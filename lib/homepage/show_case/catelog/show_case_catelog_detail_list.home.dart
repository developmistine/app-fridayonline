// ignore_for_file: non_constant_identifier_names

// import 'dart:developer';
import 'package:fridayonline/safearea.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../service/languages/multi_languages.dart';
import 'show_case_catelog_detail_list.dart';

class ShowCaseCatelogdetailListHome extends StatelessWidget {
  const ShowCaseCatelogdetailListHome({super.key, this.channel});
  final channel;
  @override
  Widget build(BuildContext context) {
    var ChangeLanguage = MultiLanguages.of(context)!;
    return SafeAreaProvider(
      child: Scaffold(
        body: ShowCaseWidget(
          onFinish: () {
            print('out');
          },
          onStart: (index, key) {
            print('onStart: $index, $key');
          },
          onComplete: (index, key) {
            print('onComplete: $index, $key');
          },
          enableAutoScroll: true,
          scrollDuration: const Duration(seconds: 1),
          blurValue: 0.1,
          builder: (context) => ShowCaseCatelogDetailList(
              ChangeLanguage: ChangeLanguage, channel: channel),
          autoPlayDelay: const Duration(seconds: 3),
        ),
      ),
    );
  }
}
