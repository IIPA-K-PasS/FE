// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermsResponse _$TermsResponseFromJson(Map<String, dynamic> json) =>
    TermsResponse(
      isSuccess: json['isSuccess'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
      result: TermsResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TermsResponseToJson(TermsResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'code': instance.code,
      'message': instance.message,
      'result': instance.result,
    };

TermsResult _$TermsResultFromJson(Map<String, dynamic> json) => TermsResult(
      terms: (json['terms'] as List<dynamic>)
          .map((e) => Term.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TermsResultToJson(TermsResult instance) =>
    <String, dynamic>{
      'terms': instance.terms,
    };

Term _$TermFromJson(Map<String, dynamic> json) => Term(
      termId: (json['termId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      agreed: json['agreed'] as bool,
    );

Map<String, dynamic> _$TermToJson(Term instance) => <String, dynamic>{
      'termId': instance.termId,
      'title': instance.title,
      'content': instance.content,
      'agreed': instance.agreed,
    };

AgreeTermsRequest _$AgreeTermsRequestFromJson(Map<String, dynamic> json) =>
    AgreeTermsRequest(
      terms: (json['terms'] as List<dynamic>)
          .map((e) => TermAgreement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgreeTermsRequestToJson(AgreeTermsRequest instance) =>
    <String, dynamic>{
      'terms': instance.terms,
    };

TermAgreement _$TermAgreementFromJson(Map<String, dynamic> json) =>
    TermAgreement(
      termId: (json['termId'] as num).toInt(),
      agreed: json['agreed'] as bool,
    );

Map<String, dynamic> _$TermAgreementToJson(TermAgreement instance) =>
    <String, dynamic>{
      'termId': instance.termId,
      'agreed': instance.agreed,
    };

AgreeTermsResponse _$AgreeTermsResponseFromJson(Map<String, dynamic> json) =>
    AgreeTermsResponse(
      isSuccess: json['isSuccess'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
      result: AgreeTermsResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AgreeTermsResponseToJson(AgreeTermsResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'code': instance.code,
      'message': instance.message,
      'result': instance.result,
    };

AgreeTermsResult _$AgreeTermsResultFromJson(Map<String, dynamic> json) =>
    AgreeTermsResult(
      userId: (json['userId'] as num).toInt(),
      terms: (json['terms'] as List<dynamic>)
          .map((e) => TermAgreement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgreeTermsResultToJson(AgreeTermsResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'terms': instance.terms,
    };
