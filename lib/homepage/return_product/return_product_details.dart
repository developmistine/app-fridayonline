import 'dart:io';

// import 'package:fridayonline/homepage/dialogalert/customalertdialogs.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/return_product/return_summary.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
// import 'package:fridayonline/model/return_product/return_detail.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../controller/return_product_controller.dart';
import '../../service/address/addresssearch.dart';
// import '../../service/return_product/return_product_sv.dart';
// import '../theme/success_bottom.dart';
import '../theme/theme_loading.dart';
// import 'add_to_cart.dart';

class ReturnProductDetails extends StatefulWidget {
  const ReturnProductDetails({super.key, required this.invoice});
  final String invoice;

  @override
  State<ReturnProductDetails> createState() => _ReturnProductDetailsState();
}

class _ReturnProductDetailsState extends State<ReturnProductDetails> {
  final productReturn = Get.put(ReturnProductController());

  final ImagePicker _pickerImage = ImagePicker();

  // final _reasonController = TextEditingController();
  final PageController _pageController = PageController();

  // final int _checkedReason = 0;
  final FocusNode _reasonFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        productReturn.onClose();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBarTitleMaster('แจ้งคืนสินค้า'),
        body: GetX<ReturnProductController>(builder: (products) {
          return products.isDataLoading.value
              ? Center(
                  child: theme_loading_df,
                )
              : products.productByinvoice!.productDetail!.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo/logofriday.png',
                            width: 70),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text('ไม่พบข้อมูล'),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'เลือกสินค้าที่ต้องการคืน',
                                          style: TextStyle(
                                            color: theme_color_df,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            const Expanded(
                                              flex: 1,
                                              child: Text(
                                                'เลขที่ใบกำกับภาษี',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                widget.invoice,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Expanded(
                                              flex: 1,
                                              child: Text(
                                                'รอบการขาย',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                products
                                                    .productByinvoice!.campDate,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'สถานะการชำระเงิน',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'ยังไม่ชำระเงิน',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      height: 12, color: theme_space_color)
                                  // Divider(
                                  //   height: 1,
                                  //   thickness: 3,
                                  //   color: theme_red,
                                  // ),
                                ],
                              ),
                              ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                primary: false,
                                itemCount: products
                                    .productByinvoice!.productDetail!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    // splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        if (products.checked![index].value) {
                                          products.checked![index].value =
                                              !products.checked![index].value;
                                          products.removeCounter(index);
                                        } else {
                                          reasonBottomSheet(context, index);
                                        }
                                      });
                                    },
                                    child: Obx(() {
                                      return Container(
                                        padding: EdgeInsets.zero,
                                        color: products.checked![index].value
                                            ? const Color.fromRGBO(
                                                255, 246, 244, 1)
                                            : Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: products
                                                        .checked![index].value
                                                    ? Icon(
                                                        Icons.check_box,
                                                        color: theme_red,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .check_box_outline_blank,
                                                        color: theme_color_df,
                                                      ),
                                              ),
                                              if (products
                                                      .productByinvoice!
                                                      .productDetail![index]
                                                      .image !=
                                                  '')
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 12,
                                                        horizontal: 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      border: Border.all(
                                                          color: theme_grey_bg,
                                                          width: 1),
                                                    ),
                                                    child: Image.network(
                                                      products
                                                          .productByinvoice!
                                                          .productDetail![index]
                                                          .image,
                                                      // width: 45,
                                                      height: 50,
                                                    ),
                                                  ),
                                                )
                                              else
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      border: Border.all(
                                                          color: theme_grey_bg,
                                                          width: 1),
                                                    ),
                                                    child: Image.asset(
                                                      imageError,
                                                      // width: 45,
                                                      height: 50,
                                                    ),
                                                  ),
                                                ),
                                              Expanded(
                                                flex: 8,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          right: 20.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'รหัส ${products.productByinvoice!.productDetail![index].billcode}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        products
                                                            .productByinvoice!
                                                            .productDetail![
                                                                index]
                                                            .billdesc,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'ราคา ${myFormat.format(products.productByinvoice!.productDetail![index].price)} บาท',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          // products
                                                          //         .checked![
                                                          //             index]
                                                          //         .value
                                                          // ? Row(
                                                          //     children: [
                                                          //       SizedBox(
                                                          //         width: 60,
                                                          //         height:
                                                          //             30,
                                                          //         child:
                                                          //             TextFormField(
                                                          //           enableInteractiveSelection:
                                                          //               true,
                                                          //           textInputAction:
                                                          //               TextInputAction.done,
                                                          //           autofocus:
                                                          //               true,
                                                          //           showCursor:
                                                          //               false,
                                                          //           focusNode:
                                                          //               products.focusNodes[index],
                                                          //           controller:
                                                          //               products.controllers[index],
                                                          //           textAlignVertical:
                                                          //               TextAlignVertical.center,
                                                          //           textAlign:
                                                          //               TextAlign.center,
                                                          //           keyboardType:
                                                          //               TextInputType.number,
                                                          //           inputFormatters: <TextInputFormatter>[
                                                          //             FilteringTextInputFormatter.allow(
                                                          //                 RegExp(r'[0-9]')),
                                                          //             FilteringTextInputFormatter
                                                          //                 .deny(
                                                          //               RegExp(r'^0+'),
                                                          //             ),
                                                          //             LengthLimitingTextInputFormatter(
                                                          //                 3),
                                                          //           ],
                                                          //           decoration:
                                                          //               InputDecoration(
                                                          //             filled:
                                                          //                 true,
                                                          //             fillColor:
                                                          //                 Colors.white,
                                                          //             isCollapsed:
                                                          //                 true,
                                                          //             focusedBorder:
                                                          //                 OutlineInputBorder(
                                                          //               borderSide:
                                                          //                   BorderSide(width: 1.3, color: theme_color_df),
                                                          //             ),
                                                          //             enabledBorder:
                                                          //                 OutlineInputBorder(borderSide: BorderSide(color: theme_red)),
                                                          //           ),
                                                          //           onTap:
                                                          //               () {
                                                          //             products.controllers[index].selection = TextSelection(
                                                          //                 baseOffset: 0,
                                                          //                 extentOffset: products.controllers[index].text.length);
                                                          //           },
                                                          //           onChanged:
                                                          //               ((value) {
                                                          //             // setState(
                                                          //             //     () {
                                                          //             if (value ==
                                                          //                 '') {
                                                          //               products.controllers[index].text =
                                                          //                   '';
                                                          //             } else {
                                                          //               if (int.parse(value) >=
                                                          //                   products.productByinvoice!.productDetail![index].qty) {
                                                          //                 products.controllers[index].text = products.productByinvoice!.productDetail![index].qty.toString();
                                                          //                 products.typeCounter();
                                                          //               } else {
                                                          //                 products.typeCounter();
                                                          //               }
                                                          //             }
                                                          //             // });
                                                          //           }),
                                                          //         ),
                                                          //       ),
                                                          //       Text(
                                                          //           ' / ${products.productByinvoice!.productDetail![index].qty}'),
                                                          //     ],
                                                          //   )
                                                          // :
                                                          Text(
                                                              'จำนวน : ${products.productByinvoice!.productDetail![index].qty}')
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: theme_grey_bg,
                                  );
                                },
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: theme_grey_bg,
                              ),
                              Container(height: 12, color: theme_space_color),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'สรุป',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('ยอดรวมสินค้าเดิม'),
                                          Text('xxx บาท')
                                        ]),
                                    Text(
                                        'รอบการขาย ${products.productByinvoice!.campDate} (${products.productByinvoice!.productDetail!.length} รายการ)'),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                            text: const TextSpan(
                                                text: 'ยอดรวมสินค้าแจ้งคืน',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'notoreg'),
                                                children: [
                                              TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                      fontFamily: 'notoreg'))
                                            ])),
                                        const Text('x บาท')
                                      ],
                                    ),
                                    const Text(
                                      '*ข้อมูลอาจมีการเปลี่ยนแปลง',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
        }),
        bottomNavigationBar:
            GetX<ReturnProductController>(builder: (setbottom) {
          return setbottom.isDataLoading.value
              ? const SizedBox()
              : setbottom.productByinvoice!.productDetail!.isEmpty
                  ? const SizedBox()
                  : Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: theme_color_df,
                            width: 3,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'รวมทั้งสิ้น',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                    '( ${setbottom.items.value} รายการ ${setbottom.price.value} ชิ้น)')
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Expanded(
                          //         child: RichText(
                          //           text: TextSpan(
                          //             text: 'เหตุผล ',
                          //             style: const TextStyle(
                          //                 color: Colors.black,
                          //                 fontWeight: FontWeight.bold,
                          //                 fontFamily: 'notoreg'),
                          //             children: <TextSpan>[
                          //               TextSpan(
                          //                   text: '*',
                          //                   style: TextStyle(
                          //                       fontFamily: 'notoreg',
                          //                       fontWeight: FontWeight.bold,
                          //                       color: theme_red)),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: InkWell(
                          //           onTap: () {
                          //             // open bottom sheet
                          //             // reasonBottomSheet(context);
                          //           },
                          //           child: Obx(() {
                          //             return Row(
                          //               children: [
                          //                 Expanded(
                          //                   child: Text(
                          //                     productReturn.reasonText.value,
                          //                     maxLines: 1,
                          //                     textAlign: TextAlign.end,
                          //                     overflow: TextOverflow.ellipsis,
                          //                   ),
                          //                 ),
                          //                 Icon(
                          //                   Icons.arrow_forward_ios,
                          //                   size: 16,
                          //                   color: theme_grey_text,
                          //                 )
                          //               ],
                          //             );
                          //           }),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),

                          InkWell(
                            onTap: () async {
                              Get.to(() => ReturnSummary());
                              // return;
                              // var textDes = '';
                              // if (setbottom.checked!.any(
                              //         (element) => element.value == true) &&
                              //     setbottom.reasonText.any(
                              //         (element) => element != 'กรุณาเลือก')) {
                              //   List<ProductDetail> listProduct = [];
                              //   for (var i = 0;
                              //       i <
                              //           setbottom.productByinvoice!
                              //               .productDetail!.length;
                              //       i++) {
                              //     // check checked product
                              //     if (setbottom.checked![i].value == true) {
                              //       listProduct.add(ProductDetail(
                              //           billcode: setbottom.productByinvoice!
                              //               .productDetail![i].billcode,
                              //           billdesc: setbottom.productByinvoice!
                              //               .productDetail![i].billdesc,
                              //           price: setbottom.productByinvoice!
                              //               .productDetail![i].price,
                              //           qty: int.parse(
                              //               setbottom.controllers[i].text)));
                              //     }
                              //   }
                              //   var campDateFormat = setbottom
                              //       .productByinvoice!.campDate
                              //       .split(' ')[1];
                              //   // remove / from date
                              //   campDateFormat =
                              //       campDateFormat.replaceAll('/', '');
                              //   ReturnProductJson jsonReturn =
                              //       ReturnProductJson(
                              //           productDetail: listProduct,
                              //           campDate: campDateFormat,
                              //           device: '',
                              //           invoice: widget.invoice,
                              //           reasonAll: ReasonAll(
                              //               code: setbottom.reasonCode.value,
                              //               reason: setbottom
                              //                   .reasonController.text),
                              //           receivedDate: setbottom
                              //               .productByinvoice!.receivedDate,
                              //           repcode: '',
                              //           repseq: '');

                              //   await returnProductService(jsonReturn)
                              //       .then((value) {
                              //     if (value!.message1 == 'success') {
                              //       successBottom(context, 'ยืนยัน');
                              //     } else {
                              //       Get.to(() => const AddToCartSlide());
                              //     }
                              //   });
                              // } else {
                              //   if (setbottom.reasonText.any(
                              //       (element) => element == 'กรุณาเลือก')) {
                              //     textDes = 'กรุณาระบุเหตุผลค่ะ';
                              //   }
                              //   if (setbottom.checked!.every(
                              //       (element) => element.value == false)) {
                              //     textDes =
                              //         'กรุณาเลือกสินค้าที่ต้องการแจ้งคืนค่ะ';
                              //   }
                              //   showDialog(
                              //       barrierColor: Colors.black26,
                              //       context: context,
                              //       builder: (context) {
                              //         return MediaQuery(
                              //           data: MediaQuery.of(context).copyWith(
                              //             textScaleFactor: 1.0,
                              //           ),
                              //           child: CustomAlertDialogs(
                              //             title: 'แจ้งเตือน',
                              //             description: textDes,
                              //           ),
                              //         );
                              //       });
                              // }
                            },
                            child: Container(
                              height: 60,
                              color: setbottom.checked!.any(
                                          (element) => element.value == true) &&
                                      (setbottom.reasonText.any(
                                          (element) => element != 'กรุณาเลือก'))
                                  ? theme_red
                                  : theme_grey_text,
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                  child: setbottom.checked!.any((element) =>
                                              element.value == true) ||
                                          (setbottom.reasonText.any((element) =>
                                              element != 'กรุณาเลือก'))
                                      ? const Text(
                                          'ยืนยันการแจ้งคืนสินค้า',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const Text(
                                          'เลือกสินค้าที่ต้องการ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                            ),
                          )
                        ],
                      ),
                    );
        }),
      ),
    );
  }

  reasonBottomSheet(BuildContext context, int indexProduct) {
    return showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        // isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0))),
        builder: (BuildContext context) {
          return GestureDetector(onTap: () {
            FocusScope.of(context).unfocus();
          }, child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return ExpandablePageView.builder(
              controller: _pageController,
              // allowImplicitScrolling: true,
              // animationCurve: Curves.decelerate,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                // return Text('333');
                if (index == 0) {
                  return selectAmount(indexProduct);
                } else if (index == 1) {
                  return reason_1(setState, indexProduct);
                } else {
                  return reason_2(setState, indexProduct);
                }
              },
            );
          }));
        });
  }

  selectAmount(int indexProduct) {
    return SizedBox(
      height: Get.height / 3.5 + Get.mediaQuery.viewInsets.bottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 30,
                    color: theme_red,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'ระบุ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'ระบุจำนวนที่ต้องการคืน',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 30,
                          child: TextFormField(
                            enableInteractiveSelection: true,
                            textInputAction: TextInputAction.done,
                            // autofocus: true,
                            showCursor: false,
                            // focusNode: products.focusNodes[index],
                            controller: productReturn.controllers[indexProduct],
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              FilteringTextInputFormatter.deny(
                                RegExp(r'^0+'),
                              ),
                              LengthLimitingTextInputFormatter(3),
                            ],
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              isCollapsed: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1.3, color: theme_red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: theme_red)),
                            ),
                            onTap: () {
                              productReturn
                                      .controllers[indexProduct].selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: productReturn
                                          .controllers[indexProduct]
                                          .text
                                          .length);
                            },
                            onChanged: ((value) {
                              // setState(
                              //     () {
                              if (value == '') {
                                productReturn.controllers[indexProduct].text =
                                    '';
                              } else {
                                if (int.parse(value) >=
                                    productReturn.productByinvoice!
                                        .productDetail![indexProduct].qty) {
                                  productReturn.controllers[indexProduct].text =
                                      productReturn.productByinvoice!
                                          .productDetail![indexProduct].qty
                                          .toString();
                                  // productReturn.typeCounter();
                                } else {
                                  // productReturn.typeCounter();
                                }
                              }
                              // });
                            }),
                          ),
                        ),
                        Text(
                          ' / ${productReturn.productByinvoice!.productDetail![indexProduct].qty}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (productReturn.controllers[indexProduct].text == '')
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                '* กรุณาระบุจำนวน',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.red),
              ),
            ),
          const Spacer(),
          InkWell(
              onTap: () {
                if (productReturn.controllers[indexProduct].text != '') {
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
              child: productReturn.controllers[indexProduct].text != ''
                  ? Container(
                      color: theme_red,
                      height: 60,
                      width: Get.width,
                      child: const Center(
                          child: Text(
                        'ถัดไป',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      )),
                    )
                  : Container(
                      color: theme_grey_text,
                      height: 60,
                      width: Get.width,
                      child: const Center(
                          child: Text(
                        'ถัดไป',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      )),
                    ))
        ],
      ),
    );
  }

  reason_2(StateSetter setState, indexProduct) {
    uploadImg() async {
      await _pickerImage.pickImage(source: ImageSource.gallery).then((value) {
        if (value != null) {
          setState(() {
            productReturn.setImgage(value, indexProduct);
          });
        }
      });
    }

    return SizedBox(
      height: Get.height / 1.6 + Get.mediaQuery.viewInsets.bottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 30,
                    color: theme_red,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'แนบรูปภาพและรายละเอียด',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: InkWell(
              onTap: () {
                // previous pageview
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'เหตุผล',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          productReturn.reasonText[indexProduct],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: theme_grey_text,
                      )
                    ],
                  )
                      // }),
                      )
                ],
              ),
            ),
          ),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
          //   child: Row(
          //     children: [
          //       Text(
          //         'รายละเอียดเพิ่มเติม',
          //         style: TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       Text('(ไม่บังคับ)',
          //           style: TextStyle(
          //               color: Colors.red, fontWeight: FontWeight.bold)),
          //     ],
          //   ),
          // ),
          // Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 30),
          //     child: TextFormField(
          //       keyboardType: TextInputType.text,
          //       autofocus: false,
          //       controller: productReturn.reasonController,
          //       decoration: InputDecoration(
          //         focusedBorder: OutlineInputBorder(
          //             borderSide: BorderSide(color: theme_red)),
          //         hintMaxLines: 10,
          //         hintStyle: const TextStyle(fontSize: 14),
          //         hintText: 'เหตุผลเพิ่มเติม',
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(8.0),
          //         ),
          //       ),
          //       maxLines: 7,
          //       onChanged: (value) {},
          //     )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    uploadImg();
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [8, 8],
                    strokeWidth: 2,
                    color: theme_color_df,
                    child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Icon(Icons.camera_alt_rounded,
                                size: 40,
                                color: Color.fromRGBO(123, 123, 123, 1)),
                            Text('อัปโหลดรูปและรายละเอียด')
                          ],
                        )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                productReturn.imageFile![indexProduct].path != ''
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            border: Border.all(
                                                color: const Color.fromRGBO(
                                                    171, 171, 171, 1))),
                                        // height: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 20),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: Image.file(
                                                File(productReturn
                                                    .imageFile![indexProduct]
                                                    .path),
                                                fit: BoxFit.fitHeight,
                                              )),
                                        )),
                                    Transform.rotate(
                                      angle: 210 / 90,
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            // printWhite(indexProduct);
                                            productReturn
                                                    .imageFile![indexProduct] =
                                                XFile('');
                                            // productReturn.imageFile!
                                            //     .removeAt(indexProduct);
                                            // productReturn.imageFile![indexProduct] =
                                            //     XFile('');
                                          });
                                        },
                                        child: const Icon(
                                            size: 20,
                                            Icons.add_circle_outlined),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: SizedBox(
                                height: 78,
                                child: TextField(
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'โปรดระบุ',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: theme_grey_text)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: theme_grey_text)),
                                  ),
                                ),
                              ))
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {}, child: const Text('บันทึก'))
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              productReturn.checked![indexProduct].value =
                  !productReturn.checked![indexProduct].value;
              // set focus textfield and keyboard active
              if (productReturn.checked![indexProduct].value) {
                // productReturn.focusNodes[indexProduct].requestFocus();
                // FocusScope.of(context)
                // .requestFocus(productReturn.focusNodes[indexProduct]);
                productReturn.addCounter(indexProduct);
              } else {
                productReturn.removeCounter(indexProduct);
              }
              Get.back();
            },
            child: Container(
              color: theme_red,
              height: 60,
              width: Get.width,
              child: const Center(
                  child: Text(
                'ยืนยัน',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16),
              )),
            ),
          ),
          SizedBox(
            height: Get.mediaQuery.viewInsets.bottom,
          )
        ],
      ),
    );
  }

  reason_1(StateSetter setState, indexProduct) {
    return GetX<ReturnProductController>(builder: (products) {
      return products.isDataLoading.value
          ? const SizedBox()
          : SizedBox(
              height: Get.height / 1.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease);
                          },
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 30,
                            color: theme_red,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'เหตุผล',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      // primary: false,
                      itemCount: products.productByinvoice!.reasonAll.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              products.checkedReason![indexProduct] = index;
                              products.reasonText[indexProduct] = products
                                  .productByinvoice!.reasonAll[index].reason;
                              products.reasonCode.value = products
                                  .productByinvoice!.reasonAll[index].code;
                              _reasonFocusNode.requestFocus();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    products.productByinvoice!.reasonAll[index]
                                        .reason,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                products.checkedReason!.isNotEmpty &&
                                        products.checkedReason![indexProduct] ==
                                            index
                                    ? Icon(
                                        Icons.radio_button_checked,
                                        color: theme_red,
                                      )
                                    : const Icon(
                                        Icons.radio_button_unchecked_outlined,
                                        color: Colors.grey,
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (products.checkedReason!.isNotEmpty) {
                          _pageController.animateToPage(2,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        }
                      });
                    },
                    child: Container(
                      height: 60,
                      color: products.checkedReason!.isNotEmpty
                          ? theme_red
                          : theme_grey_text,
                      padding: const EdgeInsets.all(12),
                      child: const Center(
                          child: Text(
                        'ถัดไป',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            );
    });
  }
}
