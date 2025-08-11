import 'package:fridayonline/homepage/widget/cartbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/app_controller.dart';
import '../theme/theme_color.dart';

appBarTitleCart(String titles, String backPage) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50),
    child: MediaQuery(
      data: MediaQuery.of(Get.context!)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            if (backPage.toLowerCase() == 'home') {
              Get.find<AppController>().setCurrentNavInget(0);
              Get.toNamed('/backAppbarnotify', parameters: {'changeView': '0'});
            } else {
              Get.back();
            }
          },
        ),
        // iconTheme: const IconThemeData(
        //   color: Colors.white, //change your color here
        // ),
        centerTitle: true,
        backgroundColor: theme_color_df,
        title: Text(
          titles,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'notoreg',
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CartIconButton(),
          )
        ],
      ),
    ),
  );
}
