import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
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
