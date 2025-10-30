import 'package:billow/features/landing/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/challenge/presentation/challenge_screen.dart';
import 'features/tips/presentation/tips_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/auth/presentation/auth_test_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {

  // .env 파일 로드
  await dotenv.load(fileName: '.env');

  // 환경변수에서 카카오 네이티브 앱 키 가져오기
  final kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];
  if (kakaoNativeAppKey == null || kakaoNativeAppKey.isEmpty) {
    throw Exception('KAKAO_NATIVE_APP_KEY is not set in .env file');
  }

  KakaoSdk.init(nativeAppKey: kakaoNativeAppKey);
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
          // 알림 아이콘을 포인트 초기화 버튼으로 대체 (테스트용)
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black54, size: 32),
            tooltip: '포인트 초기화',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('green_point_override');
              if (mounted) setState(() {}); // 즉시 반영(마이/홈)
              // TODO: 디버깅/테스트 끝나면 이 기능은 disable 하세요~
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.teal[50],
              child: Text(
                'Me',
                style: TextStyle(
                  color: Colors.teal[800],
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal  ,
        unselectedItemColor: Colors.grey,
        iconSize: 28,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: '챌린지',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: '자취꿀팁',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
