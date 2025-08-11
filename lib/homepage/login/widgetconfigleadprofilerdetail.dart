// import 'dart:developer';

import 'package:fridayonline/homepage/login/widgetsetprofilerheader.dart';
import 'package:fridayonline/homepage/theme/themeimageprofiler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/set_data/set_data.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/pathapi.dart';
import '../../service/profileuser/getprofile.dart';
import '../../service/profileuser/profileuser_menu_special_project.dart';
import '../theme/constants.dart';
import '../theme/theme_color.dart';
import '../webview/webview_app.dart';
import '../webview/webview_full_screen.dart';

final titles = [
  "แจกแค๊ตตาล็อก/ข้อมูลลูกค้า",
  "ที่อยู่จัดส่ง",
  "ตลาดนัด Friday",
  "ขายตรงเงินล้าน"
];

final titlesenduser = ["ข้อมูลการสั่งซื้อ"];

final titlesSetup = [
  //"ลงทะเบียนเพื่อใช้งาน",
  "ข้อมูลการสั่งซื้อ",
  "ภาษา/Languages",
  "คำแนะนำการใช้งาน",
  "นโยบายความเป็นส่วนตัว"
];

final titlesHelp = ["คำแนะนำในการใช้งาน"];

final titlesHelpenduser = ["คำแนะนำในการใช้งาน"];

// ส่วนของข้อมูลที่เกี่ยวกับสมาชิก
Container configmslprofilerdetail() {
  return Container(
      child: ListView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // <-- this will disable scroll
          shrinkWrap: true,
          itemCount: titles.length,
          itemBuilder: (context, index) {
            return Card(
                color: Colors.white,
                child: ListTile(
                    tileColor: Colors.white,
                    onTap: () {
                      // log(index.toString());
                      // Scaffold.of(context).showSnackBar(SnackBar(
                      //   content:
                      //       Text(titles[index] + ' pressed!'),
                      // ));
                      if (index == 0) {
                        Get.toNamed('/sharecatalog');
                      } else if (index == 1) {
                        Get.toNamed('/editaddress');
                      } else if (index == 2) {
                        Get.toNamed('/market');
                      } else if (index == 3) {
                        Get.toNamed('/saledirect');
                      }
                    },
                    title: Text(
                      titles[index],
                      style:
                          const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                    ),

                    //  subtitle: Text(subtitles[index]),
                    leading: ImageMslinfor[index],
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                    iconColor: theme_color_df));
          }));
}

// ส่วนของข้อมูลที่เกี่ยวกับสมาชิก
Container configenduserprofilerdetail() {
  return Container(
      child: ListView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // <-- this will disable scroll
          shrinkWrap: true,
          itemCount: titlesenduser.length,
          itemBuilder: (context, index) {
            return Card(
                color: Colors.white70,
                child: ListTile(
                    tileColor: Colors.white70,
                    onTap: () {
                      if (index == 0) {
                        Get.toNamed('/enduser_check_information',
                            parameters: {'select': '1'});
                      }
                    },
                    title: Text(
                      titlesenduser[index],
                      style:
                          const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                    ),

                    //  subtitle: Text(subtitles[index]),
                    leading: Imageenduserorder[index],
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                    iconColor: theme_color_df));
          }));
}

// ส่วนของข้อมูลที่เกี่ยวกับการตั้งค่า
Container configSetUpmsl() {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  return Container(
      child: ListView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // <-- this will disable scroll
          shrinkWrap: true,
          itemCount: titlesSetup.length,
          itemBuilder: (context, index) {
            return Card(
                color: Colors.white,
                child: ListTile(
                    tileColor: Colors.white,
                    onTap: () async {
                      // if (index == 0) {
                      //   Get.toNamed('/loginLead');
                      // } else
                      if (index == 0) {
                        Get.toNamed('/lead_check_information',
                            parameters: {'select': '1'});
                      } else if (index == 1) {
                        final SharedPreferences prefs = await pref;
                        var lang = prefs.getString("localeKey");
                        Get.toNamed('/change_languages', parameters: {
                          "lang": lang.toString()
                        }); //กำหนด Route ไปที่ /change_languages
                      } else if (index == 2) {
                        var url = "${baseurl_yclub}yclub/member/help/help.php";
                        Get.to(() => WebViewFullScreen(mparamurl: url));
                      } else if (index == 3) {
                        var nametitle = MultiLanguages.of(context)!
                            .translate('me_policy_pdpa');
                        var url =
                            "${baseurl_yclub}yclub/policyandcondition/privacy-notice_no.php";
                        Get.to(() => webview_app(
                              mparamurl: url,
                              mparamTitleName: nametitle,
                              mparamType: '',
                              mparamValue: '',
                            ));
                      }
                    },
                    title: Text(
                      titlesSetup[index],
                      style:
                          const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                    ),

                    //  subtitle: Text(subtitles[index]),
                    leading: ImageLead[index],
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                    iconColor: theme_color_df));
          }));
}

// ส่วนของข้อมูลที่เกี่ยวกับการตั้งค่า
Container configSetUpenduser() {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  return Container(
      child: ListView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // <-- this will disable scroll
          shrinkWrap: true,
          itemCount: titlesSetup.length,
          itemBuilder: (context, index) {
            return Card(
                color: Colors.white70,
                child: ListTile(
                    tileColor: Colors.white70,
                    onTap: () async {
                      if (index == 0) {
                        final SharedPreferences prefs = await pref;
                        var lang = prefs.getString("localeKey");
                        Get.toNamed('/change_languages', parameters: {
                          "lang": lang.toString()
                        }); //กำหนด Route ไปที่ /change_languages
                      } else if (index == 1) {}
                    },
                    title: Text(
                      titlesSetup[index],
                      style:
                          const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                    ),

                    //  subtitle: Text(subtitles[index]),
                    leading: ImageMslSetUp[index],
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                    iconColor: theme_color_df));
          }));
}

// ส่วนของข้อมูลที่เกี่ยวกับการตั้งค่า
Container configSetUpmshelp() {
  return Container(
      child: ListView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // <-- this will disable scroll
          shrinkWrap: true,
          itemCount: titlesHelp.length,
          itemBuilder: (context, index) {
            return Card(
                color: Colors.white,
                child: ListTile(
                    tileColor: Colors.white,
                    onTap: () {
                      // Scaffold.of(context).showSnackBar(SnackBar(
                      //   content: Text(titles[index] + ' pressed!'),
                      // ));
                      if (index == 0) {
                        var url = "${baseurl_yclub}yclub/member/help/help.php";
                        Get.to(() => WebViewFullScreen(mparamurl: url));
                      } else if (index == 1) {
                        Get.toNamed('/helpermsl');
                      }
                    },
                    title: Text(
                      titlesHelp[index],
                      style:
                          const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                    ),

                    //  subtitle: Text(subtitles[index]),
                    leading: ImageMslhelp[index],
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                    iconColor: theme_color_df));
          }));
}

// ส่วนของข้อมูลที่เกี่ยวกับการตั้งค่า
Container configSetUpEnduserhelp() {
  return Container(
      child: ListView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // <-- this will disable scroll
          shrinkWrap: true,
          itemCount: titlesHelpenduser.length,
          itemBuilder: (context, index) {
            return Card(
                color: Colors.white70,
                child: ListTile(
                    tileColor: Colors.white70,
                    onTap: () {
                      // Scaffold.of(context).showSnackBar(SnackBar(
                      //   content:
                      //       Text(titles[index] + ' pressed!'),
                      // ));
                    },
                    title: Text(
                      titlesHelpenduser[index],
                      style:
                          const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                    ),

                    //  subtitle: Text(subtitles[index]),
                    leading: ImageMslhelp[index],
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                    iconColor: theme_color_df));
          }));
}

class ConfigSetUpBaner extends StatefulWidget {
  const ConfigSetUpBaner({super.key});

  @override
  State<ConfigSetUpBaner> createState() => _ConfigSetUpBanerState();
}

class _ConfigSetUpBanerState extends State<ConfigSetUpBaner> {
  SetData data = SetData();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getspecialproject(),
      builder:
          (BuildContext context, AsyncSnapshot<Menuspecialproject?> snapshot) {
        if (snapshot.hasData) {
          var mparmMenu = snapshot.data;
          var mMenuProjet = mparmMenu!.project.length;
          // print(mparmMenu!.project.length);
          if (mMenuProjet > 0) {
            return Column(
              children: [
                setprofilerheader('โครงการพิเศษของคุณ'),
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CarouselSlider.builder(
                          autoSliderTransitionTime:
                              const Duration(milliseconds: 500),
                          unlimitedMode: true,
                          slideBuilder: (index) {
                            return InkWell(
                              onTap: () async {
                                var mRepSeq = await data.repSeq;
                                var mRepCode = await data.repCode;
                                var mPgmCode = mparmMenu.project[index].pgmCode;
                                var mNameProject =
                                    mparmMenu.project[index].nameProject;
                                var palamCode =
                                    "&RepCode=$mRepCode&repseq=$mRepSeq&progarm_code=$mPgmCode&name_SAV_PROJECT=$mNameProject&channel=YUPIN";
                                var palamUrl =
                                    mparmMenu.project[index].urlProject +
                                        palamCode;

                                Get.to(() => WebViewFullScreen(
                                    mparamurl:
                                        Uri.encodeFull(palamUrl.toString())));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: mparmMenu.project[index].imageApp,
                                    fit: BoxFit.fill,
                                    height: double.infinity,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            );
                          },
                          slideTransform: const DefaultTransform(),
                          slideIndicator: CircularSlideIndicator(
                              padding: const EdgeInsets.only(bottom: 10),
                              currentIndicatorColor: theme_color_df,
                              indicatorBackgroundColor: Colors.grey),
                          itemCount: mparmMenu.project.length,
                          initialPage: 0,
                          enableAutoSlider: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox(
              child: Center(),
            );
          }
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Shimmer.fromColors(
                highlightColor: kBackgroundColor,
                baseColor: const Color(0xFFE0E0E0),
                child: Container(
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
