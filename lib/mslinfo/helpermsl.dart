// import 'dart:developer';

// import 'package:fridayonline/homepage/login/widgetsetprofilerheader.dart';
// import 'package:fridayonline/homepage/theme/themeimageprofiler.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/service/pathapi.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../homepage/theme/theme_color.dart';
// import '../homepage/webview/webview_app.dart';
import '../service/languages/multi_languages.dart';

final titles = ["คู่มือการขาย", "ข้อตกลงการเป็นสมาชิก", "บัตรประจำตัวสมาชิก"];

// แก้ไขเพิ่มเติม
class HelperMsl extends StatelessWidget {
  const HelperMsl({super.key});

  get children => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitleMaster(
            MultiLanguages.of(context)!.translate('customer_help')),
        body: Column(
          children: [
            const SizedBox(height: 25),
            Center(
                child: GestureDetector(
              onTap: () {
                var url = "${baseurl_yclub}yclub/member/invitationbook.php";
                Get.to(() => WebViewFullScreen(mparamurl: url));
              },
              child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 50,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: theme_color_df),
                    borderRadius: BorderRadius.circular(30.0),
                    color: theme_color_df),
                child: Text(
                  MultiLanguages.of(context)!.translate('btn_seller_manual'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )),
            const SizedBox(height: 20),
            Center(
                child: GestureDetector(
              onTap: () {
                var url =
                    "${baseurl_yclub}yclub/policyandcondition/agreement.php";
                Get.to(() => WebViewFullScreen(mparamurl: url));
              },
              child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 50,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: theme_color_df),
                    borderRadius: BorderRadius.circular(30.0),
                    color: theme_color_df),
                child: Text(
                  MultiLanguages.of(context)!.translate('btn_agreement_member'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )),
            const SizedBox(height: 20),
            Center(
                child: GestureDetector(
              onTap: () {
                var url = "${baseurl_yclub}yclub/member/membercard.php";
                Get.to(() => WebViewFullScreen(mparamurl: url));
              },
              child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 50,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: theme_color_df),
                    borderRadius: BorderRadius.circular(30.0),
                    color: theme_color_df),
                child: const Text(
                  'บัตรประจำตัวสมาชิก',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )),
          ],
        ));
  }
}
