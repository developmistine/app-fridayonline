// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/controller/badger/badger_controller.dart';
import 'package:fridayonline/controller/cart/cart_controller.dart';
import 'package:fridayonline/controller/cart/dropship_controller.dart';
import 'package:fridayonline/controller/flashsale/flash_controller.dart';
import 'package:fridayonline/controller/home/home_controller.dart';
import 'package:fridayonline/controller/point_rewards/point_rewards_controller.dart';
import 'package:fridayonline/controller/pro_filecontroller.dart';
import 'package:fridayonline/homepage/dialogalert/customalertdialogs.dart';
import 'package:fridayonline/homepage/myhomepage.dart';
import 'package:fridayonline/homepage/theme/formatter_text.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/model/register/mslregistermodel.dart';
import 'package:fridayonline/model/register/objectconfirmotp.dart';
import 'package:fridayonline/model/register/push_otp_msl_regis.dart';
import 'package:fridayonline/service/register_service.dart';
import 'package:fridayonline/service/registermember/registermember.dart';
import 'package:fridayonline/service/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/catelog/catelog_controller.dart';
import '../../controller/notification/notification_controller.dart';
import 'package:fridayonline/model/register/userlogin.dart';

class CheckMslOtp extends StatefulWidget {
  final String repcode;
  const CheckMslOtp({super.key, required this.repcode});

  @override
  State<CheckMslOtp> createState() => _CheckMslOtpState();
}

class _CheckMslOtpState extends State<CheckMslOtp> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController lmphonenumber = TextEditingController();
  bool hasError = false;
  OtpTimerController timerController = Get.put(OtpTimerController());
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  User user = User('', '', '', '', '');
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

  void SettingsPreferences(String lsSuccess, String lsRepSeq, String lsRepCode,
      String lsRepName, String lsTypeUser) async {
    // เรียกใช้งาน SharedPreferences ที่เป็น future
    final SharedPreferences prefs = await _prefs;
    // ทำการ Get Data ออกมาทำการตรวจสอบก่อน

    // กรณีที่ทำการ Set Data
    prefs.setString("login", lsSuccess);
    prefs.setString("RepSeq", lsRepSeq);
    prefs.setString("RepCode", lsRepCode);
    prefs.setString("RepName", lsRepName);
    prefs.setString("UserType", lsTypeUser);

    // String? lslogin1 = prefs.getString("login");

    Get.find<AppController>().setCurrentNavInget(0);
    Get.find<DraggableFabController>().draggable_Fab();
    Get.find<BannerController>().get_banner_data();
    Get.find<FavoriteController>().get_favorite_data();
    Get.find<SpecialPromotionController>().get_promotion_data();
    //Get.find<SpecialDiscountController>().fetch_special_discount();
    Get.find<ProductHotItemHomeController>().get_product_hotitem_data();
    Get.find<ProductHotIutemLoadmoreController>().resetItem();
    Get.find<CatelogController>().get_catelog();
    Get.find<NotificationController>().get_notification_data();
    Get.find<ProfileController>().get_profile_data();
    Get.find<ProfileSpecialProjectController>().get_special_project_data();
    Get.find<FetchCartItemsController>().fetch_cart_items();
    Get.find<FetchCartDropshipController>().fetchCartDropship();
    Get.find<FlashsaleTimerCount>().flashSaleHome();
    Get.find<BadgerController>().get_badger();
    Get.find<BadgerProfileController>().get_badger_profile();
    Get.find<BadgerController>().getBadgerMarket();
    Get.find<PopUpStatusController>().ChangeStatusViewPopupFalse();
    Get.find<KeyIconController>().get_keyIcon_data();

    Get.find<HomePointController>().get_home_point_data(false);
    Get.find<HomeContentSpecialListController>().get_home_content_data("");

    Get.offAll(() => MyHomePage());
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => ShowCaseHome()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleMaster('สมาชิกเข้าสู่ระบบ'),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Column(
                children: [
                  const Text(
                    'สมาชิกลงทะเบียนเข้าระบบ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'notoreg',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "ระบุเบอร์โทรศัพท์",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                        fontFamily: 'notoreg',
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        controller: lmphonenumber,
                        keyboardType: TextInputType.phone,
                        validator: Validators.minLength(
                            10, 'กรุณาระบุเบอร์โทรศัพท์ 10 หลัก'),
                        inputFormatters: [maskFormatterPhone],
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'notoreg',
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: Get.width,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () async {
                              bool validate = _formkey.currentState!.validate();
                              if (validate) {
                                if (!timerController.isCountDown.value) {
                                  PushOtpMslRegis res = await pushOtpMslRegis(
                                      widget.repcode, lmphonenumber.text);
                                  if (res.values == '001') {
                                    timerController.startTimer();
                                  } else {
                                    return showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialogs(
                                          title: "แจ้งเตือน",
                                          description: res.message,
                                        );
                                      },
                                    );
                                  }
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
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "OTP ส่ง SMS ไปที่หมายเลข \n ${lmphonenumber.text}",
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'notoreg'),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GetX<OtpTimerController>(builder: (data) {
                          return PinCodeTextField(
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
                                Checkotp res = await CheckOTP(
                                    lmphonenumber.text.replaceAll("-", ""),
                                    currentText);
                                if (res.values == "-1") {
                                  return showDialog(
                                    barrierColor: Colors.black26,
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialogs(
                                        title: "แจ้งเตือน",
                                        description: res.message,
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          content: Center(
                                            child: theme_loading_df,
                                          ));
                                    },
                                  );
                                  user.RepCode = widget.repcode;
                                  user.OTP = currentText;
                                  Mslregist mslregist =
                                      await MslReGiaterAppliction(user);
                                  var lsSuccess = mslregist.value.success;
                                  var lsRepSeq = mslregist.value.repSeq;
                                  var lsRepCode = mslregist.value.repCode;
                                  var lsRepName = mslregist.value.repName;
                                  Get.find<OtpTimerController>().resetTimer();
                                  Get.back();
                                  if (lsSuccess == "1") {
                                    SettingsPreferences(lsSuccess, lsRepSeq,
                                        lsRepCode, lsRepName, "2");
                                  } else {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            titlePadding: const EdgeInsets.only(
                                                top: 20, bottom: 0),
                                            actionsPadding:
                                                const EdgeInsets.only(
                                                    top: 0, bottom: 0),
                                            actionsAlignment:
                                                MainAxisAlignment.end,
                                            title: Text(
                                              textAlign: TextAlign.center,
                                              "แจ้งเตือน",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: theme_color_df),
                                            ),
                                            content: Text(
                                                textAlign: TextAlign.center,
                                                mslregist.value.description.msg
                                                    .msgAlert1),
                                            actions: [
                                              const Divider(
                                                color: Color(0XFFD9D9D9),
                                                thickness: 1,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Center(
                                                  child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      'ปิด',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              theme_color_df)),
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  }
                                }
                              }
                            },
                            onChanged: (value) {
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
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "กรุณากรอกรหัสที่ได้รับ",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'notoreg',
                              color: theme_color_df),
                          textAlign: TextAlign.center,
                        ),
                        // if (show_time == true)
                        //   Text(
                        //     "รหัสจะหมดเวลาภายใน $_start",
                        //     style: const TextStyle(
                        //         fontSize: 14,
                        //         color: Colors.red,
                        //         fontFamily: 'notoreg'),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
