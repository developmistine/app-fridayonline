// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

// import 'dart:developer';

import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/controller/catelog/catelog_controller.dart';
import 'package:fridayonline/controller/home/home_controller.dart';
import 'package:fridayonline/controller/notification/notification_controller.dart';
import 'package:fridayonline/homepage/dialogalert/CustomAlertDialogs.dart';
import 'package:fridayonline/homepage/myhomepage.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/model/register/objectenduserregister.dart';
import 'package:fridayonline/model/register/userlogin.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:fridayonline/service/registermember/registermember.dart';
import 'package:fridayonline/service/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../controller/cart/cart_controller.dart';
import '../../controller/cart/dropship_controller.dart';
import '../theme/formatter_text.dart';
import '../theme/theme_loading.dart';

// เป็นส่วนที่ระบบ
class EndUserRegisterProfile extends StatefulWidget {
  final String lstelNumber;
  final String lsOTPNumber;
  final String name;
  final String serName;
  final String repCode;
  final String linkId;

  const EndUserRegisterProfile(this.lstelNumber, this.lsOTPNumber, this.name,
      this.serName, this.repCode, this.linkId,
      {super.key});

  @override
  State<EndUserRegisterProfile> createState() => _EndUserRegisterProfileState();
}

class _EndUserRegisterProfileState extends State<EndUserRegisterProfile> {
  late String TelNumber;
  late String UserID;
  late String repCodeShare;
  final _formkey = GlobalKey<FormState>();

  // ส่วนที่ดำเนินการในการเตรียม
  TextEditingController cusname = TextEditingController();
  TextEditingController cusnickname = TextEditingController();
  TextEditingController custel = TextEditingController();
  TextEditingController cusref = TextEditingController();

  // เตรียม Object ก่อนที่จะทำการ INSERT

  EndUserRegidter enduserInfo = EndUserRegidter(
      '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

  // ส่วนของระบบที่ทำการ Get ตาม  Preferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // ส่วนที่ทำการ Get Data ออกมา
  String lstoken = '';
  String lsDevice = '';

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    // enduserInfo  = EnduserInfo();
    setState(() {
      // กรณีที่ทำการ Get Data
      TelNumber = widget.lstelNumber;
      cusname.text = widget.name;
      cusnickname.text = widget.serName;
      cusref.text = widget.repCode.replaceAllMapped(
          RegExp(r'(\d{4})(\d{5})(\d+)'),
          (Match m) => "${m[1]}-${m[2]}-${m[3]}");
      custel.text = TelNumber.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'),
          (Match m) => "${m[1]}-${m[2]}-${m[3]}");
    });
    // ระบบทำการ Get ข้อมูลก่อน
    _myGetData();
    if (widget.repCode == '') {
      getRepCodeShare();
    }
  }

  void getRepCodeShare() async {
    final SharedPreferences prefs = await _prefs;
    final repCodeShare = prefs.getString("RepCodeShare") ?? '';
    setState(() {
      cusref.text = repCodeShare.replaceAllMapped(
          RegExp(r'(\d{4})(\d{5})(\d+)'),
          (Match m) => "${m[1]}-${m[2]}-${m[3]}");
    });
  }

  void _myGetData() async {
    // ส่วนที่ระบบทำการสลับในการ Call  Data
    final SharedPreferences prefs = await _prefs;
    setState(() {
      lstoken = prefs.getString("Token") ?? '';
      lsDevice = prefs.getString("Device") ?? '';
    });
  }

  // ส่วนที่ระบบทำการ Call มาที่ Event การทำงานของระบบ
  // กรณีที่ดำเนินการ
  void _myCallback() async {
    // ส่วนที่ระบบทำการสลับในการ Call  Data
    bool validate = _formkey.currentState!.validate();
    // bool lbinitial = false;
    String success = "";
    String RepCode = "";
    String RepSeq = "";
    String RepName = "";
    String RepTel = "";
    String EndUserID = "";
    String Endusersurname = "";
    String EnduserName = "";
    String EnduserTel = "";

    final Enduserregister objectinsertRegistet;
    if (validate) {
      intitialdatatoinsert();
      // กรณีที่ดำเนินการส่งข้อมูลเข้าไปในระบบ
      objectinsertRegistet = await EnduserRegisterMember(enduserInfo);
      success = objectinsertRegistet.value.success;
      if (success == '1') {
        // ระบบทำการ Login เข้าไปตรวจสอบสำเร็จ
        RepCode = objectinsertRegistet.value.msl.repCode;
        RepSeq = objectinsertRegistet.value.msl.repSeq;
        RepName = objectinsertRegistet.value.msl.repName;
        RepTel = objectinsertRegistet.value.msl.repTel;
        EndUserID = objectinsertRegistet.value.endUserid;
        EnduserName = objectinsertRegistet.value.enduserName;
        Endusersurname = objectinsertRegistet.value.endusersurname;
        EnduserTel = TelNumber;
        // log(EnduserTel);
        // จากนั้นเอา Data ที่ได้เก็บเข้าไปในระบบ
        SettingsPreferences(success, RepSeq, RepCode, RepName, RepTel, '1',
            EndUserID, EnduserName, Endusersurname, EnduserTel);
      } else // กรณีที่ Log in ข้อมูลในระบบไม่สำเร็จ ระบบแสดง POPUP ออกมา
      {
        // กรณีที่ระบบแสดง  POPUP
        // ส่วนที่ระบบดำเนินการ POPUP กรณีที่ไม่สามารถ
        showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (context) {
            return const CustomAlertDialogs(
              title: "แจ้งข้อมูล",
              description: "ลงทะเบียนไม่สำเร็จ กรุณาติดต่อเจ้าหน้าที่",
            );
          },
        ).then((val) {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
          return;
        });
      }
    }
  }

  Future<void> setNewSessionId() async {
    const uuid = Uuid();
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("sessionId", uuid.v4());
  }

  //  ทำการเก็บ Data เข้ามาหลังจากที่ระบบทำการ Login สำเร็จ
  void SettingsPreferences(
      String lsSuccess,
      String lsRepSeq,
      String lsRepCode,
      String lsRepName,
      String lsRepTel,
      String lsTypeUser,
      String EndUserID,
      String EnduserName,
      String Endusersurname,
      String EnduserTel) async {
    // เรียกใช้งาน SharedPreferences ที่เป็น future
    final SharedPreferences prefs = await _prefs;
    await setNewSessionId();
    // Clear preference RepCodeShare
    prefs.setString("RepCodeShare", "");
    // ทำการ Get Data ออกมาทำการตรวจสอบก่อน
    // กรณีที่ทำการ Set Data
    prefs.setString("login", lsSuccess);
    prefs.setString("RepSeq", lsRepSeq);
    prefs.setString("RepCode", lsRepCode);
    prefs.setString("RepName", lsRepName);
    prefs.setString("RepTel", lsRepTel);
    prefs.setString("UserType", lsTypeUser);
    // กรณีที่ทำการจัดเก็บ EndUserID
    prefs.setString("EndUserID", EndUserID);
    prefs.setString("EnduserName", EnduserName);
    prefs.setString("Endusersurname", Endusersurname);

    SetData data = SetData();

    await InteractionLogger.initialize(
        sessionId: await data.sessionId,
        customerId: int.tryParse(await data.enduserId) ?? 0,
        customerCode: await data.repCode,
        customerType: await data.repType,
        customerName: await data.nameEndUsers,
        channel: "app",
        deviceType: await data.device,
        deviceToken: await data.tokenId == "null" ? "" : await data.tokenId);
    // ระบบ Set กลับไปที่หน้า Page หลักก่อน  หรือจะให้ไปแสดงที่หน้าจอ Profile เลย
    // String? lslogin1 = prefs.getString("login");
    Get.find<AppController>().setCurrentNavInget(0);
    Get.find<BannerController>().get_banner_data();
    Get.find<NotificationController>().get_notification_data();
    Get.find<DraggableFabController>().draggable_Fab();
    Get.find<FavoriteController>().get_favorite_data();
    Get.find<SpecialPromotionController>().get_promotion_data();
    //Get.find<SpecialDiscountController>().fetch_special_discount();
    Get.find<ProductHotItemHomeController>().get_product_hotitem_data();
    Get.find<ProductHotIutemLoadmoreController>().resetItem();
    Get.find<CatelogController>().get_catelog();
    Get.find<FetchCartItemsController>().fetch_cart_items();
    Get.find<FetchCartDropshipController>().fetchCartDropship();
    Get.find<KeyIconController>().get_keyIcon_data();
    Get.find<HomePointController>().get_home_point_data(false);
    Get.find<HomeContentSpecialListController>().get_home_content_data("");

    // ระบบ Set กลับไปที่หน้า Page หลักก่อน

    Get.offAll(() => MyHomePage());
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  SettingTelEnduersPreference(endtelnumber) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("EnduserTel", endtelnumber);
  }

  // ส่วนที่ระบบทำการ Call มาที่ Event การทำงานของระบบ
  // กรณีที่ทำการ เตรียมข้อมูลเพื่อที่จะทำการ Insert ข้อมูล
  bool intitialdatatoinsert() {
    //  ทำการ Set
    try {
      setState(() {
        // เป็นส่วนที่ทำการ SETDATA เข้ามาในระบบ
        enduserInfo.enduserName = cusname.text;
        enduserInfo.endusersurname = cusnickname.text;
        enduserInfo.birthday = '';
        enduserInfo.email = '';
        enduserInfo.telnumber = custel.text.replaceAll(RegExp(r'[^0-9\.]'), '');
        enduserInfo.flag = 'I';
        enduserInfo.repCode = cusref.text.replaceAll(RegExp(r'[^0-9\.]'), '');
        enduserInfo.tokenOrder = '';
        enduserInfo.imei = '';
        enduserInfo.chanel = 'OTP';
        enduserInfo.socialId = custel.text.replaceAll(RegExp(r'[^0-9\.]'), '');
        enduserInfo.registrationId = lstoken;
        enduserInfo.userId = '';
        enduserInfo.versionName = '1.1.0';
        enduserInfo.linkId = widget.linkId;

        SettingTelEnduersPreference(enduserInfo.telnumber);
      });
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(50.0), // here the desired height
            child: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             EndCustomerRegister())); // กรณีระบบทำการ ส่งกลับไป
                  }),
              backgroundColor: theme_color_df,
              title: const Text(
                "รายละเอียดข้อมูลส่วนตัว",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'notoreg',
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            )),
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xfff7f6fb),
        // Design Data OTP
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    settext(
                        'ท่านสามารถเข้าใช้งานเชื่อมต่อระบบได้อย่างปลอดภัย ข้อมูลส่วนตัวของท่านจะถูกเก็บเป็นความลับ'),
                    // เริ่มวางในส่วนของ Columns
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: cusname,
                            maxLines: 1,
                            validator:
                                Validators.required('กรุณาระบุ ชื่อ-นามสกุล'),
                            // controller: lmaddress1,
                            style: const TextStyle(
                                fontSize: 15, fontFamily: 'notoreg'),
                            decoration: designtexthint('ชื่อ-นามสกุล'),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: cusnickname,
                            maxLines: 1,
                            validator:
                                Validators.required('กรุณาระบุ ชื่อเล่น'),
                            // controller: lmaddress1,
                            style: const TextStyle(
                                fontSize: 15, fontFamily: 'notoreg'),
                            decoration: designtexthint('ชื่อเล่น'),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: custel,
                            keyboardType: TextInputType.phone,
                            maxLines: 1,
                            inputFormatters: [maskFormatterPhone],
                            validator:
                                Validators.required('กรุณาระบุเบอร์โทรศัพท์'),
                            // controller: lmaddress1,
                            style: const TextStyle(
                                fontSize: 15, fontFamily: 'notoreg'),
                            decoration: designtexthint('เบอร์โทรศัพท์'),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    settext('อ้างอิงรหัสสมาชิกมิสทินที่แนะนำ'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: cusref,
                            keyboardType: TextInputType.phone,
                            maxLines: 1,
                            inputFormatters: [maskFormatterRepcode],
                            validator: Validators.required(
                                'กรุณาระบุรหัสสมาชิกมิสทิน'),
                            // controller: lmaddress1,
                            style: const TextStyle(
                                fontSize: 15, fontFamily: 'notoreg'),
                            decoration: designtexthint('รหัสสมาชิกมิสทิน'),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextButton(
            // ignore: sort_child_properties_last
            child: const Text(
              'ลงทะเบียน',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'notoreg',
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              var len = cusref.text.replaceAll(RegExp(r'[^0-9\.]'), '');
              if (len.length >= 10) {
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
                await Future.delayed(const Duration(seconds: 2));
                _myCallback();
              } else {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.all(10),
                        titlePadding: const EdgeInsets.only(top: 20, bottom: 0),
                        actionsPadding:
                            const EdgeInsets.only(top: 0, bottom: 0),
                        actionsAlignment: MainAxisAlignment.end,
                        title: Text(
                          textAlign: TextAlign.center,
                          "แจ้งเตือน",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme_color_df),
                        ),
                        content: const Text(
                            textAlign: TextAlign.center,
                            'กรอกรหัสสมาชิกให้ครบ 10 หลัก'),
                        actions: [
                          const Divider(
                            color: Color(0XFFD9D9D9),
                            thickness: 1,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
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
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: theme_color_df,
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 15, fontFamily: 'notoreg')),
          ),
        ),
      ),
    );
  }

  Padding settext(String lsheader) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Container(
        alignment: Alignment.topLeft,
        child: Text(
          lsheader,
          style: const TextStyle(fontFamily: 'notoreg', fontSize: 15),
        ),
      ),
    );
  }

  InputDecoration designtexthint(String lstext) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      hintText: lstext,
      hintStyle: const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
      isDense: true, // Added this
    );
  }
}
