import 'package:flutter/material.dart';
import '../../../core/animation/fade_route.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
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
      // 조용한 로그인: 카카오 세션 존재 시 idToken 발급 후 서버 로그인 시도
      OAuthToken token;
      try {
        // 이미 세션이 있으면 바로 me() 호출로 확인
        await UserApi.instance.me();
        token = await UserApi.instance.loginWithKakaoAccount();
      } catch (_) {
        // 세션 없으면 로그인 화면으로 이동
        if (!mounted) return _goLogin();
        return _goLogin();
      }

      final idToken = token.idToken;
      if (idToken == null) return _goLogin();
      final ok = await AuthService.loginWithKakaoIdToken(idToken);
      if (!mounted) return;
      if (ok) {
        Navigator.pushReplacement(
          context,
          FadeRoute(page: const MainNavigationPage()), // 자동 로그인 성공 시 메인 화면으로 이동
        );
      } else {
        _goLogin();
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