import 'package:fridayonline/controller/reviews/revies_ctr.dart';
import 'package:fridayonline/homepage/review/review.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final ctr = Get.find<ReviewsCtr>();
successSentReview(context) async {
  return showMaterialModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      builder: (builder) {
        return WillPopScope(
            onWillPop: () async => false,
            child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => ctr.isLoading.value
                        ? SizedBox(
                            height: 355,
                            child: Lottie.asset(
                                width: 180, 'assets/images/loading_line.json'),
                          )
                        : ctr.success!.code != "100"
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 220,
                                    child: Lottie.asset(
                                        width: 180,
                                        'assets/images/warning_red.json'),
                                  ),
                                  Text(ctr.success!.message1,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: Get.width * 0.8,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Get.back(
                                            closeOverlays: true,
                                          );
                                        },
                                        child: const Text('ตกลง')),
                                  ),
                                  const SizedBox(
                                    height: 28,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 220,
                                    child: Lottie.asset(
                                        width: 180,
                                        'assets/images/cart/success_lottie.json'),
                                  ),
                                  const Text('บันทึกรีวิวเรียบร้อยค่ะ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const Text(
                                      'ระบบจะทำการตรวจสอบ\nความเหมาะสมของเนื้อหา',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey)),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: Get.width * 0.8,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: theme_color_df),
                                        onPressed: () {
                                          Get.back(
                                              closeOverlays: true,
                                              result: true);
                                          Get.off(() => const Review(
                                                tabs: 1,
                                              ));
                                        },
                                        child: const Text(
                                          'ตกลง',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 28,
                                  ),
                                ],
                              )),
                  ],
                )));
      });
}
