import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future dialogAlert(List<Widget> children) {
  return Get.dialog(
      barrierDismissible: false,
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
              child: MediaQuery(
                data: MediaQuery.of(Get.context!)
                    .copyWith(textScaler: const TextScaler.linear(1)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
}

Future dialogOutStockConfirm(List<Widget> children) {
  return Get.dialog(
      // barrierDismissible: false,
      barrierColor: Colors.black26,
      AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 0),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 24),
              child: MediaQuery(
                data: MediaQuery.of(Get.context!)
                    .copyWith(textScaler: const TextScaler.linear(1)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
}
