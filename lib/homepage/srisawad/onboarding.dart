import 'package:fridayonline/enduser/utils/image_preloader.dart';
import 'package:fridayonline/homepage/login/webview_pdpa_srisawad.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/safearea.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingCtr extends GetxController {
  RxInt pageIndex = 0.obs;
  List<Map<String, String>> page = [
    {
      "img": "assets/images/onboarding/boarding-1.png",
      "title": "เริ่มขายได้ทันที ไม่ต้องลงทุน!",
      "subTitle":
          "ไม่ต้องสต๊อกสินค้า ไม่ต้องกังวลเรื่องสินค้าค้าง\nบริการส่งสินค้าฟรี!! ถึงบ้าน",
    },
    {
      "img": "assets/images/onboarding/boarding-2.png",
      "title": "สิทธิพิเศษสำหรับสมาชิก",
      "subTitle":
          "โปรโมชั่นจัดเต็ม ส่วนลด ของแถม\nและกิจกรรมลุ้นรางวัลทุกเดือน",
    },
    {
      "img": "assets/images/onboarding/boarding-3.png",
      "title": "สะสมคะแนน 🎁\nเพื่อแลกของรางวัลมากมาย",
      "subTitle": "ยิ่งขายได้ ยิ่งคุ้ม! ทุกๆ 25 บาท = 1 คะแนน",
    },
    {
      "img": "assets/images/onboarding/boarding-4.png",
      "title": "ได้รับกำไรเป็น % ตามยอดขาย",
      "subTitle":
          " ยิ่งขายมาก  กำไรก็ยิ่งมาก\nได้กำไรเพิ่มสูงสุดถึง 30% สมัครเลยวันนี้..",
    },
  ];
}

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    final boardingCtr = Get.put(OnBoardingCtr());
    return SafeAreaProvider(
        child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1)),
            child: Scaffold(
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: AppBar(
                        automaticallyImplyLeading: false,
                        iconTheme: const IconThemeData(
                          color: Colors.white, //change your color here
                        ),
                        centerTitle: true,
                        backgroundColor: theme_color_df,
                        title: Text(
                          'สมัครสมาชิก',
                          style: GoogleFonts.notoSansThai(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                body: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: Get.height / 3,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  const Color(0xFF2EA9E1).withOpacity(0.1),
                                  const Color(0xFFFFFFFF).withOpacity(0.1),
                                ])),
                      ),
                    ),
                    PageView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: boardingCtr.page.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            PreloadedImageWidget(
                              width: Get.width,
                              height: 420,
                              assetPath: boardingCtr.page[index]['img']!,
                            ),
                            // Image.asset(
                            //   boardingCtr.page[index]['img']!,
                            // ),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              boardingCtr.page[index]['title']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoSansThai(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              boardingCtr.page[index]['subTitle']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoSansThai(fontSize: 18),
                            ),
                          ],
                        );
                      },
                      padEnds: false,
                      onPageChanged: (value) {
                        boardingCtr.pageIndex.value = value;
                      },
                    ),
                    Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: Get.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(boardingCtr.page.length,
                                    (index) {
                                  return Obx(() {
                                    return AnimatedContainer(
                                      width:
                                          boardingCtr.pageIndex.value == index
                                              ? 24
                                              : 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                          color: boardingCtr.pageIndex.value ==
                                                  index
                                              ? theme_color_df
                                              : const Color(0xFFC6C5C9),
                                          borderRadius: BorderRadius.circular(
                                              boardingCtr.pageIndex.value ==
                                                      index
                                                  ? 12
                                                  : 50)),
                                      duration:
                                          const Duration(milliseconds: 300),
                                    );
                                  });
                                }),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            SizedBox(
                              width: 320,
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: theme_color_df,
                                      elevation: 0),
                                  onPressed: () {
                                    Get.to(() => const WebviewPdpaSrisawad());
                                  },
                                  child: Text(
                                    'สมัครสมาชิกเลย',
                                    style: GoogleFonts.notoSansThai(
                                        fontWeight: FontWeight.bold),
                                  )),
                            )
                          ],
                        ))
                  ],
                ))));
  }
}
