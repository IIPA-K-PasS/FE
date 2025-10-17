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
      body: const SafeArea(
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
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.flash_on, color: Color(0xFFFBC02D)),
                title: const Text('전기 요금'),
                onTap: () {
                  _pickImageAndNavigate('ELECTRICITY');
                },
              ),
              ListTile(
                leading: const Icon(Icons.water_drop, color: Color(0xFF1976D2)),
                title: const Text('수도 요금'),
                onTap: () {
                  _pickImageAndNavigate('WATER');
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_fire_department, color: Color(0xFFD32F2F)),
                title: const Text('가스 요금'),
                onTap: () {
                  _pickImageAndNavigate('GAS');
                },
              ),
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
