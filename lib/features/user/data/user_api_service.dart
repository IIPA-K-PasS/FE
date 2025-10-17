import 'package:flutter/foundation.dart';
import '../../../services/api_client.dart';
import '../../../config/api_config.dart';
import 'models/user_models.dart';

class UserApiService {
  /// GET /user - 현재 로그인된 유저 정보 조회
  static Future<UserInfo?> fetchUserInfo() async {
    try {
      debugPrint('[UserAPI] Fetching user info...');
      final response = await ApiClient.dio.get(ApiConfig.user);

      debugPrint('[UserAPI] Response status: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final userInfoResponse =
            UserInfoResponse.fromJson(response.data as Map<String, dynamic>);

        if (userInfoResponse.isSuccess) {
          debugPrint(
              '[UserAPI] ✅ User info fetched: ${userInfoResponse.result.nickname}');
          return userInfoResponse.result;
        } else {
          debugPrint(
              '[UserAPI] API returned isSuccess=false: ${userInfoResponse.message}');
          return null;
        }
      } else {
        debugPrint('[UserAPI] Failed: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('[UserAPI][ERROR] fetchUserInfo failed: $e');
      debugPrint('[UserAPI][ERROR] StackTrace: $stackTrace');
      return null;
    }
  }

  /// PATCH /user/profile - 닉네임 수정
  static Future<bool> updateNickname(String nickname) async {
    try {
      debugPrint('[UserAPI] Updating nickname to: $nickname');
      final request = UpdateNicknameRequest(nickname: nickname);

      final response = await ApiClient.dio.patch(
        ApiConfig.userProfile,
        data: request.toJson(),
      );

      debugPrint('[UserAPI] Response status: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final updateResponse = UpdateNicknameResponse.fromJson(
            response.data as Map<String, dynamic>);

        if (updateResponse.isSuccess) {
          debugPrint(
              '[UserAPI] ✅ Nickname updated: ${updateResponse.result.nickname}');
          return true;
        } else {
          debugPrint(
              '[UserAPI] API returned isSuccess=false: ${updateResponse.message}');
          return false;
        }
      } else {
        debugPrint('[UserAPI] Failed: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('[UserAPI][ERROR] updateNickname failed: $e');
      debugPrint('[UserAPI][ERROR] StackTrace: $stackTrace');
      return false;
    }
  }

  /// GET /user/bookmarks - 내가 찜한 꿀팁 조회
  static Future<List<BookmarkedTip>> fetchBookmarks() async {
    try {
      debugPrint('[UserAPI] Fetching bookmarked tips...');
      final response = await ApiClient.dio.get(ApiConfig.userBookmarks);

      debugPrint('[UserAPI] Response status: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final bookmarksResponse = UserBookmarksResponse.fromJson(
            response.data as Map<String, dynamic>);

        if (bookmarksResponse.isSuccess) {
          debugPrint(
              '[UserAPI] ✅ Fetched ${bookmarksResponse.result.length} bookmarked tips');
          return bookmarksResponse.result;
        } else {
          debugPrint(
              '[UserAPI] API returned isSuccess=false: ${bookmarksResponse.message}');
          return [];
        }
      } else {
        debugPrint('[UserAPI] Failed: ${response.statusCode}');
        return [];
      }
    } catch (e, stackTrace) {
      debugPrint('[UserAPI][ERROR] fetchBookmarks failed: $e');
      debugPrint('[UserAPI][ERROR] StackTrace: $stackTrace');
      return [];
    }
  }

  /// GET /user/challenges - 완료한 챌린지 조회
  static Future<List<CompletedChallenge>> fetchCompletedChallenges() async {
    try {
      debugPrint('[UserAPI] Fetching completed challenges...');
      final response = await ApiClient.dio.get(ApiConfig.userChallenges);

      debugPrint('[UserAPI] Response status: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final challengesResponse = UserChallengesResponse.fromJson(
            response.data as Map<String, dynamic>);

        if (challengesResponse.isSuccess) {
          debugPrint(
              '[UserAPI] ✅ Fetched ${challengesResponse.result.length} completed challenges');
          return challengesResponse.result;
        } else {
          debugPrint(
              '[UserAPI] API returned isSuccess=false: ${challengesResponse.message}');
          return [];
        }
      } else {
        debugPrint('[UserAPI] Failed: ${response.statusCode}');
        return [];
      }
    } catch (e, stackTrace) {
      debugPrint('[UserAPI][ERROR] fetchCompletedChallenges failed: $e');
      debugPrint('[UserAPI][ERROR] StackTrace: $stackTrace');
      return [];
    }
  }
}

