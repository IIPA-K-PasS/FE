import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_client.dart';
import '../../../config/api_config.dart';
import 'models/term_models.dart';

class TermApiService {
  // 더미 데이터 상태 관리 (SharedPreferences로 영구 저장)
  static const String _prefsKeyPrefix = 'dummy_term_state_';
  // 마지막 동의 상태 캐시 (백엔드 실패 시 사용)
  static const String _cacheKeyPrefix = 'term_state_cache_';
  
  /// 더미 데이터 상태를 SharedPreferences에서 로드
  static Future<Map<int, bool>> _loadDummyTermStates() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      1: prefs.getBool('${_prefsKeyPrefix}1') ?? true,  // 이용약관
      2: prefs.getBool('${_prefsKeyPrefix}2') ?? true,  // 개인정보처리방침  
      3: prefs.getBool('${_prefsKeyPrefix}3') ?? false, // 마케팅 정보 수신 동의
    };
  }
  
  /// 더미 데이터 상태를 SharedPreferences에 저장
  static Future<void> _saveDummyTermState(int termId, bool agreed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_prefsKeyPrefix}$termId', agreed);
    debugPrint('[TermAPI] Saved dummy state to SharedPreferences: termId=$termId, agreed=$agreed');
  }
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
          
          // 백엔드에서 약관 데이터가 없을 때 더미 데이터 반환
          if (termsResponse.result.terms.isEmpty) {
            debugPrint('[TermAPI] ⚠️ No terms from backend, returning dummy data for testing');
            return await _getDummyTerms();
          }
          
          for (var term in termsResponse.result.terms) {
            debugPrint('[TermAPI]   - ${term.title}: agreed=${term.agreed}, required=${term.isRequired}');
            await _saveCachedTermState(term.termId, term.agreed);
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
      final cached = await _loadCachedTerms();
      if (cached.isNotEmpty) {
        debugPrint('[TermAPI] Using cached term states due to error');
        return cached;
      }
      return [];
    }
  }

  /// 백엔드에서 약관 데이터가 없을 때 사용할 더미 데이터
  static Future<List<Term>> _getDummyTerms() async {
    final dummyStates = await _loadDummyTermStates();
    return [
      Term(
        termId: 1,
        title: '서비스 이용약관',
        content: '''\
제1조 (목적)
본 약관은 **Billow(이하 "회사")**가 제공하는 **Billow 모바일 애플리케이션 및 관련 제반 서비스(이하 "서비스")**의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.

제2조 (용어의 정의)
**“서비스”**라 함은 회사가 제공하는 공과금 관리, 챌린지, 정보 콘텐츠, 포인트 교환 등 Billow 애플리케이션을 통해 이용 가능한 모든 서비스를 의미합니다.
**“회원”**이라 함은 본 약관에 따라 회사와 이용계약을 체결하고 회사가 제공하는 서비스를 이용하는 고객을 말합니다.
**“그린 포인트” 또는 “포인트”**라 함은 회원이 특정 과제(챌린지 등)를 수행하는 등 회사가 정한 요건을 충족하였을 때 지급되는 서비스 상의 가상 화폐를 의미합니다.
**“그린 마켓”**이라 함은 회원이 적립한 포인트를 지역화폐, 기프티콘 등 회사가 제공하는 상품으로 교환할 수 있는 서비스 내 공간을 의미합니다.
**“게시물”**이라 함은 회원이 서비스 상에 게시한 부호·문자·음성·음향·화상·동영상 등의 정보 형태의 글, 사진, 동영상 및 각종 파일과 링크 등을 의미합니다. (예: 챌린지 인증 사진)

제3조 (약관의 명시와 개정)
...후략... (실제 전체 약관 전문 입력)
''',
        agreed: dummyStates[1] ?? true,
        contentUrl: 'https://github.com/IIPA-K-PasS/Docs/wiki/Billow-%EC%84%9C%EB%B9%84%EC%8A%A4-%EC%9D%B4%EC%9A%A9%EC%95%BD%EA%B4%80',
      ),
      Term(
        termId: 2,
        title: '개인정보 처리방침',
        content: '''\
제1조 (개인정보의 처리목적)
Billow는 다음의 목적을 위하여 개인정보를 처리합니다:\n1. 회원가입 및 관리\n2. 서비스 제공 및 개선\n3. 고객 상담 및 불만 처리\n\n제2조 (처리하는 개인정보의 항목)
...후략...
''',
        agreed: dummyStates[2] ?? true,
        contentUrl: 'https://github.com/IIPA-K-PasS/Docs/wiki/Billow-%EA%B0%9C%EC%9D%B8%EC%A0%95%EB%B3%B4-%EC%B2%98%EB%A6%AC%EB%B0%A9%EC%B9%A8',
      ),
      Term(
        termId: 3,
        title: '위치기반서비스 이용약관',
        content: '''\
제1조 (목적)
이 약관은 Billow가 위치기반 정보제공 서비스를 제공함에 있어 사용자 권리와 의무를 규정함을 목적으로 합니다.
(이하 생략...)
''',
        agreed: dummyStates[3] ?? false,
        contentUrl: 'https://github.com/IIPA-K-PasS/Docs/wiki/Billow-%EC%9C%84%EC%B9%98%EA%B8%B0%EB%B0%98%EC%84%9C%EB%B9%84%EC%8A%A4-%EC%9D%B4%EC%9A%A9%EC%95%BD%EA%B4%80',
      ),
    ];
  }

  /// POST /term - 약관 동의 처리
  static Future<bool> agreeToTerms(List<TermAgreement> agreements) async {
    try {
      debugPrint('[TermAPI] Agreeing to terms...');
      for (var agreement in agreements) {
        debugPrint('[TermAPI]   - termId: ${agreement.termId}, agreed: ${agreement.agreed}');
      }

      final request = AgreeTermsRequest(terms: agreements);
      debugPrint('[TermAPI] Request data: ${request.toJson()}');

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
          for (final a in agreements) {
            await _saveCachedTermState(a.termId, a.agreed);
          }
          return true;
        } else {
          debugPrint('[TermAPI] API returned isSuccess=false: ${agreeResponse.message}');
          for (final a in agreements) {
            await _saveCachedTermState(a.termId, a.agreed);
            if (a.termId >= 1 && a.termId <= 3) {
              await _saveDummyTermState(a.termId, a.agreed);
            }
          }
          return false;
        }
      } else {
        debugPrint('[TermAPI] Failed: ${response.statusCode}');
        for (final a in agreements) {
          await _saveCachedTermState(a.termId, a.agreed);
        }
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('[TermAPI][ERROR] agreeToTerms failed: $e');
      debugPrint('[TermAPI][ERROR] StackTrace: $stackTrace');
      
      // DioException인 경우 더 자세한 정보 출력
      if (e.toString().contains('DioException')) {
        debugPrint('[TermAPI][ERROR] DioException details: $e');
        if (e.toString().contains('400')) {
          debugPrint('[TermAPI][ERROR] 400 Bad Request - 요청 데이터를 확인해주세요');
          debugPrint('[TermAPI][ERROR] 가능한 원인:');
          debugPrint('[TermAPI][ERROR] 1. 잘못된 termId');
          debugPrint('[TermAPI][ERROR] 2. 필수 약관 미동의');
          debugPrint('[TermAPI][ERROR] 3. 요청 형식 오류');
        }
      }
      
      for (final a in agreements) {
        await _saveCachedTermState(a.termId, a.agreed);
        if (a.termId >= 1 && a.termId <= 3) {
          await _saveDummyTermState(a.termId, a.agreed);
        }
      }
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
        return true;
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

  // ===== Local cache for last-known term states =====
  static Future<void> _saveCachedTermState(int termId, bool agreed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_cacheKeyPrefix$termId', agreed);
  }

  static Future<List<Term>> _loadCachedTerms() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Term> cached = [];
    for (final id in [1, 2, 3]) {
      final v = prefs.getBool('$_cacheKeyPrefix$id');
      if (v != null) {
        cached.add(Term(
          termId: id,
          title: id == 1 ? '이용약관' : id == 2 ? '개인정보처리방침' : '마케팅 정보 수신 동의',
          content: '',
          agreed: v,
          contentUrl: null,
        ));
      }
    }
    return cached;
  }
}

