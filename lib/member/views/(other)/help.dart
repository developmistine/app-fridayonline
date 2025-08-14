import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/components/webview/webview_full.dart';
import 'package:flutter/material.dart';

class HelpFriday extends StatelessWidget {
  const HelpFriday({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMasterEndUser('คำแนะนำการใช้งาน'),
        body: const WebViewFullScreen(
          mparamurl: 'https://help.friday.co.th/',
        ));
  }
}
