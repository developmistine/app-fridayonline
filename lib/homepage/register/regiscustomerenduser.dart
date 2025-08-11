// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:async';
// import 'dart:developer';

import 'package:fridayonline/homepage/login/anonymous_login.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
// import 'package:fridayonline/homepage/register/otp.dart';
import 'package:fridayonline/service/otpservice/otpenduserobject.dart';
import 'package:fridayonline/service/otpservice/otpservice.dart';
import 'package:fridayonline/service/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/register/objectconfirmotp.dart';
import '../../service/registermember/registermember.dart';
import '../dialogalert/CustomAlertDialogs.dart';
import '../theme/formatter_text.dart';
// import 'enduserregisterprofile.dart';

class EndCustomerRegister extends StatefulWidget {
  final String repCode;

  const EndCustomerRegister({super.key, required this.repCode});

  @override
  State<EndCustomerRegister> createState() => _EndCustomerRegisterState();
}

class _EndCustomerRegisterState extends State<EndCustomerRegister> {
  bool buttonshow = true;
  final _formkey = GlobalKey<FormState>();
  TextEditingController lmphonenumber = TextEditingController();
  var flagBackToHomepage = Get.arguments;

  void _myCallback() async {
    String lstelnumber;
    String values;
    bool validate = _formkey.currentState!.validate();
    //log(validate.toString());
    if (validate) {
      // ทำการตรวจสอบเบอร์โทรศัพท์ก่อน  กรณีที่เบอร์โทรศัพท์นั้นเก็บเบอร์โทรไว้
      //log(lmphonenumber.text);
      // ระบบ Call ไปที่ API
      lstelnumber =
          lmphonenumber.text.trim().replaceAll(RegExp(r'[^0-9\.]'), '');

      // Call ไปที่ API
      // ดำเนินการ FIX หมายเลขไว้
      // lstelnumber  = '0953640727';  ทำการปิดรายละเอียดที่อยู่ในส่น\
      // log('Tel Number' +lstelnumber);
      Otpenduserobject enduserotp = await postotpENDUSER(lstelnumber);
      setState(() {
        values = enduserotp.values;

        if (values == "001") {
          print('001$values');
          // กรณีที่ดำเนินการส่ง Data ไปที่ระบบ OTP
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) => Otp(lstelnumber)),
          // );
          startOTP(lstelnumber);
        }
      });
    }
  }

  /// *************************
  int liloop = 0;
  Timer? countdownTimer;
  Duration myDuration = const Duration(days: 5);
  late String TelNumber = '';
  late String lsotp1 = ''; // OTP ตัวที่ 1
  late String lsotp2 = ''; // OTP ตัวที่ 2
  late String lsotp3 = ''; // OTP ตัวที่ 3
  late String lsotp4 = ''; // OTP ตัวที่ 4

  // ส่วนที่ดำเนินการจัดเก็บ UserID
  late String lsuserID = '';

  startOTP(lstelnumber) {
    startTimer();
    // รับเบอร์โทรศัพท์มาจากหน้าจอแรก
    TelNumber = lstelnumber;
    // ส่วนที่ดำเนินการเพื่อที่จะทำการ SetData เพื่อที่จะทำการ Set Data
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  // Step 6
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  // ส่วนที่ระบบทำการ Call มาที่ Event การทำงานของระบบ
  // กรณี
  void _myCallback1() async {
    // เป็นส่วนที่ระบบดำเนินการ Set
    String lspushotp = lsotp1 + lsotp2 + lsotp3 + lsotp4;
    // log(lspushotp);
    // ทำการตรวจสอบ หากกรณีข้อมูลที่ป้อนมานั้นถูกต้อง ระบบจะต้องเปิดอีกหน้าถัดไป
    if (lspushotp.length == 4 && lspushotp != "") {
      // ทำการรวจสอบตัวเลข API ก่อนว่าส่วนนี้มีการระบุ
      Checkotp checkotp = await CheckOTP(TelNumber, lspushotp);
      if (checkotp.values == '100') {
        // เป็นส่วนที่ระบบทำการ Set ข้อมูลส่วนต่างๆ
        // กรณีที่ทำการ Get ID  จาก OTP
        countdownTimer!.cancel();
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           EndUserRegisterProfile(TelNumber, lspushotp)),
        // );
      } else {
        // กรณีที่ OTP นั้นไม่ถูกต้อง  หรือว่า API มีปัญหาในการเชื่อมต่อข้อมูล
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

  // Call Gen OTP agin
  void _myCalloptagin() async {
    String values;
    stopTimer();
    liloop = 0;
    Otpenduserobject enduserotp = await postotpENDUSER(TelNumber);
    values = enduserotp.values;
    if (values == "001") {
      startTimer();
      //  log('ขออีกครั้ง');
    }
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = strDigits(myDuration.inSeconds.remainder(180));
    int litime = int.parse(seconds.toString());
    if (lmphonenumber == '') {
      liloop = liloop + 1;
      // log('5555555');
      print(seconds.toString());
      if (litime == 0 && liloop > 1) {
        print('Close$seconds');
        stopTimer();
        //log('666666');
      }
    }

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
                    if (flagBackToHomepage == "Y") {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Anonumouslogin()));
                    }
                  }),
              backgroundColor: theme_color_df,
              title: const Text(
                "ลูกค้าของสมาชิก",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'notoreg',
                ),
              ),
              centerTitle: true,
            )),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                child: Column(
                  children: [
                    const Text(
                      'ลูกค้าลงทะเบียนเข้าระบบ',
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
                          controller: lmphonenumber,
                          keyboardType: TextInputType.phone,
                          validator: Validators.minLength(
                              10, 'กรุณาระบุเบอร์โทรศัพท์ 10 หลัก'),

                          // กรณีที่ทำการระบุเบอร์โทรศัพท์
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
                            // labelText: "กรอกเบอร์โทรศัพท์",
                          ),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              _myCallback();
                            },
                            style: ButtonStyle(
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  theme_color_df),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text(
                                'ขอรหัสผ่าน',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'notoreg',
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'ยืนยันรหัสจาก SMS',
                      style: TextStyle(fontSize: 20, fontFamily: 'notoreg'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "รหัสจะหมดเวลาภายใน",
                            style: TextStyle(
                                fontSize: 14,
                                color: theme_color_df,
                                fontFamily: 'notoreg'),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            seconds,
                            style: TextStyle(
                                fontFamily: 'notoreg',
                                color: theme_color_df,
                                fontSize: 25),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                              onPressed: _myCallback1,
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all<Color>(
                                    Colors.white),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    theme_color_df),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  'ยืนยัน',
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
                      height: 18,
                    ),
                    const Text(
                      "ขอใหม่อีกครั้งหากรหัสหมดอายุ หรือจำรหัสไม่ได้ ?",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                          fontFamily: 'notoreg'),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            print('_myCalloptagin');
                          },
                          child: Text(
                            'กดขอรหัสผ่านอีกครั้ง',
                            style: TextStyle(
                              color: theme_color_df,
                              fontFamily: 'notoreg',
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                //   log('C' + value.toString());
                lsotp4 = value; // Data ช่องที่ 4
              });
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
