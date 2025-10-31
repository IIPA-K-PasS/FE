import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. dotenv import 확인
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
  // 2. final 변수로 선언
  final String _clientId;
  final String _clientSecret;

  // 3. 생성자에서 하이브리드 로직을 직접 구현
  NaverMapApiService()
      : _clientId = const String.fromEnvironment('NAVER_CLIENT_ID').isEmpty
      ? dotenv.env['NAVER_CLIENT_ID'] ?? ''
      : const String.fromEnvironment('NAVER_CLIENT_ID'),
        _clientSecret =
        const String.fromEnvironment('NAVER_CLIENT_SECRET').isEmpty
            ? dotenv.env['NAVER_CLIENT_SECRET'] ?? ''
            : const String.fromEnvironment('NAVER_CLIENT_SECRET');

  // 4. _getEnv 헬퍼 함수 제거 (더 이상 필요 없음)
  // static String _getEnv(String key) { ... }

  // Geocoding: 주소 검색
  Future<List<Address>> searchAddress(String query) async {
    // 5. 키 유효성 검사 (isEmpty 사용)
    if (_clientId.isEmpty || _clientSecret.isEmpty) {
      throw Exception(
          "API keys are not configured in .env or via --dart-define");
    }
// ... (이하 동일)
    final response = await http.get(
      Uri.parse(
          'https://maps.apigw.ntruss.com/map-geocode/v2/geocode?query=$query'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': id,
        'X-NCP-APIGW-API-KEY': secret,
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
// ... (이하 동일)
    final response = await http.get(
      Uri.parse(
          'https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$lon,$lat&output=json'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': id,
        'X-NCP-APIGW-API-KEY': secret,
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

