import 'package:appfridayecommerce/enduser/controller/enduser.home.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/topproduct.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/track.ctr.dart';
import 'package:appfridayecommerce/enduser/utils/cached_image.dart';
import 'package:appfridayecommerce/enduser/views/(top)/top.product.dart';
import 'package:appfridayecommerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BestSellingProducts extends StatefulWidget {
  const BestSellingProducts({super.key});

  @override
  State<BestSellingProducts> createState() => _BestSellingProductsState();
}

class _BestSellingProductsState extends State<BestSellingProducts> {
  final EndUserHomeCtr endUserHomeCtr = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (endUserHomeCtr.isLoadingTopSales.value) {
        return const SizedBox();
      }
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade100,
                    Colors.grey.shade50,
                  ]),
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  image:
                      AssetImage('assets/images/b2c/background/bg-blue.png'))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'สินค้าขายดี',
                        style: GoogleFonts.notoSansThaiLooped(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Image.asset(
                        'assets/images/b2c/icon/shopping.png',
                        width: 24,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Get.find<TopProductsCtr>().setActiveTab(0);
                      Get.find<TopProductsCtr>().fetchTopProducts(
                          endUserHomeCtr.topSalesWeekly!.data.first.prodlineId);
                      Get.to(() => const TopProductsWeekly());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        children: [
                          Text(
                            'ดูทั้งหมด',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.black,
                            size: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                          endUserHomeCtr.topSalesWeekly!.data.length, (index) {
                        var items = endUserHomeCtr.topSalesWeekly!.data[index];
                        return Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.find<TopProductsCtr>().setActiveTab(index);
                                Get.find<TopProductsCtr>().fetchTopProducts(
                                    endUserHomeCtr.topSalesWeekly!.data[index]
                                        .prodlineId);
                                Get.find<TrackCtr>().trackContentId =
                                    endUserHomeCtr
                                        .topSalesWeekly!.data[index].prodlineId;
                                Get.to(() => const TopProductsWeekly());
                              },
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                margin:
                                    const EdgeInsets.only(right: 12, bottom: 8),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300
                                            .withOpacity(0.5),
                                        offset: const Offset(0, 6),
                                        blurRadius: 4,
                                        // spreadRadius: 1,
                                      )
                                    ],
                                    border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 0.1),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                          child: CacheImageProducts(
                                        height: 150,
                                        url: items.image,
                                      )),
                                      Container(
                                        width: Get.width,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (items.selling != "")
                                              Container(
                                                color: themeColorDefault,
                                                width: Get.width,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6),
                                                child: Text(
                                                  items.selling,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts
                                                      .notoSansThaiLooped(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                ),
                                              ),
                                            Container(
                                              color: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              height: 45,
                                              child: Center(
                                                child: Text(
                                                  items.displayName,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                    ],
                  )),
            ],
          ),
        ),
      );
    });
  }
}
