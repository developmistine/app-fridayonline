// import 'dart:developer';
// import 'dart:ffi';

// import 'package:fridayonline/homepage/home/content_list.dart';
// import 'package:fridayonline/homepage/login/widgetsetprofilerheader.dart';
// import 'package:fridayonline/homepage/theme/theme_loading.dart';
// import 'package:fridayonline/homepage/theme/themeimageprofiler.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/model/set_data/set_data_saledirect.dart';
// import 'package:fridayonline/mslinfo/saledirect_pro.dart';
// import 'package:fridayonline/service/pathapi.dart';
import 'package:fridayonline/service/profileuser/getsaledirect.dart';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../homepage/theme/theme_color.dart';
// import '../homepage/webview/webview_app.dart';
import '../service/languages/multi_languages.dart';

final titles = ["โบนัสสะสม", "โปรเงินล้าน", "มีนัดกับมาดาม", "เส้นทางเศรษฐี"];

// แก้ไขเพิ่มเติม
class SaleDirect extends StatefulWidget {
  const SaleDirect({super.key});

  @override
  State<SaleDirect> createState() => _SaleDirectState();
}

class _SaleDirectState extends State<SaleDirect> {
  SetData data = SetData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleMaster(
          MultiLanguages.of(context)!.translate('direct_million')),
      body: Column(
        children: [
          FutureBuilder(
            future: getSaleDirect(),
            builder:
                (BuildContext context, AsyncSnapshot<GetSaleDirect?> snapshot) {
              if (snapshot.hasData) {
                var mparmMenu = snapshot.data;
                if (mparmMenu!.activity.isNotEmpty) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Center(
                          child: GestureDetector(
                        onTap: () {
                          var url = mparmMenu.activity[0].contentIndcx;
                          Get.to(() => WebViewFullScreen(mparamurl: url));
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 300,
                              height: 50,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0, color: theme_color_df),
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: theme_color_df),
                              child: Text(
                                MultiLanguages.of(context)!
                                    .translate('bonus_accumulated'),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Image.asset(
                                width: 70,
                                'assets/images/cartoon/Yupin-Cartoon02.png'),
                          ],
                        ),
                      )),
                      // const SizedBox(height: 10),
                      // Center(
                      //     child: GestureDetector(
                      //   onTap: () {
                      //     Get.to(() => saledirect_pro(
                      //         mparamType: 'content',
                      //         mparamTitleName: MultiLanguages.of(context)!
                      //             .translate('promotion_million'),
                      //         contentIndcx: '',
                      //         band: '',
                      //         imgurl: '',
                      //         keyindex: ''));
                      //   },
                      //   child: Stack(
                      //     alignment: AlignmentDirectional.bottomStart,
                      //     children: [
                      //       Container(
                      //         alignment: Alignment.center,
                      //         width: 300,
                      //         height: 50,
                      //         padding: const EdgeInsets.all(10.0),
                      //         decoration: BoxDecoration(
                      //             border: Border.all(
                      //                 width: 1.0, color: theme_color_df),
                      //             borderRadius: BorderRadius.circular(10.0),
                      //             color: theme_color_df),
                      //         child: Text(
                      //           MultiLanguages.of(context)!
                      //               .translate('promotion_million'),
                      //           style: const TextStyle(color: Colors.white),
                      //         ),
                      //       ),
                      //       Image.asset(
                      //           width: 70,
                      //           'assets/images/cartoon/Yupin-Emotion04.png'),
                      //     ],
                      //   ),
                      // )),
                      const SizedBox(height: 10),
                      Center(
                          child: GestureDetector(
                        onTap: () async {
                          var url = mparmMenu.activity[2].contentIndcx;
                          Get.to(() => WebViewFullScreen(mparamurl: url));
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 300,
                              height: 50,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0, color: theme_color_df),
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: theme_color_df),
                              child: Text(
                                MultiLanguages.of(context)!
                                    .translate('appointment_madame'),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Image.asset(
                                width: 60,
                                'assets/images/cartoon/Yupin-Emotion01.png'),
                          ],
                        ),
                      )),
                      const SizedBox(height: 10),
                      Center(
                          child: GestureDetector(
                        onTap: () {
                          var url = mparmMenu.activity[3].contentIndcx;
                          Get.to(() => WebViewFullScreen(mparamurl: url));
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 300,
                              height: 50,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0, color: theme_color_df),
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: theme_color_df),
                              child: Text(
                                MultiLanguages.of(context)!
                                    .translate('millionaire'),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Image.asset(
                                width: 70,
                                'assets/images/cartoon/Yupin-Emotion05.png'),
                          ],
                        ),
                      )),
                    ],
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo/logofriday.png',
                          width: 50,
                          height: 50,
                        ),
                        Text(MultiLanguages.of(context)!
                            .translate('alert_no_datas')),
                      ],
                    ),
                  );
                }
              } else {
                return const Center();
              }
            },
          ),
        ],
      ),
    );
  }
}
