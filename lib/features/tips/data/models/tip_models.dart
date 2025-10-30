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
    return TipItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? json['thumbnailUrl'] ?? json['thumbnail_url'] ?? '',
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
    return TipDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? json['thumbnailUrl'] ?? json['thumbnail_url'] ?? '',
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

