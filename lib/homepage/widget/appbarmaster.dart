// import 'package:fridayonline/homepage/widget/cartbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/theme_color.dart';

PreferredSize appBarTitleMaster(String title) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: MediaQuery(
        data: MediaQuery.of(Get.context!)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: AppBar(
          leading: const BackButton(color: Colors.white),
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: true,
          backgroundColor: theme_color_df,
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'notoreg',
                fontWeight: FontWeight.bold),
          ),
        ),
      ));
}
