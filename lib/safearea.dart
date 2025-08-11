import 'dart:io';

import 'package:flutter/material.dart';

class SafeAreaProvider extends StatelessWidget {
  const SafeAreaProvider({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: Platform.isAndroid ? true : false,
      child: child,
    );
  }
}
