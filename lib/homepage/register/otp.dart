// // ignore_for_file: use_build_context_synchronously

// import 'dart:async';
// import 'dart:developer';
// import 'package:fridayonline/homepage/dialogalert/CustomAlertDialogs.dart';
// import 'package:fridayonline/homepage/register/enduserregisterprofile.dart';
// import 'package:fridayonline/homepage/register/regiscustomerenduser.dart';
// import 'package:fridayonline/homepage/theme/theme_color.dart';
// import 'package:fridayonline/model/register/objectconfirmotp.dart';
// import 'package:fridayonline/service/otpservice/otpenduserobject.dart';
// import 'package:fridayonline/service/otpservice/otpservice.dart';
// import 'package:fridayonline/service/registermember/registermember.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:otp_text_field/otp_field.dart';
// import 'package:otp_text_field/style.dart';
// import 'package:pin_code_text_field/pin_code_text_field.dart';

// // ทำการรับตัวเลขที่เป็น เป็น String มา
// class Otp extends StatefulWidget {
//   String lstelNumber;
//   Otp(this.lstelNumber, {Key? key}) : super(key: key);

//   @override
//   State<Otp> createState() => _OtpState();
// }

// class _OtpState extends State<Otp> {
//   int liloop = 0;
//   Timer? countdownTimer;
//   Duration myDuration = const Duration(days: 5);
//   late String TelNumber = '';
//   late String lsotp1 = ''; // OTP ตัวที่ 1
//   late String lsotp2 = ''; // OTP ตัวที่ 2
//   late String lsotp3 = ''; // OTP ตัวที่ 3
//   late String lsotp4 = ''; // OTP ตัวที่ 4

//   // ส่วนที่ดำเนินการจัดเก็บ UserID
//   late String lsuserID = '';

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//     // รับเบอร์โทรศัพท์มาจากหน้าจอแรก
//     TelNumber = widget.lstelNumber;
//     // ส่วนที่ดำเนินการเพื่อที่จะทำการ SetData เพื่อที่จะทำการ Set Data
//   }

//   void startTimer() {
//     countdownTimer =
//         Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
//   }

//   // Step 4
//   void stopTimer() {
//     print('end loop');
//     setState(() => countdownTimer!.cancel());
//   }

//   // Step 6
//   void setCountDown() {
//     final reduceSecondsBy = 1;
//     setState(() {
//       final seconds = myDuration.inSeconds - reduceSecondsBy;
//       if (seconds < 0) {
//         countdownTimer!.cancel();
//       } else {
//         myDuration = Duration(seconds: seconds);
//       }
//     });
//   }

//   // ส่วนที่ระบบทำการ Call มาที่ Event การทำงานของระบบ
//   // กรณี
//   void _myCallback1() async {
//     // เป็นส่วนที่ระบบดำเนินการ Set
//     String lspushotp = lsotp1 + lsotp2 + lsotp3 + lsotp4;
//     // log(lspushotp);
//     // ทำการตรวจสอบ หากกรณีข้อมูลที่ป้อนมานั้นถูกต้อง ระบบจะต้องเปิดอีกหน้าถัดไป
//     if (lspushotp.length == 4 && lspushotp != null) {
//       // ทำการรวจสอบตัวเลข API ก่อนว่าส่วนนี้มีการระบุ
//       Checkotp checkotp = await CheckOTP(TelNumber, lspushotp);
//       if (checkotp.values == '100') {
//         // เป็นส่วนที่ระบบทำการ Set ข้อมูลส่วนต่างๆ
//         // กรณีที่ทำการ Get ID  จาก OTP
//         countdownTimer!.cancel();
//         Navigator.of(context).push(
//           MaterialPageRoute(
//               builder: (context) =>
//                   EndUserRegisterProfile(TelNumber, lspushotp)),
//         );
//       } else {
//         // กรณีที่ OTP นั้นไม่ถูกต้อง  หรือว่า API มีปัญหาในการเชื่อมต่อข้อมูล
//         showDialog(
//           barrierColor: Colors.black26,
//           context: context,
//           builder: (context) {
//             return CustomAlertDialogs(
//               title: "แจ้งข้อมูล",
//               description: checkotp.message,
//             );
//           },
//         ).then((val) {
//           // myFocusNode.requestFocus();
//           return;
//         });
//       }
//     }
//   }

//   // Call Gen OTP agin
//   void _myCalloptagin() async {
//     String values;
//     stopTimer();
//     liloop = 0;
//     Otpenduserobject enduserotp = await postotpENDUSER(TelNumber);
//     values = enduserotp.values;
//     if (values == "001") {
//       startTimer();
//       //  log('ขออีกครั้ง');
//     }
//   }

//   final text1 = TextEditingController();
//   final text2 = TextEditingController();

//   TextEditingController controller = TextEditingController(text: "1234");
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String strDigits(int n) => n.toString().padLeft(2, '0');
//     final seconds = strDigits(myDuration.inSeconds.remainder(20));
//     int litime = int.parse(seconds.toString());
//     liloop = liloop + 1;
//     // log('5555555');
//     log(seconds.toString());
//     if (litime == 0 && liloop > 1) {
//       //log('Close' + seconds.toString());
//       stopTimer();
//       //log('666666');
//     }

//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(50.0), // here the desired height
//           child: AppBar(
//             leading: IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () {
//                   stopTimer();
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => EndCustomerRegister()));
//                 }),
//             backgroundColor: const Color(0xFF2EA9E1),
//             title: const Text(
//               "ระบุรหัสจาก SMS",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontFamily: 'notoreg',
//               ),
//             ),
//             centerTitle: true,
//           )),
//       resizeToAvoidBottomInset: false,
//       backgroundColor: const Color(0xfff7f6fb),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
//           child: Column(
//             children: [
//               PinCodeTextField(
//                 autofocus: true,
//                 controller: controller,
//                 pinBoxRadius: 10,
//                 highlight: true,
//                 highlightColor: theme_color_df,
//                 defaultBorderColor: Colors.grey,
//                 hasTextBorderColor: Colors.grey,
//                 maxLength: 4,
//                 onTextChanged: (text) {
//                   setState(() {
//                     // hasError = false;
//                   });
//                 },
//                 onDone: (text) {
//                   print("DONE $text");
//                   print("DONE CONTROLLER ${controller.text}");
//                 },
//                 pinBoxWidth: 50,
//                 pinBoxHeight: 50,
//                 pinTextStyle: TextStyle(fontSize: 22.0),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               const Text(
//                 'ยืนยันรหัสจาก SMS',
//                 style: TextStyle(fontSize: 20, fontFamily: 'notoreg'),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text(
//                 "รหัสจะหมดเวลาภายใน",
//                 style: TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF2EA9E1),
//                     fontFamily: 'notoreg'),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Text(
//                 seconds,
//                 style: const TextStyle(
//                     fontFamily: 'notoreg',
//                     color: Color(0xFF2EA9E1),
//                     fontSize: 25),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // _textFieldOTP(
//                         //     first: true,
//                         //     last: false,
//                         //     indexpara: 1), // ช่อง Parameter 1
//                         // _textFieldOTP(
//                         //     first: false,
//                         //     last: false,
//                         //     indexpara: 2), // ช่อง Parameter 2
//                         // _textFieldOTP(
//                         //     first: false,
//                         //     last: false,
//                         //     indexpara: 3), // ช่อง Parameter 3
//                         // _textFieldOTP(
//                         //     first: false,
//                         //     last: true,
//                         //     indexpara: 4), // ช่อง Parameter 4
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 22,
//                     ),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _myCallback1,
//                         style: ButtonStyle(
//                           foregroundColor:
//                               MaterialStateProperty.all<Color>(Colors.white),
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                               const Color(0xFF2EA9E1)),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(24.0),
//                             ),
//                           ),
//                         ),
//                         child: const Padding(
//                           padding: EdgeInsets.all(14.0),
//                           child: Text(
//                             'ยืนยัน',
//                             style:
//                                 TextStyle(fontSize: 16, fontFamily: 'notoreg'),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 18,
//               ),
//               const Text(
//                 "ขอใหม่อีกครั้งหากรหัสหมดอายุ หรือจำรหัสไม่ได้ ?",
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black38,
//                     fontFamily: 'notoreg'),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 18,
//               ),
//               Container(
//                   alignment: Alignment.center,
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       textStyle: const TextStyle(
//                         fontSize: 18,
//                       ),
//                     ),
//                     onPressed: _myCalloptagin,
//                     child: const Text(
//                       'กดขอรหัสผ่านอีกครั้ง',
//                       style: TextStyle(
//                         color: Color(0xFF2EA9E1),
//                         fontFamily: 'notoreg',
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget _textFieldOTP({required bool first, last, required int indexpara}) {
//   //   return SizedBox(
//   //     height: 60,
//   //     child: AspectRatio(
//   //       aspectRatio: 1.0,
//   //       child: TextField(
//   //         autofocus: true,
//   //         onChanged: (value) {
//   //           print('ddd ' + indexpara.toString());
//   //           // เป็นส่วนที่ระบบทำการ Data Value ออกมา

//   //           if (value.length == 1 && last == false) {
//   //             // log('A' + value.toString());
//   //             setState(() {
//   //               if (indexpara == 1 && value != null) {
//   //                 lsotp1 = value; // Data ช่องที่ 1
//   //               } else if (indexpara == 2 && value != null) {
//   //                 lsotp2 = value; // Data ช่องที่ 2
//   //               } else if (indexpara == 3 && value != null) {
//   //                 lsotp3 = value; // Data ช่องที่ 3
//   //               } else if (indexpara == 4 && value != null) {
//   //                 lsotp4 = value; // Data ช่องที่ 4
//   //               }
//   //             });
//   //             // ส่วนของการดำเนินการ โดยการ Set

//   //             FocusScope.of(context).nextFocus();
//   //           } else if (value.length == 0 && first == false) {
//   //             // log('B' + value.toString());
//   //             FocusScope.of(context).previousFocus();
//   //           } else if (value.length == 1 && indexpara == 4) {
//   //             setState(() {
//   //               //   log('C' + value.toString());
//   //               lsotp4 = value; // Data ช่องที่ 4
//   //             });
//   //           }
//   //         },
//   //         showCursor: false,
//   //         readOnly: false,
//   //         textAlign: TextAlign.center,
//   //         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//   //         keyboardType: TextInputType.phone,
//   //         maxLength: 1,
//   //         decoration: InputDecoration(
//   //           counter: const Offstage(),
//   //           enabledBorder: OutlineInputBorder(
//   //               borderSide: const BorderSide(width: 2, color: Colors.black12),
//   //               borderRadius: BorderRadius.circular(12)),
//   //           focusedBorder: OutlineInputBorder(
//   //               borderSide:
//   //                   const BorderSide(width: 2, color: Color(0xFF2EA9E1)),
//   //               borderRadius: BorderRadius.circular(12)),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
// }
