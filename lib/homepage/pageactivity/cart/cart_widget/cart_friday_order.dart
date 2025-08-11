// ? widget ส่วนรายการตระกร้าสินค้า
import 'dart:async';
// import 'dart:developer';

import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/setbillcolor.dart';
import 'package:fridayonline/model/cart/cart_getItems.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../controller/cart/cart_controller.dart';
// import '../../../../controller/cart/delivery_controller.dart';
// import '../../../../controller/cart/dropship_controller.dart';
import '../../../../controller/cart/function_add_to_cart.dart';
import '../../../../service/address/addresssearch.dart';
import '../../../../service/languages/multi_languages.dart';
import '../../../theme/theme_color.dart';

//? ตั้งดีเลให้ช่องแก้ไขจำนวน
Timer? _debounce;
FetchCartItemsController controller = Get.find<FetchCartItemsController>();

MediaQuery listCart(scaffoldKey, context, List<TextEditingController> inputors,
    int index, bool enableEdit) {
  return MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(1.0)),
    child: ListTile(
      contentPadding: const EdgeInsets.only(right: 16, left: 16),
      leading: null,
      title: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 0.5,
                          style: BorderStyle.solid,
                          color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: controller
                        .itemsCartList!.cardHeader.carddetail[index].billImg,
                  ),
                ),
                if (controller.itemsCartList!.cardHeader.carddetail[index]
                        .flagNetPrice ==
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
                if (!controller
                    .itemsCartList!.cardHeader.carddetail[index].isInStock)
                  CachedNetworkImage(
                    width: 50,
                    imageUrl: controller
                        .itemsCartList!.cardHeader.carddetail[index].imgAppend,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  maxLines: 2,
                  controller
                      .itemsCartList!.cardHeader.carddetail[index].billName,
                  style: const TextStyle(
                      height: 1, fontSize: 16, overflow: TextOverflow.ellipsis),
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text:
                          MultiLanguages.of(context)!.translate('product_code'),
                      style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black,
                          fontFamily: 'notoreg')),
                  TextSpan(
                      text:
                          '  ${controller.itemsCartList!.cardHeader.carddetail[index].billCode}',
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: setBillColor(controller.itemsCartList!
                              .cardHeader.carddetail[index].billColor))),
                ])),
                if (controller.itemsCartList!.cardHeader.carddetail[index]
                        .stockDescription.isNotEmpty &&
                    enableEdit)
                  Text(
                      controller.itemsCartList!.cardHeader.carddetail[index]
                          .stockDescription,
                      style:
                          TextStyle(fontSize: 13, height: 1, color: theme_red)),
                enableEdit
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                MultiLanguages.of(context)!
                                    .translate('product_price'),
                                style: TextStyle(
                                    color: theme_color_df, fontSize: 14),
                              ),
                              Text(
                                  "${myFormat.format(controller.itemsCartList!.cardHeader.carddetail[index].price)} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                  style: TextStyle(
                                      color: theme_color_df, fontSize: 14)),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  MultiLanguages.of(context)!
                                      .translate('total_prices'),
                                  style: TextStyle(
                                      fontWeight: boldText,
                                      color: theme_color_df,
                                      fontSize: 15),
                                ),
                              ),
                              GetBuilder<CartItemsEdit>(builder: (data) {
                                if (data.isDataLoading.value) {}
                                return Text(
                                    "${myFormat.format(controller.itemsCartList!.cardHeader.carddetail[index].price * controller.itemsCartList!.cardHeader.carddetail[index].qty)} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                    style: TextStyle(
                                        fontWeight: boldText,
                                        fontSize: 15,
                                        color: theme_color_df));
                              }),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(),
                if (enableEdit)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            //? remove button
                            child: BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.5,
                              onPressed: (() async {
                                if (inputors[index].text.isNotEmpty) {
                                  if (!Get.find<CartItemsEdit>()
                                      .isDataLoading
                                      .value) {
                                    inputors[index].selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            inputors[index].text.length);
                                    var remove =
                                        int.parse(inputors[index].text) - 1;
                                    if (remove >= 1) {
                                      inputors[index].value = inputors[index]
                                          .value
                                          .copyWith(text: remove.toString());
                                      controller.itemsCartList!.cardHeader
                                          .carddetail[index].qty = remove;
                                      await fnEditCart(
                                          context,
                                          controller.itemsCartList!.cardHeader
                                              .carddetail[index],
                                          'cart_edit_amount',
                                          '',
                                          '',
                                          ref: 'cart',
                                          contentId: '');
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
                                  textInputAction: TextInputAction.done,
                                  autofocus: false,
                                  showCursor: false,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  controller: inputors[index],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                    FilteringTextInputFormatter.deny(
                                      RegExp(
                                          r'^0+'), //ป้องกันการใส่เลข 0 ตำแหน่งแรก
                                    ),
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  // style: const TextStyle(fontSize: 14),
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {
                                    inputors[index].selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            inputors[index].text.length);
                                  },
                                  onChanged: (text) async {
                                    if (text.isNotEmpty) {
                                      //? set delay เพื่อไม่ให้มีการส่ง alert ซ้ำ
                                      if (_debounce?.isActive ?? false) {
                                        _debounce!.cancel();
                                      }
                                      _debounce = Timer(
                                          const Duration(milliseconds: 500),
                                          () async {
                                        controller
                                            .itemsCartList!
                                            .cardHeader
                                            .carddetail[index]
                                            .qty = int.parse(text);
                                        Get.find<FetchCartItemsController>()
                                            .isDataLoading(true);

                                        await checkLimitProduct(
                                            scaffoldKey,
                                            context,
                                            controller.itemsCartList!.cardHeader
                                                .carddetail[index],
                                            inputors);
                                      });
                                    } else {
                                      if (text.isEmpty) {
                                        inputors[index].text = '1';
                                        inputors[index].selection =
                                            TextSelection(
                                                baseOffset: 0,
                                                extentOffset: inputors[index]
                                                    .text
                                                    .length);
                                        controller.itemsCartList!.cardHeader
                                                .carddetail[index].qty =
                                            int.parse(inputors[index].text);
                                        await checkLimitProduct(
                                            scaffoldKey,
                                            context,
                                            controller.itemsCartList!.cardHeader
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
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 1.5,
                                onPressed: (() async {
                                  if (inputors[index].text.isNotEmpty) {
                                    if (!Get.find<CartItemsEdit>()
                                        .isDataLoading
                                        .value) {
                                      inputors[index].selection = TextSelection(
                                          baseOffset: 0,
                                          extentOffset:
                                              inputors[index].text.length);
                                      var add =
                                          int.parse(inputors[index].text) + 1;
                                      if (add <= 999) {
                                        inputors[index].value = inputors[index]
                                            .value
                                            .copyWith(text: add.toString());
                                        controller.itemsCartList!.cardHeader
                                            .carddetail[index].qty = add;
                                        await checkLimitProduct(
                                            scaffoldKey,
                                            context,
                                            controller.itemsCartList!.cardHeader
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
                          duration: const Duration(milliseconds: 100),
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
                                contentId: '');
                            inputors.removeAt(index);
                          },
                          child: Image.asset(
                              scale: 1.8, 'assets/images/cart/delete.png'),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              '${MultiLanguages.of(context)!.translate('product_price')}  ${myFormat.format(controller.itemsCartList!.cardHeader.carddetail[index].price)} ${MultiLanguages.of(context)!.translate('order_baht')}',
                              style: TextStyle(
                                  fontSize: 14, color: theme_color_df),
                            ),
                          ),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            '${MultiLanguages.of(context)!.translate('order_qty')} : ${controller.itemsCartList!.cardHeader.carddetail[index].qty}',
                            style:
                                TextStyle(fontSize: 14, color: theme_color_df),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                                MultiLanguages.of(context)!
                                    .translate('total_prices'),
                                style: TextStyle(
                                    fontWeight: boldText,
                                    color: theme_color_df,
                                    fontSize: 15)),
                          ),
                          Text(
                              '${myFormat.format(controller.itemsCartList!.cardHeader.carddetail[index].price * controller.itemsCartList!.cardHeader.carddetail[index].qty)} ${MultiLanguages.of(context)!.translate('order_baht')}',
                              style: TextStyle(
                                  fontWeight: boldText,
                                  color: theme_color_df,
                                  fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

MediaQuery listCartB2C(scaffoldKey, context, TextEditingController inputors,
    Carddetail cartDetail, bool enableEdit) {
  return MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(1.0)),
    child: ListTile(
      contentPadding: const EdgeInsets.only(right: 16, left: 16),
      leading: null,
      title: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 0.5,
                          style: BorderStyle.solid,
                          color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: cartDetail.billImg,
                  ),
                ),
                if (cartDetail.flagNetPrice == "Y")
                  Positioned(
                    top: 0,
                    left: 0,
                    child: CachedNetworkImage(
                      imageUrl: cartDetail.imgNetPrice,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      width: 60,
                    ),
                  ),
                if (!cartDetail.isInStock)
                  CachedNetworkImage(
                    width: 50,
                    imageUrl: cartDetail.imgAppend,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  maxLines: 2,
                  cartDetail.billName,
                  style: const TextStyle(
                      height: 1, fontSize: 16, overflow: TextOverflow.ellipsis),
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text:
                          MultiLanguages.of(context)!.translate('product_code'),
                      style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black,
                          fontFamily: 'notoreg')),
                  TextSpan(
                      text: '  ${cartDetail.billCode}',
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: setBillColor(cartDetail.billColor))),
                ])),
                if (cartDetail.stockDescription.isNotEmpty && enableEdit)
                  Text(cartDetail.stockDescription,
                      style:
                          TextStyle(fontSize: 13, height: 1, color: theme_red)),
                enableEdit
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                MultiLanguages.of(context)!
                                    .translate('product_price'),
                                style: TextStyle(
                                    color: theme_color_df, fontSize: 14),
                              ),
                              Text(
                                  "${myFormat.format(cartDetail.price)} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                  style: TextStyle(
                                      color: theme_color_df, fontSize: 14)),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  MultiLanguages.of(context)!
                                      .translate('total_prices'),
                                  style: TextStyle(
                                      fontWeight: boldText,
                                      color: theme_color_df,
                                      fontSize: 15),
                                ),
                              ),
                              GetBuilder<CartItemsEdit>(builder: (data) {
                                if (data.isDataLoading.value) {}
                                return Text(
                                    "${myFormat.format(cartDetail.price * cartDetail.qty)} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                    style: TextStyle(
                                        fontWeight: boldText,
                                        fontSize: 15,
                                        color: theme_color_df));
                              }),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(),
                if (enableEdit)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            //? remove button
                            child: BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.5,
                              onPressed: (() async {
                                if (inputors.text.isNotEmpty) {
                                  if (!Get.find<CartItemsEdit>()
                                      .isDataLoading
                                      .value) {
                                    inputors.selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset: inputors.text.length);
                                    var remove = int.parse(inputors.text) - 1;
                                    if (remove >= 1) {
                                      inputors.value = inputors.value
                                          .copyWith(text: remove.toString());
                                      cartDetail.qty = remove;
                                      await fnEditCart(context, cartDetail,
                                          'cart_edit_amount', '', '',
                                          ref: 'cart', contentId: '');
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
                                  textInputAction: TextInputAction.done,
                                  autofocus: false,
                                  showCursor: false,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  controller: inputors,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                    FilteringTextInputFormatter.deny(
                                      RegExp(
                                          r'^0+'), //ป้องกันการใส่เลข 0 ตำแหน่งแรก
                                    ),
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  // style: const TextStyle(fontSize: 14),
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {
                                    inputors.selection = TextSelection(
                                        baseOffset: 0,
                                        extentOffset: inputors.text.length);
                                  },
                                  onChanged: (text) async {
                                    if (text.isNotEmpty) {
                                      //? set delay เพื่อไม่ให้มีการส่ง alert ซ้ำ
                                      if (_debounce?.isActive ?? false) {
                                        _debounce!.cancel();
                                      }
                                      _debounce = Timer(
                                          const Duration(milliseconds: 500),
                                          () async {
                                        cartDetail.qty = int.parse(text);
                                        Get.find<FetchCartItemsController>()
                                            .isDataLoading(true);

                                        await checkLimitProduct(scaffoldKey,
                                            context, cartDetail, inputors);
                                      });
                                    } else {
                                      if (text.isEmpty) {
                                        inputors.text = '1';
                                        inputors.selection = TextSelection(
                                            baseOffset: 0,
                                            extentOffset: inputors.text.length);
                                        cartDetail.qty =
                                            int.parse(inputors.text);
                                        await checkLimitProduct(scaffoldKey,
                                            context, cartDetail, inputors);
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
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 1.5,
                                onPressed: (() async {
                                  if (inputors.text.isNotEmpty) {
                                    if (!Get.find<CartItemsEdit>()
                                        .isDataLoading
                                        .value) {
                                      inputors.selection = TextSelection(
                                          baseOffset: 0,
                                          extentOffset: inputors.text.length);
                                      var add = int.parse(inputors.text) + 1;
                                      if (add <= 999) {
                                        inputors.value = inputors.value
                                            .copyWith(text: add.toString());
                                        cartDetail.qty = add;
                                        await checkLimitProduct(scaffoldKey,
                                            context, cartDetail, inputors);
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
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.5,
                          onPressed: () async {
                            await fnEditCart(
                                context, cartDetail, 'cart_page_delete', '', '',
                                ref: 'cart', contentId: '');
                            inputors.clear();
                          },
                          child: Image.asset(
                              scale: 1.8, 'assets/images/cart/delete.png'),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              '${MultiLanguages.of(context)!.translate('product_price')}  ${myFormat.format(cartDetail.price)} ${MultiLanguages.of(context)!.translate('order_baht')}',
                              style: TextStyle(color: theme_color_df),
                            ),
                          ),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            '${MultiLanguages.of(context)!.translate('order_qty')} : ${cartDetail.qty}',
                            style: TextStyle(color: theme_color_df),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                                MultiLanguages.of(context)!
                                    .translate('total_prices'),
                                style: TextStyle(
                                    fontWeight: boldText,
                                    color: theme_color_df,
                                    fontSize: 15)),
                          ),
                          Text(
                              '${myFormat.format(cartDetail.price * cartDetail.qty)} ${MultiLanguages.of(context)!.translate('order_baht')}',
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
    ),
  );
}

Future<void> checkLimitProduct(
    scaffoldKey, context, Carddetail cartDetail, inputors) async {
  var checkLimit = await fnEditCartInPageCart(
      scaffoldKey, context, cartDetail, 'cart_edit_amount');
  if (inputors.runtimeType == TextEditingController) {
    if (checkLimit.toString().toLowerCase() != 'sussess') {
      inputors.text = cartDetail.qty.toString();
    }
  } else {
    if (checkLimit.toString().toLowerCase() != 'sussess') {
      var direcSale = controller.itemsCartList!.cardHeader.carddetail;

      for (var i = 0; i < direcSale.length; i++) {
        inputors[i].text = direcSale[i].qtyConfirm.toString();
      }
    }
  }
}

show_case_list_Cart(
    scaffoldKey,
    context,
    FetchCartItemsController controller,
    List<TextEditingController> inputors,
    int index,
    bool enableEdit,
    GlobalKey<State<StatefulWidget>> keyTwo,
    GlobalKey<State<StatefulWidget>> keyThree,
    GlobalKey<State<StatefulWidget>> keyFour,
    MultiLanguages ChangeLanguage) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  // FetchCartDropshipController itemsDropship =
  //     Get.find<FetchCartDropshipController>();
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: ListTileTheme(
        minLeadingWidth: 2,
        horizontalTitleGap: 0,
        contentPadding: const EdgeInsets.only(right: 16, left: 4),
        child: ListTile(
          //? fade dropship
          // leading: _enableEdit == true
          //     ? SizedBox(
          //         height: 24.0,
          //         width: 42.0,
          //         child: Checkbox(
          //             side: BorderSide(width: 1, color: theme_color_df),
          //             value: controller.itemsCartList!.cardHeader
          //                 .carddetail[index].isChecked,
          //             onChanged: (bool? value) {
          //               controller.updateCheckbox(false);
          //               setState(() {
          //                 controller.itemsCartList!.cardHeader.carddetail[index]
          //                     .isChecked = value!;
          //                 controller.isChecked = controller
          //                     .itemsCartList!.cardHeader.carddetail
          //                     .every((element) => element.isChecked);
          //                 controller.allowMultiple = controller
          //                     .itemsCartList!.cardHeader.carddetail
          //                     .every((element) {
          //                   if (itemsDropship
          //                       .itemDropship!.cartHeader.cartDetail.isEmpty) {
          //                     if (controller.isChecked) {
          //                       return true;
          //                     } else {
          //                       return false;
          //                     }
          //                   } else {
          //                     if (controller.isChecked &&
          //                         controller.isCheckedDropship) {
          //                       return true;
          //                     } else {
          //                       return false;
          //                     }
          //                   }
          //                 });
          //               });
          //             }),
          //       )
          //     : null,
          title: Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  clipBehavior: Clip.antiAlias,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1.0,
                              style: BorderStyle.solid,
                              color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: controller.itemsCartList!.cardHeader
                            .carddetail[index].billImg,
                        // height: 100,
                      ),
                    ),
                    if (controller.itemsCartList!.cardHeader.carddetail[index]
                            .flagNetPrice ==
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
                    if (!controller
                        .itemsCartList!.cardHeader.carddetail[index].isInStock)
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
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      maxLines: 3,
                      controller
                          .itemsCartList!.cardHeader.carddetail[index].billName,
                      style: const TextStyle(
                          height: 1,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: MultiLanguages.of(context)!
                              .translate('product_code'),
                          style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.black,
                              fontFamily: 'notoreg')),
                      TextSpan(
                          text:
                              '  ${controller.itemsCartList!.cardHeader.carddetail[index].billCode}',
                          style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: setBillColor(controller.itemsCartList!
                                  .cardHeader.carddetail[index].billColor))),
                    ])),
                    if (controller.itemsCartList!.cardHeader.carddetail[index]
                            .stockDescription.isNotEmpty &&
                        enableEdit)
                      Text(
                          controller.itemsCartList!.cardHeader.carddetail[index]
                              .stockDescription,
                          style: TextStyle(
                              fontSize: 13, height: 1, color: theme_red)),
                    const SizedBox(
                      height: 5,
                    ),
                    enableEdit
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    MultiLanguages.of(context)!
                                        .translate('product_price'),
                                    style: TextStyle(
                                        fontSize: 14, color: theme_color_df),
                                  ),
                                  Text(
                                      "${myFormat.format(controller.itemsCartList!.cardHeader.carddetail[index].price)} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                      style: TextStyle(
                                          fontSize: 14, color: theme_color_df)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    MultiLanguages.of(context)!
                                        .translate('total_prices'),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: boldText,
                                        color: theme_color_df),
                                  ),
                                  GetBuilder<CartItemsEdit>(builder: (data) {
                                    if (data.isDataLoading.value) {}
                                    return Text(
                                        "${myFormat.format(controller.itemsCartList!.cardHeader.carddetail[index].price * controller.itemsCartList!.cardHeader.carddetail[index].qty)} ${MultiLanguages.of(context)!.translate('order_baht')}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: boldText,
                                            color: theme_color_df));
                                  }),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox(),
                    enableEdit
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Showcase.withWidget(
                                disableMovingAnimation: true,
                                width: width,
                                height: height / 1.4,
                                container: InkWell(
                                  onTap: () {
                                    ShowCaseWidget.of(context)
                                        .startShowCase([keyThree]);
                                  },
                                  child: MediaQuery(
                                    data: MediaQuery.of(context).copyWith(
                                        textScaler:
                                            const TextScaler.linear(1.0)),
                                    child: SizedBox(
                                      width: width / 1,
                                      height: height / 2,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 60.0, top: 50),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Container(
                                                  color: theme_color_df,
                                                  width: 250,
                                                  height: 80,
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        ChangeLanguage.translate(
                                                            'guide_in_cart2'),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 220.0),
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                        WidgetStateProperty.all<Color>(
                                                            theme_color_df),
                                                    backgroundColor:
                                                        WidgetStateProperty.all<Color>(
                                                            Colors.white),
                                                    shape: WidgetStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(
                                                                30.0),
                                                            side: BorderSide(
                                                                color: theme_color_df)))),
                                                onPressed: () {
                                                  ShowCaseWidget.of(context)
                                                      .startShowCase(
                                                          [keyThree]);
                                                },
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 40,
                                                  child: Center(
                                                    child: Text(
                                                        maxLines: 1,
                                                        ChangeLanguage.translate(
                                                            'btn_next_guide'),
                                                        style: const TextStyle(
                                                            fontSize: 16)),
                                                  ),
                                                )),
                                          ),
                                          Expanded(
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      ShowCaseWidget.of(context)
                                                          .next();
                                                      ShowCaseWidget.of(context)
                                                          .next();
                                                      ShowCaseWidget.of(context)
                                                          .next();
                                                    })),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //overlayColor: theme_color_df,
                                // targetPadding: const EdgeInsets.all(20),
                                key: keyTwo,
                                disposeOnTap: true,
                                onTargetClick: () {
                                  ShowCaseWidget.of(context)
                                      .startShowCase([keyThree]);
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: BouncingWidget(
                                        duration:
                                            const Duration(milliseconds: 100),
                                        scaleFactor: 1.5,
                                        onPressed: (() async {
                                          if (inputors[index].text.isNotEmpty) {
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
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                              FilteringTextInputFormatter.deny(
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
                                                          inputors[index].text);
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
                                                var add = int.parse(
                                                        inputors[index].text) +
                                                    1;
                                                if (add <= 999) {
                                                  inputors[index].value =
                                                      inputors[index]
                                                          .value
                                                          .copyWith(
                                                              text: add
                                                                  .toString());
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
                              ),
                              Showcase.withWidget(
                                disableMovingAnimation: true,
                                width: width,
                                height: height / 1.4,
                                container: InkWell(
                                  onTap: () {
                                    ShowCaseWidget.of(context)
                                        .startShowCase([keyFour]);
                                  },
                                  child: MediaQuery(
                                    data: MediaQuery.of(context).copyWith(
                                        textScaler:
                                            const TextScaler.linear(1.0)),
                                    child: SizedBox(
                                      width: width / 1,
                                      height: height / 2,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 60.0, top: 50),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Container(
                                                  color: theme_color_df,
                                                  width: 250,
                                                  height: 80,
                                                  child: Center(
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      ChangeLanguage.translate(
                                                          'guide_in_cart3'),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 220.0),
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                        WidgetStateProperty.all<Color>(
                                                            theme_color_df),
                                                    backgroundColor:
                                                        WidgetStateProperty.all<Color>(
                                                            Colors.white),
                                                    shape: WidgetStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(
                                                                30.0),
                                                            side: BorderSide(
                                                                color: theme_color_df)))),
                                                onPressed: () {
                                                  ShowCaseWidget.of(context)
                                                      .startShowCase([keyFour]);
                                                },
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 40,
                                                  child: Center(
                                                    child: Text(
                                                        maxLines: 1,
                                                        ChangeLanguage.translate(
                                                            'btn_next_guide'),
                                                        style: const TextStyle(
                                                            fontSize: 16)),
                                                  ),
                                                )),
                                          ),
                                          Expanded(
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      ShowCaseWidget.of(context)
                                                          .next();
                                                      ShowCaseWidget.of(context)
                                                          .next();
                                                    })),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //overlayColor: theme_color_df,
                                // targetPadding: const EdgeInsets.all(20),
                                key: keyThree,
                                disposeOnTap: true,
                                onTargetClick: () {
                                  ShowCaseWidget.of(context)
                                      .startShowCase([keyFour]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: BouncingWidget(
                                    duration: const Duration(milliseconds: 100),
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
                                          contentId: '');
                                      for (var i = 0;
                                          i <
                                              controller.itemsCartList!
                                                  .cardHeader.carddetail.length;
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
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${MultiLanguages.of(context)!.translate('product_price')}  ${myFormat.format(controller.itemsCartList!.cardHeader.carddetail[index].price)} ${MultiLanguages.of(context)!.translate('order_baht')}',
                                    style: TextStyle(color: theme_color_df),
                                  ),
                                  Text(
                                    '${MultiLanguages.of(context)!.translate('order_qty')} : ${controller.itemsCartList!.cardHeader.carddetail[index].qty}',
                                    style: TextStyle(color: theme_color_df),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      MultiLanguages.of(context)!
                                          .translate('total_prices'),
                                      style: TextStyle(
                                          fontWeight: boldText,
                                          color: theme_color_df,
                                          fontSize: 15)),
                                  Text(
                                      overflow: TextOverflow.ellipsis,
                                      '${myFormat.format(controller.itemsCartList!.cardHeader.carddetail[index].price * controller.itemsCartList!.cardHeader.carddetail[index].qty)} ${MultiLanguages.of(context)!.translate('order_baht')}',
                                      style: TextStyle(
                                          fontWeight: boldText,
                                          color: theme_color_df,
                                          fontSize: 15)),
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}
