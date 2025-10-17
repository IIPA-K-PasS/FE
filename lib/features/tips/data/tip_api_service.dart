import 'package:flutter/foundation.dart';
import '../../../services/api_client.dart';
import '../../../config/api_config.dart';
import 'models/tip_models.dart';

class TipApiService {
  /// 전체 꿀팁 목록 조회
  static Future<List<TipItem>> fetchTips() async {
    try {
      debugPrint('[TipAPI] Fetching tips list...');
      debugPrint('[TipAPI] URL: ${ApiConfig.baseUrl}${ApiConfig.tips}');
      final response = await ApiClient.dio.get(ApiConfig.tips);
      
      debugPrint('[TipAPI] Response status: ${response.statusCode}');
      debugPrint('[TipAPI] Raw response data: ${response.data}');
      
      final data = TipListResponse.fromJson(response.data as Map<String, dynamic>);
      
      debugPrint('[TipAPI] Parsed isSuccess: ${data.isSuccess}');
      debugPrint('[TipAPI] Parsed code: ${data.code}');
      debugPrint('[TipAPI] Parsed message: ${data.message}');
      debugPrint('[TipAPI] Parsed result count: ${data.result.length}');
      
      if (!data.isSuccess) {
        debugPrint('[TipAPI] API returned isSuccess=false: ${data.message}');
        return [];
      }
      
      debugPrint('[TipAPI] ✅ Successfully fetched ${data.result.length} tips');
      if (data.result.isNotEmpty) {
        debugPrint('[TipAPI] First tip: ${data.result[0].title}');
      }
      return data.result;
    } catch (e, stackTrace) {
      debugPrint('[TipAPI][ERROR] fetchTips failed: $e');
      debugPrint('[TipAPI][ERROR] StackTrace: $stackTrace');
      rethrow;
    }
  }

  /// 특정 꿀팁 상세 조회
  static Future<TipDetail?> fetchTipDetail(int tipId) async {
    try {
      debugPrint('[TipAPI] Fetching tip detail: $tipId');
      final response = await ApiClient.dio.get(ApiConfig.tipDetail(tipId));
      
      debugPrint('[TipAPI] Detail response status: ${response.statusCode}');
      final data = TipDetailResponse.fromJson(response.data as Map<String, dynamic>);
      
      if (!data.isSuccess) {
        debugPrint('[TipAPI] API returned isSuccess=false: ${data.message}');
        return null;
      }
      
      debugPrint('[TipAPI] Fetched tip detail: ${data.result.title}');
      return data.result;
    } catch (e) {
      debugPrint('[TipAPI][ERROR] fetchTipDetail failed: $e');
      return null;
    }
  }
}

