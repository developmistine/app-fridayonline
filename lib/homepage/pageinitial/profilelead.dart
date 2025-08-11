import 'package:fridayonline/homepage/login/widgetconfigleadprofilerdetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/cart/cart_controller.dart';
import '../../controller/cart/dropship_controller.dart';
import '../../controller/lead/lead_controller.dart';
import '../../service/languages/multi_languages.dart';
import '../globals_variable.dart';
import '../theme/theme_color.dart';

class ProfileLead extends StatefulWidget {
  const ProfileLead({super.key});

  @override
  State<ProfileLead> createState() => _ProfileLeadState();
}

class _ProfileLeadState extends State<ProfileLead> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Color? colors;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileLeadController>(builder: (data) {
      if (!data.isDataLoading.value) {
        if (data.leadStatus!.leadStatus == 'waiting') {
          colors = const Color(0XFFFCB635);
        } else if (data.leadStatus!.leadStatus == 'cancel') {
          colors = const Color(0XFFFF0000);
        } else {
          colors = const Color(0XFFFCB635);
        }
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
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: colors!, width: 4),
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(10), //border corner radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          if (data.leadStatus!.leadStatus == 'waiting')
                            Image.asset(
                              'assets/images/lead/waiting.png',
                              height: 100,
                            ),
                          if (data.leadStatus!.leadStatus == 'cancel')
                            Image.asset(
                              'assets/images/lead/cancel.png',
                              height: 100,
                            ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                                textAlign: TextAlign.center,
                                'สถานะการสมัครสมาชิก'),
                          ),
                          if (data.leadStatus!.leadStatus == 'waiting')
                            const Text(
                              textAlign: TextAlign.center,
                              'กำลังตรวจสอบข้อมูล',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          if (data.leadStatus!.leadStatus == 'cancel')
                            const Text(
                              textAlign: TextAlign.center,
                              'การสมัครไม่สำเร็จ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          if (data.leadStatus!.leadStatus == 'cancel')
                            const Text(
                              textAlign: TextAlign.center,
                              'กรุณาติดต่อผู้จัดการเขต\nหรือ Call Center 02-118-5111',
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                configSetUpmsl(),
                const SizedBox(
                  height: 25.0,
                ),
                GestureDetector(
                  onDoubleTap: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                              textScaler: const TextScaler.linear(1.0)),
                          child: CupertinoAlertDialog(
                            title: const Text(
                              'คุณต้องการลบข้อมูลหรือไม่ ?',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            content: const SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('กดตกลงเพื่อลบข้อมูลทุกอย่าง'),
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
                                  final SharedPreferences prefs = await _prefs;
                                  prefs.remove("login");
                                  prefs.remove("RepSeq");
                                  prefs.remove("RepCode");
                                  prefs.remove("RepName");
                                  prefs.remove("UserType");
                                  prefs.remove("localeKey");
                                  prefs.remove("StatusLoadApp");
                                  Get.find<FetchCartItemsController>()
                                      .fetch_cart_items();
                                  Get.find<FetchCartDropshipController>()
                                      .fetchCartDropship();

                                  Get.toNamed('/');
                                },
                                child: const Text('ตกลง'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                          "${MultiLanguages.of(context)!.translate('me_version')}: $versionApp",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'notoreg',
                            color: theme_color_df,
                          ))),
                ),
              ],
            ),
          ),
        );
      } else {
        return const Center();
      }
    });
  }
}
