import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

appBarMasterEndUser(String titles) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50),
    child: MediaQuery(
      data: MediaQuery.of(Get.context!)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: AppBar(
        elevation: 0.2,
        leading: InkWell(
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
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
          style: GoogleFonts.ibmPlexSansThai(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    ),
  );
}
