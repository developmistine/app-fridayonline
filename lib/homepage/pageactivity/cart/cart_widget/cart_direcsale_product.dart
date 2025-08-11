import 'dart:async';

import 'package:fridayonline/controller/cart/cart_controller.dart';
import 'package:fridayonline/controller/cart/dropship_controller.dart';
import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/theme/setbillcolor.dart';
import 'package:fridayonline/model/cart/cart_getItems.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/cart/function_add_to_cart.dart';
import '../../../../service/address/addresssearch.dart';
import '../../../../service/languages/multi_languages.dart';
import '../../../theme/theme_color.dart';
import '../cart_theme/cart_all_theme.dart';
import 'cart_friday_order.dart';

class FridayList extends StatefulWidget {
  const FridayList(this.controller, this.index, this._enableEdit, this.inputors,
      this.scaffoldKey,
      {super.key});
  final FetchCartItemsController controller; //? ข้อมูลสินค้าในตระกร้า
  final int index;
  final bool _enableEdit; //? เปิด - ปิดการแก้ไข
  final List<TextEditingController> inputors; //? จำนวนสินค้าใน textfield
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<FridayList> createState() =>
      _FridayListState(controller, index, _enableEdit, inputors, scaffoldKey);
}

class _FridayListState extends State<FridayList> {
  _FridayListState(this.controller, this.index, this._enableEdit, this.inputors,
      this.scaffoldKey);
  FetchCartItemsController controller; //? ข้อมูลสินค้าในตระกร้า
  int index;
  final bool _enableEdit; //? เปิด - ปิดการแก้ไข
  List<TextEditingController> inputors; //? จำนวนสินค้าใน textfield
  Timer? _debounce;
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Carddetail> list2 = [];
  FetchCartDropshipController itemsDropship =
      Get.find<FetchCartDropshipController>();
  int i = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // for (var element in controller.itemsCartList!.cardHeader.carddetail) {
    //   element.isChecked = true;
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: ListTileTheme(
            minLeadingWidth: 2,
            horizontalTitleGap: 0,
            contentPadding: const EdgeInsets.only(right: 16, left: 16),
            child: ListTile(
              leading: _enableEdit == true
                  ? null
                  // ? SizedBox(
                  //     height: 24.0,
                  //     width: 42.0,
                  //     child: Checkbox(
                  //         side: BorderSide(width: 1, color: theme_color_df),
                  //         value: controller.itemsCartList!.cardHeader
                  //             .carddetail[index].isChecked,
                  //         onChanged: (bool? value) {
                  //           controller.updateCheckbox(false);
                  //           setState(() {
                  //             controller.itemsCartList!.cardHeader
                  //                 .carddetail[index].isChecked = value!;
                  //             controller.isChecked = controller
                  //                 .itemsCartList!.cardHeader.carddetail
                  //                 .every((element) => element.isChecked);
                  //             controller.allowMultiple = controller
                  //                 .itemsCartList!.cardHeader.carddetail
                  //                 .every((element) {
                  //               if (itemsDropship.itemDropship!.cartHeader
                  //                   .cartDetail.isEmpty) {
                  //                 if (controller.isChecked) {
                  //                   return true;
                  //                 } else {
                  //                   return false;
                  //                 }
                  //               } else {
                  //                 if (controller.isChecked &&
                  //                     controller.isCheckedDropship) {
                  //                   return true;
                  //                 } else {
                  //                   return false;
                  //                 }
                  //               }
                  //             });
                  //           });
                  //         }),
                  //   )
                  : null,
              title: Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                  color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              if (_enableEdit) {
                                var mChannel = '6';
                                var mChannelId = '';
                                Get.find<ProductDetailController>()
                                    .productDetailController(
                                  controller.itemsCartList!.cardHeader
                                      .carddetail[index].billcamp,
                                  controller.itemsCartList!.cardHeader
                                      .carddetail[index].billCode,
                                  controller.itemsCartList!.cardHeader
                                      .carddetail[index].media,
                                  controller.itemsCartList!.cardHeader
                                      .carddetail[index].fsCode,
                                  mChannel,
                                  mChannelId,
                                );
                                Get.to(() => const ProductDetailPage(
                                      ref: '',
                                      contentId: '',
                                    ));
                              }
                            },
                            child: CachedNetworkImage(
                              imageUrl: controller.itemsCartList!.cardHeader
                                  .carddetail[index].billImg,
                              // height: 100,
                            ),
                          ),
                        ),
                        if (controller.itemsCartList!.cardHeader
                                .carddetail[index].flagNetPrice ==
                            "Y")
                          Positioned(
                            top: 0,
                            left: 0,
                            child: CachedNetworkImage(
                              imageUrl: controller.itemsCartList!.cardHeader
                                  .carddetail[index].imgNetPrice,
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                              width: 60,
                            ),
                          ),
                        if (!controller.itemsCartList!.cardHeader
                            .carddetail[index].isInStock)
                          CachedNetworkImage(
                            width: 50,
                            imageUrl: controller.itemsCartList!.cardHeader
                                .carddetail[index].imgAppend,
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.itemsCartList!.cardHeader.carddetail[index]
                              .billName,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 16, overflow: TextOverflow.ellipsis),
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: MultiLanguages.of(context)!
                                  .translate('product_code'),
                              style: const TextStyle(
                                  fontSize: 14,
                                  height: 2,
                                  color: Colors.black,
                                  fontFamily: 'notoreg')),
                          TextSpan(
                              text:
                                  '  ${controller.itemsCartList!.cardHeader.carddetail[index].billCode}',
                              style: TextStyle(
                                  fontSize: 14,
                                  height: 2,
                                  color: setBillColor(controller
                                      .itemsCartList!
                                      .cardHeader
                                      .carddetail[index]
                                      .billColor))),
                        ])),
                        if (controller
                                .itemsCartList!
                                .cardHeader
                                .carddetail[index]
                                .stockDescription
                                .isNotEmpty &&
                            _enableEdit)
                          Text(
                              controller.itemsCartList!.cardHeader
                                  .carddetail[index].stockDescription,
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
                                        style: TextStyle(color: theme_color_df),
                                      ),
                                      Text(
                                          "${myFormat.format(controller.itemsCartList!.cardHeader.carddetail[index].price)} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                          style:
                                              TextStyle(color: theme_color_df)),
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
                                      GetBuilder<CartItemsEdit>(
                                          builder: (data) {
                                        if (data.isDataLoading.value) {}
                                        return Text(
                                            "${myFormat.format(controller.itemsCartList!.cardHeader.carddetail[index].price * controller.itemsCartList!.cardHeader.carddetail[index].qty)} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                            style: TextStyle(
                                                fontWeight: boldText,
                                                color: theme_color_df));
                                      }),
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
                                          duration:
                                              const Duration(milliseconds: 100),
                                          scaleFactor: 1.5,
                                          onPressed: (() async {
                                            if (inputors[index]
                                                .text
                                                .isNotEmpty) {
                                              if (!Get.find<CartItemsEdit>()
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
                                                        inputors[index].text) -
                                                    1;
                                                if (remove >= 1) {
                                                  inputors[index].value =
                                                      inputors[index]
                                                          .value
                                                          .copyWith(
                                                              text: remove
                                                                  .toString());
                                                  controller
                                                      .itemsCartList!
                                                      .cardHeader
                                                      .carddetail[index]
                                                      .qty = remove;
                                                  await fnEditCart(
                                                      context,
                                                      controller
                                                          .itemsCartList!
                                                          .cardHeader
                                                          .carddetail[index],
                                                      'cart_edit_amount',
                                                      '',
                                                      '',
                                                      ref: 'cart',
                                                      contentId: '');
                                                  // await Get.find<FetchDeliveryChange>()
                                                  //     .fetchDeliveryChange(controller
                                                  //         .itemsCartList!
                                                  //         .cardHeader
                                                  //         .totalAmount);
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
                                              enableInteractiveSelection: false,
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
                                              decoration: const InputDecoration(
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
                                                        .itemsCartList!
                                                        .cardHeader
                                                        .carddetail[index]
                                                        .qty = int.parse(text);
                                                    Get.find<
                                                            FetchCartItemsController>()
                                                        .isDataLoading(true);

                                                    await checkLimitProduct(
                                                        scaffoldKey,
                                                        context,
                                                        controller
                                                            .itemsCartList!
                                                            .cardHeader
                                                            .carddetail[index],
                                                        inputors);
                                                  });
                                                } else {
                                                  if (text.isEmpty) {
                                                    inputors[index].text = '1';
                                                    inputors[index].selection =
                                                        TextSelection(
                                                            baseOffset: 0,
                                                            extentOffset:
                                                                inputors[index]
                                                                    .text
                                                                    .length);
                                                    controller
                                                            .itemsCartList!
                                                            .cardHeader
                                                            .carddetail[index]
                                                            .qty =
                                                        int.parse(
                                                            inputors[index]
                                                                .text);
                                                    await checkLimitProduct(
                                                        scaffoldKey,
                                                        context,
                                                        controller
                                                            .itemsCartList!
                                                            .cardHeader
                                                            .carddetail[index],
                                                        inputors);
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
                                                if (!Get.find<CartItemsEdit>()
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
                                                            text:
                                                                add.toString());
                                                    controller
                                                        .itemsCartList!
                                                        .cardHeader
                                                        .carddetail[index]
                                                        .qty = add;
                                                    await checkLimitProduct(
                                                        scaffoldKey,
                                                        context,
                                                        controller
                                                            .itemsCartList!
                                                            .cardHeader
                                                            .carddetail[index],
                                                        inputors);
                                                    // await Call_cart_edit(controller, index, add);
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
                                        await fnEditCart(
                                          context,
                                          controller.itemsCartList!.cardHeader
                                              .carddetail[index],
                                          'cart_page_delete',
                                          '',
                                          '',
                                          ref: 'cart',
                                          contentId: '',
                                        );
                                        for (var i = 0;
                                            i <
                                                controller
                                                    .itemsCartList!
                                                    .cardHeader
                                                    .carddetail
                                                    .length;
                                            i++) {
                                          inputors[i].text = controller
                                              .itemsCartList!
                                              .cardHeader
                                              .carddetail[i]
                                              .qty
                                              .toString();
                                        }
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
                                          '${MultiLanguages.of(context)!.translate('product_price')}  ${myFormat.format(controller.itemsCartList!.cardHeader.carddetail[index].price)} ${MultiLanguages.of(context)!.translate('order_baht')}',
                                          style:
                                              TextStyle(color: theme_color_df),
                                        ),
                                      ),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        '${MultiLanguages.of(context)!.translate('order_qty')} : ${controller.itemsCartList!.cardHeader.carddetail[index].qty}',
                                        style: TextStyle(color: theme_color_df),
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
                                          '${myFormat.format(controller.itemsCartList!.cardHeader.carddetail[index].price * controller.itemsCartList!.cardHeader.carddetail[index].qty)} ${MultiLanguages.of(context)!.translate('order_baht')}',
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
  }
}
