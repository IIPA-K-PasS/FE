import 'package:flutter/material.dart';
import '../../../core/animation/fade_route.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import '../../../services/auth_service.dart';
import 'login_screen.dart';
import '../../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    try {
      // 조용한 로그인: 기존 토큰으로 서버 로그인 시도
      try {
        // 기존 토큰 확인 (카카오 창 뜨지 않음)
        final accessTokenInfo = await UserApi.instance.accessTokenInfo();
        if (accessTokenInfo == null) {
          if (!mounted) return _goLogin();
          return _goLogin();
        }
        
        // 기존 토큰으로 사용자 정보 확인 (세션 검증)
        await UserApi.instance.me();

        // Kakao SDK에 저장된 토큰 조회
        final OAuthToken? stored = await TokenManagerProvider.instance.manager.getToken();
        final accessToken = stored?.accessToken ?? '';
        if (accessToken.isEmpty) {
          if (!mounted) return _goLogin();
          return _goLogin();
        }
        
        // 서버 로그인 시도 (accessToken 사용)
        final ok = await AuthService.loginWithKakaoAccessToken(accessToken);
        if (!mounted) return;
        if (ok) {
          Navigator.pushReplacement(
            context,
            FadeRoute(page: const MainNavigationPage()),
          );
        } else {
          _goLogin();
        }
      } catch (_) {
        // 세션 없거나 실패하면 로그인 화면으로 이동
        if (!mounted) return _goLogin();
        return _goLogin();
      }
    } catch (_) {
      _goLogin();
    }
  }

  void _goLogin() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      FadeRoute(page: const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/billow_logo.png',
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'Billow',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '나의 작은 실천이 만드는 초록빛 변화',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}