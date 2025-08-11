// ignore_for_file: non_constant_identifier_names

// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../service/languages/multi_languages.dart';
import 'show_case_search_product.dart';

class ShowCaseSearchHome extends StatelessWidget {
  const ShowCaseSearchHome({Key? key}) : super(key: key);

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
            ShowCaseSearchProduct(ChangeLanguage: ChangeLanguage),
        autoPlayDelay: const Duration(seconds: 3),
      ),
    );
  }
}
