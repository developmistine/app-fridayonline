import 'dart:convert';
// import 'dart:developer';
import 'dart:typed_data';

import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
// import 'package:fridayonline/model/set_data/set_data.dart';
// import 'package:fridayonline/service/paymentsystem/payment.dart';
// import 'package:fridayonline/service/paymentsystem/paymentobject.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
// import 'package:share_plus/share_plus.dart';

import 'map_model_androind.dart';

class Payment_detailQrcode extends StatefulWidget {
  final String lspathurl;
  const Payment_detailQrcode(this.lspathurl, {super.key});

  @override
  State<Payment_detailQrcode> createState() => _Payment_detailQrcodeState();
}

class _Payment_detailQrcodeState extends State<Payment_detailQrcode> {
  late String PathUrl;
  // ส่วนของระบบที่ทำการ Get ตาม  Preferences
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      // เป็นส่วนที่ทำการรับตัวเลขมา
      PathUrl = widget.lspathurl;
    });
  }

  // Future<void> _SharePayment() async {
  //   var id = await Share.shareFiles(['https://$PathUrl'],
  //           text: 'บันทึกหรือส่งคิวอาร์โค้ดเพื่อชำระเงิน')
  //       .then(
  //     (value) async {
  //       // var response = await Dio().get("https://$PathUrl",
  //       //     options: Options(responseType: ResponseType.bytes));
  //       // final result = await ImageGallerySaver.saveImage(
  //       //     Uint8List.fromList(response.data),
  //       //     quality: 60,
  //       //     name: "hello");
  //       // print(jsonEncode(result));
  //     },
  //   );
  //   log(id.toString());
  //   return;
  // }

  _save() async {
    //? set ชื่อให้กับรูป
    var nameImage = PathUrl.split('/');

    var response = await Dio().get("https://$PathUrl",
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: nameImage.last);
    SaveImageAndriond mapDataSave =
        saveImageAndriondFromJson(jsonEncode(result));
    if (mapDataSave.isSuccess) {
      Get.snackbar(
          forwardAnimationCurve: Curves.easeOutBack,
          duration: const Duration(milliseconds: 950),
          dismissDirection: DismissDirection.horizontal,
          'ฟรายเดย์',
          'บันทึกรูปภาพสำเร็จค่ะ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitleMaster("ชำระเงิน"),
        body: SingleChildScrollView(
          child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'สแกนเพื่อชำระเงิน',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black45,
                              fontFamily: 'notoreg'),
                        ),
                      ],
                    ),

                    Center(
                      child: Image.network(
                        'https://$PathUrl',
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),

                    //    setlistwedget1(),
                    setlistwedget2(),
                  ],
                ),
              )),
        ));
  }

  Container setlistwedget1() {
    return Container(
      child: Image.network('https://$PathUrl'),
    );
  }

  setlistwedget2() {
    return ListTile(
      tileColor: theme_color_df,
      leading: const ExcludeSemantics(
        child: Icon(
          Icons.save,
          size: 45,
          color: Colors.white,
        ),
      ),
      title: const Text(
        'บันทึกหรือส่งคิวอาร์โค้ด(QR CODE)',
        style:
            TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'notoreg'),
      ),
      subtitle: const Text(
        'เพื่อชำระเงิน',
        style:
            TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'notoreg'),
      ),
      onTap: () async {
        // SetData data = SetData();
        // var device = await data.device;
        // log(device)
        // if (device.toLowerCase() == "android") {
        _save();
        // } else {
        //   _SharePayment();
        // }
      },
    );
  }
}
