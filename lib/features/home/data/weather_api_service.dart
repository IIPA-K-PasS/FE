import 'dart:convert';
import 'package:flutter/foundation.dart'; // kDebugMode를 위해 import
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
  String? _resolveKey() {
    String v = const String.fromEnvironment('OPENWEATHERMAP_API_KEY');
    if (v.isEmpty) {
      try { v = dotenv.env['OPENWEATHERMAP_API_KEY'] ?? ''; } catch (_) {}
    }
    return v.isEmpty ? null : v;
  }

  Future<WeatherData?> getWeather(double lat, double lon) async {
    final apiKey = _resolveKey();
    if (apiKey == null) return null;
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=kr');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      return WeatherData.fromJson(map);
    }
    return null;
  }
}

