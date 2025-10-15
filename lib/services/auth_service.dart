import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'api_client.dart';
import 'token_storage.dart';

class AuthService {
  // idToken은 카카오 SDK에서 발급받은 값
  static Future<bool> loginWithKakaoIdToken(String idToken) async {
    try {
      final Response response = await ApiClient.dio.post(
        ApiConfig.kakaoLogin,
        data: jsonEncode({ 'idToken': idToken }),
      );

      final data = response.data as Map<String, dynamic>;
      final String access = data['accessToken'] as String;
      final String refresh = data['refreshToken'] as String;

      await TokenStorage.saveTokens(access: access, refresh: refresh);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchUserInfo() async {
    try {
      final Response response = await ApiClient.dio.get(ApiConfig.userInfo);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  static Future<void> logoutLocal() async {
    await TokenStorage.clear();
  }
}


