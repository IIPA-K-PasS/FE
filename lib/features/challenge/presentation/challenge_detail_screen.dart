import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../domain/challenge_entity.dart';
import 'challenge_proof_preview_screen.dart';

class ChallengeDetailScreen extends StatelessWidget {
  final Challenge challenge;

  const ChallengeDetailScreen({super.key, required this.challenge});

  // 인증샷 선택 및 확인 화면 이동 로직 (이전과 동일)
  Future<void> _pickImageAndShowPreview(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null && context.mounted) {
        final result = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (context) => ChallengeProofPreviewScreen(imageFile: pickedFile),
          ),
        );

        if (result == true && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${challenge.title} 인증 완료! ${challenge.points}P 획득!')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('카메라 실행 중 오류 발생: $e')),
        );
      }
    }
  }

  // 카테고리별 아이콘 반환 함수 (ChallengeScreen에서 가져옴)
  IconData _getIconForCategory(String category) {
    switch (category) {
      case '자원 순환':
        return Icons.recycling;
      case '에너지 절약':
        return Icons.power_off;
      default:
        return Icons.eco;
    }
  }

  // 카테고리별 아이콘 색상 반환 함수 (ChallengeScreen에서 가져옴)
  Color _getIconColorForCategory(String category) {
    switch (category) {
      case '자원 순환':
        return Colors.blue.shade700;
      case '에너지 절약':
        return Colors.amber.shade800;
      default:
        return Colors.green.shade700;
    }
  }

  // ⭐ 변경점: 문장 분리 로직 추가 (간단 버전)
  // 마침표(.), 느낌표(!), 물음표(?) 뒤 공백을 기준으로 문장을 나눕니다.
  // 좀 더 복잡한 문장 구조에는 완벽하지 않을 수 있습니다.
  List<String> _splitIntoSentences(String text) {
    // 먼저 기존 줄바꿈('\n')을 다른 구분자로 임시 대체
    String tempText = text.replaceAll('\\n', '||');
    // 마침표, 느낌표, 물음표 뒤 공백을 기준으로 나누고, 임시 구분자도 복원
    return tempText.split(RegExp(r'(?<=[.!?])\s+|\|\|'))
        .map((s) => s.trim()) // 각 문장 앞뒤 공백 제거
        .where((s) => s.isNotEmpty) // 빈 문장 제거
        .toList();
  }


  @override
  Widget build(BuildContext context) {
    // 테마 색상 및 아이콘 가져오기
    final Color themeColor = challenge.themeColor;
    final Color iconColor = _getIconColorForCategory(challenge.category);
    final IconData categoryIcon = _getIconForCategory(challenge.category);
    // 텍스트 색상 결정 (배경 밝기에 따라)
    final Color textColorOnTheme = themeColor.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;

    // ⭐ 변경점: 문장 분리 실행
    final List<String> benefitSentences = _splitIntoSentences(challenge.benefitDescription);

    return Scaffold(
      appBar: AppBar(
        title: Text(challenge.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬 기본
          children: [
            // 1. 상단 영역 디자인 개선 (기존과 동일)
            Container(
              height: 180,
              width: double.infinity,
              color: themeColor, // 챌린지 테마 배경색
              child: Stack( // 아이콘과 텍스트를 겹치도록 Stack 사용
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(categoryIcon, size: 150, color: textColorOnTheme),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(categoryIcon, size: 50, color: iconColor), // 카테고리 아이콘
                        const SizedBox(height: 8),
                        Text(
                          challenge.category, // 카테고리 텍스트
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColorOnTheme.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. 내용 영역
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리 텍스트 (기존과 동일)
                  Text(
                    challenge.category,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 챌린지 제목 (기존과 동일)
                  Text(
                    challenge.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 챌린지 설명 (기존과 동일)
                  Text(
                    challenge.description,
                    style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
                  ),

                  // 3. 구분선 추가 (기존과 동일)
                  const SizedBox(height: 24),
                  const Divider(thickness: 1),
                  const SizedBox(height: 24),

                  // 4. '작은 행동이 만드는 변화' 섹션 (기존과 동일)
                  const Text(
                    '이 작은 행동이 만드는 변화',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ⭐ 변경점: 분리된 문장 리스트를 사용하여 UI 생성
                  ...benefitSentences.map((sentence) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0), // 항목 간 간격
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 위쪽 정렬
                        children: [
                          // 색상 원
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0), // 원 위치 미세 조정
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: themeColor.withOpacity(0.7), // 테마 색상 사용
                            ),
                          ),
                          const SizedBox(width: 12), // 원과 텍스트 사이 간격
                          // 설명 텍스트
                          Expanded(
                            child: Text(
                              sentence, // 분리된 문장 사용
                              style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 40),

                  // 인증샷 올리기 버튼 (기존과 동일)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImageAndShowPreview(context),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: Text('인증샷 올리기 (+${challenge.points}P)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

