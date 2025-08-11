import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Future<dynamic> loadingCart(context) {
  return showDialog(
    context: context,
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color.fromARGB(96, 26, 25, 25),
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.all(60),
        content: Lottie.asset(
            height: 100, width: 100, 'assets/images/loading_line.json'),
      );
    },
  );
}

Future<dynamic> loadingProductStock(context) {
  return showDialog(
    context: context,
    barrierColor: Colors.transparent,
    // barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.all(20),
        content: Lottie.asset(
            height: 80, width: 80, 'assets/images/loading_line.json'),
      );
    },
  );
}

Future<dynamic> loadingProductTier(context) {
  return showDialog(
    context: context,
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.all(0),
        content: Lottie.asset(
            height: 80, width: 80, 'assets/images/loading_line.json'),
      );
    },
  );
}
