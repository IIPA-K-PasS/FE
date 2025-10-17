import 'package:flutter/foundation.dart';
import '../../../services/api_client.dart';
import '../../../config/api_config.dart';
import 'models/term_models.dart';

class TermApiService {
  /// GET /term - 전체 약관 목록과 사용자의 동의 여부 조회
  static Future<List<Term>> fetchTerms() async {
    try {
      debugPrint('[TermAPI] Fetching terms...');
      final response = await ApiClient.dio.get(ApiConfig.terms);

      debugPrint('[TermAPI] Response status: ${response.statusCode}');
      debugPrint('[TermAPI] Raw response data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final termsResponse =
            TermsResponse.fromJson(response.data as Map<String, dynamic>);

        debugPrint('[TermAPI] Parsed isSuccess: ${termsResponse.isSuccess}');
        debugPrint('[TermAPI] Parsed code: ${termsResponse.code}');

        if (termsResponse.isSuccess) {
          debugPrint('[TermAPI] ✅ Fetched ${termsResponse.result.terms.length} terms');
          for (var term in termsResponse.result.terms) {
            debugPrint('[TermAPI]   - ${term.title}: agreed=${term.agreed}, required=${term.isRequired}');
          }
          return termsResponse.result.terms;
        } else {
          debugPrint('[TermAPI] API returned isSuccess=false: ${termsResponse.message}');
          return [];
        }
      } else {
        debugPrint('[TermAPI] Failed: ${response.statusCode}');
        return [];
      }
    } catch (e, stackTrace) {
      debugPrint('[TermAPI][ERROR] fetchTerms failed: $e');
      debugPrint('[TermAPI][ERROR] StackTrace: $stackTrace');
      return [];
    }
  }

  /// POST /term - 약관 동의 처리
  static Future<bool> agreeToTerms(List<TermAgreement> agreements) async {
    try {
      debugPrint('[TermAPI] Agreeing to terms...');
      for (var agreement in agreements) {
        debugPrint('[TermAPI]   - termId: ${agreement.termId}, agreed: ${agreement.agreed}');
      }

      final request = AgreeTermsRequest(terms: agreements);
      final response = await ApiClient.dio.post(
        ApiConfig.terms,
        data: request.toJson(),
      );

      debugPrint('[TermAPI] Response status: ${response.statusCode}');
      debugPrint('[TermAPI] Raw response data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final agreeResponse =
            AgreeTermsResponse.fromJson(response.data as Map<String, dynamic>);

        if (agreeResponse.isSuccess) {
          debugPrint('[TermAPI] ✅ Terms agreement successful for user: ${agreeResponse.result.userId}');
          return true;
        } else {
          debugPrint('[TermAPI] API returned isSuccess=false: ${agreeResponse.message}');
          return false;
        }
      } else {
        debugPrint('[TermAPI] Failed: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('[TermAPI][ERROR] agreeToTerms failed: $e');
      debugPrint('[TermAPI][ERROR] StackTrace: $stackTrace');
      return false;
    }
  }

  /// 약관 동의 여부 확인 (신규 회원 판단용)
  static Future<bool> hasAgreedToRequiredTerms() async {
    try {
      final terms = await fetchTerms();
      
      // 필수 약관만 필터링
      final requiredTerms = terms.where((t) => t.isRequired).toList();
      
      if (requiredTerms.isEmpty) {
        debugPrint('[TermAPI] ⚠️ No required terms found');
        return false;
      }
      
      // 모든 필수 약관에 동의했는지 확인
      final allAgreed = requiredTerms.every((t) => t.agreed);
      
      debugPrint('[TermAPI] Required terms agreed: $allAgreed');
      return allAgreed;
    } catch (e) {
      debugPrint('[TermAPI][ERROR] hasAgreedToRequiredTerms failed: $e');
      return false;
    }
  }
}

