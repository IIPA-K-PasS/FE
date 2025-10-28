import 'package:flutter/material.dart';
import '../../data/weather_api_service.dart';

class AISavingForecastCard extends StatelessWidget {
  final bool isLoading;
  final WeatherData? weatherData;
  final String locationName;

  const AISavingForecastCard({
    super.key,
    required this.isLoading,
    this.weatherData,
    required this.locationName,
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
      child: isLoading
          ? _buildLoadingState() // 1. 로딩 중 UI
          : (locationName == '위치 정보 없음') // 2. 동네 설정 전 UI
          ? _buildNotSetState(context)
          : _buildDataState(context), // 3. 동네 설정 후 UI
    );
  }

  // 로딩 상태일 때 보여줄 위젯
  Widget _buildLoadingState() {
    return const SizedBox(
      height: 150, // 전체 카드 높이와 비슷하게 유지
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // 동네가 설정되지 않았을 때 보여줄 위젯
  Widget _buildNotSetState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목은 항상 표시
        Text(
          '오늘의 AI 절약 예보',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // 동네 설정을 유도하는 안내 메시지
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                Icon(Icons.location_off_outlined, size: 36, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  '내 동네를 설정하고\nAI 절약 예보를 받아보세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], height: 1.5, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 데이터가 있을 때 보여줄 위젯
  Widget _buildDataState(BuildContext context) {
    final iconUrl = weatherData != null
        ? 'https://openweathermap.org/img/wn/${weatherData!.icon}@2x.png'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 제목
        Text(
          '오늘의 AI 절약 예보',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // 2. 위치 및 날씨 정보 Row
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 8),
            // 위치 이름 동적 표시
            Text(
              locationName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            // 온도 및 날씨 설명 동적 표시
            if (weatherData != null)
              Text(
                '${weatherData!.temp.toStringAsFixed(0)}°C ${weatherData!.description}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(width: 8),
            // 날씨 아이콘 동적 표시
            if (iconUrl != null)
              Image.network(iconUrl, width: 24, height: 24)
            else
              Icon(
                Icons.cloud_off,
                color: Colors.grey[400],
                size: 20,
              ),
          ],
        ),
        const SizedBox(height: 16),

        // 3. 절약 팁 박스
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.teal[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal[200]!, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: Colors.teal[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // AI 팁 텍스트 (하드코딩)
              Expanded(
                child: Text(
                  '맑은 날씨가 계속돼요. 건조기 대신 햇볕에 빨래를 널러 전기 요금을 아껴보세요!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal[800],
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

