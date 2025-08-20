import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/webview/webview.dart';
import 'package:get/get.dart';

class BannerProject extends StatelessWidget {
  const BannerProject({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {
          Get.to(() => const WebViewApp(
              mparamurl:
                  "https://sp.fridayth.com/webnew/b2cpoint?cust_id=381&member_code=N2501&content_type=special&content_id=1091&device=web",
              mparamTitleName: 'โครงการพิเศษ'));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/banner/accidental_insurance.png',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
