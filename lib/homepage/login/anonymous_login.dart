// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/controller/badger/badger_controller.dart';
import 'package:fridayonline/controller/catelog/catelog_controller.dart';
import 'package:fridayonline/controller/home/home_controller.dart';
// import 'package:fridayonline/enduser/enduser.main.dart';
import 'package:fridayonline/homepage/dialogalert/CustomAlertDialogs.dart';
import 'package:fridayonline/homepage/login/login_by_phone.dart';
import 'package:fridayonline/homepage/login/select_register_type.dart';
import 'package:fridayonline/homepage/login/widget_msl_otp.dart';
import 'package:fridayonline/homepage/myhomepage.dart';
import 'package:fridayonline/homepage/theme/formatter_text.dart';
import 'package:fridayonline/model/register/mslResponse.dart';
import 'package:fridayonline/model/register/mslregistermodel.dart';
import 'package:fridayonline/model/register/userlogin.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:fridayonline/service/register_service.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../controller/cart/cart_controller.dart';
import '../../controller/cart/dropship_controller.dart';
import '../../controller/notification/notification_controller.dart';
import '../../controller/pro_filecontroller.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/pathapi.dart';
import '../../controller/flashsale/flash_controller.dart';
import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';
import '../webview/webview_full_screen.dart';
import '../globals_variable.dart' as globals;
// เป็น Class ที่บุคคุณทั่วไปเข้ามาใน App ต้องทำการ Login

class Anonumouslogin extends StatefulWidget {
  const Anonumouslogin({super.key});

  @override
  State<Anonumouslogin> createState() => _AnonumousloginState();
}

class _AnonumousloginState extends State<Anonumouslogin> {
  TextEditingController repcode = TextEditingController();
  TextEditingController reptelnumber = TextEditingController();

  late FocusNode myFocusNode; // ทำการ SET FOCUS ตัวที่ 1
  late FocusNode
      FocusNodeTelnumber; // เป็นตัวที่จะให้ระบบทำการ SET FOCUS ตัวที่ 2

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // Control ที่เป็นตัวของ User เอา Data ส่วนนี้ออกมา
  User user = User('', '', '', '', '');
  String? lstokenData;
  late String lsSuccess;
  late String lsRepSeq;
  late String lsRepCode;
  late String lsRepName;
  late String lsTypeUser;

  late String _versionApp;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    FocusNodeTelnumber = FocusNode();
    loadgetSettings();

    _versionApp = globals.versionApp;
  }

  // ตั้งค่าเริ่มต้น
  void loadgetSettings() async {
    // เรียกใช้งาน SharedPreferences ที่เป็น future
    final SharedPreferences prefs = await _prefs;

    // ทำการ Get Data ออกมาทำการตรวจสอบก่อน

    setState(() {
      lstokenData = prefs.getString("Token") ?? "";
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    FocusNodeTelnumber.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  // ระบบวิไป Call  API เพื่อทำการ Regis
  void CallDataRegisterlogin(User user) async {
    // กรณีที่ทำการ Get Data
    ResponseMsl isMsl = await checkRepCodeMslRegister(user.RepCode);
    if (isMsl.code == "-9") {
      Navigator.pop(context);
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(10),
              titlePadding: const EdgeInsets.only(top: 20, bottom: 0),
              actionsPadding: const EdgeInsets.only(top: 0, bottom: 0),
              actionsAlignment: MainAxisAlignment.end,
              title: Text(
                textAlign: TextAlign.center,
                "แจ้งเตือน",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme_color_df),
              ),
              content: Text(textAlign: TextAlign.center, isMsl.message),
              actions: [
                const Divider(
                  color: Color(0XFFD9D9D9),
                  thickness: 1,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    FocusScope.of(context).unfocus();
                  },
                  child: Center(
                    child: Text(
                        textAlign: TextAlign.center,
                        'ปิด',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme_color_df)),
                  ),
                )
              ],
            );
          });
    }

    if (isMsl.info.flagOtp) {
      Get.back();
      Get.to(() => CheckMslOtp(repcode: user.RepCode));
    } else {
      Mslregist mslregist = await MslReGiaterAppliction(user);

      // กรณีที่ทำการ Set Data ออกมา
      setState(() {
        lsSuccess = mslregist.value.success;
        lsRepSeq = mslregist.value.repSeq;
        lsRepCode = mslregist.value.repCode;
        lsRepName = mslregist.value.repName;
        lsTypeUser = "2"; //   mslregist.value.typeUser;
        // กรณีที่ทำการ Register แล้วระบบทำการ Login ผ่าน
        if (lsSuccess == "1") {
          // log("login Success");
          SettingsPreferences(
              lsSuccess, lsRepSeq, lsRepCode, lsRepName, lsTypeUser);
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(10),
                  titlePadding: const EdgeInsets.only(top: 20, bottom: 0),
                  actionsPadding: const EdgeInsets.only(top: 0, bottom: 0),
                  actionsAlignment: MainAxisAlignment.end,
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
                      mslregist.value.description.msg.msgAlert1),
                  actions: [
                    const Divider(
                      color: Color(0XFFD9D9D9),
                      thickness: 1,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        FocusScope.of(context).unfocus();
                      },
                      child: Center(
                        child: Text(
                            textAlign: TextAlign.center,
                            'ปิด',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme_color_df)),
                      ),
                    )
                  ],
                );
              });
        }
      });
    }
  }

  Future<void> setNewSessionId() async {
    const uuid = Uuid();
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("sessionId", uuid.v4());
  }

  // ตั้งค่าเริ่มต้น
  void SettingsPreferences(String lsSuccess, String lsRepSeq, String lsRepCode,
      String lsRepName, String lsTypeUser) async {
    // เรียกใช้งาน SharedPreferences ที่เป็น future
    final SharedPreferences prefs = await _prefs;
    await setNewSessionId();

    // ทำการ Get Data ออกมาทำการตรวจสอบก่อน

    // กรณีที่ทำการ Set Data
    prefs.setString("login", lsSuccess);
    prefs.setString("RepSeq", lsRepSeq);
    prefs.setString("RepCode", lsRepCode);
    prefs.setString("RepName", lsRepName);
    prefs.setString("UserType", lsTypeUser);

    SetData data = SetData();

    await InteractionLogger.initialize(
        sessionId: await data.sessionId,
        customerId: int.tryParse(await data.repSeq) ?? 0,
        customerCode: await data.repCode,
        customerType: await data.repType,
        customerName: await data.repType == '1'
            ? await data.nameEndUsers
            : await data.repName,
        channel: "app",
        deviceType: await data.device,
        deviceToken: await data.tokenId == "null" ? "" : await data.tokenId);

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
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<AppController>(builder: (controller) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: WillPopScope(
          onWillPop: () async {
            Get.find<AppController>().setCurrentNavIngetB2c(0);
            Get.back();
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ทำปุ่มย้อนกลับ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: SafeArea(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              onPressed: () {
                                Get.find<AppController>()
                                    .setCurrentNavIngetB2c(0);
                                Get.back();
                              },
                              child: Text(
                                MultiLanguages.of(context)!
                                    .translate('login_register_back'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xfffd7f6b),
                                  fontFamily: 'notoreg',
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 2.0,
                    ),
                    // ทำข้อความ Text
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0XFFC3EAFF),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20, bottom: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    MultiLanguages.of(context)!
                                        .translate('login_member_title'),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),

                              // Text รหัสสมาชิก 10 หลัก

                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    MultiLanguages.of(context)!
                                        .translate('login_repcode'),
                                    style: const TextStyle(
                                        fontFamily: 'notoreg',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  TextFormField(
                                    focusNode: myFocusNode,
                                    //maxLength: 10,
                                    controller: repcode,
                                    inputFormatters: [maskFormatterRepcode],
                                    // กรณีที่เป็น รหัสสมาชิก
                                    style: const TextStyle(
                                      fontFamily: 'notoreg',
                                    ),
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: MultiLanguages.of(context)!
                                          .translate('login_repcode_specify'),
                                      hintStyle: const TextStyle(
                                          color: Color(0xff12699D)),
                                      //prefixIcon: const Icon(Icons.person),
                                      contentPadding:
                                          const EdgeInsets.only(left: 10),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(.0)),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: theme_color_df),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: theme_color_df),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),

                                    // validator: EmailValidator(errorText: 'enter a valid email address')
                                    validator: RequiredValidator(
                                            errorText: 'this field is required')
                                        .call,
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 20.0,
                              ),

                              TextButton(
                                onPressed: () {
                                  // ทำการ GetRepCode เพื่อทำการ
                                  String lsrepcode = repcode.text
                                      .replaceAll(RegExp(r'[^0-9\.]'), '');
                                  // เป็นส่วนที่ทำการ Get เบอร์โทรศัพท์ออกมาทำการตรวจสอบ
                                  String lsreptelnumber = reptelnumber.text
                                      .replaceAll(RegExp(r'[^0-9\.]'), '');

                                  // ประกกาศตัวแปร Bool มาทำการตรวจสอบข้อมูลก่อน
                                  String lstitle = "แจ้งข้อมูล";
                                  String lsdescription = "";
                                  // String lsdescriptiontelnumber = "";
                                  // เป็นส่วนที่ทำการตรวจสอบเพื่อที่จะทำการค่าว่างของรหัสสมาชิก

                                  bool lbflagcheckrepcode = false;
                                  bool lbflagcheckreptelnumber = false;

                                  // กรณีที่ทำการตรวจสอบ RepCode
                                  if (lsrepcode == '') {
                                    setState(() {
                                      lsdescription =
                                          "กรุณากรอกรหัสสมาชิก 10 หลัก";
                                      lbflagcheckrepcode = true;
                                    });
                                  } else if (lsrepcode.length < 10) {
                                    setState(() {
                                      lsdescription =
                                          "กรุณากรอกรหัสสมาชิก 10 หลัก";
                                      lbflagcheckrepcode = true;
                                    });
                                  } else {
                                    setState(() {
                                      lsdescription = "";
                                      lbflagcheckrepcode = false;
                                    });
                                  }

                                  // กรณีที่ทำการตรวจสอบการกรอกรหัสสมาชิก
                                  if (lbflagcheckrepcode) {
                                    // int lsstatusclick = controller.Getcurrentsetstatuschick();
                                    showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialogs(
                                          title: lstitle,
                                          description: lsdescription,
                                        );
                                      },
                                    ).then((val) {
                                      myFocusNode.requestFocus();
                                      return;
                                    });
                                  }
                                  // กรณีที่ผ่านการตรวจสอบข้อมูลทั้งหมด
                                  if (!lbflagcheckrepcode &&
                                      !lbflagcheckreptelnumber) {
                                    // log("Call Function เพื่อที่จะทำการ Login ระบบ");
                                    user.RepCode = lsrepcode;
                                    user.Telnumber = lsreptelnumber;
                                    user.Device = "Android";
                                    user.Token = lstokenData!;
                                    user.OTP = "9999";
                                    // ทำการส
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
                                    CallDataRegisterlogin(user);
                                  }

                                  // เป็นส่วนที่ทำการ Get เบอร์โทรศัพท์ออกมาทำการตรวจสอบ
                                },
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(width / 1.1, 56.0),
                                    backgroundColor: theme_color_df,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    textStyle: const TextStyle(
                                        fontSize: 15, fontFamily: 'notoreg')),
                                child: Text(
                                  MultiLanguages.of(context)!
                                      .translate('login_to_friday'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'notoreg',
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 15.0,
                              ),

                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginByPhone()));
                                },
                                child: Text(
                                  MultiLanguages.of(context)!
                                      .translate('login_phone'),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'notoreg',
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Divider(
                        color: Color(0XFFABABAB),
                        thickness: 1,
                      ),
                    ),

                    const SizedBox(
                      height: 15.0,
                    ),

                    // สมัครสมาชิก
                    TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: Size(width / 1.2, 56.0),
                        side: const BorderSide(
                            color: Color(0xFF4D4D4D), width: 1),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SelectRegisterType()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${MultiLanguages.of(context)!.translate('no_member')} ',
                              style: const TextStyle(
                                  color: Color(0xFF4D4D4D),
                                  fontSize: 17,
                                  fontFamily: 'notoreg'),
                            ),
                            Text(
                                MultiLanguages.of(context)!
                                    .translate('login_register_text_press'),
                                style: const TextStyle(
                                    color: Color(0xFF4D4D4D),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'notoreg')),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                              MultiLanguages.of(context)!
                                  .translate('login_register_text'),
                              style: const TextStyle(
                                  fontSize: 17, fontFamily: 'notoreg')),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            onPressed: () {
                              var murl =
                                  '$baseurl_yclub/yclub/policyandcondition/howto_regisnew.php';
                              Get.to(() => WebViewFullScreen(mparamurl: murl));
                            },
                            child: Text(
                              'ดูเพิ่มเติม',
                              style: TextStyle(
                                color: theme_color_df,
                                fontFamily: 'notoreg',
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '${MultiLanguages.of(context)!.translate('me_version')}: $_versionApp',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontFamily: 'notoreg',
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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
