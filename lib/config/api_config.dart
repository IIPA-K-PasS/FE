import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // 환경변수에서 API Base URL 가져오기
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://billow.210-178-1-132.nip.io';

  // Auth
  static const String kakaoLogin = '/auth/kakao';
  static const String userInfo = '/auth/user-info';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}


