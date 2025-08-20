import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/models/chat/seller.list.model.dart';
import 'package:fridayonline/member/views/(other)/help.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

appBarChat(SellerChat shop) {
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
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Get.find<BrandCtr>().fetchShopData(shop.sellerId);
                Get.toNamed('/BrandStore/${shop.sellerId}');
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          clipBehavior: Clip.none,
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(50),
                          //     border: Border.all()),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: shop.sellerImage,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.deepOrange.shade700),
                            child: const Text(
                              'Mall',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop.sellerName,
                          style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   'เข้าสู่ระบบเมื่อ 5 วินาทีที่เเล้ว',
                        //   style: GoogleFonts.ibmPlexSansThai(
                        //     height: 1,
                        //     fontWeight: FontWeight.normal,
                        //     color: Colors.grey.shade500,
                        //     fontSize: 11,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => const HelpFriday());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.only(right: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  Text(
                    'ศูนย์ช่วยเหลือ',
                    style: GoogleFonts.ibmPlexSansThai(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.normal),
                  ),
                  const Icon(Icons.support_agent, color: Colors.red)
                ]),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
