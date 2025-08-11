// ignore_for_file: non_constant_identifier_names

// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../service/languages/multi_languages.dart';
import 'show_case_catelog_detail.dart';

class ShowCaseCatelogHome extends StatelessWidget {
  const ShowCaseCatelogHome({super.key, this.channel});
  final channel;

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
            //log('onStart: $index, $key');
          },
          onComplete: (index, key) {
            //log('onComplete: $index, $key');
          },
          enableAutoScroll: true,
          scrollDuration: const Duration(seconds: 1),
          blurValue: 0.1,
          builder: (context) => ShowCaseCatelogDetail(
              ChangeLanguage: ChangeLanguage, channel: channel),
          autoPlayDelay: const Duration(seconds: 3),
        ),
      ),
    );
  }
}
