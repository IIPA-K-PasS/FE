import 'package:flutter/material.dart';

class NeighborhoodComparisonCard extends StatelessWidget {
  final VoidCallback onPressed;
  const NeighborhoodComparisonCard({super.key, required this.onPressed});

  // 하드코딩 데이터 (이미지 참고값)
  final int myAmount = 54500;
  final int neighborAvg = 58000;
  final int percent = 6;

  @override
  Widget build(BuildContext context) {
    final myColor = const Color(0xFF3D72F5); // 파란색
    final neighborColor = Colors.grey[400]!;
    final percentStr = '$percent%';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '우리 동네 비교',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          // 상단 멘트
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: '이웃보다 ',
                  style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: percentStr,
                  style: TextStyle(color: myColor, fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const TextSpan(
                  text: ' 더 적게 사용하고 있어요. 멋져요!',
                  style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 우리집
          Row(
            children: [
              const Text('🙋\u200D♀️ 우리집', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              const Spacer(),
              Text('${myAmount.toString().replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"), (m)=>',')}원',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: myAmount / neighborAvg.clamp(1, double.infinity), // 그냥 예시용
              backgroundColor: neighborColor.withOpacity(0.4),
              valueColor: AlwaysStoppedAnimation<Color>(myColor),
            ),
          ),

          const SizedBox(height: 18),

          // 이웃 평균
          Row(
            children: [
              const Text('🏡 이웃 평균', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              const Spacer(),
              Text('${neighborAvg.toString().replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"), (m)=>',')}원',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: 1.0,
              backgroundColor: neighborColor.withOpacity(0.4),
              valueColor: AlwaysStoppedAnimation<Color>(neighborColor),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "내 동네 설정하기",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

