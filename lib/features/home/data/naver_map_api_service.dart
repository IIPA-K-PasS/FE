import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// 주소 검색 결과를 담을 간단한 모델
class Address {
  final String roadAddress;
  final String jibunAddress;

  Address({required this.roadAddress, required this.jibunAddress});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      roadAddress: json['roadAddress'] ?? '',
      jibunAddress: json['jibunAddress'] ?? '',
    );
  }
}

class NaverMapApiService {
  final String? _clientId = dotenv.env['NAVER_CLIENT_ID'];
  final String? _clientSecret = dotenv.env['NAVER_CLIENT_SECRET'];

  // Geocoding: 주소 검색
  Future<List<Address>> searchAddress(String query) async {
    if (_clientId == null || _clientSecret == null) {
      throw Exception("API keys are not configured in .env file");
    }

    final response = await http.get(
      Uri.parse('https://maps.apigw.ntruss.com/map-geocode/v2/geocode?query=$query'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': _clientId,
        'X-NCP-APIGW-API-KEY': _clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['addresses'] != null) {
        return (data['addresses'] as List).map((addr) => Address.fromJson(addr)).toList();
      }
      return [];
    } else {
      throw Exception('Failed to load addresses');
    }
  }

  // Reverse Geocoding: 좌표 -> 주소 변환
  Future<String> coordToAddress(double lat, double lon) async {
    if (_clientId == null || _clientSecret == null) {
      throw Exception("API keys are not configured in .env file");
    }

    final response = await http.get(
      Uri.parse('https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$lon,$lat&output=json'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': _clientId,
        'X-NCP-APIGW-API-KEY': _clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status']['code'] == 0 && data['results'].isNotEmpty) {
        final region = data['results'][0]['region'];
        return '${region['area1']['name']} ${region['area2']['name']} ${region['area3']['name']}';
      }
      return '주소를 찾을 수 없습니다.';
    } else {
      // API 호출 실패 시, 서버로부터 받은 실제 응답 내용을 출력합니다.
      // 이렇게 하면 인증 실패인지, 쿼리 문제인지 정확히 알 수 있습니다.
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['error']?['message'] ?? response.body;

      // 디버그 콘솔에 상세 오류 출력
      if (kDebugMode) {
        print('--- 네이버 API 오류 ---');
        print('Status Code: ${response.statusCode}');
        print('Error Body: ${response.body}');
        print('---------------------');
      }

      // 사용자에게 보여줄 예외 메시지
      throw Exception('주소 변환 실패: $errorMessage');
    }
  }
}