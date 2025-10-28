import 'package:billow/features/challenge/presentation/widget/challenge_card.dart';
import 'package:flutter/material.dart';
import '../domain/challenge_entity.dart';
import 'challenge_detail_screen.dart'; // 상세 화면 import

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengeScreen> {
  // 아이콘 매핑 (카테고리별 아이콘 지정)
  IconData _getIconForCategory(String category) {
    switch (category) {
      case '자원 순환':
        return Icons.recycling;
      case '에너지 절약':
        return Icons.power_off;
      default:
        return Icons.eco; // 기본 아이콘
    }
  }

  // 아이콘 색상 매핑
  Color _getIconColorForCategory(String category) {
    switch (category) {
      case '자원 순환':
        return Colors.blue.shade700;
      case '에너지 절약':
        return Colors.amber.shade800;
      default:
        return Colors.green.shade700;
    }
  }

  // 배경 색상 매핑
  Color _getBackgroundColorForCategory(String category) {
    switch (category) {
      case '자원 순환':
        return Colors.blue.shade50;
      case '에너지 절약':
        return Colors.amber.shade50;
      default:
        return Colors.green.shade50;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100], // 배경색 추가
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
              const SizedBox(height: 24),

              // ListView.builder를 사용하여 챌린지 목록 동적 생성
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(), // 중첩 스크롤 방지
                shrinkWrap: true, // 내용물 크기에 맞게 높이 조절
                itemCount: dummyChallenges.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16), // 카드 사이 간격
                itemBuilder: (context, index) {
                  final challenge = dummyChallenges[index];
                  return ChallengeCard(
                    icon: _getIconForCategory(challenge.category),
                    iconColor: _getIconColorForCategory(challenge.category),
                    backgroundColor: _getBackgroundColorForCategory(challenge.category),
                    title: challenge.title,
                    // TODO: 참여자 수는 API 연동 필요 (현재는 카테고리만 표시)
                    subtitle: "${challenge.category} 참여",
                    points: "+${challenge.points}P",
                    // onTap 콜백 추가: 상세 화면으로 이동
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChallengeDetailScreen(challenge: challenge),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        )
    );
  }
}

