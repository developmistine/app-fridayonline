import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:flutter/material.dart';

import '../service/languages/multi_languages.dart';

class FridayMarket extends StatelessWidget {
  const FridayMarket({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleMaster(
          MultiLanguages.of(context)!.translate('yupin_market')),
      body: Container(),
    );
  }
}
