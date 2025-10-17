import 'package:flutter/material.dart';
import '../../user/data/user_api_service.dart';
import '../../user/data/models/user_models.dart';
import '../../tips/presentation/tip_detail_screen.dart';

class BookmarkedTipsScreen extends StatefulWidget {
  const BookmarkedTipsScreen({super.key});

  @override
  State<BookmarkedTipsScreen> createState() => _BookmarkedTipsScreenState();
}

class _BookmarkedTipsScreenState extends State<BookmarkedTipsScreen> {
  List<BookmarkedTip> _bookmarks = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final bookmarks = await UserApiService.fetchBookmarks();
      if (mounted) {
        setState(() {
          _bookmarks = bookmarks;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '찜한 꿀팁을 불러오는데 실패했어요';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('내가 찜한 꿀팁'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadBookmarks,
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.teal),
              )
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadBookmarks,
                          icon: const Icon(Icons.refresh),
                          label: const Text('다시 시도'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : _bookmarks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bookmark_border,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              '아직 찜한 꿀팁이 없어요',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '마음에 드는 꿀팁을 찜해보세요!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: _bookmarks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final tip = _bookmarks[index];
                          return _BookmarkCard(
                            tip: tip,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TipDetailScreen(tipId: tip.tipId),
                                ),
                              );
                            },
                          );
                        },
                      ),
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final BookmarkedTip tip;
  final VoidCallback onTap;

  const _BookmarkCard({required this.tip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              // 북마크 아이콘
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bookmark,
                  color: Colors.orange[600],
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // 제목 및 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tip.content,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // 화살표 아이콘
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

