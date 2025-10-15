import 'package:flutter/material.dart';

class BillSummaryCard extends StatelessWidget {
  const BillSummaryCard({super.key});

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
            '6월 고지서 요약',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 요금 정보
          const Text(
            '이번 달 총 요금',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 총 요금 금액
          const Text(
            '54,500원',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 절약 금액
          Text(
            '지난달보다 3,500원 아꼈어요!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 고지서 촬영 버튼
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Semantics(
              label: '고지서 촬영 및 등록 버튼',
              button: true,
              child: ElevatedButton(
                onPressed: () {
                  _showBillTypeSelectionSheet(context);
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[400],
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '고지서 촬영/등록하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBillTypeSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)), // 상단 둥근 모서리
      ),
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center( // 모달 손잡이
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                '어떤 고지서를 촬영할까요?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '분석하고 싶은 고지서를 선택해주세요.',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              _BillTypeSelectionButton(
                icon: Icons.flash_on,
                label: '전기 요금',
                color: const Color(0xFFFBC02D),
                onPressed: () {
                  Navigator.pop(bc); // 모달 닫기
                  // TODO: 전기 요금 촬영 로직 시작
                  print('전기 요금 촬영 선택됨');
                },
              ),
              const SizedBox(height: 12),

              _BillTypeSelectionButton(
                icon: Icons.water_drop,
                label: '수도 요금',
                color: const Color(0xFF1976D2),
                onPressed: () {
                  Navigator.pop(bc); // 모달 닫기
                  // TODO: 수도 요금 촬영 로직 시작
                  print('수도 요금 촬영 선택됨');
                },
              ),
              const SizedBox(height: 12),

              _BillTypeSelectionButton(
                icon: Icons.local_fire_department,
                label: '가스 요금',
                color: const Color(0xFFD32F2F),
                onPressed: () {
                  Navigator.pop(bc); // 모달 닫기
                  // TODO: 가스 요금 촬영 로직 시작
                  print('가스 요금 촬영 선택됨');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BillTypeSelectionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _BillTypeSelectionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withOpacity(0.8), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16), // 버튼 패딩 조절
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20), // 아이콘 크기 조절
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
