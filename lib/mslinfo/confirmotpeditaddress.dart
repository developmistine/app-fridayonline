// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';
// import 'dart:developer';

import 'package:fridayonline/controller/app_controller.dart';
// import 'package:fridayonline/controller/catelog/catelog_controller.dart';
import 'package:fridayonline/homepage/dialogalert/customalertdialogs.dart';
import 'package:fridayonline/homepage/myhomepage.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/model/objecteditaddress/objecteditaddress.dart';
import 'package:fridayonline/model/register/objectconfirmotp.dart';
import 'package:fridayonline/mslinfo/editaddressdetail.dart';
import 'package:fridayonline/service/mslinfo/editaddressregist.dart';
import 'package:fridayonline/service/otpservice/otpenduserobject.dart';
import 'package:fridayonline/service/otpservice/otpservice.dart';
import 'package:fridayonline/service/profileuser/getprofile.dart';
import 'package:fridayonline/service/profileuser/mslinfo.dart';
import 'package:fridayonline/service/registermember/registermember.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// เป็นหน้าจอในส่วนของการดำเนินการยืนยัน OTP ในการย้ายที่อยู่ในการลงทะเบียน
class ConfirmOTPAddress extends StatefulWidget {
  String? option = '';
  String? address = '';
  String? tumbon = '';
  String? tumbonID = '';
  String? amphur = '';
  String? amphurID = '';
  String? province = '';
  String? provinceID = '';
  String? postCode = '';
  ConfirmOTPAddress(this.option, this.address, this.tumbon, this.tumbonID,
      this.amphur, this.amphurID, this.province, this.provinceID, this.postCode,
      {super.key});

  @override
  State<ConfirmOTPAddress> createState() => _ConfirmOTPAddressState();
}

class _ConfirmOTPAddressState extends State<ConfirmOTPAddress> {
  int liloop = 0;
  Timer? countdownTimer;
  Duration myDuration = const Duration(days: 5);

  late String lsotp1 = ''; // OTP ตัวที่ 1
  late String lsotp2 = ''; // OTP ตัวที่ 2
  late String lsotp3 = ''; // OTP ตัวที่ 3
  late String lsotp4 = ''; // OTP ตัวที่ 4

  String option = '';
  String RepSeq = '';
  String RepCode = '';
  String Telnumber = '';
  String Telresult = '';
  String address = '';
  String tumbon = '';
  String tumbonID = '';
  String amphur = '';
  String amphurID = '';
  String province = '';
  String provinceID = '';
  String postCode = '';

  @override
  void initState() {
    super.initState();
    // TODO: implement
    stopTimer();
    loadmslinfo();
    SetInfomation();
  }

  // ดำเนินการ Set ตัวแปลที่มาจาก Infomation เพื่อที่จะทำการกำหนดข้อมูล
  // เป็นส่วนที่ดำเนินการ Set
  void SetInfomation() {
    print('option$option');
    setState(() {
      option = widget.option!;
      address = widget.address!;
      tumbon = widget.tumbon!;
      tumbonID = widget.tumbonID!;
      amphur = widget.amphur!;
      amphurID = widget.amphurID!;
      province = widget.province!;
      provinceID = widget.provinceID!;
      postCode = widget.postCode!;
    });
  }

  // ตั้งค่าเริ่มต้น
  // กรณีที่ทำการ Load
  void loadmslinfo() async {
    Mslinfo enduserotp = await getProfileMSL();
    setState(() {
      // จากนั้นระบบดำเนินการ Get Data ออกมาจาก Object
      // ทำการ SET DATA OBJECT
      RepSeq = enduserotp.mslInfo.repSeq;
      RepCode = enduserotp.mslInfo.repCode;
      Telnumber = enduserotp.mslInfo.telnumber;
      //log('length${Telnumber.length}');
      if (Telnumber.length == 10) {
        Telresult = '0XX-XXX-${Telnumber.substring(6)}';
      }
    });
  }

  void startTimer() {
    try {
      countdownTimer =
          Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
      //  log('$tokenApp');
    } catch (error) {
      // print("Can not get Token");
    }
  }

  // Step 4
  void stopTimer() {
    try {
      setState(() => countdownTimer!.cancel());
      //  log('$tokenApp');
    } catch (error) {
      // print("Can not get Token");
    }
  }

  // Step 6
  void setCountDown() {
    const reduceSecondsBy = 1;
    try {
      setState(() {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    } catch (e) {}
  }

  // เป็น Service ที่ทำการ Call ไปที่ API ทั้งหมดเพื่อที่จะดำเนินการประมวลผลข้อมูล
  void _myCallback() async {
    //startTimer();
    _myCalloptagin();
  }

  //
  void _myCalloptagin() async {
    String values;
    liloop = 0;
    Otpenduserobject enduserotp = await postotpENDUSER(Telnumber);
    values = enduserotp.values;
    if (values == "001") {
      startTimer();
      //  log('ขออีกครั้ง');
    }
  }

  // String Otp1,String Otp2,String Otp3,String Otp4
  // เป็นส่วนที่ทำการ Call Service เพื่อที่จะทำการ Register Edit Address
  void _CallPostRegisterEditAddress(
      String lsotp1, String lsotp2, String lsotp3, String lsotp4) async {
    // ส่วนที่ทำการ Call  API ในส่วนของการ Edit ข้อมูลที่อยู่ในระบบ

    String lspushotp =
        lsotp1.trim() + lsotp2.trim() + lsotp3.trim() + lsotp4.trim();
    // ระบบดำเนินการตรวจสอบที่ OTP ถูกต้องหรือไม่
    if (lspushotp.length == 4 && lspushotp != "") {
      Checkotp checkotp = await CheckOTP(Telnumber, lspushotp);
      if (checkotp.values == '100') {
        // กรณีที่  OTP แสดงรายละเอียดเข้ามา
        // ทำการ Call  API เพื่อที่จะทำการ Insert Data
        Objectreturneditaddress objectenduser = await EditAddressData(
            option,
            address,
            provinceID,
            amphurID,
            tumbonID,
            province,
            amphur,
            tumbon,
            postCode);

        if (objectenduser.code == '100') {
          showDialog(
            barrierColor: Colors.black26,
            context: context,
            builder: (context) {
              return const CustomAlertDialogs(
                title: "แจ้งข้อมูล",
                description: "ทำการแก้ไขที่อยู่สำเร็จ",
              );
            },
          ).then((val) {
            Get.find<AppController>().setCurrentNavInget(0);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          });
        } else {
          // กรณีที่ทำการ  INSERT ไม่สำเร็จ
          showDialog(
            barrierColor: Colors.black26,
            context: context,
            builder: (context) {
              return CustomAlertDialogs(
                title: "แจ้งเตือน",
                description: objectenduser.message,
              );
            },
          ).then((val) {
            // myFocusNode.requestFocus();
            return;
          });
        }
      } else {
        // กรณีที่ทำการตรวจสอบแล้ว OTP แสดงไม่ถูกต้อง
        showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (context) {
            return CustomAlertDialogs(
              title: "แจ้งข้อมูล",
              description: checkotp.message,
            );
          },
        ).then((val) {
          // myFocusNode.requestFocus();
          return;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = strDigits(myDuration.inSeconds.remainder(120));
    int litime = int.parse(seconds.toString());
    liloop = liloop + 1;
    // log('5555555');
    if (litime == 0 && liloop > 1) {
      // log(seconds.toString());
      stopTimer();
      //log('666666');
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), // here the desired height
          child: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  stopTimer(); // ทำการ Stop Time ก่อนที่จะทำการกลับไป
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => editaddressdetail(option)));
                }),
            backgroundColor: theme_color_df,
            title: const Text(
              "ยืนยันรหัส OTP-SMS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'notoreg',
              ),
            ),
            centerTitle: true,
          )),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff7f6fb),
      body: SingleChildScrollView(
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                // ดำเนินการระบุ Row ที่เป็นในส่วนของ Header
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'OTP-SMS จะถูกส่งไปที่หมายเลข',
                        style: TextStyle(fontSize: 20, fontFamily: 'notoreg'),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Telresult,
                        style: const TextStyle(
                            fontSize: 20, fontFamily: 'notoreg'),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // เป็นส่วนของกรอบที่จะดำเนินการระบุ OTP เข้ามา
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text('กรุณาใส่รหัส OTP-SMS ที่ได้รับ',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'notoreg',
                          color: Colors.red)),
                ),
                const Text('รหัส OTP จะหมดอายุใน 3 นาทีหลังจากทำการขอรหัส',
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'notoreg',
                        color: Colors.red)),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(seconds,
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'notoreg',
                              color: theme_color_df))
                    ],
                  ),
                ),
                // จากนั้นดำเนินการเพื่อที่จะทำการแสดงในการที่จะระบุช่องในการแจ้ง OTP
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _textFieldOTP(
                              first: true,
                              last: false,
                              indexpara: 1), // ช่อง Parameter 1
                          _textFieldOTP(
                              first: false,
                              last: false,
                              indexpara: 2), // ช่อง Parameter 2
                          _textFieldOTP(
                              first: false,
                              last: false,
                              indexpara: 3), // ช่อง Parameter 3
                          _textFieldOTP(
                              first: false,
                              last: true,
                              indexpara: 4), // ช่อง Parameter 4
                        ],
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _myCallback,
                          style: ButtonStyle(
                            foregroundColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                WidgetStateProperty.all<Color>(theme_color_df),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'กดขอรหัส OTP-SMS',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: 'notoreg'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // ROW ในส่วนของการระบุ TEXT
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Text(
                          "การแก้ไขที่อยู่จะสมบูรณ์เมื่อทำการยืนยันผ่าน OTP-SMS ซึ่งจะส่งไปยังเบอร์มือถือที่ลงทะเบียนไว้กับระบบตอนสมัครสมาชิก",
                          style: TextStyle(fontSize: 16, fontFamily: 'notoreg'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                // ROW ในส่วนของการระบุ TEXT
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Text(
                          "กรณีที่ไม่สามารถทำรายการได้ กรุณาติดต่อ คอลเซ็นเตอร์",
                          style: TextStyle(fontSize: 16, fontFamily: 'notoreg'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                // ROW ในส่วนของการระบุ TEXT
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "02-118-5111",
                      style: TextStyle(fontSize: 20, fontFamily: 'notoreg'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ส่วนที่ระบบระบุ OTP เข้ามาเพื่อแจ้งการทำงาน

  Widget _textFieldOTP({required bool first, last, required int indexpara}) {
    return SizedBox(
      height: 60,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            // เป็นส่วนที่ระบบทำการ Data Value ออกมา
            if (value.length == 1 && last == false) {
              // log('A' + value.toString());
              setState(() {
                if (indexpara == 1 && value != "") {
                  lsotp1 = value; // Data ช่องที่ 1
                } else if (indexpara == 2 && value != "") {
                  lsotp2 = value; // Data ช่องที่ 2
                } else if (indexpara == 3 && value != "") {
                  lsotp3 = value; // Data ช่องที่ 3
                } else if (indexpara == 4 && value != "") {
                  lsotp4 = value; // Data ช่องที่ 4
                }
              });
              // ส่วนของการดำเนินการ โดยการ Set
              FocusScope.of(context).nextFocus();
            } else if (value.isEmpty && first == false) {
              // log('B' + value.toString());
              FocusScope.of(context).previousFocus();
            } else if (value.length == 1 && indexpara == 4) {
              setState(() {
                lsotp4 = value; // Data ช่องที่ 4
              });
            }

            // ทำการตรวจสอบก่อนว่าได้เอาตัวสุดท้ายเข้ามาหรือไม่
            // กรณีที่เข้ามานั้นให้ระบบทำการ POPUP ออกไปเลย
            if (lsotp1 != '' && lsotp2 != '' && lsotp3 != '' && lsotp4 != '') {
              // เป็นที่ทำการ Call ไปที่ API
              try {
                _CallPostRegisterEditAddress(lsotp1, lsotp2, lsotp3, lsotp4);
              } catch (error) {
                // กรณีที่ทำการแสดง Error
              }
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.phone,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: theme_color_df),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
