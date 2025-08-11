// ignore_for_file: non_constant_identifier_names

// import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../service/languages/multi_languages.dart';
import 'show_case_my_homepage.dart';

class ShowCaseHome extends StatelessWidget {
  const ShowCaseHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ChangeLanguage = MultiLanguages.of(context)!;
    return Scaffold(
      body: ShowCaseWidget(
        onFinish: () {
          print('out show case');
        },
        onStart: (index, key) {
          //log('onStart: $index, $key');
        },
        onComplete: (index, key) {
          //log('onComplete: $index, $key');
        },
        enableAutoScroll: true,
        scrollDuration: Duration(seconds: 1),
        blurValue: 0.1,
        builder: (context) =>
            ShowCaseMyHomePage(ChangeLanguage: ChangeLanguage),
        autoPlayDelay: const Duration(seconds: 3),
      ),
    );
  }
}
