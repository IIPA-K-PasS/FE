import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  Future<void> _complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <_OnboardPageData>[
      _OnboardPageData(
        image: 'assets/images/onboarding/onboard_1.png',
        title: '고지서를 찍기만 하면,\nAI가 분석해줘요',
        body: '복잡한 숫자들은 AI에게 맡기고,\n나는 똑똑하게 절약만 하면 돼요.',
        primaryText: '다음',
      ),
      _OnboardPageData(
        image: 'assets/images/onboarding/onboard_2.png',
        title: '흩어진 공과금,\n한눈에 모아보세요',
        body: '전기·수도·가스 고지서를\n앱에서 간편하게 관리해요.',
        primaryText: '다음',
      ),
      _OnboardPageData(
        image: 'assets/images/onboarding/onboard_3.png',
        title: '절약 습관 만들고,\n포인트로 보상 받으세요',
        body: '작은 실천이 만드는 놀라운 변화.\n포인트로 바꾸는 쏠쏠한 즐거움!',
        primaryText: '시작하기',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: pages.length,
                itemBuilder: (_, i) => _OnboardPage(data: pages[i]),
              ),
            ),
            const SizedBox(height: 8),
            _Dots(count: pages.length, index: _index),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _complete,
                    child: const Text('건너뛰기', style: TextStyle(color: Colors.grey)),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (_index < pages.length - 1) {
                        _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                      } else {
                        _complete();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(pages[_index].primaryText),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _OnboardPageData {
  final String image; final String title; final String body; final String primaryText;
  _OnboardPageData({required this.image, required this.title, required this.body, required this.primaryText});
}

class _OnboardPage extends StatelessWidget {
  final _OnboardPageData data;
  const _OnboardPage({required this.data});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                data.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.teal[50],
                  alignment: Alignment.center,
                  child: const Text('Illustration', style: TextStyle(color: Colors.teal, fontSize: 22, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF263238)),
          ),
          const SizedBox(height: 12),
          Text(
            data.body,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF607D8B)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count; final int index;
  const _Dots({required this.count, required this.index});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final selected = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: selected ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: selected ? Colors.teal : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}


