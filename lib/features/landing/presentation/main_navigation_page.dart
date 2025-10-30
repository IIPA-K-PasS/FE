import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:billow/features/home/presentation/home_screen.dart';
import 'package:billow/features/profile/presentation/profile_screen.dart';
import 'package:billow/features/tips/presentation/tips_screen.dart';
import 'package:billow/features/challenge/presentation/challenge_screen.dart';
import 'package:billow/features/auth/presentation/auth_test_screen.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ChallengeScreen(),
    TipsScreen(),
    ProfileScreen(),
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
            icon: const Icon(Icons.notifications_none, color: Colors.black54, size: 32),
            tooltip: '포인트 초기화',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('green_point_override');
              if (mounted) setState(() {});
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
        selectedItemColor: Colors.teal,
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
