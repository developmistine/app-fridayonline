import 'dart:async';
import 'package:fridayonline/controller/badger/badger_controller.dart';
import 'package:fridayonline/controller/flashsale/flash_controller.dart';
import 'package:fridayonline/homepage/dialogalert/customalertdialogs.dart';
import 'package:fridayonline/homepage/login/anonymous_login.dart';
import 'package:fridayonline/homepage/splashscreen.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:fridayonline/model/register/userlogin.dart';
import 'package:fridayonline/model/srisawad/register.dart' as srisawad;
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/safearea.dart';
import 'package:fridayonline/service/address/address.dart';
import 'package:fridayonline/service/address/addresssearch.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:fridayonline/service/register_service.dart';
import 'package:fridayonline/service/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/app_controller.dart';
import '../../controller/cart/dropship_controller.dart';
import '../../controller/catelog/catelog_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../controller/lead/lead_controller.dart';
import '../../controller/notification/notification_controller.dart';
import '../../model/register/requestLeadData.dart';
import '../theme/formatter_text.dart';

// เป็นส่วนที่ระบบทำการ
class RegisterSrisawad extends StatefulWidget {
  const RegisterSrisawad(
      {super.key,
      this.urlCheckCustomer,
      this.urlCheckappmkt,
      required this.isB2c});
  final String? urlCheckCustomer;
  final String? urlCheckappmkt;
  final bool isB2c;
  @override
  State<RegisterSrisawad> createState() => _RegisterSrisawadState();
}

class _RegisterSrisawadState extends State<RegisterSrisawad> {
  final _formkey = GlobalKey<FormState>();
  bool isChecked = false;

// ประกกาศตัวแปรในการรับ Text ไว่ทั้งหมด 13 ตัว
  TextEditingController lmrepname = TextEditingController();
  TextEditingController lmsername = TextEditingController();
  TextEditingController lmnickname = TextEditingController();
  TextEditingController lmphonenumber = TextEditingController();
  TextEditingController lmhomenumber = TextEditingController();
  TextEditingController lmProjectCode = TextEditingController();
  TextEditingController lmaddress1 = TextEditingController();
  TextEditingController lmaddress2 = TextEditingController();
  TextEditingController lmtumbon = TextEditingController();
  TextEditingController lmamphur = TextEditingController();
  TextEditingController lmprovince = TextEditingController();
  TextEditingController lmpostcode = TextEditingController();
  TextEditingController lmdistice = TextEditingController();
  List<Body1> body = [];
  Address? newvalue;
  String? master;
  String? districtKey;
  String websiteId = "";

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _myCallback() async {
    bool validate = _formkey.currentState!.validate();

    if (validate) {
      //? กรณีที่ไม่ระบุเขต
      if (isChecked) {
        setState(() {
          checkValidate(validate);
        });
      } else {
        const title = "ฟรายเดย์";
        const description = "กรุณาคลิกยอมรับเงื่อนไขค่ะ";
        alertCheckform(title, description);
      }
    }
  }

  Future<dynamic> alertCheckform(String titleFomrm, String descriptionForm) {
    return showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (context) {
        return alertText(titleFomrm, descriptionForm);
      },
    );
  }

  CustomAlertDialogs alertText(String title2, String description2) {
    return CustomAlertDialogs(title: title2, description: description2);
  }

  LeadRegisterController ch = Get.find<LeadRegisterController>();

  @override
  void initState() {
    super.initState();
    getDefault();
  }

  bool isFormValid = false;
  bool refferReadonly = false;

  getDefault() async {
    SetData data = SetData();
    var refferId = await data.refferId;
    lmdistice.text = refferId;
    if (refferId.isNotEmpty) {
      refferReadonly = true;
    } else {
      refferReadonly = false;
    }
    await ch.lead_project();
    websiteId = "2982";
  }

  void _checkFormValid() {
    final isValid = _formkey.currentState?.validate() ?? false;
    if (isFormValid != isValid) {
      setState(() {
        isFormValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    Get.find<LeadRegisterController>().show.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaProvider(
      child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: PreferredSize(
              preferredSize:
                  const Size.fromHeight(50.0), // here the desired height
              child: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                ),
                backgroundColor: theme_color_df,
                title: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: const Text(
                    "สมัครสมาชิก",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'notoreg',
                    ),
                  ),
                ),
                centerTitle: true,
              )),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Form(
                  key: _formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: _checkFormValid,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // project(),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        introduce(),
                        const SizedBox(
                          height: 12,
                        ),
                        address(),
                        const SizedBox(
                          height: 10,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 18,
                                    margin: const EdgeInsets.only(
                                      right: 8,
                                    ),
                                    child: Checkbox(
                                        side: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade400),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isChecked = value!;
                                          });
                                        }),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          isChecked = !isChecked;
                                        });
                                      },
                                      child: Text("ยอมรับเงื่อนไขสมัครสมาชิก",
                                          style: GoogleFonts.notoSansThai(
                                              fontSize: 14,
                                              color: const Color(0xFF5A5A5A))),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        Get.to(
                                            transition: Transition.rightToLeft,
                                            () => WebViewFullScreen(
                                                mparamurl:
                                                    "$baseurl_yclub/yclub/policyandcondition/agreement.php"));
                                      },
                                      child: Text(
                                        'อ่านข้อตกลงการเป็นสมาชิก',
                                        style: GoogleFonts.notoSansThai(
                                          color: const Color(0xFF5A5A5A),
                                          fontSize: 13,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isFormValid ? _myCallback : null,
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: theme_color_df,
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    child: Text(
                      'ยืนยันข้อมูล',
                      style:
                          GoogleFonts.notoSansThai(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget introduce() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ข้อมูลส่วนตัว',
              style: GoogleFonts.notoSansThai(
                  color: theme_color_df,
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          lableText(title: "ชื่อ"),
          TextFormField(
            controller: lmrepname,
            keyboardType: TextInputType.name,
            validator: Validators.required('กรุณาระบุชื่อผู้สมัคร'),
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('ชื่อ'),
          ),
          const SizedBox(
            height: 10,
          ),
          lableText(title: "นามสกุล"),
          TextFormField(
            controller: lmsername,
            keyboardType: TextInputType.name,
            validator: Validators.required('กรุณาระบุนามสกุลผู้สมัคร'),
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('นามสกุล'),
          ),
          const SizedBox(
            height: 10,
          ),
          lableText(title: "ชื่อเล่น"),
          TextFormField(
            controller: lmnickname,
            keyboardType: TextInputType.name,
            validator: Validators.required('กรุณาระบุชื่อเล่นผู้สมัคร'),
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('ชื่อเล่น'),
          ),
          const SizedBox(
            height: 10,
          ),
          lableText(title: "เบอร์โทรศัพท์มือถือ"),
          TextFormField(
            inputFormatters: [maskFormatterPhone],
            controller: lmphonenumber,
            keyboardType: TextInputType.phone,
            validator: Validators.minLength(12, 'ระบุเบอร์โทรศัพท์ให้ถูกต้อง'),
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('เบอร์โทรศัพท์มือถือ'),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget address() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ที่อยู่สำหรับจัดส่งสินค้า',
              style: GoogleFonts.notoSansThai(
                  color: theme_color_df,
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            maxLines: 3,
            validator: Validators.required('กรุณาระบุที่อยู่ผู้สมัคร'),
            controller: lmaddress1,
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField(
                'กรอกที่อยู่ / เลขที่ห้อง / ตึก / หมู่บ้าน'),
          ),
          const SizedBox(
            height: 10,
          ),
          // TextFormField(
          //   controller: lmaddress2,
          //   style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
          //   decoration: designTextFormField('ถนน'),
          // ),
          // const SizedBox(
          //   height: 8,
          // ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    lableText(title: "ตำบล"),
                    TextFormField(
                      controller: lmtumbon,
                      readOnly: true,
                      onTap: () async {
                        // log('เพิ่มรายการที่อยู่');
                        newvalue = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const Searchaddress()));

                        setState(() {
                          if (newvalue != null) {
                            // log('Data :' + jsonEncode(Body));
                            lmtumbon.text = newvalue!.tumbon;
                            lmamphur.text = newvalue!.amphur;
                            lmprovince.text = newvalue!.province;
                            lmpostcode.text = newvalue!.postCode;
                          }
                        });
                      },
                      validator:
                          Validators.required('กรุณาระบุที่อยู่ผู้สมัคร'),
                      style:
                          const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
                      decoration: designTextFormField('ตำบล'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    lableText(title: "อำเภอ"),
                    TextFormField(
                      controller: lmamphur,
                      readOnly: true,
                      onTap: () async {
                        // log('เพิ่มรายการที่อยู่');
                        newvalue = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const Searchaddress()));

                        setState(() {
                          if (newvalue != null) {
                            // log('Data :' + jsonEncode(Body));
                            lmtumbon.text = newvalue!.tumbon;
                            lmamphur.text = newvalue!.amphur;
                            lmprovince.text = newvalue!.province;
                            lmpostcode.text = newvalue!.postCode;
                          }
                        });
                      },
                      validator:
                          Validators.required('กรุณาระบุที่อยู่ผู้สมัคร'),
                      style:
                          const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
                      decoration: designTextFormField('อำเภอ'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          lableText(title: "จังหวัด"),
          TextFormField(
            controller: lmprovince,
            readOnly: true,
            onTap: () async {
              // log('เพิ่มรายการที่อยู่');
              newvalue = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Searchaddress()));

              setState(() {
                if (newvalue != null) {
                  // log('Data :' + jsonEncode(Body));
                  lmtumbon.text = newvalue!.tumbon;
                  lmamphur.text = newvalue!.amphur;
                  lmprovince.text = newvalue!.province;
                  lmpostcode.text = newvalue!.postCode;
                }
              });
            },
            validator: Validators.required('กรุณาระบุที่อยู่ผู้สมัคร'),
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('จังหวัด'),
          ),
          const SizedBox(
            height: 8,
          ),
          lableText(title: "รหัสผู้แนะนำ"),
          TextFormField(
            readOnly: refferReadonly,
            maxLength: 10,
            buildCounter: (context,
                    {required currentLength, maxLength, required isFocused}) =>
                null,
            controller: lmdistice,
            validator: Validators.required('กรุณาระบุรหัสผู้แนะนำ'),
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('รหัสผู้แนะนำ'),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget lableText({required String title}) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.notoSansThai(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: const Color(0xFF5A5A5A)),
        ),
        const Text(
          ' *',
          style: TextStyle(fontSize: 14, color: Colors.red),
        ),
      ],
    );
  }

  InputDecoration designTextFormField(String lstext) {
    return InputDecoration(
      suffixIcon: lstext == 'ชื่อโครงการ'
          ? Icon(
              Icons.arrow_drop_down,
              color: theme_color_df,
            )
          : null,
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
      hintStyle: TextStyle(color: Colors.grey.shade400),
      // isDense: true, // Added thisr
      enabled: lstext == 'ชื่อโครงการ' ? false : true,
      contentPadding: const EdgeInsets.only(top: 4, left: 12, bottom: 8),
    );
  }

  //? ทำการสมัคร
  checkValidate(validate) async {
    if (validate) {
      body.clear();
      if (lmphonenumber.text.replaceAll(RegExp(r'[^0-9\.]'), '').length != 10) {
        alertCheckform('ฟรายเดย์', 'กรุณากรอกเบอร์โทรศัพท์ให้ครบ');
      } else {
        srisawad.Address address = srisawad.Address(
          province: lmprovince.text,
          provinceCode: newvalue!.provinceID,
          amphur: lmamphur.text,
          amphurCode: newvalue!.amphurID,
          address: lmaddress1.text,
          tambon: lmtumbon.text,
          tambonCode: newvalue!.tumbonID,
          postalCode: lmpostcode.text,
        );

        srisawad.SrisawadRegister payload = srisawad.SrisawadRegister(
          name: lmrepname.text,
          surname: lmsername.text,
          nickname: lmnickname.text,
          phone1: lmphonenumber.text.replaceAll(RegExp(r'[^0-9\.]'), ''),
          phone2: lmhomenumber.text.replaceAll(RegExp(r'[^0-9\.]'), ''),
          address: address,
          typeRegister: '0',
          pdpaMkt: widget.urlCheckappmkt.toString(),
          pdpaCustomer: widget.urlCheckCustomer.toString(),
          pathImg: '',
          tokenId: '',
          device: '',
          linkId: lmdistice.text,
          webId: websiteId,
          referralCode: lmdistice.text,
        );

        // printJSON(payload);
        // return;

        Get.find<LeadRegisterController>().register_srisawad(payload);
        //? สำเร็จแสดง popup
        showModalBottomSheet(
          enableDrag: false,
          isDismissible: false,
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0))),
          builder: (builder) {
            double width = MediaQuery.of(context).size.width;
            return SafeAreaProvider(
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: PopScope(
                    onPopInvoked: (canpop) async => false,
                    child: GetBuilder<LeadRegisterController>(
                        builder: (dataResponse) {
                      if (dataResponse.isDataLoading.value) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 330,
                              child: Lottie.asset(
                                  width: 180,
                                  'assets/images/loading_line.json'),
                            ),
                          ],
                        );
                      } else {
                        if (dataResponse.leadRegis!.code == '100') {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Lottie.asset(
                                    width: 230,
                                    height: 230,
                                    'assets/images/cart/success_lottie.json'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    dataResponse.leadRegis!.message,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: width / 1.3,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: theme_color_df),
                                        onPressed: () async {
                                          final Future<SharedPreferences>
                                              prefs =
                                              SharedPreferences.getInstance();
                                          final SharedPreferences pref =
                                              await prefs;
                                          await pref.remove("refferSrisawad");
                                          SetData data = SetData();
                                          User user = User(
                                              dataResponse.leadRegis!.repCode,
                                              lmphonenumber.text,
                                              await data.device,
                                              await data.tokenId,
                                              '9999');
                                          var mslregist =
                                              await MslReGiaterAppliction(user);
                                          if (mslregist.value.success == '1') {
                                            settingsPreferences(
                                              mslregist.value.repSeq,
                                              mslregist.value.repCode,
                                              mslregist.value.repName,
                                              '',
                                              '2',
                                            );
                                          }
                                        },
                                        child: const Text(
                                          textAlign: TextAlign.center,
                                          'ตกลง',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Lottie.asset(
                                    width: 160,
                                    height: 160,
                                    'assets/images/warning_red.json'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    dataResponse.leadRegis!.message,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: width / 1.3,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: theme_color_df),
                                        onPressed: () async {
                                          final Future<SharedPreferences>
                                              prefs =
                                              SharedPreferences.getInstance();
                                          final SharedPreferences pref =
                                              await prefs;
                                          await pref
                                              .setString("refferSrisawad", "")
                                              .then((res) {
                                            Get.offAll(
                                                () => const SplashScreen());
                                          });
                                        },
                                        child: const Text(
                                          textAlign: TextAlign.center,
                                          'ตกลง',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      }
                    }),
                  ),
                );
              }),
            );
          },
        );
      }
    }
  }

  settingsPreferences(
    repSeq,
    repCode,
    repName,
    repTel,
    typeUser,
  ) async {
    final SharedPreferences prefs = await _prefs;
    // ทำการ Get Data ออกมาทำการตรวจสอบก่อน
    // กรณีที่ทำการ Set Data
    await prefs.setString("login", '1');
    await prefs.setString("RepSeq", repSeq.toString());
    await prefs.setString("RepCode", repCode);
    await prefs.setString("RepName", repName);
    await prefs.setString("RepTel", repTel);
    await prefs.setString("UserType", typeUser);
    // กรณีที่ทำการจัดเก็บ EndUserID
    // await prefs.setString("EndUserID", endUserID.toString());
    // await prefs.setString("EnduserName", enduserName);
    // await prefs.setString("Endusersurname", endusersurname);
    // await prefs.setString("EnduserTel", enduserTel);
    // ลบ referrer
    await prefs.setString("refferSrisawad", "");

    // ระบบ Set กลับไปที่หน้า Page หลักก่อน  หรือจะให้ไปแสดงที่หน้าจอ Profile เลย
    Get.find<AppController>().setCurrentNavInget(0);
    Get.find<DraggableFabController>().draggable_Fab();
    Get.find<BannerController>().get_banner_data();
    Get.find<FavoriteController>().get_favorite_data();
    Get.find<SpecialPromotionController>().get_promotion_data();
    // Get.find<SpecialDiscountController>().fetch_special_discount();
    Get.find<ProductHotItemHomeController>().get_product_hotitem_data();
    Get.find<ProductHotIutemLoadmoreController>().resetItem();
    Get.find<CatelogController>().get_catelog();
    Get.find<NotificationController>().get_notification_data();
    Get.find<FlashsaleTimerCount>().flashSaleHome();
    Get.find<BadgerController>().get_badger();
    Get.find<BadgerProfileController>().get_badger_profile();
    Get.find<BadgerController>().getBadgerMarket();
    Get.find<FetchCartDropshipController>().fetchCartDropship();

    // กลับไปที่หน้าหลัก
    Get.offAll(() => const SplashScreen());
  }
}
