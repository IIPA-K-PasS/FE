import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
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
      height: 150,
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
        Text(
          '오늘의 AI 절약 예보',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
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

    final weatherText = weatherData != null
        ? '${weatherData!.temp.toStringAsFixed(0)}°C ${weatherData!.description}'
        : '날씨 정보 로딩 중...';

    // 날씨 텍스트 스타일 정의
    final weatherTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘의 AI 절약 예보',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                locationName,
                style: weatherTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ⭐ 변경점: 날씨 텍스트 부분을 LayoutBuilder로 감싸서 너비 측정
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // TextPainter를 사용하여 텍스트 너비 계산
                        final span = TextSpan(text: weatherText, style: weatherTextStyle);
                        final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
                        tp.layout();

                        // 사용 가능한 너비(constraints.maxWidth)보다 텍스트 너비(tp.width)가 크면 Marquee 사용
                        if (tp.width > constraints.maxWidth) {
                          return SizedBox(
                            height: 24, // Marquee 높이 지정
                            child: Marquee(
                              text: weatherText,
                              style: weatherTextStyle,
                              scrollAxis: Axis.horizontal,
                              blankSpace: 20.0,
                              velocity: 50.0,
                              pauseAfterRound: const Duration(seconds: 1),
                              showFadingOnlyWhenScrolling: true,
                              fadingEdgeStartFraction: 0.1,
                              fadingEdgeEndFraction: 0.1,
                              startPadding: 10.0,
                              // numberOfRounds: null, // 무한 반복 (기본값)
                              // accelerationDuration 및 decelerationDuration은 기본값 사용 가능
                            ),
                          );
                        } else {
                          // 너비가 충분하면 일반 Text 위젯 사용 (오른쪽 정렬)
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Text(weatherText, style: weatherTextStyle),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (iconUrl != null)
                    Image.network(iconUrl, width: 24, height: 24, errorBuilder: (context, error, stackTrace) => Icon(Icons.error_outline, color: Colors.grey[400], size: 20))
                  else
                    Icon(
                      Icons.cloud_off,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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

