import 'package:flutter/material.dart';
import 'package:billow/features/terms/data/term_api_service.dart';
import 'package:billow/features/landing/presentation/main_navigation_page.dart';
import 'package:billow/features/terms/presentation/terms_agreement_screen.dart';
import 'package:billow/services/auth_service.dart';

class KakaoWebCallbackScreen extends StatefulWidget {
  const KakaoWebCallbackScreen({super.key});

  @override
  State<KakaoWebCallbackScreen> createState() => _KakaoWebCallbackScreenState();
}

class _KakaoWebCallbackScreenState extends State<KakaoWebCallbackScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _handleCallback();
  }

  Future<void> _handleCallback() async {
    final code = Uri.base.queryParameters['code'];
    if (code == null || code.isEmpty) {
      setState(() => _error = '인가 코드(code)를 받지 못했습니다.');
      return;
    }
    final ok = await AuthService.loginWithKakaoAuthCodeWeb(code);
    if (!mounted) return;
    if (!ok) {
      setState(() => _error = '서버 로그인 실패');
      return;
    }
    final agreed = await TermApiService.hasAgreedToRequiredTerms();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => agreed ? const MainNavigationPage() : const TermsAgreementScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _error == null
            ? const CircularProgressIndicator(color: Colors.teal)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
              ),
      ),
    );
  }
}
