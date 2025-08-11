import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/check_information/check_information_controller.dart';
import '../../../controller/dropship_shop/dropship_shop_controller.dart';
import '../../dropship_shop/dropship_supplier_shop.dart';
import '../../pageactivity/cart/cart_theme/cart_all_theme.dart';

class OrderHistoryExpressSalesDetail extends StatelessWidget {
  const OrderHistoryExpressSalesDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: const Color(0XFFE5E5E5),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: true,
          backgroundColor: theme_color_df,
          title: const Text(
            'ประวัติการสั่งซื้อ',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'notoreg',
                fontWeight: FontWeight.bold),
          ),
        ),
        body: GetX<CheckInformationOrderHistoryController>(
            builder: (detailHistory) {
          if (!detailHistory.isDropshipLoading.value) {
            if (detailHistory.responseDropship!.orderDetailList.isNotEmpty) {
              return ListView(
                children: [
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: IntrinsicHeight(
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text('ส่งด่วน 3 วัน',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFFFD7F6B),
                                    fontSize: 15)),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: VerticalDivider(
                                color: Color(0XFFFD7F6B),
                                thickness: 1,
                              ),
                            ),
                            Text('เก็บเงินปลายทาง',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFFFD7F6B),
                                    fontSize: 15))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Container(color: theme_color_df),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              detailHistory.responseDropship!.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: 'notobold'),
                            ),
                            Text(
                              detailHistory.responseDropship!.orderStatus,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFF20BE79),
                                  fontSize: 18,
                                  fontFamily: 'notobold'),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'วันที่ใบส่งของ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'notobold'),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                detailHistory.responseDropship!.orderDate,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'เลขที่ใบส่งของ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'notobold'),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                detailHistory.responseDropship!.orderId,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                        const Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'ช่องทางการชำระเงิน',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'notobold'),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'เก็บเงินปลายทาง',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: const Color(0XFF203959),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 8, bottom: 5),
                      child: InkWell(
                        onTap: () {
                          Get.put(FetchDropshipShop())
                              .fetchProductSupplierDropship(
                                  detailHistory.responseDropship!.subCode);
                          Get.to(() => const ShopDropShip());
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/check_order/logo_shop.png',
                              width: 70,
                              height: 70,
                            ),
                            Text(
                              detailHistory.responseDropship!.subName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'notobold'),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        for (var items
                            in detailHistory.responseDropship!.orderDetailList)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8, left: 8, right: 12),
                                child: Row(
                                  children: [
                                    items.productImg == ''
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Image.asset(
                                              imageError,
                                              width: 120,
                                              height: 120,
                                            ),
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: items.productImg,
                                            width: 120,
                                            height: 120,
                                          ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.left,
                                            items.prouctName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'รหัสสินค้า ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                items.productCode,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    'ราคา ',
                                                    style: TextStyle(
                                                      color: Color(0XFF2EA9E1),
                                                      fontSize: 16,
                                                      fontFamily: 'notoreg',
                                                    ),
                                                  ),
                                                  Text(
                                                    myFormat.format(
                                                        double.parse(
                                                            items.price)),
                                                    style: const TextStyle(
                                                      color: Color(0XFF2EA9E1),
                                                      fontSize: 16,
                                                      fontFamily: 'notoreg',
                                                    ),
                                                  ),
                                                  const Text(
                                                    ' บาท',
                                                    style: TextStyle(
                                                      color: Color(0XFF2EA9E1),
                                                      fontSize: 16,
                                                      fontFamily: 'notoreg',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'จำนวน : ',
                                                    style: TextStyle(
                                                      color: Color(0XFF2EA9E1),
                                                      fontSize: 16,
                                                      fontFamily: 'notoreg',
                                                    ),
                                                  ),
                                                  Text(
                                                    items.qty,
                                                    style: const TextStyle(
                                                      color: Color(0XFF2EA9E1),
                                                      fontSize: 16,
                                                      fontFamily: 'notoreg',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'รวมราคา',
                                                style: TextStyle(
                                                  color: Color(0XFF2EA9E1),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'notoreg',
                                                ),
                                              ),
                                              //! price
                                              Row(
                                                children: [
                                                  Text(
                                                    myFormat.format(
                                                        double.parse(
                                                            items.amount)),
                                                    style: const TextStyle(
                                                      color: Color(0XFF2EA9E1),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'notoreg',
                                                    ),
                                                  ),
                                                  const Text(
                                                    ' บาท',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0XFF2EA9E1),
                                                      fontSize: 16,
                                                      fontFamily: 'notoreg',
                                                    ),
                                                  ),
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
                              Divider(
                                thickness: 1,
                                color: theme_color_df,
                                height: 1,
                              )
                            ],
                          )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.left,
                            ' สรุป',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'notobold',
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ยอดรวมสินค้าส่งด่วน',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '(${detailHistory.responseDropship!.totalItem} รายการ)',
                                    style: const TextStyle(
                                      color: Color(0XFF7B7B7B),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${myFormat.format(double.parse(detailHistory.responseDropship!.amount))} บาท',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ค่าส่ง',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'ฟรีค่าจัดส่ง',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: const [
                          //     Text(
                          //       'ส่วนลด จาก BW Points',
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //       ),
                          //     ),
                          //     Text(
                          //       '-5  บาท',
                          //       style: TextStyle(
                          //         color: Color(0XFFFF0000),
                          //         fontSize: 16,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ยอดรวมทั้งหมด',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                myFormat.format(double.parse(detailHistory
                                    .responseDropship!.totalAmount)),
                                style: const TextStyle(
                                  fontFamily: 'notobold',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 4, bottom: 4),
                          //   child: Container(
                          //     color: const Color(0XFFD9D9D9),
                          //     height: 1.5,
                          //   ),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: const [
                          //     Text(
                          //       'ประกันรายได้',
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //       ),
                          //     ),
                          //     Text(
                          //       '5 บาท',
                          //       style: TextStyle(
                          //         fontFamily: 'notobold',
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 16,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: const [
                          //     Text(
                          //       'BW Points',
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //       ),
                          //     ),
                          //     Text(
                          //       '+2 คะแนน',
                          //       style: TextStyle(
                          //         fontFamily: 'notobold',
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 16,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const Text(
                          //   'หมายเหตุ : ประกันรายได้และคะแนนเป็นการคำนวณ\nเบื้องต้นโดยประมาณ',
                          //   style: TextStyle(
                          //     color: Color(0XFFFF0000),
                          //     fontSize: 16,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: Text('ไม่พบข้อมูล'),
              );
            }
          } else {
            return Center(
              child: theme_loading_df,
            );
          }
        }),
      ),
    );
  }
}
