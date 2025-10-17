import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import 'token_storage.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: ApiConfig.defaultHeaders,
    ),
  )..interceptors.add(_AuthInterceptor());
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint('🔑 [API Request] ${options.method} ${options.path}');
      debugPrint('🔑 [Access Token Only] $token');
      debugPrint('🔑 [For Swagger] Bearer $token');
    } else {
      debugPrint('⚠️ [API Request] ${options.method} ${options.path} - No token!');
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // 현재는 refresh API가 없으므로 강제 로그아웃 플로우 권장.
      debugPrint('Unauthorized - access token may be expired.');
    }
    super.onError(err, handler);
  }
}


