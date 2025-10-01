import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Color themeColorDefault = const Color(0xFF00ADEF);
Color themeRed = const Color.fromRGBO(253, 127, 107, 1);

ThemeData themeData() {
  return ThemeData(
    primaryColor: themeColorDefault,
    fontFamily: 'IBM_Regular',
    useMaterial3: false,
    progressIndicatorTheme:
        ProgressIndicatorThemeData(color: themeColorDefault),
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontFamily: 'IBM_Regular',
          fontWeight: FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        textStyle: const TextStyle(
          fontFamily: 'IBM_Regular',
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          // Customize button shape
          borderRadius: BorderRadius.circular(30.0),
        ),
        textStyle: const TextStyle(
          fontFamily: 'IBM_Regular',
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
  );
}

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

Future<void> loadingAffiliate(bool show) async {
  if (show) {
    if (Get.isDialogOpen != true) {
      Get.dialog(
        Center(
          child: Lottie.asset(
            'assets/images/loading_line.json',
            height: 80,
            width: 80,
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: .2),
      );
    }
    return;
  } else {
    if (Get.isDialogOpen == true) {
      Get.back(); // ปิด dialog

      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}
