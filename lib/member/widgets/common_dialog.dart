import 'package:flutter/material.dart';

Future<Object?> dialogCommon(
  BuildContext context,
  Widget children, {
  required String title,
  bool? hideHeader,
  bool? hideHeaderDivider,
  double insetPadding = 24,
  Color? bgColor,
  bool isDismiss = true,
}) {
  return showGeneralDialog(
    context: context,
    transitionDuration: const Duration(milliseconds: 500),
    barrierDismissible: isDismiss,
    barrierLabel: '',
    barrierColor: bgColor != null ? Colors.black12 : Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) {
      return PopScope(
        canPop: isDismiss,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            return;
          }
        },
        child: Dialog(
          insetPadding: EdgeInsets.all(insetPadding),
          constraints: BoxConstraints(maxWidth: 525),
          shadowColor: const Color(0x51131313),
          backgroundColor: bgColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hideHeader != true)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.close_rounded),
                              ),
                            ],
                          ),
                        ),
                      if (hideHeaderDivider != true)
                        Divider(height: 0, color: Color(0xFFF5F5F5)),
                      children,
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0, 1), // เริ่มจากล่าง
        end: const Offset(0, 0), // จบตรงกลาง
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
