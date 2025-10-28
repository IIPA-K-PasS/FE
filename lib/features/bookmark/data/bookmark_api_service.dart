import 'package:flutter/foundation.dart';
import '../../../services/api_client.dart';
import '../../../config/api_config.dart';
import '../../user/data/models/user_models.dart';

class BookmarkApiService {
  /// POST /bookmark - 특정 꿀팁에 북마크 요청 또는 취소하는 API
  static Future<bool> toggleBookmark(int tipId, bool isBookmarked) async {
    try {
      debugPrint('[BookmarkAPI] Toggling bookmark for tipId: $tipId, isBookmarked: $isBookmarked');
      
      final request = BookmarkRequest(
        tipId: tipId,
        isBookmarked: isBookmarked,
      );

      final response = await ApiClient.dio.post(
        ApiConfig.bookmark,
        data: request.toJson(),
      );

      debugPrint('[BookmarkAPI] Response status: ${response.statusCode}');
      debugPrint('[BookmarkAPI] Raw response data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final bookmarkResponse = BookmarkResponse.fromJson(
            response.data as Map<String, dynamic>);

        debugPrint('[BookmarkAPI] Parsed isSuccess: ${bookmarkResponse.isSuccess}');
        debugPrint('[BookmarkAPI] Parsed code: ${bookmarkResponse.code}');
        debugPrint('[BookmarkAPI] Parsed message: ${bookmarkResponse.message}');

        if (bookmarkResponse.isSuccess) {
          debugPrint('[BookmarkAPI] ✅ Bookmark ${isBookmarked ? 'added' : 'removed'} successfully');
          return true;
        } else {
          debugPrint('[BookmarkAPI] API returned isSuccess=false: ${bookmarkResponse.message}');
          return false;
        }
      } else {
        debugPrint('[BookmarkAPI] Failed: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('[BookmarkAPI][ERROR] toggleBookmark failed: $e');
      debugPrint('[BookmarkAPI][ERROR] StackTrace: $stackTrace');
      return false;
    }
  }

  /// 북마크 추가
  static Future<bool> addBookmark(int tipId) async {
    return await toggleBookmark(tipId, true);
  }

  /// 북마크 삭제
  static Future<bool> removeBookmark(int tipId) async {
    return await toggleBookmark(tipId, false);
  }
}
