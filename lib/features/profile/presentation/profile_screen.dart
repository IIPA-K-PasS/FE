import 'package:flutter/material.dart';
import 'widgets/profile_info_card.dart';
//import 'widgets/green_market_button.dart';
import 'widgets/activity_section.dart';
import 'widgets/settings_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              
              // 프로필 정보 카드
              const ProfileInfoCard(),
              
              const SizedBox(height: 16),
              
              // 그린 마켓 버튼
              //const GreenMarketButton(),
              
              //const SizedBox(height: 24),
              
              // 나의 활동 섹션
              const ActivitySection(),
              
              const SizedBox(height: 24),
              
              // 앱 설정 섹션
              const SettingsSection(),
              
              const SizedBox(height: 20), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }
}