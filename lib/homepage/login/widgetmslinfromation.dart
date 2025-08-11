// import 'dart:developer';

import 'package:fridayonline/analytics/analytics_engine.dart';
import 'package:fridayonline/controller/check_information/check_information_controller.dart';
import 'package:fridayonline/controller/return_product_controller.dart';
import 'package:fridayonline/homepage/check_information/payment/payment_summary.dart';
import 'package:fridayonline/homepage/review/review.dart';
// import 'package:fridayonline/homepage/review/review.dart';
// import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:fridayonline/homepage/theme/themeimageprofiler.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/badger/badger_controller.dart';
import '../../model/badger/badger_profile_response.dart';
import '../../service/badger/badger.dart';
import '../../service/languages/multi_languages.dart';
import '../check_information/order/order_order.dart';

Future<void> _trackGA(String name) async {
  SetData data = SetData();
  AnalyticsEngine.sendAnalyticsEvent(
      name, await data.repCode, await data.repSeq, await data.repType);
}

// เป็นตัวที่ต้องรับยอดเงินที่ต้องชำระเพื่อส่งต่อไปที่ หน้าของ payment
// ignore: non_constant_identifier_names
eventmsl_information(String ARBal, BuildContext context) {
  BadgerProfileController badgerProfile = Get.put(BadgerProfileController());
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: InkWell(
          onTap: () async {
            // Logs to GA
            _trackGA('click_profile_payment');

            Get.to(() => PaymentSummary(
                ARBal)); // ทำการส่ง ยอดเงินที่ค้่างชำระไปที่ระบบดังกล่าว
            // Get.to(() => payment_cutomer(
            //     ARBal)); // ทำการส่ง ยอดเงินที่ค้่างชำระไปที่ระบบดังกล่าว
          },
          child: Container(
            alignment: Alignment.center,
            // ความสูงของกล่อง
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              //border corner radius
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imgpayment,
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    MultiLanguages.of(context)!.translate('me_payment'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'notoreg',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: InkWell(
          onTap: () async {
            // print('check order');
            _trackGA('click_member_profile_order');
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const CheckInformationOrderOrder()),
            );
            BadgerProfilResppnse response =
                await call_badger_update_profile("OrderMSL");
            if (response.value.success == "1") {
              Get.find<BadgerController>().get_badger();
              Get.find<BadgerController>().get_badger();
              Get.find<BadgerProfileController>().get_badger_profile();
              Get.find<BadgerController>().getBadgerMarket();
            }
          },
          child: Container(
            alignment: Alignment.center,
            // ความสูงของกล่อง
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              //border corner radius
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1), //color of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  if (!badgerProfile.isDataLoading.value) {
                    if (int.parse(badgerProfile.badgerProfile!.configFile.badger
                            .orderMsl.newMessage) >
                        0) {
                      return Stack(clipBehavior: Clip.none, children: <Widget>[
                        imgorder,
                        Positioned(
                          // draw a red marble
                          top: -10,
                          right: -5,
                          child: badges.Badge(
                              badgeStyle: const badges.BadgeStyle(
                                badgeColor: Colors.red,
                              ),
                              badgeContent: Text(
                                  badgerProfile.badgerProfile!.configFile.badger
                                      .orderMsl.newMessage,
                                  style: const TextStyle(
                                      inherit: false,
                                      color: Colors.white,
                                      fontSize: 15))),
                        )
                      ]);
                    } else {
                      return imgorder;
                    }
                  } else {
                    return imgorder;
                  }
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    MultiLanguages.of(context)!.translate('me_order'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'notoreg',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: InkWell(
          onTap: () {
            _trackGA('click_member_delivery_status');
            Get.toNamed(
                '/check_information_order_delivery_status'); //กำหนด Route ไปที่ /check_information_order
          },
          child: Container(
            alignment: Alignment.center,
            // ความสูงของกล่อง
            width: 90,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              //border corner radius
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1), //color of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imglogistic,
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "สถานะ\nการจัดส่ง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'notoreg',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: InkWell(
          onTap: () {
            _trackGA('click_member_order_history');
            Get.find<SetSelectInformation>().set_select_information(
                2); //ทำการเซ็ต tap bar ที่ SetSelectInformation => set_select_information
            Get.find<CheckInformationOrderOrderAllController>()
                .fetch_information_order_all(); //ทำการโหลดข้อมูลที่ CheckInformationOrderOrderAllControlle => fetch_information_order_all
            Get.find<CheckInformationDeliveryStatusController>()
                .fetch_information_delivery_status(); //ทำการโหลดข้อมูลที่ CheckInformationDeliveryStatusController => fetch_information_delivery_status
            Get.find<CheckInformationOrderHistoryController>()
                .fetch_information_order_history_me(); //ทำการโหลดข้อมูลที่ CheckInformationOrderHistoryController => fetch_information_order_history_me
            Get.find<ReturnProductController>().fetchBadgerReturnProduct();
            Get.toNamed(
                '/check_information_order_history'); //กำหนด Route ไปที่ /check_information_order
          },
          child: Container(
            alignment: Alignment.center,
            // ความสูงของกล่อง
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              //border corner radius
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1), //color of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imghistory,
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    MultiLanguages.of(context)!.translate('me_purchaseHistory'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'notoreg',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      //? fade review
      Expanded(
        child: InkWell(
          onTap: () {
            _trackGA('click_member_review');
            Get.to(() => const Review(
                tabs: 0)); //กำหนด Route ไปที่ /check_information_order
          },
          child: Container(
            alignment: Alignment.center,
            // ความสูงของกล่อง
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              //border corner radius
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1), //color of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    imgreview,
                    badgerProfile.isDataLoading.value
                        ? const SizedBox()
                        : int.parse(badgerProfile.badgerProfile!.configFile
                                    .badger.review.newMessage) >
                                0
                            ? Positioned(
                                top: -10,
                                right: -5,
                                child: badges.Badge(
                                    badgeStyle: const badges.BadgeStyle(
                                      badgeColor: Colors.red,
                                    ),
                                    badgeContent: Text(
                                        badgerProfile.badgerProfile!.configFile
                                            .badger.review.newMessage,
                                        style: const TextStyle(
                                            inherit: false,
                                            color: Colors.white,
                                            fontSize: 15))),
                              )
                            : const SizedBox(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    MultiLanguages.of(context)!.translate('my_review'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'notoreg',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
