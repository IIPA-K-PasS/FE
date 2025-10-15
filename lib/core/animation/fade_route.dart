import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({required this.page})
      : super(
    // 전환될 페이지를 지정합니다.
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,

    // 트랜지션(애니메이션) 효과를 정의합니다.
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
    // FadeTransition 위젯을 사용하여 투명도 애니메이션을 적용합니다.
    FadeTransition(
      opacity: animation, // animation 값(0.0 -> 1.0)에 따라 투명도가 변합니다.
      child: child,
    ),

    transitionDuration: const Duration(milliseconds: 350),
  );
}