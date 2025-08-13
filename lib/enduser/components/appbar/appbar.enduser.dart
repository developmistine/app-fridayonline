import 'package:fridayonline/enduser/controller/cart.ctr.dart';
import 'package:fridayonline/enduser/controller/chat.ctr.dart';
import 'package:fridayonline/enduser/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/enduser/controller/search.ctr.dart';
import 'package:fridayonline/enduser/views/(cart)/cart.main.dart';
import 'package:fridayonline/enduser/views/(chat)/chat.dart';
import 'package:fridayonline/enduser/views/(search)/search.view.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fridayonline/theme.dart';

var border = const OutlineInputBorder(
  borderSide: BorderSide(
    color: Colors.transparent,
    width: 0,
  ),
  borderRadius: BorderRadius.all(
    Radius.circular(4),
  ),
);
PreferredSize appbarEnduser(
    {required BuildContext ctx, required bool isSetAppbar, double? elevation}) {
  final EndUserSignInCtr ctr = Get.find();
  final chatCtr = Get.find<ChatController>();
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
              boxShadow: isSetAppbar && elevation == null
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(0, 0),
                        blurRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: AppBar(
              elevation: elevation,
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark),
              backgroundColor: isSetAppbar ? Colors.white : Colors.transparent,
              automaticallyImplyLeading: false,
              centerTitle: true,
              titleSpacing: 0,
              title: Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: !isSetAppbar
                              ? [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    offset: const Offset(0, 0),
                                    blurRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: TextField(
                          onTap: () {
                            Get.find<SearchProductCtr>().fetchProductSuggust(0);
                            Get.find<SearchProductCtr>().fetchSort();
                            Get.to(
                              () => const EndUserSearch(),
                              transition: Transition.fade,
                            );
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 4),
                            focusedBorder: border,
                            enabledBorder: border,
                            isDense: true,
                            hintText: 'ค้นหาสินค้า',
                            hintStyle: GoogleFonts.notoSansThaiLooped(
                              fontSize: 13,
                              color: themeColorDefault,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
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
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   width: 12,
                  // ),
                  SizedBox(
                    width: 40,
                    child: badges.Badge(
                        position: badges.BadgePosition.topEnd(top: 2, end: 0),
                        badgeAnimation: const badges.BadgeAnimation.slide(
                            loopAnimation: false),
                        badgeContent: Obx(() {
                          return cartCtr.isLoadingCart.value
                              ? Text(
                                  '0',
                                  style: GoogleFonts.notoSansThaiLooped(
                                      height: 1,
                                      color: Colors.white,
                                      fontSize: 10),
                                )
                              : Text(
                                  '${cartCtr.cartItems!.value.data.map((e) => e.items.length).fold(0, (previousValue, element) => previousValue + element)}',
                                  style: GoogleFonts.notoSansThaiLooped(
                                      height: 1,
                                      color: Colors.white,
                                      fontSize: 10),
                                );
                        }),
                        badgeStyle: badges.BadgeStyle(
                            badgeColor: themeColorDefault,
                            padding: const EdgeInsets.all(5)),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () async {
                            Get.find<EndUserCartCtr>().fetchCartItems();
                            Get.to(() => const EndUserCart());
                          },
                          icon: Image.asset(
                            isSetAppbar
                                ? 'assets/images/icon/cart-blue.png'
                                : 'assets/images/icon/cart-white.png',
                            width: 28,
                          ),
                        )),
                  ),
                  Obx(() {
                    if (ctr.isLoading.value) {
                      return const SizedBox();
                    } else if (ctr.custId == 0) {
                      return const SizedBox();
                    }
                    return Container(
                      margin: const EdgeInsets.only(right: 5.0),
                      child: badges.Badge(
                          position: badges.BadgePosition.topEnd(top: 2, end: 6),
                          badgeAnimation: const badges.BadgeAnimation.slide(
                              loopAnimation: false),
                          badgeContent: Obx(() {
                            return Text(
                              chatCtr.countChat.value.toString(),
                              style: GoogleFonts.notoSansThaiLooped(
                                  height: 1, color: Colors.white, fontSize: 10),
                            );
                          }),
                          badgeStyle: badges.BadgeStyle(
                              badgeColor: themeColorDefault,
                              padding: const EdgeInsets.all(5)),
                          child: IconButton(
                            padding: const EdgeInsets.only(bottom: 12, top: 5),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () async {
                              chatCtr.fetchSellerChat(0);
                              Get.to(() => const ChatApp());
                            },
                            icon: Image.asset(
                              isSetAppbar
                                  ? "assets/images/b2c/chat/chat-blue.png"
                                  : "assets/images/b2c/chat/chat-white.png",
                            ),
                          )),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ));
}
