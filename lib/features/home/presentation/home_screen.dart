import 'package:billow/features/home/presentation/widgets/bill_type_selection_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/weather_api_service.dart';
import 'bill_preview_screen.dart';
import 'neighborhood_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../domain/bill_entity.dart';
import 'widgets/ai_saving_forecast_card.dart';
import 'widgets/bill_summary_card.dart';
import 'widgets/neighborhood_comparison_card.dart';
import '../../bills/presentation/monthly_report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  int? _scannedAmount;
  WeatherData? _weatherData;
  String _locationName = '위치 정보 없음';
  bool _isLoadingWeather = true;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    // ⭐ 변경점: 동네 설정 여부를 확인하는 플래그 생성
    final bool isLocationSet = _locationName != '위치 정보 없음';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // 첫 번째 카드: AI 절약 예보
              AISavingForecastCard(
                isLoading: _isLoadingWeather,
                weatherData: _weatherData,
                locationName: _locationName,
              ),

              const SizedBox(height: 20),

              // 두 번째 카드: 6월 고지서 요약
              BillSummaryCard(
                amount: _scannedAmount,
                onScanPressed: _showBillTypeSelectionSheet,
                onViewReportPressed: _navigateToMonthlyReport,
              ),

              const SizedBox(height: 20),

              // 세 번째 카드: 우리 동네 비교
              // ⭐ 변경점: isLocationSet 플래그를 전달합니다.
              NeighborhoodComparisonCard(
                isLocationSet: isLocationSet,
                onPressed: _navigateToNeighborhoodSetting,
              ),

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
          height: MediaQuery
              .of(context)
              .size
              .height * 0.45,
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
                    _pickImageAndNavigate ('ELECTRICITY');
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

    if (mounted) Navigator.pop(context);

    try {
      final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.camera);

      if (pickedFile != null && mounted) {
        // BillPreviewScreen으로 이동하고, BillEntity 타입의 결과를 기다립니다.
        final result = await Navigator.of(context).push<BillEntity>(
          MaterialPageRoute(
            builder: (context) =>
                BillPreviewScreen(
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    }
  }

  void _navigateToMonthlyReport() {
    Navigator.of(context).push(
      MaterialPageRoute(
        // TODO: 실제 년/월 데이터를 전달하도록 수정 필요
        builder: (context) => const MonthlyReportScreen(year: 2025, month: 6),
      ),
    );
  }

  // 홈 화면에 필요한 모든 데이터를 로드하는 함수
  Future<void> _loadHomeData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() { _isLoadingWeather = true; });
      }
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final double? lat = prefs.getDouble('user_latitude');
      final double? lon = prefs.getDouble('user_longitude');
      final String? fullLocationName = prefs.getString('user_location_name');

      WeatherData? newWeatherData;
      String newLocationName = '위치 정보 없음';

      if (lat != null && lon != null && fullLocationName != null) {
        final weatherService = WeatherApiService();
        newWeatherData = await weatherService.getWeather(lat, lon);

        // 주소를 공백으로 분리합니다. 예: "서울특별시 중구 명동" -> ["서울특별시", "중구", "명동"]
        final addressParts = fullLocationName.split(' ');

        // 분리된 주소 부분이 2개 이상이면 앞의 두 부분만 합칩니다.
        if (addressParts.length >= 2) {
          // 예: "서울특별시 중구"
          newLocationName = '${addressParts[0]} ${addressParts[1]}';
        } else {
          // 주소가 한 단어이거나 특이한 경우 그대로 사용합니다.
          newLocationName = fullLocationName;
        }
      }

      if (mounted) {
        setState(() {
          _weatherData = newWeatherData;
          _locationName = newLocationName;
          _isLoadingWeather = false;
        });
      }

    } catch (e) {
      print('날씨 데이터 로딩 실패: $e');
      if (mounted) {
        setState(() {
          _locationName = '위치 정보 없음';
          _weatherData = null;
          _isLoadingWeather = false;
        });
      }
    }
  }

  // '내 동네 설정하기' 화면으로 이동하고, 완료 시 데이터를 새로고침하는 함수
  Future<void> _navigateToNeighborhoodSetting() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const NeighborhoodSettingScreen()),
    );

    if (result == true && mounted) {
      // 현재 프레임의 렌더링이 완료된 직후에 _loadHomeData를 호출합니다.
      // 이렇게 하면 화면 전환과 setState 충돌을 방지할 수 있습니다.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadHomeData();
      });
    }
  }
}

