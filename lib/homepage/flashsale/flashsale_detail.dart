// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail_outstock_flashsale.dart';
import 'package:fridayonline/homepage/widget/appbar_cart.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../controller/cart/function_add_to_cart.dart';
// import '../../controller/category/category_controller.dart';
import '../../controller/flashsale/flash_controller.dart';
import '../../model/flashsale/flashsale_detail.dart';
import '../../model/set_data/set_data.dart';
import '../../service/flashsale/flashsale_detail_service.dart';
import '../../service/languages/multi_languages.dart';
import '../login/anonymous_login.dart';
import '../pageactivity/cart/cart_theme/cart_all_theme.dart';
import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';
import '../theme/themeimage_menu.dart';

class FlashSaleDetail extends StatefulWidget {
  const FlashSaleDetail({super.key, required this.contentId});
  final String contentId;

  @override
  State<FlashSaleDetail> createState() => _FlashSaleDetailState();
}

class _FlashSaleDetailState extends State<FlashSaleDetail> {
  var mChannel = '3';
  var mChannelId = '';

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: appBarTitleCart("Flash Sale", ""),
        body: FutureBuilder(
          //future: GetMslInfoSevice(),
          future: Future.wait([
            FlashsaleDetailService(),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            //ตรวจสอบว่าโหลดข้อมูลได้ไหม
            //กรณีโหลดข้อมูลได้
            if (snapshot.connectionState == ConnectionState.done) {
              var result = snapshot.data;
              FlashSaleDetailRun dataDetail = result![0];
              return DefaultTabController(
                length: dataDetail.flashSale.length,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CachedNetworkImage(
                      imageUrl: dataDetail.banner,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      color: Colors.white,
                      child: tabBar(dataDetail),
                    ),
                    Expanded(
                      child: tabbarView(dataDetail),
                    ),
                  ],
                ),
              );

              //กรณีไม่สามารถโหลดข้อมูลได้
            } else {
              return Center(
                heightFactor: 15,
                child: theme_loading_df,
              );
            }
          },
        ),
      ),
    );
  }

  //? tabbar controller && style
  TabBar tabBar(FlashSaleDetailRun dataDetail) {
    return TabBar(
        padding: const EdgeInsets.only(top: 12),
        isScrollable: true,
        labelColor: theme_color_df,
        indicatorColor: theme_color_df,
        unselectedLabelColor: const Color(0xFFABABAB),
        indicatorWeight: 4.0,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          for (int i = 0; i < dataDetail.flashSale.length; i++)
            Tab(
              child: Column(
                children: [
                  Text(dataDetail.flashSale[i].startTime,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(dataDetail.flashSale[i].showDate,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
        ]);
  }

  //? หน้่าแสดงผลตาม tabbar
  TabBarView tabbarView(FlashSaleDetailRun dataDetail) {
    return TabBarView(children: [
      for (int i = 0; i < dataDetail.flashSale.length; i++)
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                height: 45,
                color: i == 0 ? theme_color_df : Colors.grey.shade600,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: i == 0
                                ? const Text(
                                    'จะสิ้นสุดใน ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                    // ignore: prefer_const_constructors
                                  )
                                : const Text(
                                    'จะเริ่มใน ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    i == 0 ? flashSaleTimeLimit() : checkFlashSaleNextTime(),
                  ],
                ),
              ),
            ),
            //!
            Expanded(
              child: ListView.builder(
                itemCount: dataDetail.flashSale[i].product.length,
                itemBuilder: (BuildContext context, int index) {
                  return list(
                    dataDetail.flashSale[i].product,
                    i,
                    index,
                  );
                },
              ),
            ),
          ],
        ),
    ]);
  }

  //? show time countdow flashSale
  Flexible flashSaleTimeLimit() {
    return Flexible(
      fit: FlexFit.tight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
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
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          ':',
                          style: TextStyle(
                              fontWeight: boldText, color: Colors.white),
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
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          ':',
                          style: TextStyle(
                              fontWeight: boldText, color: Colors.white),
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
    );
  }

  //? check next time flashSale * ยังไม่เสร็จ
  Flexible checkFlashSaleNextTime() {
    return Flexible(
      fit: FlexFit.tight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          GetX<FlashsaleTimerCount>(
              builder: (data) => Row(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.grey.shade800,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 3, right: 3, top: 1, bottom: 1),
                          child: Text(
                            data.hours.value,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          ':',
                          style: TextStyle(
                              fontWeight: boldText, color: Colors.white),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.grey.shade800,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 3, right: 3, top: 1, bottom: 1),
                          child: Text(
                            data.minutes.value,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          ':',
                          style: TextStyle(
                              fontWeight: boldText, color: Colors.white),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.grey.shade800,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 3, right: 3, top: 1, bottom: 1),
                          child: Text(
                            data.seconds.value,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  )),
        ],
      ),
    );
  }

  //? list product flashSale
  Padding list(List<Product> product, int i, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // !Get.to(() => DetailProduct() ใช้ได้

          // var mstock = '';
          Get.find<ProductDetailController>().productDetailController(
              product[index].campaign,
              product[index].billCode,
              product[index].mediaCode,
              product[index].sku,
              mChannel,
              mChannelId);
          if (product[index].isInStock) {
            // mstock = '1';
            Get.to(() => ProductDetailPage(
                  ref: 'flashsale',
                  contentId: widget.contentId,
                ));
          } else {
            Get.to(() => OutStockFlashSale(mChannel, mChannelId));
            // mstock = '0';
          }
          // Get.find<CategoryProductDetailController>().fetchproductdetail(
          //     product[index].campaign,
          //     product[index].billCode,
          //     product[index].brand,
          //     product[index].sku,
          //     mChannel,
          //     mChannelId,
          //     mstock);
          // Get.toNamed('/my_detail',
          //     parameters: {'mchannel': mChannel, 'mchannelId': mChannelId});
          // if (product[index].isInStock) {
          //   Get.find<CategoryProductDetailController>().fetchproductdetail(
          //       product[index].campaign,
          //       product[index].billCode,
          //       product[index].brand,
          //       product[index].sku,
          //       '',
          //       '');
          //   Get.toNamed('/my_detail');
          // } else {
          //   Get.to(
          //       arguments: product[index],
          //       transition: Transition.rightToLeft,
          //       () => OutStockPage());
          // }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x34090F13),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                      scale: 1.6,
                                      'assets/images/flashsale/cart_discout.png'),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'ลด',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(product[index].percentDiscount,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: product[index].img,
                                  width: 80,
                                  height: 80,
                                ),
                                !product[index].isInStock
                                    ? Image.asset(
                                        scale: 1.5,
                                        width: 60,
                                        height: 60,
                                        'assets/images/flashsale/img_out_stock.png')
                                    : const SizedBox()
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 16.0, top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 14.0, top: 10, bottom: 4),
                                  child: Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    product[index].name,
                                    style: const TextStyle(
                                        color: Color(0xFF7B7B7B)),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 1),
                                          Text(
                                            '${myFormat.format(double.parse(product[index].specialPrice))} ${MultiLanguages.of(context)!.translate('order_baht')}',
                                            style: const TextStyle(
                                                color: Color(0xFFF54C47),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${myFormat.format(double.parse(product[index].price))} ${MultiLanguages.of(context)!.translate('order_baht')}',
                                            style: const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Color(0xFF7B7B7B),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          product[index].isInStock && i == 0
                                              ? LinearPercentIndicator(
                                                  padding: EdgeInsets.zero,
                                                  alignment:
                                                      MainAxisAlignment.start,
                                                  animation: true,
                                                  lineHeight: 15.0,
                                                  animationDuration: 1500,
                                                  percent: product[index]
                                                          .percentNum /
                                                      100,
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          164, 214, 241, 1),
                                                  center: Text(
                                                    product[index].percentSale,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  // ignore: prefer_const_constructors
                                                  linearGradient:
                                                      const LinearGradient(
                                                    begin: Alignment.bottomLeft,
                                                    end: Alignment(0.8, 1),
                                                    tileMode: TileMode.mirror,
                                                    colors: <Color>[
                                                      Color(0xFFFD7F6B),
                                                      Color(0xFFFF0000),
                                                    ],
                                                  ),
                                                  barRadius:
                                                      const Radius.circular(10),
                                                )
                                              : !product[index].isInStock
                                                  ? Text(
                                                      product[index]
                                                          .soldOutTime,
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xFF7B7B7B)),
                                                    )
                                                  : const SizedBox()
                                        ],
                                      ),
                                    ),
                                    product[index].isInStock && i == 0
                                        ? Expanded(
                                            child: BouncingWidget(
                                            duration: const Duration(
                                                milliseconds: 100),
                                            scaleFactor: 1.5,
                                            onPressed: () async {
                                              SetData data = SetData();
                                              var lslogin =
                                                  await data.loginStatus;
                                              var mChannel = "3";
                                              var mChannelId = "";
                                              if (lslogin == "") {
                                                Get.to(
                                                    transition:
                                                        Transition.rightToLeft,
                                                    () =>
                                                        const Anonumouslogin());
                                              } else {
                                                await fnEditCart(
                                                  context,
                                                  product[index],
                                                  'FlashSale',
                                                  mChannel,
                                                  mChannelId,
                                                  ref: 'flashsale',
                                                  contentId: widget.contentId,
                                                );
                                              }
                                            },
                                            child: ImageBasget,
                                          ))
                                        : const SizedBox()
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                  product[index].isInStock
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            'assets/images/flashsale/img_out_stock_big.png',
                            width: 150,
                          ),
                        )
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       child: Stack(
              //         alignment: AlignmentDirectional.center,
              //         children: [
              //           // CachedNetworkImage(
              //           //   imageUrl: product[index].img,
              //           //   width: 80,
              //           //   height: 80,
              //           // ),
              //           !product[index].isInStock
              //               ? Image.asset(
              //                   scale: 1.5,
              //                   width: 60,
              //                   height: 60,
              //                   'assets/images/flashsale/img_out_stock.png')
              //               : const SizedBox()
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = theme_color_df
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(0, size.height * 1);
    path0.lineTo(size.width * 1.12, size.height * 1.0052299);
    path0.lineTo(size.width * 0.9194397, size.height * 0.5032902);
    path0.lineTo(size.width * 1.12, 0);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
