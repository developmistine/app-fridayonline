// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, must_be_immutable, camel_case_types, use_key_in_widget_constructors

import 'package:fridayonline/controller/app_controller.dart';
// import 'package:fridayonline/controller/category/category_controller.dart';
import 'package:fridayonline/controller/catelog/catelog_controller.dart';
import 'package:fridayonline/controller/home/home_controller.dart';
import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/check_information/payment/payment_cutomer.dart';
import 'package:fridayonline/homepage/flashsale/flashsale_detail.dart';
import 'package:fridayonline/homepage/home/home_new/home_more_special/home_special_project.dart';
import 'package:fridayonline/homepage/home/home_special_promotion_bwpoint.dart';
import 'package:fridayonline/homepage/myhomepage.dart';
import 'package:fridayonline/homepage/page_showproduct/List_product.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/webview/webview_app.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:fridayonline/homepage/widget/appbar_cart_share.dart';
import 'package:fridayonline/model/flashsale/flashsale.dart';
import 'package:fridayonline/model/notify/informationPushPromotionGroup.dart';
import 'package:fridayonline/model/point_rewards/point_rewards_get_msl_info.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/flashsale/flashsale_service.dart';
import 'package:fridayonline/service/languages/multi_languages.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:fridayonline/service/logapp/logapp_service.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:fridayonline/service/point_rewards/point_rewards_sevice.dart';
import 'package:fridayonline/service/profileuser/getprofile.dart';
import 'package:fridayonline/service/profileuser/mslinfo.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/badger/badger_controller.dart';
import '../../controller/notification/notification_controller.dart';
import '../../service/notify/informationPushNotify_sevice.dart';
import '../theme/theme_loading.dart';
import '../widget/appbar_relode.dart';

class notify_promotionlist extends StatefulWidget {
  notify_promotionlist({required this.idparm, required this.typedataapi});
  String idparm;
  String typedataapi;

  @override
  State<notify_promotionlist> createState() => _notify_promotionlistState();
}

class _notify_promotionlistState extends State<notify_promotionlist> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBarRelodeMaster('โปรโมชันพิเศษ', '/backAppbarnotify'),
        body: GetBuilder<NotificationPromotionListController>(
          builder: ((notify) {
            if (!notify.isDataLoading.value) {
              if (notify.promotionList!.promotionGroup.isNotEmpty) {
                if (notify
                    .promotionList!.promotionGroup[0].promotion.isNotEmpty) {
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: notify
                        .promotionList!.promotionGroup[0].promotion.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime now = DateTime.parse(notify.promotionList!
                          .promotionGroup[0].promotion[index].date);
                      String formattedDate =
                          DateFormat('dd-MM-yyyy  kk:mm').format(now);

                      return ListTile(
                          tileColor: notify.promotionList!.promotionGroup[0]
                                      .promotion[index].readStatus ==
                                  "N"
                              ? const Color(0xffcce4fa)
                              : Colors.white,
                          isThreeLine: true,
                          title: Text(
                            notify.promotionList!.promotionGroup[0]
                                .promotion[index].title,
                            style: const TextStyle(
                                fontSize: 16, fontFamily: 'notoreg'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () async {
                            await Information_Push_PromotionList(
                                idparm: notify.promotionList!.promotionGroup[0]
                                    .promotion[index].idindex,
                                typedataapi: 'GetPromotionIndex');

                            await LogAppTisCall(
                                '24',
                                notify.promotionList!.promotionGroup[0]
                                    .promotion[index].idindex);

                            SetData data = SetData();
                            var cpRepSeq = await data.repSeq;
                            var cpRepCode = await data.repCode;
                            var repType = await data.repType;
                            var token = await data.tokenId;

                            Promotion promotion = notify.promotionList!
                                .promotionGroup[0].promotion[index];
                            String parameterContent =
                                promotion.parameterContent;
                            String parameterKey = promotion.parameterKey;
                            InteractionLogger.logNotification(
                                contentId: promotion.contentId,
                                contentName: promotion.title,
                                contentImage: promotion.imgContent);

                            switch (parameterContent) {
                              case "url":
                                Get.to(() =>
                                    WebViewFullScreen(mparamurl: parameterKey));
                              case "sharecatalog":
                                Get.toNamed('/sharecatalog');
                                break;
                              case "sku":
                                Get.find<ProductDetailController>()
                                    .productDetailController(
                                  "",
                                  parameterKey,
                                  "",
                                  parameterKey,
                                  '24',
                                  notify.promotionList!.promotionGroup[0]
                                      .promotion[index].idindex,
                                );
                                Get.to(() => ProductDetailPage(
                                      ref: 'notify',
                                      contentId: notify
                                          .promotionList!
                                          .promotionGroup[0]
                                          .promotion[index]
                                          .contentId,
                                    ));
                                break;
                              case "category":
                                // ParameterKey
                                Get.put(ProductFromBanner())
                                    .fetch_product_banner(parameterKey, '');

                                Get.to(() => Scaffold(
                                    appBar: appbarShare(
                                        MultiLanguages.of(context)!.translate(
                                            'home_page_list_products'),
                                        "",
                                        "24",
                                        notify.promotionList!.promotionGroup[0]
                                            .promotion[index].idindex),
                                    body: Obx(() => Get.put(ProductFromBanner())
                                            .isDataLoading
                                            .value
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : showList(
                                            Get.put(ProductFromBanner())
                                                .BannerProduct!
                                                .skucode,
                                            '24',
                                            notify
                                                .promotionList!
                                                .promotionGroup[0]
                                                .promotion[index]
                                                .contentId,
                                            ref: 'notify',
                                            contentId: notify
                                                .promotionList!
                                                .promotionGroup[0]
                                                .promotion[index]
                                                .contentId,
                                          ))));
                                break;
                              case "extra":
                                Get.to(() => const HomeSpecialProject());
                                break;
                              case "flashSale":
                                Flashsale? flashSaleData =
                                    await FlashsaleHomeService();
                                if (flashSaleData!.flashSale.isNotEmpty) {
                                  Get.to(() => FlashSaleDetail(
                                        contentId: notify
                                            .promotionList!
                                            .promotionGroup[0]
                                            .promotion[index]
                                            .id,
                                      ));
                                } else {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          titlePadding: const EdgeInsets.only(
                                              top: 20, bottom: 0),
                                          actionsPadding: const EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          actionsAlignment:
                                              MainAxisAlignment.end,
                                          title: Text(
                                            textAlign: TextAlign.center,
                                            "แจ้งเตือน",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: theme_color_df),
                                          ),
                                          content: const Text(
                                              textAlign: TextAlign.center,
                                              'ขออภัยค่ะ\nขณะนี้ Flash Sale ยังไม่เปิด'),
                                          actions: [
                                            const Divider(
                                              color: Color(0XFFD9D9D9),
                                              thickness: 1,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Center(
                                                child: Text(
                                                    textAlign: TextAlign.center,
                                                    'ปิด',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: theme_color_df)),
                                              ),
                                            )
                                          ],
                                        );
                                      });
                                  debugPrint('ยังไม่เปิด');
                                }
                                break;
                              case "payment":
                                Mslinfo profile = await getProfileMSL();
                                Get.to(() =>
                                    payment_cutomer(profile.mslInfo.arBal));
                                break;
                              case "pointHome":
                                Get.to(() => const SpecialPromotionBwpoint(
                                    type: 'notify'));
                                break;
                              case "pointCategoryDetail":
                                GetMslinfo? mslinfo = await GetMslInfoSevice();
                                var idCard = mslinfo!.idcardRequire;

                                var cpFscode = notify
                                    .promotionList!
                                    .promotionGroup[0]
                                    .promotion[index]
                                    .parameterKey;
                                if (idCard == "Y") {
                                  Get.to(() => WebViewFullScreen(
                                      mparamurl:
                                          "${baseurl_web_view}main-less/main_less.php?repseq=$cpRepSeq&repcode=$cpRepCode"));
                                } else {
                                  Get.to(() => webview_app(
                                      mparamurl:
                                          "${base_url_web_fridayth}bwpoint/product?billCode=$cpFscode",
                                      mparamTitleName:
                                          MultiLanguages.of(context)!
                                              .translate('point_titleView'),
                                      mparamType: 'rewards_detail',
                                      mparamValue: cpFscode));
                                }
                                break;
                              case "catalogHome":
                                Get.find<AppController>().setCurrentNavInget(1);
                                Get.offAll(() => MyHomePage(
                                      typeView: 'catelog',
                                      indexCatelog: int.parse(notify
                                          .promotionList!
                                          .promotionGroup[0]
                                          .promotion[index]
                                          .parameterKey),
                                    ));
                                break;
                              case "catalogDetail":
                                var value = notify
                                    .promotionList!
                                    .promotionGroup[0]
                                    .promotion[index]
                                    .parameterKey
                                    .split('|');

                                var catalogCampaign = value[1];
                                var catalogBrand = value[2];
                                var catalogMedia = value[3];
                                if ((value[0].isNotEmpty) &&
                                    (catalogCampaign.isNotEmpty) &&
                                    (catalogBrand.isNotEmpty) &&
                                    (catalogMedia.isNotEmpty)) {
                                  var catalogtype;
                                  if (value[0] == "0") {
                                    catalogtype = "7";
                                  } else if (value[0] == "1") {
                                    catalogtype = "8";
                                  }
                                  Get.find<CatelogDetailController>()
                                      .get_catelog_detail(catalogCampaign,
                                          catalogBrand, catalogMedia);
                                  Get.toNamed('/catelog_detail', parameters: {
                                    "channel": catalogtype.toString()
                                  });
                                }
                                break;
                              default:
                                break;
                            }

                            await Get.find<
                                    NotificationPromotionListController>()
                                .get_promotionList_reset(
                                    widget.idparm, widget.typedataapi);

                            Get.find<NotificationController>()
                                .get_notification_data();
                            Get.find<BadgerController>().get_badger();
                            Get.find<BadgerProfileController>()
                                .get_badger_profile();
                            Get.find<BadgerController>().getBadgerMarket();
                          },
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notify.promotionList!.promotionGroup[0]
                                    .promotion[index].desc,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                // mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Expanded(
                                    flex: 1,
                                    child: Icon(
                                      Icons.access_time,
                                      size: 18.0,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Text(
                                      formattedDate,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'notoreg',
                                          color: Colors.black26),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          leading: CachedNetworkImage(
                            imageUrl: notify.promotionList!.promotionGroup[0]
                                .promotion[index].imgContent,
                            fit: BoxFit.fill,
                            height: 55,
                            width: 55,
                            alignment: Alignment.center,
                          ),
                          trailing: const SizedBox(
                            height: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                          iconColor: theme_color_df);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 2,
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
                      Text(MultiLanguages.of(context)!
                          .translate('alert_no_datas')),
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
                    Text(MultiLanguages.of(context)!
                        .translate('alert_no_datas')),
                  ],
                ));
              }
            } else {
              return Center(child: theme_loading_df);
            }
          }),
        ),
      ),
    );
  }
}

//New Pam Push History
// import 'package:fridayonline/controller/app_controller.dart';
// import 'package:fridayonline/controller/category/category_controller.dart';
// import 'package:fridayonline/controller/catelog/catelog_controller.dart';
// import 'package:fridayonline/controller/home/home_controller.dart';
// import 'package:fridayonline/homepage/check_information/payment/payment_cutomer.dart';
// import 'package:fridayonline/homepage/flashsale/flashsale_detail.dart';
// import 'package:fridayonline/homepage/home/home_new/home_more_special/home_special_project.dart';
// import 'package:fridayonline/homepage/home/home_special_promotion_bwpoint.dart';
// import 'package:fridayonline/homepage/myhomepage.dart';
// import 'package:fridayonline/homepage/page_showproduct/List_product.dart';
// import 'package:fridayonline/homepage/pageactivity/cart_activity.dart';
// import 'package:fridayonline/homepage/theme/theme_color.dart';
// import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
// import 'package:fridayonline/homepage/webview/webview_app.dart';
// import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
// import 'package:fridayonline/homepage/widget/appbar_cart.dart';
// import 'package:fridayonline/model/flashsale/flashsale.dart';
// import 'package:fridayonline/model/point_rewards/point_rewards_get_msl_info.dart';
// import 'package:fridayonline/model/set_data/set_data.dart';
// import 'package:fridayonline/pam/notification_api.dart';
// import 'package:fridayonline/service/flashsale/flashsale_service.dart';
// import 'package:fridayonline/service/languages/multi_languages.dart';
// import 'package:fridayonline/service/logapp/logapp_service.dart';
// import 'package:fridayonline/service/pathapi.dart';
// import 'package:fridayonline/service/point_rewards/point_rewards_sevice.dart';
// import 'package:fridayonline/service/profileuser/getprofile.dart';
// import 'package:fridayonline/service/profileuser/mslinfo.dart';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../../controller/badger/badger_controller.dart';
// import '../../controller/notification/notification_controller.dart';
// import '../../service/notify/informationPushNotify_sevice.dart';
// import '../theme/theme_loading.dart';
// import '../widget/appbar_relode.dart';

// class notify_promotionlist extends StatefulWidget {
//   notify_promotionlist({required this.idparm, required this.typedataapi});
//   String idparm;
//   String typedataapi;

//   @override
//   State<notify_promotionlist> createState() => _notify_promotionlistState();
// }

// class _notify_promotionlistState extends State<notify_promotionlist> {
//   @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
//       child: Scaffold(
//         appBar: AppBarRelodeMaster('โปรโมชันพิเศษ', '/backAppbarnotify'),
//         body: GetBuilder<NotificationPromotionListController>(
//           builder: ((notify) {
//             if (!notify.isDataLoading.value) {
//               try {
//                 if (notify.listPamPushHistory!.items.isNotEmpty &&
//                     notify.listPamPushHistory != null) {
//                   return ListView.separated(
//                     physics: const BouncingScrollPhysics(),
//                     itemCount: notify.listPamPushHistory!.items.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       DateTime now = DateTime.parse(
//                           notify.listPamPushHistory!.items[index].createdDate);
//                       Duration timeDifference = const Duration(hours: 7);
//                       DateTime resultDateTime = now.add(timeDifference);
//                       String formattedDate = DateFormat('dd-MM-yyyy  kk:mm')
//                           .format(resultDateTime);

//                       return ListTile(
//                           tileColor:
//                               notify.listPamPushHistory!.items[index].isOpen ==
//                                       false
//                                   ? const Color(0xffcce4fa)
//                                   : Colors.white,
//                           isThreeLine: true,
//                           title: Text(
//                             notify.listPamPushHistory!.items[index].title,
//                             style: const TextStyle(
//                                 fontSize: 16, fontFamily: 'notoreg'),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           onTap: () async {
//                             var pushType = notify.listPamPushHistory!
//                                 .items[index].jsonData.pam.contentType
//                                 .toString()
//                                 .toLowerCase();
//                             var contentIndex = notify.listPamPushHistory!
//                                 .items[index].jsonData.pam.contentIndex;
//                             var billCode = notify.listPamPushHistory!
//                                 .items[index].jsonData.pam.billCode;
//                             var fsCode = notify.listPamPushHistory!.items[index]
//                                 .jsonData.pam.fsCode;
//                             var categoryID = notify.listPamPushHistory!
//                                 .items[index].jsonData.pam.categoryId;
//                             var catalogType = notify.listPamPushHistory!
//                                 .items[index].jsonData.pam.catalogType;
//                             var campaign = notify.listPamPushHistory!
//                                 .items[index].jsonData.pam.campaign;
//                             var brand = notify.listPamPushHistory!.items[index]
//                                 .jsonData.pam.brand;
//                             var media = notify.listPamPushHistory!.items[index]
//                                 .jsonData.pam.media;
//                             var url = notify.listPamPushHistory!.items[index]
//                                 .jsonData.pam.url;
//                             var channelId = notify.listPamPushHistory!
//                                 .items[index].jsonData.pam.channelId;
//                             var pixel = notify.listPamPushHistory!.items[index]
//                                 .jsonData.pam.pixel;

//                             var pamAPI = PamPushNotificationAPI();
//                             pamAPI.read(pixel);

//                             var mChannel = '26';
//                             await LogAppTisCall(mChannel, channelId);
//                             await notify.get_pam_notification_reset();
//                             await Get.find<NotificationController>()
//                                 .get_notification_data_update();

//                             switch (pushType) {
//                               case "url":
//                                 {
//                                   Get.to(() =>
//                                       WebViewFullScreen(mparamurl: url));
//                                   break;
//                                 }
//                               case "category":
//                                 {
//                                   Get.put(ProductFromBanner())
//                                       .fetch_product_banner(categoryID, '');
//                                   Get.to(() => Scaffold(
//                                       appBar: appBarTitleCart(
//                                           MultiLanguages.of(context)!.translate(
//                                               'home_page_list_products'),
//                                           ""),
//                                       body: Obx(() =>
//                                           Get.put(ProductFromBanner())
//                                                   .isDataLoading
//                                                   .value
//                                               ? const Center(
//                                                   child:
//                                                       CircularProgressIndicator(),
//                                                 )
//                                               : showList(
//                                                   context,
//                                                   Get.put(ProductFromBanner())
//                                                       .BannerProduct!
//                                                       .skucode,
//                                                   '26',
//                                                   contentIndex))));
//                                   break;
//                                 }
//                               case "sku":
//                                 {
//                                   Get.find<CategoryProductDetailController>()
//                                       .fetchproductdetail("", billCode, "",
//                                           fsCode, '26', contentIndex, '');
//                                   // จากนั้นไปที่ รายละเอียดสินค้าที่เป็น Webview
//                                   Get.toNamed('/my_detail', parameters: {
//                                     'mchannel': '26',
//                                     'mchannelId': contentIndex
//                                   });
//                                   break;
//                                 }
//                               case "sharecatalog":
//                                 {
//                                   Get.toNamed("/sharecatalog");
//                                   break;
//                                 }
//                               // ไปที่หน้า ข้อมูลการสั่งซื้อ EndUser (push: EndUser)
//                               case "vieworder":
//                                 {
//                                   Get.toNamed("/enduser_check_information",
//                                       parameters: {'select': '1'});
//                                   //Get.toNamed("/enduser_check_information");
//                                   break;
//                                 }
//                               // ไปที่หน้า ข้อมูลการสั่งซื้อของ EndUser (push: Msl)
//                               case "vieworderenduser":
//                                 {
//                                   Get.toNamed("/check_information_order");
//                                   break;
//                                 }
//                               case "promotion":
//                                 {
//                                   Get.find<
//                                           NotificationPromotionListController>()
//                                       .get_promotionList(
//                                           '101', "GetPromotionGroup");
//                                   Get.find<AppController>()
//                                       .setCurrentNavInget(3);
//                                   Get.to(
//                                     transition: Transition.rightToLeft,
//                                     () => notify_promotionlist(
//                                         idparm: '101',
//                                         typedataapi: "GetPromotionGroup"),
//                                   );
//                                   break;
//                                 }
//                               case "activity":
//                                 {
//                                   var activityUrl = await GetYupinActivity(
//                                       'GetYupinActivity');
//                                   Get.to(
//                                       transition: Transition.rightToLeft,
//                                       () => WebViewFullScreen(
//                                           mparamurl: activityUrl.toString()));
//                                   break;
//                                 }
//                               case "news":
//                                 {
//                                   var newsUrl =
//                                       await GetYupinActivity('GetYupinNews');
//                                   Get.to(
//                                       transition: Transition.rightToLeft,
//                                       () => WebViewFullScreen(
//                                           mparamurl: newsUrl.toString()));
//                                   break;
//                                 }
//                               case "notifynormal":
//                                 {
//                                   Get.find<AppController>()
//                                       .setCurrentNavInget(3);
//                                   Get.toNamed("/backAppbarnotify",
//                                       parameters: {'changeView': '3'});
//                                   // Get.toNamed("/promotion");
//                                   break;
//                                 }
//                               case "leadtomsl":
//                                 {
//                                   //setMslFromLead();
//                                   break;
//                                 }
//                               case "extra":
//                                 {
//                                   Get.to(() => const HomeSpecialProject());
//                                   break;
//                                 }
//                               case "flashsale":
//                                 {
//                                   Flashsale? flashSaleData =
//                                       await FlashsaleHomeService();
//                                   if (flashSaleData!.flashSale.isNotEmpty) {
//                                     Get.to(() => const FlashSaleDetail());
//                                   } else {
//                                     showDialog(
//                                         context: context,
//                                         barrierDismissible: false,
//                                         builder: (BuildContext context) {
//                                           return AlertDialog(
//                                             targetPadding:
//                                                 const EdgeInsets.all(10),
//                                             titlePadding: const EdgeInsets.only(
//                                                 top: 20, bottom: 0),
//                                             actionsPadding:
//                                                 const EdgeInsets.only(
//                                                     top: 0, bottom: 0),
//                                             actionsAlignment:
//                                                 MainAxisAlignment.end,
//                                             title: Text(
//                                               textAlign: TextAlign.center,
//                                               "แจ้งเตือน",
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: theme_color_df),
//                                             ),
//                                             content: const Text(
//                                                 textAlign: TextAlign.center,
//                                                 'ขออภัยค่ะ\nขณะนี้ Flash Sale ยังไม่เปิด'),
//                                             actions: [
//                                               const Divider(
//                                                 color: Color(0XFFD9D9D9),
//                                                 thickness: 1,
//                                               ),
//                                               TextButton(
//                                                 onPressed: () {
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: Center(
//                                                   child: Text(
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       'ปิด',
//                                                       style: TextStyle(
//                                                           fontSize: 16,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color:
//                                                               theme_color_df)),
//                                                 ),
//                                               )
//                                             ],
//                                           );
//                                         });
//                                     debugPrint('ยังไม่เปิด');
//                                   }
//                                   break;
//                                 }
//                               case "payment":
//                                 {
//                                   Mslinfo profile = await getProfileMSL();
//                                   Get.to(() =>
//                                       payment_cutomer(profile.mslInfo.arBal));
//                                   break;
//                                 }
//                               case "pointhome":
//                                 {
//                                   Get.to(() =>
//                                       SpecialPromotionBwpoint(type: 'push'));
//                                   break;
//                                 }
//                               case "pointcategorydetail":
//                                 {
//                                   SetData data = SetData();
//                                   var cpRepSeq = await data.repSeq;
//                                   var cpRepCode = await data.repCode;
//                                   GetMslinfo? mslinfo =
//                                       await GetMslInfoSevice();
//                                   var idCard = mslinfo!.idcardRequire;
//                                   var cpFscode = fsCode;
//                                   if (idCard == "Y") {
//                                     Get.to(() => WebViewFullScreen(
//                                         mparamurl:
//                                             "${baseurl_web_view}main-less/main_less.php?repseq=$cpRepSeq&repcode=$cpRepCode"));
//                                   } else {
//                                     Get.to(() => webview_app(
//                                         mparamurl:
//                                             "${base_url_web_fridayth}bwpoint/product?billCode=$cpFscode",
//                                         mparamTitleName:
//                                             MultiLanguages.of(context)!
//                                                 .translate('point_titleView'),
//                                         mparamType: 'rewards_detail',
//                                         mparamValue: cpFscode));
//                                   }
//                                   break;
//                                 }
//                               case "cataloghome":
//                                 {
//                                   Get.find<AppController>()
//                                       .setCurrentNavInget(1);
//                                   Get.offAll(() => MyHomePage(
//                                         typeView: 'catelog',
//                                         indexCatelog: int.parse(catalogType),
//                                       ));
//                                   break;
//                                 }
//                               case "catalogdetail":
//                                 {
//                                   var catalogtype;
//                                   if (catalogType == "0") {
//                                     catalogtype = "7";
//                                   } else if (catalogType == "1") {
//                                     catalogtype = "8";
//                                   }
//                                   Get.find<CatelogDetailController>()
//                                       .get_catelog_detail(
//                                           campaign, brand, media);
//                                   Get.toNamed('/catelog_detail', parameters: {
//                                     "channel": catalogtype.toString()
//                                   });
//                                   break;
//                                 }
//                               case "cart":
//                                 {
//                                   Get.to(() => const Cart());
//                                   break;
//                                 }
//                               case "checkin":
//                                 {
//                                   SetData data = SetData();
//                                   var cpRepSeq = await data.repSeq;
//                                   var cpRepCode = await data.repCode;
//                                   var tokenApp = await data.tokenId;
//                                   var urlCheckIn =
//                                       "https://club.fridayth.com/yclub/activity/checkin/index.php?chanel=BANNER?ProjectCode=Notify&Repcode=${cpRepCode}&RefCode=${cpRepCode}&RepSeq=${cpRepSeq}&RefID=${cpRepSeq}&RepType=2&TokenApp=${tokenApp}";
//                                   Get.to(() => WebViewFullScreen(
//                                       mparamurl: urlCheckIn));
//                                   break;
//                                 }
//                               default:
//                                 {
//                                   Get.toNamed("/");
//                                   break;
//                                 }
//                             }
//                           },
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 notify.listPamPushHistory!.items[index]
//                                     .description,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Row(
//                                 // mainAxisSize: MainAxisSize.min,
//                                 children: <Widget>[
//                                   const Expanded(
//                                     flex: 1,
//                                     child: Icon(
//                                       Icons.access_time,
//                                       size: 18.0,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     flex: 10,
//                                     child: Text(
//                                       formattedDate,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(
//                                           fontSize: 12,
//                                           fontFamily: 'notoreg',
//                                           color: Colors.black26),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           leading: notify.listPamPushHistory!.items[index]
//                                       .thumbnailUrl ==
//                                   ""
//                               ? Image.asset(imageError,
//                                   height: 160, fit: BoxFit.contain)
//                               : CachedNetworkImage(
//                                   imageUrl: notify.listPamPushHistory!
//                                       .items[index].thumbnailUrl,
//                                   fit: BoxFit.fill,
//                                   height: 55,
//                                   width: 55,
//                                   alignment: Alignment.center,
//                                 ),
//                           trailing: SizedBox(
//                             height: double.infinity,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.min,
//                               children: const [
//                                 Icon(
//                                   Icons.arrow_forward_ios,
//                                   size: 15,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           iconColor: theme_color_df);
//                     },
//                     separatorBuilder: (BuildContext context, int index) =>
//                         const Divider(
//                       height: 2,
//                     ),
//                   );
//                 } else {
//                   //แสดงข้อความว่า ไม่พบข้อมูล
//                   return Center(
//                       child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/images/logo/logofriday.png',
//                         width: 50,
//                         height: 50,
//                       ),
//                       Text(MultiLanguages.of(context)!
//                           .translate('alert_no_datas')),
//                     ],
//                   ));
//                 }
//               } catch (e) {
//                 return Center(
//                     child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/images/logo/logofriday.png',
//                       width: 50,
//                       height: 50,
//                     ),
//                     Text(MultiLanguages.of(context)!
//                         .translate('alert_no_datas')),
//                   ],
//                 ));
//               }
//             } else {
//               return Center(child: theme_loading_df);
//             }
//           }),
//         ),
//       ),
//     );
//   }
// }
