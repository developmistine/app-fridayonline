import 'package:fridayonline/enduser/controller/cart.ctr.dart';
import 'package:fridayonline/enduser/controller/chat.ctr.dart';
import 'package:fridayonline/enduser/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/enduser/views/(chat)/chat.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;

final EndUserCartCtr cartCtr = Get.find();
final EndUserSignInCtr signInCtr = Get.find();
final chatCtr = Get.find<ChatController>();

AppBar appbarCart() {
  return AppBar(
    elevation: 0.2,
    centerTitle: true,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Get.back();
            // if (Get.currentRoute == '/ShowProductSku') {
            //   Get.find<ShowProductSkuCtr>().goBackToPreviousProduct();
            // }
          },
          child: Icon(
            Icons.arrow_back,
            color: themeColorDefault,
          ),
        ),
        Row(
          children: [
            Text(
              'ตะกร้า',
              style: GoogleFonts.notoSansThaiLooped(
                  fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(width: 4),
            Obx(() {
              return cartCtr.isLoadingCart.value
                  ? const Text('')
                  : Text(
                      '(${cartCtr.cartItems!.value.data.map((e) => e.items.length).fold(0, (previousValue, element) => previousValue + element)})',
                      style: GoogleFonts.notoSansThaiLooped(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    );
            }),
          ],
        ),
        Row(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                cartCtr.showEditCart.value = !cartCtr.showEditCart.value;
              },
              child: Obx(() {
                return !cartCtr.isLoadingCart.value &&
                        cartCtr.cartItems!.value.code != "-9"
                    ? cartCtr.showEditCart.value
                        ? const Text(
                            'สำเร็จ',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.normal),
                          )
                        : const Text(
                            'แก้ไข',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.normal),
                          )
                    : const Text('');
              }),
            ),
            Obx(() {
              if (signInCtr.isLoading.value) {
                return const SizedBox();
              } else if (signInCtr.custId == 0) {
                return const SizedBox();
              }
              return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 6, end: 6),
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
                    padding: const EdgeInsets.only(bottom: 12, top: 10),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () async {
                      chatCtr.fetchSellerChat(0);
                      Get.to(() => const ChatApp());
                    },
                    icon: Image.asset("assets/images/b2c/chat/chat-grey.png",
                        width: 24),
                  ));
            }),
          ],
        ),
      ],
    ),
  );
}
