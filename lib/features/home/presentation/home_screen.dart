import 'package:flutter/material.dart';
import 'widgets/ai_saving_forecast_card.dart';
import 'widgets/bill_summary_card.dart';
import 'widgets/neighborhood_comparison_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            
            // 첫 번째 카드: AI 절약 예보
            const AISavingForecastCard(),
            
            const SizedBox(height: 20),
            
            // 두 번째 카드: 6월 고지서 요약
            const BillSummaryCard(),
            
            const SizedBox(height: 20),
            
            // 세 번째 카드: 우리 동네 비교
            const NeighborhoodComparisonCard(),
            
            const SizedBox(height: 100), // 하단 네비게이션바 공간
          ],
        ),
      ),
    );
  }
}
