import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    String value = const String.fromEnvironment('API_BASE_URL');
    if (value.isEmpty) {
      try {
        value = dotenv.env['API_BASE_URL'] ?? '';
      } catch (_) {}
    }
    if (value.isEmpty) {
      throw StateError('Missing API_BASE_URL (use --dart-define or .env)');
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


