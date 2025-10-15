import 'package:flutter/material.dart';
import 'package:billow/main.dart';

import '../../../common/animation/slide_route.dart'; // MainNavigationPage를 import

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/billow_logo.png',
                  height: 200,
                ),
              ),
              Text(
                'Billow',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                ),
              ),
              const SizedBox(height: 80),
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
              const SizedBox(height: 80),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 카카오 로그인 버튼
                  ElevatedButton(
                    onPressed: () {
                      // TODO: 실제 카카오 로그인 로직 구현
                      Navigator.pushReplacement(
                        context,
                        SlideRoute(page: const MainNavigationPage()),
                      );
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
            ],
          ),
        ),
      ),
    );
  }
}