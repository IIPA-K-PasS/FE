import 'package:json_annotation/json_annotation.dart';

part 'term_models.g.dart';

// ==================== GET /term ====================

@JsonSerializable()
class TermsResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final TermsResult result;

  TermsResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory TermsResponse.fromJson(Map<String, dynamic> json) =>
      _$TermsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TermsResponseToJson(this);
}

@JsonSerializable()
class TermsResult {
  final List<Term> terms;

  TermsResult({required this.terms});

  factory TermsResult.fromJson(Map<String, dynamic> json) =>
      _$TermsResultFromJson(json);
  Map<String, dynamic> toJson() => _$TermsResultToJson(this);
}

@JsonSerializable()
class Term {
  final int termId;
  final String title;
  final String content;
  final bool agreed;

  Term({
    required this.termId,
    required this.title,
    required this.content,
    required this.agreed,
  });

  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);
  Map<String, dynamic> toJson() => _$TermToJson(this);
  
  // 헬퍼: 필수 약관 여부 판단 (title 기반)
  bool get isRequired {
    final lowerTitle = title.toLowerCase();
    return lowerTitle.contains('이용약관') || 
           lowerTitle.contains('개인정보') ||
           lowerTitle.contains('필수');
  }
  
  // copyWith 헬퍼
  Term copyWith({bool? agreed}) {
    return Term(
      termId: termId,
      title: title,
      content: content,
      agreed: agreed ?? this.agreed,
    );
  }
}

// ==================== POST /term ====================

@JsonSerializable()
class AgreeTermsRequest {
  final List<TermAgreement> terms;

  AgreeTermsRequest({required this.terms});

  factory AgreeTermsRequest.fromJson(Map<String, dynamic> json) =>
      _$AgreeTermsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AgreeTermsRequestToJson(this);
}

@JsonSerializable()
class TermAgreement {
  final int termId;
  final bool agreed;

  TermAgreement({required this.termId, required this.agreed});

  factory TermAgreement.fromJson(Map<String, dynamic> json) =>
      _$TermAgreementFromJson(json);
  Map<String, dynamic> toJson() => _$TermAgreementToJson(this);
}

@JsonSerializable()
class AgreeTermsResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final AgreeTermsResult result;

  AgreeTermsResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory AgreeTermsResponse.fromJson(Map<String, dynamic> json) =>
      _$AgreeTermsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AgreeTermsResponseToJson(this);
}

@JsonSerializable()
class AgreeTermsResult {
  final int userId;
  final List<TermAgreement> terms;

  AgreeTermsResult({required this.userId, required this.terms});

  factory AgreeTermsResult.fromJson(Map<String, dynamic> json) =>
      _$AgreeTermsResultFromJson(json);
  Map<String, dynamic> toJson() => _$AgreeTermsResultToJson(this);
}

