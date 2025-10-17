import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class TokenStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _accessKey = 'access_token';
  static const String _refreshKey = 'refresh_token';

  static Future<void> saveTokens({required String access, required String refresh}) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  static Future<String?> getAccessToken() => _storage.read(key: _accessKey);
  static Future<String?> getRefreshToken() => _storage.read(key: _refreshKey);
  
  /// 디버그용: Bearer Token 출력 (Swagger 테스트용)
  static Future<void> printAccessTokenForSwagger() async {
    final token = await getAccessToken();
    if (token != null) {
      debugPrint('═══════════════════════════════════════════════════════');
      debugPrint('🔑 [Bearer Token for Swagger]');
      debugPrint('Bearer $token');
      debugPrint('═══════════════════════════════════════════════════════');
    } else {
      debugPrint('⚠️ No access token found');
    }
  }

  static Future<void> saveAccessToken(String access) => _storage.write(key: _accessKey, value: access);

  static Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }

  static Future<bool> hasTokens() async {
    final access = await getAccessToken();
    final refresh = await getRefreshToken();
    return (access != null && access.isNotEmpty) && (refresh != null && refresh.isNotEmpty);
  }
}


