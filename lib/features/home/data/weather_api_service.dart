import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// ... (WeatherData 모델은 동일)
class WeatherData {
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
  // ⭐ 변경점: final 변수로 선언
  final String _apiKey;
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  // ⭐ 변경점: 생성자에서 하이브리드 로직 구현
  WeatherApiService()
      : _apiKey =
  const String.fromEnvironment('OPENWEATHERMAP_API_KEY').isEmpty
      ? dotenv.env['OPENWEATHERMAP_API_KEY'] ?? ''
      : const String.fromEnvironment('OPENWEATHERMAP_API_KEY');

  Future<WeatherData> getWeather(double lat, double lon) async {
    // ⭐ 변경점: 키 유효성 검사
    if (_apiKey.isEmpty) {
      throw Exception(
          "OpenWeatherMap API key is not configured in .env or via --dart-define");
    }

    final url =
        '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=kr';

    final response = await http.get(Uri.parse(url));

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
  }
}

