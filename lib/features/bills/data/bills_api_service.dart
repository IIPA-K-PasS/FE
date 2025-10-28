import 'package:dio/dio.dart';
import '../../../services/api_client.dart';
import '../../../config/api_config.dart';
import 'models/bill_models.dart';

class BillsApiService {
  static Future<BillsSummary> fetchSummary({required int year, required int month}) async {
    // TODO: 실제 API 연동 시 주석 해제
    // final Response res = await ApiClient.dio.get(
    //   ApiConfig.billsSummary,
    //   queryParameters: {
    //     'year': year,
    //     'month': month,
    //   },
    // );
    // return BillsSummary.fromJson(res.data as Map<String, dynamic>);
    
    // 하드코딩된 더미 데이터 (테스트용)
    await Future.delayed(const Duration(milliseconds: 500)); // 로딩 시뮬레이션
    return BillsSummary(
      year: year,
      month: month,
      totalAmount: 54800, // 전기 23500 + 수도 12800 + 가스 18200
      difference: -3500,
    );
  }

  static Future<MonthlyReportDetail> fetchReportDetail({
    required int year,
    required int month,
    required BillCategory category,
  }) async {
    // TODO: 실제 API 연동 시 주석 해제
    // final Response res = await ApiClient.dio.get(
    //   ApiConfig.billsReportDetail,
    //   queryParameters: {
    //     'year': year,
    //     'month': month,
    //     'category': billCategoryToParam(category),
    //   },
    // );
    // return MonthlyReportDetail.fromJson(res.data as Map<String, dynamic>);
    
    // 하드코딩된 더미 데이터 (테스트용)
    await Future.delayed(const Duration(milliseconds: 800)); // 로딩 시뮬레이션
    
    switch (category) {
      case BillCategory.electricity:
        return MonthlyReportDetail(
          category: category,
          year: year,
          month: month,
          currentMonthFee: 23500,
          previousMonthFee: 22000,
          additionalInfo: {
            'stageText': '현재 1단계 사용 중이에요. 다음 단계까지 여유 있어요!',
            'stageProgress': 0.35,
          },
          monthlyTrend: [
            MonthlyTrendPoint(month: 1, fee: 32000),
            MonthlyTrendPoint(month: 2, fee: 28000),
            MonthlyTrendPoint(month: 3, fee: 25000),
            MonthlyTrendPoint(month: 4, fee: 26000),
            MonthlyTrendPoint(month: 5, fee: 22000),
            MonthlyTrendPoint(month: 6, fee: 23500),
          ],
        );
        
      case BillCategory.water:
        return MonthlyReportDetail(
          category: category,
          year: year,
          month: month,
          currentMonthFee: 12800,
          previousMonthFee: 14800,
          additionalInfo: {
            'tip1': '지난달보다 2,000원이나 아끼셨네요! 이건 샤워 시간을 5분 줄인 것과 같은 효과예요. 정말 대단해요!',
            'tip2': '설거지할 때 물을 계속 틀어놓지 않고 설거지통을 사용하면 월 최대 3,000원까지 추가로 아낄 수 있어요.',
          },
          monthlyTrend: [
            MonthlyTrendPoint(month: 1, fee: 15000),
            MonthlyTrendPoint(month: 2, fee: 14000),
            MonthlyTrendPoint(month: 3, fee: 13000),
            MonthlyTrendPoint(month: 4, fee: 14500),
            MonthlyTrendPoint(month: 5, fee: 14800),
            MonthlyTrendPoint(month: 6, fee: 12800),
          ],
        );
        
      case BillCategory.gas:
        return MonthlyReportDetail(
          category: category,
          year: year,
          month: month,
          currentMonthFee: 18200,
          previousMonthFee: 20000,
          additionalInfo: {
            'nextInspection': '3개월 후',
            'lastInspection': '2025년 5월 15일',
          },
          monthlyTrend: [
            MonthlyTrendPoint(month: 1, fee: 30000),
            MonthlyTrendPoint(month: 2, fee: 25000),
            MonthlyTrendPoint(month: 3, fee: 22000),
            MonthlyTrendPoint(month: 4, fee: 21000),
            MonthlyTrendPoint(month: 5, fee: 20000),
            MonthlyTrendPoint(month: 6, fee: 18200),
          ],
        );
    }
  }
}


