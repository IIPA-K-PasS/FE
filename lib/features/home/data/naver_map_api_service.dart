import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// ... (Address 모델은 동일)
class Address {
  final String roadAddress;
  final String jibunAddress;
  final double lat;
  final double lon;

  Address(
      {required this.roadAddress,
        required this.jibunAddress,
        required this.lat,
        required this.lon});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      roadAddress: json['roadAddress'] ?? '',
      jibunAddress: json['jibunAddress'] ?? '',
      lat: double.tryParse(json['y'] ?? '0.0') ?? 0.0,
      lon: double.tryParse(json['x'] ?? '0.0') ?? 0.0,
    );
  }
}

class NaverMapApiService {
  final String _clientId;
  final String _clientSecret;

  NaverMapApiService()
      : _clientId = _getEnv('NAVER_CLIENT_ID'),
        _clientSecret = _getEnv('NAVER_CLIENT_SECRET');

  static String _getEnv(String key) {
    String value = String.fromEnvironment(key);
    if (value.isEmpty) {
      value = dotenv.env[key] ?? '';
    }
    return value;
  }

  // Geocoding: 주소 검색
  Future<List<Address>> searchAddress(String query) async {
    if (_clientId.isEmpty || _clientSecret.isEmpty) {
      throw Exception(
          "API keys are not configured in .env or via --dart-define");
    }

    final response = await http.get(
      Uri.parse(
          'https://maps.apigw.ntruss.com/map-geocode/v2/geocode?query=$query'),
      headers: {
        // ⭐ 오류 수정: id, secret -> _clientId, _clientSecret
        'X-NCP-APIGW-API-KEY-ID': _clientId,
        'X-NCP-APIGW-API-KEY': _clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['addresses'] != null) {
        return (data['addresses'] as List)
            .map((addr) => Address.fromJson(addr))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load addresses');
    }
  }

  // Reverse Geocoding: 좌표 -> 주소 변환
  Future<String> coordToAddress(double lat, double lon) async {
    if (_clientId.isEmpty || _clientSecret.isEmpty) {
      throw Exception(
          "API keys are not configured in .env or via --dart-define");
    }

    final response = await http.get(
      Uri.parse(
          'https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$lon,$lat&output=json'),
      headers: {
        // ⭐ 오류 수정: id, secret -> _clientId, _clientSecret
        'X-NCP-APIGW-API-KEY-ID': _clientId,
        'X-NCP-APIGW-API-KEY': _clientSecret,
      },
    );

    // 디버깅 로그 (기존과 동일)
    if (kDebugMode) {
      print('--- 네이버 Reverse Geocoding 응답 ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${utf8.decode(response.bodyBytes)}');
      print('----------------------------------');
    }

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['status']['code'] == 0 && data['results'].isNotEmpty) {
        final region = data['results'][0]['region'];
        final area1 = region['area1']?['name'] ?? '';
        final area2 = region['area2']?['name'] ?? '';
        final area3 = region['area3']?['name'] ?? '';

        if (area1.isNotEmpty || area2.isNotEmpty || area3.isNotEmpty) {
          return '$area1 $area2 $area3'.trim();
        } else {
          return '상세 주소 정보를 찾을 수 없습니다.';
        }
      }
      return '주소를 찾을 수 없습니다. (응답 코드: ${data['status']?['code']})';
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['error']?['message'] ?? response.body;
      if (kDebugMode) {
        print('--- 네이버 API 오류 ---');
        print('Status Code: ${response.statusCode}');
        print('Error Body: ${response.body}');
        print('---------------------');
      }
      throw Exception('주소 변환 실패: $errorMessage');
    }
  }
}

