import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/pathapi.dart';
import '../webview/webview_full_screen.dart';
import 'webviewcustomerpdpa.dart';
import 'webviewleadpdpa.dart';

class SelectRegisterType extends StatelessWidget {
  const SelectRegisterType({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        body: Column(
          children: [
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeadWebviewPDPA(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme_color_df,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Center(
                            child: Image.asset(
                              'assets/images/login/member.png',
                              width: 80,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'สมัครสมาชิก',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                'ขายตรงฟรายเดย์',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const Text('')
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerWebviewPDPA(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0XFFA4D6F1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Center(
                            child: Image.asset(
                              'assets/images/login/customer.png',
                              width: 80,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ลงทะเบียนลูกค้าสมาชิก',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF12699D)),
                              ),
                              Text(
                                'ซื้อสินค้าจากแอปฟรายเดย์',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF12699D)),
                              ),
                            ],
                          ),
                        ),
                        const Text('')
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Color(0xFFABABAB),
                      height: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'วิธีลงทะเบียน',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            var murl =
                                '$baseurl_yclub/yclub/policyandcondition/howto_regisnew.php';
                            Get.to(() => WebViewFullScreen(mparamurl: murl));
                          },
                          child: Text(
                            'ดูเพิ่มเติม',
                            style: TextStyle(
                              color: theme_color_df,
                              fontFamily: 'notoreg',
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Color(0xFFABABAB),
                      height: 50,
                    ),
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
