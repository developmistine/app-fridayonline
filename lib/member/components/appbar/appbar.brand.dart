import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

final ShowProductSkuCtr showProductCtr = Get.find();

var border = OutlineInputBorder(
  borderSide: BorderSide(
    color: themeColorDefault,
    width: 1,
  ),
  borderRadius: const BorderRadius.all(
    Radius.circular(8),
  ),
);
Widget appbarBrand({
  required BuildContext ctx,
  required String title,
  required bool isSetAppbar,
  required double opacity,
  required bool showSort,
  required Widget tabbar,
}) {
  return MediaQuery(
      data:
          MediaQuery.of(ctx).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: isSetAppbar
                ? [
                    BoxShadow(
                      color: Colors.grey.shade700.withOpacity(0.5),
                      offset: const Offset(0, 0),
                      blurRadius: 4,
                    ),
                  ]
                : [],
          ),
          child: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
              backgroundColor: Colors.white.withOpacity(opacity),
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              titleSpacing: 8,
              title: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isSetAppbar
                        ? InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: themeColorDefault,
                            ),
                          )
                        : InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.black54.withOpacity(0.2),
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                    const SizedBox(width: 12),
                    if (showSort) Expanded(child: tabbar),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
}
