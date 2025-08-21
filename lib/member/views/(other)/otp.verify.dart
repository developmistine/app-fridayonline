import 'dart:async';

import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:fridayonline/member/services/authen/b2cauthen.service.dart';
import 'package:fridayonline/member/services/profile/profile.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/splashscreen.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerify extends StatefulWidget {
  final String phone;
  final String type;
  final String otpRef;
  const OtpVerify(
      {super.key,
      required this.phone,
      required this.type,
      required this.otpRef});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  final textEditingController = TextEditingController();
  final ProfileOtpCtr otpCtr = Get.put(ProfileOtpCtr());

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
              Theme.of(context).textTheme,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    textStyle: GoogleFonts.ibmPlexSansThai()))),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: appBarMasterEndUser('ยืนยันตัวตนด้วยหมายเลขโทรศัพท์'),
              body: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'กรุณาตรวจสอบข้อความที่ส่งไปยังหมายเลข',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      formatPhoneNumber(widget.phone),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Obx(() {
                      return PinCodeTextField(
                        appContext: context,
                        enabled: otpCtr.remainingSeconds.value == 0 ||
                                otpCtr.remainingSeconds.value == 60
                            ? false
                            : true,
                        pastedTextStyle: TextStyle(
                          color: themeColorDefault,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 6,
                        obscureText: false,
                        obscuringCharacter: '*',
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          selectedBorderWidth: 1,
                          inactiveBorderWidth: 0.8,
                          activeBorderWidth: 1,
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 52,
                          fieldWidth: 52,
                          activeColor: themeColorDefault,
                          selectedColor: themeColorDefault,
                          inactiveColor: Colors.grey.shade400,
                          inactiveFillColor: themeColorDefault,
                          activeFillColor:
                              hasError ? Colors.orange : Colors.white,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        textStyle: const TextStyle(fontSize: 20, height: 1.6),
                        errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        autoFocus: true,
                        boxShadows: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (v) async {
                          final Future<SharedPreferences> prefs =
                              SharedPreferences.getInstance();

                          loadingProductStock(context);
                          var res = await b2cVerifyOtpService(
                              widget.type, widget.phone, v, widget.otpRef);
                          Get.back();
                          if (res!.code == '100') {
                            otpCtr.resetTimer();
                            if (widget.type == 'edit_profile') {
                              Get.back(result: true);
                            } else {
                              var response =
                                  await ApiProfile().deleteAccountService();
                              if (response.code == '100') {
                                dialogAlert([
                                  Text(
                                    'ทำการลบบัญชีเรียบร้อย',
                                    style: GoogleFonts.ibmPlexSansThai(
                                        color: Colors.white, fontSize: 13),
                                  )
                                ]);
                                Future.delayed(
                                    const Duration(milliseconds: 1200),
                                    () async {
                                  Get.back();
                                  await prefs
                                      .then((SharedPreferences pref) async {
                                    await pref.clear();
                                  });
                                  Get.offAll(() => const SplashScreen());
                                });
                              } else {
                                Get.snackbar('แจ้งเตือน',
                                    'เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้ง',
                                    backgroundColor:
                                        Colors.red.withOpacity(0.8),
                                    colorText: Colors.white);
                              }
                            }
                          } else {
                            if (!Get.isSnackbarOpen) {
                              Get.snackbar('แจ้งเตือน', 'OTP ไม่ถูกต้อง',
                                  backgroundColor: Colors.red.withOpacity(0.8),
                                  colorText: Colors.white);
                            }
                          }
                        },
                      );
                    }),
                    Obx(() {
                      if (otpCtr.remainingSeconds.value == 0 ||
                          otpCtr.remainingSeconds.value == 60) {
                        return RichText(
                          text: TextSpan(
                              text: "ไม่ได้รับข้อความ? ",
                              style: GoogleFonts.ibmPlexSansThai(
                                  color: Colors.grey.shade700),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      otpCtr.resetTimer();
                                      otpCtr.startTimer();
                                    },
                                  text: 'ส่งอีกครั้ง',
                                  style: GoogleFonts.ibmPlexSansThai(
                                      color: themeColorDefault),
                                )
                              ]),
                        );
                      }
                      return Text(
                          "กรุณารอ ${otpCtr.remainingSeconds.value} วินาทีก่อนส่งอีกครั้ง");
                    })
                  ],
                ),
              ))),
        ),
      ),
    );
  }
}
