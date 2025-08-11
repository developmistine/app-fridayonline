import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future dialogError(String msg) {
  return Get.dialog(
      barrierColor: Colors.transparent,
      AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 50),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black87, borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 40,
                  ),
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansThaiLooped(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
}
