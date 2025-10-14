import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/controller/track.ctr.dart';
import 'package:fridayonline/member/utils/cached_image.dart';
import 'package:fridayonline/member/views/(initials)/brand/brand.view.dart';
import 'package:fridayonline/member/widgets/seeall.button.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FridayMall extends StatefulWidget {
  const FridayMall({super.key});

  @override
  State<FridayMall> createState() => _FridayMallState();
}

class _FridayMallState extends State<FridayMall> {
  final EndUserHomeCtr endUserHomeCtr = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FRIDAY MALL',
                style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 16,
                    color: themeColorDefault,
                    fontWeight: FontWeight.w900),
              ),
              InkWell(
                onTap: () {
                  Get.offAllNamed('/EndUserHome',
                      parameters: {'changeView': "1"});
                },
                child: buttonSeeAll(),
              ),
            ],
          ),
        ),
        Obx(() {
          if (endUserHomeCtr.isLoadingMall.value) {
            return const SizedBox();
          }
          var mallItems = endUserHomeCtr.mall!.data;
          if (mallItems.isEmpty) {
            return const SizedBox();
          }
          return InkWell(
              onTap: () {
                Get.offAllNamed('/EndUserHome',
                    parameters: {'changeView': "1"});
              },
              child: CacheImageBannerShop(
                url: mallItems.first.image,
              ));
          // child: CachedNetworkImage(imageUrl: mallItems.first.image));
        }),
        Obx(() {
          if (endUserHomeCtr.isLoadingBrands.value) {
            return const SizedBox();
          }
          var brandItems = endUserHomeCtr.brands!.data;
          if (brandItems.isEmpty) {
            return const SizedBox();
          }
          return Container(
              color: Colors.white,
              child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: Row(
                    children: List.generate(brandItems.length, (index) {
                      var items = brandItems[index];
                      return InkWell(
                        onTap: () async {
                          Get.find<TrackCtr>()
                              .setLogContentAddToCart(items.id, 'home_brands');
                          Get.find<TrackCtr>().setDataTrack(
                            items.id,
                            items.brandName,
                            "home_brands",
                          );
                          Get.find<BrandCtr>()
                              .fetchShopData(items.brandId, path: 'brands');
                          await Get.toNamed('/BrandItems/${items.brandId}',
                                  arguments: items.sectionId == 0 ? 0 : 1,
                                  parameters: {
                                "sectionId": items.sectionId.toString(),
                                "viewType": items.sectionId == 0 ? '0' : '1',
                              })!
                              .then((res) {
                            Get.find<TrackCtr>().clearLogContent();
                          });
                        },
                        child: Container(
                            clipBehavior: Clip.antiAlias,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade100),
                              color: Colors.white,
                            ),
                            width: Get.width >= 768 ? 180 : 145,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              clipBehavior: Clip.none,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2,
                                      bottom: 38.0,
                                      left: 18,
                                      right: 18),
                                  child: CacheImageProducts(
                                    url: items.productImage,
                                    height: Get.width >= 768 ? 140 : 120,
                                  ),
                                ),
                                Positioned(
                                    bottom: 4,
                                    child: BrandItem(
                                        url: items.icon,
                                        shopId: items.sellerId,
                                        radius: 30,
                                        isLoading: false)),
                              ],
                            )),
                      );
                    }),
                  )));
        }),
        const SizedBox(
          height: 18,
        )
      ],
    );
  }
}
