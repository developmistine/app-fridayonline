import 'package:fridayonline/enduser/controller/cart.ctr.dart';
import 'package:fridayonline/enduser/controller/chat.ctr.dart';
import 'package:fridayonline/enduser/controller/track.ctr.dart';
import 'package:fridayonline/enduser/views/(cart)/cart.main.dart';
import 'package:fridayonline/enduser/views/(chat)/chat.dart';
import 'package:fridayonline/theme.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

appBarNoSearchEndUser(String titles, {String? page}) {
  final chatCtr = Get.find<ChatController>();
  return PreferredSize(
    preferredSize: const Size.fromHeight(50),
    child: MediaQuery(
      data: MediaQuery.of(Get.context!)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(
          textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
            Theme.of(Get.context!).textTheme,
          ),
        ),
        child: AppBar(
          elevation: 1,
          leading: page == "home"
              ? null
              : InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: themeColorDefault,
                  ),
                ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            titles,
            style: GoogleFonts.notoSansThaiLooped(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
          actions: [
            Container(
              width: 40,
              margin: const EdgeInsets.only(right: 5.0),
              child: badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 2, end: 0),
                  badgeAnimation:
                      const badges.BadgeAnimation.slide(loopAnimation: false),
                  badgeContent: Obx(() {
                    return cartCtr.isLoadingCart.value
                        ? Text(
                            '0',
                            style: GoogleFonts.notoSansThaiLooped(
                                height: 1, color: Colors.white, fontSize: 10),
                          )
                        : Text(
                            '${cartCtr.cartItems!.value.data.map((e) => e.items.length).fold(0, (previousValue, element) => previousValue + element)}',
                            style: GoogleFonts.notoSansThaiLooped(
                                height: 1, color: Colors.white, fontSize: 10),
                          );
                  }),
                  badgeStyle: badges.BadgeStyle(
                      badgeColor: themeColorDefault,
                      padding: const EdgeInsets.all(5)),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () async {
                      Get.find<TrackCtr>().clearLogContent();
                      Get.find<EndUserCartCtr>().fetchCartItems();
                      Get.to(() => const EndUserCart());
                    },
                    icon: Image.asset(
                      'assets/images/icon/cart-blue.png',
                      width: 28,
                    ),
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(right: 5.0),
              child: badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 2, end: 0),
                  badgeAnimation:
                      const badges.BadgeAnimation.slide(loopAnimation: false),
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
                      Get.find<TrackCtr>().clearLogContent();
                      chatCtr.fetchSellerChat(0);
                      Get.to(() => const ChatApp());
                    },
                    icon: Image.asset("assets/images/b2c/chat/chat-blue.png"),
                  )),
            )
          ],
        ),
      ),
    ),
  );
}
