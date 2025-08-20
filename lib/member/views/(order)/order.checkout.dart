import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/controller/order.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/services/orders/order.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(cart)/cart.payment.change.dart';
import 'package:fridayonline/member/views/(cart)/cart.select.address.dart';
import 'package:fridayonline/member/views/(cart)/cart.sumary.dart';
import 'package:fridayonline/member/views/(order)/order.detail.dart';
import 'package:fridayonline/member/views/(profile)/myorder.dart';
import 'package:fridayonline/member/widgets/dialog.confirm.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderCheckout extends StatefulWidget {
  const OrderCheckout({super.key});

  @override
  State<OrderCheckout> createState() => _OrderCheckoutState();
}

Color getStatusColor(String status) {
  switch (status) {
    case 'b':
      return themeColorDefault;
    case 'y':
      return Colors.amber;
    case 'g':
      return Colors.teal.shade400;
    case 'r':
      return const Color.fromARGB(255, 221, 60, 32);
    default:
      return themeColorDefault;
  }
}

class _OrderCheckoutState extends State<OrderCheckout> {
  final orderCtr = Get.find<OrderController>();
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.ibmPlexSansThai())),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  textStyle: GoogleFonts.ibmPlexSansThai())),
          textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: appBarMasterEndUser('รายละเอียดคำสั่งซื้อ'),
          body: Obx(() {
            if (orderCtr.isLoadingDetailCheckOut.value) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(
                  height: 4,
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(12),
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: getStatusColor(orderCtr
                                  .orderDetailChekcOut!
                                  .data
                                  .orderStatus
                                  .colorCode
                                  .toLowerCase()),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  orderCtr.orderDetailChekcOut!.data.orderStatus
                                      .description,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Icon(
                                  Icons.payment,
                                  color: Colors.white,
                                )
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'ที่อยู่ในการจัดส่ง',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      dialogConfirm(
                                              'สามารถแก้ไขที่อยู่ได้เพียงหนึ่งครั้งต่อหนึ่งคำสั่งซื้อ คุณแน่ใจหรือไม่ว่าจะแก้ไข',
                                              'ตกลง',
                                              'ปิด')
                                          .then((res) async {
                                        if (res == 0) {
                                          // goto addrss
                                          Get.find<EndUserCartCtr>()
                                              .fetchAddressList();

                                          var res = await Get.to(() =>
                                              const EndUserSelectAddress());

                                          if (res != null) {
                                            // call api
                                            await updateOrderAddressServices(
                                                    orderCtr.orderShopId, res)
                                                .then((value) {
                                              if (value["code"] == '100') {
                                                orderCtr
                                                    .fetchOrderDetailCheckOut(
                                                        orderCtr.orderShopId);
                                              } else {
                                                dialogConfirm(value["message1"],
                                                    'ตกลง', '');
                                              }
                                            });
                                          }
                                        }
                                      });
                                    },
                                    child: Text(
                                      'แก้ไข',
                                      style: TextStyle(
                                          fontSize: 13,
                                          decoration: TextDecoration.underline,
                                          color: themeColorDefault),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                orderCtr.orderDetailChekcOut!
                                                    .data.address.shippingName,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Flexible(
                                              child: Text(
                                                formatPhoneNumber(orderCtr
                                                    .orderDetailChekcOut!
                                                    .data
                                                    .address
                                                    .shippingPhone),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          orderCtr.orderDetailChekcOut!.data
                                              .address.shippingAddress,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ช่องทางการชำระเงิน',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              orderCtr.orderDetailChekcOut!.data.paymentMethod
                                  .paymentChannelName,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: orderCtr.orderDetailChekcOut!.data.shopList.length,
                  itemBuilder: (context, index) {
                    var data =
                        orderCtr.orderDetailChekcOut!.data.shopList[index];
                    return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.find<BrandCtr>()
                                      .fetchShopData(data.shopInfo.shopId);
                                  // Get.to(() => const BrandStore());
                                  Get.toNamed(
                                      '/BrandStore/${data.shopInfo.shopId}');
                                },
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: CachedNetworkImage(
                                        imageUrl: data.shopInfo.icon,
                                        width: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      data.shopInfo.shopName,
                                      style: GoogleFonts.ibmPlexSansThai(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ListView.builder(
                                padding: const EdgeInsets.only(top: 8),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: data.itemGroups.length,
                                itemBuilder: (context, itemIndex) {
                                  var item = data.itemGroups[itemIndex];
                                  return InkWell(
                                    onTap: () {
                                      Get.find<ShowProductSkuCtr>()
                                          .fetchB2cProductDetail(
                                              item.productId, 'order_detail');
                                      Get.toNamed(
                                        '/ShowProductSku/${item.productId}',
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                  width: 0.4,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                    imageUrl: item.image),
                                              ),
                                            )),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.productName,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 13),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                              'x${item.amount}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 13,
                                                              )),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                  '฿${myFormat.format(item.price)}',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                  )),
                                                              if (item
                                                                  .haveDiscount)
                                                                const SizedBox(
                                                                  width: 4,
                                                                ),
                                                              if (item
                                                                  .haveDiscount)
                                                                Text(
                                                                  '฿${myFormat.format(item.priceBeforeDiscount)}',
                                                                  style: TextStyle(
                                                                      height: 2,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400,
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const Divider(),
                              ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                padding: EdgeInsets.zero,
                                itemCount: data.paymentInfo.info.length,
                                itemBuilder: (context, paymentIndex) {
                                  var paymentInfo =
                                      data.paymentInfo.info[paymentIndex];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          paymentInfo.text,
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          "฿${myFormat.format(paymentInfo.value)}",
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const Divider(),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'รวมคำสั่งซื้อ: ฿${myFormat.format(data.paymentInfo.finalTotal)}',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        ));
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: Get.width,
                    height: 40,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: const RoundedRectangleBorder()),
                        onPressed: () async {
                          Get.find<EndUserCartCtr>().paymentType.clear();
                          var res = await Get.to(
                                  () => const EndUserChangePayment()) ??
                              "";
                          if (res == "") {
                            return;
                          }

                          final orderId =
                              orderCtr.orderDetailChekcOut!.data.orderId;
                          var resUpdate = await updatePaymentServices(
                            orderId,
                            res,
                          );
                          if (resUpdate["code"] == "100") {
                            if (res.toLowerCase() == "cod") {
                              dialogAlert([
                                const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 34,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                const Text(
                                  "สำเร็จ",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                )
                              ]);
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                Get.back();
                                Get.offAllNamed('/EndUserHome',
                                    parameters: {'changeView': "3"});
                                orderCtr.fetchOrderList(1, 0);
                                orderCtr.fetchNotifyOrderTracking(10627, 0);
                                Get.to(() => const MyOrderHistory(),
                                    arguments: 1);
                              });
                              return;
                            }
                            dialogAlert([
                              const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 34,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              const Text(
                                "สำเร็จ",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              )
                            ]);
                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              Get.back();
                              orderCtr.fetchOrderDetailCheckOut(
                                  orderCtr.orderShopId);
                            });
                          } else {
                            dialogAlert([
                              const Icon(
                                Icons.notification_important,
                                color: Colors.white,
                                size: 40,
                              ),
                              Text(
                                "เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้ง",
                                style: GoogleFonts.ibmPlexSansThai(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ]);
                            Future.delayed(const Duration(milliseconds: 1200),
                                () {
                              Get.back();
                            });
                          }
                        },
                        child: const Text(
                          'เปลี่ยนช่องทางการชำระเงิน',
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (orderCtr.orderDetailChekcOut!.data.canCancel)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: Get.width,
                      height: 40,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder()),
                          onPressed: () async {
                            loadingProductStock(context);
                            await fetchCancelReasonOrdersService(
                                    orderCtr.orderShopId)
                                .then((value) {
                              Get.back();
                              bottomReasonCancel(
                                  value,
                                  orderCtr.orderDetailChekcOut!.data.orderId,
                                  true);
                            });
                          },
                          child: const Text(
                            'ยกเลิกคำสั่งซื้อ',
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                  ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ));
          }),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(80, 0, 0, 0), // เงานุ่มขึ้น
                  offset: Offset(0, 1), // ด้านบน (Y ติดลบ)
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Obx(() {
              if (orderCtr.isLoadingDetailCheckOut.value) {
                return const SizedBox();
              }
              return SafeArea(
                  child: IntrinsicHeight(
                      child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white, boxShadow: []),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'ยอดเงินที่ต้องชำระ :',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "฿${myFormat.format(orderCtr.orderDetailChekcOut!.data.summary.finalTotal)}",
                                      style: TextStyle(
                                          color: themeColorDefault,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: Get.width,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: themeColorDefault),
                                      onPressed: () async {
                                        SetData data = SetData();
                                        var custId = await data.b2cCustID;
                                        final paymentType = orderCtr
                                            .orderDetailChekcOut!
                                            .data
                                            .paymentMethod
                                            .paymentChannelName
                                            .toLowerCase();
                                        final orderId = orderCtr
                                            .orderDetailChekcOut!.data.orderId;
                                        final url = getPaymentUrl(
                                            paymentType,
                                            custId,
                                            orderId,
                                            await data.accessToken);
                                        if (url != null) {
                                          await handlePaymentNavigation(url);
                                        }
                                      },
                                      child: const Text(
                                        'ชำระเงิน',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              )
                            ],
                          ))));
            }),
          ),
        ),
      ),
    );
  }
}
