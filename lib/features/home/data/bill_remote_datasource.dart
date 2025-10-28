import 'dart:convert';
import 'package:flutter/foundation.dart'; // 디버깅 프린트를 위해 import
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../config/api_config.dart';
// BillResponseModel import 경로를 models 폴더로 수정
import 'bill_response_model.dart';

// 실제 API 통신을 담당하는 클래스입니다.
class BillRemoteDataSource {
  static String get _baseUrl => ApiConfig.baseUrl;
  final _storage = const FlutterSecureStorage();

  Future<BillResponseModel> uploadBill({
    required String billType,
    required XFile billImage,
  }) async {
    final String? jwtToken = await _storage.read(key: 'access_token');

    if (jwtToken == null || jwtToken.isEmpty) {
      throw Exception('Access Token not found. Please log in.');
    }

    // ApiConfig에서 경로를 가져오도록 수정
    final uri = Uri.parse('$_baseUrl/api/bills/ocr');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $jwtToken';
    // Content-Type 헤더는 MultipartRequest가 자동으로 설정하므로 제거해도 괜찮습니다.
    // request.headers['Content-Type'] = 'multipart/form-data';

    request.fields['billType'] = billType;
    request.files.add(
      await http.MultipartFile.fromPath(
        'billImage', // 백엔드 API에서 받는 파일 필드 이름 확인 필요
        billImage.path,
        // 파일 확장자에 따라 contentType을 동적으로 설정하거나, 서버에서 허용하는 타입으로 지정
        contentType: MediaType('image', billImage.path.split('.').last), // 예: 'jpeg' 또는 'png'
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // ⭐ --- 디버깅 코드 추가 --- ⭐
      if (kDebugMode) {
        print('--- Bill OCR API 응답 ---');
        print('Request URL: ${request.url}');
        print('Request Headers: ${request.headers}');
        print('Request Fields: ${request.fields}');
        print('Status Code: ${response.statusCode}');
        // UTF-8로 디코딩하여 한글 깨짐 방지
        try {
          print('Response Body: ${utf8.decode(response.bodyBytes)}');
        } catch (e) {
          print('Response Body (raw): ${response.body}'); // 디코딩 실패 시 원본 출력
        }
        print('------------------------');
      }
      // ⭐ --- 디버깅 코드 끝 --- ⭐

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        // 모델 클래스 이름 확인 (BillResponseModel)
        return BillResponseModel.fromJson(decodedData);
      } else {
        // API 호출 실패 시 오류 메시지 포함 (UTF-8 디코딩)
        throw Exception(
            'Failed to upload bill. Status: ${response.statusCode}, Body: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      // 네트워크 오류 등 예외 처리
      // 디버깅을 위해 에러 로그 추가
      if (kDebugMode) {
        print('Bill OCR API 호출 중 오류 발생: $e');
      }
      throw Exception('An error occurred while uploading bill: $e');
    }
  }
}

