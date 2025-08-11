// ignore_for_file: must_be_immutable, use_build_context_synchronously, unrelated_type_equality_checks

// import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/theme/setbillcolor.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
// import 'package:flutter_carousel_slider/carousel_slider.dart';
// import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
// import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
// import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../controller/cart/cart_controller.dart';
import '../../controller/cart/function_add_to_cart.dart';
import '../../controller/home/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/languages/multi_languages.dart';
import '../login/anonymous_login.dart';
// import '../pageinitial/home.dart';
// import '../theme/theme_color.dart';
import '../theme/themeimage_menu.dart';
import 'cache_image.dart';

class HomeProductHotItem extends StatefulWidget {
  const HomeProductHotItem({super.key});

  @override
  State<HomeProductHotItem> createState() => _HomeProductHotItemState();
}

class _HomeProductHotItemState extends State<HomeProductHotItem> {
  ProductFromBanner bannerProduct = Get.put(ProductFromBanner());
  // @override
  // SetData data = SetData();
  // var loginStatus;
  var mChannel = '6';
  var mChannelId = '';

  @override
  Widget build(BuildContext context) {
    // bool show;
    double width = MediaQuery.of(context).size.width;
    return GetX<ProductHotItemHomeController>(
      builder: ((productHotItem) {
        if (!productHotItem.isDataLoading.value) {
          if (productHotItem.productHotItem!.hotItem.isNotEmpty) {
            return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (width >= 768.0) ? 3 : 2,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    mainAxisExtent: 290),
                itemCount: productHotItem
                    .productHotItem!.hotItem[0].dataSqlHotitemsDetail.length,
                itemBuilder: (context, index) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          /*
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(14, 0, 0, 0),
                            offset: Offset(0.0, 4.0),
                            blurRadius: 0.2,
                            spreadRadius: 0.2,
                          ), //BoxShadow
                        ],
                        *
                         */
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(children: [
                          GestureDetector(
                            onTap: () {
                              // !Get.to(() => DetailProduct() ใช้ได้
                              Get.find<ProductDetailController>()
                                  .productDetailController(
                                productHotItem.productHotItem!.hotItem[0]
                                    .dataSqlHotitemsDetail[index].campaign,
                                productHotItem.productHotItem!.hotItem[0]
                                    .dataSqlHotitemsDetail[index].billcode,
                                productHotItem.productHotItem!.hotItem[0]
                                    .dataSqlHotitemsDetail[index].media,
                                productHotItem.productHotItem!.hotItem[0]
                                    .dataSqlHotitemsDetail[index].sku,
                                mChannel,
                                mChannelId,
                              );
                              Get.to(() => const ProductDetailPage(
                                    ref: 'product',
                                    contentId: '',
                                  ));
                            },
                            child: Stack(
                              children: <Widget>[
                                if (productHotItem.productHotItem!.hotItem[0]
                                        .dataSqlHotitemsDetail[index].image ==
                                    '')
                                  Image.asset(imageError,
                                      height: 160, fit: BoxFit.contain)
                                else
                                  Center(
                                    child: CacheImageProduct(
                                        url: productHotItem
                                            .productHotItem!
                                            .hotItem[0]
                                            .dataSqlHotitemsDetail[index]
                                            .image),
                                    // child: CachedNetworkImage(
                                    //   imageUrl: productHotItem
                                    //       .productHotItem!
                                    //       .hotItem[0]
                                    //       .dataSqlHotitemsDetail[index]
                                    //       .image,
                                    //   height: 160,
                                    //   fit: BoxFit.contain,
                                    // ),
                                  ),
                                Positioned(
                                    top: 0.0,
                                    left: 0.0,
                                    child: CacheImagePrice(
                                        url: productHotItem
                                            .productHotItem!
                                            .hotItem[0]
                                            .dataSqlHotitemsDetail[index]
                                            .imgNetPrice,
                                        flagNetPrice: productHotItem
                                            .productHotItem!
                                            .hotItem[0]
                                            .dataSqlHotitemsDetail[index]
                                            .flagNetPrice)
                                    // child: CachedNetworkImage(
                                    //   imageUrl: productHotItem
                                    //       .productHotItem!
                                    //       .hotItem[0]
                                    //       .dataSqlHotitemsDetail[index]
                                    //       .imgNetPrice,
                                    // height: (productHotItem
                                    //             .productHotItem!
                                    //             .hotItem[0]
                                    //             .dataSqlHotitemsDetail[index]
                                    //             .flagNetPrice ==
                                    //         'Y')
                                    //     ? 60
                                    //     : 0,
                                    //),
                                    ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: CachedNetworkImage(
                                      imageUrl: productHotItem
                                          .productHotItem!
                                          .hotItem[0]
                                          .dataSqlHotitemsDetail[index]
                                          .imgAppend,
                                      height: (productHotItem
                                                  .productHotItem!
                                                  .hotItem[0]
                                                  .dataSqlHotitemsDetail[index]
                                                  .isInStock ==
                                              false)
                                          ? 80
                                          : 0,
                                    )),
                              ],
                            ),
                          ),
                          // if (show)
                          Flexible(
                            child: Wrap(
                              children: [
                                SizedBox(
                                  height: 60.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            productHotItem
                                                .productHotItem!
                                                .hotItem[0]
                                                .dataSqlHotitemsDetail[index]
                                                .name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 14),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${MultiLanguages.of(context)!.translate('product_code')} ${productHotItem.productHotItem!.hotItem[0].dataSqlHotitemsDetail[index].billcode}",
                                              style: TextStyle(
                                                  fontFamily: 'notoreg',
                                                  fontSize: 12,
                                                  color: setBillColor(
                                                      productHotItem
                                                          .productHotItem!
                                                          .hotItem[0]
                                                          .dataSqlHotitemsDetail[
                                                              index]
                                                          .color)),
                                            ),
                                            Text(
                                              "${MultiLanguages.of(context)!.translate('order_price_txt')} ${NumberFormat.decimalPattern().format(double.parse(productHotItem.productHotItem!.hotItem[0].dataSqlHotitemsDetail[index].price))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'notoreg',
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: BouncingWidget(
                                            duration: const Duration(
                                                milliseconds: 100),
                                            scaleFactor: 1.5,
                                            onPressed: () async {
                                              final Future<SharedPreferences>
                                                  prefs0 = SharedPreferences
                                                      .getInstance();

                                              final SharedPreferences prefs =
                                                  await prefs0;
                                              late String? lslogin;
                                              lslogin =
                                                  prefs.getString("login");

                                              if (lslogin == null) {
                                                Get.to(() =>
                                                    const Anonumouslogin());
                                              } else {
                                                await fnEditCart(
                                                  context,
                                                  productHotItem
                                                          .productHotItem!
                                                          .hotItem[0]
                                                          .dataSqlHotitemsDetail[
                                                      index],
                                                  'loadmore_page',
                                                  mChannel,
                                                  mChannelId,
                                                  ref: 'product',
                                                  contentId: '',
                                                );
                                              }
                                            },
                                            child: ImageBasget),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                });
          } else {
            return Container();
          }
        }
        return Container();
      }),
    );
  }
}
