import 'package:fridayonline/analytics/analytics_engine.dart';
import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/controller/pro_filecontroller.dart';
import 'package:fridayonline/enduser/services/authen/b2cauthen.service.dart';
import 'package:fridayonline/homepage/login/widgetconfigmslprofilerdetail.dart';
import 'package:fridayonline/homepage/login/widgetsetprofilerheader.dart';
import 'package:fridayonline/homepage/splashscreen.dart';
import 'package:fridayonline/homepage/widget/widgetsetline.dart';
import 'package:fridayonline/model/register/enduserinfo.dart';
import 'package:fridayonline/service/profileuser/getenduserinfoprofile.dart';
import 'package:fridayonline/service/profileuser/log_logout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/set_data/set_data.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/pathapi.dart';
// import '../globals_variable.dart';
import '../theme/theme_color.dart';
import '../webview/webview_full_screen.dart';

class ProfileEndUser extends StatefulWidget {
  const ProfileEndUser({super.key});

  @override
  State<ProfileEndUser> createState() => _ProfileEndUserState();
}

// ทำการ Get Data Enduser
class _ProfileEndUserState extends State<ProfileEndUser> {
// ส่วนที่ประกาศในการจัดเก็บข้อ๔
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SetData data = SetData();
// เป็นตัวที่ดำเนินการ
  String? EndUserID;
  String? RepSeq;

// ตัวแปลที่ประกาศในส่วนการจัดเก็บ
  String? lsUserID = '';
  String? lsUserName = '';
  String? lsEnduserTelNumber = '';
  String? lsStarStock = '0';
  String? lsStarVisual = '';
  String? lsStarRecive = '';
  String? lsMslrepseq = '';
  String? lsMslrepcode = '';
  String? lsMslname = '';
  String? lsMslTelNumber = '';
  String? lsDetailMessage1 = '';
  String? lsDetailMessage2 = '';
  String? lsUsertype = '';

  final value = NumberFormat("#,##0", "en_US");
  @override
  void initState() {
    super.initState();
    // ทำการ Get เอกา Data Preferences
    setState(() {
      // กรณีที่ Load
      GetDataEndUser();
    });
  }

  // ส่วนที่ Call API เพื่อที่จะทำการ Get Data ออกมา
  void GetDataEndUser() async {
    final SharedPreferences prefs = await _prefs;
    EndUserID = prefs.getString("EndUserID")!;
    RepSeq = prefs.getString("RepSeq")!;

    // log('=====> Data Log $EndUserID  $RepSeq');
    // กรณีที่ทำการ Get Data
    try {
      EndUserInfo UserInfo = await getProfileEnduser(EndUserID, RepSeq);
      // ทำการ Get Data
      setState(() {
        lsUserID = UserInfo.endUserInfo[0].userId;
        lsUserName = UserInfo.endUserInfo[0].userName;
        lsEnduserTelNumber =
            UserInfo.endUserInfo[0].infodetail[0].enduserTelNumber;
        lsStarStock = UserInfo.endUserInfo[0].infodetail[0].starStock;
        lsStarVisual = UserInfo.endUserInfo[0].infodetail[0].starVisual;
        lsStarRecive = UserInfo.endUserInfo[0].infodetail[0].starRecive;
        lsMslrepseq = UserInfo.endUserInfo[0].infodetail[0].mslrepseq;
        lsMslrepcode = UserInfo.endUserInfo[0].infodetail[0].mslrepcode;
        lsMslname = UserInfo.endUserInfo[0].infodetail[0].mslname;
        lsMslTelNumber = UserInfo.endUserInfo[0].infodetail[0].mslTelNumber;
        lsDetailMessage1 = UserInfo.endUserInfo[0].infodetail[0].detailMessage1;
        lsDetailMessage2 = UserInfo.endUserInfo[0].infodetail[0].detailMessage2;
        lsUsertype = UserInfo.endUserInfo[0].infodetail[0].usertype;
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          var shouldPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                actionsPadding: const EdgeInsets.only(
                    top: 10, bottom: 5, left: 5, right: 5),
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: const SizedBox(
                  width: 250,
                  child: Center(
                    child: Text(
                      'คุณต้องการออกจากแอปฯ หรือไม่',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text(
                          'ยกเลิก',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text(
                          'ออก',
                          style: TextStyle(
                              color: Color(0xFFFD7F6B),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
          return shouldPop!;
        },
        child: Scaffold(
          // เป็นส่วนที่ระบบออกแบบเพื่อที่จะทำการแสดงรายละเอียดของลูกค้า
          body: SingleChildScrollView(
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Text(
                            'คุณ $lsUserName',
                            style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'notoreg',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              MultiLanguages.of(context)!
                                  .translate('customer_code'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'notoreg',
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Text(
                              ': $lsUserID',
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'notoreg',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              MultiLanguages.of(context)!
                                  .translate('customer_tel'),
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'notoreg',
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Text(
                              ': $lsEnduserTelNumber'.replaceAllMapped(
                                  RegExp(r'(\d{3})(\d{3})(\d+)'),
                                  (Match m) => "${m[1]}-${m[2]}-${m[3]}"),
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'notoreg',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius:
                            BorderRadius.circular(10), //border corner radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Row(
                                children: [
                                  Text(
                                    MultiLanguages.of(context)!
                                        .translate('members_customer'),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'notoreg',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    MultiLanguages.of(context)!
                                        .translate('msl_name'),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'notoreg',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    ': $lsMslname ',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'notoreg',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    MultiLanguages.of(context)!
                                        .translate('login_tel_label'),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'notoreg',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    ': $lsMslTelNumber'.replaceAllMapped(
                                        RegExp(r'(\d{3})(\d{3})(\d+)'),
                                        (Match m) => "${m[1]}-${m[2]}-${m[3]}"),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'notoreg',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                MultiLanguages.of(context)!
                                    .translate('customer_reward'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'notoreg',
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () async {
                                  // print('ดูรายละเอียดเป็น สตาร์รีวอร์ด');
                                  var mRepcode = await data.repCode;
                                  var mRepSeq = await data.repSeq;
                                  var mEndUserID = await data.enduserId;
                                  var mRepType = await data.repType;
                                  var mpalam =
                                      "Repcode=$mRepcode&RepSeq=$mRepSeq&EndUserID=$mEndUserID&RepType=$mRepType";
                                  var murl =
                                      "$baseurl_web_view/starrewardsgetpiont?$mpalam";

                                  AnalyticsEngine.sendAnalyticsEvent(
                                      'click_enduser_start_reward',
                                      mRepcode,
                                      mRepSeq,
                                      mRepType);

                                  Get.to(
                                      () => WebViewFullScreen(mparamurl: murl));
                                },
                                child: Text(
                                  MultiLanguages.of(context)!
                                      .translate('customer_about_reward'),
                                  style: TextStyle(
                                    color: theme_color_df,
                                    fontFamily: 'notoreg',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                value.format(int.parse(lsStarStock!)),
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'notoreg',
                                    color: theme_color_df,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          controlline(),
                        ],
                      ),
                    ),
                    setProfileEnduserHeader(
                        MultiLanguages.of(context)!.translate('segment_order')),

                    configenduserprofilerdetail(),

                    // setProfileEnduserHeader('รีวิวของฉัน'),
                    configenduserprofilerreview(),
                    setProfileEnduserHeader(
                        MultiLanguages.of(context)!.translate('me_settings')),
                    configSetUpenduser(),
                    setProfileEnduserHeader(
                        MultiLanguages.of(context)!.translate('me_help')),
                    configSetUpEnduserhelp(),
                    appVersion(),
                    const SizedBox(
                      height: 25.0,
                    ),

                    GestureDetector(
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.0)),
                              child: CupertinoAlertDialog(
                                title: const Text(
                                  'คุณต้องการออกจากระบบ ?',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: const SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(''),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('ยกเลิก'),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () async {
                                      await logLogOut();
                                      Get.find<AppController>()
                                          .setCurrentNavInget(0);
                                      await b2cLogoutService();
                                      await _prefs.then(
                                          (SharedPreferences prefs) async {
                                        // 1. เก็บ sessionId ไว้ก่อน
                                        // String? sessionId =
                                        //     prefs.getString("sessionId");
                                        String? lastActive =
                                            prefs.getString('lastActiveTime');

                                        // 2. ลบทุก key ทีละตัว (ไม่ใช้ clear())
                                        final keys = prefs.getKeys();
                                        for (String key in keys) {
                                          // if (key != "sessionId") {
                                          await prefs.remove(key);
                                          // }
                                        }

                                        // 3. ถ้าอยากให้ชัวร์ set sessionId กลับอีกทีก็ได้ (option)
                                        // if (sessionId != null) {
                                        //   await prefs.setString(
                                        //       "sessionId", sessionId);
                                        // }
                                        if (lastActive != null) {
                                          await prefs.setString(
                                              'lastActiveTime', lastActive);
                                        }
                                      });

                                      Get.offAll(() => const SplashScreen());
                                    },
                                    child: const Text('ตกลง'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: exitApp(),
                      // child: Container(
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //         "${MultiLanguages.of(context)!.translate('me_version')}: $versionApp",
                      //         style: TextStyle(
                      //           fontSize: 15,
                      //           fontFamily: 'notoreg',
                      //           color: theme_color_df,
                      //         ))),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
