import 'package:flutter/material.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/challenge/presentation/challenge_page.dart';
import 'features/tips/presentation/tips_screen.dart';
import 'features/profile/presentation/profile_screen.dart';

void main() {
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
      home: const MainNavigationPage(),
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
    const HomePage(),
    const ChallengePage(),
    const TipsPage(),
    const ProfilePage(),
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
        // 제목 위젯
        title: Text(
          'Eco-Wise',
          style: TextStyle(
            color: Theme.of(context).primaryColor, // 테마의 기본 색상(teal) 사용
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        // AppBar 오른쪽에 배치될 아이콘 목록
        actions: [
          IconButton(
            icon: const Icon(
                Icons.notifications_none,
                color: Colors.black54,
                size: 32),
            onPressed: () {
              // 알림 버튼 클릭 시 동작
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 8.0),
            child: CircleAvatar(
              radius: 20, // 원의 크기
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
