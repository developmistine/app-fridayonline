// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously

// import 'dart:async';
// import 'dart:developer';

import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
// import 'package:fridayonline/homepage/pageinitial/category.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
// import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../controller/cart/function_add_to_cart.dart';
// import '../../controller/category/category_controller.dart';
import '../../controller/flashsale/flash_controller.dart';
import '../../model/flashsale/flashsale.dart';
import '../../service/flashsale/flashsale_service.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/logapp/logapp_service.dart';
import '../login/anonymous_login.dart';
import '../theme/themeimage_menu.dart';
import 'flashsale_detail.dart';

class FlashsaleHome extends StatefulWidget {
  const FlashsaleHome({super.key});
  @override
  State<FlashsaleHome> createState() => _FlashsaleHomeState();
}

class _FlashsaleHomeState extends State<FlashsaleHome> {
  @override
  void initState() {
    super.initState();
    if (!Get.put(FlashsaleTimerCount()).isDataLoading.value) {
      if (Get.put(FlashsaleTimerCount()).flashSaleData!.flashSale.isNotEmpty) {
        if (Get.put(FlashsaleTimerCount())
                .dataEndApi!
                .compareTo(Get.put(FlashsaleTimerCount()).dateNow) <=
            0) {
          Get.put(FlashsaleTimerCount()).flashSaleHome();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: GetBuilder<FlashsaleTimerCount>(builder: (data) {
        if (!data.isDataLoading.value &&
            data.flashSaleData!.flashSale.isNotEmpty) {
          var mchannelId = data.flashSaleData!.flashSale[0].id;
          return data.flashSaleData!.flashSale.isNotEmpty &&
                  data.dataEndApi!.compareTo(data.dateNow) >= 0 &&
                  data.dataStartApi!.compareTo(data.dateNow) <= 0
              ? Column(
                  children: [
                    Container(
                      color: const Color.fromRGBO(245, 245, 245, 1),
                      height: 10,
                    ),
                    CountdownFlashsale(mchannelId),
                    Container(
                      height: 2,
                      color: const Color.fromRGBO(245, 245, 245, 1),
                    ),
                    Container(
                      color: const Color.fromRGBO(245, 245, 245, 1),
                      height: 220,
                      width: double.infinity,
                      child: FutureBuilder(
                        future: FlashsaleHomeService(),
                        builder: (BuildContext context,
                            AsyncSnapshot<Flashsale?> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data!.flashSale.isNotEmpty) {
                            var dataFlash = snapshot.data;
                            var dataItemsCount =
                                snapshot.data!.flashSale[0].flashSale.length;
                            if (dataItemsCount >= 11) {
                              dataItemsCount = 10;
                            } else {
                              dataItemsCount = dataItemsCount;
                            }
                            return GridView.builder(
                              // shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: dataItemsCount,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == (dataItemsCount - 1) &&
                                    index > 1) {
                                  return Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: InkWell(
                                        onTap: (() => Get.to(() =>
                                            FlashSaleDetail(
                                                contentId: mchannelId))),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color:
                                                    Color.fromARGB(14, 0, 0, 0),
                                                offset: Offset(0.0, 4.0),
                                                blurRadius: 0.2,
                                                spreadRadius: 0.2,
                                              ), //BoxShadow
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                MultiLanguages.of(context)!
                                                    .translate(
                                                        'home_page_see_more'),
                                                style: TextStyle(
                                                    color: theme_color_df),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: theme_color_df,
                                              )
                                            ],
                                          )),
                                        ),
                                      ));
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(14, 0, 0, 0),
                                          offset: Offset(0.0, 4.0),
                                          blurRadius: 0.2,
                                          spreadRadius: 0.2,
                                        ), //BoxShadow
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(children: [
                                        // if (show)
                                        GestureDetector(
                                          onTap: () {
                                            var mchannel = '3';
                                            var mchannelId =
                                                dataFlash.flashSale[0].id;
                                            Get.find<ProductDetailController>()
                                                .productDetailController(
                                              dataFlash.flashSale[0]
                                                  .flashSale[index].campaign,
                                              dataFlash.flashSale[0]
                                                  .flashSale[index].billCode,
                                              dataFlash.flashSale[0]
                                                  .flashSale[index].mediaCode,
                                              dataFlash.flashSale[0]
                                                  .flashSale[index].sku,
                                              mchannel,
                                              mchannelId,
                                            );
                                            Get.to(() => ProductDetailPage(
                                                  ref: 'flashsale',
                                                  contentId:
                                                      dataFlash.flashSale[0].id,
                                                ));
                                          },
                                          child: Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: Center(
                                                  child: CachedNetworkImage(
                                                    imageUrl: dataFlash!
                                                        .flashSale[0]
                                                        .flashSale[index]
                                                        .img,
                                                    height: 75,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  top: 0,
                                                  right: 0.0,
                                                  child: Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topCenter,
                                                    children: [
                                                      Image.asset(
                                                          scale: 2,
                                                          'assets/images/flashsale/close_modal.png'),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            'ลด',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    boldText,
                                                                fontFamily:
                                                                    'notoreg',
                                                                inherit: false,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                              dataFlash
                                                                  .flashSale[0]
                                                                  .flashSale[
                                                                      index]
                                                                  .percentDiscount,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    boldText,
                                                                fontFamily:
                                                                    'notoreg',
                                                                inherit: false,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  )),
                                              // Positioned(
                                              //     top: 0.0,
                                              //     right: 0.0,
                                              //     child: Column(
                                              //       mainAxisAlignment:
                                              //           MainAxisAlignment.center,
                                              //       children: [
                                              //         const Text(
                                              //           textAlign:
                                              //               TextAlign.center,
                                              //           'ลด',
                                              //           style: TextStyle(
                                              //               color: Colors.white,
                                              //               fontSize: 12),
                                              //         ),
                                              //         Text(
                                              //             dataFlash
                                              //                 .flashSale[0]
                                              //                 .flashSale[index]
                                              //                 .percentDiscount,
                                              //             style: const TextStyle(
                                              //               color: Colors.white,
                                              //               fontSize: 13,
                                              //             )),
                                              //       ],
                                              //     )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Text(
                                              dataFlash.flashSale[0]
                                                  .flashSale[index].name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                        ),
                                        // const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.left,
                                                  "฿${dataFlash.flashSale[0].flashSale[index].specialPrice.replaceAll('.00', '')}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'notoreg',
                                                      color: Colors.red),
                                                ),
                                                Text(
                                                  textAlign: TextAlign.left,
                                                  "฿${dataFlash.flashSale[0].flashSale[index].price}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'notoreg',
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            BouncingWidget(
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              scaleFactor: 1.5,
                                              child: ImageBasget,
                                              onPressed: () async {
                                                SetData data = SetData();
                                                var lslogin =
                                                    await data.loginStatus;
                                                if (lslogin == "") {
                                                  Get.to(
                                                      transition: Transition
                                                          .rightToLeft,
                                                      () =>
                                                          const Anonumouslogin());
                                                } else {
                                                  await fnEditCart(
                                                    context,
                                                    dataFlash.flashSale[0]
                                                        .flashSale[index],
                                                    'FlashSale',
                                                    '3',
                                                    dataFlash.flashSale[0].id,
                                                    ref: 'flashsale',
                                                    contentId: dataFlash
                                                        .flashSale[0].id,
                                                  );
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        LinearPercentIndicator(
                                          padding: EdgeInsets.zero,
                                          alignment: MainAxisAlignment.center,
                                          animation: true,
                                          lineHeight: 15.0,
                                          animationDuration: 1500,
                                          percent: dataFlash.flashSale[0]
                                                  .flashSale[index].percentnum /
                                              100,
                                          backgroundColor: const Color.fromRGBO(
                                              164, 214, 241, 1),
                                          center: Text(
                                            dataFlash.flashSale[0]
                                                .flashSale[index].percentSale,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                          // ignore: prefer_const_constructors
                                          linearGradient: LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: const Alignment(0.8, 1),
                                            tileMode: TileMode.mirror,
                                            colors: <Color>[
                                              const Color.fromARGB(
                                                  255, 239, 100, 36),
                                              const Color.fromARGB(
                                                  255, 228, 40, 7),
                                            ],
                                          ),
                                          barRadius: const Radius.circular(10),
                                        ),
                                      ]),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 2,
                                      mainAxisExtent: 135,
                                      crossAxisCount: 1),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                    Container(
                      color: const Color.fromRGBO(245, 245, 245, 1),
                      height: 10,
                    ),
                  ],
                )
              : const SizedBox();
        }
        return const SizedBox();
      }),
    );
  }
}

class CountdownFlashsale extends StatelessWidget {
  final String chId;
  const CountdownFlashsale(
    this.chId, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  scale: 1.5,
                  'assets/images/flashsale/flashsale01.png',
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'จะสิ้นสุดใน ',
                      style: TextStyle(color: theme_red, fontWeight: boldText),
                    ),
                    GetX<FlashsaleTimerCount>(
                        builder: (data) => Row(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: Colors.grey.shade800,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 4),
                                    child: Text(
                                      data.hours.value,
                                      style: const TextStyle(
                                          inherit: false,
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                        fontWeight: boldText,
                                        color: Colors.black),
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: Colors.grey.shade800,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 4),
                                    child: Text(
                                      data.minutes.value,
                                      style: const TextStyle(
                                          inherit: false,
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                        fontWeight: boldText,
                                        color: Colors.black),
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: Colors.grey.shade800,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 4),
                                    child: Text(
                                      data.seconds.value,
                                      style: const TextStyle(
                                          inherit: false,
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                  ],
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: theme_color_df),
                  onPressed: () {
                    var mchannel = '3';
                    var mchannelId = chId;
                    LogAppTisCall(mchannel, mchannelId);
                    Get.to(() => FlashSaleDetail(contentId: chId));
                  },
                  child: Text(
                    MultiLanguages.of(context)!.translate('home_page_see_more'),
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
