import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/controller/badger/badger_controller.dart';
import 'package:fridayonline/controller/catelog/catelog_controller.dart';
import 'package:fridayonline/controller/home/home_controller.dart';
import 'package:fridayonline/homepage/dialogalert/CustomAlertDialogs.dart';
// import 'package:fridayonline/homepage/login/webviewcustomerpdpa.dart';
// import 'package:fridayonline/homepage/login/webviewleadpdpa.dart';
import 'package:fridayonline/homepage/myhomepage.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/model/register/mslregistermodel.dart';
import 'package:fridayonline/model/register/userlogin.dart';
import 'package:fridayonline/service/register_service.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/cart/cart_controller.dart';
import '../../controller/cart/dropship_controller.dart';
import '../../service/languages/multi_languages.dart';
// import '../../service/pathapi.dart';
import '../../controller/flashsale/flash_controller.dart';
// import '../webview/webview_full_screen.dart';
import '../globals_variable.dart' as globals;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// เป็น Class ที่บุคคุณทั่วไปเข้ามาใน App ต้องทำการ Login

class Leadlogin extends StatefulWidget {
  const Leadlogin({super.key});

  @override
  State<Leadlogin> createState() => _LeadloginState();
}

class _LeadloginState extends State<Leadlogin> {
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
    // TODO: implement initState
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
    Mslregist mslregist = await MslReGiaterAppliction(user);
    // จากนั้นทำการ Get
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
        Get.find<FetchCartItemsController>().fetch_cart_items();
        SettingsPreferences(
            lsSuccess, lsRepSeq, lsRepCode, lsRepName, lsTypeUser);
      } else {
        // log("login Fale");
        showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (context) {
            return const CustomAlertDialogs(
              title: "แจ้งเตือน",
              description:
                  "รหัสของท่านไม่ถูกต้อง สมาชิกกรุณาติดต่อ ศูนย์บริการสมาชิก 02-118-5111 หรือหาก ไม่ใช่สมาชิกกรุณาลงทะเบียน",
            );
          },
        ).then((val) {
          // myFocusNode.requestFocus();
          return;
        });
      }
    });
  }

  // ตั้งค่าเริ่มต้น
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
    Get.find<BannerController>().get_banner_data();
    Get.find<FavoriteController>().get_favorite_data();
    Get.find<SpecialPromotionController>().get_promotion_data();
    //Get.find<SpecialDiscountController>().fetch_special_discount();
    Get.find<ProductHotItemHomeController>().get_product_hotitem_data();
    Get.find<ProductHotIutemLoadmoreController>().resetItem();
    Get.find<CatelogController>().get_catelog();
    Get.find<FetchCartItemsController>().fetch_cart_items();
    Get.find<FetchCartDropshipController>().fetchCartDropship();
    Get.find<FlashsaleTimerCount>().flashSaleHome();
    Get.find<BadgerController>().get_badger();
    Get.find<BadgerProfileController>().get_badger_profile();
    Get.find<BadgerController>().getBadgerMarket();
    Get.find<HomeContentSpecialListController>().get_home_content_data("");

    Get.offAll(() => MyHomePage());
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => ShowCaseHome()));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
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
                              Get.find<AppController>().setCurrentNavInget(0);
                              Navigator.pop(context);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 350,
                        child: Center(
                          child: Text(
                            MultiLanguages.of(context)!
                                .translate('login_member_title'),
                            style: const TextStyle(
                                color: Colors.black,
                                //fontFamily: 'noto_medium',
                                fontSize: 35),
                          ),
                        ),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 40.0),
                        child: Text(
                          MultiLanguages.of(context)!
                              .translate('login_repcode'),
                          style: const TextStyle(
                              fontFamily: 'notoreg',
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 40.0),
                        child: TextFormField(
                          focusNode: myFocusNode,
                          //maxLength: 10,
                          controller: repcode,
                          inputFormatters: [
                            MaskTextInputFormatter(mask: "####-#####-#")
                          ],
                          // กรณีที่เป็น รหัสสมาชิก
                          style: const TextStyle(
                            fontFamily: 'notoreg',
                          ),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xfff5f5f5),
                            hintText: MultiLanguages.of(context)!
                                .translate('login_repcode_specify'),
                            hintStyle:
                                const TextStyle(color: Color(0xffc4c4c4)),
                            //prefixIcon: const Icon(Icons.person),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 5.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xfff5f5f5)),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xfff5f5f5)),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),

                          // validator: EmailValidator(errorText: 'enter a valid email address')
                          validator: RequiredValidator(
                                  errorText: 'this field is required')
                              .call,
                        ),
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),
                      // Text เบอร์โทรศัพท์
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 40.0),
                        child: Text(
                          MultiLanguages.of(context)!
                              .translate('login_tel_label'),
                          style: const TextStyle(
                              fontFamily: 'notoreg',
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 40.0),
                        child: TextFormField(
                          focusNode:
                              FocusNodeTelnumber, // ทำการ SET FOCUS เพื่อที่จะทำการแสดง Arert
                          //maxLength: 12,
                          controller: reptelnumber, // กรณีที่เป็นเบอร์โทรศัพท์
                          style: const TextStyle(
                            fontFamily: 'notoreg',
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            MaskTextInputFormatter(mask: "###-###-####")
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xfff5f5f5),
                            hintText: MultiLanguages.of(context)!
                                .translate('login_tel'),
                            hintStyle:
                                const TextStyle(color: Color(0xffc4c4c4)),
                            //prefixIcon: const Icon(Icons.phone),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 5.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xfff5f5f5)),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xfff5f5f5)),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),
                  // บุ่มยืนยัน
                  TextButton(
                    onPressed: () {
                      // ทำการ GetRepCode เพื่อทำการ
                      String lsrepcode =
                          repcode.text.replaceAll(RegExp(r'[^0-9\.]'), '');
                      // เป็นส่วนที่ทำการ Get เบอร์โทรศัพท์ออกมาทำการตรวจสอบ
                      String lsreptelnumber =
                          reptelnumber.text.replaceAll(RegExp(r'[^0-9\.]'), '');

                      // ประกกาศตัวแปร Bool มาทำการตรวจสอบข้อมูลก่อน
                      String lstitle = "แจ้งข้อมูล";
                      String lsdescription = "";
                      String lsdescriptiontelnumber = "";
                      // เป็นส่วนที่ทำการตรวจสอบเพื่อที่จะทำการค่าว่างของรหัสสมาชิก

                      bool lbflagcheckrepcode = false;
                      bool lbflagcheckreptelnumber = false;

                      // กรณีที่ทำการตรวจสอบ RepCode
                      if (lsrepcode == '') {
                        setState(() {
                          lsdescription = "กรุณากรอกรหัสสมาชิก 10 หลัก";
                          lbflagcheckrepcode = true;
                        });
                      } else if (lsrepcode.length < 10) {
                        setState(() {
                          lsdescription = "กรุณากรอกรหัสสมาชิก 10 หลัก";
                          lbflagcheckrepcode = true;
                        });
                      } else {
                        setState(() {
                          lsdescription = "";
                          lbflagcheckrepcode = false;
                        });
                      }

                      // กรณีที่ทำการตรวจสอบที่เบอร์โทรศัพท์
                      if (lsreptelnumber == '') {
                        setState(() {
                          lsdescriptiontelnumber = "กรุณากรอกเบอร์โทรศัพท์";
                          lbflagcheckreptelnumber = true;
                        });
                      } else if (lsreptelnumber.length < 10) {
                        setState(() {
                          lsdescriptiontelnumber =
                              "กรุณากรอกเบอร์โทรศัพท์ครบ 10 หลัก";
                          lbflagcheckreptelnumber = true;
                        });
                      } else {
                        setState(() {
                          lsdescriptiontelnumber = "";
                          lbflagcheckreptelnumber = false;
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
                      } // endif

                      if (!lbflagcheckrepcode) {
                        // กรณีที่ทำการตรวจสอบในส่วนของเบอร์โทรศัพท์
                        if (lbflagcheckreptelnumber) {
                          // int lsstatusclick = controller.Getcurrentsetstatuschick();
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (context) {
                              return CustomAlertDialogs(
                                title: lstitle,
                                description: lsdescriptiontelnumber,
                              );
                            },
                          ).then((val) {
                            FocusNodeTelnumber.requestFocus();
                          });
                        } // endif
                      }

                      // กรณีที่ผ่านการตรวจสอบข้อมูลทั้งหมด
                      if (!lbflagcheckrepcode && !lbflagcheckreptelnumber) {
                        // log("Call Function เพื่อที่จะทำการ Login ระบบ");
                        user.RepCode = lsrepcode;
                        user.Telnumber = lsreptelnumber;
                        user.Device = "Android";
                        user.Token = lstokenData!;
                        user.OTP = "9999";
                        // ทำการส
                        CallDataRegisterlogin(user);
                      }

                      // เป็นส่วนที่ทำการ Get เบอร์โทรศัพท์ออกมาทำการตรวจสอบ
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300.0, 56.0),
                        backgroundColor: theme_color_df,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        textStyle: const TextStyle(
                            fontSize: 15, fontFamily: 'notoreg')),
                    child: Text(
                      MultiLanguages.of(context)!.translate('login_to_friday'),
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
      );
    });
  }
}
