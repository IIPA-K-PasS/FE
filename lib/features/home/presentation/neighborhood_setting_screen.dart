import 'package:flutter/material.dart';

class NeighborhoodSettingScreen extends StatelessWidget {
  const NeighborhoodSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 동네 설정'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 2),
            // 중앙 아이콘
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.person_outline,
                  size: 40,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 메인 텍스트
            const Text(
              '어떻게 동네를 설정할까요?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // 서브 텍스트
            Text(
              '정확한 비교를 위해 현재 거주하는\n동네를 설정해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const Spacer(flex: 3),

            // 현재 위치로 찾기 버튼
            ElevatedButton.icon(
              onPressed: () {
                // TODO: GPS 위치 기반 동네 설정 로직 구현
              },
              icon: const Icon(Icons.my_location),
              label: const Text('현재 위치로 찾기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor.withOpacity(0.9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 12),

            // 주소 직접 검색 버튼
            OutlinedButton.icon(
              onPressed: () {
                // TODO: 주소 검색 화면으로 이동하는 로직 구현
              },
              icon: const Icon(Icons.search),
              label: const Text('주소 직접 검색'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black54,
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}