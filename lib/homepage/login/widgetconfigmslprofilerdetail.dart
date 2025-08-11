// import 'dart:developer';

import 'package:fridayonline/analytics/analytics_engine.dart';
import 'package:fridayonline/controller/address/address_controller.dart';
import 'package:fridayonline/homepage/globals_variable.dart';
import 'package:fridayonline/homepage/login/widgetsetprofilerheader.dart';
import 'package:fridayonline/homepage/review/review.dart';
// import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:fridayonline/homepage/theme/themeimageprofiler.dart';
// import 'package:fridayonline/mslinfo/sharecatalog.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
// import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
// import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/badger/badger_controller.dart';
import '../../controller/pro_filecontroller.dart';
import '../../model/badger/badger_profile_response.dart';
import '../../model/set_data/set_data.dart';
import '../../service/badger/badger.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/pathapi.dart';
// import '../../service/profileuser/getprofile.dart';
// import '../../service/profileuser/profileuser_menu_special_project.dart';
import '../theme/constants.dart';
import '../theme/theme_color.dart';
import '../webview/webview_full_screen.dart';

final titles = [
  "me_catalog_customer",
  "me_shipping_address",
  //"yupin_market",
  "direct_million"
];

final titlesenduser = ["title_order_info"];

final titlesSetup = ["me_language", "me_setting"];

final titlesHelp = ["me_instruction", "customer_help"];
final versionsApp = ["version"];
final exitApps = ["exitApp"];

final titlesHelpenduser = ["me_instruction"];

Future<void> _trackGA(String name) async {
  SetData data = SetData();
  AnalyticsEngine.sendAnalyticsEvent(
      name, await data.repCode, await data.repSeq, await data.repType);
}

Future<void> _trackGAendUser(String name) async {
  SetData data = SetData();
  AnalyticsEngine.sendAnalyticsEventEndUser(name, await data.enduserId,
      await data.repCode, await data.repSeq, await data.repType);
}

configmslprofilerdetail(bool show) {
  BadgerProfileController badgerProfile = Get.put(BadgerProfileController());
  return ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // <-- this will disable scroll
      shrinkWrap: true,
      itemCount: titles.length,
      itemBuilder: (context, index) {
        if (index == 2 && show == false) {
          return const Center();
        } else {
          return Card(
              margin: const EdgeInsets.all(0.5),
              color: Colors.white,
              child: ListTile(
                  tileColor: Colors.white,
                  onTap: () async {
                    // log(index.toString());
                    // Scaffold.of(context).showSnackBar(SnackBar(
                    //   content:
                    //       Text(titles[index] + ' pressed!'),
                    // ));
                    if (index == 0) {
                      _trackGA('click_share_catalogue_menu');
                      Get.toNamed('/sharecatalog');
                      BadgerProfilResppnse response =
                          await call_badger_update_profile("CustomerList");
                      if (response.value.success == "1") {
                        Get.find<BadgerController>().get_badger();
                        Get.find<BadgerProfileController>()
                            .get_badger_profile();
                      }
                    } else if (index == 1) {
                      _trackGA('click_change_address_menu');
                      Get.find<AddressController>().getAddressData();
                      Get.toNamed('/editaddress');
                      // } else if (index == 2) {
                      // Get.find<BadgerController>().getBadgerMarket();
                      // Get.toNamed('/market',
                      //     parameters: {'type': 'profile'});
                    } else if (index == 2) {
                      Get.toNamed('/saledirect');
                    }
                  },
                  title: Text(
                    MultiLanguages.of(context)!.translate(titles[index]),
                    style: const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                  ),

                  //  subtitle: Text(subtitles[index]),
                  leading: ImageMslinfor[index],
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (index == 0)
                        Obx(() {
                          if (!badgerProfile.isDataLoading.value) {
                            if (int.parse(badgerProfile
                                    .badgerProfile!
                                    .configFile
                                    .badger
                                    .customerList
                                    .newMessage) >
                                0) {
                              return badges.Badge(
                                  badgeStyle: const badges.BadgeStyle(
                                    badgeColor: Colors.red,
                                  ),
                                  badgeContent: Text(
                                      badgerProfile.badgerProfile!.configFile
                                          .badger.customerList.newMessage,
                                      style: const TextStyle(
                                          inherit: false,
                                          color: Colors.white,
                                          fontSize: 15)));
                            } else {
                              return const Center();
                            }
                          } else {
                            return const Center();
                          }
                        }),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    ],
                  ),
                  iconColor: theme_color_df));
        }
      });
}

// ลูกค้าสมาชิก
configenduserprofilerdetail() {
  return ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // <-- this will disable scroll
      shrinkWrap: true,
      itemCount: titlesenduser.length,
      itemBuilder: (context, index) {
        return Card(
            margin: const EdgeInsets.all(0.5),
            color: Colors.white70,
            child: ListTile(
                tileColor: Colors.white70,
                onTap: () {
                  if (index == 0) {
                    // GA
                    _trackGAendUser('click_enduser_order');

                    Get.toNamed('/enduser_check_information',
                        parameters: {'select': '1'});
                  }
                },
                title: Text(
                  MultiLanguages.of(context)!.translate(titlesenduser[index]),
                  style: const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                ),

                //  subtitle: Text(subtitles[index]),
                leading: Imageenduserorder[index],
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                iconColor: theme_color_df));
      });
}

// ส่วนรีวิว
configenduserprofilerreview() {
  return ListView.builder(
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
                    _trackGAendUser('click_enduser_review');
                    Get.to(() => const Review(
                        tabs: 0)); //กำหนด Route ไปที่ /check_information_order
                  }
                },
                title: const Text(
                  "รีวิวของฉัน",
                  style: TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                ),

                //  subtitle: Text(subtitles[index]),
                leading: Image.asset('assets/images/profileimg/review.png',
                    width: 30, height: 30),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                iconColor: theme_color_df));
      });
}

// ส่วนของข้อมูลที่เกี่ยวกับการตั้งค่า
configSetUpmsl() {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  return ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // <-- this will disable scroll
      shrinkWrap: true,
      itemCount: titlesSetup.length,
      itemBuilder: (context, index) {
        return Card(
            margin: const EdgeInsets.all(0.5),
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                onTap: () async {
                  if (index == 0) {
                    _trackGA('click_language_menu');
                    final SharedPreferences prefs = await pref;
                    var lang = prefs.getString("localeKey");
                    Get.toNamed('/change_languages', parameters: {
                      "lang": lang.toString()
                    }); //กำหนด Route ไปที่ /change_languages
                  } else if (index == 1) {
                    _trackGA('click_about_friday_menu');
                    final SharedPreferences prefs = await pref;
                    var lang = prefs.getString("localeKey");
                    Get.toNamed('/aboutfriday',
                        parameters: {"lang": lang.toString()});
                  }
                },
                title: Text(
                  MultiLanguages.of(context)!.translate(titlesSetup[index]),
                  style: const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                ),

                //  subtitle: Text(subtitles[index]),
                leading: ImageMslSetUp[index],
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                iconColor: theme_color_df));
      });
}

// ส่วนของข้อมูลที่เกี่ยวกับการตั้งค่า
configSetUpenduser() {
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  return ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // <-- this will disable scroll
      shrinkWrap: true,
      itemCount: titlesSetup.length,
      itemBuilder: (context, index) {
        return Card(
            margin: const EdgeInsets.all(0.5),
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
                  } else if (index == 1) {
                    _trackGAendUser('click_enduser_about');
                    final SharedPreferences prefs = await pref;
                    var lang = prefs.getString("localeKey");
                    Get.toNamed('/aboutfriday',
                        parameters: {"lang": lang.toString()});
                  }
                },
                title: Text(
                  MultiLanguages.of(context)!.translate(titlesSetup[index]),
                  style: const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                ),

                //  subtitle: Text(subtitles[index]),
                leading: ImageMslSetUp[index],
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                iconColor: theme_color_df));
      });
}

// ส่วนของข้อมูลที่เกี่ยวกับการตั้งค่า
configSetUpmshelp() {
  return ListView.builder(
    physics:
        const NeverScrollableScrollPhysics(), // <-- this will disable scroll
    shrinkWrap: true,
    itemCount: titlesHelp.length,
    itemBuilder: (context, index) {
      return Card(
          margin: const EdgeInsets.all(0.5),
          color: Colors.white,
          child: ListTile(
              tileColor: Colors.white,
              onTap: () {
                // Scaffold.of(context).showSnackBar(SnackBar(
                //   content: Text(titles[index] + ' pressed!'),
                // ));
                if (index == 0) {
                  _trackGA('click_member_manual_menu');
                  var url = "${baseurl_yclub}yclub/member/help/help.php";
                  Get.to(() => WebViewFullScreen(mparamurl: url));
                } else if (index == 1) {
                  _trackGA('click_member_helper_menu');
                  Get.toNamed('/helpermsl');
                }
              },
              title: Text(
                MultiLanguages.of(context)!.translate(titlesHelp[index]),
                style: const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
              ),

              //  subtitle: Text(subtitles[index]),
              leading: ImageMslhelp[index],
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              iconColor: theme_color_df));
    },
  );
}

appVersion() {
  // ignore: avoid_unnecessary_containers
  return Container(
      child: ListView.builder(
          physics:
              const NeverScrollableScrollPhysics(), // <-- this will disable scroll
          shrinkWrap: true,
          itemCount: versionsApp.length,
          itemBuilder: (context, index) {
            return Card(
                margin: const EdgeInsets.all(0.5),
                color: Colors.white,
                child: ListTile(
                    tileColor: Colors.white,
                    title: const Text(
                      "เวอร์ชัน",
                      style: TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                    ),

                    //  subtitle: Text(subtitles[index]),
                    leading: const Icon(
                      Icons.info_outline,
                      size: 32,
                    ),
                    trailing: Text("$versionApp  ($buildNumbers)"),
                    iconColor: theme_color_df));
          }));
}

Container exitApp() {
  // ignore: avoid_unnecessary_containers
  return Container(
    child: ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // <-- this will disable scroll
      shrinkWrap: true,
      itemCount: exitApps.length,
      itemBuilder: (context, index) {
        return const Card(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "ออกจากระบบ",
                  style: TextStyle(fontSize: 14, fontFamily: 'notoreg'),
                ),

                //  subtitle: Text(subtitles[index]),
                leading: Icon(
                  Icons.exit_to_app_rounded,
                  size: 30,
                ),
                iconColor: Colors.black54));
      },
    ),
  );
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
                      _trackGAendUser('click_enduser_help');
                      var url =
                          "${baseurl_yclub}yclub/policyandcondition/howto_regisnew.php";
                      Get.to(() => WebViewFullScreen(mparamurl: url));
                    },
                    title: Text(
                      MultiLanguages.of(context)!
                          .translate(titlesHelpenduser[index]),
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
    double width = MediaQuery.of(context).size.width;
    return GetX<ProfileSpecialProjectController>(builder: (dataContent) {
      if (!dataContent.isDataLoading.value) {
        if (dataContent.specialproject!.project.isNotEmpty) {
          return Column(
            children: [
              setprofilerheader(
                  MultiLanguages.of(context)!.translate('me_projectx')),
              SizedBox(
                width: double.infinity,
                height:
                    width >= 768 ? MediaQuery.of(context).size.height / 3 : 200,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CarouselSlider.builder(
                        autoSliderTransitionTime:
                            const Duration(milliseconds: 500),
                        unlimitedMode:
                            dataContent.specialproject!.project.length > 1
                                ? true
                                : false,
                        slideBuilder: (index) {
                          return InkWell(
                            onTap: () async {
                              var mRepSeq = await data.repSeq;
                              var mRepCode = await data.repCode;
                              var mPgmCode = dataContent
                                  .specialproject!.project[index].pgmCode;
                              var mNameProject = dataContent
                                  .specialproject!.project[index].nameProject;
                              var palamCode =
                                  "&RepCode=$mRepCode&repseq=$mRepSeq&progarm_code=$mPgmCode&name_SAV_PROJECT=$mNameProject&channel=YUPIN";
                              var palamUrl = dataContent.specialproject!
                                      .project[index].urlProject +
                                  palamCode;

                              _trackGA('click_member_profile_project', mPgmCode,
                                  mNameProject);

                              Get.to(() => WebViewFullScreen(
                                  mparamurl:
                                      Uri.encodeFull(palamUrl.toString())));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: dataContent
                                      .specialproject!.project[index].imageApp,
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
                            indicatorRadius: 3,
                            itemSpacing: 10,
                            padding: const EdgeInsets.only(bottom: 10),
                            currentIndicatorColor: theme_color_df,
                            indicatorBackgroundColor: Colors.grey),
                        itemCount: dataContent.specialproject!.project.length,
                        initialPage: 0,
                        enableAutoSlider:
                            dataContent.specialproject!.project.length > 1
                                ? true
                                : false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      } else {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: width >= 768 ? MediaQuery.of(context).size.height / 3 : 200,
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
      }
    });
  }

  Future<void> _trackGA(String name, String pCode, String pName) async {
    AnalyticsEngine.sendAnalyticsMemberProject(name, pCode, pName,
        await data.repCode, await data.repSeq, await data.repType);
  }
}
