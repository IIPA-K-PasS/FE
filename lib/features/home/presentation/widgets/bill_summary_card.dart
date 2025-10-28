import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillSummaryCard extends StatelessWidget {
  final int? amount;
  final VoidCallback onScanPressed;
  final VoidCallback? onViewReportPressed;

  const BillSummaryCard({
    super.key,
    this.amount,
    required this.onScanPressed,
    this.onViewReportPressed,
  });

  // 금액을 콤마(,) 포맷으로 변환해주는 헬퍼 함수
  String _formatCurrency(int value) {
    return NumberFormat('#,###').format(value);
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('6월 고지서 요약', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              if (onViewReportPressed != null)
                GestureDetector(
                  onTap: onViewReportPressed,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('이번 달 총 요금', style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 8),

          if (amount != null)
            Text(
              '${_formatCurrency(amount!)}원',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            )
          else
            const Text(
              '고지서를 등록해주세요',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

          const SizedBox(height: 8),

          Text(
            amount != null ? '지난달보다 3,500원 아꼈어요!' : '절약 정보를 확인해보세요',
            style: TextStyle(fontSize: 14, color: Colors.blue[600], fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: onScanPressed,
              icon: const Icon(Icons.camera_alt, size: 20),
              label: const Text('고지서 촬영/등록하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[400],
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}