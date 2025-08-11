import 'dart:io';

import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/widget/appbar_cart.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/badger/badger_controller.dart';
import '../../../../controller/home/home_controller.dart';
import '../../../../service/logapp/logapp_service.dart';
import '../../../webview/webview_full_screen.dart';
import '../../cache_image.dart';

class HomeSeemore extends StatelessWidget {
  HomeSeemore({super.key});
  final scroller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: appBarTitleCart('สิทธิพิเศษสำหรับสมาชิก', ""),
        body: Column(
          children: [
            GetX<SpecialPromotionController>(builder: ((promotion) {
              if (!promotion.isDataLoading.value) {
                if (promotion.promotion!.specialPromotion.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: promotion.promotion!.specialPromotion.length,
                        itemBuilder: (data, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: GestureDetector(
                                  onTap: () async {
                                    // print(promotion.promotion!
                                    //     .specialPromotion[index].specialimgapp);
                                    var logData = promotion
                                        .promotion!.specialPromotion[index];
                                    //LogApp
                                    LogAppTisCall(
                                        '4',
                                        promotion.promotion!
                                            .specialPromotion[index].id);
                                    InteractionLogger.logPrivileges(
                                      contentId: logData.id,
                                      contentName: logData.specialname,
                                      contentImage: logData.specialimgapp,
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
                                  child: CacheImagePromotion(
                                      url: promotion
                                          .promotion!
                                          .specialPromotion[index]
                                          .specialimgapp)),
                            ),
                          );
                        }),
                  );
                }
              }
              return Center(
                child: theme_loading_df,
              );
            })),
          ],
        ),
      ),
    );
  }
}
