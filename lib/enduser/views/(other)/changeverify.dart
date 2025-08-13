import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/controller/profile.ctr.dart';
import 'package:fridayonline/enduser/services/authen/b2cauthen.service.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'otp.verify.dart';

class ChangeVerify extends StatefulWidget {
  final String phone;
  const ChangeVerify({super.key, required this.phone});

  @override
  State<ChangeVerify> createState() => _ChangeVerifyState();
}

class _ChangeVerifyState extends State<ChangeVerify> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Theme(
            data: Theme.of(context).copyWith(
                textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
                  Theme.of(context).textTheme,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        textStyle: GoogleFonts.notoSansThaiLooped()))),
            child: Scaffold(
              appBar: appBarMasterEndUser('ระบบตรวจสอบความปลอดภัย'),
              body: SingleChildScrollView(
                  child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'กรุณาเลือกวิธีการยืนยันตัวตนต่อไปนี้ เพื่อรักษาความปลอดภัยบัญชีคุณ',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        var profileCtr = Get.put(ProfileOtpCtr());
                        loadingProductStock(context);
                        await b2cSentOtpService("delete_account", widget.phone)
                            .then((value) {
                          Get.back();
                          if (value!.code == "100") {
                            if (profileCtr.remainingSeconds.value == 0) {
                              profileCtr.resetTimer();
                            }
                            profileCtr.startTimer();
                            Get.to(() => OtpVerify(
                                  phone: widget.phone,
                                  type: 'delete_account',
                                ));
                          } else {
                            Get.snackbar('แจ้งเตือน',
                                'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
                                backgroundColor: Colors.red.withOpacity(0.8),
                                colorText: Colors.white);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade500),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text('ยืนยันตัวตนด้วยหมายเลขโทรศัพท์'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
            )));
  }
}
