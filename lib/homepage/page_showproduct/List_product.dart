import 'package:fridayonline/homepage/login/anonymous_login.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/theme/setbillcolor.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../controller/cart/function_add_to_cart.dart';
// import '../../controller/dropship_shop/dropship_shop_controller.dart';
import '../../controller/home/home_controller.dart';
// import '../../model/home/banner_product.dart';
import '../../controller/product_detail/product_detail_controller.dart';
import '../../service/languages/multi_languages.dart';
import '../pageactivity/cart/cart_theme/cart_all_theme.dart';
import '../theme/theme_color.dart';
// import 'product_detail.dart';

// showList( List<Skucode>items) {
// ignore: must_be_immutable, camel_case_types
class showList extends StatelessWidget {
  dynamic items;
  dynamic mchannel;
  dynamic mchannelId;
  String ref;
  String contentId;
  showList(this.items, this.mchannel, this.mchannelId,
      {super.key, required this.ref, required this.contentId});

  @override
  Widget build(BuildContext context) {
    print(contentId);
    bool show;
    double width = MediaQuery.of(context).size.width;
    // printWhite(items.runtimeType);
    return items.length < 1
        //? กรณีที่ไม่มีสินค้า
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Image.asset('assets/images/logo/logofriday.png', width: 70),
              ),
              const Text('ไม่พบสินค้า'),
            ],
          ))
        //? รายการสินค้า
        : GetX<ProductFromBanner>(builder: (checkLoad) {
            if (!checkLoad.isDataLoading.value) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (checkLoad.BannerProduct != null &&
                        checkLoad.BannerProduct!.contentimg.imgAppend != '')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4),
                        child: SizedBox(
                          width: Get.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              checkLoad.BannerProduct!.contentimg.imgAppend,
                              // width: Get.width,
                              fit: BoxFit.contain,
                              // height: 140,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    if (checkLoad.BannerProduct != null &&
                        checkLoad.BannerProduct!.bannerimg.imgAppend != '')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4),
                        child: SizedBox(
                          width: Get.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              checkLoad.BannerProduct!.bannerimg.imgAppend,
                              // width: Get.width,
                              fit: BoxFit.contain,
                              // height: 140,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    if (checkLoad.BannerProduct != null &&
                        checkLoad.BannerProduct!.pushImage.imgAppend != '')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4),
                        child: SizedBox(
                          width: Get.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              checkLoad.BannerProduct!.pushImage.imgAppend,
                              // width: Get.width,
                              fit: BoxFit.contain,
                              // height: 140,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    if (checkLoad.BannerProduct != null &&
                        checkLoad.BannerProduct!.popupImage.imgAppend != '')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4),
                        child: SizedBox(
                          width: Get.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              checkLoad.BannerProduct!.popupImage.imgAppend,
                              // width: Get.width,
                              fit: BoxFit.contain,
                              // height: 140,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    MasonryGridView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        gridDelegate:
                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (width >= 768.0) ? 3 : 2,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          (items[index].img != '') ? show = true : show = false;
                          // !set colors billcode
                          final billcolor = items[index].billColor;
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
                                              items[index].campaign,
                                              items[index].billCode,
                                              items[index].mediaCode,
                                              items[index].sku,
                                              mchannel,
                                              mchannelId);
                                      Get.to(() => ProductDetailPage(
                                            ref: ref,
                                            contentId: contentId,
                                          ));
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        if (show)
                                          Center(
                                            child: CachedNetworkImage(
                                              imageUrl: items[index].img,
                                              height: 150,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        if (!show)
                                          Center(
                                              child: Image.asset(
                                            imageError,
                                            height: 150,
                                          )),
                                        Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          child: CachedNetworkImage(
                                            imageUrl: items[index].imgNetPrice,
                                            height:
                                                (items[index].flagNetPrice ==
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
                                              imageUrl: items[index].imgAppend,
                                              height: (items[index].isInStock ==
                                                      false)
                                                  ? 80
                                                  : 0,
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
                                        child: items[index].flagHouseBrand ==
                                                'Y'
                                            ? Stack(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.left,
                                                    '          ${items[index].name}',
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
                                                // textAlign: TextAlign.start,
                                                items[index].name,
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
                                                "${MultiLanguages.of(context)!.translate('product_code')} ${items[index].billCode}",
                                                style: TextStyle(
                                                  fontFamily: 'notoreg',
                                                  fontSize: 12,
                                                  color: setBillColor(
                                                      billcolor.toString()),
                                                ),
                                              ),
                                              //? ราคา
                                              Text(
                                                "${MultiLanguages.of(context)!.translate('order_price_txt')} ${myFormat.format(double.parse(items[index].specialPrice.toString()))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'notoreg',
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0)),
                                              ),
                                              //! fade review
                                              if (items[index].totalReview > 0)
                                                Wrap(
                                                  runAlignment:
                                                      WrapAlignment.center,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Text(
                                                      items[index]
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
                                                      '(${items[index].totalReview})',
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
                                                      items[index],
                                                      'CategoryList',
                                                      mchannel,
                                                      mchannelId,
                                                      ref: ref,
                                                      contentId: contentId);
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
                  ],
                ),
              );
            } else {
              return Center(
                child: theme_loading_df,
              );
            }
          });
  }
}
// Widget showList( items, mchannel, mchannelId) {
//   }

showCaseShowList(
    context,
    items,
    mchannel,
    mchannelId,
    MultiLanguages ChangeLanguage,
    GlobalKey<State<StatefulWidget>> keyOne,
    GlobalKey<State<StatefulWidget>> keyTwo) {
  bool show;
  double height = Get.height;
  double width = MediaQuery.of(context).size.width;

  return items.length < 1
      ? Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Image.asset('assets/images/logo/logofriday.png', width: 70),
            ),
            const Text('ไม่พบสินค้า'),
          ],
        ))
      : GetX<ProductFromBanner>(builder: (checkLoad) {
          if (!checkLoad.isDataLoading.value) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (checkLoad.BannerProduct != null &&
                      checkLoad.BannerProduct!.contentimg.imgAppend != '')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4),
                      child: SizedBox(
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            checkLoad.BannerProduct!.contentimg.imgAppend,
                            // width: Get.width,
                            fit: BoxFit.contain,
                            // height: 140,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  if (checkLoad.BannerProduct != null &&
                      checkLoad.BannerProduct!.bannerimg.imgAppend != '')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4),
                      child: SizedBox(
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            checkLoad.BannerProduct!.bannerimg.imgAppend,
                            // width: Get.width,
                            fit: BoxFit.contain,
                            // height: 140,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  MasonryGridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (width >= 768.0) ? 3 : 2,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        (items[index].img != '') ? show = true : show = false;

                        // !set colors billcode
                        final billcolor = items[index].billColor;
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Showcase.withWidget(
                              disableMovingAnimation: true,
                              width: width,
                              height: height / 1.4,
                              container: InkWell(
                                onTap: () {
                                  ShowCaseWidget.of(context).next();
                                },
                                child: MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                      textScaler: const TextScaler.linear(1.0)),
                                  child: SizedBox(
                                    width: width / 1.1,
                                    height: height / 2.2,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0, top: 30),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Container(
                                                color: theme_color_df,
                                                width: 250,
                                                height: 80,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      ChangeLanguage.translate(
                                                          'guide_product_category2'),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 190.0),
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      WidgetStateProperty.all<Color>(
                                                          theme_color_df),
                                                  backgroundColor:
                                                      WidgetStateProperty.all<
                                                          Color>(Colors.white),
                                                  shape: WidgetStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  30.0),
                                                          side: BorderSide(color: theme_color_df)))),
                                              onPressed: () {
                                                ShowCaseWidget.of(context)
                                                    .next();
                                              },
                                              child: SizedBox(
                                                width: 50,
                                                height: 40,
                                                child: Center(
                                                  child: Text(
                                                      maxLines: 1,
                                                      ChangeLanguage.translate(
                                                          'btn_end_guide'),
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                ),
                                              )),
                                        ),
                                        Expanded(
                                          child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    ShowCaseWidget.of(context)
                                                        .next();
                                                  })),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              //overlayColor: theme_color_df,
                              // targetPadding: const EdgeInsets.all(20),
                              key: keyTwo,
                              disposeOnTap: true,
                              onTargetClick: () {
                                ShowCaseWidget.of(context).next();
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
                                child: Column(children: [
                                  // if (show)
                                  GestureDetector(
                                    onTap: () {
                                      // !Get.to(() => DetailProduct() ใช้ได้
                                      Get.find<ProductDetailController>()
                                          .productDetailController(
                                        items[index].campaign,
                                        items[index].billCode,
                                        items[index].mediaCode,
                                        items[index].sku,
                                        mchannel,
                                        mchannelId,
                                      );
                                      Get.to(() => const ProductDetailPage(
                                            ref: '',
                                            contentId: '',
                                          ));
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        if (show)
                                          Center(
                                            child: CachedNetworkImage(
                                              imageUrl: items[index].img,
                                              height: 150,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        if (!show)
                                          Center(
                                              child: Image.asset(
                                            imageError,
                                            height: 150,
                                          )),
                                        Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          child: CachedNetworkImage(
                                            imageUrl: items[index].imgNetPrice,
                                            height:
                                                (items[index].flagNetPrice ==
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
                                              imageUrl: items[index].imgAppend,
                                              height: (items[index].isInStock ==
                                                      false)
                                                  ? 80
                                                  : 0,
                                              // fit: BoxFit.contain,
                                            )),
                                      ],
                                    ),
                                  ),
                                  //? hours brand
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 4, left: 14, right: 14),
                                    child: Row(children: [
                                      Expanded(
                                        child: items[index].flagHouseBrand ==
                                                'Y'
                                            ? Stack(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.left,
                                                    '          ${items[index].name}',
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
                                                // textAlign: TextAlign.start,
                                                items[index].name,
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
                                                "${MultiLanguages.of(context)!.translate('product_code')} ${items[index].billCode}",
                                                style: TextStyle(
                                                  fontFamily: 'notoreg',
                                                  fontSize: 12,
                                                  color: setBillColor(
                                                      billcolor.toString()),
                                                ),
                                              ),
                                              //? ราคา
                                              Text(
                                                "${MultiLanguages.of(context)!.translate('order_price_txt')} ${NumberFormat.decimalPattern().format(double.parse(items[index].price))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'notoreg',
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0)),
                                              ),
                                              //! fade review
                                              if (items[index].totalReview > 0)
                                                Wrap(
                                                  runAlignment:
                                                      WrapAlignment.center,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Text(
                                                      items[index]
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
                                                      '(${items[index].totalReview})',
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
                                                Get.to(
                                                    transition:
                                                        Transition.rightToLeft,
                                                    () =>
                                                        const Anonumouslogin());
                                              } else {
                                                await fnEditCart(
                                                    context,
                                                    items[index],
                                                    'CategoryList',
                                                    mchannel,
                                                    mchannelId,
                                                    ref: '',
                                                    contentId: '');
                                              }
                                            },
                                            child: Showcase.withWidget(
                                              targetShapeBorder:
                                                  const CircleBorder(),
                                              disableMovingAnimation: true,
                                              width: width,
                                              height: height / 1.4,
                                              container: InkWell(
                                                onTap: () {
                                                  ShowCaseWidget.of(context)
                                                      .startShowCase([keyTwo]);
                                                },
                                                child: MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaler:
                                                              const TextScaler
                                                                  .linear(1.0)),
                                                  child: SizedBox(
                                                    width: width / 1.1,
                                                    height: height / 2.1,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 20.0,
                                                                  top: 30),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: Container(
                                                                color:
                                                                    theme_color_df,
                                                                width: 250,
                                                                height: 80,
                                                                child: Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      ChangeLanguage
                                                                          .translate(
                                                                              'guide_product_category'),
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 190.0),
                                                          child: ElevatedButton(
                                                              style: ButtonStyle(
                                                                  foregroundColor:
                                                                      WidgetStateProperty.all<Color>(
                                                                          theme_color_df),
                                                                  backgroundColor:
                                                                      WidgetStateProperty.all<Color>(Colors
                                                                          .white),
                                                                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0),
                                                                      side: BorderSide(
                                                                          color:
                                                                              theme_color_df)))),
                                                              onPressed: () {
                                                                ShowCaseWidget.of(
                                                                        context)
                                                                    .startShowCase([
                                                                  keyTwo
                                                                ]);
                                                              },
                                                              child: SizedBox(
                                                                width: 50,
                                                                height: 40,
                                                                child: Center(
                                                                  child: Text(
                                                                      maxLines:
                                                                          1,
                                                                      ChangeLanguage
                                                                          .translate(
                                                                              'btn_next_guide'),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16)),
                                                                ),
                                                              )),
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: IconButton(
                                                                  icon:
                                                                      const Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    ShowCaseWidget.of(
                                                                            context)
                                                                        .next();
                                                                    ShowCaseWidget.of(
                                                                            context)
                                                                        .next();
                                                                  })),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //overlayColor: theme_color_df,
                                              // targetPadding:
                                              //     const EdgeInsets.all(20),
                                              key: keyOne,
                                              disposeOnTap: true,
                                              onTargetClick: () {
                                                ShowCaseWidget.of(context)
                                                    .startShowCase([keyTwo]);
                                              },
                                              child: ImageBasget,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          );
                        } else {
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
                              child: Column(children: [
                                // if (show)
                                GestureDetector(
                                  onTap: () {
                                    // !Get.to(() => DetailProduct() ใช้ได้
                                    Get.find<ProductDetailController>()
                                        .productDetailController(
                                      items[index].campaign,
                                      items[index].billCode,
                                      items[index].mediaCode,
                                      items[index].sku,
                                      mchannel,
                                      mchannelId,
                                    );
                                    Get.to(() => const ProductDetailPage(
                                          ref: '',
                                          contentId: '',
                                        ));
                                    // Get.find<CategoryProductDetailController>()
                                    //     .fetchproductdetail(
                                    //         items[index].campaign,
                                    //         items[index].billCode,
                                    //         items[index].brand,
                                    //         items[index].sku,
                                    //         mchannel,
                                    //         mchannelId,
                                    //         '');
                                    // Get.toNamed('/my_detail', parameters: {
                                    //   'mchannel': mchannel,
                                    //   'mchannelId': mchannelId
                                    // });
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      if (show)
                                        Center(
                                          child: CachedNetworkImage(
                                            imageUrl: items[index].img,
                                            height: 150,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      if (!show)
                                        Center(
                                            child: Image.asset(
                                          imageError,
                                          height: 150,
                                        )),
                                      Positioned(
                                        top: 0.0,
                                        left: 0.0,
                                        child: CachedNetworkImage(
                                          imageUrl: items[index].imgNetPrice,
                                          height:
                                              (items[index].flagNetPrice == 'Y')
                                                  ? 60
                                                  : 0,
                                          // fit: BoxFit.contain,
                                        ),
                                      ),
                                      Positioned(
                                          top: 0.0,
                                          right: 0.0,
                                          child: CachedNetworkImage(
                                            imageUrl: items[index].imgAppend,
                                            height: (items[index].isInStock ==
                                                    false)
                                                ? 80
                                                : 0,
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
                                      child: items[index].flagHouseBrand == 'Y'
                                          ? Stack(
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.left,
                                                  '          ${items[index].name}',
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
                                              // textAlign: TextAlign.start,
                                              items[index].name,
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
                                              "${MultiLanguages.of(context)!.translate('product_code')} ${items[index].billCode}",
                                              style: TextStyle(
                                                fontFamily: 'notoreg',
                                                fontSize: 12,
                                                color: setBillColor(
                                                    billcolor.toString()),
                                              ),
                                            ),
                                            //? ราคา
                                            Text(
                                              "${MultiLanguages.of(context)!.translate('order_price_txt')} ${NumberFormat.decimalPattern().format(double.parse(items[index].price))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'notoreg',
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                            //! fade review
                                            if (items[index].totalReview > 0)
                                              Wrap(
                                                runAlignment:
                                                    WrapAlignment.center,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Text(
                                                    items[index]
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
                                                    '(${items[index].totalReview})',
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
                                                    items[index],
                                                    'CategoryList',
                                                    mchannel,
                                                    mchannelId,
                                                    ref: '',
                                                    contentId: '');
                                              }
                                            },
                                            child: ImageBasget),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          );
                        }
                      }),
                ],
              ),
            );
          } else {
            return Center(
              child: theme_loading_df,
            );
          }
        });
}
