import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridayonline/member/components/utils/share.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/controller/search.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/controller/track.ctr.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:fridayonline/member/views/(search)/search.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fridayonline/theme.dart';

final ShowProductSkuCtr showProductCtr = Get.find();
final TrackCtr trackCtr = Get.find();

var border = OutlineInputBorder(
  borderSide: BorderSide(
    color: themeColorDefault,
    width: 1,
  ),
  borderRadius: const BorderRadius.all(
    Radius.circular(8),
  ),
);
PreferredSize appbarSku(
    {required BuildContext ctx,
    required String title,
    required bool isSetAppbar,
    required GlobalKey<State<StatefulWidget>> keyCart,
    required ScrollController scrollController}) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: MediaQuery(
          data: MediaQuery.of(ctx)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Material(
            elevation: 0, // ตั้ง elevation เป็น 0
            color: isSetAppbar ? Colors.white : Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: isSetAppbar
                    ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ]
                    : [],
              ),
              child: AppBar(
                elevation: 0,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
                backgroundColor:
                    isSetAppbar ? Colors.white : Colors.transparent,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isSetAppbar
                          ? InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: themeColorDefault,
                              ),
                            )
                          : InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black54.withOpacity(0.2),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                      const SizedBox(width: 12),
                      if (isSetAppbar)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                focusedBorder: border,
                                enabledBorder: border,
                                isDense: true,
                                hintText: 'ค้นหาสินค้า',
                                hintStyle: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 13,
                                  color: themeColorDefault,
                                ),
                                prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Icon(
                                    Icons.search,
                                    color: themeColorDefault,
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 10,
                                  minHeight: 10,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                              ),
                              onTap: () {
                                trackCtr.clearLogContent();
                                Get.find<SearchProductCtr>()
                                    .fetchProductSuggust(0);
                                Get.find<SearchProductCtr>().fetchSort();
                                Get.to(() => const EndUserSearch());
                                // showProductCtr.gotoNewPage('/EndUserSearch');
                              },
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          // if (showProductCtr.productDetail.value!.data.canShare)
                          //   InkWell(
                          //     splashColor: Colors.transparent,
                          //     highlightColor: Colors.transparent,
                          //     onTap: () {
                          //       shareDialog(
                          //         shareType: 'product',
                          //         shareTitle: 'แชร์เพื่อรับค่าคอมมิชชั่นนี้',
                          //         productPrices: showProductCtr
                          //             .productDetail.value!.data.productPrice,
                          //         product: ShareProduct(
                          //           productId: showProductCtr
                          //               .productDetail.value!.data.productId,
                          //           title: showProductCtr
                          //               .productDetail.value!.data.title,
                          //           image: showProductCtr.productDetail.value!
                          //               .data.productImages.image.first.image,
                          //           commission: showProductCtr
                          //               .productDetail.value!.data.commission,
                          //         ),
                          //       );
                          //     },
                          //     child: Stack(
                          //       alignment: Alignment.center,
                          //       children: [
                          //         Container(
                          //           width: 32,
                          //           height: 32,
                          //           padding: EdgeInsets.zero,
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(50),
                          //             color: isSetAppbar
                          //                 ? Colors.transparent
                          //                 : Colors.black54.withOpacity(0.2),
                          //           ),
                          //         ),
                          //         Stack(
                          //           clipBehavior: Clip.none,
                          //           children: [
                          //             IconButton(
                          //               splashColor: Colors.transparent,
                          //               highlightColor: Colors.transparent,
                          //               // key: keyCart,
                          //               onPressed: () {
                          //                 shareDialog(
                          //                   shareType: 'product',
                          //                   shareTitle: 'แชร์สินค้า',
                          //                   productPrices: showProductCtr
                          //                       .productDetail
                          //                       .value!
                          //                       .data
                          //                       .productPrice,
                          //                   product: ShareProduct(
                          //                     productId: showProductCtr
                          //                         .productDetail
                          //                         .value!
                          //                         .data
                          //                         .productId,
                          //                     title: showProductCtr
                          //                         .productDetail
                          //                         .value!
                          //                         .data
                          //                         .title,
                          //                     image: showProductCtr
                          //                         .productDetail
                          //                         .value!
                          //                         .data
                          //                         .productImages
                          //                         .image
                          //                         .first
                          //                         .image,
                          //                     commission: showProductCtr
                          //                         .productDetail
                          //                         .value!
                          //                         .data
                          //                         .commission,
                          //                   ),
                          //                 );
                          //               },
                          //               icon: SvgPicture.asset(
                          //                 'assets/images/affiliate/share.svg',
                          //                 color: isSetAppbar
                          //                     ? themeColorDefault
                          //                     : Colors.white,
                          //                 width: 20,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              trackCtr.clearLogContent();
                              Get.find<EndUserCartCtr>().fetchCartItems();
                              Get.to(() => const EndUserCart());
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  padding: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: isSetAppbar
                                        ? Colors.transparent
                                        : Colors.black54.withOpacity(0.2),
                                  ),
                                ),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      key: keyCart,
                                      onPressed: () {
                                        // Get.find<ShowProductSkuCtr>().scrCtrl =
                                        //     null;
                                        Get.find<EndUserCartCtr>()
                                            .fetchCartItems();
                                        Get.to(() => const EndUserCart());
                                      },
                                      icon: Image.asset(
                                        isSetAppbar
                                            ? 'assets/images/icon/cart-blue.png'
                                            : 'assets/images/icon/cart-white.png',
                                        width: 20,
                                      ),
                                    ),
                                    Positioned(
                                        right: 4,
                                        top: -7,
                                        child: SizedBox(
                                          width: 18,
                                          child: CircleAvatar(
                                            backgroundColor: themeColorDefault,
                                            foregroundColor: Colors.white,
                                            child: Obx(() {
                                              return cartCtr.isLoadingCart.value
                                                  ? Text(
                                                      '${cartCtr.cartItems!.value.data.map((e) => e.items.length).fold(0, (previousValue, element) => previousValue + element)}',
                                                      style: GoogleFonts
                                                          .ibmPlexSansThai(
                                                              height: 1,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                    )
                                                  : Text(
                                                      '${cartCtr.cartItems!.value.data.map((e) => e.items.length).fold(0, (previousValue, element) => previousValue + element)}',
                                                      style: GoogleFonts
                                                          .ibmPlexSansThai(
                                                              height: 1,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                    );
                                            }),
                                          ),
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              trackCtr.clearLogContent();
                              Get.offAllNamed('/EndUserHome');
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: isSetAppbar
                                    ? Colors.transparent
                                    : Colors.black54.withOpacity(0.2),
                              ),
                              child: Icon(
                                Icons.home_outlined,
                                color: isSetAppbar
                                    ? themeColorDefault
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )));
}
