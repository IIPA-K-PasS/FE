import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// API 응답 데이터를 담을 모델 클래스
class WeatherData {
  final double temp;
  final String description;
  final String icon;

  WeatherData({required this.temp, required this.description, required this.icon});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temp: (json['main']['temp'] as num?)?.toDouble() ?? 0.0,
      description: json['weather'][0]['description'] ?? '정보 없음',
      icon: json['weather'][0]['icon'] ?? '',
    );
  }
}

class WeatherApiService {
  final String? _apiKey = dotenv.env['OPENWEATHERMAP_API_KEY'];
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherData> getWeather(double lat, double lon) async {
    if (_apiKey == null) {
      throw Exception("OpenWeatherMap API key is not configured in .env file");
    }

    // API 요청 URL (단위: 섭씨, 언어: 한국어)
    final url = '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=kr';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data. Status: ${response.statusCode}');
    }
  }
}
