import 'package:flutter/material.dart';
import '../data/tip_api_service.dart';
import '../data/models/tip_models.dart';
import 'tip_detail_screen.dart';
import '../utils/tip_image_resolver.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<TipItem> _allTips = [];
  bool _loading = true;
  String? _error;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadTips();
  }

  Future<void> _loadTips() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final tips = await TipApiService.fetchTips();
      if (mounted) {
        setState(() {
          _allTips = tips;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '꿀팁을 불러오는데 실패했어요 😢';
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<TipItem> visibleTips = _allTips
        .where((t) => t.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadTips,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: _TipsHeader(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _SearchField(
                    controller: _searchController,
                    hintText: '궁금한 팁을 검색해보세요',
                    onChanged: (String value) => setState(() => _query = value),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              
              // 로딩 상태
              if (_loading)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: CircularProgressIndicator(color: Colors.teal),
                    ),
                  ),
                )
              // 에러 상태
              else if (_error != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(_error!, style: TextStyle(color: Colors.grey[600])),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadTips,
                          child: Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                )
              // 빈 상태
              else if (visibleTips.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          _query.isEmpty ? '아직 꿀팁이 없어요' : '검색 결과가 없어요',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              // 목록 표시
              else
                SliverList.separated(
                  itemBuilder: (BuildContext context, int index) {
                    final TipItem tip = visibleTips[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _TipCardAPI(
                        tip: tip,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TipDetailScreen(tipId: tip.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: visibleTips.length,
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '슬기로운 자취 생활',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '사회초년생을 위한 필수 꿀팁 모음',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const _SearchField({
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '검색창',
      textField: true,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Row(
              children: <Widget>[
                Icon(Icons.search, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// API 데이터용 카드
class _TipCardAPI extends StatelessWidget {
  final TipItem tip;
  final VoidCallback? onTap;

  const _TipCardAPI({required this.tip, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tip.title,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // 이미지 표시 (에셋 우선 -> 서버 데이터)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: () {
                          final asset = TipImageResolver.assetForTitle(tip.title);
                          if (asset != null) {
                            return Image.asset(
                              asset,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                // 에셋 누락 시 네트워크로 폴백
                                if (tip.imageUrl.isNotEmpty) {
                                  return Image.network(
                                    tip.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  );
                                }
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                                );
                              },
                            );
                          }
                          if (tip.imageUrl.isNotEmpty) {
                            return Image.network(
                              tip.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, err, ___) {
                                debugPrint('[TipIMG][LIST] load failed: ${tip.imageUrl} error=$err');
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                                );
                              },
                            );
                          }
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.teal[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.lightbulb, color: Colors.teal[600]),
                          );
                        }(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: tip.hashtags
                                  .map((String tag) => _TagChip(text: tag))
                                  .toList(),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tip.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TipLeading extends StatelessWidget {
  final _TipItem tip;
  const _TipLeading({required this.tip});

  @override
  Widget build(BuildContext context) {
    final Widget container = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: tip.leadingEmoji != null
          ? Text(
              tip.leadingEmoji!,
              style: const TextStyle(fontSize: 22),
            )
          : Icon(
              tip.leadingIcon ?? Icons.lightbulb,
              color: tip.leadingIconColor ?? Colors.teal,
              size: 22,
            ),
    );
    return container;
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  const _TagChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // light green-ish
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '#$text',
        style: TextStyle(
          color: Colors.green[700],
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TipItem {
  final String title;
  final List<String> tags;
  final String? leadingEmoji;
  final IconData? leadingIcon;
  final Color? leadingIconColor;

  const _TipItem({
    required this.title,
    required this.tags,
    this.leadingEmoji,
    this.leadingIcon,
    this.leadingIconColor,
  });
}
