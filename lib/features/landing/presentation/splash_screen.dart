import 'package:flutter/material.dart';
import '../../../core/animation/fade_route.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import '../../../services/auth_service.dart';
import 'login_screen.dart';
import '../../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';

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
    if (!mounted) return;

    // --- 온보딩 실험용 (매번 무조건 노출) ---
    final done = false; // 항상 온보딩 보이기 (영상/테스트용)
    // 원래 로직 (아래 주석 해제하면 정상화)
    // final prefs = await SharedPreferences.getInstance();
    // final done = prefs.getBool('onboarding_completed') ?? false;
    if (!done) {
      Navigator.pushReplacement(
        context,
        FadeRoute(page: const OnboardingScreen()),
      );
      return;
    }
    // 항상 로그인 화면으로 이동 (자동 로그인 로직은 하단 주석 참고)
    Navigator.pushReplacement(context, FadeRoute(page: const LoginScreen()));
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
              'Billow v3',
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