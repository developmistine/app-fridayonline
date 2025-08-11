import 'package:fridayonline/enduser/controller/cart.ctr.dart';
import 'package:fridayonline/enduser/controller/search.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/enduser/controller/track.ctr.dart';
import 'package:fridayonline/enduser/views/(cart)/cart.main.dart';
import 'package:fridayonline/enduser/views/(search)/search.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../homepage/theme/theme_color.dart';

final ShowProductSkuCtr showProductCtr = Get.find();
final TrackCtr trackCtr = Get.find();

var border = OutlineInputBorder(
  borderSide: BorderSide(
    color: theme_color_df,
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
                                color: theme_color_df,
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
                                hintStyle: GoogleFonts.notoSansThaiLooped(
                                  fontSize: 13,
                                  color: theme_color_df,
                                ),
                                prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Icon(
                                    Icons.search,
                                    color: theme_color_df,
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
                                            backgroundColor: theme_color_df,
                                            foregroundColor: Colors.white,
                                            child: Obx(() {
                                              return cartCtr.isLoadingCart.value
                                                  ? Text(
                                                      '${cartCtr.cartItems!.value.data.map((e) => e.items.length).fold(0, (previousValue, element) => previousValue + element)}',
                                                      style: GoogleFonts
                                                          .notoSansThaiLooped(
                                                              height: 1,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                    )
                                                  : Text(
                                                      '${cartCtr.cartItems!.value.data.map((e) => e.items.length).fold(0, (previousValue, element) => previousValue + element)}',
                                                      style: GoogleFonts
                                                          .notoSansThaiLooped(
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
                                color:
                                    isSetAppbar ? theme_color_df : Colors.white,
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
