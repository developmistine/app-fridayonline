import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';

Widget arrowToTop(
    {required ScrollController scrCtrl, required bool isShowArrow}) {
  return TweenAnimationBuilder(
    duration: const Duration(milliseconds: 300),
    tween: ColorTween(
      begin: Colors.transparent,
      end:
          isShowArrow ? themeColorDefault.withOpacity(0.6) : Colors.transparent,
    ),
    builder: (context, Color? color, child) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: isShowArrow ? 1.0 : 0.0,
          child: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              print('test');
              if (!isShowArrow) return;
              scrCtrl.animateTo(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
          ),
        ),
      );
    },
  );
}
