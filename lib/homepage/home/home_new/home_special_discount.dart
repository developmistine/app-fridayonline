import 'dart:io';

import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/badger/badger_controller.dart';
import '../../../controller/home/home_controller.dart';
import '../../../service/logapp/logapp_service.dart';
import '../../theme/constants.dart';
import '../../theme/theme_color.dart';
import '../../webview/webview_full_screen.dart';
import '../cache_image.dart';
import 'home_more_special/home_special_seemore.dart';

class HomeSpecial extends StatelessWidget {
  final ScrollController keyIconScroller = ScrollController();
  final Color colorBg = const Color.fromARGB(255, 229, 228, 228);

  HomeSpecial({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<SpecialPromotionController>(builder: ((promotion) {
      if (!promotion.isDataLoading.value) {
        if (promotion.promotion!.specialPromotion.isNotEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 8,
                color: colorBg,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width >= 768 ? 450 : 290,
                // decoration: const BoxDecoration(color: Colors.amber),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18.0, top: 8),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (promotion.promotion!.repType == '2')
                            Text(
                              'สิทธิพิเศษสำหรับสมาชิก',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: theme_color_df,
                                  fontWeight: FontWeight.bold),
                            )
                          else if (promotion.promotion!.repType == '1' ||
                              promotion.promotion!.repType == '3')
                            Text(
                              'สิทธิพิเศษสำหรับคุณ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: theme_color_df,
                                  fontWeight: FontWeight.bold),
                            )
                          else
                            Text(
                              'ประชาสัมพันธ์',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: theme_color_df,
                                  fontWeight: FontWeight.bold),
                            ),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: theme_color_df),
                                onPressed: () {
                                  Get.to(() => HomeSeemore());
                                },
                                child: const Text(
                                  'ดูเพิ่มเติม',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                )),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView(
                      // physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      controller: keyIconScroller,
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: CarouselSlider.builder(
                            autoSliderDelay: const Duration(seconds: 6),
                            autoSliderTransitionTime:
                                const Duration(milliseconds: 500),
                            unlimitedMode:
                                promotion.promotion!.specialPromotion.length -
                                            1 >=
                                        1
                                    ? true
                                    : false,
                            initialPage: 0,
                            enableAutoSlider:
                                promotion.promotion!.specialPromotion.length -
                                            1 >=
                                        1
                                    ? true
                                    : false,
                            slideIndicator: CircularSlideIndicator(
                                indicatorRadius: 3,
                                itemSpacing: 10,
                                currentIndicatorColor: theme_color_df,
                                indicatorBackgroundColor: Colors.grey),
                            slideBuilder: (index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () async {
                                      var logData = promotion
                                          .promotion!.specialPromotion[index];
                                      //LogApp
                                      InteractionLogger.logPrivileges(
                                        contentId: logData.id,
                                        contentName: logData.specialname,
                                        contentImage: logData.specialimgapp,
                                      );
                                      LogAppTisCall(
                                        '4',
                                        promotion.promotion!
                                            .specialPromotion[index].id,
                                      );

                                      final specialKeyIndex = promotion
                                          .promotion!
                                          .specialPromotion[index]
                                          .specialkeyindex;
                                      final specialDataIndex = promotion
                                          .promotion!
                                          .specialPromotion[index]
                                          .specialdataindex;

                                      final specialIndexUrl = promotion
                                          .promotion!
                                          .specialPromotion[index]
                                          .specialindexurl;

                                      switch (specialKeyIndex) {
                                        case 'bwpoint':
                                          Get.toNamed(
                                              '/special_promotion_bwpoint');
                                          break;
                                        case 'sharecatalog':
                                          Get.toNamed('/sharecatalog');
                                          break;
                                        case 'market':
                                          Get.find<BadgerController>()
                                              .getBadgerMarket();
                                          Get.toNamed('/market',
                                              parameters: {'type': 'home'});
                                          break;
                                        case 'url':
                                          {
                                            Get.to(() => WebViewFullScreen(
                                                mparamurl: specialDataIndex));
                                            break;
                                          }
                                        case 'url_external':
                                          {
                                            if (Platform.isIOS) {
                                              await LaunchApp.openApp(
                                                  iosUrlScheme:
                                                      'nonexistent-scheme://',
                                                  appStoreLink: specialIndexUrl,
                                                  openStore: true);
                                            } else {
                                              var url1 =
                                                  Uri.parse(specialIndexUrl);
                                              await launchUrl(
                                                url1,
                                                mode: LaunchMode
                                                    .externalApplication,
                                              );
                                            }
                                          }
                                        default:
                                          break;
                                      }
                                    },
                                    child: CacheImageDiscount(
                                        url: promotion
                                            .promotion!
                                            .specialPromotion[index]
                                            .specialimgapp)),
                              );
                            },
                            itemCount:
                                promotion.promotion!.specialPromotion.length,
                          ),
                        ),
                      ],
                    ))
                  ]),
                ),
              ),
              Container(
                height: 8,
                color: colorBg,
              ),
            ],
          );
        } else {
          return Container();
        }
      }
      return Column(
        children: [
          Container(
            height: 8,
            color: colorBg,
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, left: 8.0, right: 8.0, bottom: 16.0),
            child: Column(
              children: [
                Shimmer.fromColors(
                  highlightColor: kBackgroundColor,
                  baseColor: const Color(0xFFE0E0E0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          child: const SizedBox(),
                          onPressed: () {},
                        )),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 200,
                    child: Shimmer.fromColors(
                        highlightColor: kBackgroundColor,
                        baseColor: const Color(0xFFE0E0E0),
                        child: Container(
                          color: Colors.grey,
                          height: 280,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 8,
            color: colorBg,
          ),
        ],
      );
    }));
  }
}
