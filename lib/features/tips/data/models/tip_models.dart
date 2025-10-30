import 'package:billow/config/api_config.dart';

class TipListResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final List<TipItem> result;

  TipListResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory TipListResponse.fromJson(Map<String, dynamic> json) {
    return TipListResponse(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      result: (json['result'] as List<dynamic>?)
              ?.map((item) => TipItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TipItem {
  final int id;
  final String title;
  final String imageUrl;
  final List<String> hashtags;

  TipItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.hashtags,
  });

  factory TipItem.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] ?? 0;
    final String rawUrl = json['imageUrl'] ?? json['image_url'] ?? json['thumbnailUrl'] ?? json['thumbnail_url'] ?? '';
    return TipItem(
      id: id,
      title: json['title'] ?? '',
      imageUrl: _normalizeImageUrl(rawUrl, seed: 'list_$id'),
      hashtags: (json['hashtags'] as List<dynamic>?)
              ?.map((tag) => tag.toString())
              .toList() ??
          [],
    );
  }
}

class TipDetailResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final TipDetail result;

  TipDetailResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory TipDetailResponse.fromJson(Map<String, dynamic> json) {
    return TipDetailResponse(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      result: TipDetail.fromJson(json['result'] as Map<String, dynamic>),
    );
  }
}

class TipDetail {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> hashtags;
  final DateTime createdAt;

  TipDetail({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.hashtags,
    required this.createdAt,
  });

  factory TipDetail.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] ?? 0;
    final String rawUrl = json['imageUrl'] ?? json['image_url'] ?? json['thumbnailUrl'] ?? json['thumbnail_url'] ?? '';
    return TipDetail(
      id: id,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: _normalizeImageUrl(rawUrl, seed: 'detail_$id'),
      hashtags: (json['hashtags'] as List<dynamic>?)
              ?.map((tag) => tag.toString())
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

// 이미지 URL 정규화: 상대경로 보정 + 특정 호스트 실패 시 대체 URL
String _normalizeImageUrl(String? url, {String? seed}) {
  String u = (url ?? '').trim();
  if (u.isEmpty) return u;

  // 상대경로면 Base URL prefix
  if (u.startsWith('/')) {
    u = '${ApiConfig.baseUrl}$u';
  }

  // 개발 환경에서 via.placeholder.com DNS 실패 시 대체
  if (u.contains('via.placeholder.com')) {
    final String s = (seed ?? 'img');
    // 고정 크기(400x250)로 대체, 시드로 항목별 고유 이미지 유지
    return 'https://picsum.photos/seed/$s/400/250';
  }

  return u;
}


