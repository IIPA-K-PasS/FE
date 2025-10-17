import 'package:flutter/material.dart';
import '../data/tip_api_service.dart';
import '../data/models/tip_models.dart';
import 'package:intl/intl.dart';

class TipDetailScreen extends StatelessWidget {
  final int tipId;

  const TipDetailScreen({super.key, required this.tipId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: FutureBuilder<TipDetail?>(
        future: TipApiService.fetchTipDetail(tipId),
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
                flexibleSpace: FlexibleSpaceBar(
                  background: tip.imageUrl.isNotEmpty
                      ? Image.network(
                          tip.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, size: 64),
                          ),
                        )
                      : Container(
                          color: Colors.teal[50],
                          child: Icon(Icons.lightbulb, size: 80, color: Colors.teal[300]),
                        ),
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

