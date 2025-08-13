// import 'package:fridayonline/homepage/theme/constants.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard(
      {super.key,
      required this.width,
      required this.height,
      required this.radius,
      this.color});
  final double width;
  final double height;
  final double radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor:
          color != null ? color! : themeColorDefault.withOpacity(0.7),
      baseColor: color != null
          ? color!.withOpacity(0.4)
          : themeColorDefault.withOpacity(0.4),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
