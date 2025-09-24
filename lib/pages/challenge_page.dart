import 'package:flutter/material.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("그린 챌린지",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              )
            ),
            const SizedBox(height: 8),
            Text(
              "작은 실천으로 세상을 바꾸는 습관",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
              ),

            ),
            const SizedBox(height: 24), // 부제목과 챌린지 목록 사이 간격
            _buildChallengeCard(
              context,
              icon: Icons.recycling,
              iconColor: Colors.blue.shade700,
              backgroundColor: Colors.blue.shade100,
              title: "페트병 라벨 떼고 버리기",
              subtitle: "자원 순환 • 1,234명 참여",
              points: "+20P",
            ),
            const SizedBox(height: 16), // 카드 사이 간격
            _buildChallengeCard(
              context,
              icon: Icons.power_off,
              iconColor: Colors.amber.shade800,
              backgroundColor: Colors.amber.shade100,
              title: "안 쓰는 코드 뽑기",
              subtitle: "에너지 절약 • 2,580명 참여",
              points: "+10P",
            ),
          ]
        ),
      )
    );
  }
}

Widget _buildChallengeCard(
  BuildContext context,{
required IconData icon,
required Color iconColor,
required Color backgroundColor,
required String title,
required String subtitle,
required String points,
}){
  return Card(
    elevation: 1, // 카드에 부드러운 그림자 효과
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: InkWell( // 클릭 시 물결 효과
      onTap: () {
        // 챌린지 상세 페이지로 이동하는 로직 추가
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // 왼쪽 아이콘
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(width: 16),
            // 중앙 텍스트 (제목, 부제목)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // 오른쪽 포인트
            Text(
              points,
              style: TextStyle(
                color: Theme.of(context).primaryColor, // 앱의 테마 색상 사용
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

