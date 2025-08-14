import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final EndUserSignInCtr endUserSignInCtr = Get.put(EndUserSignInCtr());

PreferredSize appbarEndUserRegister(pageCtr) {
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
            leading: BackButton(
                color: themeColorDefault,
                onPressed: () {
                  if (endUserSignInCtr.currentPage.value > 0) {
                    endUserSignInCtr.currentPage.value--;
                    pageCtr.jumpToPage(endUserSignInCtr.currentPage.value);
                  } else {
                    Get.back();
                  }
                }),
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Obx(() {
              return Text(
                endUserSignInCtr.currentPage.value == 2
                    ? 'สอบถามความสนใจของคุณ'
                    : 'สมัครสมาชิก',
                style: GoogleFonts.notoSansThaiLooped(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              );
            }),
          ),
        ),
      ));
}
