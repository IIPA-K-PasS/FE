import 'package:flutter/material.dart';

class SlideRoute extends PageRouteBuilder {
  final Widget page;
  final Offset beginOffset; // 시작 위치 (예: Offset(1.0, 0.0)은 오른쪽에서 시작)

  SlideRoute({
    required this.page,
    this.beginOffset = const Offset(1.0, 0.0), // 기본값: 오른쪽에서 시작 (x: 1.0, y: 0.0)
  }) : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) {
      // Tween을 사용하여 시작 위치(begin)에서 끝 위치(end)까지의 애니메이션을 정의합니다.
      var begin = beginOffset; // 예를 들어 오른쪽에서 들어오면 (1.0, 0.0)
      var end = Offset.zero; // 최종 위치는 (0.0, 0.0) 즉, 화면 중앙
      var curve = Curves.ease; // 애니메이션 곡선

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      // SlideTransition 위젯을 사용하여 위치 애니메이션을 적용합니다.
      return SlideTransition(
        position: animation.drive(tween), // animation 값을 tween에 연결
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 600),
  );
}