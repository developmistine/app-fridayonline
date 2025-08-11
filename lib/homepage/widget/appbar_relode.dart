import 'package:fridayonline/homepage/widget/cartbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/app_controller.dart';
// import '../point_rewards/point_rewards_coupon.dart';
import '../theme/theme_color.dart';

PreferredSize AppBarRelodeMaster(String Titles, String paramtest) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: MediaQuery(
        data: MediaQuery.of(Get.context!)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            color: Colors.white,
            onPressed: () {
              Get.find<AppController>().setCurrentNavInget(3);
              Get.toNamed(paramtest, parameters: {'changeView': '3'});
            },
          ),
          centerTitle: true,
          backgroundColor: theme_color_df,
          title: Text(
            Titles,
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
      ));
}
