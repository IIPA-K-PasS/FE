import 'package:flutter/material.dart';
import 'green_market_button.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import '../../../../services/kakao_service.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 섹션
          Row(
            children: [
              // 프로필 이미지 (CircleAvatar 사용)
              FutureBuilder<kakao.User?>(
                future: KakaoService.getMeSafe(),
                builder: (context, snapshot) {
                  final profileUrl = snapshot.data?.kakaoAccount?.profile?.profileImageUrl;
                  return Semantics(
                    label: '프로필 이미지',
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.teal[100],
                      backgroundImage: profileUrl != null ? NetworkImage(profileUrl) : null,
                      child: profileUrl == null
                          ? Text(
                              'Me',
                              style: TextStyle(
                                color: Colors.teal[800],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
              
              const SizedBox(width: 16),
              
              // 사용자 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<kakao.User?>(
                      future: KakaoService.getMeSafe(),
                      builder: (context, snapshot) {
                        final nickname = snapshot.data?.kakaoAccount?.profile?.nickname ?? '에코세이버';
                        return Text(
                          nickname,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: FutureBuilder<kakao.User?>(
                            future: KakaoService.getMeSafe(),
                            builder: (context, snapshot) {
                              final email = snapshot.data?.kakaoAccount?.email ?? '';
                              return Text(
                                email.isEmpty ? ' ' : email,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          ),
                        ),
                        // 프로필 수정 버튼
                        Semantics(
                          label: '프로필 수정 버튼',
                          button: true,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // TODO: 프로필 수정 기능 구현
                                print('프로필 수정 버튼 클릭됨');
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Text(
                                    '프로필 수정',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
          
          //const SizedBox(height: 20),
          
          // 포인트 섹션
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              //color: Colors.teal[50],
              borderRadius: BorderRadius.circular(12),
              //border: Border.all(color: Colors.teal[200]!, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '나의 그린 포인트',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.teal[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '1,250 P',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.teal[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
              ],
            ),
          ),
          const GreenMarketButton()
        ],
      ),
    );
  }
}
