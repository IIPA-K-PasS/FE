import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // 환경변수에서 API Base URL 가져오기 (하이브리드 방식)
  static String get baseUrl {
    // 1. --dart-define에서 먼저 읽기
    String value = const String.fromEnvironment('API_BASE_URL');
    // 2. --dart-define 값이 비어있으면(로컬 실행 시) .env 파일에서 읽기
    if (value.isEmpty) {
      value = dotenv.env['API_BASE_URL'] ?? '';
    }
    // 3. 둘 다 값이 없으면 오류 발생
    if (value.isEmpty) {
      throw StateError('Missing API_BASE_URL in .env or via --dart-define');
    }
    return value;
  }

  // Auth
  static const String kakaoLogin = '/auth/kakao';
  static const String userInfo = '/auth/user-info';

  // Tips
  static const String tips = '/tip';
  static String tipDetail(int id) => '/tip/$id';

  // User
  static const String user = '/user';
  static const String userProfile = '/user/profile';
  static const String userBookmarks = '/user/bookmarks';
  static const String userChallenges = '/user/challenges';

  // Terms
  static const String terms = '/term';

  // Bookmark
  static const String bookmark = '/bookmark';

  // Bills
  static const String billsOcr = '/api/bills/ocr';
  static const String billsSummary = '/api/bills/summary';
  static const String billsReportDetail = '/api/bills/report/detail';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

