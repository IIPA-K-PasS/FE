import 'package:flutter/material.dart';
import 'package:billow/main.dart' hide MainNavigationPage;
import '../../../services/auth_service.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../../core/animation/slide_route.dart';
import '../../terms/data/term_api_service.dart';
import '../../terms/presentation/terms_agreement_screen.dart';
import 'main_navigation_page.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Center(
                child: Image.asset(
                  'assets/images/billow_logo.png',
                  height: 200,
                ),
              ),
              Text(
                'Billow',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                ),
              ),
              const SizedBox(height: 60),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '생활요금, 이제\n아끼고 포인트 받으세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'AI가 우리 집 에너지 사용량을 분석해주고,\n절약 챌린지를 통해 현금처럼 사용하는 포인트를 드려요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 카카오 로그인 버튼
                  ElevatedButton(
                    onPressed: () async {
                      final scaffold = ScaffoldMessenger.of(context);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CircularProgressIndicator()),
                      );
                      try {
                        // 개선된 로그인 로직 사용
                        final idToken = await AuthService.performKakaoLogin();
                        if (idToken == null) {
                          if (context.mounted) Navigator.of(context).pop();
                          scaffold.showSnackBar(
                            const SnackBar(content: Text('ID 토큰을 받지 못했습니다. openid 동의 확인')), 
                          );
                          return;
                        }
                        final ok = await AuthService.loginWithKakaoIdToken(idToken);
                        if (context.mounted) Navigator.of(context).pop();
                        if (!ok) {
                          scaffold.showSnackBar(
                            const SnackBar(content: Text('로그인 실패: 서버 연동 확인 필요')), 
                          );
                          return;
                        }

                        // 약관 동의 여부 확인
                        if (context.mounted) {
                          final hasAgreed = await TermApiService.hasAgreedToRequiredTerms();

                          if (!context.mounted) return;

                          if (hasAgreed) {
                            // 기존 회원 → 메인 화면
                            Navigator.pushReplacement(
                              context,
                              SlideRoute(page: const MainNavigationPage()),
                            );
                          } else {
                            // 신규 회원 → 약관 동의 화면
                            Navigator.pushReplacement(
                              context,
                              SlideRoute(page: const TermsAgreementScreen()),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) Navigator.of(context).pop();
                        scaffold.showSnackBar(
                          SnackBar(content: Text('카카오 로그인 실패: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFAE100), // 카카오 노란색
                      foregroundColor: Colors.black87,
                      minimumSize: const Size(double.infinity, 50), // 버튼 너비 최대로
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Image.asset(
                           'assets/images/kakao_logo.png',
                           height: 20,
                         ),
                        const SizedBox(width: 8),
                        const Text(
                          '카카오로 시작하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF371D1E)
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '이용약관',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '|',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '개인정보처리방침',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30), // 하단 여백
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

Future<String?> _promptIdToken(BuildContext context) async {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Kakao ID Token 입력'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: '카카오에서 발급받은 idToken 붙여넣기'),
          minLines: 1,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text('확인'),
          ),
        ],
      );
    },
  );
}