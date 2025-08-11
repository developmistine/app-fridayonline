import 'package:fridayonline/enduser/controller/brand.ctr.dart';
import 'package:fridayonline/enduser/controller/enduser.home.ctr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final EndUserHomeCtr endUserHomeCtr = Get.find();
final BrandCtr brandCtr = Get.find<BrandCtr>();

flashDealTimer() {
  return Obx(() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 4),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2), color: Colors.black),
          alignment: Alignment.center,
          child: Text(
            endUserHomeCtr.countdown.value.split(":")[0],
            style: GoogleFonts.notoSansThaiLooped(
                height: 1.2, color: Colors.white, fontSize: 13),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            ':',
            style: GoogleFonts.notoSansThaiLooped(
                height: 1, color: Colors.black, fontSize: 13),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2), color: Colors.black),
          alignment: Alignment.center,
          child: Text(
            endUserHomeCtr.countdown.value.split(":")[1],
            style: GoogleFonts.notoSansThaiLooped(
                height: 1.2, color: Colors.white, fontSize: 13),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            ':',
            style: GoogleFonts.notoSansThaiLooped(
                height: 1, color: Colors.black, fontSize: 13),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2), color: Colors.black),
          alignment: Alignment.center,
          child: Text(
            endUserHomeCtr.countdown.value.split(":")[2],
            style: GoogleFonts.notoSansThaiLooped(
                height: 1.2, color: Colors.white, fontSize: 13),
          ),
        ),
      ],
    );
  });
}

shopflashDealTimer() {
  return Obx(() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 4),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2), color: Colors.black),
          alignment: Alignment.center,
          child: Text(
            brandCtr.countdown.value.split(":")[0],
            style: GoogleFonts.notoSansThaiLooped(
                height: 1.2, color: Colors.white, fontSize: 13),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            ':',
            style: GoogleFonts.notoSansThaiLooped(
                height: 1, color: Colors.black, fontSize: 13),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2), color: Colors.black),
          alignment: Alignment.center,
          child: Text(
            brandCtr.countdown.value.split(":")[1],
            style: GoogleFonts.notoSansThaiLooped(
                height: 1.2, color: Colors.white, fontSize: 13),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            ':',
            style: GoogleFonts.notoSansThaiLooped(
                height: 1, color: Colors.black, fontSize: 13),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2), color: Colors.black),
          alignment: Alignment.center,
          child: Text(
            brandCtr.countdown.value.split(":")[2],
            style: GoogleFonts.notoSansThaiLooped(
                height: 1.2, color: Colors.white, fontSize: 13),
          ),
        ),
      ],
    );
  });
}
