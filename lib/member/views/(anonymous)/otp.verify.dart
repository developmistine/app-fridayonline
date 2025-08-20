import 'dart:async';

import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/member/models/authen/b2cregis.model.dart';
import 'package:fridayonline/member/services/authen/b2cauthen.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

final EndUserHomeCtr endUserHomeCtr = Get.find();
final EndUserSignInCtr endUserSignInCtr = Get.put(EndUserSignInCtr());

class OtpVerify extends StatefulWidget {
  const OtpVerify({super.key});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  final textEditingController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: themeColorDefault,
            leadingWidth: 200,
            leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    Icon(Icons.arrow_back),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'ย้อนกลับ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                Padding(
                  padding: Get.width >= 768
                      ? EdgeInsets.symmetric(
                          horizontal: Get.width / 5, vertical: 100)
                      : EdgeInsets.zero,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('กรอกรหัส OTP',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text('เราได้ส่ง OTP ไปทาง SMS'),
                          Obx(() {
                            return Text(
                                'ที่เบอร์โทรของคุณ ${formatPhoneNumber(endUserSignInCtr.telNumber.value)}');
                          }),
                          const SizedBox(
                            height: 42,
                          ),
                          // InkWell(
                          //     onTap: () {
                          //       endUserSignInCtr.stopTimer();
                          //       // endUserSignInCtr.resetTimer();
                          //       // endUserSignInCtr.startTimer();
                          //     },
                          //     child: const Text('test')),
                          Obx(() {
                            return PinCodeTextField(
                              appContext: context,
                              enabled:
                                  endUserSignInCtr.remainingSeconds.value == 0
                                      ? false
                                      : true,
                              pastedTextStyle: TextStyle(
                                color: themeColorDefault,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 4,
                              obscureText: false,
                              obscuringCharacter: '*',
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                selectedBorderWidth: 0.5,
                                disabledBorderWidth: 0.5,
                                inactiveBorderWidth: 0.8,
                                activeBorderWidth: 0.5,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(14),
                                fieldHeight: 72,
                                fieldWidth: 72,
                                activeColor: themeColorDefault,
                                selectedColor: themeColorDefault,
                                inactiveColor: Colors.grey.shade400,
                                inactiveFillColor: themeColorDefault,
                                activeFillColor:
                                    hasError ? Colors.orange : Colors.white,
                              ),
                              cursorColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              textStyle:
                                  const TextStyle(fontSize: 20, height: 1.6),
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
                                // print(v);
                                SetData data = SetData();
                                loadingProductStock(context);
                                var res = await b2cVerifyOtpService("register",
                                    endUserSignInCtr.telNumber.value, v);
                                Get.back();
                                if (res!.code == "100") {
                                  endUserSignInCtr.resetTimer();
                                  final SharedPreferences prefs = await _prefs;
                                  String deepLinkSource =
                                      prefs.getString("deepLinkSource") ?? '';
                                  String deepLinkId =
                                      prefs.getString("deepLinkId") ?? '';
                                  var payload = B2CRegister(
                                    registerId:
                                        endUserSignInCtr.telNumber.value,
                                    registerType: 'phone',
                                    moblie: endUserSignInCtr.telNumber.value,
                                    email: '',
                                    prefix: '',
                                    firstName: '',
                                    lastName: '',
                                    displayName: '',
                                    image: '',
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
                                      mobile: '',
                                    ),
                                    tokenApp: await data.tokenId,
                                    device: await data.device,
                                    sessionId: await data.sessionId,
                                    identityId: await data.deviceId,
                                  );
                                  var res = await b2cRegisterService(payload);

                                  // printWhite(
                                  //     "Login ด้วย เบอร์ CustId : ${res!.data.custId}");
                                  await prefs.setString(
                                      "accessToken", res!.data.accessToken);
                                  await prefs.setString(
                                      "refreshToken", res.data.refreshToken);
                                  prefs.remove("deepLinkSource");
                                  prefs.remove("deepLinkId");
                                  await endUserSignInCtr.settingPreference(
                                      '1',
                                      endUserSignInCtr.telNumber.value,
                                      '5',
                                      res.data.custId);
                                } else {
                                  if (!Get.isSnackbarOpen) {
                                    Get.snackbar('แจ้งเตือน', 'OTP ไม่ถูกต้อง',
                                        backgroundColor:
                                            Colors.red.withOpacity(0.8),
                                        colorText: Colors.white);
                                  }
                                }
                              },
                            );
                          }),
                          const SizedBox(
                            height: 32,
                          ),
                          Obx(() {
                            return endUserSignInCtr.remainingSeconds.value > 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "จะส่งรหัสอีกครั้ง",
                                        style: GoogleFonts.ibmPlexSansThai(
                                            color: themeColorDefault,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Obx(() => Text(
                                            '${endUserSignInCtr.remainingSeconds.value} วินาที',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: themeColorDefault),
                                          )),
                                    ],
                                  )
                                : SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: themeColorDefault,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                        onPressed: () {
                                          b2cSentOtpService("register",
                                              endUserSignInCtr.telNumber.value);
                                          endUserSignInCtr.resetTimer();
                                          endUserSignInCtr.startTimer();
                                        },
                                        child: const Text(
                                          "ส่งรหัสอีกครั้ง",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        )),
                                  );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
