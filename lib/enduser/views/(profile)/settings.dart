import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/components/profile/menu.section.dart';
import 'package:fridayonline/enduser/controller/chat.ctr.dart';
import 'package:fridayonline/enduser/services/authen/b2cauthen.service.dart';
import 'package:fridayonline/enduser/widgets/dialog.confirm.dart';
import 'package:fridayonline/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Map<String, Object>> listMenu = [
    {
      "title": "ตั้งค่าบัญชี",
      "subtitle": [
        {
          "name": "บัญชี",
        },
        {
          "name": "ที่อยู่จัดส่ง",
        },
      ]
    },
    {
      "title": "เกี่ยวกับ",
      "subtitle": [
        {
          "name": "นโยบายความเป็นส่วนตัว",
        },
        {
          "name": "เวอร์ชั่น",
        },
        {
          "name": "คำขอลบบัญชี",
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.notoSansThaiLooped())),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  textStyle: GoogleFonts.notoSansThaiLooped())),
          textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
          appBar: appBarMasterEndUser('ตั้งค่าบัญชี'),
          backgroundColor: Colors.grey.shade100,
          body: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.zero,
              itemCount: listMenu.length,
              itemBuilder: (context, index) {
                var subMenu = listMenu[index]["subtitle"] as List;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        listMenu[index]['title'].toString(),
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.zero,
                        itemCount: subMenu.length,
                        itemBuilder: (context, subIndex) {
                          return InkWell(
                            onTap: () {
                              handleMenuTap(subMenu[subIndex]['name']);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: subIndex == subMenu.length - 1
                                        ? null
                                        : Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 0.4))),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        subMenu[subIndex]['name']!.toString(),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.grey.shade500,
                                        size: 14,
                                      )
                                    ],
                                  ),
                                )),
                          );
                        }),
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  onPressed: () {
                    var socketCtr = Get.find<WebSocketController>();
                    dialogConfirm('คุณต้องการออกจากระบบ?', 'ปิด', 'ใช่')
                        .then((res) async {
                      if (res == 1) {
                        await b2cLogoutService();
                        await _prefs.then((SharedPreferences prefs) async {
                          // 1. เก็บ sessionId ไว้ก่อน
                          String? sessionId = prefs.getString("sessionId");
                          String? lastActive =
                              prefs.getString('lastActiveTime');
                          String? deviceId = prefs.getString('deviceId');

                          // 2. ลบทุก key ทีละตัว (ไม่ใช้ clear())
                          final keys = prefs.getKeys();
                          for (String key in keys) {
                            if (key != "sessionId" &&
                                key != 'lastActiveTime' &&
                                key != 'deviceId' &&
                                key != 'branch_first_processed' &&
                                key != 'last_processed_click_timestamp') {
                              await prefs.remove(key);
                            }
                          }
                          socketCtr.onClose();

                          // 3. ถ้าอยากให้ชัวร์ set sessionId กลับอีกทีก็ได้ (option)
                          if (sessionId != null) {
                            await prefs.setString("sessionId", sessionId);
                          }
                          if (lastActive != null) {
                            await prefs.setString('lastActiveTime', lastActive);
                          }
                          if (deviceId != null) {
                            await prefs.setString('deviceId', deviceId);
                          }
                        });

                        Get.offAll(() => const SplashScreen());
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                      side:
                          BorderSide(width: 0.5, color: Colors.grey.shade700)),
                  child: const Text(
                    'ออกจากระบบ',
                    style: TextStyle(color: Colors.black),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
