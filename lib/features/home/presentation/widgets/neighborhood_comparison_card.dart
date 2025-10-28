import 'package:flutter/material.dart';

class NeighborhoodComparisonCard extends StatelessWidget {
  // 1. 부모 위젯(HomeScreen)으로부터 버튼 클릭 시 실행할 함수를 전달받기 위한 변수
  final VoidCallback onPressed;

  const NeighborhoodComparisonCard({
    super.key,
    required this.onPressed, // 2. 생성자에 onPressed를 필수로 받도록 추가
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          const Text(
            '우리 동네 비교',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 24),

          // 중앙 아이콘
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.location_on,
                size: 40,
                color: Colors.grey[600],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 플레이스홀더 텍스트
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

          const SizedBox(height: 24,),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // 3. Navigator.push 대신, 부모로부터 전달받은 onPressed 함수를 실행
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

