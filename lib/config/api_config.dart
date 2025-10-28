import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // 환경변수에서 API Base URL 가져오기
  static String get baseUrl {
    final value = dotenv.env['API_BASE_URL'];
    if (value == null || value.isEmpty) {
      throw StateError('Missing API_BASE_URL in .env');
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


