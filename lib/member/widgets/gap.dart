import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap({super.key, required this.height});
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.grey[100],
    );
  }
}
