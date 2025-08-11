import 'dart:convert';

import 'package:fridayonline/controller/cancel_order/cancel_ctr.dart';
import 'package:fridayonline/homepage/check_information/order/order_order.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../controller/check_information/check_information_controller.dart';
import '../../../theme/themeimage_menu.dart';

class MslDownloadFlagYB2C extends StatefulWidget {
  const MslDownloadFlagYB2C({
    super.key,
    required this.dataController,
    required this.width,
    required this.height,
    required ScrollController firstController,
    required this.shopType,
  }) : _firstController = firstController;

  final CheckInformationOrderOrderAllController dataController;
  final double width;
  final double height;
  final ScrollController _firstController;
  final String shopType;

  @override
  State<MslDownloadFlagYB2C> createState() => _MslDownloadFlagYB2CState();
}

class _MslDownloadFlagYB2CState extends State<MslDownloadFlagYB2C> {
  bool isShowDiscount = false;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: ListView(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.dataController.headerStatus!,
                                style: const TextStyle(color: Colors.black)),
                            Text(widget.dataController.statusDiscription!,
                                style: const TextStyle(
                                    color: Color(0XFF20BE79),
                                    fontWeight: FontWeight.bold)),
                            Text(
                                widget.dataController
                                    .infornation_orderdetail_b2c!.repName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey)),
                            // Text(
                            //     'รอบการขาย ${widget.dataController.ordercamp!}',
                            //     style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                widget.dataController
                                    .infornation_orderdetail_b2c!.orderDate,
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 15,
                                    color: Colors.grey)),
                            Text(
                                widget.dataController
                                    .infornation_orderdetail_b2c!.repTel
                                    .replaceAllMapped(
                                        RegExp(r'(\d{3})(\d{3})(\d+)'),
                                        (Match m) => "${m[1]}-${m[2]}-${m[3]}"),
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 15,
                                    color: Colors.grey)),
                          ],
                        ),
                      )
                    ]),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: BorderDirectional(
                        bottom: BorderSide(
                      width: 2,
                      color: theme_color_df,
                    ))),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Text(
                    'รายการสินค้า',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: ListView.builder(
                  controller: widget._firstController,
                  shrinkWrap: true,
                  itemCount: widget.dataController.infornation_orderdetail_b2c!
                      .itemGroups.length,
                  itemBuilder: (context, index) {
                    return Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 0.5,
                                color: Color.fromARGB(255, 224, 224, 224)),
                          ), // Set border width
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget
                                      .dataController
                                      .infornation_orderdetail_b2c!
                                      .itemGroups[index]
                                      .image ==
                                  '')
                                Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.all(12),
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      child: Image.asset(imageError)),
                                )
                              else
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 0.5)),
                                    child: CachedNetworkImage(
                                      imageUrl: widget
                                          .dataController
                                          .infornation_orderdetail_b2c!
                                          .itemGroups[index]
                                          .image,
                                      width: ((widget.width - 32.0) / 2) / 2,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'รหัส ${widget.dataController.infornation_orderdetail_b2c!.itemGroups[index].billCode}'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        widget
                                            .dataController
                                            .infornation_orderdetail_b2c!
                                            .itemGroups[index]
                                            .billName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${NumberFormat.decimalPattern().format(widget.dataController.infornation_orderdetail_b2c!.itemGroups[index].price * widget.dataController.infornation_orderdetail_b2c!.itemGroups[index].amount)} บาท',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                          'x${widget.dataController.infornation_orderdetail_b2c!.itemGroups[index].amount}',
                                          style: TextStyle(
                                              color: theme_color_df,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ));
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0;
                        i <
                            widget.dataController.infornation_orderdetail_b2c!
                                .paymentInfo.info.length;
                        i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget
                              .dataController
                              .infornation_orderdetail_b2c!
                              .paymentInfo
                              .info[i]
                              .text),
                          Text(
                            "${myFormat.format(widget.dataController.infornation_orderdetail_b2c!.paymentInfo.info[i].value)} บาท",
                            style: const TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '*ข้อมูลอาจมีการเปลี่ยนแปลง',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: theme_red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              widget.dataController.infornation_orderdetail_b2c!.cancelFlag
                  ? Container(
                      width: Get.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              side: BorderSide(
                                  width: 2, color: Colors.grey.shade700),
                              backgroundColor: Colors.white),
                          onPressed: () {
                            reasonBottomSheet(
                                context,
                                widget.dataController
                                    .infornation_orderdetail_b2c!.orderId
                                    .toString(),
                                widget.shopType,
                                "");
                          },
                          child: Text(
                            'ยกเลิกคำสั่งซื้อ',
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}

reasonBottomSheet(
    BuildContext context, String orderId, String shopType, String endUserId) {
  canConfirm(CancelProductController reason) {
    if (!reason.isCheck.value) {
      return false;
    } else if (!reason.isOther.value) {
      return true;
    } else if (reason.isOther.value && reason.otherNoteCtr.value.text == "") {
      return false;
    } else {
      return true;
    }
  }

  return showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0))),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return GestureDetector(
            onTap: () {
              setState(() {
                FocusScope.of(context).unfocus();
              });
            },
            child: GetX<CancelProductController>(builder: (reason) {
              return reason.isDataLoading.value
                  ? const SizedBox()
                  : MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: Get.height / 1.7 +
                                Get.mediaQuery.viewInsets.bottom),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  InkWell(
                                    child: Icon(
                                      Icons.arrow_back_rounded,
                                      size: 30,
                                      color: theme_red,
                                    ),
                                    onTap: () {
                                      Get.back();
                                      reason.otherNoteCtr.value.clear();
                                    },
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'ยกเลิกคำสั่งซื้อ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          "หากยกเลิกคำสั่งซื้อ ข้อมูลจะถูกลบและต้องสั่งซื้อใหม่",
                                          style: TextStyle(
                                            color: theme_red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                // physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                // primary: false,
                                itemCount: reason.cancleReason!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        reason.checkedIndex!.value = index;
                                        reason.isCheck.value = true;
                                        if (reason
                                            .cancleReason![index].noteFlag) {
                                          reason.isOther.value = true;
                                        } else {
                                          reason.isOther.value = false;
                                          reason.otherNoteCtr.value.clear();
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              reason.cancleReason![index]
                                                  .cancelReason,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          reason.isCheck.value &&
                                                  reason.checkedIndex!.value ==
                                                      index
                                              ? Icon(
                                                  Icons.radio_button_checked,
                                                  color: theme_red,
                                                )
                                              : const Icon(
                                                  Icons
                                                      .radio_button_unchecked_outlined,
                                                  color: Colors.grey,
                                                ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (reason.cancleReason!.any((e) => e.noteFlag))
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: reason.otherNoteCtr.value,
                                  readOnly: !reason.isOther.value,
                                  onChanged: (value) {
                                    setState(() {
                                      canConfirm(reason);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    filled: !reason.isOther.value,
                                    fillColor: Colors.grey.shade200,
                                    enabled: reason.isOther.value,
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: theme_red)),
                                    isDense: true,
                                    hintText: 'โปรดระบุ',
                                    hintStyle: const TextStyle(fontSize: 13),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: theme_color_df)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: theme_color_df)),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: theme_red)),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                if (!canConfirm(reason)) {
                                  return;
                                }
                                final cancelId = reason
                                    .cancleReason![reason.checkedIndex!.value]
                                    .cancelId;

                                Get.back();
                                reason.saveCancelOrderFn(
                                    orderId,
                                    endUserId,
                                    "",
                                    cancelId,
                                    reason.otherNoteCtr.value.text,
                                    shopType);
                                successBottomSheet(context);
                              },
                              child: Container(
                                height: 60,
                                color: canConfirm(reason)
                                    ? theme_red
                                    : theme_grey_text,
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                    child: Text(
                                  canConfirm(reason)
                                      ? "ยืนยัน"
                                      : reason.isOther.value
                                          ? "ระบุเหตุผล"
                                          : "เลือกเหตุผล",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                            SizedBox(height: Get.mediaQuery.viewInsets.bottom),
                          ],
                        ),
                      ),
                    );
            }),
          );
        });
      });
}

successBottomSheet(BuildContext context) {
  return showMaterialModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0))),
      builder: (BuildContext context) {
        return GestureDetector(onTap: () {
          FocusScope.of(context).unfocus();
        }, child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return GetX<CancelProductController>(builder: (saveCancel) {
            return saveCancel.saveDataLoading.value
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 355,
                        child: Lottie.asset(
                            width: 180, 'assets/images/loading_line.json'),
                      ),
                    ],
                  )
                : saveCancel.response!.code != "100"
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                              width: 230,
                              height: 230,
                              'assets/images/cart/error_confirm.json'),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: Text(
                              textAlign: TextAlign.center,
                              saveCancel.response!.message1,
                              style:
                                  TextStyle(fontWeight: boldText, fontSize: 19),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                                width: 280,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: theme_color_df),
                                    onPressed: () async {
                                      Get.back();
                                      Get.back(result: true);
                                      Get.off(() =>
                                          const CheckInformationOrderOrder());
                                    },
                                    child: const Text(
                                      "ตกลง",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ))),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                              width: 230,
                              height: 230,
                              'assets/images/cart/success_lottie.json'),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: Text(
                              textAlign: TextAlign.center,
                              "บันทึกข้อมูลเรียบร้อย",
                              style:
                                  TextStyle(fontWeight: boldText, fontSize: 19),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                                width: 280,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: theme_color_df),
                                    onPressed: () async {
                                      Get.back();
                                      Get.back(result: true);
                                      Get.off(() =>
                                          const CheckInformationOrderOrder());
                                    },
                                    child: const Text(
                                      "ตกลง",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ))),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      );
          });
        }));
      });
}

List<Reason> reasonFromJson(String str) =>
    List<Reason>.from(json.decode(str).map((x) => Reason.fromJson(x)));

String reasonToJson(List<Reason> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reason {
  bool selected;
  String reason;

  Reason({
    required this.selected,
    required this.reason,
  });

  factory Reason.fromJson(Map<String, dynamic> json) => Reason(
        selected: json["selected"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "selected": selected,
        "reason": reason,
      };
}
