import 'package:flutter/material.dart';
import 'widget/ChallengeCard.dart';

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
            ChallengeCard(
              icon: Icons.recycling,
              iconColor: Colors.blue.shade700,
              backgroundColor: Colors.blue.shade100,
              title: "페트병 라벨 떼고 버리기",
              subtitle: "자원 순환 • 1,234명 참여",
              points: "+20P",
            ),
            const SizedBox(height: 16), // 카드 사이 간격
            ChallengeCard(
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


