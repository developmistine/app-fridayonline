import 'dart:convert';
import 'dart:ui';

import 'package:appfridayecommerce/enduser/components/appbar/appbar.master.dart';
import 'package:appfridayecommerce/enduser/components/cart/storer.coupon.dart';
import 'package:appfridayecommerce/enduser/components/webview/webview_full.dart';
import 'package:appfridayecommerce/enduser/controller/cart.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/coupon.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/order.ctr.dart';
import 'package:appfridayecommerce/enduser/models/cart/cart.checkout.dart';
import 'package:appfridayecommerce/enduser/models/cart/cart.update.input.dart';
import 'package:appfridayecommerce/enduser/services/address/adress.service.dart';
import 'package:appfridayecommerce/enduser/services/cart/cart.service.dart';
import 'package:appfridayecommerce/enduser/utils/format.dart';
import 'package:appfridayecommerce/enduser/views/(cart)/cart.coupon.dart';
// import 'package:appfridayecommerce/enduser/views/(cart)/cart.etax.dart';
import 'package:appfridayecommerce/enduser/views/(cart)/cart.main.dart';
import 'package:appfridayecommerce/enduser/views/(cart)/cart.payment.change.dart';
import 'package:appfridayecommerce/enduser/views/(cart)/cart.select.address.dart';
import 'package:appfridayecommerce/enduser/views/(cart)/cart.set.address.dart';
import 'package:appfridayecommerce/enduser/views/(profile)/myorder.dart';
import 'package:appfridayecommerce/enduser/widgets/dialog.confirm.dart';
import 'package:appfridayecommerce/enduser/widgets/dialog.dart';
import 'package:appfridayecommerce/theme.dart';
import 'package:appfridayecommerce/preferrence.dart';
import 'package:appfridayecommerce/service/pathapi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appfridayecommerce/enduser/models/cart/cart.checkout.input.dart'
    as checkout_model;

// fetchAddressList
final checkoutCtr = Get.find<EndUserCartCtr>();
final cartCouponCtr = Get.find<EndUserCouponCartCtr>();

String? getPaymentUrl(
    String paymentType, int custId, int orderId, String accessToken) {
  if (paymentType == 'qr' || paymentType == 'qrcode') {
    checkoutCtr.routeName = "payment_qrcode_page";
    return '${webview_b2c}payment/app/pmq_Z3kLj5w4RBsH2xCyVNu9tg?custId=$custId&orderId=$orderId&accessToken=$accessToken';
  } else if (paymentType == 'card') {
    checkoutCtr.routeName = "payment_card_page";
    return '${webview_b2c}payment/app/pmc_b2E9v7GjFdQwXsLkY3zpNe?custId=$custId&orderId=$orderId&accessToken=$accessToken';
  }
  return null;
}

Future<void> handlePaymentNavigation(String url) async {
  await Get.to(() => WebViewFullScreen(mparamurl: url),
          routeName: checkoutCtr.routeName)
      ?.then((val) {
    Get.find<EndUserCouponCartCtr>().clearVal();
    Get.find<CheckboxController>().clearVal();
    Get.find<EndUserCartCtr>().clearVal();
    final orderCtr = Get.find<OrderController>();
    cartCtr.fetchCartItems();
    if (val == true) {
      orderCtr.fetchOrderList(1, 0);
      orderCtr.fetchNotifyOrderTracking(10627, 0);
      Get.offAllNamed('/EndUserHome', parameters: {'changeView': "3"});
      Get.to(() => const MyOrderHistory(), arguments: 1);
    } else {
      orderCtr.fetchOrderList(0, 0);
      orderCtr.fetchNotifyOrderTracking(10627, 0);
      Get.offAllNamed('/EndUserHome', parameters: {'changeView': "3"});
      Get.to(() => const MyOrderHistory());
    }
  });
}

class EndUserCartSummary extends StatefulWidget {
  const EndUserCartSummary({super.key});

  @override
  State<EndUserCartSummary> createState() => _EndUserCartSummaryState();
}

class _EndUserCartSummaryState extends State<EndUserCartSummary> {
  Future<void> handlePaymentNavigationCod() async {
    Get.find<EndUserCouponCartCtr>().clearVal();
    Get.find<CheckboxController>().clearVal();
    Get.find<EndUserCartCtr>().clearVal();
    final orderCtr = Get.find<OrderController>();
    orderCtr.fetchOrderList(1, 0);
    orderCtr.fetchNotifyOrderTracking(10627, 0);

    cartCtr.fetchCartItems();
    Get.offAllNamed('/EndUserHome', parameters: {'changeView': "3"});
    Get.to(() => const MyOrderHistory(), arguments: 1);
  }

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
                  textStyle: GoogleFonts.notoSansThaiLooped())),
          textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
            Theme.of(context).textTheme,
          ),
          primaryTextTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
          // backgroundColor: Colors.grey.shade100,
          backgroundColor: Colors.white,
          appBar: appBarMasterEndUser('สรุปการสั่งซื้อ'),
          body: Obx(() {
            if (checkoutCtr.isLoadingcChekcout.value) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return Container(
              color: Colors.grey.shade100,
              height: Get.height,
              // padding: EdgeInsets.only(bottom: 60),
              child: SingleChildScrollView(
                  child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        EndUserAddress(),
                        SizedBox(
                          height: 8,
                        ),
                        EndUserProductList(),
                        SizedBox(
                          height: 8,
                        ),
                        EndUserFridayCoupon(),
                        SizedBox(
                          height: 8,
                        ),
                        EndUserPaymentChannels(),
                        SizedBox(
                          height: 8,
                        ),
                        EndUserTotalPayment()
                      ],
                    ),
                  ),
                ],
              )),
            );
          }),
          bottomNavigationBar: SafeArea(
            child: Container(
                // padding: const EdgeInsets.only(bottom: 28),
                color: Colors.white,
                child: IntrinsicHeight(
                  child: Container(
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(88, 0, 0, 0),
                        offset: Offset(0.0, -12.0),
                        blurRadius: 12,
                        spreadRadius: -20,
                      ),
                    ]),
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      children: [
                        const Divider(
                          height: 0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'รวมยอดสั่งซื้อ',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        Obx(() {
                                          if (checkoutCtr
                                              .isLoadingcChekcout.value) {
                                            return Text(
                                              ' ...',
                                              style: TextStyle(
                                                color:
                                                    Colors.deepOrange.shade700,
                                                fontSize: 12,
                                              ),
                                            );
                                          }
                                          return Text(
                                            ' ฿${myFormat.format(checkoutCtr.checkoutItems!.value.data.totalPayable)}',
                                            style: TextStyle(
                                                color:
                                                    Colors.deepOrange.shade700,
                                                fontWeight: FontWeight.bold),
                                          );
                                        }),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     const Text(
                                    //       'ส่วนลด',
                                    //       style: TextStyle(
                                    //         fontSize: 12,
                                    //       ),
                                    //     ),
                                    //     Text(
                                    //       ' ฿100',
                                    //       style: TextStyle(
                                    //         color: Colors.deepOrange.shade700,
                                    //         fontSize: 13,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, bottom: 8, left: 8, right: 8),
                                  child: SizedBox(
                                    height: 40,
                                    child: Obx(() {
                                      if (checkoutCtr
                                          .isLoadingcChekcout.value) {
                                        return const SizedBox();
                                      }
                                      return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor: checkoutCtr
                                                      .checkoutItems!
                                                      .value
                                                      .data
                                                      .shoporders
                                                      .every(
                                                          (e) => e.code == "-9")
                                                  ? Colors.grey.shade300
                                                  : themeColorDefault,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4))),
                                          onPressed: () async {
                                            if (checkoutCtr.checkoutItems!.value
                                                .data.shoporders
                                                .every((e) => e.code == "-9")) {
                                              return;
                                            }
                                            if (checkoutCtr
                                                        .paymentType["type"] ==
                                                    "" ||
                                                checkoutCtr
                                                        .paymentType["type"] ==
                                                    null) {
                                              dialogConfirm(
                                                      'กรุณาเลือกวิธีการชำระเงิน',
                                                      'ตกลง',
                                                      '')
                                                  .then((res) {
                                                Get.to(() =>
                                                    const EndUserChangePayment());
                                              });
                                              return;
                                            }
                                            SetData data = SetData();

                                            var defaultAddress = checkoutCtr
                                                .addressList!.data
                                                .firstWhereOrNull(
                                              (element) =>
                                                  element.isDeliveryAddress,
                                            );
                                            var shopOrders = [];
                                            List<
                                                    checkout_model
                                                    .CheckoutShopOrder>
                                                itemsList = itemsUpdate();

                                            for (var items in checkoutCtr
                                                .checkoutItems!
                                                .value
                                                .data
                                                .shoporders) {
                                              List<CartonInput> cartonList = [];
                                              List<dynamic> vouchersId = [];

                                              for (var ctr in cartCouponCtr
                                                  .promotionDataCheckOut
                                                  .shopVouchers) {
                                                if (!ctr.unusedShopVoucher &&
                                                    ctr.shopId ==
                                                        items.shop.shopId) {
                                                  vouchersId = ctr.vouchers;
                                                }
                                              }

                                              for (var product in itemsList) {
                                                if (items.shop.shopId ==
                                                        product.shopId &&
                                                    items.code != "-9") {
                                                  for (var carton
                                                      in items.carton) {
                                                    // ดึงข้อมูล logistic_channels
                                                    LogisticChannel
                                                        logisticChannel =
                                                        carton.logisticChannels[
                                                            0];
                                                    LogisticChannelsInput
                                                        logistic =
                                                        LogisticChannelsInput(
                                                      logisticId:
                                                          logisticChannel
                                                              .logisticId,
                                                      couponId: logisticChannel
                                                          .couponId,
                                                    );

                                                    // ดึงข้อมูล items
                                                    List<ItemInput>
                                                        itemsCheckOut = carton
                                                            .itemCheckout
                                                            .map((item) {
                                                      return ItemInput(
                                                        cartId: item.cartId,
                                                        promotionId:
                                                            item.promotionId,
                                                      );
                                                    }).toList();

                                                    cartonList.add(CartonInput(
                                                      logisticChannels:
                                                          logistic,
                                                      items: itemsCheckOut,
                                                    )); // ✅ เพิ่มเข้า list ใหม่
                                                  }
                                                }
                                              }

                                              shopOrders.addIf(
                                                  items.code != "-9", {
                                                "shop_id": items.shop.shopId,
                                                "vouchers": vouchersId,
                                                "carton": cartonList
                                              });
                                            }
                                            loadingProductStock(context);
                                            var custId = await data.b2cCustID;

                                            var payload = jsonEncode({
                                              "cust_id": custId,
                                              "addr_id": defaultAddress!.id,
                                              "addr_remark": "",
                                              "platform_vouchers": cartCouponCtr
                                                      .promotionData
                                                      .unusedPlatformVoucher
                                                  ? []
                                                  : cartCouponCtr.promotionData
                                                      .platformVouchers,
                                              "payment_code": checkoutCtr
                                                      .paymentType[
                                                  'value'], // cod , qr, card
                                              "device": await data.device,
                                              "language": "th",
                                              "shoporders": shopOrders
                                            });

                                            var res = await cartConfirmService(
                                                payload);
                                            Get.back();
                                            if (res.code == '100') {
                                              dialogAlert([
                                                const Icon(
                                                  Icons.check_rounded,
                                                  color: Colors.white,
                                                  size: 34,
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  res.message,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                )
                                              ]);
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1000),
                                                  () async {
                                                Get.back();
                                                final paymentType = checkoutCtr
                                                    .paymentType['value'];
                                                final url = getPaymentUrl(
                                                    paymentType!,
                                                    custId,
                                                    res.orderId,
                                                    await data.accessToken);
                                                if (url != null) {
                                                  await handlePaymentNavigation(
                                                      url);
                                                } else {
                                                  handlePaymentNavigationCod();
                                                }
                                              });
                                              return;
                                            } else if (res.code == '-1') {
                                              return dialogOutStockConfirm([
                                                Image.asset(
                                                  "assets/images/b2c/icon/outstock.png",
                                                  scale: 4.5,
                                                ),
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                Text(
                                                  'รายการสินค้าหมด',
                                                  style: GoogleFonts
                                                      .notoSansThaiLooped(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  res.message
                                                      .replaceAll(r'\n', '\n'),
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts
                                                      .notoSansThaiLooped(
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: SizedBox(
                                                    width: Get.width,
                                                    height: 40,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            elevation: 0,
                                                            backgroundColor:
                                                                themeColorDefault),
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: Text(
                                                          'ตกลง',
                                                          style: GoogleFonts
                                                              .notoSansThaiLooped(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                                  ),
                                                )
                                              ]).then((res) {
                                                Get.back();
                                                cartCtr.fetchCartItems();
                                              });
                                            } else {
                                              dialogAlert([
                                                const Icon(
                                                  Icons.error,
                                                  color: Colors.white,
                                                  size: 34,
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  res.message,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                )
                                              ]);
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1000), () {
                                                Get.back();
                                                Get.back();
                                                cartCtr.fetchCartItems();
                                              });
                                            }
                                          },
                                          child: const Text(
                                            'สั่งสินค้า',
                                            style: TextStyle(fontSize: 15),
                                          ));
                                    }),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class EndUserTotalPayment extends StatelessWidget {
  const EndUserTotalPayment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Obx(() {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'ข้อมูลการชำระเงิน',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          ...List.generate(
              checkoutCtr.checkoutItems!.value.data.priceBreakdown.length,
              (index) {
            if (index ==
                checkoutCtr.checkoutItems!.value.data.priceBreakdown.length -
                    1) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    checkoutCtr
                        .checkoutItems!.value.data.priceBreakdown[index].name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    checkoutCtr.checkoutItems!.value.data.priceBreakdown[index]
                                .displayValue ==
                            ""
                        ? "0"
                        : checkoutCtr.checkoutItems!.value.data
                            .priceBreakdown[index].displayValue,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  checkoutCtr
                      .checkoutItems!.value.data.priceBreakdown[index].name,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
                Text(
                  checkoutCtr.checkoutItems!.value.data.priceBreakdown[index]
                              .displayValue ==
                          ""
                      ? "0"
                      : checkoutCtr.checkoutItems!.value.data
                          .priceBreakdown[index].displayValue,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            );
          }),
          if (checkoutCtr.checkoutItems!.value.data.priceBreakdown.isEmpty)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'รวมการสั่งซื้อ',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                Text(
                  '฿0',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            )
        ]);
      }),
    );
  }
}

class EndUserPaymentChannels extends StatelessWidget {
  const EndUserPaymentChannels({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ช่องทางการชำระเงิน',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const EndUserChangePayment());
                },
                child: Row(
                  children: [
                    Text(
                      'ดูทั้งหมด',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 12, color: Colors.grey.shade700)
                  ],
                ),
              ),
            ],
          ),
          GetBuilder<EndUserCartCtr>(builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.paymentType["type"] == null
                      ? "ระบุช่องทางการชำระเงิน"
                      : controller.paymentType["type"]!,
                  style: const TextStyle(fontSize: 13),
                ),
                if (controller.paymentType["type"] != null)
                  Icon(Icons.check_circle, color: themeColorDefault),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class EndUserFridayCoupon extends StatelessWidget {
  const EndUserFridayCoupon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (checkoutCtr.checkoutItems!.value.data.shoporders
        .every((e) => e.code == "-9")) {
      return const SizedBox();
    }
    return Container(
      padding: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'โค้ดส่วนลด Friday',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              InkWell(
                onTap: () async {
                  await loadCouponPlatForm();
                },
                child: Row(
                  children: [
                    Obx(() {
                      return Text(
                        checkoutCtr.checkoutItems!.value.data.discountDisplay
                                    .text ==
                                ""
                            ? 'กดใช้โค้ด'
                            : checkoutCtr
                                .checkoutItems!.value.data.discountDisplay.text,
                        style: TextStyle(
                            fontSize: 12,
                            color: checkoutCtr.checkoutItems!.value.data
                                        .discountDisplay.text ==
                                    ""
                                ? Colors.grey.shade700
                                : Colors.deepOrange.shade700),
                      );
                    }),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 12, color: Colors.grey.shade700)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EndUserProductList extends StatefulWidget {
  const EndUserProductList({
    super.key,
  });

  @override
  State<EndUserProductList> createState() => _EndUserProductListState();
}

class _EndUserProductListState extends State<EndUserProductList> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: checkoutCtr.checkoutItems!.value.data.shoporders.length,
          itemBuilder: (context, index) {
            var items = checkoutCtr.checkoutItems!.value.data.shoporders[index];
            return Container(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.only(
                  bottom: index ==
                          checkoutCtr
                                  .checkoutItems!.value.data.shoporders.length -
                              1
                      ? 0
                      : 8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: items.shop.icon,
                          width: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: Get.width - 60),
                        child: Text(
                          items.shop.shopName,
                          style: GoogleFonts.notoSansThaiLooped(
                              fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      ),
                    ]),
                  ),
                  const Divider(
                    height: 0,
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: items.carton.length,
                      itemBuilder: (context, cartonIndex) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!items.carton[cartonIndex].onlyOne)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Text(
                                  items.carton[cartonIndex].cartonDesc,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: items
                                      .carton[cartonIndex].itemCheckout.length,
                                  itemBuilder: (context, productIndex) {
                                    var product = items.carton[cartonIndex]
                                        .itemCheckout[productIndex];
                                    return productList(
                                        items, cartonIndex, product);
                                  }),
                            ),
                            const Divider(
                              height: 0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: items.code == "-9"
                                        ? Colors.grey[50]
                                        : themeColorDefault.withOpacity(0.05),
                                    border: Border.all(
                                        width: 0.4,
                                        color: items.code == "-9"
                                            ? Colors.grey.shade200
                                            : themeColorDefault)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          items.carton[cartonIndex]
                                              .logisticChannels[0].name,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (items.code != "-9")
                                          Text(
                                            '฿ ${items.carton[cartonIndex].logisticChannels[0].chargeableShippingFee}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (items.code != "-9")
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 2.0),
                                            child: Icon(
                                              Icons.local_shipping_rounded,
                                              size: 12,
                                              color: themeColorDefault,
                                            ),
                                          ),
                                        if (items.code != "-9")
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        Text(
                                          items.code == "-9"
                                              ? items
                                                  .carton[cartonIndex]
                                                  .logisticChannels[0]
                                                  .description
                                              : items
                                                  .carton[cartonIndex]
                                                  .logisticChannels[0]
                                                  .estimatedDeliveryTime,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: items.code == '-9'
                                                  ? Colors.red.shade700
                                                  : themeColorDefault),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  const Divider(
                    height: 0,
                  ),
                  InkWell(
                    onTap: () {
                      if (items.code == '-9') {
                        return;
                      }

                      var selectedShop = checkoutCtr
                          .checkoutItems!.value.data.promotionData.shopVouchers
                          .firstWhereOrNull(
                              (element) => element.shopId == items.shop.shopId);
                      if (selectedShop == null) {
                        cartCouponCtr.shopVouchers.value = [];
                        storerCouponSelected(context).then((res) async {
                          await loadCouponShop();
                        });
                        return;
                      }
                      cartCouponCtr.shopVouchers.value =
                          selectedShop.shopVouchers;
                      storerCouponSelected(context).then((res) async {
                        await loadCouponShop().then((res) {
                          // setState(() {});
                          // cartCtr.checkoutItems!.refresh();
                          // printJSON(cartCtr.checkoutItems!.value.data.shoporders
                          //     .where(
                          //         (e) => e.shop.shopId == selectedShop.shopId)
                          //     .toList());
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/b2c/icon/coupon2.png',
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Text(
                                'โค้ดส่วนลดร้านค้า',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                items.discountVoucher,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: items.discountVoucher == "" ||
                                            items.discountVoucher == "กดใช้โค้ด"
                                        ? Colors.grey.shade700
                                        : Colors.deepOrange.shade700),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: Colors.grey.shade700,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  // const Divider(
                  //   height: 0,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Get.to(() => const B2cRequestEtax(), arguments: []);
                  //     // arguments: ["edit", listAddress[index]]
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Image.asset(
                  //               'assets/images/b2c/icon/etax.png',
                  //               height: 20,
                  //               width: 20,
                  //             ),
                  //             const SizedBox(
                  //               width: 8,
                  //             ),
                  //             const Text(
                  //               'ขอใบกำกับภาษี',
                  //               style: TextStyle(fontSize: 13),
                  //             ),
                  //           ],
                  //         ),
                  //         Row(
                  //           children: [
                  //             Text(
                  //               "ขอใบกำกับภาษี",
                  //               style: TextStyle(
                  //                   fontSize: 13, color: Colors.grey.shade700),
                  //             ),
                  //             Icon(
                  //               Icons.arrow_forward_ios_rounded,
                  //               size: 12,
                  //               color: Colors.grey.shade700,
                  //             )
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const Divider(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'สินค้ารวม ${items.shop.productCount} ชิ้น',
                          style: const TextStyle(fontSize: 13),
                        ),
                        Text(
                          '฿${myFormat.format(items.shop.total)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    });
  }

  Widget productList(Shoporder items, int cartonIndex, ItemCheckout product) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: items.carton[cartonIndex].itemCheckout.length > 1 ? 12.0 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 0.2, color: Colors.grey)),
                  child: CachedNetworkImage(imageUrl: product.productImage),
                ),
                if (items.code == '-9')
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                      child: Container(
                        color:
                            Colors.white.withOpacity(0.5), // สีขาวโปร่งแสง 50%
                      ),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13,
                      color: items.code == '-9' ? Colors.grey : Colors.black),
                ),
                if (items.code == '-9')
                  Text(
                    items.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Colors.red.shade700),
                  )
                else
                  Text(
                    product.selectItem,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),
                const SizedBox(
                  height: 8,
                ),
                Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (product.haveDiscount)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '฿${myFormat.format(product.price)}',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '฿${myFormat.format(product.priceBeforeDiscount)}',
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    height: 2.6,
                                    fontSize: 10,
                                    color: Colors.grey.shade700),
                              ),
                            ],
                          )
                        else
                          Text(
                            '฿${myFormat.format(product.priceBeforeDiscount)}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        Text(
                          'x${product.quantity}',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    if (items.code == '-9')
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: Container(
                            color: Colors.white
                                .withOpacity(0.5), // สีขาวโปร่งแสง 50%
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class EndUserAddress extends StatefulWidget {
  const EndUserAddress({
    super.key,
  });

  @override
  State<EndUserAddress> createState() => _EndUserAddressState();
}

class _EndUserAddressState extends State<EndUserAddress> {
  @override
  void initState() {
    super.initState();
    checkB2cAddress();
  }

  checkB2cAddress() async {
    var res = await fetchAddressListService();
    var defaultAddress = res!.data.firstWhereOrNull(
      (element) => element.isDeliveryAddress,
    );
    if (defaultAddress == null) {
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        if (Get.isDialogOpen! == false) {
          Get.dialog(Dialog(
              backgroundColor: Colors.transparent,
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1)),
                child:
                    StatefulBuilder(builder: (context, StateSetter setState) {
                  return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'กรุณาเพิ่มที่อยู่เพื่อทำการสั่งซื้อ',
                              style:
                                  GoogleFonts.notoSansThaiLooped(fontSize: 14),
                            ),
                          )),
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.back(result: null);
                                      },
                                      child: Center(
                                          child: Text('ยกเลิก',
                                              style: GoogleFonts
                                                  .notoSansThaiLooped(
                                                      fontSize: 14))),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 30, child: VerticalDivider()),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        var res = await Get.to(
                                            () => const EndUserSetAddress(),
                                            arguments: ['first']);
                                        if (res == null) {
                                          Get.back(result: false);
                                        } else {
                                          Get.back(result: res);
                                        }
                                      },
                                      child: Center(
                                          child: Text(
                                        'เพิ่มที่อยู่ใหม่',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            color: Colors.deepOrange.shade700,
                                            fontSize: 14),
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ));
                }),
              ))).then((value) {
            if (value == null) {
              Get.back();
            } else {
              if (value == false) {
                checkB2cAddress();
              } else {
                cartCtr.fetchAddressList();
              }
            }
          });
        }
      }
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (checkoutCtr.isLoadingAddress.value) {
        return Container(
          padding: const EdgeInsets.all(8),
          width: Get.width,
          height: 45,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
        );
      }
      var defaultAddress = checkoutCtr.addressList!.data.firstWhereOrNull(
        (element) => element.isDeliveryAddress,
      );
      if (defaultAddress == null) {
        // checkB2cAddress();
        return InkWell(
          onTap: () {
            // Get.to(() => const EndUserSelectAddress());
            Get.to(() => const EndUserSetAddress(), arguments: ['first']);
          },
          child: Container(
              padding: const EdgeInsets.all(8),
              width: Get.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.deepOrange.shade700,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'เพิ่มที่อยู่',
                      style: TextStyle(
                          fontSize: 13, color: Colors.deepOrange.shade700),
                    ),
                  ],
                ),
              )),
        );
      }
      return InkWell(
        onTap: () {
          Get.find<EndUserCartCtr>().fetchAddressList();
          Get.to(() => const EndUserSelectAddress());
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          width: Get.width,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                Icons.pin_drop_sharp,
                color: Colors.deepOrange.shade700,
              )),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${defaultAddress.firstName} ${defaultAddress.lastName}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' ${formatPhoneNumber(defaultAddress.phone)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${defaultAddress.address1} \n${defaultAddress.address}",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: Colors.grey.shade700,
              )
            ],
          ),
        ),
      );
    });
  }
}

List<checkout_model.CheckoutShopOrder> itemsUpdate() {
  var res = Get.find<CheckboxController>().generateOutputJson();
  List<checkout_model.CheckoutShopOrder> shopUpdate = res.map((shop) {
    // สร้างรายการ ProductBriefs สำหรับแต่ละ shop
    List<ProductBrief> productBriefs =
        (shop['product_briefs'] as List).map((brief) {
      return ProductBrief(
        productId: brief['product_id'],
        itemId: brief['item_id'],
      );
    }).toList();

    // เพิ่ม UpdatedShopOrder ลงใน shopList
    return checkout_model.CheckoutShopOrder(
      productBriefs: productBriefs,
      shopId: shop['shop_id'],
    );
  }).toList();
  return shopUpdate;
}

Future<void> loadCouponPlatForm() async {
  SetData data = SetData();

  await Get.to(() => const EndUserCartCoupon())!.then((value) async {
    cartCouponCtr.promotionDataCheckOut.unusedPlatformVoucher =
        cartCouponCtr.promotionData.unusedPlatformVoucher;
    cartCouponCtr.promotionDataCheckOut.platformVouchers =
        cartCouponCtr.promotionData.platformVouchers;

    var payload = checkout_model.CartCheckOutInput(
      custId: await data.b2cCustID,
      checkoutShopOrders: itemsUpdate(),
      promotionData: checkout_model.PromotionData(
          freeShipping: [],
          unusedPlatformVoucher:
              cartCouponCtr.promotionData.unusedPlatformVoucher,
          platformVouchers: cartCouponCtr.promotionData.platformVouchers,
          shopVouchers: cartCouponCtr.promotionShop),
    );

    // cartCtr.fetchCartCheckOut(payload);
    cartCtr.checkoutItems!.value = await cartCheckOutService(payload);
  });
}

Future<void> loadCouponShop() async {
  SetData data = SetData();

  cartCouponCtr.promotionDataCheckOut.shopVouchers =
      cartCouponCtr.promotionData.shopVouchers;
  var payload = checkout_model.CartCheckOutInput(
    custId: await data.b2cCustID,
    checkoutShopOrders: itemsUpdate(),
    promotionData: checkout_model.PromotionData(
        freeShipping: [],
        unusedPlatformVoucher:
            cartCouponCtr.promotionData.unusedPlatformVoucher,
        platformVouchers: cartCouponCtr.promotionData.platformVouchers,
        shopVouchers: cartCouponCtr.promotionData.shopVouchers),
  );
  cartCtr.checkoutItems!.value = await cartCheckOutService(payload);
}

class CartonInput {
  final LogisticChannelsInput logisticChannels;
  final List<ItemInput> items;

  CartonInput({required this.logisticChannels, required this.items});

  factory CartonInput.fromJson(Map<String, dynamic> json) {
    return CartonInput(
      logisticChannels:
          LogisticChannelsInput.fromJson(json['logistic_channels']),
      items: (json['items'] as List)
          .map((item) => ItemInput.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "logistic_channels": logisticChannels.toJson(),
      "items": items.map((item) => item.toJson()).toList(),
    };
  }
}

class LogisticChannelsInput {
  final int logisticId;
  final int couponId;

  LogisticChannelsInput({required this.logisticId, required this.couponId});

  factory LogisticChannelsInput.fromJson(Map<String, dynamic> json) {
    return LogisticChannelsInput(
      logisticId: json['logistic_id'],
      couponId: json['coupon_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "logistic_id": logisticId,
      "coupon_id": couponId,
    };
  }
}

class ItemInput {
  final int cartId;
  final int promotionId;

  ItemInput({required this.cartId, required this.promotionId});

  factory ItemInput.fromJson(Map<String, dynamic> json) {
    return ItemInput(
      cartId: json['cart_id'],
      promotionId: json['promotion_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "cart_id": cartId,
      "promotion_id": promotionId,
    };
  }
}
