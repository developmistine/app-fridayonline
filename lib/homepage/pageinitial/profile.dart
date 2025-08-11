// import 'package:fridayonline/analytics/analytics_engine.dart';
import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/controller/pro_filecontroller.dart';
import 'package:fridayonline/enduser/controller/enduser.home.ctr.dart';
import 'package:fridayonline/enduser/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/enduser/enduser.main.dart';
import 'package:fridayonline/enduser/models/authen/b2cregis.model.dart';
import 'package:fridayonline/enduser/services/authen/b2cauthen.service.dart';
import 'package:fridayonline/homepage/login/widgetconfigmslprofilerdetail.dart';
import 'package:fridayonline/homepage/login/widgetmslinfromation.dart';
import 'package:fridayonline/homepage/login/widgetsetprofilerheader.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/widget/cartbutton.dart';

import 'package:fridayonline/homepage/widget/widgetsetline.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/address/addresssearch.dart';
import 'package:fridayonline/service/profileuser/log_logout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../controller/home/home_controller.dart';
import '../../controller/update_app_controller.dart';
import '../../service/check_version/check_version_service.dart';
import '../../service/languages/multi_languages.dart';
import '../home/home_popup.dart';
import '../home/home_special_promotion_bwpoint.dart';
import '../splashscreen.dart';
import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final value = NumberFormat("#,##0", "en_US");
  UpdateAppController update = Get.put(UpdateAppController());
  PopUpStatusController popup = Get.put(PopUpStatusController());
  SetData data = SetData();
  var loginStatus;
  var Istype;
  getPopupTranfer() async {
    loginStatus = await data.loginStatus;
    Istype = await data.repType;
    var tranferDist = await call_check_transfer_dist();
    // print(' type user page home $Istype');
    Get.find<PopUpStatusController>().changeStatusViewPopupTranfer(true);
    if (tranferDist!.flagTransfer.toLowerCase() == 'y' &&
        (loginStatus == "1") &&
        Istype == '2' &&
        (popup.isViewPopupTranfer.value)) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) {
          return;
        } else {
          // setState(() {});
          showpopUptranfer(context, tranferDist);
        }
      });
    }
  }

  checkShowPopUp() async {
    DateTime now = DateTime.now();
    String date = '${now.year}-${now.month}-${now.day}';
    final SharedPreferences prefs = await _prefs;
    String showPopupStatus = prefs.getString("ShowPopupStatus") ?? "";
    if (update.statusUpdate != true) {
      if (showPopupStatus != date) {
        if (popup.isViewPopup != true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showPopUp(context).then((value) {
              if (value == null) {
                getPopupTranfer();
              }
            });
          });
        }
      } else {
        getPopupTranfer();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkShowPopUp();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ProfileController>(builder: (data) {
      if (!data.isDataLoading.value) {
        if (data.profile!.mslInfo.repCode.isNotEmpty &&
            data.profile!.mslInfo.repName.isNotEmpty) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                leadingWidth: 0,
                systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (data.profile!.mslInfo.fairActive) buttonSwithB2C(data),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CartIconButton(
                        icon: Image.asset(
                          'assets/images/icon/cart-grey.png',
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
              ),
              body: WillPopScope(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        title: const SizedBox(
                          width: 250,
                          child: Center(
                            child: Text(
                              'คุณต้องการออกจากแอปฯ หรือไม่',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
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
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  // ส่วนของหน้าจอที่ทำการ Design ออกมาทั้งหมด
                  children: [
                    // ออกแบบในส่วนของข้อมูลการสั่งซื้อว่าต้องสั่งถึงรอบไหน
                    Container(
                      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                      // height: 150, // ความสูงของกล่อง
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: theme_color_df),
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(12), //border corner radius
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            offset: const Offset(0, 3),
                            blurRadius: 5.0,
                            // changes position of shadow
                            //first paramerter of offset is left-right
                            //second parameter is top to down
                          ),
                          //you can set more BoxShadow() here
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 14,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '${MultiLanguages.of(context)!.translate('me_time_to_orders')} ${data.profile!.mslInfo.campaignText}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'notoreg',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      '${MultiLanguages.of(context)!.translate('me_dueDate')} : ${data.profile!.mslInfo.billDate}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'notoreg',
                                          color: theme_color_df,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (data.profile!.mslInfo.numDaysLeft > 3)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 4.0),
                              child: Container(
                                alignment: Alignment.center,
                                //  margin: EdgeInsets.all(5),
                                height: 70, // ความสูงของกล่อง
                                width: 70,
                                decoration: BoxDecoration(
                                  color: theme_color_df,
                                  borderRadius: BorderRadius.circular(
                                      10), //border corner radius
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.1), //color of shadow
                                      spreadRadius: 1, //spread radius
                                      blurRadius: 7, // blur radius
                                      offset: const Offset(
                                          0, 2), // changes position of shadow
                                      //first paramerter of offset is left-right
                                      //second parameter is top to down
                                    ),
                                    //you can set more BoxShadow() here
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      MultiLanguages.of(context)!
                                          .translate('me_countDay'),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'notoreg',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${data.profile!.mslInfo.numDaysLeft} ${MultiLanguages.of(context)!.translate('me_day')}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'notoreg',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              child: Container(
                                alignment: Alignment.center,
                                //  margin: EdgeInsets.all(5),
                                height: 80, // ความสูงของกล่อง
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(
                                      10), //border corner radius
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.1), //color of shadow
                                      spreadRadius: 1, //spread radius
                                      blurRadius: 7, // blur radius
                                      offset: const Offset(
                                          0, 2), // changes position of shadow
                                      //first paramerter of offset is left-right
                                      //second parameter is top to down
                                    ),
                                    //you can set more BoxShadow() here
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      MultiLanguages.of(context)!
                                          .translate('me_countDay'),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'notoreg',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${data.profile!.mslInfo.numDaysLeft} ${MultiLanguages.of(context)!.translate('me_day')}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'notoreg',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.profile!.mslInfo.repName,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: 'notoreg',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "รหัสสมาชิก  ${data.profile!.mslInfo.repCode.replaceAllMapped(RegExp(r'(\d{4})(\d{5})(\d+)'), (Match m) => "${m[1]}-${m[2]}-${m[3]}")}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'notoreg',
                                          color: theme_color_back1,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "โทรศัพท์  ${data.profile!.mslInfo.telnumber.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'), (Match m) => "${m[1]}-${m[2]}-${m[3]}")}",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'notoreg',
                                          color: theme_color_back1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Expanded(
                                //       child: Text(
                                //         "โทรศัพท์  ${data.profile!.mslInfo.telnumber.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'), (Match m) => "${m[1]}-${m[2]}-${m[3]}")}",
                                //         style: TextStyle(
                                //           fontSize: 14,
                                //           fontFamily: 'notoreg',
                                //           color: theme_color_back1,
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                            const SizedBox(
                              height: 2.0,
                            ),
                            // Row(
                            //   children: [
                            //     SizedBox(
                            //       width: 80,
                            //       child: Text(
                            //         "โทรศัพท์",
                            //         style: TextStyle(
                            //           fontSize: 14,
                            //           fontFamily: 'notoreg',
                            //           color: theme_color_back1,
                            //         ),
                            //       ),
                            //     ),
                            //     Text(
                            //       ' : ${data.profile!.mslInfo.telnumber.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'), (Match m) => "${m[1]}-${m[2]}-${m[3]}")}',
                            //       style: TextStyle(
                            //         fontSize: 14,
                            //         fontFamily: 'notoreg',
                            //         color: theme_color_back1,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // รายละเอียดคะแนนสะสม
                    if (data.profile!.mslInfo.bprBal.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() =>
                                          const SpecialPromotionBwpoint(
                                              type: 'profile'));
                                    },
                                    child: Text(
                                      MultiLanguages.of(context)!
                                          .translate('point_titleView'),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'notoreg',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => const SpecialPromotionBwpoint(
                                        type: 'profile'));
                                  },
                                  child: Text(
                                    'เกี่ยวกับคะแนน',
                                    style: TextStyle(
                                        color: theme_color_df,
                                        fontWeight: FontWeight.bold),
                                  ).paddingOnly(right: 8),
                                )
                                // if (data.profile!.mslInfo.pointShow == true)
                                //   TextButton(
                                //     style: TextButton.styleFrom(
                                //       textStyle: const TextStyle(
                                //         fontSize: 14,
                                //       ),
                                //     ),
                                //     onPressed: () {
                                //       Get.to(() =>
                                //           const SpecialPromotionBwpoint(
                                //               type: 'profile'));
                                //     },
                                //     child: Text(
                                //       'ไปยังฟรายเดย์ออนไลน์',
                                //       style: TextStyle(
                                //           color: theme_color_df,
                                //           fontFamily: 'notoreg',
                                //           fontSize: 16,
                                //           fontWeight: FontWeight.bold
                                //           // fontWeight: FontWeight.bold,
                                //           // decoration: TextDecoration.underline,
                                //           ),
                                //     ),
                                //   )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() =>
                                          const SpecialPromotionBwpoint(
                                              type: 'profile'));
                                    },
                                    child: Text(
                                      value.format(int.parse(
                                          data.profile!.mslInfo.bprBal)),
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontFamily: 'notoreg',
                                          color: theme_color_df,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                // if (data.profile!.mslInfo.pointShow == true)
                              ],
                            ),
                            controlline(),
                          ],
                        ),
                      )
                    else
                      controlline(),
                    // รายละเอียด Function งานต่างๆที่ทำการ Set เป็น Function การทำงาน
                    //ตรวจสอบข้อมูล //ยังไม่แปล
                    // setprofilerheader(''),

                    // รายละเอียดข้อมูลเกี่ยวกับสมาชิก
                    eventmsl_information(data.profile!.mslInfo.arBal,
                        context), // เป็น  Event ต่างๆกรณีที่คลิกเข้าไปดูข้อมูล

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: controlline(),
                    ),

                    //โครงการพิเศษของคุณ
                    const ConfigSetUpBaner(),

                    // เกี่ยวกับสมาชิก
                    setprofilerheader(
                        MultiLanguages.of(context)!.translate('me_about')),
                    configmslprofilerdetail(data.profile!.mslInfo.activityShow),

                    // ตั้งค่า
                    setprofilerheader(
                        MultiLanguages.of(context)!.translate('me_settings')),
                    configSetUpmsl(),

                    // ช่วยเหลือ
                    setprofilerheader(
                        MultiLanguages.of(context)!.translate('me_help')),
                    configSetUpmshelp(),
                    appVersion(),

                    const SizedBox(
                      height: 25.0,
                    ),

                    // Logout
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
                                    child: const Text('ตกลง.'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: exitApp(),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // // ? test new enduser
                    // ElevatedButton(
                    //     onPressed: () {
                    //       final EndUserHomeCtr endUserHomeCtr = Get.find();
                    //       endUserHomeCtr.endUserGetAllHomePage();
                    //       Get.to(() => const EndUserHomePage());
                    //     },
                    //     child: const Text('test'))
                  ],
                ),
              ),
            ),
          );
        } else {
          //แสดงข้อความว่า ไม่พบข้อมูล
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo/logofriday.png',
                width: 50,
                height: 50,
              ),
              Text(MultiLanguages.of(context)!.translate('alert_no_datas')),
            ],
          ));
        }
      } else {
        return Center(child: theme_loading_df);
      }
    });
  }

  Widget buttonSwithB2C(ProfileController data) {
    return InkWell(
      onTap: () async {
        var isSwitch = await showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                elevation: 0,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'แจ้งเตือน',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: theme_color_df,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'notoreg'),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "หากเข้าสู่\nฟรายเดย์แฟร์",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'notoreg',
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "ท่านจะไม่สามารถใช้\nคะแนนสะสม หรือราคา\nพิเศษสำหรับสมาชิกได้",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'notoreg',
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Get.back();
                              },
                              child: const Text(
                                'ยกเลิก',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                              child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Get.back(result: 1);
                            },
                            child: Text(
                              'ยืนยัน',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: theme_red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ))
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        );
        if (isSwitch == null) return;
        final EndUserSignInCtr endUserSignInCtr = Get.put(EndUserSignInCtr());

        final user = data.profile!.mslInfo;

        final SharedPreferences prefs = await _prefs;
        String deepLinkSource = prefs.getString("deepLinkSource") ?? '';
        String deepLinkId = prefs.getString("deepLinkId") ?? '';
        SetData prefer = SetData();
        var payload = B2CRegister(
          registerId: user.repSeq,
          registerType: "msl",
          moblie: user.telnumber,
          email: '',
          prefix: '',
          firstName: '',
          lastName: '',
          displayName: user.repName,
          image: "",
          referringBrowser: deepLinkSource,
          referringId: deepLinkId,
          gender: '',
          birthDate: '',
          address: Address(
              firstName: '',
              lastName: '',
              address1: '',
              address2: '',
              tombonId: 0,
              amphurId: 0,
              provinceId: 0,
              postCode: '',
              mobile: ''),
          tokenApp: await prefer.tokenId,
          device: await prefer.device,
          sessionId: await prefer.sessionId,
          identityId: await prefer.deviceId,
        );
        var res = await b2cRegisterService(payload);
        if (res!.code == "100") {
          prefs.remove("deepLinkSource");
          prefs.remove("deepLinkId");
          await prefs.setString("accessToken", res.data.accessToken);
          await prefs.setString("refreshToken", res.data.refreshToken);
          await endUserSignInCtr.settingPreferencePush(
              '1', '', '5', res.data.custId);
          Get.find<EndUserHomeCtr>().endUserGetAllHomePage();
          // if (mounted) {
          Get.offAll(() => EndUserHome(),
              routeName: "/EndUserHome", arguments: 'switch_account');
          // }
        } else {
          if (!Get.isSnackbarOpen) {
            Get.snackbar('', '',
                titleText: const Text('แจ้งเตือน',
                    style: TextStyle(color: Colors.white)),
                messageText: Text(res.message,
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.red.withOpacity(0.8),
                colorText: Colors.white,
                duration: const Duration(seconds: 2));
          }
          return;
        }
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue,
              theme_color_df.withOpacity(1),
              theme_color_df.withOpacity(1),
              theme_color_df.withOpacity(0.8),
            ]),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: const Row(
          children: [
            Icon(
              Icons.shopping_bag,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              'ช้อปฟรายเดย์ออนไลน์',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'notoreg',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.8),
            ),
            SizedBox(
              width: 2.0,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.0,
            ),
          ],
        ),
      ),
    );
  }
}
