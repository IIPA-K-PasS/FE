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
    
    if (!mounted) return;

    // TODO: 로그인 테스트를 위해 자동 로그인 임시 비활성화
    // 항상 로그인 화면으로 이동
    Navigator.pushReplacement(
      context,
      FadeRoute(page: const LoginScreen()),
    );

    /* 자동 로그인 로직 (테스트 후 활성화)
    // 카카오 SDK 세션 자동 로그인 시도
    bool autoLoginSuccess = false;
    
    try {
      // 1. 카카오 SDK에 유효한 토큰이 있는지 확인
      if (await AuthApi.instance.hasToken()) {
        try {
          // 2. 토큰 유효성 검사
          AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
          debugPrint('✅ 카카오 토큰 유효 (만료: ${tokenInfo.expiresIn}초 남음)');
          
          // 3. 카카오 사용자 정보 가져오기
          User kakaoUser = await UserApi.instance.me();
          
          // 4. idToken이 있으면 서버 로그인 시도
          final token = await TokenManagerProvider.instance.manager.getToken();
          if (token?.idToken != null) {
            debugPrint('🔑 idToken으로 서버 로그인 시도');
            final serverLoginSuccess = await AuthService.loginWithKakaoIdToken(token!.idToken!);
            
            if (serverLoginSuccess) {
              debugPrint('🎉 자동 로그인 성공 - 메인 화면으로 이동');
              autoLoginSuccess = true;
            } else {
              debugPrint('⚠️ 서버 로그인 실패 - 로그인 화면으로 이동');
            }
          } else {
            debugPrint('⚠️ idToken이 없음 - 재로그인 필요');
          }
        } catch (e) {
          debugPrint('❌ 카카오 토큰 검증 실패: $e');
          // 토큰이 만료되었거나 유효하지 않음
        }
      }
    } catch (e) {
      debugPrint('❌ 자동 로그인 에러: $e');
    }

    if (!mounted) return;

    if (autoLoginSuccess) {
      // 자동 로그인 성공 → 메인 화면으로
      Navigator.pushReplacement(
        context,
        FadeRoute(page: const MainNavigationPage()),
      );
    } else {
      // 자동 로그인 실패 → 로그인 화면으로
      Navigator.pushReplacement(
        context,
        FadeRoute(page: const LoginScreen()),
      );
    }
    */
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