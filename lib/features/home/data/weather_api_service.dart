import 'dart:convert';
import 'package:flutter/foundation.dart'; // kDebugMode를 위해 import
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. dotenv import 확인
import 'package:http/http.dart' as http;

// API 응답 데이터를 담을 모델 클래스
class WeatherData {
// ... (이하 동일)
  final double temp;
  final String description;
  final String icon;

  WeatherData(
      {required this.temp, required this.description, required this.icon});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temp: (json['main']['temp'] as num?)?.toDouble() ?? 0.0,
      description: json['weather'][0]['description'] ?? '정보 없음',
      icon: json['weather'][0]['icon'] ?? '',
    );
  }
}

class WeatherApiService {
  // 2. final 변수로 선언
  final String _apiKey;
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  // 3. 생성자에서 하이브리드 로직을 직접 구현
  WeatherApiService()
      : _apiKey =
  const String.fromEnvironment('OPENWEATHERMAP_API_KEY').isEmpty
      ? dotenv.env['OPENWEATHERMAP_API_KEY'] ?? ''
      : const String.fromEnvironment('OPENWEATHERMAP_API_KEY');

  Future<WeatherData> getWeather(double lat, double lon) async {
    // 4. 키 유효성 검사 (isEmpty 사용)
    if (_apiKey.isEmpty) {
      throw Exception(
          "OpenWeatherMap API key is not configured in .env or via --dart-define");
    }

    // API 요청 URL (단위: 섭씨, 언어: 한국어)
    final url =
        '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=kr';

    final response = await http.get(Uri.parse(url));

// ... (디버깅 코드 및 이하 동일)
    if (kDebugMode) {
      print('--- OpenWeatherMap API 응답 ---');
      print('Request URL: $url');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${utf8.decode(response.bodyBytes)}');
      print('-----------------------------');
    }

    if (response.statusCode == 200) {
      return WeatherData.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception(
          'Failed to load weather data. Status: ${response.statusCode}, Body: ${utf8.decode(response.bodyBytes)}');
    }
    return null;
  }
}

