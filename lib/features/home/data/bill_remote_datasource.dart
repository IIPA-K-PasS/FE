import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../config/api_config.dart';
import '../data/bill_response_model.dart';

// 실제 API 통신을 담당하는 클래스입니다.
class BillRemoteDataSource {
  // ApiConfig에서 baseUrl을 가져옵니다
  static String get _baseUrl => ApiConfig.baseUrl;

  Future<BillResponseModel> uploadBill({
    required String billType,
    required XFile billImage,
  }) async {
    // TODO: 실제 JWT 토큰을 안전한 곳(Secure Storage 등)에서 가져오세요.
    const String jwtToken = 'YOUR_JWT_TOKEN_HERE';

    final uri = Uri.parse(_baseUrl);
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $jwtToken';
    request.headers['Content-Type'] = 'multipart/form-data';

    request.fields['billType'] = billType;
    request.files.add(
      await http.MultipartFile.fromPath(
        'billImage',
        billImage.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        return BillResponseModel.fromJson(decodedData);
      } else {
        throw Exception(
            'Failed to upload bill. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
