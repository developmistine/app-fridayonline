// ignore_for_file: use_build_context_synchronously

import 'package:fridayonline/controller/dropship_shop/dropship_shop_controller.dart';
import 'package:fridayonline/homepage/widget/appbar_cart.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../controller/cart/function_add_to_cart.dart';
import '../../service/address/addresssearch.dart';
import '../../service/languages/multi_languages.dart';
import 'dropship_supplier_shop.dart';
import 'theme_dropship.dart';
import '../login/anonymous_login.dart';
import '../pageactivity/cart/cart_theme/cart_all_theme.dart';
import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';
import '../theme/themeimage_menu.dart';

class DropShipProduct extends StatefulWidget {
  const DropShipProduct({super.key});
  @override
  State<DropShipProduct> createState() => _DropShipProductState();
}

class _DropShipProductState extends State<DropShipProduct> {
  VideoPlayerController? _controller;
  Future<void>? setVideo;

  Future<void>? _initializeVideoPlayerFuture(String urlVideo) {
    _controller = VideoPlayerController.network(urlVideo);
    setVideo = _controller!.initialize();
    return setVideo;
  }

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: appBarTitleCart("รายการสินค้า", ""),
        body: GetBuilder<FetchDropshipShop>(builder: (detail) {
          if (!detail.isProductDetailLoading.value) {
            if (detail.productDetail!.billCode != '') {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    slideImage(detail),
                    showPrice(detail),
                    showName(detail),
                    Container(
                      height: 15,
                      color: const Color(0XFFF5F5F5),
                    ),
                    showDetail(detail),
                    Container(
                      height: 15,
                      color: const Color(0XFFF5F5F5),
                    ),
                    brandShop(width, detail),
                    Container(
                      height: 15,
                      color: const Color(0XFFF5F5F5),
                    ),
                    if (detail.productDetail!.productRecom.isNotEmpty)
                      textDetail(width),
                    listProductExpress(width, detail)
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('ไม่พบสินค้า'),
              );
            }
          }
          return Center(
            child: Lottie.asset('assets/images/loading_dropship.json',
                width: 100, height: 100),
          );
        }),
        bottomNavigationBar: buttonAddtoCart(context),
      ),
    );
  }

  //? สินค้าแนะนำ
  listProductExpress(double width, FetchDropshipShop detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: MasonryGridView.builder(
          shrinkWrap: true,
          primary: false,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (width >= 768.0) ? 3 : 2,
          ),
          itemCount: detail.productDetail!.productRecom.length,
          itemBuilder: (context, index) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () {
                    Get.put(FetchDropshipShop()).fetchProductDetailDropship(
                        detail.productDetail!.productRecom[index].productCode);
                    Get.to(() => const DropShipProduct(),
                        preventDuplicates: false);
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
                      Stack(
                        children: <Widget>[
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: detail
                                  .productDetail!.productRecom[index].imageUrl,
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                      // if (show)
                      //? express
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 4, left: 14, right: 14),
                        child: Row(children: [
                          Expanded(
                              child: Stack(
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: theme_red),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, top: 4, bottom: 2, right: 4),
                                  child: Text(
                                    detail.productDetail!.productRecom[index]
                                        .deliveryType,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Text(
                                  '                     ${detail.productDetail!.productRecom[index].nameTh}',
                                  style: const TextStyle(
                                      height: 1.7,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          )),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //? รหัสสินค้า
                                  Text(
                                    "${MultiLanguages.of(context)!.translate('product_code')} ${detail.productDetail!.productRecom[index].billYup}",
                                    style: TextStyle(
                                      fontFamily: 'notoreg',
                                      fontSize: 12,
                                      color: theme_grey_text,
                                    ),
                                  ),
                                  //? ราคา
                                  Text(
                                    "${MultiLanguages.of(context)!.translate('order_price_txt')} ${myFormat.format(double.parse(detail.productDetail!.productRecom[index].priceRegular))} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'notoreg',
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
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

                                    final SharedPreferences prefs =
                                        await prefs0;
                                    late String? lslogin;
                                    lslogin = prefs.getString("login");
                                    var mChannel = '6';
                                    var mChannelId = '';

                                    if (lslogin == null) {
                                      Get.to(() => const Anonumouslogin());
                                    } else {
                                      await fnEditCartDropship(
                                          context,
                                          detail.productDetail!
                                              .productRecom[index],
                                          'Dropship',
                                          mChannel,
                                          mChannelId);
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
              ),
            );
          }),
    );
  }

  //? header text
  textDetail(double width) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: width / 3.5,
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0XFFD9D9D9),
            ),
          ),
          const SizedBox(
            width: 100,
            child: Text(
              textAlign: TextAlign.center,
              'สินค้าแนะนำ',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            width: width / 3.5,
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0XFFD9D9D9),
            ),
          )
        ],
      ),
    );
  }

  //? banner slide
  slideImage(FetchDropshipShop detail) {
    return Container(
      color: Colors.white,
      height: 350,
      child: CarouselSlider.builder(
        autoSliderTransitionTime: const Duration(milliseconds: 500),
        unlimitedMode: false,
        slideBuilder: (index) {
          if (detail.productDetail!.imageList[index].imageType == "image") {
            return InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  imageUrl: detail.productDetail!.imageList[index].imageUrl,
                  fit: BoxFit.fitHeight,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),
            );
          } else {
            return FutureBuilder(
                future: _initializeVideoPlayerFuture(
                    detail.productDetail!.imageList[index].imageUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final chewieController = ChewieController(
                      allowFullScreen: false,
                      showControls: true,
                      videoPlayerController: _controller!,
                      autoPlay: false,
                      looping: false,
                    );
                    if (_controller == null) {
                      chewieController.dispose();
                    }
                    return AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: Chewie(
                          controller: chewieController,
                        ));
                  } else {
                    return Center(child: theme_loading_df);
                  }
                });
          }
        },
        slideTransform: const DefaultTransform(),
        slideIndicator: CircularSlideIndicator(
            indicatorRadius: 3,
            itemSpacing: 10,
            padding: const EdgeInsets.only(bottom: 10),
            currentIndicatorColor: theme_color_df,
            indicatorBackgroundColor: Colors.grey),
        itemCount: detail.productDetail!.imageList.length,
        initialPage: 0,
        enableAutoSlider: false,
      ),
    );
  }

  //? show ราคา
  showPrice(FetchDropshipShop detail) {
    return Container(
      width: double.infinity,
      color: theme_color_df,
      child: Padding(
        padding: setPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${myFormat.format(double.parse(detail.productDetail!.price))} ${MultiLanguages.of(context)!.translate('order_baht')}',
              style: const TextStyle(
                  height: 1.5,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            // Row(
            //   children: [
            //     Container(
            //         alignment: Alignment.center,
            //         decoration: BoxDecoration(
            //           boxShadow: const [
            //             BoxShadow(
            //               color: Color.fromARGB(14, 0, 0, 0),
            //               offset: Offset(0.0, 4.0),
            //               blurRadius: 0.2,
            //               spreadRadius: 0.2,
            //             ), //BoxShadow
            //           ],
            //           color: theme_red,
            //           borderRadius: BorderRadius.circular(2),
            //         ),
            //         width: 70.0,
            //         height: 30.0,
            //         // ignore: prefer_const_constructors
            //         child: Text(
            //           textAlign: TextAlign.center,
            //           '-20%',
            //           style: const TextStyle(fontSize: 18, color: Colors.white),
            //         )),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     const Text(
            //       "2100 บาท",
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 16,
            //         decoration: TextDecoration.lineThrough,
            //       ),
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  //? show ชื่อสินค้า และรหัสสินค้า
  showName(FetchDropshipShop detail) {
    return Padding(
      padding: setPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Text(
                  detail.productDetail!.deliveryType,
                  style:
                      TextStyle(color: theme_red, fontWeight: FontWeight.bold),
                ),
                const VerticalDivider(
                  color: Color.fromARGB(255, 247, 104, 82),
                  thickness: 1,
                ),
                Text(
                  detail.productDetail!.paymentType,
                  style:
                      TextStyle(color: theme_red, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            detail.productDetail!.productName,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          Text('รหัส ${detail.productDetail!.billYup}'),
        ],
      ),
    );
  }

  //? show รายละเอียดสินค้า
  showDetail(FetchDropshipShop detail) {
    return Padding(
      padding: setPadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "รายละเอียดสินค้า",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(
          color: theme_color_df,
          thickness: 1,
        ),
        HtmlWidget(
          '''
  ${detail.productDetail!.productdetail}
  ''',
          customStylesBuilder: (element) {
            if (element.classes.contains('foo')) {
              return {'color': 'red'};
            }

            return null;
          },
          customWidgetBuilder: (element) {
            if (element.attributes['foo'] == 'bar') {}

            return null;
          },
          // isSelectable: true,
          onLoadingBuilder: (context, element, loadingProgress) => Container(),
          renderMode: RenderMode.column,
          textStyle: const TextStyle(fontSize: 14),
          // ignore: deprecated_member_use
          // webView: true,
        )
      ]),
    );
  }

  //? ร้านค้า
  brandShop(double width, FetchDropshipShop detail) {
    return Container(
      width: double.infinity,
      color: colorsBrand,
      child: Padding(
        padding: setPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundColor: Colors.amber),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.productDetail!.supplierName,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      detail.productDetail!.supplierType,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: width,
              child: ElevatedButton(
                  onPressed: () {
                    detail.fetchProductSupplierDropship(
                        detail.productDetail!.supplierCode);
                    Get.to(() => const ShopDropShip());
                  },
                  child: const Text("ไปที่ร้านค้า")),
            )
          ],
        ),
      ),
    );
  }

  //? add to cart
  buttonAddtoCart(BuildContext context) {
    return GetBuilder<FetchDropshipShop>(builder: (dialog) {
      if (!dialog.isProductDetailLoading.value &&
          dialog.productDetail!.productCode != '') {
        return Container(
          height: 60,
          color: theme_color_df,
          child: InkWell(
            onTap: () async {
              dialogAddtoCart(context, dialog);
            },
            child: Center(
                child: Text(
              MultiLanguages.of(context)!.translate('btn_add_to_cart'),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'notoreg',
                  fontWeight: FontWeight.bold),
            )),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}

dialogAddtoCart(BuildContext context, FetchDropshipShop dialog) {
  TextEditingController controller = TextEditingController();

  showMaterialModalBottomSheet(
      backgroundColor: Colors.white,
      isDismissible: false,
      barrierColor: Colors.black26,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      context: context,
      builder: (builder) {
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
        controller.value = controller.value.copyWith(text: 1.toString());
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Container(
            height: 260 + (MediaQuery.of(context).viewInsets.bottom),
            color: Colors.transparent,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CachedNetworkImage(
                                height: 100,
                                imageUrl: dialog.productDetail!.imageURL,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${MultiLanguages.of(context)!.translate('product_code')}  ${dialog.productDetail!.billYup}',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${myFormat.format(double.parse(dialog.productDetail!.price))} ${MultiLanguages.of(context)!.translate('order_baht')}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF00AEEF),
                                    fontWeight: FontWeight.bold),
                              ),
                              // Text('ราคา  45 บาท'),
                            ],
                          )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text('กรุณาระบุจำนวน',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    splashRadius: 10,
                                    onPressed: (() {
                                      if (controller.text.isNotEmpty) {
                                        var remove =
                                            int.parse(controller.text) - 1;
                                        if (remove >= 1) {
                                          controller.value = controller.value
                                              .copyWith(
                                                  text: remove.toString());
                                        }
                                      }
                                    }),
                                    icon: Icon(
                                      Icons.remove_circle,
                                      color: theme_color_df,
                                    )),
                                SizedBox(
                                  width: 80.0,
                                  height: 60.0,
                                  child: Center(
                                    child: TextField(
                                      enableInteractiveSelection: false,
                                      textInputAction: TextInputAction.done,
                                      autofocus: false,
                                      showCursor: false,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.center,
                                      controller: controller,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                        FilteringTextInputFormatter.deny(
                                          RegExp(
                                              r'^0+'), //ป้องกันการใส่เลข 0 ตำแหน่งแรก
                                        ),
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(7),
                                        isCollapsed: true,
                                        border: OutlineInputBorder(),
                                      ),
                                      onTap: () {
                                        controller.selection = TextSelection(
                                            baseOffset: 0,
                                            extentOffset:
                                                controller.text.length);
                                      },
                                      onChanged: (text) {
                                        if (text.isNotEmpty) {
                                          controller.value = controller.value
                                              .copyWith(text: text);
                                        } else {
                                          controller.text = '1';
                                          controller.selection = TextSelection(
                                              baseOffset: 0,
                                              extentOffset:
                                                  controller.text.length);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                IconButton(
                                    splashRadius: 10,
                                    onPressed: (() {
                                      if (controller.text.isNotEmpty) {
                                        var add =
                                            int.parse(controller.text) + 1;
                                        if (add <= 999) {
                                          controller.value = controller.value
                                              .copyWith(text: add.toString());
                                        }
                                      }
                                    }),
                                    icon: Icon(Icons.add_circle,
                                        color: theme_color_df)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(
                                        255, 145, 202, 223),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width / 2.2,
                                        10),
                                    side: const BorderSide(
                                        width: 1.0, color: Color(0xFF00AEEF)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.text = '1';
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                      MultiLanguages.of(context)!
                                          .translate('alert_close'),
                                      style: const TextStyle(
                                          color: Color(0xFF00AEEF))),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width / 2.2,
                                        10),
                                    backgroundColor: const Color(0xFF00AEEF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    var mChannel = '';
                                    var mChannelId = '';
                                    Navigator.of(context).pop();
                                    await fnEditCartDropship(
                                        context,
                                        dialog.productDetail!,
                                        'dropship_ProductDetail ${controller.text}',
                                        mChannel,
                                        mChannelId);
                                  },
                                  child: Text(
                                    MultiLanguages.of(context)!
                                        .translate('btn_add_to_cart'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  )),
            ),
          ),
        );
      });
}
