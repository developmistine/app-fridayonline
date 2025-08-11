// ? widget ส่วนหัวตระกร้า dropship
import 'package:fridayonline/controller/cart/dropship_controller.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../controller/cart/cart_controller.dart';
// import '../../../../model/cart/dropship/drop_ship_address.dart';
// import '../../../../service/cart/dropship/dropship_address_service.dart';
import '../../../../service/languages/multi_languages.dart';
import '../../../theme/theme_color.dart';
// import '../cart_page/cart_change_address.dart';
import '../cart_theme/cart_all_theme.dart';

class CheckBoxDropship extends StatefulWidget {
  const CheckBoxDropship({super.key});
  @override
  State<CheckBoxDropship> createState() => _CheckBoxDropshipState();
}

class _CheckBoxDropshipState extends State<CheckBoxDropship> {
  @override
  void dispose() {
    Get.find<FetchCartItemsController>().isCheckedDropship = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Get.find<FetchCartItemsController>().isCheckedDropship = false;
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool checkboxNoti = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FetchCartDropshipController>(builder: (data) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        width: 16,
        height: 16,
        color: Colors.white,
        child: GetBuilder<FetchCartItemsController>(builder: (dir) {
          return SizedBox(
            height: 24.0,
            width: 24.0,
            child: Checkbox(
                side: BorderSide(width: 1, color: theme_color_df),
                value: dir.isCheckedDropship,
                onChanged: (bool? value) async {
                  dir.updateCheckboxDrop(value);
                  dir.allowMultiple = data.itemDropship!.cartHeader.cartDetail
                      .every((element) =>
                          (dir.isChecked && dir.isCheckedDropship));
                  if (dir.isCheckedDropship) {
                    for (var element
                        in data.itemDropship!.cartHeader.cartDetail) {
                      element.isChecked = true;
                    }
                  } else {
                    for (var element
                        in data.itemDropship!.cartHeader.cartDetail) {
                      element.isChecked = false;
                    }
                  }
                  final SharedPreferences prefs = await _prefs;

                  if (value == true &&
                      (prefs.getBool("notify-dropship") == false ||
                          prefs.getBool("notify-dropship") == null)) {
                    showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0)),
                            title: Center(
                              child: Icon(
                                size: 40,
                                Icons.info,
                                color: theme_color_df,
                              ),
                            ),
                            content: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'สินค้าส่งด่วน',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                      'จำกัดการชำระเงินเฉพาะเก็บเงินปลายทางเท่านั้น',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          checkboxNoti = !checkboxNoti;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 24.0,
                                            width: 24.0,
                                            child: Checkbox(
                                              side: BorderSide(
                                                  width: 1,
                                                  color: theme_color_df),
                                              value: checkboxNoti,
                                              onChanged: (bool? value) async {
                                                // final SharedPreferences prefs =
                                                //     await _prefs;
                                                setState(() {
                                                  checkboxNoti = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          Text(
                                            ' ไม่แจ้งเตือนข้อความนี้อีก',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: theme_grey_text),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                            actions: <Widget>[
                              MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                    textScaler: const TextScaler.linear(1.0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              style: BorderStyle.solid,
                                              color: theme_red),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0)),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            if (checkboxNoti == true) {
                                              prefs.setBool("notify-dropship",
                                                  checkboxNoti);
                                            } else {
                                              dir.isCheckedDropship = false;
                                              Get.find<
                                                      FetchCartDropshipController>()
                                                  .refreshDataFalse();
                                            }
                                          });
                                          Get.back();
                                        },
                                        child: Text(
                                          MultiLanguages.of(context)!
                                              .translate('alert_close'),
                                          style: TextStyle(color: theme_red),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (checkboxNoti == true) {
                                              prefs.setBool("notify-dropship",
                                                  checkboxNoti);
                                            }
                                            Navigator.pop(context, true);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                            backgroundColor: theme_color_df,
                                          ),
                                          child: const Text(
                                            'ดำเนินการต่อ',
                                            maxLines: 1,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.white,
                                                fontFamily: 'notoreg'),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                      },
                    ).then((value) {
                      if (value == null && checkboxNoti == false) {
                        dir.isCheckedDropship = false;
                        Get.find<FetchCartDropshipController>()
                            .refreshDataFalse();
                      }
                    });
                  }
                }),
          );
        }),
      );
    });
  }
}

MediaQuery headDropship(BuildContext context) {
  String? routeName = ModalRoute.of(context)?.settings.name;
  // printWhite(routeName);
  return MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(1.0)),
    child: Container(
      height: 50,
      color: theme_red,
      child: Padding(
        // padding: routeName != "/cart_activity"
        padding: routeName != "/Cart" &&
                routeName != null &&
                routeName != '/cart_activity' &&
                routeName != '/show_case_cart_activity'
            ? const EdgeInsets.symmetric(horizontal: 16.0)
            : EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (routeName == "/Cart" ||
                routeName == null ||
                routeName == '/cart_activity' ||
                routeName == '/show_case_cart_activity')
              const CheckBoxDropship(),
            // if (routeName == "/cart_activity") const CheckBoxDropship(),
            SizedBox(
              height: 30,
              width: 95,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(width: 1.0, color: theme_color_df),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: null,
                child: Text(
                  'ส่งด่วน 3 วัน',
                  style: TextStyle(
                      color: theme_color_df,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Expanded(
              flex: 1,
              child: VerticalDivider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const Expanded(
              flex: 8,
              child: Text(
                'เก็บเงินปลายทาง',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
