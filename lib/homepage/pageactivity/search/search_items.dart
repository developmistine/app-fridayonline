// import 'package:fridayonline/controller/cart/cart_controller.dart';
// import 'package:fridayonline/controller/category/category_controller.dart';
import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/controller/search_product/search_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/theme/setbillcolor.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:fridayonline/homepage/widget/appbar_cart.dart';
// import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/cart/function_add_to_cart.dart';
import '../../../service/languages/multi_languages.dart';
import '../../login/anonymous_login.dart';

class ShowSearchList extends StatelessWidget {
  const ShowSearchList(
      {super.key,
      required this.showAppbar,
      required this.pChannel,
      required this.contentId});
  final bool showAppbar;
  final String contentId;
  final String pChannel;

  @override
  Widget build(BuildContext context) {
    ShowSearchProductController searchItems =
        Get.put(ShowSearchProductController());
    double width = MediaQuery.of(context).size.width;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
          appBar: showAppbar
              ? appBarTitleCart(
                  MultiLanguages.of(context)!
                      .translate('home_page_list_products'),
                  "")
              : null,
          body: Obx(() => searchItems.isDataLoading.value
              ? Center(
                  child: theme_loading_df,
                )
              : searchItems.itemsSearch!.skucode.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                                'assets/images/logo/logofriday.png',
                                width: 70),
                          ),
                          const Text(
                            'ไม่พบสินค้า',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'notoreg'),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: (width >= 768.0) ? 3 : 2,
                                  mainAxisSpacing: 2.0,
                                  crossAxisSpacing: 1.0,
                                  mainAxisExtent: 358),
                          // itemCount: 10,
                          itemCount: searchItems.itemsSearch!.skucode.length,
                          itemBuilder: (context, index) {
                            return ClipRect(
                              clipBehavior: Clip.antiAlias,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // !Get.to(() => DetailProduct() ใช้ได้
                                    Get.find<ProductDetailController>()
                                        .productDetailController(
                                      searchItems
                                          .itemsSearch!.skucode[index].campaign,
                                      searchItems
                                          .itemsSearch!.skucode[index].billCode,
                                      searchItems.itemsSearch!.skucode[index]
                                          .mediaCode,
                                      searchItems
                                          .itemsSearch!.skucode[index].sku,
                                      pChannel,
                                      '',
                                    );
                                    Get.to(() => ProductDetailPage(
                                          ref: 'search',
                                          contentId: contentId,
                                        ));
                                  },
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
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // if (show)
                                          Stack(
                                            children: <Widget>[
                                              Center(
                                                child: CachedNetworkImage(
                                                  imageUrl: searchItems
                                                      .itemsSearch!
                                                      .skucode[index]
                                                      .img,
                                                  height: 140,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              Positioned(
                                                top: 0.0,
                                                left: 0.0,
                                                child: CachedNetworkImage(
                                                  imageUrl: searchItems
                                                      .itemsSearch!
                                                      .skucode[index]
                                                      .imgNetPrice,
                                                  height: (searchItems
                                                              .itemsSearch!
                                                              .skucode[index]
                                                              .flagNetPrice ==
                                                          'Y')
                                                      ? 60
                                                      : 0,
                                                  // fit: BoxFit.contain,
                                                ),
                                              ),
                                              Positioned(
                                                  top: 0.0,
                                                  right: 0.0,
                                                  child: CachedNetworkImage(
                                                    imageUrl: searchItems
                                                        .itemsSearch!
                                                        .skucode[index]
                                                        .imgAppend,
                                                    height: (searchItems
                                                                .itemsSearch!
                                                                .skucode[index]
                                                                .isInStock ==
                                                            false)
                                                        ? 80
                                                        : 0,
                                                    // fit: BoxFit.contain,
                                                  )),
                                            ],
                                          ),
                                          // if (show)
                                          // ? ชื่อสินค้า
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 4,
                                                left: 14,
                                                right: 14),
                                            child: Row(children: [
                                              Expanded(
                                                child: searchItems
                                                            .itemsSearch!
                                                            .skucode[index]
                                                            .flagHouseBrand ==
                                                        'Y'
                                                    ? Stack(
                                                        children: [
                                                          Text(
                                                            textAlign:
                                                                TextAlign.left,
                                                            '          ${searchItems.itemsSearch!.skucode[index].name}',
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'notoreg',
                                                              color:
                                                                  Colors.black,
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
                                                        textAlign:
                                                            TextAlign.start,
                                                        searchItems
                                                            .itemsSearch!
                                                            .skucode[index]
                                                            .name,
                                                        maxLines: 3,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                              ),
                                            ]),
                                          ),
                                          // ? ราคา และรหัสสินค้า
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 14),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${MultiLanguages.of(context)!.translate('product_code')} ${searchItems.itemsSearch!.skucode[index].billCode}",
                                                        style: TextStyle(
                                                          fontFamily: 'notoreg',
                                                          fontSize: 12,
                                                          color: setBillColor(
                                                              searchItems
                                                                  .itemsSearch!
                                                                  .skucode[
                                                                      index]
                                                                  .billColor),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${MultiLanguages.of(context)!.translate('order_price_txt')} ${NumberFormat.decimalPattern().format(double.parse(searchItems.itemsSearch!.skucode[index].specialPrice))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'notoreg',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0)),
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
                                                        final Future<
                                                                SharedPreferences>
                                                            prefs0 =
                                                            SharedPreferences
                                                                .getInstance();

                                                        final SharedPreferences
                                                            prefs =
                                                            await prefs0;
                                                        late String? lslogin;
                                                        lslogin = prefs
                                                            .getString("login");

                                                        if (lslogin == null) {
                                                          Get.to(() =>
                                                              const Anonumouslogin());
                                                        } else {
                                                          await fnEditCart(
                                                              context,
                                                              searchItems
                                                                      .itemsSearch!
                                                                      .skucode[
                                                                  index],
                                                              'CategoryList',
                                                              pChannel,
                                                              '',
                                                              ref: 'search',
                                                              contentId:
                                                                  contentId);
                                                        }
                                                      },
                                                      child: ImageBasget),
                                                ),
                                              ],
                                            ),
                                          ),

                                          //! fade review
                                          if (searchItems.itemsSearch!
                                                  .skucode[index].totalReview >
                                              0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 14),
                                              child: Wrap(
                                                runAlignment:
                                                    WrapAlignment.center,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Text(
                                                    searchItems
                                                        .itemsSearch!
                                                        .skucode[index]
                                                        .ratingProduct
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'notoreg',
                                                        inherit: false,
                                                        color: theme_color_df,
                                                        fontSize: 14),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4.0,
                                                            left: 4,
                                                            right: 4),
                                                    child: Image.asset(
                                                        scale: 1.8,
                                                        'assets/images/home/star.png'),
                                                  ),
                                                  Text(
                                                    '(${searchItems.itemsSearch!.skucode[index].totalReview})',
                                                    style: TextStyle(
                                                        fontFamily: 'notoreg',
                                                        inherit: false,
                                                        color: theme_color_df,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          const Spacer(),
                                          // ? รายละเอียดแค๊ตตาลอก
                                          Container(
                                            width: width,
                                            height: 65,
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  28, 112, 110, 110),
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      searchItems
                                                          .itemsSearch!
                                                          .skucode[index]
                                                          .nameText,
                                                      style: const TextStyle(
                                                        fontFamily: 'notoreg',
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                      )),
                                                  Text(
                                                    searchItems.itemsSearch!
                                                        .skucode[index].pageNo,
                                                    style: const TextStyle(
                                                      fontFamily: 'notoreg',
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ))),
    );
  }
}
