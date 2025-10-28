import 'package:flutter/material.dart';

// 챌린지 데이터를 나타내는 클래스
class Challenge {
  final String id;
  final String title;
  final String category; // 예: "자원 순환", "에너지 절약"
  final String description;
  final String benefitDescription; // 작은 행동이 만드는 변화 설명
  final int points; // 인증 시 획득 포인트
  final Color themeColor; // 카드 배경 등에 사용할 테마 색상

  Challenge({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.benefitDescription,
    required this.points,
    required this.themeColor,
  });
}

// 예시 챌린지 데이터 (나중에는 API로부터 받아옵니다)
final List<Challenge> dummyChallenges = [
  Challenge(
    id: 'recycle01',
    title: '페트병 라벨 떼고 버리기',
    category: '자원 순환',
    description: '투명 페트병의 비닐 라벨을 깨끗하게 제거한 후, 찌그러트려 뚜껑을 닫아 분리배출하는 챌린지입니다.',
    benefitDescription:
    '라벨을 떼면 페트병이 고품질 원료로 재탄생하여 연간 10만 톤의 플라스틱을 재활용할 수 있어요.\n이는 자동차 2만 대가 1년간 내뿜는 탄소 배출량을 줄이는 것과 같은 효과랍니다.',
    points: 20,
    themeColor: Colors.blue[100]!,
  ),
  Challenge(
    id: 'poweroff01',
    title: '안 쓰는 코드 뽑기',
    category: '에너지 절약',
    description: '사용하지 않는 전자제품의 플러그를 뽑아 불필요한 \'대기전력\' 소모를 막는 챌린지입니다.',
    benefitDescription:
    '대기전력은 가정 전체 전기요금의 최대 10%를 차지하는 숨은 주범이에요.\nTV 셋톱박스, 컴퓨터 플러그만 뽑아도 연간 3만원 이상을 아낄 수 있답니다.',
    points: 10,
    themeColor: Colors.yellow[100]!,
  ),
  // 여기에 더 많은 챌린지 추가 가능
];

