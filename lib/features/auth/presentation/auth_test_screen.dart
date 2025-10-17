import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../services/token_storage.dart';

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({super.key});

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  final TextEditingController _idTokenController = TextEditingController();
  bool _loading = false;
  String _result = '';
  Map<String, dynamic>? _user;

  Future<void> _login() async {
    setState(() { _loading = true; _result = ''; _user = null; });
    final ok = await AuthService.loginWithKakaoIdToken(_idTokenController.text.trim());
    if (!mounted) return;
    if (ok) {
      final me = await AuthService.fetchUserInfo();
      setState(() {
        _user = me;
        _result = '로그인 성공';
      });
    } else {
      setState(() { _result = '로그인 실패'; });
    }
    setState(() { _loading = false; });
  }

  Future<void> _clear() async {
    await TokenStorage.clear();
    if (!mounted) return;
    setState(() { _result = '토큰 삭제 완료'; _user = null; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Test (Debug)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _idTokenController,
              decoration: const InputDecoration(
                labelText: 'Kakao ID Token',
                hintText: '여기에 카카오 idToken 붙여넣기',
              ),
              minLines: 1,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(
                          width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('로그인 시도'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: _clear, child: const Text('토큰 삭제')),
              ],
            ),
            const SizedBox(height: 12),
            Text(_result, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (_user != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_user.toString()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


