// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../service/languages/multi_languages.dart';
import '../../category/category_page/category_list_product.dart';

class ShowCaseCategoryProductHome extends StatelessWidget {
  const ShowCaseCategoryProductHome({Key? key}) : super(key: key);

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
        scrollDuration: const Duration(seconds: 1),
        blurValue: 0.1,
        builder: (context) =>
            ShowCaseMylistCategory(ChangeLanguage: ChangeLanguage),
        autoPlayDelay: const Duration(seconds: 3),
      ),
    );
  }
}
