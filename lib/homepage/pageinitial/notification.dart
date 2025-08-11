// เป็นหน้าจอแจ้งเตือนของระบบ

// ignore_for_file: non_constant_identifier_names

import 'package:fridayonline/controller/notification/notification_controller.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../analytics/analytics_engine.dart';
import '../../controller/badger/badger_controller.dart';
import '../../model/badger/badger_response.dart';

import '../../service/badger/badger.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/notify/informationPushNotify_sevice.dart';
import '../notify/notify_promotionlist.dart';
import '../theme/theme_loading.dart';
import '../theme/themeimage_menu.dart';
import '../webview/webview_full_screen.dart';

class PushNotification extends StatefulWidget {
  const PushNotification({super.key});

  @override
  State<PushNotification> createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: ((notify) {
        if (!notify.isDataLoading.value) {
          //ตรวจสอบว่ามีข้อมูลไหม
          //กรณีที่มีข้อมูลให้ทำการแสดงข้อมูล
          if (notify.notify!.informationPushNotify.isNotEmpty) {
            if (notify.notify!.informationPushNotify[0].notify.isNotEmpty) {
              var mdataInformationPushNotify = notify.notify!;
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: mdataInformationPushNotify
                      .informationPushNotify[0].notify.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        tileColor: Colors.white,
                        onTap: () async {
                          if (mdataInformationPushNotify
                                  .informationPushNotify[0]
                                  .notify[index]
                                  .type ==
                              "Promotion") {
                            // Get.find<NotificationPromotionListController>()
                            //     .get_pam_notification_data();
                            Get.find<NotificationPromotionListController>()
                                .get_promotionList(
                                    mdataInformationPushNotify
                                        .informationPushNotify[0]
                                        .notify[index]
                                        .idgroup,
                                    "GetPromotionGroup");
                            Get.to(
                              transition: Transition.rightToLeft,
                              () => notify_promotionlist(
                                  idparm: mdataInformationPushNotify
                                      .informationPushNotify[0]
                                      .notify[index]
                                      .idgroup,
                                  typedataapi: "GetPromotionGroup"),
                            );
                            Get.find<NotificationController>()
                                .get_notification_data();
                            _trackNotify('click_promotion_notify');
                          } else if (mdataInformationPushNotify
                                  .informationPushNotify[0]
                                  .notify[index]
                                  .type ==
                              "Activity") {
                            var mpdata_activity =
                                await GetYupinActivity('GetYupinActivity');
                            // print(mpdata_activity);

                            Get.to(
                                transition: Transition.rightToLeft,
                                () => WebViewFullScreen(
                                    mparamurl: mpdata_activity.toString()));
                            Get.find<NotificationController>()
                                .get_notification_data();
                            _trackNotify('click_activity_notify');
                          } else if (mdataInformationPushNotify
                                  .informationPushNotify[0]
                                  .notify[index]
                                  .type ==
                              "News") {
                            var mpdata_activity =
                                await GetYupinActivity('GetYupinNews');

                            Get.to(
                                transition: Transition.rightToLeft,
                                () => WebViewFullScreen(
                                    mparamurl: mpdata_activity.toString()));
                            BadgerRespones badgerResponse =
                                await call_badger_update_push_notification();
                            if (badgerResponse.status == '1') {
                              //print(badgerResponse.message);
                              Get.find<BadgerController>().get_badger();
                              Get.find<BadgerProfileController>()
                                  .get_badger_profile();
                              Get.find<BadgerController>().getBadgerMarket();
                              Get.find<NotificationController>()
                                  .get_notification_data();
                            }
                            _trackNotify('click_variety_notify');
                            // print(mpdata_activity);
                          } else if (mdataInformationPushNotify
                                  .informationPushNotify[0]
                                  .notify[index]
                                  .type ==
                              "Chat") {
                            // Get.to(
                            //     transition: Transition.rightToLeft,
                            //     () => ErrorCloseUpdate());

                            var mpdata_activity =
                                await GetYupinActivity('GetChatOnline');

                            Get.to(
                                transition: Transition.rightToLeft,
                                () => WebViewFullScreen(
                                    mparamurl: mpdata_activity.toString()));
                            // print(mpdata_activity);
                            Get.find<NotificationController>()
                                .get_notification_data();
                            _trackNotify('click_coupon_notify');
                          }
                        },
                        title: Text(
                          mdataInformationPushNotify
                              .informationPushNotify[0].notify[index].title,
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'notoreg'),
                        ),
                        subtitle: Text(
                          mdataInformationPushNotify
                              .informationPushNotify[0].notify[index].desc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: Image.asset(
                          mdataInformationPushNotify.informationPushNotify[0]
                                      .notify[index].type ==
                                  "Promotion"
                              ? img_notify_promotion
                              : mdataInformationPushNotify
                                          .informationPushNotify[0]
                                          .notify[index]
                                          .type ==
                                      "Activity"
                                  ? img_notify_activity
                                  : mdataInformationPushNotify
                                              .informationPushNotify[0]
                                              .notify[index]
                                              .type ==
                                          "News"
                                      ? img_notify_news
                                      : mdataInformationPushNotify
                                                  .informationPushNotify[0]
                                                  .notify[index]
                                                  .type ==
                                              "Chat"
                                          ? img_notify_cupon
                                          : '',
                          height: 50,
                          width: 50,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                if (mdataInformationPushNotify
                                        .informationPushNotify[0]
                                        .notify[index]
                                        .badger !=
                                    "0")
                                  badges.Badge(
                                      badgeAnimation:
                                          const badges.BadgeAnimation.fade(),
                                      badgeContent: SizedBox(
                                          //badge size
                                          child: Center(
                                        //aligh badge content to center
                                        child: Text(
                                            mdataInformationPushNotify
                                                .informationPushNotify[0]
                                                .notify[index]
                                                .badger,
                                            style: const TextStyle(
                                                inherit: false,
                                                color: Colors.white,
                                                fontSize: 12)),
                                      )),
                                      badgeStyle: const badges.BadgeStyle(
                                        badgeColor: Colors.red,
                                      )
                                      //badge background color
                                      )
                                else
                                  Container()
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                          ],
                        ),
                        iconColor: theme_color_df);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 0.5,
                  ),
                ),
              );
            } else {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo/logofriday.png',
                    width: 50,
                    height: 50,
                  ),
                  Text(MultiLanguages.of(context)!.translate('alert_no_datas')),
                ],
              ));
            }
          } else {
            //แสดงข้อความว่า ไม่พบข้อมูล
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo/logofriday.png',
                  width: 50,
                  height: 50,
                ),
                Text(MultiLanguages.of(context)!.translate('alert_no_datas')),
              ],
            ));
          }
        } else {
          return Center(child: theme_loading_df);
        }
      }),
    );
  }

  Future<void> _trackNotify(String name) async {
    SetData data = SetData();
    AnalyticsEngine.sendAnalyticsEvent(
        name, await data.repCode, await data.repSeq, await data.repType);
  }
}
