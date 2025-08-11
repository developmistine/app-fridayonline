import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/material.dart';
// import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../model/market/market_login_supplier.dart';
import '../../model/set_data/set_data.dart';
import '../../service/market/market_service.dart';
import '../theme/theme_color.dart';
import '../webview/webview_full_screen.dart';

class MarketSupplierLogin extends StatefulWidget {
  const MarketSupplierLogin({super.key});

  @override
  State<MarketSupplierLogin> createState() => _MarketSupplierLoginState();
}

class _MarketSupplierLoginState extends State<MarketSupplierLogin> {
  get myFocusNode => null;
  TextEditingController idusername = TextEditingController();
  TextEditingController idpassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), // here the desired height
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              color: Colors.white,
              onPressed: () {
                // Get.toNamed(
                //   '/market',
                // );
                Get.back();
              },
            ),
            centerTitle: true,
            backgroundColor: theme_color_df,
            title: const Text(
              "เข้าสู่ระบบร้านค้า",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'notoreg',
              ),
            ),
          )),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                child: Text(
                  "SUPPLIER CENTER",
                  style: TextStyle(
                      fontSize: 18,
                      color: theme_color_df,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
            child: TextField(
              controller: idusername,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: TextField(
              controller: idpassword,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor: WidgetStateProperty.all<Color>(theme_color_df),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: theme_color_df)))),
            onPressed: () async {
              SetData data = SetData();
              var mdevice = await data.device;

              LoginCheckSupplier? dataLogin = await LoginCheckSupplierCall(
                  musername: idusername.text, mpassword: idpassword.text);

              if (dataLogin!.code.toString() == "1") {
                var mtoken = dataLogin.token.toString();
                var url =
                    "${sellerFridayth}seller_register/yup_home?app=$mdevice&token=$mtoken";
                Get.to(() => WebViewFullScreen(mparamurl: url));
              } else {
                showDialog(
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Dialog(
                        elevation: 0,
                        backgroundColor: const Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Column(
                                children: [
                                  Text(
                                    dataLogin.message.toString(),
                                    style: const TextStyle(
                                        fontFamily: 'notoreg',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "กรุณาตรวจสอบอีกครั้ง",
                                      style: TextStyle(
                                          fontFamily: 'notoreg', fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Divider(
                              height: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: SizedBox(
                                    width: 100,
                                    height: 50,
                                    child: InkWell(
                                      highlightColor: Colors.grey[200],
                                      onTap: () {
                                        //do somethig

                                        Navigator.of(context).pop();
                                      },
                                      child: Center(
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'notoreg'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 1,
                            ),
                          ],
                        ),
                      );
                    },
                    context: context);
              }
            },
            child: const SizedBox(
              width: 150,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Sign in",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
