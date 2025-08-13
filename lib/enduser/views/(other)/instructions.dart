import 'package:appfridayecommerce/enduser/components/appbar/appbar.master.dart';
import 'package:appfridayecommerce/enduser/components/webview/webview_full.dart';
import 'package:flutter/material.dart';

import '../../../service/pathapi.dart';

class Instructions extends StatelessWidget {
  const Instructions({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
          appBar: appBarMasterEndUser('นโยบายความเป็นส่วนตัว'),
          body: WebViewFullScreen(
            mparamurl:
                '${baseurl_yclub}yclub/policyandcondition/privacy-notice_no.php',
          )),
    );
  }
}
