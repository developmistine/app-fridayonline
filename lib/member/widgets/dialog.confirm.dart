import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

dialogConfirm(String title, String action1, String action2) {
  return Get.dialog(
      barrierColor: Colors.black26,
      MediaQuery(
        data: MediaQuery.of(Get.context!)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: AlertDialog(
          elevation: 2,
          actionsAlignment: MainAxisAlignment.spaceAround,
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansThaiLooped(fontSize: 13),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  height: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            Get.back(result: 0);
                          },
                          child: SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(action1,
                                  style: GoogleFonts.notoSansThaiLooped(
                                      fontSize: 13)),
                            ),
                          )),
                    ),
                    if (action2 != "")
                      const SizedBox(
                          height: 40,
                          child: VerticalDivider(
                            width: 0,
                          )),
                    if (action2 != "")
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              Get.back(result: 1);
                            },
                            child: SizedBox(
                              height: 40,
                              child: Center(
                                child: Text(action2,
                                    style: GoogleFonts.notoSansThaiLooped(
                                        fontSize: 13,
                                        color: Colors.deepOrange.shade600)),
                              ),
                            )),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ));
}
