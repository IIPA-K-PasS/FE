import '../domain/bill_entity.dart';

// API 응답 JSON을 Dart 객체로 변환하기 위한 모델입니다.
class BillResponseModel extends BillEntity {
  BillResponseModel({
    required super.billType,
    required super.amount,
    required super.usagePeriod,
    required super.rawText
  });

  factory BillResponseModel.fromJson(Map<String, dynamic> json) {
    return BillResponseModel(
      billType: json['billType'],
      amount: json['amount'],
      usagePeriod: json['usagePeriod'],
      rawText: json['rawText']
    );
  }

  // API 모델을 Domain Entity로 변환하는 메서드 (필요 시 사용)
  BillEntity toEntity() {
    return BillEntity(
      billType: billType,
      amount: amount,
      usagePeriod: usagePeriod,
      rawText: rawText
    );
  }
}
