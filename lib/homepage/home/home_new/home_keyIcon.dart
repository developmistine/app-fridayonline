// import 'dart:developer';

import 'dart:io';

import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/app_controller.dart';
import '../../../controller/badger/badger_controller.dart';
import '../../../controller/dropship_shop/dropship_shop_controller.dart';
import '../../../controller/home/home_controller.dart';
import '../../../model/badger/badger_profile_response.dart';
import '../../../service/badger/badger.dart';
import '../../../service/logapp/logapp_service.dart';
import '../../../service/profileuser/getprofile.dart';
import '../../../service/profileuser/mslinfo.dart';
import '../../check_information/order/order_order.dart';
import '../../check_information/payment/payment_cutomer.dart';

import '../../myhomepage.dart';
// import '../../pageactivity/cart/cart_theme/cart_all_theme.dart';
// import '../../pageinitial/notification.dart';
import '../../theme/constants.dart';
import '../../theme/theme_color.dart';
// import '../content_list.dart';
import '../home_express.dart';
import 'home_more_special/home_seemore_product.dart';
import 'home_more_special/home_special_project.dart';

class HomeKeyIcon extends StatefulWidget {
  const HomeKeyIcon({super.key});

  @override
  State<HomeKeyIcon> createState() => _HomeKeyIconState();
}

class _HomeKeyIconState extends State<HomeKeyIcon> {
  ScrollController keyIconScroller = ScrollController();

  BadgerProfileController badgerProfile = Get.put(BadgerProfileController());
  double offset = 0;
  @override
  void initState() {
    super.initState();
    keyIconScroller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetX<KeyIconController>(builder: (keyIcon) {
      if (keyIcon.isDataLoading.value) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 110,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Shimmer.fromColors(
                          highlightColor: kBackgroundColor,
                          baseColor: const Color(0xFFE0E0E0),
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFFE0E0E0),
                          ),
                        ),
                        Shimmer.fromColors(
                          highlightColor: kBackgroundColor,
                          baseColor: const Color(0xFFE0E0E0),
                          child: Container(
                            height: 10,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        )
                      ],
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 8,
                      mainAxisExtent: 80,
                      crossAxisCount: 1),
                ),
              ),
            ),
          ],
        );
      } else {
        if (keyIcon.keyIcon!.keyIcon.isEmpty) {
          //? return empty
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RawScrollbar(
            controller: keyIconScroller,
            thickness: 8,
            thumbColor: Colors.white,
            trackColor: Colors.grey[350],
            thumbVisibility: true,
            trackVisibility: true,
            interactive: true,
            // mainAxisMargin: 160,
            trackRadius: const Radius.circular(20),
            radius: const Radius.circular(20),
            padding:
                EdgeInsets.symmetric(horizontal: Get.width > 390 ? 170 : 155),
            child: Container(
              height: 120,
              decoration: BoxDecoration(color: theme_color_df),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                child: GridView.builder(
                  controller: keyIconScroller,
                  scrollDirection: Axis.horizontal,
                  itemCount: keyIcon.keyIcon!.keyIcon.length,
                  itemBuilder: (BuildContext context, int index) {
                    var keysTab = keyIcon.keyIcon!.keyIcon[index];
                    // var keyvalue = keyIcon.keyIcon.keyIcon[index].

                    //? ปุ่มข้อมูลสั่งซื้อ
                    if (keysTab.keyIconKeyIndex == 'order_information') {
                      return InkWell(
                        onTap: () async {
                          var mchannel = "20";
                          var mchannelId = keysTab.id;
                          //LogApp
                          LogAppTisCall(mchannel, mchannelId);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    const CheckInformationOrderOrder()),
                          );
                          BadgerProfilResppnse response =
                              await call_badger_update_profile("OrderMSL");
                          if (response.value.success == "1") {
                            Get.find<BadgerController>().get_badger();
                            Get.find<BadgerController>().get_badger();
                            Get.find<BadgerProfileController>()
                                .get_badger_profile();
                            Get.find<BadgerController>().getBadgerMarket();
                          }
                        },
                        child: Column(
                          children: [
                            Obx(() {
                              if (!badgerProfile.isDataLoading.value) {
                                if (int.parse(badgerProfile
                                        .badgerProfile!
                                        .configFile
                                        .badger
                                        .orderMsl
                                        .newMessage) >
                                    0) {
                                  return Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.white,
                                          child: Center(
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: keyIcon
                                                        .keyIcon!
                                                        .keyIcon[index]
                                                        .keyIconImgApp,
                                                  )))),
                                      badges.Badge(
                                          badgeStyle: const badges.BadgeStyle(
                                            borderSide: BorderSide(
                                                width: 2.0,
                                                color: Colors.white),
                                            padding: EdgeInsets.all(5.0),
                                            badgeColor: Colors.red,
                                          ),
                                          badgeContent: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                                badgerProfile
                                                    .badgerProfile!
                                                    .configFile
                                                    .badger
                                                    .orderMsl
                                                    .newMessage,
                                                style: const TextStyle(
                                                    inherit: false,
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontFamily: 'notore')),
                                          ))
                                    ],
                                  );
                                } else {
                                  return CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: Center(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: CachedNetworkImage(
                                                imageUrl: keyIcon
                                                    .keyIcon!
                                                    .keyIcon[index]
                                                    .keyIconImgApp,
                                              ))));
                                }
                              } else {
                                return CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: CachedNetworkImage(
                                              imageUrl: keyIcon.keyIcon!
                                                  .keyIcon[index].keyIconImgApp,
                                            ))));
                              }
                            }),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 4),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  keyIcon.keyIcon!.keyIcon[index].keyIconName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      height: 1.5,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    //? ปุ่มไลฟ์
                    if (keysTab.keyIconKeyIndex == 'live_friday') {
                      return InkWell(
                        onTap: () async {
                          // Get.to(() => const LiveMainPage());
                        },
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: Center(
                                        child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: CachedNetworkImage(
                                              imageUrl: keyIcon.keyIcon!
                                                  .keyIcon[index].keyIconImgApp,
                                            )))),
                                Positioned(
                                  top: 0,
                                  right: -8,
                                  child: badges.Badge(
                                      badgeStyle: badges.BadgeStyle(
                                        badgeColor: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                        shape: badges.BadgeShape.square,
                                        borderSide: const BorderSide(
                                            width: 2.0, color: Colors.white),
                                        padding: EdgeInsets.zero,
                                      ),
                                      badgeContent: const Padding(
                                        padding: EdgeInsets.all(3.0),
                                        child: Text(' Live ',
                                            style: TextStyle(
                                                inherit: false,
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontFamily: 'notore')),
                                      )),
                                )
                              ],
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 4),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  keyIcon.keyIcon!.keyIcon[index].keyIconName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      height: 1.5,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    //? ปุ่มอื่นๆ
                    return InkWell(
                      onTap: () async {
                        var mchannel = "20";
                        var mchannelId = keysTab.id;
                        //LogApp
                        LogAppTisCall(mchannel, mchannelId);
                        //  End
                        switch (keysTab.keyIconKeyIndex.toLowerCase()) {
                          case 'activity':
                            Get.find<AppController>().setCurrentNavInget(3);
                            Get.toNamed("/backAppbarnotify",
                                parameters: {'changeView': '3'});
                            break;
                          case 'market':
                            Get.find<BadgerController>().getBadgerMarket();
                            Get.toNamed('/market',
                                parameters: {'type': 'home'});
                            break;
                          case 'special_project':
                            Get.to(() => const HomeSpecialProject());
                            break;
                          case 'content_list':
                            Get.find<HomeContentSpecialListController>()
                                .get_home_content_data("seemore");
                            Get.to(() => HomeSeemoreProduct(
                                  ref: 'key_icon',
                                ));
                            break;
                          case 'express_delivery':
                            Get.put(FetchDropshipShop()).fetchBannerDropship();
                            Get.put(FetchDropshipShop()).fetchProductDropship();
                            Get.to(() => HomeExpress());
                            break;
                          case 'live_friday':
                            // Get.to(() => const LiveMainPage());
                            break;
                          case 'payment':
                            Mslinfo profile = await getProfileMSL();
                            Get.to(
                                () => payment_cutomer(profile.mslInfo.arBal));
                            break;
                          case 'sharecatalog':
                            Get.toNamed("/sharecatalog");
                            break;
                          case 'catalog_home0':
                            Get.find<AppController>().setCurrentNavInget(1);
                            Get.offAll(() => MyHomePage(
                                  typeView: 'catelog',
                                  indexCatelog: 0,
                                ));
                            break;
                          case 'catalog_home1':
                            Get.find<AppController>().setCurrentNavInget(1);
                            Get.offAll(() => MyHomePage(
                                  typeView: 'catelog',
                                  indexCatelog: 1,
                                ));
                            break;
                          case 'delivery_status':
                            Get.toNamed(
                                "check_infor    mation_order_delivery_status");
                            break;
                          case 'url':
                            {
                              Get.to(() => WebViewFullScreen(
                                  mparamurl: keysTab.keyIconKeyValue));
                              break;
                            }
                          case 'url_external':
                            {
                              if (Platform.isIOS) {
                                await LaunchApp.openApp(
                                    iosUrlScheme: 'nonexistent-scheme://',
                                    appStoreLink: keysTab.keyIconKeyValue,
                                    openStore: true);
                              } else {
                                var url1 = Uri.parse(keysTab.keyIconKeyValue);
                                await launchUrl(
                                  url1,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            }
                          default:
                            break;
                        }
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Center(
                                  child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: CachedNetworkImage(
                                        imageUrl: keyIcon.keyIcon!
                                            .keyIcon[index].keyIconImgApp,
                                      )))),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 4),
                              child: Text(
                                textAlign: TextAlign.center,
                                keyIcon.keyIcon!.keyIcon[index].keyIconName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    height: 1.5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 14,
                      mainAxisExtent: 80,
                      crossAxisCount: 1),
                ),
              ),
            ),
          ),
        );
      }
    });
  }
}
