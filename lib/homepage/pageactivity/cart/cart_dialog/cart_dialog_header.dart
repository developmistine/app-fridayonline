import 'package:fridayonline/controller/cart/cart_cheer_controller.dart';
import 'package:fridayonline/controller/home/home_controller.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

ProductFromBanner bannerProduct = Get.find<ProductFromBanner>();
cartDailogHeader(BuildContext ctx, CheerCartCtr cheer) {
  return MediaQuery(
    data: MediaQuery.of(ctx).copyWith(textScaler: const TextScaler.linear(1.0)),
    child: AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
      titlePadding: const EdgeInsets.all(0),
      title: MediaQuery(
        data: MediaQuery.of(ctx)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Container(
          height: 80,
          width: 400,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35.0),
                topRight: Radius.circular(35.0)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(41, 0, 0, 0),
                offset: Offset(0.0, 4.0),
                blurRadius: 1,
                spreadRadius: 0.8,
              ), //BoxShadow
            ],
            color: theme_color_df,
          ),
          child: Center(
              child: Image.asset(
            'assets/images/logo.png',
            width: 120,
          )),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(cheer.conditions!.popUp.title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 4,
          ),
          const Text(
            'เพื่อได้',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(cheer.conditions!.popUp.subtitle,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          const SizedBox(
            height: 2,
          ),
          Text(cheer.conditions!.popUp.description,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          Container(
              width: Get.width * 0.8,
              height: 50,
              color: Colors.transparent,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: theme_color_df),
                  onPressed: () {
                    Get.back(result: true);
                  },
                  child: const Text(
                    'สั่งซื้อเพิ่ม',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ))),
          const SizedBox(
            height: 4,
          ),
          InkWell(
              onTap: () {
                Get.back(result: false);
              },
              child:
                  const Text('ไม่สนใจ', style: TextStyle(color: Colors.grey)))
        ],
      ),
    ),
  );
}
