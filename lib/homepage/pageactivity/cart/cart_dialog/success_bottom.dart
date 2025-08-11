// import 'dart:convert';

import 'package:fridayonline/controller/badger/badger_controller.dart';
import 'package:fridayonline/controller/cart/cart_controller.dart';
import 'package:fridayonline/controller/cart/coupon_discount_controller.dart';
import 'package:fridayonline/controller/cart/dropship_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../controller/app_controller.dart';
import '../../../../controller/cart/save_order_controller.dart';
import '../../../../controller/home/home_controller.dart';
import '../../../../model/cart/dropship/dropship_confirm.dart';
import '../../../../model/cart/order_end_user.dart';
import '../../../../service/languages/multi_languages.dart';

SaveOrderController saveDirecsale = Get.find<SaveOrderController>();
SaveOrderDropship saveDropship = Get.find<SaveOrderDropship>();

successConfirmDialog(context, OrderEndUserClass orderTotal,
    DropshipConfirmOrder dataDropship) async {
  if (orderTotal.orderdetail.isNotEmpty &&
      dataDropship.orderCartList.isNotEmpty) {
    saveDirecsale.saveOrderCart(orderTotal.toJson());
    saveDropship.saveOrderCartDropship(dataDropship.toJson());
    //? กรณียืนยันทั้งสอง
    return showMaterialModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        builder: (builder) {
          return WillPopScope(
            onWillPop: () async => false,
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1)),
              child: GetBuilder<SaveOrderController>(builder: (dataSave) {
                return GetBuilder<SaveOrderDropship>(builder: (dataDropship) {
                  if (dataSave.isDataLoading.value ||
                      dataDropship.isDataLoading.value) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 355,
                          child: Lottie.asset(
                              width: 180, 'assets/images/loading_line.json'),
                        ),
                      ],
                    );
                  } else {
                    if (dataSave.itemsSaveOrder!.value.success == '1' &&
                        dataDropship.saveDropship!.code == '100') {
                      // ? กรณี confirm ทั้ง สอง
                      return popupSuccessAll(context);
                    } else {
                      //? กรณีที่เกิด ข้อผิดพลาด
                      return errorPopup(context,
                          dataSave.itemsSaveOrder!.value.description.msgAlert1);
                    }
                  }
                });
              }),
            ),
          );
        });
  } else if (orderTotal.orderdetail.isNotEmpty ||
      orderTotal.orderdetailB2C.isNotEmpty) {
    saveDirecsale.saveOrderCart(orderTotal.toJson());
    //? กรณียืนยันเฉพาะ Direct sale
    return showMaterialModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        builder: (builder) {
          return WillPopScope(
            onWillPop: () async => false,
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1)),
              child: GetBuilder<SaveOrderController>(builder: (dataSave) {
                if (dataSave.isDataLoading.value) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 355,
                        child: Lottie.asset(
                            width: 180, 'assets/images/loading_line.json'),
                      ),
                    ],
                  );
                } else {
                  if (dataSave.itemsSaveOrder!.value.success == '1') {
                    // ? กรณี confirm direct sale
                    return popupDirectSuccess(context, saveDirecsale);
                  } else {
                    //? กรณีที่เกิด ข้อผิดพลาด
                    return errorPopup(context,
                        dataSave.itemsSaveOrder!.value.description.msgAlert1);
                  }
                }
              }),
            ),
          );
        });
  } else if (dataDropship.orderCartList.isNotEmpty) {
    saveDropship.saveOrderCartDropship(dataDropship.toJson());
    //? กรณียืนยันเฉพาะ Dropship
    return showMaterialModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        builder: (builder) {
          return WillPopScope(
            onWillPop: () async => false,
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1)),
              child: GetBuilder<SaveOrderDropship>(builder: (dataDropship) {
                if (dataDropship.isDataLoading.value) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 355,
                        child: Lottie.asset(
                            width: 180, 'assets/images/loading_line.json'),
                      ),
                    ],
                  );
                } else {
                  if (dataDropship.saveDropship!.code == '100') {
                    // ? กรณี confirm Dropship
                    return popupSuccessAll(context);
                  } else {
                    //? กรณีที่เกิด ข้อผิดพลาด
                    return errorPopup(
                        context, dataDropship.saveDropship!.message1);
                  }
                }
              }),
            ),
          );
        });
  } else {
    //? กรณีเกิดข้อผิดพลาด
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
              child: errorPopup(
                  context, 'เกิดข้อผิดพลาดในการบันทึกรายการสั่งซื้อ')),
        );
      },
    );
  }
}

errorPopup(context, String mesError) {
  return MediaQuery(
    data:
        MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
            width: 160, height: 160, 'assets/images/cart/error_confirm.json'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
          child: Text(
            textAlign: TextAlign.center,
            mesError,
            style: TextStyle(fontWeight: boldText, fontSize: 18),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
              width: 280,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: theme_color_df),
                  onPressed: () async {
                    Get.offAllNamed('/backAppbarnotify',
                        parameters: {'changeView': '4'});
                    Get.find<AppController>().setCurrentNavInget(4);
                    Get.find<BadgerProfileController>().get_badger_profile();
                    await Get.find<FetchCartItemsController>()
                        .fetch_cart_items();
                    await Get.find<FetchCartDropshipController>()
                        .fetchCartDropship();
                  },
                  child: Text(
                    MultiLanguages.of(context)!.translate('alert_okay'),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ))),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    ),
  );
}

popupSuccessAll(context) {
  return MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(1.0)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
            width: 160, height: 160, 'assets/images/cart/success_lottie.json'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
          child: Text(
            textAlign: TextAlign.center,
            'บันทึกรายการสั่งซื้อสำเร็จ', //'บันทึกการสั่งซื้อสำเร็จ',
            style: TextStyle(fontWeight: boldText, fontSize: 18),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
              width: 280,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: theme_color_df),
                  onPressed: () async {
                    Get.offAllNamed('/backAppbarnotify',
                        parameters: {'changeView': '4'});
                    Get.find<AppController>().setCurrentNavInget(4);
                    Get.find<BadgerProfileController>().get_badger_profile();
                    Get.find<FetchCouponDiscount>().setEmptyCouponList();
                    await Get.find<FetchCartItemsController>()
                        .fetch_cart_items();
                    await Get.find<FetchCartDropshipController>()
                        .fetchCartDropship();
                  },
                  child: Text(
                    MultiLanguages.of(context)!.translate('alert_okay'),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ))),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    ),
  );
}

// Show confirm order direct sale
popupDirectSuccess(context, SaveOrderController dataSave) {
  return MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(1.0)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
            width: 230, height: 230, 'assets/images/cart/success_lottie.json'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
          child: Text(
            textAlign: TextAlign.center,
            dataSave.itemsSaveOrder!.value.description.msgAlert1,
            style: TextStyle(fontWeight: boldText, fontSize: 19),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
              width: 280,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: theme_color_df),
                  onPressed: () async {
                    Get.offAllNamed('/backAppbarnotify',
                        parameters: {'changeView': '4'});
                    Get.find<AppController>().setCurrentNavInget(4);
                    Get.find<BadgerProfileController>().get_badger_profile();
                    await Get.put(FetchCouponDiscount()).setEmptyCouponList();
                    Get.find<HomePointController>().get_home_point_data(false);
                    await Get.find<FetchCartItemsController>()
                        .fetch_cart_items();
                    await Get.find<FetchCartDropshipController>()
                        .fetchCartDropship();
                  },
                  child: Text(
                    MultiLanguages.of(context)!.translate('alert_okay'),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ))),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    ),
  );
}
