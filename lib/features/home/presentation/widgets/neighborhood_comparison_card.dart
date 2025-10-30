import 'package:flutter/material.dart';

class NeighborhoodComparisonCard extends StatelessWidget {
  // 1. 부모로부터 '동네 설정 여부'와 '버튼 클릭 함수'를 받습니다.
  final bool isLocationSet;
  final VoidCallback onPressed;

  const NeighborhoodComparisonCard({
    super.key,
    required this.isLocationSet,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
          // 공통 제목
          const Text(
            '우리 동네 비교',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),

          // 2. isLocationSet 값에 따라 다른 UI를 렌더링합니다.
          if (isLocationSet)
            _buildComparisonGraph(context) // 동네 설정 후 (하드코딩된 그래프)
          else
            _buildSettingPrompt(context) // 동네 설정 전 (안내)
        ],
      ),
    );
  }

  // 3. 동네 설정 후 (하드코딩된 비교 그래프 UI)
  Widget _buildComparisonGraph(BuildContext context) {
    // 사용자가 제공한 하드코딩 데이터
    final int myAmount = 54500;
    final int neighborAvg = 58000;
    final int percent = 6;
    final myColor = const Color(0xFF3D72F5); // 파란색
    final neighborColor = Colors.grey[400]!;
    final percentStr = '$percent%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500),
            children: [
              const TextSpan(text: '이웃보다 '),
              TextSpan(
                text: percentStr,
                style: TextStyle(color: myColor, fontWeight: FontWeight.w700, fontSize: 15),
              ),
              const TextSpan(text: ' 더 적게 사용하고 있어요. 멋져요!'),
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
            value: myAmount / neighborAvg.clamp(1, double.infinity),
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
            value: 1.0, // 이웃 평균을 100% 기준으로 설정
            backgroundColor: neighborColor.withOpacity(0.4),
            valueColor: AlwaysStoppedAnimation<Color>(neighborColor),
          ),
        ),
        const SizedBox(height: 20),

        // "내 동네 다시 설정하기" 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed, // 부모로부터 받은 콜백 연결
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text(
              "내 동네 다시 설정하기", // 텍스트 변경
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }

  // 4. 동네 설정 전 (안내 UI)
  Widget _buildSettingPrompt(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.location_on_outlined,
              size: 40,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            '동네 데이터가 없습니다',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Center(
          child: Text(
            '내 동네를 설정하고 사용량을 비교해보세요.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black45,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed, // 부모로부터 받은 콜백 연결
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text(
              "내 동네 설정하기",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

