import 'package:billow/features/home/presentation/widgets/bill_type_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../domain/bill_entity.dart';
import 'bill_preview_screen.dart';
import 'widgets/ai_saving_forecast_card.dart';
import 'widgets/bill_summary_card.dart';
import 'widgets/neighborhood_comparison_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  int? _scannedAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body:  SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // 첫 번째 카드: AI 절약 예보
              const AISavingForecastCard(),

              const SizedBox(height: 20),

              // 두 번째 카드: 6월 고지서 요약
              BillSummaryCard(
                amount: _scannedAmount,
                onScanPressed: _showBillTypeSelectionSheet,
              ),

              const SizedBox(height: 20),

              // 세 번째 카드: 우리 동네 비교
              const NeighborhoodComparisonCard(),

              const SizedBox(height: 20), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }

  void _showBillTypeSelectionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext bc) {
        // 모달 UI는 기존과 거의 동일 (onPressed 부분만 수정)
        return Container(
          // height 속성을 추가하여 높이를 지정합니다.
          height: MediaQuery.of(context).size.height * 0.45,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 모달 손잡이
              Center(
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

              // 제목 텍스트
              const Text(
                '어떤 고지서를 촬영할까요?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // 부제목 텍스트
              const Text(
                '분석하고 싶은 고지서를 선택해주세요.',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // 커스텀 버튼들
              BillTypeSelectionButton(
                  icon: Icons.flash_on,
                  label: '전기 요금',
                  color: const Color(0xFFFBC02D),
                  onPressed: () {
                    // onPressed 내부에서 _pickImageAndNavigate를 호출합니다.
                    _pickImageAndNavigate('ELECTRICITY');
                  }),
              const SizedBox(height: 12),

              BillTypeSelectionButton(
                  icon: Icons.water_drop,
                  label: '수도 요금',
                  color: const Color(0xFF1976D2),
                  onPressed: () {
                    _pickImageAndNavigate('WATER');
                  }),
              const SizedBox(height: 12),

              BillTypeSelectionButton(
                  icon: Icons.local_fire_department,
                  label: '가스 요금',
                  color: const Color(0xFFD32F2F),
                  onPressed: () {
                    _pickImageAndNavigate('GAS');
                  }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageAndNavigate(String billType) async {
    final ImagePicker picker = ImagePicker();

    if(mounted) Navigator.pop(context);

    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null && mounted) {
        // BillPreviewScreen으로 이동하고, BillEntity 타입의 결과를 기다립니다.
        final result = await Navigator.of(context).push<BillEntity>(
          MaterialPageRoute(
            builder: (context) => BillPreviewScreen(
              imageFile: pickedFile,
              billType: billType,
            ),
          ),
        );

        if (result != null) {
          setState(() {
            _scannedAmount = result.amount;
          });
        }
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    }
  }
}
