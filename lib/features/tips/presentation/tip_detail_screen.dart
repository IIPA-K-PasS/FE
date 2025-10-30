import 'package:flutter/material.dart';
import '../data/tip_api_service.dart';
import '../data/models/tip_models.dart';
import '../../bookmark/data/bookmark_api_service.dart';
import '../../user/data/user_api_service.dart';
import '../utils/tip_image_resolver.dart';
import 'package:intl/intl.dart';

class TipDetailScreen extends StatefulWidget {
  final int tipId;

  const TipDetailScreen({super.key, required this.tipId});

  @override
  State<TipDetailScreen> createState() => _TipDetailScreenState();
}

class _TipDetailScreenState extends State<TipDetailScreen> {
  bool _isBookmarked = false;
  bool _isLoadingBookmark = false;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    try {
      final bookmarks = await UserApiService.fetchBookmarks();
      setState(() {
        _isBookmarked = bookmarks.any((bookmark) => bookmark.tipId == widget.tipId);
      });
    } catch (e) {
      debugPrint('[TipDetail] Failed to check bookmark status: $e');
    }
  }

  Future<void> _toggleBookmark() async {
    if (_isLoadingBookmark) return;

    setState(() {
      _isLoadingBookmark = true;
    });

    try {
      final success = await BookmarkApiService.toggleBookmark(
        widget.tipId,
        !_isBookmarked,
      );

      if (success) {
        setState(() {
          _isBookmarked = !_isBookmarked;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isBookmarked ? '북마크에 추가했어요! 💖' : '북마크에서 제거했어요',
            ),
            backgroundColor: _isBookmarked ? Colors.teal : Colors.grey[600],
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('북마크 처리에 실패했어요 😢'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('[TipDetail] Bookmark toggle failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('북마크 처리에 실패했어요 😢'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoadingBookmark = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: FutureBuilder<TipDetail?>(
        future: TipApiService.fetchTipDetail(widget.tipId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      '꿀팁을 불러올 수 없어요 😢',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('돌아가기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final tip = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // AppBar
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                actions: [
                  // 북마크 버튼
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: IconButton(
                      onPressed: _isLoadingBookmark ? null : _toggleBookmark,
                      icon: _isLoadingBookmark
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.teal,
                              ),
                            )
                          : Icon(
                              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: _isBookmarked ? Colors.teal : Colors.grey[600],
                              size: 28,
                            ),
                      tooltip: _isBookmarked ? '북마크 제거' : '북마크 추가',
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: () {
                    final asset = TipImageResolver.assetForTitle(tip.title);
                    if (asset != null) {
                      return Image.asset(
                        asset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          // 에셋 누락 시 네트워크로 폴백
                          if (tip.imageUrl.isNotEmpty) {
                            return Image.network(
                              tip.imageUrl,
                              fit: BoxFit.cover,
                            );
                          }
                          return Container(
                            color: Colors.teal[50],
                            child: Icon(Icons.lightbulb, size: 80, color: Colors.teal[300]),
                          );
                        },
                      );
                    }
                    if (tip.imageUrl.isNotEmpty) {
                      return Image.network(
                        tip.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, err, ___) {
                          debugPrint('[TipIMG][DETAIL] load failed: ${tip.imageUrl} error=$err');
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, size: 64),
                          );
                        },
                      );
                    }
                    return Container(
                      color: Colors.teal[50],
                      child: Icon(Icons.lightbulb, size: 80, color: Colors.teal[300]),
                    );
                  }(),
                ),
              ),

              // 내용
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 태그들
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tip.hashtags
                            .map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),

                      const SizedBox(height: 20),

                      // 제목
                      Text(
                        tip.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                      ),

                      const SizedBox(height: 12),

                      // 작성일
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('yyyy.MM.dd').format(tip.createdAt),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 구분선
                      Divider(color: Colors.grey[200], thickness: 1),

                      const SizedBox(height: 24),

                      // 본문
                      Text(
                        tip.content,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black87,
                              height: 1.6,
                              fontSize: 15,
                            ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

