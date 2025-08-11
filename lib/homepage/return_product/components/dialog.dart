import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pageactivity/cart/cart_theme/cart_all_theme.dart';
import '../../theme/theme_color.dart';

class ReturnDialog extends StatelessWidget {
  final List<Widget>? chilWidget;

  const ReturnDialog({
    super.key,
    required this.chilWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      actionsPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: chilWidget!,
        ),
      ),
      actions: [
        InkWell(
          // overlayColor: MaterialStateProperty.all(Colors.transparent),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12)),
          onTap: () {
            Get.back();
          },
          child: Container(
            alignment: Alignment.center,
            // margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: theme_grey_bg, width: 1))),
            width: Get.width,
            height: 55,
            child: Text(
              'ปิด',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: theme_color_df,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        )
      ],
    );
  }
}
