import 'package:billow/features/landing/presentation/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/challenge/presentation/challenge_screen.dart';
import 'features/tips/presentation/tips_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/auth/presentation/auth_test_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<void> main() async {
  // 3. 로컬 디버깅을 위해 .env 파일 로드
  await dotenv.load(fileName: ".env");

  if (kIsWeb) {
    // --- 웹 환경일 경우 ---
    // GitHub Actions의 --dart-define에서 JavaScript 키를 읽어옵니다.
    const jsAppKey = String.fromEnvironment('KAKAO_JAVASCRIPT_APP_KEY');
    if (jsAppKey.isEmpty) {
      throw Exception('KAKAO_JAVASCRIPT_APP_KEY is not set via --dart-define');
    }
    KakaoSdk.init(javaScriptAppKey: jsAppKey);
  } else {
    // --- 모바일 (Android/iOS) 환경일 경우 ---
    // --dart-define 값을 먼저 확인하고, 없으면 .env 파일에서 로드 (하이브리드 방식)
    String nativeAppKey =
    const String.fromEnvironment('KAKAO_NATIVE_APP_KEY');
    if (nativeAppKey.isEmpty) {
      nativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '';
    }

    if (nativeAppKey.isEmpty) {
      throw Exception('KAKAO_NATIVE_APP_KEY is not set in .env or via --dart-define');
    }
    KakaoSdk.init(nativeAppKey: nativeAppKey);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0.5,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ChallengeScreen(),
    const TipsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 40,
        title: Text(
          'Billow',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.vpn_key, color: Colors.black54),
            tooltip: 'Auth Test',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AuthTestScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), label: '챌린지'),
          NavigationDestination(icon: Icon(Icons.lightbulb_outline), label: '꿀팁'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '마이'),
        ],
      ),
    );
  }
}