// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:fridayonline/controller/cart/dropship_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/cart/cart_controller.dart';
import '../../../../controller/cart/delivery_controller.dart';
import '../../../../controller/cart/point_controller.dart';
import '../../../../service/languages/multi_languages.dart';
import '../cart_widget/cart_bottom_confirm.dart';
import '../cart_theme/cart_all_theme.dart';

Detail_bill(
    BuildContext context,
    FetchCartDropshipController dropship,
    FetchCartItemsController controller,
    List<TextEditingController> inputors,
    List<TextEditingController> inputorsDropship,
    String nameBtn,
    String? typeUser) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: Colors.black87,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))),
      context: context,
      builder: (builder) {
        var totalDropship =
            dropship.itemDropship!.cartHeader.cartDetail.map((e) {
          if (e.isChecked) {
            return e.amount;
          } else {
            return 0;
          }
        });
        //? result ราคา dropship ที่เลือก
        final result = totalDropship.fold<double>(
            0, (previousValue, element) => previousValue + element);
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Text(
                          textAlign: TextAlign.center,
                          MultiLanguages.of(context)!
                              .translate('detail_header_bill'),
                          style: TextStyle(fontWeight: boldText, fontSize: 24)),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Transform.rotate(
                            angle: 210 / 90,
                            child: Icon(
                                size: 40,
                                color: theme_red,
                                Icons.add_circle_outlined),
                          )),
                    ),
                  ],
                ),
              ),
              Divider(),
              //? direcsale
              if (controller.itemsCartList!.cardHeader.carddetail.isNotEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: edgeInsets,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                              width: 87, "assets/images/home/friday_logo.png"),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'สินค้ารอบการขาย ${controller.itemsCartList!.cardHeader.campaign}',
                            style:
                                TextStyle(fontSize: 14, fontWeight: boldText),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: edgeInsets,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(MultiLanguages.of(context)!
                              .translate('all_products_included')),
                          Text(
                              "x${controller.itemsCartList!.cardHeader.totalitem} ${MultiLanguages.of(context)!.translate('order_list')}"),
                        ],
                      ),
                    ),
                    if (typeUser == '2' || typeUser == '1')
                      nameBtn == 'pay'
                          ? Padding(
                              padding: edgeInsets,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    MultiLanguages.of(context)!
                                        .translate('shipping_cost'),
                                  ),
                                  if (typeUser != '3')
                                    GetBuilder<FetchDeliveryChange>(
                                        builder: (delivery) {
                                      return Text(
                                          '${myFormat.format(double.parse(delivery.isChange!.detailDelivery![delivery.indexChange.value].price))} ${MultiLanguages.of(context)!.translate('order_baht')}');
                                    })
                                ],
                              ),
                            )
                          : SizedBox(),
                    if (typeUser == '2' || typeUser == '1')
                      nameBtn == 'pay'
                          ? Padding(
                              padding: edgeInsets,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (typeUser == '2')
                                    Text(
                                        MultiLanguages.of(context)!
                                            .translate('order_discount'),
                                        style: TextStyle(fontSize: 14)),
                                  if (typeUser == '1') const Text('ส่วนลด'),
                                  GetX<FetchPointMember>(
                                    builder: (discount) {
                                      return Text(
                                        ' - ${discount.discount.value} ${MultiLanguages.of(context)!.translate('order_baht')}',
                                        style: TextStyle(color: theme_red),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                    if (typeUser == '2')
                      nameBtn == 'pay'
                          ? Padding(
                              padding: edgeInsets,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    MultiLanguages.of(context)!
                                        .translate('order_coupon_discount'),
                                  ),
                                  GetX<FetchPointMember>(
                                    builder: (discount) {
                                      return Text(
                                        ' - ${discount.disCouponPrice.value} ${MultiLanguages.of(context)!.translate('order_baht')}',
                                        style: TextStyle(color: theme_red),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                    Padding(
                      padding: edgeInsets,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(MultiLanguages.of(context)!
                              .translate('customer_total')),
                          nameBtn == 'pay'
                              ? GetBuilder<FetchDeliveryChange>(
                                  builder: (delivery) {
                                  return GetBuilder<FetchPointMember>(
                                      builder: (discount) {
                                    if (typeUser == '2' || typeUser == '1') {
                                      return Text(
                                          '${myFormat.format((double.parse(delivery.isChange!.detailDelivery![delivery.indexChange.value].price) + controller.itemsCartList!.cardHeader.totalAmount) - discount.discount.value - discount.disCouponPrice.value)} ${MultiLanguages.of(context)!.translate('order_baht')}');
                                    }
                                    // if (typeUser == '1') {
                                    //   return Text(
                                    //       '${myFormat.format(controller.itemsCartList!.cardHeader.totalAmount - discount.discount.value)} ${MultiLanguages.of(context)!.translate('order_baht')}');
                                    // }
                                    return Text(
                                        "${myFormat.format(controller.itemsCartList!.cardHeader.totalAmount)} ${MultiLanguages.of(context)!.translate('order_baht')}");
                                  });
                                })
                              : Text(
                                  "${myFormat.format(controller.itemsCartList!.cardHeader.totalAmount)} ${MultiLanguages.of(context)!.translate('order_baht')}"),
                        ],
                      ),
                    ),
                    // !v16
                    // if (typeUser == '2')
                    //   Padding(
                    //     padding: edgeInsets,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           MultiLanguages.of(context)!
                    //               .translate('delivery_members'),
                    //           style: TextStyle(fontWeight: boldText),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                  ],
                ),
              //? dropship
              if (dropship.itemDropship!.cartHeader.cartDetail
                  .where((element) => element.isChecked)
                  .isNotEmpty)
                Column(
                  children: [
                    //! dropship falde

                    SizedBox(height: 15),
                    if (controller
                        .itemsCartList!.cardHeader.carddetail.isNotEmpty)
                      Image.asset(
                        'assets/images/cart/divider2.png',
                        // scale: 1.2,
                        width: MediaQuery.of(context).size.width / 1.4,
                      ),
                    SizedBox(height: 15),

                    // SizedBox(height: 15),
                    Padding(
                      padding: edgeInsets,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(14, 0, 0, 0),
                                    offset: Offset(0.0, 4.0),
                                    blurRadius: 0.2,
                                    spreadRadius: 0.2,
                                  ), //BoxShadow
                                ],
                                color: theme_red,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              width: 100.0,
                              height: 35.0,
                              child: Text(
                                textAlign: TextAlign.center,
                                'ส่งด่วน 3 วัน',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'เก็บเงินปลายทาง',
                            style:
                                TextStyle(fontSize: 14, fontWeight: boldText),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: edgeInsets,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('รวมสินค้าทั้งหมด'),
                          Text(
                              'x${dropship.itemDropship!.cartHeader.cartDetail.where((element) => element.isChecked).length}  ${MultiLanguages.of(context)!.translate('order_list')}'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: edgeInsets,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(MultiLanguages.of(context)!
                              .translate('customer_total')),
                          Text(
                              "${myFormat.format(result)} ${MultiLanguages.of(context)!.translate('order_baht')}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: edgeInsets,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('แยกจัดส่งโดย BL Express',
                              style: TextStyle(fontWeight: boldText)),
                        ],
                      ),
                    ),
                  ],
                ),

              Align(
                  alignment: Alignment.bottomCenter,
                  child: bottomConfirm(context, false, nameBtn,
                      inputorsDropship, inputors, typeUser)),
            ],
          ),
        );
      });
}
