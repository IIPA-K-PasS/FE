import 'package:flutter/material.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<_TipItem> _allTips = <_TipItem>[
    _TipItem(
      leadingEmoji: '🤔',
      title: '음식물 쓰레기, 일반 봉투에 버려도 되나요?',
      tags: <String>['분리수거'],
    ),
    _TipItem(
      leadingIcon: Icons.bolt,
      leadingIconColor: Colors.orange,
      title: '에어컨, 껐다 켰다 vs 계속 켜기, 뭐가 더 절약될까요?',
      tags: <String>['전기요금', '생활꿀팁'],
    ),
  ];

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<_TipItem> visibleTips = _allTips
        .where((t) => t.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
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
                  hintText: '궁금한 집을 검색해보세요',
                  onChanged: (String value) => setState(() => _query = value),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverList.separated(
              itemBuilder: (BuildContext context, int index) {
                final _TipItem tip = visibleTips[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _TipCard(
                    tip: tip,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('선택: ${tip.title}'),
                          behavior: SnackBarBehavior.floating,
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

class _TipCard extends StatelessWidget {
  final _TipItem tip;
  final VoidCallback? onTap;

  const _TipCard({required this.tip, this.onTap});

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
                      _TipLeading(tip: tip),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: tip.tags
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
