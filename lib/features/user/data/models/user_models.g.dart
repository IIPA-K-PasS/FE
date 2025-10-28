// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoResponse _$UserInfoResponseFromJson(Map<String, dynamic> json) =>
    UserInfoResponse(
      isSuccess: json['isSuccess'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
      result: UserInfo.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserInfoResponseToJson(UserInfoResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'code': instance.code,
      'message': instance.message,
      'result': instance.result,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: (json['id'] as num).toInt(),
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      point: (json['point'] as num).toInt(),
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'email': instance.email,
      'profileImageUrl': instance.profileImageUrl,
      'point': instance.point,
    };

UpdateNicknameRequest _$UpdateNicknameRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateNicknameRequest(
      nickname: json['nickname'] as String,
    );

Map<String, dynamic> _$UpdateNicknameRequestToJson(
        UpdateNicknameRequest instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
    };

UpdateNicknameResponse _$UpdateNicknameResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateNicknameResponse(
      isSuccess: json['isSuccess'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
      result: UpdatedUser.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateNicknameResponseToJson(
        UpdateNicknameResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'code': instance.code,
      'message': instance.message,
      'result': instance.result,
    };

UpdatedUser _$UpdatedUserFromJson(Map<String, dynamic> json) => UpdatedUser(
      id: (json['id'] as num).toInt(),
      nickname: json['nickname'] as String,
    );

Map<String, dynamic> _$UpdatedUserToJson(UpdatedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
    };

UserBookmarksResponse _$UserBookmarksResponseFromJson(
        Map<String, dynamic> json) =>
    UserBookmarksResponse(
      isSuccess: json['isSuccess'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
      result: (json['result'] as List<dynamic>)
          .map((e) => BookmarkedTip.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserBookmarksResponseToJson(
        UserBookmarksResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'code': instance.code,
      'message': instance.message,
      'result': instance.result,
    };

BookmarkedTip _$BookmarkedTipFromJson(Map<String, dynamic> json) =>
    BookmarkedTip(
      tipId: (json['tipId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$BookmarkedTipToJson(BookmarkedTip instance) =>
    <String, dynamic>{
      'tipId': instance.tipId,
      'title': instance.title,
      'content': instance.content,
    };

UserChallengesResponse _$UserChallengesResponseFromJson(
        Map<String, dynamic> json) =>
    UserChallengesResponse(
      isSuccess: json['isSuccess'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
      result: (json['result'] as List<dynamic>)
          .map((e) => CompletedChallenge.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserChallengesResponseToJson(
        UserChallengesResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'code': instance.code,
      'message': instance.message,
      'result': instance.result,
    };

CompletedChallenge _$CompletedChallengeFromJson(Map<String, dynamic> json) =>
    CompletedChallenge(
      challengeId: (json['challengeId'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      rewardPoints: (json['rewardPoints'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$CompletedChallengeToJson(CompletedChallenge instance) =>
    <String, dynamic>{
      'challengeId': instance.challengeId,
      'title': instance.title,
      'description': instance.description,
      'rewardPoints': instance.rewardPoints,
      'imageUrl': instance.imageUrl,
    };

BookmarkRequest _$BookmarkRequestFromJson(Map<String, dynamic> json) =>
    BookmarkRequest(
      tipId: (json['tipId'] as num).toInt(),
      isBookmarked: json['isBookmarked'] as bool,
    );

Map<String, dynamic> _$BookmarkRequestToJson(BookmarkRequest instance) =>
    <String, dynamic>{
      'tipId': instance.tipId,
      'isBookmarked': instance.isBookmarked,
    };

BookmarkResponse _$BookmarkResponseFromJson(Map<String, dynamic> json) =>
    BookmarkResponse(
      isSuccess: json['isSuccess'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
      result: json['result'] as String,
    );

Map<String, dynamic> _$BookmarkResponseToJson(BookmarkResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'code': instance.code,
      'message': instance.message,
      'result': instance.result,
    };
