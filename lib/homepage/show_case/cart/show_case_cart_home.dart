// ignore_for_file: non_constant_identifier_names

// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../service/languages/multi_languages.dart';
import 'show_case_cart_activity.dart';

class ShowCaseCartHome extends StatelessWidget {
  const ShowCaseCartHome({super.key});

  @override
  Widget build(BuildContext context) {
    var ChangeLanguage = MultiLanguages.of(context)!;
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Scaffold(
        body: ShowCaseWidget(
          onFinish: () {
            print('out show case');
          },
          onStart: (index, key) {
            //  log('onStart: $index, $key');
          },
          onComplete: (index, key) {
            // log('onComplete: $index, $key');
          },
          enableAutoScroll: true,
          scrollDuration: const Duration(seconds: 1),
          blurValue: 0.1,
          builder: (context) => ShowCaseCart(
            ChangeLanguage: ChangeLanguage,
          ),
          autoPlayDelay: const Duration(seconds: 3),
        ),
      ),
    );
  }
}
