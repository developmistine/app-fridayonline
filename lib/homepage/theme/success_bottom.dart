import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../controller/return_product_controller.dart';
import '../return_product/order_history_return_product.dart';
import 'theme_color.dart';

successBottom(BuildContext context, String nameBtn) {
  return showMaterialModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      builder: (builder) {
        Widget elevatedButton = ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: theme_color_df),
            onPressed: () {
              Get.find<ReturnProductController>().fetchHistoryReturnAll();
              Get.off(() => const OrderHistoryReturnProduct());
            },
            child: Text(nameBtn));
        return WillPopScope(
            onWillPop: () async => false,
            child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1)),
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                          width: 160,
                          height: 160,
                          'assets/images/cart/success_lottie.json'),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                        child: Text(
                          textAlign: TextAlign.center,
                          'บันทึกรายการสั่งซื้อสำเร็จ', //'บันทึกการสั่งซื้อสำเร็จ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(width: 280, child: elevatedButton),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )));
      });
}
