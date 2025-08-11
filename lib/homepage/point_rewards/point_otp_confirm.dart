// ignore_for_file: avoid_print

import 'dart:async';

// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
// import 'package:fridayonline/homepage/widget/appbar_cart.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../controller/point_rewards/point_rewards_controller.dart';
import '../../model/point_rewards/check_otp_point.dart';
import '../../model/point_rewards/otp_point.dart';
import '../../service/point_rewards/point_rewards_sevice.dart';
import '../theme/formatter_text.dart';
// import 'point_rewards_category_list_confirm.dart';

class PorintOtpConfirm extends StatefulWidget {
  final String phoneNumber;
  final String pointExchage;

  const PorintOtpConfirm(this.phoneNumber, this.pointExchage, {super.key});

  @override
  _PorintOtpConfirmState createState() => _PorintOtpConfirmState();
}

class _PorintOtpConfirmState extends State<PorintOtpConfirm> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  OtpTimerController timerController = Get.put(OtpTimerController());

  @override
  Widget build(BuildContext context) {
    const textDangerAlert = TextStyle(
      color: Color(0xFFFF4141),
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 0,
    );
    return Scaffold(
      appBar: appBarTitleMaster('คะแนนสะสม'),
      key: scaffoldKey,
      body: WillPopScope(
        onWillPop: () async {
          Get.back(result: false);
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'โปรดยืนยันตัวตนเพื่อรับสิทธิ์',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                elevation: 5,
                surfaceTintColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 20),
                  child: Column(
                    children: [
                      const Text(
                        'OTP ส่ง SMS ไปที่หมายเลข',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        formatPhoneNumber(widget.phoneNumber),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => timerController.isCountDown.value
                          ? const Column(
                              children: [
                                Text(
                                  'กรุณาใส่รหัส OTP-SMS ที่ได้รับ',
                                  style: textDangerAlert,
                                ),
                                Text(
                                  'รหัส OTP จะหมดอายุใน 3 นาที',
                                  style: textDangerAlert,
                                ),
                                Text(
                                  'หลังจากทำการขอรหัส',
                                  style: textDangerAlert,
                                ),
                              ],
                            )
                          : const SizedBox()),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Form(
                          key: formKey,
                          child: GetX<OtpTimerController>(builder: (data) {
                            return PinCodeTextField(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              appContext: context,
                              enabled: data.isCountDown.value ? true : false,
                              pastedTextStyle: TextStyle(
                                color: theme_color_df,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 4,
                              obscureText: false,
                              obscuringCharacter: '*',
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                selectedBorderWidth: 1,
                                inactiveBorderWidth: 0.8,
                                activeBorderWidth: 1,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(10),
                                fieldHeight: 52,
                                fieldWidth: 52,
                                activeColor: theme_color_df,
                                selectedColor: theme_color_df,
                                inactiveColor: theme_color_df,
                                inactiveFillColor: theme_color_df,
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
                              autoFocus: data.isCountDown.value ? true : false,
                              boxShadows: const [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) async {
                                if (currentText.length != 4) {
                                } else {
                                  CheckotpPoint? res = await checkOtpPoint(
                                      widget.phoneNumber, currentText);
                                  if (res!.code == "100") {
                                    setState(() {
                                      timerController.resetTimer();
                                      hasError = false;
                                      print(
                                          'OTP ถูกต้อง ${widget.phoneNumber}');
                                      Get.back(result: true);
                                    });
                                  } else {
                                    errorController!.add(ErrorAnimationType
                                        .shake); // Triggering error shake animation
                                    setState(() {
                                      hasError = true;
                                    });
                                  }
                                }
                              },
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  currentText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                return true;
                              },
                            );
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Get.width,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (!timerController.isCountDown.value) {
                                OtpPoint? res = await otpPoint(
                                    widget.phoneNumber, widget.pointExchage);
                                if (res!.code == '100') {
                                  // printWhite('${res.message}');
                                  timerController.startTimer();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: theme_color_df,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            child: Obx(() => timerController.isCountDown.value
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/arrow_change.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "ส่งอีกครั้ง ${timerController.secondsRemaining.value} วินาที",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    'กดขอรับ OTP-SMS',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ))),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                'หากเบอร์โทรศัพท์ ไม่ถูกต้อง \nกรุณาติดต่อ เจ้าหน้าที่ Call Center\nโทร. 02-118-5111',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF4D4D4D),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
