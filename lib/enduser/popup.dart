import 'dart:io';

import 'package:appfridayecommerce/controller/update_app_controller.dart';
import 'package:appfridayecommerce/theme.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

showPopUpUpdateApp(context, UpdateAppController update) async {
  try {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        double width = MediaQuery.of(context).size.width;
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1)),
            child: Scaffold(
                backgroundColor: Colors.black.withOpacity(0),
                body: Center(
                  child: Container(
                    width: width / 1.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/b2c/icon/update_app.png',
                            width: width / 2,
                          ),
                          Text(
                            "แอปใหม่พร้อมให้ใช้งานแล้ว!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansThaiLooped(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            textAlign: TextAlign.center,
                            update.detail.replaceAll('\\n', '\n'),
                            style: GoogleFonts.notoSansThaiLooped(
                              fontSize: 14,
                            ),
                          ).paddingSymmetric(horizontal: 8),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  foregroundColor: Colors.white,
                                  backgroundColor: themeColorDefault,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: themeColorDefault))),
                              onPressed: () async {
                                if (Platform.isIOS) {
                                  await LaunchApp.openApp(
                                      iosUrlScheme: 'nonexistent-scheme://',
                                      appStoreLink: update.url,
                                      openStore: true);
                                } else {
                                  var url1 = Uri.parse(update.url);
                                  await launchUrl(
                                    url1,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: SizedBox(
                                width: width / 1.7,
                                child: Center(
                                  child: Text('อัปเดตเลย!',
                                      style: GoogleFonts.notoSansThaiLooped(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  } catch (e) {
    print("popup");
  }
}
