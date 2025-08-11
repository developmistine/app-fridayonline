// ignore: file_names

// ignore_for_file: prefer_const_constructors

import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/login/anonymous_login.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/theme/setbillcolor.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/cart/function_add_to_cart.dart';
import '../../service/languages/multi_languages.dart';
// import '../theme/theme_color.dart';

Widget CatelogListProShow(context, items, channel, channelId) {
  // bool show;
  double width = MediaQuery.of(context).size.width;

  return MasonryGridView.builder(
      shrinkWrap: true,
      primary: false,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (width >= 768.0) ? 3 : 2,
      ),
      itemCount:
          items.catelog_list_product_by_page!.listProductByPageECatalog.length,
      itemBuilder: (context, index) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Padding(
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
              child: Column(children: [
                GestureDetector(
                  onTap: () {
                    // Get.toNamed(
                    //   '/my_detail',
                    // !Get.to(() => DetailProduct() ใช้ได้
                    // );
                    // print(items.catelog_list_product_by_page!.listProductByPageECatalog[index].toJson().toString());
                    Get.find<ProductDetailController>().productDetailController(
                      items.catelog_list_product_by_page!
                          .listProductByPageECatalog[index].campaign,
                      items.catelog_list_product_by_page!
                          .listProductByPageECatalog[index].billCode,
                      items.catelog_list_product_by_page!
                          .listProductByPageECatalog[index].mediaCode,
                      items.catelog_list_product_by_page!
                          .listProductByPageECatalog[index].sku,
                      channel,
                      channelId,
                    );
                    Get.to(() => ProductDetailPage(
                          ref: 'catalog_page',
                          contentId: channelId,
                        ));
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: CachedNetworkImage(
                          imageUrl: items.catelog_list_product_by_page!
                              .listProductByPageECatalog[index].img,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 0.0,
                        left: 0.0,
                        child: CachedNetworkImage(
                          imageUrl: items.catelog_list_product_by_page!
                              .listProductByPageECatalog[index].imgNetPrice,
                          height: (items
                                      .catelog_list_product_by_page!
                                      .listProductByPageECatalog[index]
                                      .flagNetPrice ==
                                  'Y')
                              ? 60
                              : 0,
                          // fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 5.0,
                        left: 80.0,
                        child: CachedNetworkImage(
                          imageUrl: items.catelog_list_product_by_page!
                              .listProductByPageECatalog[index].imgAppend,
                          height: (items
                                      .catelog_list_product_by_page!
                                      .listProductByPageECatalog[index]
                                      .isInStock ==
                                  false)
                              ? 80
                              : 0,
                          // fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                //? hours brand
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 4, left: 14, right: 14),
                  child: Row(children: [
                    Expanded(
                      child: items
                                  .catelog_list_product_by_page!
                                  .listProductByPageECatalog[index]
                                  .flagHouseBrand ==
                              'Y'
                          ? Stack(
                              children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  '          ${items.catelog_list_product_by_page!.listProductByPageECatalog[index].name}',
                                  maxLines: 3,
                                  style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                  ),
                                ),
                                Image.asset(
                                    scale: 23, 'assets/images/home/HB.png')
                              ],
                            )
                          : Text(
                              // textAlign: TextAlign.start,
                              items.catelog_list_product_by_page!
                                  .listProductByPageECatalog[index].name,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //? รหัสสินค้า
                            Text(
                              "${MultiLanguages.of(context)!.translate('product_code')} ${items.catelog_list_product_by_page!.listProductByPageECatalog[index].billCode}",
                              style: TextStyle(
                                fontFamily: 'notoreg',
                                fontSize: 12,
                                color: setBillColor(items
                                    .catelog_list_product_by_page!
                                    .listProductByPageECatalog[index]
                                    .billColor),
                              ),
                            ),
                            //? ราคา
                            Text(
                              "${MultiLanguages.of(context)!.translate('order_price_txt')} ${NumberFormat.decimalPattern().format(double.parse(items.catelog_list_product_by_page!.listProductByPageECatalog[index].price))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'notoreg',
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            //! fade review
                            if (items
                                    .catelog_list_product_by_page!
                                    .listProductByPageECatalog[index]
                                    .totalReview >
                                0)
                              Wrap(
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    items
                                        .catelog_list_product_by_page!
                                        .listProductByPageECatalog[index]
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
                                        bottom: 4.0, left: 4, right: 4),
                                    child: Image.asset(
                                        scale: 1.8,
                                        'assets/images/home/star.png'),
                                  ),
                                  Text(
                                    '(${items.catelog_list_product_by_page!.listProductByPageECatalog[index].totalReview})',
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
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.5,
                            onPressed: () async {
                              final Future<SharedPreferences> prefs0 =
                                  SharedPreferences.getInstance();

                              final SharedPreferences prefs = await prefs0;
                              late String? lslogin;
                              lslogin = prefs.getString("login");

                              if (lslogin == null) {
                                Get.to(() => Anonumouslogin());
                              } else {
                                fnEditCart(
                                    context,
                                    items.catelog_list_product_by_page!
                                        .listProductByPageECatalog[index],
                                    'CategoryList',
                                    channel,
                                    channelId,
                                    ref: 'catalog_page',
                                    contentId: channelId);
                              }
                            },
                            child: ImageBasget),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        );
      });
}
