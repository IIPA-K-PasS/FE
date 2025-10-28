import 'package:json_annotation/json_annotation.dart';

part 'user_models.g.dart';

// ==================== GET /user ====================

@JsonSerializable()
class UserInfoResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final UserInfo result;

  UserInfoResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UserInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoResponseToJson(this);
}

@JsonSerializable()
class UserInfo {
  final int id;
  final String nickname;
  final String email;
  final String? profileImageUrl;  // nullable로 변경
  final int point;

  UserInfo({
    required this.id,
    required this.nickname,
    required this.email,
    this.profileImageUrl,  // required 제거
    required this.point,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

// ==================== PATCH /user/profile ====================

@JsonSerializable()
class UpdateNicknameRequest {
  final String nickname;

  UpdateNicknameRequest({required this.nickname});

  factory UpdateNicknameRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNicknameRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateNicknameRequestToJson(this);
}

@JsonSerializable()
class UpdateNicknameResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final UpdatedUser result;

  UpdateNicknameResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory UpdateNicknameResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateNicknameResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateNicknameResponseToJson(this);
}

@JsonSerializable()
class UpdatedUser {
  final int id;
  final String nickname;

  UpdatedUser({required this.id, required this.nickname});

  factory UpdatedUser.fromJson(Map<String, dynamic> json) =>
      _$UpdatedUserFromJson(json);
  Map<String, dynamic> toJson() => _$UpdatedUserToJson(this);
}

// ==================== GET /user/bookmarks ====================

@JsonSerializable()
class UserBookmarksResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final List<BookmarkedTip> result;

  UserBookmarksResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory UserBookmarksResponse.fromJson(Map<String, dynamic> json) =>
      _$UserBookmarksResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserBookmarksResponseToJson(this);
}

@JsonSerializable()
class BookmarkedTip {
  final int tipId;
  final String title;
  final String content;

  BookmarkedTip({
    required this.tipId,
    required this.title,
    required this.content,
  });

  factory BookmarkedTip.fromJson(Map<String, dynamic> json) =>
      _$BookmarkedTipFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkedTipToJson(this);
}

// ==================== GET /user/challenges ====================

@JsonSerializable()
class UserChallengesResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final List<CompletedChallenge> result;

  UserChallengesResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory UserChallengesResponse.fromJson(Map<String, dynamic> json) =>
      _$UserChallengesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserChallengesResponseToJson(this);
}

@JsonSerializable()
class CompletedChallenge {
  final int challengeId;
  final String title;
  final String description;
  final int rewardPoints;
  final String imageUrl;

  CompletedChallenge({
    required this.challengeId,
    required this.title,
    required this.description,
    required this.rewardPoints,
    required this.imageUrl,
  });

  factory CompletedChallenge.fromJson(Map<String, dynamic> json) =>
      _$CompletedChallengeFromJson(json);
  Map<String, dynamic> toJson() => _$CompletedChallengeToJson(this);
}

// ==================== POST /bookmark ====================

@JsonSerializable()
class BookmarkRequest {
  final int tipId;
  final bool isBookmarked;

  BookmarkRequest({
    required this.tipId,
    required this.isBookmarked,
  });

  factory BookmarkRequest.fromJson(Map<String, dynamic> json) =>
      _$BookmarkRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkRequestToJson(this);
}

@JsonSerializable()
class BookmarkResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final String result;

  BookmarkResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory BookmarkResponse.fromJson(Map<String, dynamic> json) =>
      _$BookmarkResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkResponseToJson(this);
}

