import 'package:dio/dio.dart';
import '../../../services/api_client.dart';
import '../../../config/api_config.dart';
import 'models/bill_models.dart';

class BillsApiService {
  static Future<BillsSummary> fetchSummary({required int year, required int month}) async {
    final Response res = await ApiClient.dio.get(
      ApiConfig.billsSummary,
      queryParameters: {
        'year': year,
        'month': month,
      },
    );
    return BillsSummary.fromJson(res.data as Map<String, dynamic>);
  }

  static Future<MonthlyReportDetail> fetchReportDetail({
    required int year,
    required int month,
    required BillCategory category,
  }) async {
    final Response res = await ApiClient.dio.get(
      ApiConfig.billsReportDetail,
      queryParameters: {
        'year': year,
        'month': month,
        'category': billCategoryToParam(category),
      },
    );
    return MonthlyReportDetail.fromJson(res.data as Map<String, dynamic>);
  }
}


