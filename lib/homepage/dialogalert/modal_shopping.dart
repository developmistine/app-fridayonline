import 'dart:ui';

import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/model/product_detail/product_detail_model.dart';
import 'package:fridayonline/safearea.dart';
import 'package:fridayonline/service/languages/multi_languages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../controller/cart/function_add_to_cart.dart';
// import '../pageactivity/cart/cart_widget/cart_friday_order.dart';

TextEditingController _controller = TextEditingController();
BuildContext contextAlert = Get.context!;

modalAddtoCart(
  BuildContext context,
  ProductDetailModel listproduct,
  String mChannel,
  String mChannelId,
  String ref,
  String contentId,
) {
  // FocusNode CountItems = FocusNode();
  _controller.value = _controller.value.copyWith(text: 1.toString());
  final ctr = Get.find<ProductDetailController>();

  // return showBarModalBottomSheet(
  return showMaterialModalBottomSheet(
      backgroundColor: Colors.white,
      isDismissible: false,
      enableDrag: false,
      barrierColor: Colors.black26,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      context: context,
      builder: (builder) {
        _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));

        return SafeAreaProvider(
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  FocusScope.of(context).unfocus();
                });
              },
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 4.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 14,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: CachedNetworkImage(
                                height: 80,
                                imageUrl: listproduct.productImages.image[0],
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(listproduct.billName),
                                    Text(
                                      '${myFormat.format(listproduct.specialPrice)} ${MultiLanguages.of(context)!.translate('order_baht')}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: theme_color_df,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        if (listproduct.productGroups.length > 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("ตัวเลือก",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxHeight: 180),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisExtent: 62,
                                            crossAxisCount: 2),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            ProductGroup prdGroup = listproduct
                                                .productGroups[index];
                                            ctr.setProductDetailByProductGroup(
                                                prdGroup, index);
                                          });
                                        },
                                        child: Card(
                                          color: !listproduct
                                                  .productGroups[index]
                                                  .isInStock
                                              ? theme_grey_bg
                                              : ctr.indexProductGroup.value ==
                                                      index
                                                  ? theme_color_df
                                                      .withOpacity(0.5)
                                                  : theme_grey_bg,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            side: BorderSide(
                                              color:
                                                  ctr.indexProductGroup.value ==
                                                          index
                                                      ? theme_color_df
                                                      : Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Stack(
                                                alignment: Alignment.topRight,
                                                clipBehavior: Clip.antiAlias,
                                                children: [
                                                  if (listproduct
                                                      .productGroups[index]
                                                      .isInStock)
                                                    Card(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        side: BorderSide(
                                                          color: Colors
                                                              .grey.shade300,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: CachedNetworkImage(
                                                          width: 50,
                                                          height: 50,
                                                          imageUrl: listproduct
                                                              .productGroups[
                                                                  index]
                                                              .productImages
                                                              .image[0]),
                                                    ),
                                                  if (!listproduct
                                                      .productGroups[index]
                                                      .isInStock)
                                                    Card(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        side: BorderSide(
                                                          color: Colors
                                                              .grey.shade300,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          CachedNetworkImage(
                                                              width: 50,
                                                              height: 50,
                                                              imageUrl: listproduct
                                                                  .productGroups[
                                                                      index]
                                                                  .productImages
                                                                  .image[0]),
                                                          Positioned.fill(
                                                            child:
                                                                BackdropFilter(
                                                              filter: ImageFilter
                                                                  .blur(
                                                                      sigmaX:
                                                                          0.8,
                                                                      sigmaY:
                                                                          0.8), // ปรับค่า sigma ให้เบลอ
                                                              child: Container(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.5), // สีขาวโปร่งแสง 50%
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  if (!listproduct
                                                      .productGroups[index]
                                                      .isInStock)
                                                    CachedNetworkImage(
                                                        width: 28,
                                                        height: 28,
                                                        imageUrl: listproduct
                                                            .imgOutOfStock)
                                                ],
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      listproduct
                                                          .productGroups[index]
                                                          .billName,
                                                      textAlign: TextAlign.left,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: listproduct
                                                                .productGroups[
                                                                    index]
                                                                .isInStock
                                                            ? Colors.black
                                                            : theme_grey_text,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: listproduct.productGroups.length,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text('กรุณาระบุจำนวน',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      splashRadius: 10,
                                      onPressed: (() {
                                        if (_controller.text.isNotEmpty) {
                                          var remove =
                                              int.parse(_controller.text) - 1;
                                          if (remove >= 1) {
                                            Get.find<ProductDetailController>()
                                                .removeItemsCart();
                                            _controller.value =
                                                _controller.value.copyWith(
                                                    text: remove.toString());
                                          }
                                        }
                                      }),
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color:
                                            Get.find<ProductDetailController>()
                                                        .countItems
                                                        .value ==
                                                    1
                                                ? const Color.fromARGB(
                                                    255, 92, 92, 92)
                                                : theme_color_df,
                                      )),
                                  SizedBox(
                                    width: 80.0,
                                    height: 60.0,
                                    child: Center(
                                      child: TextField(
                                        enableInteractiveSelection: false,
                                        textInputAction: TextInputAction.done,
                                        autofocus: false,
                                        showCursor: false,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        textAlign: TextAlign.center,
                                        controller: _controller,
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
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(7),
                                          isCollapsed: true,
                                          border: OutlineInputBorder(),
                                        ),
                                        onTap: () {
                                          _controller.selection = TextSelection(
                                              baseOffset: 0,
                                              extentOffset:
                                                  _controller.text.length);
                                        },
                                        onChanged: (text) {
                                          if (text.isNotEmpty) {
                                            _controller.value = _controller
                                                .value
                                                .copyWith(text: text);
                                            Get.find<ProductDetailController>()
                                                .countItems
                                                .value = int.parse(text);
                                          } else {
                                            _controller.text = '1';
                                            _controller.selection =
                                                TextSelection(
                                                    baseOffset: 0,
                                                    extentOffset: _controller
                                                        .text.length);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      splashRadius: 10,
                                      onPressed: (() {
                                        if (_controller.text.isNotEmpty) {
                                          var add =
                                              int.parse(_controller.text) + 1;
                                          if (add <= 999) {
                                            Get.find<ProductDetailController>()
                                                .addItemsCart();
                                            _controller.value = _controller
                                                .value
                                                .copyWith(text: add.toString());
                                            Get.find<ProductDetailController>()
                                                .countItems
                                                .value = add;
                                          }
                                        }
                                      }),
                                      icon: Icon(Icons.add_circle,
                                          color: theme_color_df)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 24.0, left: 12.0, right: 12.0),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: theme_color_df,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        side: BorderSide(
                                            width: 1.0, color: theme_color_df),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        _controller.text = '1';
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                          MultiLanguages.of(context)!
                                              .translate('alert_close'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: theme_color_df)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        backgroundColor: listproduct
                                                .productGroups[
                                                    ctr.indexProductGroup.value]
                                                .isInStock
                                            ? theme_color_df
                                            : Colors.grey.shade300,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (!listproduct
                                            .productGroups[
                                                ctr.indexProductGroup.value]
                                            .isInStock) {
                                          return;
                                        }
                                        Get.back();
                                        await fnEditCart(
                                            contextAlert,
                                            ctr,
                                            'ModalWebview',
                                            mChannel,
                                            mChannelId,
                                            ref: ref,
                                            contentId: contentId);
                                      },
                                      child: Text(
                                        listproduct
                                                .productGroups[
                                                    ctr.indexProductGroup.value]
                                                .isInStock
                                            ? MultiLanguages.of(context)!
                                                .translate('btn_add_to_cart')
                                            : "สินค้าหมด",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: listproduct
                                                    .productGroups[ctr
                                                        .indexProductGroup
                                                        .value]
                                                    .isInStock
                                                ? Colors.white
                                                : theme_grey_text),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      });
}
