import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:billow/features/landing/presentation/splash_screen.dart';
import 'package:billow/features/landing/presentation/kakao_web_callback_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String kakaoKey = const String.fromEnvironment('KAKAO_NATIVE_APP_KEY');
  if (kakaoKey.isEmpty) {
    try {
      await dotenv.load(fileName: '.env');
      kakaoKey = dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '';
    } catch (_) {}
  }
  if (kakaoKey.isEmpty) {
    throw Exception('KAKAO_NATIVE_APP_KEY is not set (use --dart-define or .env)');
  }
  KakaoSdk.init(nativeAppKey: kakaoKey);

  runApp(const BillowApp());
}

class BillowApp extends StatelessWidget {
  const BillowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Colors.teal,
        secondary: Colors.teal,
        surface: Colors.white,
        background: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/auth/callback') {
          return MaterialPageRoute(builder: (_) => const KakaoWebCallbackScreen());
        }
        return null;
      },
    );
  }
}
