// import 'dart:developer';
// import 'dart:ffi';
import 'package:fridayonline/homepage/check_information/payment/payment_detailqrcode.dart';
import 'package:fridayonline/homepage/dialogalert/CustomAlertDialogs.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/service/paymentsystem/payment.dart';
import 'package:fridayonline/service/paymentsystem/paymentobject.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../service/languages/multi_languages.dart';
import '../../widget/appbarmaster.dart';

class payment_cutomer extends StatefulWidget {
  final String ARBal;
  const payment_cutomer(this.ARBal, {super.key});
  @override
  State<payment_cutomer> createState() => _payment_cutomerState();
}

// ดำเนินการแก้ไขในส่วนของการชำระเงิน เพื่อที่จะดำเนินการเอา qrcode มาทำการแสดง
class _payment_cutomerState extends State<payment_cutomer> {
  // ทำการ initial state
  String lsarbal = '0';
  // Controller ที่ทำการจัดเก็บค่าจาก text
  TextEditingController numarbal = TextEditingController();

  // ส่วนของระบบที่ทำการ Get ตาม  Preferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // ส่วนที่ทำการ Get Data ออกมา
  String? lstoken;
  String? lsRepSeq;
  String? lsRepCode;
  String? lsUserType;
  String? lslogin;
  double ldnumamount = 0;
  double ldnumarbal = 0;
  late String? pathurl = '';
  String? TransDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      lsarbal = widget.ARBal; // ทำการ set ค่ายอดหนี้ที่ส่งมาจากตัวหัง

      lsRepCode = '';
      numarbal.text =
          NumberFormat.decimalPattern().format(double.parse(widget.ARBal));
      // NumberFormat.decimalPattern().format(double.parse(widget.ARBal));
    });
    // ทำการ getdata
    _myGetDataPreferences();
    // _SetinitialAmount();
    // ทำการ กำหนดกรณีที่มีการส่งค่าเข้ามาในระบบแล้วมีค่าน้อยกว่า 300
  }

  // void _SetinitialAmount() {
  //   setState(() {
  //     // ส่วนของ Data  ที่ทำการ
  //     ldnumarbal = double.parse(lsarbal);
  //   });
  //
  //   // ทำการตรวจสอบยอดเงินที่ส่งมามากกว่า 300 หรือไม่
  //   if (ldnumarbal <= 300) {
  //     numarbal.text = ldnumarbal.toString();
  //   } else if (ldnumarbal > 300) {}
  // }

  void _myGetDataPreferences() async {
    // ส่วนที่ระบบทำการสลับในการ Call  Data
    final SharedPreferences prefs = await _prefs;
    setState(() {
      // ทำการ get ค่าจาก Preferences
      lstoken = prefs.getString("Token") ?? '';
      lsRepSeq = prefs.getString("RepSeq")!;
      lsRepCode = prefs.getString("RepCode")!;
      lsUserType = prefs.getString("UserType")!;
      lslogin = prefs.getString("login")!;
    });
  }

  // เป็นส่วนที่ระบบดำเนินการเพื่อที่จะทำการ ส่งข้อมูลไปทำการ gen qrcode ออกมา
  void _callprocesspayment(String value) async {
    if (value.isEmpty) {
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return const CustomAlertDialogs(
            title: "แจ้งเตือน",
            description: "กรุณาระบุจำนวนเงินค่ะ",
          );
        },
      );
      return;
    }
    var numamount = '0';
    // final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
    // var mtotalC = value.replaceAll(RegExp(r'[^0-9\.]'), '');
    numamount = value;

    double val = double.parse(value.replaceAll(",", ""));
    // ตรวจสอบเพื่อทำการ set ค่า default
    if (val >= 1) {
      double? total =
          double.parse(numamount.replaceAll(RegExp(r'[^0-9\.]'), ''));

      val = total;
      // double mBalanceFloat = double.parse(lsarbal);
      if (val < 1) {
        return showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (context) {
            return const CustomAlertDialogs(
              title: "แจ้งเตือน",
              description: "กรุณาชำระขั้นต่ำ 1 บาท ค่ะ",
            );
          },
        );
      }
      if (val > 1000000) {
        return showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (context) {
            return const CustomAlertDialogs(
              title: "แจ้งเตือน",
              description: "กรุณาชำระต่ำกว่า 1 ล้านบาท ค่ะ",
            );
          },
        );
      }
      _callpayment(val);
      // case 0
      // if (mBalanceFloat == 0) {
      //   if (ldnumamount >= 1) {
      //     if (ldnumamount > 1000000) {
      //       showDialog(
      //         barrierColor: Colors.black26,
      //         context: context,
      //         builder: (context) {
      //           return const CustomAlertDialogs(
      //             title: "แจ้งเตือน",
      //             description: "กรุณาชำระต่ำกว่า 1 ล้านบาท ค่ะ",
      //           );
      //         },
      //       );
      //     } else {
      //       _callpayment(ldnumamount);
      //     }
      //   } else {
      //     showDialog(
      //       barrierColor: Colors.black26,
      //       context: context,
      //       builder: (context) {
      //         return const CustomAlertDialogs(
      //           title: "แจ้งเตือน",
      //           description: "กรุณาชำระขั้นต่ำ 1 บาท ค่ะ",
      //         );
      //       },
      //     );
      //   }
      // }
      // case < 300
      // else if (mBalanceFloat < 300) {
      //   if (ldnumamount < 1) {
      //     showDialog(
      //       barrierColor: Colors.black26,
      //       context: context,
      //       builder: (context) {
      //         return const CustomAlertDialogs(
      //           title: "แจ้งเตือน",
      //           description: "กรุณาชำระขั้นต่ำ 1 บาท ค่ะ",
      //         );
      //       },
      //     );
      //   } else {
      //     if (ldnumamount > 1000000) {
      //       showDialog(
      //         barrierColor: Colors.black26,
      //         context: context,
      //         builder: (context) {
      //           return const CustomAlertDialogs(
      //             title: "แจ้งเตือน",
      //             description: "กรุณาชำระต่ำกว่า 1 ล้านบาท ค่ะ",
      //           );
      //         },
      //       );
      //     } else {
      //       _callpayment(ldnumamount);
      //     }
      //   }
      // }
      // else {
      //   if (ldnumamount < 1) {
      //     showDialog(
      //       barrierColor: Colors.black26,
      //       context: context,
      //       builder: (context) {
      //         return const CustomAlertDialogs(
      //           title: "แจ้งเตือน",
      //           description: "กรุณาชำระขั้นต่ำ 1 บาท ค่ะ",
      //         );
      //       },
      //     );
      //   } else {
      //     if (ldnumamount > 1000000) {
      //       showDialog(
      //         barrierColor: Colors.black26,
      //         context: context,
      //         builder: (context) {
      //           return const CustomAlertDialogs(
      //             title: "แจ้งเตือน",
      //             description: "กรุณาชำระต่ำกว่า 1 ล้านบาท ค่ะ",
      //           );
      //         },
      //       );
      //     } else {
      //       _callpayment(ldnumamount);
      //     }
      //   }
      // }
    } else {
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return const CustomAlertDialogs(
            title: "แจ้งเตือน",
            description: "กรุณาชำระขั้นต่ำ 1 บาท ค่ะ",
          );
        },
      );
      return;
    }

    //

    return;
  }

  void _callpayment(double ldnumamount) async {
    try {
      var now = DateTime.now();
      TransDate = DateFormat('yyyyMMddhhmmss').format(now);
      Objectpayment objectpayment =
          await paymentService(lsRepCode!, ldnumamount.toString(), TransDate!);
      // เตรียมข้อมูลส่วไปที่หน้า genqrcode

      pathurl = objectpayment.qrcode.toString();
    } catch (error) {}
    if (pathurl!.isNotEmpty) {
      Get.to(() => Payment_detailQrcode(pathurl!));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (context) {
            return const CustomAlertDialogs(
              title: "แจ้งเตือน",
              description:
                  "ขออภัยค่ะ ไม่สามารถสร้างคิวอาร์โค้ดเพื่อชำระเงินได้ กรุณาลองใหม่อีกครั้ง",
            );
          },
        ).then((val) {
          return;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBarTitleMaster(
          MultiLanguages.of(context)!.translate('payment_title')),
      body: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
              child: Column(
                children: [
                  Text(
                    MultiLanguages.of(context)!.translate('tv_balance'),
                    style: const TextStyle(
                        fontSize: 25,
                        color: Colors.black45,
                        fontFamily: 'notoreg'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '฿ ${NumberFormat.decimalPattern().format(double.parse(lsarbal))}',
                    style: const TextStyle(
                        fontSize: 40,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontFamily: 'notoreg'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        MultiLanguages.of(context)!
                            .translate('lb_payment_method'),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme_color_df,
                            fontFamily: 'notoreg'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        '1. ${MultiLanguages.of(context)!.translate('lb_specify_amount')}',
                        style: const TextStyle(
                            fontSize: 15, fontFamily: 'notoreg'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    keyboardType: TextInputType.phone,
                    controller: numarbal,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ระบุยอดที่ต้องชำระ',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(
                        '2.  ${MultiLanguages.of(context)!.translate('lb_choose_payment_method')}',
                        style: const TextStyle(
                            fontSize: 15, fontFamily: 'notoreg'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    tileColor: theme_color_df,
                    leading: const ExcludeSemantics(
                      child: Icon(
                        Icons.qr_code_outlined,
                        size: 45,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      'สร้างคิวอาร์โค้ด (QR CODE)',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontFamily: 'notoreg'),
                    ),
                    subtitle: const Text(
                      'ชำระเงินด้วยระบบคิวอาร์โค้ด',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'notoreg'),
                    ),
                    onTap: () {
                      // print(numarbal.text);

                      _callprocesspayment(numarbal.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
