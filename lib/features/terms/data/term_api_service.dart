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
        title: '이용약관',
        content: '''제1조 (목적)
이 약관은 빌로우(Billow) 서비스(이하 "서비스")의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

제2조 (정의)
1. "서비스"란 빌로우가 제공하는 공과금 관리, 에코 챌린지, 생활 꿀팁 등의 서비스를 의미합니다.
2. "이용자"란 서비스에 접속하여 이 약관에 따라 서비스를 이용하는 회원을 의미합니다.

제3조 (약관의 효력 및 변경)
1. 이 약관은 서비스 화면에 게시하거나 기타의 방법으로 이용자에게 공지함으로써 효력을 발생합니다.
2. 회사는 필요하다고 인정되는 경우 이 약관을 변경할 수 있으며, 변경된 약관은 서비스 화면에 공지함으로써 효력을 발생합니다.

제4조 (서비스의 제공)
1. 회사는 다음과 같은 서비스를 제공합니다:
   - 공과금 OCR 분석 및 리포트
   - 에코 챌린지 및 포인트 적립
   - 생활 꿀팁 및 정보 제공
   - 그린마켓 포인트 교환

제5조 (이용자의 의무)
1. 이용자는 다음 행위를 하여서는 안 됩니다:
   - 타인의 정보 도용
   - 서비스의 안정적 운영을 방해하는 행위
   - 불법적인 목적으로 서비스를 이용하는 행위''',
        agreed: dummyStates[1] ?? true,
        contentUrl: null,
      ),
      Term(
        termId: 2,
        title: '개인정보처리방침',
        content: '''제1조 (개인정보의 처리목적)
빌로우는 다음의 목적을 위하여 개인정보를 처리합니다:
1. 회원가입 및 관리
2. 서비스 제공 및 개선
3. 고객 상담 및 불만 처리

제2조 (처리하는 개인정보의 항목)
빌로우는 다음의 개인정보 항목을 처리하고 있습니다:
1. 필수항목: 이메일, 닉네임
2. 선택항목: 프로필 이미지, 위치 정보

제3조 (개인정보의 처리 및 보유기간)
1. 회사는 정보주체로부터 개인정보를 수집할 때 동의받은 개인정보 보유·이용기간 또는 법령에 따른 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.

제4조 (개인정보의 제3자 제공)
회사는 정보주체의 개인정보를 제1조(개인정보의 처리목적)에서 명시한 범위 내에서만 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 개인정보 보호법 제17조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.

제5조 (개인정보처리 위탁)
회사는 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 위탁하고 있습니다:
- 카카오: 소셜 로그인 서비스
- 네이버: OCR 서비스''',
        agreed: dummyStates[2] ?? true,
        contentUrl: null,
      ),
      Term(
        termId: 3,
        title: '마케팅 정보 수신 동의',
        content: '''빌로우는 다음과 같은 마케팅 정보를 제공할 수 있습니다:

1. 서비스 관련 정보
- 새로운 기능 출시 안내
- 서비스 업데이트 소식
- 이벤트 및 프로모션 정보

2. 맞춤형 추천 정보
- 개인화된 에코 챌린지 추천
- 맞춤형 생활 꿀팁 제공
- 포인트 적립 기회 안내

3. 수신 방법
- 앱 내 푸시 알림
- 이메일
- SMS

※ 마케팅 정보 수신 동의는 선택사항이며, 동의하지 않아도 서비스 이용이 가능합니다.
※ 언제든지 마이페이지에서 수신 동의를 철회할 수 있습니다.''',
        agreed: dummyStates[3] ?? false,
        contentUrl: null,
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

