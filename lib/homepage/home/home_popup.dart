// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/controller/update_app_controller.dart';
import 'package:fridayonline/homepage/myhomepage.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/model/check_version/check_transferdist.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
// import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
// import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/category/category_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../controller/pro_filecontroller.dart';
import '../../model/home/popup_promotion_model.dart';
import '../../service/home/home_service.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/logapp/logapp_service.dart';
import '../../service/pathapi.dart';
import '../login/login_by_phone.dart';
import '../theme/theme_color.dart';
import '../webview/webview_app.dart';
import '../webview/webview_full_screen.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<bool?> showPopUp(context) async {
  PopUpMainHome popUpData = await call_popup_data();

  if (popUpData.modernPopup.popupList.isNotEmpty) {
    Get.find<PopUpStatusController>().changeStatusViewPopupTranfer(true);
    Get.find<PopUpStatusController>().ChangeStatusViewPopup();
    ProductFromBanner bannerProduct = Get.put(ProductFromBanner());

    bool isMultiPopUp =
        popUpData.modernPopup.popupList.length > 1 ? true : false;

    bool isChecked = false;

    try {
      return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          double height = MediaQuery.of(context).size.height;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Scaffold(
              backgroundColor: Colors.black.withOpacity(0),
              body: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(right: 30),
                    //     child: IconButton(
                    //       icon: const Icon(
                    //         Icons.close,
                    //         color: Colors.white,
                    //         size: 30,
                    //       ),
                    //       onPressed: () async {
                    //         await Get.find<PopUpStatusController>()
                    //             .changeStatusViewPopupTranfer(true);
                    //         Navigator.pop(context, false);
                    //       },
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: height / 2.5,
                      child: CarouselSlider.builder(
                        slideBuilder: (index) {
                          return Container(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () async {
                                var mchannel = '17';
                                SetData userData = SetData();
                                var logData =
                                    popUpData.modernPopup.popupList[index];
                                var mchannelId = logData.popupSeq;
                                var popupType = logData.popupType;

                                InteractionLogger.logPopup(
                                    contentId: logData.popupSeq,
                                    contentName: logData.popupCode,
                                    contentImage: logData.popupImg);
                                LogAppTisCall(mchannel, mchannelId);
                                switch (popupType.toLowerCase()) {
                                  case "url":
                                    Navigator.pop(context);
                                    Get.to(() => WebViewFullScreen(
                                        mparamurl: popUpData.modernPopup
                                            .popupList[index].popupParam));
                                    break;
                                  case 'coupon_rewards':
                                    String? urlContent =
                                        "${base_url_web_fridayth}bwpoint/product?billCode=${popUpData.modernPopup.popupList[index].popupParam}";

                                    Get.to(() => webview_app(
                                        mparamurl: urlContent,
                                        mparamTitleName:
                                            MultiLanguages.of(context)!
                                                .translate('point_titleView'),
                                        mparamType: "rewards_detail",
                                        mparamValue: popUpData.modernPopup
                                            .popupList[index].popupParam));
                                    break;
                                  case 'category':
                                    bannerProduct.fetch_product_banner(
                                        popUpData.modernPopup.popupList[index]
                                            .popupParam,
                                        '');
                                    Get.find<CategoryProductlistController>()
                                        .fetch_product_category_byperson(
                                            popUpData.modernPopup
                                                .popupList[index].popupParam,
                                            "");
                                    Get.toNamed('/my_list_category',
                                        parameters: {
                                          'mChannel': mchannel,
                                          'mChannelId': mchannelId,
                                          'mTypeBack': '',
                                          'mTypeGroup': 'category',
                                          'ref': 'popup',
                                          'contentId': logData.popupSeq
                                        });
                                    break;
                                  case 'sku':
                                    Get.find<ProductDetailController>()
                                        .productDetailController(
                                      "",
                                      popUpData.modernPopup.popupList[index]
                                          .popupParam,
                                      "",
                                      popUpData.modernPopup.popupList[index]
                                          .popupParam,
                                      mchannel,
                                      popUpData.modernPopup.popupList[index]
                                          .popupParam,
                                    );
                                    Get.to(() => ProductDetailPage(
                                          ref: 'popup',
                                          contentId: logData.popupSeq,
                                        ));
                                    break;
                                  case 'phonelogin':
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginByPhone()));
                                    break;
                                  case 'sharecatalog':
                                    Get.toNamed('/sharecatalog');
                                    break;
                                  case "coupon_popup":
                                    var repCode = await userData.repCode;
                                    var repSeq = await userData.repSeq;
                                    var repType = await userData.repType;
                                    var tokenApp = await userData.tokenId;
                                    var couponId = popUpData.modernPopup
                                        .popupList[index].popupParam;
                                    var url =
                                        "${sp_fridayth}webnew/RecieveCoupon?couponId=$couponId&RepCode=$repCode&RepSeq=$repSeq&RepType=$repType&Token=$tokenApp";
                                    Get.to(() =>
                                        WebViewFullScreen(mparamurl: url));
                                    break;
                                  default:
                                    return;
                                }
                              },
                              child: CachedNetworkImage(
                                imageUrl: popUpData
                                    .modernPopup.popupList[index].popupImg,
                                fit: BoxFit.fill,
                                alignment: Alignment.center,
                              ),
                            ),
                          );
                        },
                        slideTransform: const DefaultTransform(),
                        autoSliderTransitionTime:
                            const Duration(milliseconds: 400),
                        unlimitedMode: isMultiPopUp ? true : false,
                        enableAutoSlider: isMultiPopUp ? true : false,
                        slideIndicator: isMultiPopUp
                            ? CircularSlideIndicator(
                                indicatorRadius: 3,
                                itemSpacing: 10,
                                padding: const EdgeInsets.only(top: 20),
                                currentIndicatorColor: Colors.red,
                                indicatorBackgroundColor: Colors.grey)
                            : CircularSlideIndicator(
                                itemSpacing: 10,
                                padding: const EdgeInsets.only(top: 20),
                                currentIndicatorColor: Colors.transparent,
                                indicatorBackgroundColor: Colors.transparent),
                        itemCount: popUpData.modernPopup.popupList.length,
                        initialPage: 0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isChecked == true) {
                                  isChecked = false;
                                } else {
                                  isChecked = true;
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.white, width: 2)),
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: const Color(0XFFFD7F6B),
                                    side: const BorderSide(
                                        color: Color(0XFFFD7F6B), width: 2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 13),
                                  child: Text(
                                    'ไม่ต้องแสดงอีกในวันนี้',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: const BorderSide(
                                            color: Colors.white)))),
                            onPressed: () async {
                              if (isChecked == true) {
                                DateTime now = DateTime.now();
                                String date =
                                    '${now.year}-${now.month}-${now.day}';
                                final SharedPreferences prefs = await _prefs;
                                prefs.setString("ShowPopupStatus", date);
                              }
                              Get.find<PopUpStatusController>()
                                  .changeStatusViewPopupTranfer(true);
                              Navigator.pop(context, false);
                            },
                            child: const SizedBox(
                              width: 30,
                              height: 40,
                              child: Center(
                                child: Text(
                                  'ปิด',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(anim1),
            child: child,
          );
        },
      );
    } catch (excaption) {
      print("popup");
    }
  } else {
    await Get.find<PopUpStatusController>().changeStatusViewPopupTranfer(true);
  }
  return null;
}

showPopUpUpdateApp(context, UpdateAppController update) async {
  try {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        double width = MediaQuery.of(context).size.width;
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: Scaffold(
                backgroundColor: Colors.black.withOpacity(0),
                body: Center(
                  child: Container(
                    width: width / 1.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/b2c/icon/update_app.png',
                            width: width / 2,
                          ),
                          Text(
                            "แอปใหม่พร้อมให้ใช้งานแล้ว!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansThaiLooped(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            textAlign: TextAlign.center,
                            update.detail.replaceAll('\\n', '\n'),
                            style: GoogleFonts.notoSansThaiLooped(
                              fontSize: 14,
                            ),
                          ).paddingSymmetric(horizontal: 8),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  foregroundColor: Colors.white,
                                  backgroundColor: theme_color_df,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: theme_color_df))),
                              onPressed: () async {
                                if (Platform.isIOS) {
                                  await LaunchApp.openApp(
                                      iosUrlScheme: 'nonexistent-scheme://',
                                      appStoreLink: update.url,
                                      openStore: true);
                                } else {
                                  var url1 = Uri.parse(update.url);
                                  await launchUrl(
                                    url1,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: SizedBox(
                                width: width / 1.7,
                                child: Center(
                                  child: Text('อัปเดตเลย!',
                                      style: GoogleFonts.notoSansThaiLooped(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  } catch (e) {
    print("popup");
  }
}

//? popup tranfer
showpopUptranfer(context, TransFerDist tranferDist) async {
  try {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        double width = MediaQuery.of(context).size.width;
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: width / 1.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            textAlign: TextAlign.center,
                            "แจ้งเตือน",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            tranferDist.msgAlert1,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 60),
                            child: Text(
                              textAlign: TextAlign.center,
                              tranferDist.msgAlert2,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          theme_color_df),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          side: BorderSide(
                                              color: theme_color_df)))),
                              onPressed: () async {
                                final Future<SharedPreferences> prefs =
                                    SharedPreferences.getInstance();

                                final SharedPreferences pref = await prefs;
                                pref.setString("RepCode", tranferDist.repCode);
                                Future.delayed(const Duration(milliseconds: 0),
                                    () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()));
                                });
                              },
                              child: SizedBox(
                                width: width / 1.7,
                                child: const Center(
                                  child: Text('ยืนยัน',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    ).then((value) => {Get.find<ProfileController>().get_profile_data()});
  } catch (excaption) {
    print("popup");
  }
}
