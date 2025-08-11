// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/badger/badger_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../service/logapp/logapp_service.dart';
import '../theme/constants.dart';
import '../webview/webview_full_screen.dart';
import 'cache_image.dart';

class HomeSpecialPromotion extends StatefulWidget {
  const HomeSpecialPromotion({Key? key}) : super(key: key);

  @override
  State<HomeSpecialPromotion> createState() => _HomeSpecialPromotionState();
}

class _HomeSpecialPromotionState extends State<HomeSpecialPromotion> {
  @override
  Widget build(BuildContext context) {
    return GetX<SpecialPromotionController>(
      builder: ((promotion) {
        if (!promotion.isDataLoading.value) {
          if (promotion.promotion!.specialPromotion.isNotEmpty) {
            return Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: promotion.promotion!.specialPromotion.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: GestureDetector(
                            onTap: () {
                              print(promotion.promotion!.specialPromotion[index]
                                  .specialimgapp);
                              //LogApp
                              LogAppTisCall(
                                  '4',
                                  promotion
                                      .promotion!.specialPromotion[index].id);
                              //  End

                              if (promotion.promotion!.specialPromotion[index]
                                      .specialkeyindex ==
                                  'bwpoint') {
                                print('bwpoint');
                                //   Get.find<CatelogDetailController>().get_catelog_detail(
                                // result.ecatalogDetail[index].catalogCampaign,
                                // result.ecatalogDetail[index].catalogBrand,
                                // result.ecatalogDetail[index].catalogMedia);
                                Get.toNamed('/special_promotion_bwpoint');
                              } else if (promotion
                                      .promotion!
                                      .specialPromotion[index]
                                      .specialkeyindex ==
                                  'market') {
                                Get.find<BadgerController>().getBadgerMarket();
                                Get.toNamed('/market',
                                    parameters: {'type': 'home'});
                              } else if (promotion
                                      .promotion!
                                      .specialPromotion[index]
                                      .specialkeyindex ==
                                  'url') {
                                Get.to(() => WebViewFullScreen(
                                    mparamurl: promotion
                                        .promotion!
                                        .specialPromotion[index]
                                        .specialdataindex));
                                print(promotion.promotion!
                                    .specialPromotion[index].specialdataindex);
                              }
                            },
                            child: CacheImagePromotion(
                                url: promotion.promotion!
                                    .specialPromotion[index].specialimgapp)
                            // child: CachedNetworkImage(
                            //   imageUrl: promotion
                            //       .promotion!.specialPromotion[index].specialimgapp,
                            //   fit: BoxFit.cover,
                            //   width: MediaQuery.of(context).size.width,
                            // ),
                            ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return Container();
          }
        }
        return Column(
          children: [
            Shimmer.fromColors(
              highlightColor: kBackgroundColor,
              baseColor: const Color(0xFFE0E0E0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  height: 100,
                  color: Colors.grey[400],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Shimmer.fromColors(
              highlightColor: kBackgroundColor,
              baseColor: const Color(0xFFE0E0E0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  height: 200,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
