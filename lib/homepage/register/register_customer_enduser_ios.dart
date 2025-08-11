// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, non_constant_identifier_names, must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:fridayonline/homepage/login/anonymous_login.dart';
import 'package:fridayonline/service/otpservice/otpenduserobject.dart';
import 'package:fridayonline/service/otpservice/otpservice.dart';
import 'package:fridayonline/service/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import '../../model/register/objectconfirmotp.dart';
import '../../model/register/otp_check_name.dart';
import '../../service/registermember/registermember.dart';
import '../dialogalert/CustomAlertDialogs.dart';
import '../theme/formatter_text.dart';
import '../theme/theme_color.dart';
import 'enduserregisterprofile.dart';

class EndCustomerRegisterIos extends StatefulWidget {
  EndCustomerRegisterIos(
      {super.key, this.repCode, this.flagBackToHome, this.linkId});
  var repCode;
  var flagBackToHome;
  var linkId;

  @override
  State<EndCustomerRegisterIos> createState() => _EndCustomerRegisterIosState();
}

class _EndCustomerRegisterIosState extends State<EndCustomerRegisterIos> {
  final focus = FocusNode();
  bool buttonshow = true;
  TextEditingController lmphonenumber = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var flagBackToHomepage = Get.arguments;
  var phone_show = 'xxx-xxx-xxxx';

  void _myCallback(value) async {
    String lstelnumber;
    String values;
    bool validate = _formkey.currentState!.validate();
    if (validate) {
      lstelnumber = value.replaceAll(RegExp(r'[^0-9\.]'), '');
      Otpenduserobject enduserotp = await postotpENDUSER(lstelnumber);
      setState(() {
        values = enduserotp.values;
        phone_show = value;
        if (values == "001") {
          show_time = true;
          controller.clear();
          startOTP(lstelnumber);
          FocusScope.of(context).requestFocus(focus);
        }
      });
    }
  }

  /// *************************
  int liloop = 0;
  Timer? countdownTimer;
  Duration myDuration = const Duration(days: 5);
  late String TelNumber = '';
  // late Timer _timer;
  int _start = 0;
  bool show_time = false;

  // ส่วนที่ดำเนินการจัดเก็บ UserID
  late String lsuserID = '';

  startOTP(lstelnumber) {
    _start = 180;
    startTimer();

    // รับเบอร์โทรศัพท์มาจากหน้าจอแรก
    TelNumber = lstelnumber;
    // ส่วนที่ดำเนินการเพื่อที่จะทำการ SetData เพื่อที่จะทำการ Set Data
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  // ส่วนที่ระบบทำการ Call มาที่ Event การทำงานของระบบ
  // กรณี
  void _myCallback1(value) async {
    // เป็นส่วนที่ระบบดำเนินการ Set
    String lspushotp = value;
    // log(lspushotp);
    // ทำการตรวจสอบ หากกรณีข้อมูลที่ป้อนมานั้นถูกต้อง ระบบจะต้องเปิดอีกหน้าถัดไป
    if (lspushotp.length == 4 && lspushotp != "") {
      // ทำการรวจสอบตัวเลข API ก่อนว่าส่วนนี้มีการระบุ
      Checkotp checkotp = await CheckOTP(TelNumber, lspushotp);
      if (checkotp.values == '100') {
        // เป็นส่วนที่ระบบทำการ Set ข้อมูลส่วนต่างๆ
        // กรณีที่ทำการ Get ID  จาก OTP
        setState(() {
          _start = 0;
          show_time = false;
        });

        OtpCheckName data = await checkOTPName(TelNumber);

        if ((data.repCoderef == "") && (widget.flagBackToHome == "Y")) {
          data.repCoderef = widget.repCode;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => EndUserRegisterProfile(
                  TelNumber,
                  lspushotp,
                  data.enduserName,
                  data.endusersurname,
                  data.repCoderef,
                  widget.linkId ?? "")),
        );
      } else {
        controller.clear();
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

  TextEditingController controller = TextEditingController(text: "");
  @override
  void dispose() {
    controller.dispose();
    //_timer.cancel();
    super.dispose();
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
                          autofocus: true,
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
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              _myCallback(lmphonenumber.text);
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
                            "OTP ส่ง SMS ไปที่หมายเลข \n $phone_show",
                            style: const TextStyle(
                                fontSize: 16, fontFamily: 'notoreg'),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          PinCodeTextField(
                            focusNode: focus,
                            controller: controller,
                            pinBoxRadius: 10,
                            highlight: true,
                            highlightColor: theme_color_df,
                            defaultBorderColor: Colors.grey,
                            hasTextBorderColor: Colors.grey,
                            maxLength: 4,
                            onDone: (text) {
                              _myCallback1(text);
                            },
                            pinBoxWidth: 50,
                            pinBoxHeight: 50,
                            pinTextStyle: const TextStyle(fontSize: 22.0),
                            keyboardType: TextInputType.number,
                          ),
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
                          if (show_time == true)
                            Text(
                              "รหัสจะหมดเวลาภายใน $_start",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontFamily: 'notoreg'),
                              textAlign: TextAlign.center,
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
