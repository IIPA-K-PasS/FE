import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final String points;

  const ChallengeCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
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
}
