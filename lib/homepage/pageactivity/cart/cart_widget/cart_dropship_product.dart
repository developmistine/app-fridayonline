import 'dart:async';
// import 'dart:convert';

import 'package:fridayonline/controller/cart/cart_controller.dart';
// import 'package:fridayonline/service/cart/dropship/dropship_address_service.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../controller/cart/dropship_controller.dart';
import '../../../../controller/cart/function_add_to_cart.dart';
import '../../../../controller/dropship_shop/dropship_shop_controller.dart';
// import '../../../../model/cart/dropship/drop_ship_address.dart';
import '../../../../service/address/addresssearch.dart';
import '../../../../service/languages/multi_languages.dart';
import '../../../dropship_shop/dropship_showproduct.dart';
import '../../../theme/theme_color.dart';
// import '../cart_page/cart_change_address.dart';
import '../cart_theme/cart_all_theme.dart';
// import 'cart_friday_order.dart';

class DropshipList extends StatefulWidget {
  const DropshipList(this.controller, this.index, this._enableEdit,
      this.inputors, this.scaffoldKey,
      {super.key});
  final FetchCartDropshipController controller; //? ข้อมูลสินค้าในตระกร้า
  final int index;
  final bool _enableEdit; //? เปิด - ปิดการแก้ไข
  final List<TextEditingController> inputors; //? จำนวนสินค้าใน textfield
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<DropshipList> createState() =>
      _DropshipListState(controller, index, _enableEdit, inputors, scaffoldKey);
}

class _DropshipListState extends State<DropshipList> {
  _DropshipListState(this.controller, this.index, this._enableEdit,
      this.inputors, this.scaffoldKey);
  final FetchCartDropshipController controller; //? ข้อมูลสินค้าในตระกร้า
  final int index;
  final bool _enableEdit; //? เปิด - ปิดการแก้ไข
  final List<TextEditingController> inputors; //? จำนวนสินค้าใน textfield
  final GlobalKey<ScaffoldState> scaffoldKey; //? จำนวนสินค้าใน textfield
  Timer? _debounce;
  FetchCartItemsController checkBox = Get.put(FetchCartItemsController());
  int i = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (var element in controller.itemDropship!.cartHeader.cartDetail) {
      element.isChecked = false;
    }
  }

  bool checkboxNoti = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: ListTileTheme(
              minLeadingWidth: 2,
              horizontalTitleGap: 0,
              contentPadding: const EdgeInsets.only(right: 16, left: 4),
              child: ListTile(
                leading: _enableEdit == true
                    ? SizedBox(
                        height: 24.0,
                        width: 42.0,
                        child: GetBuilder<FetchCartDropshipController>(
                            builder: (checkDropship) {
                          return Checkbox(
                              side: BorderSide(width: 1, color: theme_color_df),
                              value: controller.itemDropship!.cartHeader
                                  .cartDetail[index].isChecked,
                              onChanged: (bool? value) async {
                                final SharedPreferences prefs = await _prefs;
                                checkBox.updateCheckboxDrop(false);
                                setState(() {
                                  controller.itemDropship!.cartHeader
                                      .cartDetail[index].isChecked = value!;
                                  checkBox.isCheckedDropship = controller
                                      .itemDropship!.cartHeader.cartDetail
                                      .every((element) => element.isChecked);
                                  checkBox.allowMultiple = controller
                                      .itemDropship!.cartHeader.cartDetail
                                      .every((element) =>
                                          (checkBox.isCheckedDropship &&
                                              checkBox.isChecked));
                                });
                                if (value == true &&
                                    (prefs.getBool("notify-dropship") ==
                                            false ||
                                        prefs.getBool("notify-dropship") ==
                                            null)) {
                                  showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2.0)),
                                          title: Center(
                                            child: Icon(
                                              size: 40,
                                              Icons.info,
                                              color: theme_color_df,
                                            ),
                                          ),
                                          content: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'สินค้าส่งด่วน',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                const Text(
                                                    'จำกัดการชำระเงินเฉพาะเก็บเงินปลายทางเท่านั้น',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: InkWell(
                                                    highlightColor:
                                                        Colors.transparent,
                                                    splashColor:
                                                        Colors.transparent,
                                                    onTap: () {
                                                      setState(() {
                                                        checkboxNoti =
                                                            !checkboxNoti;
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
                                                                color:
                                                                    theme_color_df),
                                                            value: checkboxNoti,
                                                            onChanged: (bool?
                                                                value) async {
                                                              // final SharedPreferences
                                                              //     prefs =
                                                              //     await _prefs;
                                                              setState(() {
                                                                checkboxNoti =
                                                                    value!;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        Text(
                                                          ' ไม่แจ้งเตือนข้อความนี้อีก',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  theme_grey_text),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ]),
                                          actions: <Widget>[
                                            MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      textScaler:
                                                          const TextScaler
                                                              .linear(1.0)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        side: BorderSide(
                                                            style: BorderStyle
                                                                .solid,
                                                            color: theme_red),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0)),
                                                      ),
                                                      onPressed: () async {
                                                        setState(() {
                                                          if (checkboxNoti ==
                                                              true) {
                                                            prefs.setBool(
                                                                "notify-dropship",
                                                                checkboxNoti);
                                                          } else {
                                                            checkBox.isCheckedDropship =
                                                                false;
                                                            Get.find<
                                                                    FetchCartDropshipController>()
                                                                .refreshDataFalse();
                                                          }
                                                        });
                                                        Get.back();
                                                      },
                                                      child: Text(
                                                        MultiLanguages.of(
                                                                context)!
                                                            .translate(
                                                                'alert_close'),
                                                        style: TextStyle(
                                                            color: theme_red),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          if (checkboxNoti ==
                                                              true) {
                                                            prefs.setBool(
                                                                "notify-dropship",
                                                                checkboxNoti);
                                                          }
                                                          Navigator.pop(
                                                              context, true);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0)),
                                                          backgroundColor:
                                                              theme_color_df,
                                                        ),
                                                        child: const Text(
                                                          'ดำเนินการต่อ',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'notoreg'),
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
                                    if (value == null) {
                                      checkBox.isCheckedDropship = false;
                                      Get.find<FetchCartDropshipController>()
                                          .refreshDataFalse();
                                    }
                                  });
                                }
                              });
                        }),
                      )
                    : null,
                title: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          print(111);
                          if (_enableEdit) {
                            // var mChannel = '6';
                            // var mChannelId = '';
                            Get.put(FetchDropshipShop())
                                .fetchProductDetailDropship(controller
                                    .itemDropship!
                                    .cartHeader
                                    .cartDetail[index]
                                    .billB2C);
                            Get.to(() => DropShipProduct());
                          }
                        },
                        child: CachedNetworkImage(
                          imageUrl: controller.itemDropship!.cartHeader
                              .cartDetail[index].billImg,
                          height: 120,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.itemDropship!.cartHeader
                                .cartDetail[index].billName,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 16, overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                              "${MultiLanguages.of(context)!.translate('product_code')}  ${controller.itemDropship!.cartHeader.cartDetail[index].billCode}",
                              style: const TextStyle(fontSize: 14, height: 2)),
                          if (controller
                                  .itemDropship!
                                  .cartHeader
                                  .cartDetail[index]
                                  .stockDescription
                                  .isNotEmpty &&
                              _enableEdit)
                            Text(
                                controller.itemDropship!.cartHeader
                                    .cartDetail[index].stockDescription,
                                style: TextStyle(
                                    fontSize: 14, height: 1, color: theme_red)),
                          const SizedBox(
                            height: 5,
                          ),
                          _enableEdit
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          MultiLanguages.of(context)!
                                              .translate('product_price'),
                                          style:
                                              TextStyle(color: theme_color_df),
                                        ),
                                        Text(
                                            "${myFormat.format(controller.itemDropship!.cartHeader.cartDetail[index].price)} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                            style: TextStyle(
                                                color: theme_color_df)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            MultiLanguages.of(context)!
                                                .translate('total_prices'),
                                            style: TextStyle(
                                                fontWeight: boldText,
                                                color: theme_color_df),
                                          ),
                                        ),
                                        Text(
                                            "${myFormat.format(controller.itemDropship!.cartHeader.cartDetail[index].price * controller.itemDropship!.cartHeader.cartDetail[index].qty)} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                            style: TextStyle(
                                                fontWeight: boldText,
                                                color: theme_color_df))
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          _enableEdit
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          //? remove button
                                          child: BouncingWidget(
                                            duration: const Duration(
                                                milliseconds: 100),
                                            scaleFactor: 1.5,
                                            onPressed: (() async {
                                              if (inputors[index]
                                                  .text
                                                  .isNotEmpty) {
                                                if (!Get.find<
                                                        DropshipEditCart>()
                                                    .isDataLoading
                                                    .value) {
                                                  inputors[index].selection =
                                                      TextSelection(
                                                          baseOffset: 0,
                                                          extentOffset:
                                                              inputors[index]
                                                                  .text
                                                                  .length);
                                                  var remove = int.parse(
                                                          inputors[index]
                                                              .text) -
                                                      1;
                                                  if (remove >= 1) {
                                                    inputors[index]
                                                        .value = inputors[
                                                            index]
                                                        .value
                                                        .copyWith(
                                                            text: remove
                                                                .toString());
                                                    controller
                                                        .itemDropship!
                                                        .cartHeader
                                                        .cartDetail[index]
                                                        .qty = remove;
                                                    await fnEditCartDropship(
                                                        context,
                                                        controller
                                                            .itemDropship!
                                                            .cartHeader
                                                            .cartDetail[index],
                                                        'cart_remove_amount',
                                                        '',
                                                        '');
                                                  }
                                                }
                                              }
                                            }),
                                            child: Icon(
                                              Icons.remove_circle,
                                              color: theme_color_df,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: SizedBox(
                                            width: 60.0,
                                            height: 30.0,
                                            child: Center(
                                              //? textfied edit
                                              child: TextField(
                                                enableInteractiveSelection:
                                                    false,
                                                textInputAction:
                                                    TextInputAction.done,
                                                autofocus: false,
                                                showCursor: false,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                textAlign: TextAlign.center,
                                                controller: inputors[index],
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]')),
                                                  FilteringTextInputFormatter
                                                      .deny(
                                                    RegExp(
                                                        r'^0+'), //ป้องกันการใส่เลข 0 ตำแหน่งแรก
                                                  ),
                                                  LengthLimitingTextInputFormatter(
                                                      3),
                                                ],
                                                decoration:
                                                    const InputDecoration(
                                                  isCollapsed: true,
                                                  border: OutlineInputBorder(),
                                                ),
                                                onTap: () {
                                                  inputors[index].selection =
                                                      TextSelection(
                                                          baseOffset: 0,
                                                          extentOffset:
                                                              inputors[index]
                                                                  .text
                                                                  .length);
                                                },
                                                onChanged: (text) async {
                                                  if (text.isNotEmpty) {
                                                    //? set delay เพื่อไม่ให้มีการส่ง alert ซ้ำ
                                                    if (_debounce?.isActive ??
                                                        false) {
                                                      _debounce!.cancel();
                                                    }
                                                    _debounce = Timer(
                                                        const Duration(
                                                            milliseconds: 500),
                                                        () async {
                                                      controller
                                                              .itemDropship!
                                                              .cartHeader
                                                              .cartDetail[index]
                                                              .qty =
                                                          int.parse(text);
                                                      Get.find<
                                                              FetchCartDropshipController>()
                                                          .isDataLoading(true);
                                                      await fnEditCartDropship(
                                                          context,
                                                          controller
                                                                  .itemDropship!
                                                                  .cartHeader
                                                                  .cartDetail[
                                                              index],
                                                          'r',
                                                          '',
                                                          '');
                                                    });
                                                  } else {
                                                    if (text.isEmpty) {
                                                      inputors[index].text =
                                                          '1';
                                                      inputors[index]
                                                              .selection =
                                                          TextSelection(
                                                              baseOffset: 0,
                                                              extentOffset:
                                                                  inputors[
                                                                          index]
                                                                      .text
                                                                      .length);
                                                      controller
                                                              .itemDropship!
                                                              .cartHeader
                                                              .cartDetail[index]
                                                              .qty =
                                                          int.parse(
                                                              inputors[index]
                                                                  .text);
                                                      await fnEditCartDropship(
                                                          context,
                                                          controller
                                                                  .itemDropship!
                                                                  .cartHeader
                                                                  .cartDetail[
                                                              index],
                                                          'r',
                                                          '',
                                                          '');
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: BouncingWidget(
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              scaleFactor: 1.5,
                                              onPressed: (() async {
                                                if (inputors[index]
                                                    .text
                                                    .isNotEmpty) {
                                                  if (!Get.find<
                                                          DropshipEditCart>()
                                                      .isDataLoading
                                                      .value) {
                                                    inputors[index].selection =
                                                        TextSelection(
                                                            baseOffset: 0,
                                                            extentOffset:
                                                                inputors[index]
                                                                    .text
                                                                    .length);
                                                    var add = int.parse(
                                                            inputors[index]
                                                                .text) +
                                                        1;
                                                    if (add <= 999) {
                                                      inputors[index]
                                                          .value = inputors[
                                                              index]
                                                          .value
                                                          .copyWith(
                                                              text: add
                                                                  .toString());
                                                      controller
                                                          .itemDropship!
                                                          .cartHeader
                                                          .cartDetail[index]
                                                          .qty = add;
                                                      await fnEditCartDropship(
                                                          context,
                                                          controller
                                                                  .itemDropship!
                                                                  .cartHeader
                                                                  .cartDetail[
                                                              index],
                                                          'r',
                                                          '',
                                                          '');
                                                    }
                                                  }
                                                }
                                              }),
                                              child: Icon(Icons.add_circle,
                                                  color: theme_color_df)),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: BouncingWidget(
                                        duration:
                                            const Duration(milliseconds: 100),
                                        scaleFactor: 1.5,
                                        onPressed: () async {
                                          await fnEditCartDropship(
                                              context,
                                              controller.itemDropship!
                                                  .cartHeader.cartDetail[index],
                                              'cart_page_delete',
                                              '',
                                              '');
                                          inputors.removeAt(index);
                                        },
                                        child: Image.asset(
                                            scale: 1.8,
                                            'assets/images/cart/delete.png'),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            '${MultiLanguages.of(context)!.translate('product_price')}  ${myFormat.format(controller.itemDropship!.cartHeader.cartDetail[index].price)} ${MultiLanguages.of(context)!.translate('order_baht')}',
                                            style: TextStyle(
                                                color: theme_color_df),
                                          ),
                                        ),
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          '${MultiLanguages.of(context)!.translate('order_qty')} : ${controller.itemDropship!.cartHeader.cartDetail[index].qty}',
                                          style:
                                              TextStyle(color: theme_color_df),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Text(
                                              MultiLanguages.of(context)!
                                                  .translate('total_prices'),
                                              style: setTextColordf),
                                        ),
                                        Text(
                                            '${myFormat.format(controller.itemDropship!.cartHeader.cartDetail[index].price * controller.itemDropship!.cartHeader.cartDetail[index].qty)} ${MultiLanguages.of(context)!.translate('order_baht')}',
                                            style: setTextColordf),
                                      ],
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              )));
    });
  }
}
