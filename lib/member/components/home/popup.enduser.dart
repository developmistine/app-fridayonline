import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/models/home/home.popup.model.dart';
import 'package:fridayonline/member/services/home/home.service.dart';
import 'package:fridayonline/member/services/track/track.service.dart';
import 'package:fridayonline/member/utils/event.dart';
import 'package:fridayonline/print.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

EndUserHomeCtr homeCtr = Get.find();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

// ignore: strict_top_level_inference
showPopupEndUser(BuildContext context) async {
  int current = 0;
  bool isCheck = false;
  SetData data = SetData();
  var repType = await data.repType;
  print('reptype popup : $repType');
  if (repType != "0" && repType != "5") {
    print('ไม่แสดง');
    return;
  }
  EndUserPopup? popup = await fetctPopupService(2);
  if (popup!.data.isNotEmpty) {
    homeCtr.isViewPopup.value = true;
    return Get.dialog(Dialog(
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: Get.height / 2.5,
                      child: CarouselSlider.builder(
                        itemCount: popup.data.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            SizedBox(
                          width: Get.width,
                          child: InkWell(
                            onTap: () async {
                              Get.back(result: 'view');
                              var bannerItem = popup.data[itemIndex];
                              eventBanner(bannerItem, 'home_popup');
                            },
                            child: CachedNetworkImage(
                              imageUrl: popup.data[itemIndex].image,
                              fit: BoxFit.contain,
                              fadeInDuration: const Duration(milliseconds: 300),
                              fadeOutDuration:
                                  const Duration(milliseconds: 300),
                            ),
                          ),
                        ),
                        options: CarouselOptions(
                            enableInfiniteScroll: popup.data.length > 1,
                            aspectRatio: 1,
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayAnimationDuration:
                                const Duration(seconds: 2),
                            onPageChanged: (index, reason) {
                              setState(() {
                                current = index;
                              });
                            }),
                      ),
                    ),
                    if (popup.data.length > 1)
                      Positioned(
                        bottom: -14,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(popup.data.length, (index) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: (current == index
                                          ? Colors.red
                                          : Colors.grey.shade400)
                                      .withValues(
                                          alpha: current == index ? 0.9 : 0.5)),
                            );
                          }),
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(
                          () {
                            isCheck = !isCheck;
                          },
                        );
                      },
                      child: Row(
                        children: [
                          if (!isCheck)
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: Colors.white,
                                ),
                                Icon(
                                  Icons.check_box_outline_blank,
                                  color: themeColorDefault,
                                ),
                              ],
                            )
                          else
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  color: Colors.white,
                                  width: 16,
                                  height: 16,
                                ),
                                Icon(
                                  Icons.check_box,
                                  color: themeColorDefault,
                                ),
                              ],
                            ),
                          Text(
                            'ไม่ต้องแสดงอีกในวันนี้',
                            style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 12, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: const BorderSide(color: Colors.white))),
                      onPressed: () async {
                        if (isCheck) {
                          DateTime now = DateTime.now();
                          String date = '${now.year}-${now.month}-${now.day}';
                          final SharedPreferences prefs = await _prefs;
                          prefs.setString("ClosePopupDay", date);
                        }
                        Get.back(result: 'close');
                      },
                      child: SizedBox(
                        width: 30,
                        height: 40,
                        child: Center(
                          child: Text(
                            'ปิด',
                            style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }))).then((value) {
      final item = popup.data[current];
      if (value != 'view' && item.pgmId != 0) {
        setTrackIncentiveContentViewServices(
          item.contentId,
          item.contentName,
          'home_popup',
          0,
          item.pgmId,
          'close',
        );
      }
    });
  }
}
