import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoService {
  static Future<User?> getMeSafe() async {
    try {
      return await UserApi.instance.me();
    } catch (_) {
      return null;
    }
  }

  static Future<void> logoutSdk() async {
    try {
      await UserApi.instance.logout();
    } catch (_) {}
  }

  static Future<void> unlinkSdk() async {
    try {
      await UserApi.instance.unlink();
    } catch (_) {}
  }
}


