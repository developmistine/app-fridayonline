import 'dart:async';

import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/components/flashdeal/flashdeal.timer.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/models/flashsale/flashsale.model.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

final EndUserHomeCtr endUserHomeCtr = Get.find();

class FlashSaleEndUser extends StatefulWidget {
  const FlashSaleEndUser({super.key});

  @override
  State<FlashSaleEndUser> createState() => _FlashSaleEndUserState();
}

class _FlashSaleEndUserState extends State<FlashSaleEndUser> {
  final ScrollController _scrollController = ScrollController();
  int offset = 20;
  int count = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchMoreProductContent();
      }
    });
  }

  void fetchMoreProductContent() async {
    endUserHomeCtr.isLoadMoreFlashSale.value = true;

    try {
      // ดึงข้อมูลใหม่จาก API
      final newFlashSale = await endUserHomeCtr.fetchMoreFlashSale(offset);

      if (newFlashSale!.data.productContent.isNotEmpty) {
        endUserHomeCtr.flashSale!.data.productContent
            .addAll(newFlashSale.data.productContent);
        offset += 20;
      }
    } finally {
      endUserHomeCtr.isLoadMoreFlashSale.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    offset = 20;
    _scrollController.dispose();
    endUserHomeCtr.resetFlashSale();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.ibmPlexSansThai())),
          textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
            appBar: appBarMasterEndUser('สินค้าลดราคา'),
            body: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (endUserHomeCtr.flashSale!.data.contentImg != "")
                      CachedNetworkImage(
                        imageUrl: endUserHomeCtr.flashSale!.data.contentImg,
                        errorWidget: (context, url, error) {
                          return const SizedBox();
                        },
                      ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.grey.shade100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/b2c/logo/supperday_fair_red.png',
                            width: 140,
                          ),
                          time(),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: endUserHomeCtr
                              .flashSale!.data.productContent.length +
                          (endUserHomeCtr.isLoadMoreFlashSale.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        var product = endUserHomeCtr
                            .flashSale!.data.productContent[index];
                        return InkWell(
                          onTap: () {
                            Get.find<ShowProductSkuCtr>().fetchB2cProductDetail(
                                product.productId, 'home_flashsale');
                            Get.toNamed(
                              '/ShowProductSku/${product.productId}',
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(bottom: BorderSide(width: 0.1))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                image(product),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: Text(
                                          product.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.ibmPlexSansThai(
                                              fontSize: 12),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '฿${myFormat.format(product.price)}',
                                            style: GoogleFonts.ibmPlexSansThai(
                                                height: 1,
                                                color:
                                                    Colors.deepOrange.shade700,
                                                fontSize: 16),
                                            textAlign: TextAlign.end,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            '฿${myFormat.format(product.priceBeforeDiscount)}',
                                            style: GoogleFonts.ibmPlexSansThai(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey,
                                                fontSize: 12),
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 6),
                                              child: LinearPercentIndicator(
                                                padding: EdgeInsets.zero,
                                                alignment:
                                                    MainAxisAlignment.center,
                                                animation: true,
                                                lineHeight: 13.0,
                                                animationDuration: 1500,
                                                percent: percentColor(product),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 241, 174, 164),
                                                center: Text(
                                                  'ขายแล้ว ${myFormat.format(product.stock)} ชิ้น',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1.1),
                                                ),
                                                linearGradient:
                                                    const LinearGradient(
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment(0.8, 1),
                                                  tileMode: TileMode.mirror,
                                                  colors: <Color>[
                                                    Color.fromARGB(
                                                        255, 228, 40, 7),
                                                    Color.fromARGB(
                                                        255, 239, 161, 36),
                                                  ],
                                                ),
                                                barRadius:
                                                    const Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          SizedBox(
                                            height: 30,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        themeColorDefault,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8))),
                                                onPressed: () {
                                                  Get.find<ShowProductSkuCtr>()
                                                      .fetchB2cProductDetail(
                                                          product.productId,
                                                          'home_flashsale');
                                                  Get.toNamed(
                                                    '/ShowProductSku/${product.productId}',
                                                  );
                                                },
                                                child: const Text(
                                                  'ซื้อเลย',
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                )),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Obx(() => endUserHomeCtr.isLoadMoreFlashSale.value
                        ? Center(
                            child: Column(
                              children: [
                                Text(
                                  'กำลังโหลด...',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ibmPlexSansThai(
                                      color: themeColorDefault,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink()),
                  ],
                ))),
      ),
    );
  }

  double percentColor(ProductContent product) {
    var percent = product.stock / product.flashSaleStock;
    if (percent > 1) {
      return 1;
    } else if (percent < 0) {
      return 0;
    }
    return percent;
  }

  Expanded image(ProductContent product) {
    return Expanded(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: product.image,
                errorWidget: (context, url, error) {
                  return const SizedBox();
                },
              ),
              if (product.isImageOverlayed)
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: CachedNetworkImage(
                    imageUrl: product.imageOverlay,
                    width: 160,
                  ),
                ),
              if (product.isOutOfStock)
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: Center(
                      child: Text(
                        'สินค้าหมด',
                        style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset(
                scale: 5,
                'assets/images/b2c/icon/label_flashsale.png',
              ),
              Column(
                children: [
                  Text(
                    '${product.discount}%',
                    style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    'ลด',
                    style: GoogleFonts.ibmPlexSansThai(
                        height: 1, fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Container time() {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'หมดเวลาใน',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13,
            ),
          ),
          flashDealTimer(),
          const SizedBox(
            width: 4,
          )
        ],
      ),
    );
  }
}
