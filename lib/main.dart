import 'package:billow/features/landing/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/challenge/presentation/challenge_screen.dart';
import 'features/tips/presentation/tips_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/auth/presentation/auth_test_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'services/token_storage.dart';

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
          IconButton(
            icon: const Icon(
                Icons.notifications_none,
                color: Colors.black54,
                size: 32),
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.key, size: 24, color: Colors.orange),
            tooltip: 'Show Bearer Token (Swagger용)',
            onPressed: () async {
              await TokenStorage.printAccessTokenForSwagger();
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
