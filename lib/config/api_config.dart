import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. dotenv import 확인

class ApiConfig {
  static String get baseUrl {
    // 2. --dart-define 값을 먼저 확인
    String value = const String.fromEnvironment('API_BASE_URL');
    if (value.isEmpty) {
      // 3. 값이 없으면(로컬 디버깅 시) .env 파일에서 로드
      value = dotenv.env['API_BASE_URL'] ?? '';
    }

    if (value.isEmpty) {
      throw StateError(
          'Missing API_BASE_URL in .env or via --dart-define');
    }
    return value;
  }

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  // -------- Auth/User --------
  static const String kakaoLogin = '/auth/kakao';
  static const String user = '/user';
  static const String userInfo = '/user'; // alias (기존 사용처 호환)
  static const String userProfile = '/user/profile';
  static const String userBookmarks = '/user/bookmarks';
  static const String userChallenges = '/user/challenges';

  // -------- Tips --------
  static const String tips = '/tip';
  static String tipDetail(int tipId) => '/tip/$tipId';

  // -------- Terms --------
  static const String terms = '/term';

  // -------- Bookmark --------
  static const String bookmark = '/bookmark';

  // -------- Bills --------
  static const String billsSummary = '/api/bills/summary';
  static const String billsReportDetail = '/api/bills/report/detail';
}

