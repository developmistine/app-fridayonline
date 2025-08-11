// ignore_for_file: must_be_immutable, use_build_context_synchronously, unrelated_type_equality_checks

// import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/theme/setbillcolor.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
// import 'package:flutter_carousel_slider/carousel_slider.dart';
// import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
// import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../controller/cart/cart_controller.dart';
import '../../controller/cart/function_add_to_cart.dart';
import '../../controller/home/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../controller/category/category_controller.dart';
import '../../service/languages/multi_languages.dart';
import '../login/anonymous_login.dart';
// import '../pageinitial/home.dart';
// import '../theme/theme_color.dart';
import '../theme/themeimage_menu.dart';
import 'cache_image.dart';

class HomeProductHotItemHoursBrand extends StatefulWidget {
  const HomeProductHotItemHoursBrand({super.key});

  @override
  State<HomeProductHotItemHoursBrand> createState() =>
      _HomeProductHotItemHoursBrandState();
}

class _HomeProductHotItemHoursBrandState
    extends State<HomeProductHotItemHoursBrand> {
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
            return MasonryGridView.builder(
                shrinkWrap: true,
                primary: false,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (width >= 768.0) ? 3 : 2,
                ),
                itemCount: productHotItem
                    .productHotItem!.hotItem[0].dataSqlHotitemsDetail.length,
                itemBuilder: (context, index) {
                  // (productHotItem.productHotItem!.hotItem[0]
                  //             .dataSqlHotitemsDetail[index].image !=
                  //         '')
                  //     ? show = true
                  //     : show = false;

                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(children: [
                          GestureDetector(
                            onTap: () {
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
                            //? ภาพ
                            child: Stack(
                              children: <Widget>[
                                if (productHotItem.productHotItem!.hotItem[0]
                                        .dataSqlHotitemsDetail[index].image ==
                                    '')
                                  Image.asset(imageError,
                                      height: 160, fit: BoxFit.contain)
                                else
                                  //? ภาพสินค้า
                                  Center(
                                    child: CacheImageProduct(
                                        url: productHotItem
                                            .productHotItem!
                                            .hotItem[0]
                                            .dataSqlHotitemsDetail[index]
                                            .image),
                                  ),
                                //? ราคาสุทธิ
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
                                //? สินค้าหมดสต็อก
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
                          //? ชื่อสินค้า
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 4, left: 14, right: 14),
                            child: Row(children: [
                              Expanded(
                                child: productHotItem
                                            .productHotItem!
                                            .hotItem[0]
                                            .dataSqlHotitemsDetail[index]
                                            .flagHouseBrand ==
                                        'Y'
                                    ? Stack(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.left,
                                            '          ${productHotItem.productHotItem!.hotItem[0].dataSqlHotitemsDetail[index].name}',
                                            maxLines: 3,
                                            style: const TextStyle(
                                              height: 1.5,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Image.asset(
                                              scale: 23,
                                              'assets/images/home/HB.png')
                                        ],
                                      )
                                    : Text(
                                        textAlign: TextAlign.start,
                                        productHotItem
                                            .productHotItem!
                                            .hotItem[0]
                                            .dataSqlHotitemsDetail[index]
                                            .name,
                                        maxLines: 3,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                              ),
                            ]),
                          ),
                          //? รหัสสินค้า ราคา ปุ่มหยิบใส่ตระกร้า
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //? รหัสสินค้า
                                      Text(
                                          "${MultiLanguages.of(context)!.translate('product_code')} ${productHotItem.productHotItem!.hotItem[0].dataSqlHotitemsDetail[index].billcode}",
                                          style: TextStyle(
                                            fontFamily: 'notoreg',
                                            fontSize: 12,
                                            color: setBillColor(
                                              productHotItem
                                                  .productHotItem!
                                                  .hotItem[0]
                                                  .dataSqlHotitemsDetail[index]
                                                  .color,
                                            ),
                                          )),
                                      //? ราคา
                                      Text(
                                        "${MultiLanguages.of(context)!.translate('order_price_txt')} ${NumberFormat.decimalPattern().format(double.parse(productHotItem.productHotItem!.hotItem[0].dataSqlHotitemsDetail[index].price))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'notoreg',
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      //! fade review
                                      if (productHotItem
                                              .productHotItem!
                                              .hotItem[0]
                                              .dataSqlHotitemsDetail[index]
                                              .totalReview >
                                          0)
                                        Wrap(
                                          runAlignment: WrapAlignment.center,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Text(
                                              productHotItem
                                                  .productHotItem!
                                                  .hotItem[0]
                                                  .dataSqlHotitemsDetail[index]
                                                  .ratingProduct
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: 'notoreg',
                                                  inherit: false,
                                                  color: theme_color_df,
                                                  fontSize: 14),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0,
                                                  left: 4,
                                                  right: 4),
                                              child: Image.asset(
                                                  scale: 1.8,
                                                  'assets/images/home/star.png'),
                                            ),
                                            Text(
                                              '(${productHotItem.productHotItem!.hotItem[0].dataSqlHotitemsDetail[index].totalReview})',
                                              style: TextStyle(
                                                  fontFamily: 'notoreg',
                                                  inherit: false,
                                                  color: theme_color_df,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                                //? ปุ่มหยิบใส่ตระกร้า
                                Expanded(
                                  child: BouncingWidget(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      scaleFactor: 1.5,
                                      onPressed: () async {
                                        final Future<SharedPreferences> prefs0 =
                                            SharedPreferences.getInstance();

                                        final SharedPreferences prefs =
                                            await prefs0;
                                        late String? lslogin;
                                        lslogin = prefs.getString("login");
                                        var mChannel = '6';
                                        var mChannelId = '';

                                        if (lslogin == null) {
                                          Get.to(() => const Anonumouslogin());
                                        } else {
                                          await fnEditCart(
                                            context,
                                            productHotItem
                                                .productHotItem!
                                                .hotItem[0]
                                                .dataSqlHotitemsDetail[index],
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
