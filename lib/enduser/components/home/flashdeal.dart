import 'package:fridayonline/enduser/components/shimmer/shimmer.product.dart';
import 'package:fridayonline/enduser/controller/enduser.home.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/enduser/controller/track.ctr.dart';
import 'package:fridayonline/enduser/utils/format.dart';
import 'package:fridayonline/enduser/views/(flashdeal)/flashdeal.deail.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class FlashDealFriday extends StatelessWidget {
  const FlashDealFriday({super.key});

  @override
  Widget build(BuildContext context) {
    final EndUserHomeCtr endUserHomeCtr = Get.find();

    return Obx(() {
      return endUserHomeCtr.isCloseFlashSale.value
          ? const SizedBox.shrink()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return !endUserHomeCtr.isLoadingFlashDeal.value
                            ? FlashDealCountDownHomePage(
                                data: endUserHomeCtr.countdown.value,
                                seemoreText: seemoreTextHomePage)
                            : const SizedBox();
                      }),
                      Obx(() {
                        if (!endUserHomeCtr.isLoadingFlashDeal.value) {
                          List<Widget> productList = List.generate(
                            endUserHomeCtr
                                        .flashSale!.data.productContent.length >
                                    9
                                ? 9
                                : endUserHomeCtr
                                    .flashSale!.data.productContent.length,
                            (index) {
                              return FlashDealProductItem(
                                product: endUserHomeCtr
                                    .flashSale!.data.productContent[index],
                                referrer: 'home_flashsale',
                              );
                            },
                          );
                          productList.add(seeMoreFlashSale());
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: Get.width,
                                height: 258,
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black,
                                        Colors.transparent,
                                      ],
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: Image.asset(
                                    'assets/images/b2c/background/bg-red.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                  child: Container(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 12),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, bottom: 8, top: 4),
                                    child: Row(children: productList),
                                  ),
                                ),
                              )),
                            ],
                          );
                        } else {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: List.generate(12, (index) {
                              return Container(
                                  width: 140,
                                  margin: const EdgeInsets.only(right: 8),
                                  child: const ShimmerProductItem());
                            })),
                          );
                        }
                      })
                    ],
                  ),
                ),
              ],
            );
    });
  }

  Widget seemoreText() {
    return InkWell(
      onTap: () {
        Get.find<TrackCtr>().setDataTrack(
            endUserHomeCtr.flashSale!.data.contentId,
            endUserHomeCtr.flashSale!.data.contentHeader,
            'home_flash_sale');
        Get.to(() => const FlashSaleEndUser());
      },
      child: const Row(
        children: [
          Text(
            'ดูเพิ่มเติม',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
          )
        ],
      ),
    );
  }

  Widget seemoreTextHomePage() {
    return InkWell(
      onTap: () {
        Get.find<TrackCtr>().setDataTrack(
            endUserHomeCtr.flashSale!.data.contentId,
            endUserHomeCtr.flashSale!.data.contentHeader,
            'home_flash_sale');
        Get.to(() => const FlashSaleEndUser());
      },
      child: const Row(
        children: [
          Text(
            'ดูเพิ่มเติม',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
          ),
          SizedBox(
            width: 4,
          ),
          SizedBox(
            width: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget seeMoreFlashSale() {
    return InkWell(
      onTap: () {
        Get.find<TrackCtr>().setDataTrack(
            endUserHomeCtr.flashSale!.data.contentId,
            endUserHomeCtr.flashSale!.data.contentHeader,
            'home_flash_sale');
        Get.to(() => const FlashSaleEndUser());
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          height: 215,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ดูเพิ่มเติม',
                style: TextStyle(color: themeColorDefault),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: themeColorDefault,
              )
            ],
          )),
        ),
      ),
    );
  }
}

class FlashDealCountDown extends StatelessWidget {
  const FlashDealCountDown(
      {super.key, required this.data, required this.seemoreText});
  final String data;
  final Widget Function() seemoreText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/banner/flashSales.png',
              width: 100,
            ),
            const SizedBox(
              width: 4,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2)),
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                child: Text(
                  data.split(":")[0],
                  style: const TextStyle(
                      inherit: false, color: Colors.white, fontSize: 13),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text(
                ':',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2)),
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                child: Text(
                  data.split(":")[1],
                  style: const TextStyle(
                      inherit: false, color: Colors.white, fontSize: 13),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text(
                ':',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2)),
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                child: Text(
                  data.split(":")[2],
                  style: const TextStyle(
                      inherit: false, color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
        seemoreText()
      ],
    );
  }
}

class FlashDealCountDownHomePage extends StatelessWidget {
  const FlashDealCountDownHomePage(
      {super.key, required this.data, required this.seemoreText});
  final String data;
  final Widget Function() seemoreText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              fit: BoxFit.cover,
              image:
                  AssetImage('assets/images/b2c/background/bg-label-red.png'))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/b2c/logo/supperday_fair.png',
                  width: 180,
                ),
                Row(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 4),
                        child: Text(
                          data.split(":")[0],
                          style: const TextStyle(
                              inherit: false,
                              color: Colors.white,
                              fontSize: 13),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        ':',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 4),
                        child: Text(
                          data.split(":")[1],
                          style: const TextStyle(
                              inherit: false,
                              color: Colors.white,
                              fontSize: 13),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        ':',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 4),
                        child: Text(
                          data.split(":")[2],
                          style: const TextStyle(
                              inherit: false,
                              color: Colors.white,
                              fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              seemoreText(),
              const SizedBox(width: 12),
            ],
          )
        ],
      ),
    );
  }
}

class FlashDealProductItem extends StatelessWidget {
  const FlashDealProductItem(
      {super.key, required this.product, required this.referrer, this.height});
  final dynamic product;
  final String referrer;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Get.find<ShowProductSkuCtr>()
                .fetchB2cProductDetail(product.productId, referrer);
            Get.toNamed(
              '/ShowProductSku/${product.productId}',
            );
          },
          child: Container(
            width: 160,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300.withOpacity(0.5),
                  offset: const Offset(0, 6),
                  blurRadius: 4,
                  // spreadRadius: 1,
                )
              ],
            ),
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (height != null)
                    const SizedBox(
                      height: 8,
                    ),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: height ?? 152),
                          child: CachedNetworkImage(
                            width: Get.width,
                            imageUrl: product.image,
                          ),
                        ),
                        if (product.isImageOverlayed)
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: CachedNetworkImage(
                              imageUrl: product.imageOverlay,
                              width: 170,
                            ),
                          ),
                        if (product.isOutOfStock)
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: Center(
                                child: Text(
                                  'สินค้าหมด',
                                  style: GoogleFonts.notoSansThaiLooped(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '฿${myFormat.format(product.price)}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              '฿${myFormat.format(product.priceBeforeDiscount)}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearPercentIndicator(
                          padding: EdgeInsets.zero,
                          alignment: MainAxisAlignment.center,
                          animation: true,
                          lineHeight: 18.0,
                          animationDuration: 1500,
                          percent: barStatus(),
                          backgroundColor: const Color(0xFFE2E2E4),
                          center: Text(
                            'ขายแล้ว ${myFormat.format(product.stock)} ชิ้น',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                height: 1.3,
                                fontWeight: FontWeight.bold),
                          ),
                          linearGradient: const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment(0.8, 1),
                            tileMode: TileMode.mirror,
                            colors: <Color>[
                              Color.fromARGB(255, 228, 40, 7),
                              Color.fromARGB(255, 239, 161, 36),
                            ],
                          ),
                          barRadius: const Radius.circular(10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            top: 4,
            right: 18,
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Image.asset(
                  scale: 5,
                  'assets/images/b2c/icon/label_flashsale.png',
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      textAlign: TextAlign.center,
                      'ลด',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          inherit: false,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                    Text("${product.discount}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          inherit: false,
                          color: Colors.white,
                          fontSize: 12,
                        )),
                  ],
                )
              ],
            ))
      ],
    );
  }

  barStatus() {
    bool num1 = product.stock / product.flashSaleStock < 0;
    bool num2 = product.stock / product.flashSaleStock > 1;
    if (num1) {
      return 0.0;
    } else if (num2) {
      return 1.0;
    } else {
      return product.stock / product.flashSaleStock;
    }
  }
}
