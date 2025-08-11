// import 'dart:convert';

import 'package:fridayonline/controller/cart/function_add_to_cart.dart';
import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/home/cache_image.dart';
import 'package:fridayonline/homepage/login/anonymous_login.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
// import 'package:fridayonline/homepage/theme/constants.dart';
// import 'package:fridayonline/homepage/theme/theme_loading.dart';
// import 'package:fridayonline/homepage/widget/appbar_cart.dart';
// import 'package:bouncing_widget/bouncing_widget.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:fridayonline/model/home/banner_product.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../controller/cart/function_add_to_cart.dart';
// import '../../controller/category/category_controller.dart';
import '../../controller/home/home_controller.dart';
// import '../../service/home/home_service.dart';
import '../../service/languages/multi_languages.dart';
// import '../login/anonymous_login.dart';
import '../pageactivity/cart/cart_theme/cart_all_theme.dart';
import '../theme/setbillcolor.dart';
import '../theme/themeimage_menu.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage(
      this.context, this.productSkucode, this.mchannel, this.mchannelId,
      {super.key});
  final BuildContext context;
  final dynamic productSkucode;
  final String mchannel;
  final String mchannelId;
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  dynamic products;
  int itemsPerPage = 20; // จำนวนรายการต่อหน้า
  int currentPage = 1; // หน้าปัจจุบัน
  final _scrollCtr = ScrollController();
  final scr = Get.find<ProductFromBanner>();
  bool show = true;
  @override
  void initState() {
    super.initState();
    products = widget.productSkucode;
    var stop = false;
    _scrollCtr.addListener(() {
      if (_scrollCtr.position.maxScrollExtent == _scrollCtr.offset) {
        // ถ้าอ่านถึงจุดสุดท้ายของหน้าจอ

        if (currentPage * itemsPerPage < products!.length) {
          // printWhite('set');
          // ถ้ายังมีข้อมูลที่ไม่ได้แสดง
          currentPage++;
          // เรียก API หรือดึงข้อมูลเพิ่ม
          // เพิ่มข้อมูลใหม่ลงในรายการ products
          try {
            setState(() {});
          } catch (e) {
            debugPrint('setState Error');
          } finally {
            scr.isScrollLoading.value = false;
          }
        } else {
          stop = true;
          scr.isScrollLoading.value = false;
        }
      } else {
        if (stop) {
        } else if (scr.isScrollLoading.value == false) {
          scr.isScrollLoading.value = true;
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    // precached dependencies
    precacheImage(const AssetImage(imageError), context);
    precacheImage(ImageBasget.image, context);
    precacheImage(const AssetImage('assets/images/home/HB.png'), context);
    precacheImage(const AssetImage('assets/images/menu/basget.png'), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SingleChildScrollView(
        controller: _scrollCtr,
        child: products.length > 0
            ? Column(
                children: [
                  if (scr.BannerProduct != null &&
                      scr.BannerProduct!.contentimg.imgAppend != '')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4),
                      child: SizedBox(
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            scr.BannerProduct!.contentimg.imgAppend,
                            // width: Get.width,
                            fit: BoxFit.contain,
                            // height: 140,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  if (scr.BannerProduct != null &&
                      scr.BannerProduct!.bannerimg.imgAppend != '')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4),
                      child: SizedBox(
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            scr.BannerProduct!.bannerimg.imgAppend,
                            // width: Get.width,
                            fit: BoxFit.contain,
                            // height: 140,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  if (scr.BannerProduct != null &&
                      scr.BannerProduct!.pushImage.imgAppend != '')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4),
                      child: SizedBox(
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            scr.BannerProduct!.pushImage.imgAppend,
                            // width: Get.width,
                            fit: BoxFit.contain,
                            // height: 140,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  if (scr.BannerProduct != null &&
                      scr.BannerProduct!.popupImage.imgAppend != '')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4),
                      child: SizedBox(
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            scr.BannerProduct!.popupImage.imgAppend,
                            // width: Get.width,
                            fit: BoxFit.contain,
                            // height: 140,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  // MasonryGridView.builder(
                  //   shrinkWrap: true,
                  //   primary: false,
                  //   itemCount: (currentPage * itemsPerPage <= products!.length)
                  //       ? currentPage * itemsPerPage
                  //       : products!.length,
                  //   itemBuilder: (context, index) {
                  //     return ListTile(
                  //       title: CacheImageProduct(url: products![index].img),
                  //       // เพิ่มรายละเอียดอื่น ๆ ของผลิตภัณฑ์
                  //     );
                  //   },
                  //   gridDelegate:
                  //       SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: (Get.width >= 768.0) ? 3 : 2,
                  //   ),
                  // ),
                  MasonryGridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (Get.width >= 768.0) ? 3 : 2,
                      ),
                      itemCount:
                          (currentPage * itemsPerPage <= products!.length)
                              ? currentPage * itemsPerPage
                              : products!.length,
                      itemBuilder: (context, index) {
                        // (products[index].img != '')
                        //     ? show = true
                        //     : show = false;
                        // !set colors billcode
                        final billcolor = products[index].billColor;

                        var hourseBrand =
                            Image.asset(scale: 23, 'assets/images/home/HB.png');
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                              textScaler: const TextScaler.linear(1.0)),
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
                                // if (show)
                                GestureDetector(
                                  onTap: () {
                                    Get.find<ProductDetailController>()
                                        .productDetailController(
                                            products[index].campaign,
                                            products[index].billCode,
                                            products[index].mediaCode,
                                            products[index].sku,
                                            widget.mchannel,
                                            widget.mchannelId);
                                    // Get.to(() => const ProductDetailPage());
                                    // Get.find<CategoryProductDetailController>()
                                    //     .fetchproductdetail(
                                    //         products[index].campaign,
                                    //         products[index].billCode,
                                    //         products[index].brand,
                                    //         products[index].sku,
                                    //         widget.mchannel,
                                    //         widget.mchannelId,
                                    //         '');
                                    // Get.toNamed('/my_detail', parameters: {
                                    //   'mchannel': widget.mchannel,
                                    //   'mchannelId': widget.mchannelId
                                    // });
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      products[index].img != ''
                                          ? Center(
                                              child: CacheImageProduct(
                                                url: products[index].img,
                                              ),
                                            )
                                          : Center(
                                              child: Image.asset(
                                              imageError,
                                              height: 150,
                                            )),

                                      // ?
                                      Positioned(
                                        top: 0.0,
                                        left: 0.0,
                                        child: CacheImagePrice(
                                          url: products[index].imgNetPrice,
                                          flagNetPrice:
                                              products[index].flagNetPrice,
                                          // fit: BoxFit.contain,
                                        ),
                                      ),

                                      Positioned(
                                          top: 0.0,
                                          right: 0.0,
                                          child: CacheImageAppend(
                                            url: products[index].imgAppend,
                                            flagInstock:
                                                products[index].isInStock,
                                            // fit: BoxFit.contain,
                                          )),
                                    ],
                                  ),
                                ),
                                // if (show)
                                //? hours brand
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 4, left: 14, right: 14),
                                  child: Row(children: [
                                    Expanded(
                                      child:
                                          products[index].flagHouseBrand == 'Y'
                                              ? Stack(
                                                  children: [
                                                    Text(
                                                      textAlign: TextAlign.left,
                                                      '          ${products[index].name}',
                                                      maxLines: 3,
                                                      style: const TextStyle(
                                                        height: 1.5,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    hourseBrand
                                                  ],
                                                )
                                              : Text(
                                                  // textAlign: TextAlign.start,
                                                  products[index].name,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                    fontSize: 12,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //? รหัสสินค้า
                                            Text(
                                              "${MultiLanguages.of(context)!.translate('product_code')} ${products[index].billCode}",
                                              style: TextStyle(
                                                fontFamily: 'notoreg',
                                                fontSize: 12,
                                                color: setBillColor(billcolor),
                                              ),
                                            ),
                                            //? ราคา
                                            Text(
                                              "${MultiLanguages.of(context)!.translate('order_price_txt')} ${myFormat.format(double.parse(products[index].specialPrice))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'notoreg',
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                            //! fade review
                                            // Wrap(
                                            //   runAlignment: WrapAlignment.center,
                                            //   crossAxisAlignment: WrapCrossAlignment.center,
                                            //   children: [
                                            //     Text(
                                            //       '4.6',
                                            //       style: TextStyle(
                                            //           fontFamily: 'notoreg',
                                            //           inherit: false,
                                            //           color: theme_color_df,
                                            //           fontSize: 10),
                                            //     ),
                                            //     Padding(
                                            //       padding: const EdgeInsets.only(
                                            //           bottom: 4.0, left: 4, right: 4),
                                            //       child: Image.asset(
                                            //           scale: 2.2,
                                            //           'assets/images/home/star.png'),
                                            //     ),
                                            //     Text(
                                            //       '(20)',
                                            //       style: TextStyle(
                                            //           fontFamily: 'notoreg',
                                            //           inherit: false,
                                            //           color: theme_color_df,
                                            //           fontSize: 10),
                                            //     ),
                                            //   ],
                                            // )
                                          ],
                                        ),
                                      ),
                                      //? ปุ่มหยิบใส่ตระกร้า

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
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback(
                                                        (_) async {
                                                  // await fnEditCart(
                                                  //     context,
                                                  //     products[index],
                                                  //     'CategoryList',
                                                  //     widget.mchannel,
                                                  //     widget.mchannelId);
                                                });
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
                      }),
                  Obx(() {
                    return !scr.isDataLoading.value && scr.isScrollLoading.value
                        ? const SizedBox(
                            height: 100,
                            child: Center(child: CircularProgressIndicator()))
                        : Container();
                  })
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/logo/logofriday.png',
                        width: 30),
                  ),
                  const Text('ไม่พบสินค้า'),
                ],
              ),
      );
    });
  }
}
