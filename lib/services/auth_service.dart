import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../config/api_config.dart';
import 'api_client.dart';
import 'token_storage.dart';
import 'kakao_service.dart';

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

  /// 카카오 로그인 수행 (톡/계정 분기)
  static Future<String?> performKakaoLogin() async {
    try {
      // 카카오톡 설치 여부 확인
      if (await isKakaoTalkInstalled()) {
        // 카카오톡으로 로그인 시도
        try {
          final OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          return token.idToken;
        } catch (e) {
          // 카카오톡 로그인 실패 시 계정 로그인으로 폴백
          print('카카오톡 로그인 실패, 계정 로그인으로 폴백: $e');
          final OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          return token.idToken;
        }
      } else {
        // 카카오톡 미설치 시 계정 로그인
        final OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        return token.idToken;
      }
    } catch (e) {
      print('카카오 로그인 실패: $e');
      return null;
    }
  }

  /// 동의 범위 재요청 (openid 등 부족 시)
  static Future<String?> requestAdditionalScope() async {
    try {
      // 현재 동의 범위 확인
      final user = await KakaoService.getMeSafe();
      if (user == null) return null;

      // openid가 없으면 추가 동의 요청
      // 주의: scopes 파라미터는 kakao_flutter_sdk_user 최신 버전에서만 지원됨
      // 현재 버전에서는 loginWithKakaoAccount()가 기본적으로 openid 포함
      final OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      return token.idToken;
    } catch (e) {
      print('추가 동의 요청 실패: $e');
      return null;
    }
  }

  /// SDK 토큰 무효 시 재인증 유도
  static Future<bool> reauthenticate() async {
    try {
      // 기존 세션 정리
      await KakaoService.logoutSdk();
      
      // 재로그인 시도
      final idToken = await performKakaoLogin();
      if (idToken == null) return false;
      
      // 서버 로그인
      return await loginWithKakaoIdToken(idToken);
    } catch (e) {
      print('재인증 실패: $e');
      return false;
    }
  }
}


