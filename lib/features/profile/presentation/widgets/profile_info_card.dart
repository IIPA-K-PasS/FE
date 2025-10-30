import 'package:flutter/material.dart';
import 'green_market_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../user/data/user_api_service.dart';
import '../../../user/data/models/user_models.dart';

class ProfileInfoCard extends StatefulWidget {
  const ProfileInfoCard({super.key});

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  UserInfo? _userInfo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    setState(() => _loading = true);
    final userInfo = await UserApiService.fetchUserInfo();
    if (mounted) {
      setState(() {
        _userInfo = userInfo;
        _loading = false;
      });
    }
  }

  void _showNicknameEditDialog() {
    final controller = TextEditingController(text: _userInfo?.nickname ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('닉네임 수정'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '새 닉네임',
            hintText: '변경할 닉네임을 입력하세요',
            border: OutlineInputBorder(),
          ),
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newNickname = controller.text.trim();
              if (newNickname.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('닉네임을 입력해주세요')),
                );
                return;
              }
              Navigator.pop(context);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );
              try {
                final success = await UserApiService.updateNickname(newNickname);
                if (!mounted) return;
                Navigator.of(context, rootNavigator: true).pop();
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('닉네임이 변경되었습니다')),
                  );
                  _loadUserInfo();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('닉네임 변경에 실패했습니다')),
                  );
                }
              } catch (e) {
                if (!mounted) return;
                Navigator.of(context, rootNavigator: true).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('에러 발생: $e')),
                );
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  Future<int> _getPoint() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('green_point_override') ?? 12000;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _loading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            )
          : _userInfo == null
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('사용자 정보를 불러올 수 없습니다'),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 프로필 섹션
                    Row(
                      children: [
                        Semantics(
                          label: '프로필 이미지',
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.teal[100],
                            backgroundImage: _userInfo!.profileImageUrl != null &&
                                    _userInfo!.profileImageUrl!.isNotEmpty
                                ? NetworkImage(_userInfo!.profileImageUrl!)
                                : null,
                            child: _userInfo!.profileImageUrl == null ||
                                    _userInfo!.profileImageUrl!.isEmpty
                                ? Text(
                                    _userInfo!.nickname.isNotEmpty
                                        ? _userInfo!.nickname[0].toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      color: Colors.teal[800],
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userInfo!.nickname,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _userInfo!.email,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Semantics(
                                    label: '프로필 수정 버튼',
                                    button: true,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: _showNicknameEditDialog,
                                        borderRadius: BorderRadius.circular(16),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            child: Text(
                                              '프로필 수정',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // 포인트 섹션
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '나의 그린 포인트',
                            style: TextStyle(
                              color: Color(0xFF00796B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: FutureBuilder<int>(
                                  future: _getPoint(),
                                  builder: (context, snapshot) {
                                    final value = snapshot.data ?? 12000;
                                    return Text(
                                      '${value.toStringAsFixed(0)} P',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                            color: Colors.teal[600],
                                            fontWeight: FontWeight.bold,
                                          ),
                                    );
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.notifications_none, color: Colors.teal, size: 28),
                                tooltip: '포인트 초기화(테스트)',
                                onPressed: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.remove('green_point_override');
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
