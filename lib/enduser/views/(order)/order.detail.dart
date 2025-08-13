import 'dart:io';

import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/components/viewer/fullscreen.image.dart';
import 'package:fridayonline/enduser/controller/brand.ctr.dart';
import 'package:fridayonline/enduser/controller/order.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/enduser/models/orders/bank.model.dart';
import 'package:fridayonline/enduser/models/orders/courier.model.dart';
import 'package:fridayonline/enduser/models/orders/reason.model.dart';
import 'package:fridayonline/enduser/services/orders/order.service.dart';
import 'package:fridayonline/enduser/utils/format.dart';
import 'package:fridayonline/enduser/views/(order)/return.product.dart';
import 'package:fridayonline/enduser/views/(order)/shipping.detail.dart';
import 'package:fridayonline/enduser/views/(profile)/myorder.dart';
import 'package:fridayonline/enduser/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/validators.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyOrderDetail extends StatefulWidget {
  const MyOrderDetail({super.key, this.tab});
  final int? tab;

  @override
  State<MyOrderDetail> createState() => _MyOrderDetailState();
}

class _MyOrderDetailState extends State<MyOrderDetail> {
  final orderCtr = Get.find<OrderController>();
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
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                    textStyle: GoogleFonts.notoSansThaiLooped())),
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: appBarMasterEndUser('รายละเอียดคำสั่งซื้อ'),
              body: Obx(() {
                if (orderCtr.isLoadingDetail.value) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else {
                  var orderDatailData = orderCtr.orderDetail!.data;
                  var returnInfo = orderDatailData.returnInfo;
                  var orderStatus = orderDatailData.orderStatus.orderStatus;
                  var returnStatus = returnInfo.returnStatus;
                  var showStep = returnInfo.showRefundSteps;
                  var returnType = returnInfo.returnType;

                  return SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Column(
                      children: [
                        if (orderStatus != 9 && orderStatus != 6)
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: Colors.grey[100],
                            color: Colors.white,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(12),
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        color: getStatusColor(orderCtr
                                            .orderDetail!
                                            .data
                                            .orderStatus
                                            .colorCode
                                            .toLowerCase()),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        orderDatailData.orderStatus.description,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      )),
                                  ...List.generate(
                                      orderDatailData.shippingInfo.length,
                                      (index) {
                                    var shipping =
                                        orderDatailData.shippingInfo[index];
                                    return InkWell(
                                      highlightColor: Colors.transparent,
                                      splashFactory: NoSplash.splashFactory,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        Get.to(() => ShippingDetail(
                                            shippingInfo: orderDatailData,
                                            shippingIndex: index));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'ข้อมูลการจัดส่ง',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 14,
                                                )
                                              ],
                                            ),
                                            if (orderDatailData
                                                    .shippingInfo.length >
                                                1)
                                              Text(
                                                'พัสดุกล่องที่ ${index + 1}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600]),
                                              ),
                                            if (shipping.trackingNo != "")
                                              Text(
                                                shipping.trackingNo,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600]),
                                              ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.local_shipping_outlined,
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                if (shipping
                                                    .trackingInfo.isNotEmpty)
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          shipping
                                                              .trackingInfo[0]
                                                              .description,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  themeColorDefault),
                                                        ),
                                                        Text(
                                                          shipping
                                                              .trackingInfo[0]
                                                              .dateTime,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[600]),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                  const Divider(
                                    thickness: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'ที่อยู่ในการจัดส่ง',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                          orderCtr
                                                              .orderDetail!
                                                              .data
                                                              .address
                                                              .shippingName,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          formatPhoneNumber(
                                                              orderCtr
                                                                  .orderDetail!
                                                                  .data
                                                                  .address
                                                                  .shippingPhone),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    orderCtr
                                                        .orderDetail!
                                                        .data
                                                        .address
                                                        .shippingAddress,
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
                          )
                        else if (orderStatus == 6)
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: Colors.grey[100],
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    orderDatailData.orderStatus.description,
                                    style: TextStyle(
                                        color: Colors.deepOrange.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.deepOrange.shade700
                                          .withOpacity(0.1),
                                    ),
                                    child: Icon(
                                      Icons.restore_rounded,
                                      color: Colors.deepOrange.shade700,
                                      size: 40,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        else
                          Builder(builder: (context) {
                            if (!showStep) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  shadowColor: Colors.grey[100],
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          orderDatailData
                                              .orderStatus.description,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.deepOrange.shade700),
                                        ),
                                        Icon(Icons.restore_rounded,
                                            color: Colors.deepOrange.shade700),
                                      ],
                                    ),
                                  ));
                            }
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadowColor: Colors.grey[100],
                              color: Colors.white,
                              child: Column(
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: 80, minWidth: Get.width),
                                    child: Center(
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: orderDatailData
                                              .shippingInfo[0].step.length,
                                          itemBuilder: (context, index) {
                                            final step = orderCtr
                                                .orderDetail!
                                                .data
                                                .shippingInfo[0]
                                                .step[index];
                                            return TimelineTile(
                                              isFirst: index == 0,
                                              isLast: index ==
                                                  orderCtr
                                                          .orderDetail!
                                                          .data
                                                          .shippingInfo[0]
                                                          .step
                                                          .length -
                                                      1,
                                              axis: TimelineAxis.horizontal,
                                              alignment: TimelineAlign.center,
                                              // lineXY: 0.1,
                                              indicatorStyle: step.isCurrent ==
                                                      true
                                                  ? IndicatorStyle(
                                                      indicator: ClipOval(
                                                        child: Container(
                                                          color:
                                                              themeColorDefault,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                step.image,
                                                          ),
                                                        ),
                                                      ),
                                                      width: 32,
                                                      height: 32,
                                                      color: themeColorDefault,
                                                    )
                                                  : IndicatorStyle(
                                                      height: 8,
                                                      width: 8,
                                                      indicator: ClipOval(
                                                        child: Container(
                                                          color:
                                                              themeColorDefault,
                                                        ),
                                                      ),
                                                    ),
                                              beforeLineStyle: LineStyle(
                                                  thickness: 2,
                                                  color: themeColorDefault),
                                              endChild: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Text(
                                                  step.text,
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                  if (returnStatus == 2)
                                    const Divider(
                                      height: 0,
                                    ),
                                  if (returnStatus == 2)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              returnInfo.returnTypeDesc,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                loadingProductStock(context);
                                                var bank =
                                                    await fetchBankService();
                                                var courier =
                                                    await fetchCourierService();
                                                Get.back();
                                                bottomDetailReturn(
                                                    bank: bank,
                                                    courier: courier);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      themeColorDefault),
                                              child: const Text(
                                                'ระบุรายละเอียด',
                                                style: TextStyle(fontSize: 12),
                                              )),
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            );
                          }),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: Colors.grey[100],
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.find<BrandCtr>().fetchShopData(
                                        orderDatailData.shopInfo.shopId);
                                    // Get.to(() => const BrandStore());
                                    Get.toNamed(
                                        '/BrandStore/${orderDatailData.shopInfo.shopId}');
                                  },
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(2),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              orderDatailData.shopInfo.icon,
                                          width: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        orderDatailData.shopInfo.shopName,
                                        style: GoogleFonts.notoSansThaiLooped(
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: orderCtr
                                      .orderDetail!.data.itemGroups.length,
                                  itemBuilder: (context, index) {
                                    var itemGroup = orderCtr
                                        .orderDetail!.data.itemGroups[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: InkWell(
                                        onTap: () {
                                          Get.find<ShowProductSkuCtr>()
                                              .fetchB2cProductDetail(
                                                  itemGroup.productId,
                                                  'order_detail');
                                          Get.toNamed(
                                            '/ShowProductSku/${itemGroup.productId}',
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  imageUrl: itemGroup.image,
                                                  width: 76,
                                                  height: 76,
                                                  fit: BoxFit.contain,
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return Container(
                                                      color:
                                                          Colors.grey.shade50,
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported_rounded,
                                                        color: Colors
                                                            .grey.shade200,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      itemGroup.productName,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          itemGroup.itemName,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12),
                                                        ),
                                                        Text(
                                                          "x ${myFormat.format(itemGroup.amount)}",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        widget.tab == 5
                                                            ? '฿${myFormat.format(itemGroup.refundAmountPerItem)}'
                                                            : '฿${myFormat.format(itemGroup.price)}',
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                if (orderStatus == 9)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Divider(),
                                      if (returnType == 1)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (returnInfo
                                                    .returnPayment.bankId !=
                                                0)
                                              Text(
                                                'ค่าจัดส่งที่ได้รับคืน',
                                                style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            if (returnInfo
                                                    .returnPayment.bankId !=
                                                0)
                                              Text(
                                                "฿${myFormat.format(returnInfo.returnDelivery.shippingFee)}",
                                                style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                          ],
                                        ),
                                      if (returnInfo.returnPayment.bankId != 0)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'ค่าสินค้าที่ได้รับคืน',
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "฿${myFormat.format(returnInfo.refundAmount)}",
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'ยอดเงินคืนทั้งหมด',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "฿${myFormat.format(returnInfo.refundAmount + returnInfo.returnDelivery.shippingFee)}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'วันเวลาที่ยื่นคำขอ',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600]),
                                          ),
                                          Text(
                                            returnInfo.returnDate,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'เหตุผล',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[700]),
                                          ),
                                          Text(
                                            returnInfo.returnReason,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      if (orderStatus == 9)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'คำอธิบาย',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[700]),
                                            ),
                                            Text(
                                              returnInfo.comment == ""
                                                  ? "-"
                                                  : returnInfo.comment,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      SizedBox(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              ...List.generate(
                                                  returnInfo.images.length,
                                                  (index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        FullScreenImageViewer(
                                                          imageUrls:
                                                              returnInfo.images,
                                                          initialIndex: index,
                                                        ));
                                                  },
                                                  child: Container(
                                                    width: 80,
                                                    height: 80,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 4),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .shade400)),
                                                    child: Image.network(
                                                        fit: BoxFit.cover,
                                                        returnInfo
                                                            .images[index]),
                                                  ),
                                                );
                                              })
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (orderStatus != 9)
                                  const Divider(thickness: 1),
                                if (orderStatus != 9)
                                  ...List.generate(
                                      orderDatailData.paymentInfo.info.length,
                                      ((index) {
                                    var paymentInfo =
                                        orderDatailData.paymentInfo.info[index];
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          paymentInfo.text,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600]),
                                        ),
                                        Text(
                                          '฿${myFormat.format(paymentInfo.value)}',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    );
                                  })),
                                if (orderStatus != 9)
                                  const Divider(thickness: 1),
                                if (orderStatus != 9)
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        'รวมคำสั่งซื้อ: ฿${myFormat.format(orderDatailData.paymentInfo.finalTotal)}',
                                        style: const TextStyle(fontSize: 14),
                                      ))
                              ],
                            ),
                          ),
                        ),
                        if (orderStatus == 9 &&
                            returnInfo.returnPayment.bankId != 0)
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: Colors.grey[100],
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'รายละเอียดการขอคืนเงิน',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "คืนเงินไปยัง",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(returnInfo.returnPayment.accountName,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(returnInfo.returnPayment.bankDesc,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      Text(returnInfo.returnPayment.accountNo,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  if (returnType == 1)
                                    Text('จัดส่งโดย',
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 12,
                                        )),
                                  if (returnType == 1)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            returnInfo
                                                .returnDelivery.courierDesc,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            returnInfo
                                                .returnDelivery.trackingNo,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  if (returnType == 1)
                                    SizedBox(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            ...List.generate(
                                                returnInfo.imagesTracking
                                                    .length, (index) {
                                              return InkWell(
                                                onTap: () {
                                                  Get.to(() =>
                                                      FullScreenImageViewer(
                                                        imageUrls: returnInfo
                                                            .imagesTracking,
                                                        initialIndex: index,
                                                      ));
                                                },
                                                child: Container(
                                                  width: 80,
                                                  height: 80,
                                                  clipBehavior: Clip.antiAlias,
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade400)),
                                                  child: Image.network(
                                                      fit: BoxFit.cover,
                                                      returnInfo.imagesTracking[
                                                          index]),
                                                ),
                                              );
                                            })
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: Colors.grey[100],
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'หมายเลขคำสั่งซื้อ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      orderDatailData.orderNo,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ชำระผ่าน',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    ),
                                    Text(
                                      orderDatailData.paymentInfo.paymentMethod
                                          .paymentChannelName,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
              bottomNavigationBar: Obx(
                () {
                  if (orderCtr.isLoadingDetail.value) {
                    return const SizedBox();
                  } else if (orderCtr.orderDetail!.data.canCancel) {
                    return Container(
                      color: Colors.white,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                side: BorderSide(
                                    color: Colors.grey.shade700, width: 0.5),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)))),
                            onPressed: () async {
                              loadingProductStock(context);
                              await fetchCancelReasonOrdersService(orderCtr
                                      .orderDetail!.data.shopInfo.shopId)
                                  .then((value) {
                                Get.back();

                                bottomReasonCancel(value,
                                    orderCtr.orderDetail!.data.orderId, false);
                              });
                            },
                            child: const Text('ยกเลิกคำสั่งซื้อ'),
                          ),
                        ),
                      ),
                    );
                  } else if (orderCtr.orderDetail!.data.canReturn) {
                    return Container(
                      color: Colors.white,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                side: BorderSide(
                                    color: Colors.grey.shade700, width: 0.5),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)))),
                            onPressed: () async {
                              orderCtr.fetchOrderDetail(
                                  orderCtr.orderDetail!.data.orderId);
                              Get.to(() => const ReturnProdut());
                            },
                            child: const Text('คืนสินค้า'),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              )),
        ));
  }

  bottomDetailReturn({required Bank bank, required Courier courier}) {
    var address = orderCtr.orderDetail!.data.returnInfo.returnAddress;
    int selectedBankId = bank.data.first.bankId;
    int selectedCourierId = courier.data.first.courierId;

    final formkey = GlobalKey<FormState>();

    final TextEditingController bankNameCtr = TextEditingController();
    final TextEditingController bankNoCtr = TextEditingController();
    final TextEditingController courierNoCtr = TextEditingController();
    final TextEditingController courierPriceCtr = TextEditingController();

    List<File> selectedImages = [];
    final ImagePicker picker = ImagePicker();
    var returnType = orderCtr.orderDetail!.data.returnInfo.returnType;
    var returnInfo = orderCtr.orderDetail!.data.returnInfo;
    var custAddr = orderCtr.orderDetail!.data.address;

    Get.bottomSheet(isScrollControlled: true, backgroundColor: Colors.white,
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      Future<void> pickImages() async {
        final pickedFiles = await picker.pickMultiImage();

        if (pickedFiles.isNotEmpty) {
          setState(() {
            selectedImages =
                pickedFiles.take(2).map((file) => File(file.path)).toList();
          });
        }
      }

      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'โปรดระบุรายละเอียด',
                            style: GoogleFonts.notoSansThaiLooped(
                                fontWeight: FontWeight.bold),
                          ),
                          if (returnType == 1)
                            Text(
                              '( คืนเงิน คืนสินค้า )',
                              style: GoogleFonts.notoSansThaiLooped(
                                  fontSize: 11, color: Colors.red),
                            )
                          else
                            Text(
                              '( คืนเงิน ไม่คืนสินค้า )',
                              style: GoogleFonts.notoSansThaiLooped(
                                  fontSize: 11, color: Colors.red),
                            ),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.close))
                    ],
                  ),
                ),
                const Divider(
                  height: 0,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: Get.height / 1.2),
                  child: Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(2),
                            width: Get.width,
                            padding: const EdgeInsets.all(8),
                            color: themeColorDefault.withOpacity(0.2),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: themeColorDefault,
                                      borderRadius: BorderRadius.circular(50)),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.notifications_active_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    'โปรดระบุข้อมูลให้ถูกต้อง\nหลังกดยืนยันจะไม่สามารถแก้ไขได้อีก',
                                    style: GoogleFonts.notoSansThaiLooped(
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'บัญชีธนาคารที่ต้องการรับเงินคืน',
                                    style: GoogleFonts.notoSansThaiLooped(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: Get.width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Colors.grey)),
                                    child: DropdownButton<int>(
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      dropdownColor: Colors.white,
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down_rounded),
                                      value: selectedBankId,
                                      elevation: 12,
                                      borderRadius: BorderRadius.circular(12),
                                      hint: null,
                                      // padding: EdgeInsets.zero,
                                      style: TextStyle(
                                          color: Colors.grey.shade700),
                                      onChanged: (int? value) {
                                        setState(() {
                                          selectedBankId = value!;
                                        });
                                      },
                                      selectedItemBuilder: (context) {
                                        return bank.data.map((bank) {
                                          return DropdownMenuItem<int>(
                                            value: bank.bankId,
                                            child: Text(
                                              bank.bankName,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList();
                                      },
                                      items: bank.data.map((bank) {
                                        return DropdownMenuItem<int>(
                                          value: bank.bankId,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                bank.bankName,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Divider(
                                                  color: Colors.grey.shade300,
                                                  height: 0,
                                                  thickness: 1),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                      validator: Validators.required(
                                          'กรุณาระบุชื่อบัญชีของคุณ'),
                                      controller: bankNameCtr,
                                      style: GoogleFonts.notoSansThaiLooped(
                                          fontSize: 13),
                                      decoration:
                                          textStyle(label: 'ชื่อบัญชี')),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                      validator: Validators.required(
                                          'กรุณาระบุหมายเลขบัญชีของคุณ'),
                                      keyboardType: TextInputType.phone,
                                      controller: bankNoCtr,
                                      style: GoogleFonts.notoSansThaiLooped(
                                          fontSize: 13),
                                      decoration:
                                          textStyle(label: 'หมายเลขบัญชี')),
                                  const Divider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ขนส่งเข้ารับพัสดุ',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            fontSize: 13),
                                      ),
                                      Text(
                                        returnInfo.returnPickupCondition,
                                        style: GoogleFonts.notoSansThaiLooped(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade400),
                                      ),
                                      Container(
                                        width: Get.width,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.blue.shade100),
                                            color: Colors.blue.shade50),
                                        child: Text(
                                          courier.data[0].courierName,
                                          style: GoogleFonts.notoSansThaiLooped(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        'ที่อยู่เข้ารับพัสดุ',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            fontSize: 13),
                                      ),
                                      Container(
                                        width: Get.width,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            color: Colors.grey.shade100),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    custAddr.shippingName,
                                                    style: GoogleFonts
                                                        .notoSansThaiLooped(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    "(${custAddr.shippingPhone})",
                                                    textAlign: TextAlign.start,
                                                    style: GoogleFonts
                                                        .notoSansThaiLooped(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              custAddr.shippingAddress,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts
                                                  .notoSansThaiLooped(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // if (returnType == 1)
                                  if (1 > 2)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        const Divider(),
                                        Text(
                                          'กรุณาจัดส่งสินค้าที่ต้องการคืนมายังที่อยู่ด้านล่างนี้',
                                          style: GoogleFonts.notoSansThaiLooped(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Text(
                                            address,
                                            style:
                                                GoogleFonts.notoSansThaiLooped(
                                                    fontSize: 11),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                          width: Get.width,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: DropdownButton<int>(
                                            isExpanded: true,
                                            underline: const SizedBox(),
                                            dropdownColor: Colors.white,
                                            alignment: AlignmentDirectional
                                                .bottomCenter,
                                            icon: const Icon(Icons
                                                .keyboard_arrow_down_rounded),
                                            value: selectedCourierId,
                                            elevation: 12,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            hint: null,
                                            // padding: EdgeInsets.zero,
                                            style: TextStyle(
                                                color: Colors.grey.shade700),
                                            onChanged: (int? value) {
                                              setState(() {
                                                selectedCourierId = value!;
                                              });
                                            },
                                            selectedItemBuilder: (context) {
                                              return courier.data
                                                  .map((courier) {
                                                return DropdownMenuItem<int>(
                                                  value: courier.courierId,
                                                  child: Text(
                                                    courier.courierName,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                );
                                              }).toList();
                                            },
                                            items: courier.data.map((courier) {
                                              return DropdownMenuItem<int>(
                                                value: courier.courierId,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      courier.courierName,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Divider(
                                                        color: Colors
                                                            .grey.shade300,
                                                        height: 0,
                                                        thickness: 1),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        TextFormField(
                                            validator: Validators.required(
                                                'กรุณาระบุเลขพัสดุ'),
                                            controller: courierNoCtr,
                                            style:
                                                GoogleFonts.notoSansThaiLooped(
                                                    fontSize: 13),
                                            decoration:
                                                textStyle(label: 'เลขพัสดุ')),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        TextFormField(
                                            validator: Validators.required(
                                                'กรุณาระบุค่าจัดส่ง'),
                                            keyboardType: TextInputType.phone,
                                            controller: courierPriceCtr,
                                            style:
                                                GoogleFonts.notoSansThaiLooped(
                                                    fontSize: 13),
                                            decoration:
                                                textStyle(label: 'ค่าจัดส่ง')),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'อัพโหลดหลักฐานใบจัดส่ง (ex. ใบเสร็จ)',
                                          style: GoogleFonts.notoSansThaiLooped(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        if (selectedImages.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: InkWell(
                                              onTap: pickImages,
                                              child: Wrap(
                                                spacing: 10,
                                                children: selectedImages
                                                    .map((image) => ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Image.file(
                                                            image,
                                                            width: 100,
                                                            height: 100,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        if (selectedImages.isEmpty ||
                                            selectedImages.length == 1)
                                          SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: InkWell(
                                              onTap: pickImages,
                                              child: DottedBorder(
                                                borderType: BorderType.RRect,
                                                radius:
                                                    const Radius.circular(10),
                                                dashPattern: const [6, 2],
                                                strokeWidth: 0.5,
                                                color: Colors.grey.shade700,
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          size: 28,
                                                          color: Colors
                                                              .grey.shade700),
                                                      Text(
                                                        'รูปภาพ ${selectedImages.length}/2',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey.shade700),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  width: Get.width,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (returnType == 1 && selectedImages.isEmpty) {
                          Get.snackbar('', '',
                              titleText: Text('แจ้งเตือน',
                                  style: GoogleFonts.notoSansThaiLooped(
                                      color: Colors.white)),
                              messageText: Text('กรุณาแนบใบเสร็จค่าจัดส่ง',
                                  style: GoogleFonts.notoSansThaiLooped(
                                      color: Colors.white)),
                              backgroundColor: Colors.red.withOpacity(0.8),
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2));
                          return;
                        }
                        if (formkey.currentState!.validate()) {
                          Get.back();
                          loadingCart(context);
                          SetData data = SetData();
                          var payload = {
                            "cust_id": await data.b2cCustID,
                            "ordshop_id": orderCtr.orderShopId,
                            "bank_id": selectedBankId,
                            "account_name": bankNameCtr.text,
                            "account_no": bankNoCtr.text,
                            "courier_id": courier.data[0].courierId,
                            // "courier_id":
                            //     returnType != 1 ? 0 : selectedCourierId,
                            "tracking_no":
                                returnType != 1 ? "" : courierNoCtr.text,
                            "shipping_fee": 0,
                            // "shipping_fee": returnType != 1
                            //     ? 0
                            //     : int.parse(courierPriceCtr.text)
                          };
                          await submitReturnUpdateInfoService(
                                  json: payload, images: selectedImages)
                              .then((res) {
                            Get.back();
                            if (res!.code == "100") {
                              dialogAlert([
                                const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                const Text(
                                  'บันทึกข้อมูลเรียบร้อย',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                )
                              ]);
                              Future.delayed(const Duration(milliseconds: 1500),
                                  () {
                                Get.back();
                                Get.back(result: 4);
                                Get.find<OrderController>()
                                    .fetchOrderList(4, 0);
                                Get.find<OrderController>()
                                    .fetchNotifyOrderTracking(10627, 0);
                                Get.off(() => const MyOrderHistory(),
                                    arguments: 4);
                              });
                            } else {
                              if (!Get.isSnackbarOpen) {
                                Get.snackbar('', '',
                                    titleText: Text('แจ้งเตือน',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            color: Colors.white)),
                                    messageText: Text(
                                        'เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้ง',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            color: Colors.white)),
                                    backgroundColor:
                                        Colors.red.withOpacity(0.8),
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 2));
                              }
                              return;
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: themeColorDefault,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)))),
                      child: Text(
                        'ยืนยัน',
                        style: GoogleFonts.notoSansThaiLooped(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      )),
                ),
              ],
            ),
          )),
        ),
      );
    }));
  }

  InputDecoration textStyle({required String label}) {
    return InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: themeColorDefault)),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        label: Text(label));
  }
}

bottomReasonCancel(CancelOrderReason value, int orderId, bool isCheckOut) {
  Map<int, bool> clickedReason = {};
  for (var index = 0; index < value.data.length; index++) {
    clickedReason[index] = false;
  }
  Get.bottomSheet(isScrollControlled: true, backgroundColor: Colors.white,
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: SafeArea(
          child: Stack(
        alignment: Alignment.topRight,
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'กรุณาเลือกเหตุผลในการยกเลิก',
                    style: GoogleFonts.notoSansThaiLooped(
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(
                  height: 0,
                ),
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(8),
                  color: themeColorDefault.withOpacity(0.2),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: themeColorDefault,
                            borderRadius: BorderRadius.circular(50)),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          'กรุณาเลือกเหตุผลที่คุณต้องการยกเลิกคำสั่งซื้อ สินค้าทุกชิ้นในคำสั่งซื้อนี้จะถูกยกเลิกและ ไม่สามารถแก้ไขคำขอยกเลิกได้',
                          style: GoogleFonts.notoSansThaiLooped(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(value.data.length, (index) {
                          return InkWell(
                            onTap: () {
                              clickedReason.forEach((key, value) {
                                clickedReason[key] = false;
                              });
                              clickedReason[index] = true;
                              setState(
                                () {},
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  clickedReason[index] == true
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          color: themeColorDefault,
                                        )
                                      : const Icon(
                                          Icons.radio_button_off_outlined,
                                          color: Colors.grey,
                                        ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Text(
                                      value.data[index].cancelReason.trim(),
                                      style: GoogleFonts.notoSansThaiLooped(
                                          fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: themeColorDefault,
                          elevation: 0,
                          shape: const BeveledRectangleBorder()),
                      onPressed: clickedReason.values.any((e) => e == true)
                          ? () async {
                              Get.back();
                              var cancelId = clickedReason.entries
                                  .where((entry) => entry.value)
                                  .map((entry) => entry.key)
                                  .first;
                              loadingProductStock(context);
                              await saveCancelOrderService(
                                      orderId,
                                      value.data[cancelId].cancelId,
                                      isCheckOut ? "checkout" : "")
                                  .then((res) {
                                Get.back();
                                if (res.code == '100') {
                                  dialogAlert([
                                    const Icon(
                                      Icons.shopping_cart_checkout_rounded,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    Text(
                                      res.message,
                                      style: GoogleFonts.notoSansThaiLooped(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ]);
                                  Future.delayed(
                                      const Duration(milliseconds: 1500), () {
                                    Get.back(result: 4);
                                    Get.back(result: 4);
                                    Get.back(result: 4);
                                    Get.find<OrderController>()
                                        .fetchOrderList(4, 0);
                                    Get.find<OrderController>()
                                        .fetchNotifyOrderTracking(10627, 0);
                                    Get.to(() => const MyOrderHistory(),
                                        arguments: 4);
                                  });
                                } else {
                                  dialogAlert([
                                    const Icon(
                                      Icons.notification_important_outlined,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    Text(
                                      res.message,
                                      style: GoogleFonts.notoSansThaiLooped(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ]);
                                  Future.delayed(
                                      const Duration(milliseconds: 2000), () {
                                    Get.back(result: 4);
                                    Get.back(result: 4);
                                    Get.back(result: 4);
                                    Get.find<OrderController>()
                                        .fetchOrderList(4, 0);
                                    Get.find<OrderController>()
                                        .fetchNotifyOrderTracking(10627, 0);
                                    Get.off(() => const MyOrderHistory(),
                                        arguments: 4);
                                  });
                                }
                              });
                            }
                          : null,
                      child: Text(
                        'ยกเลิกคำสั่งซื้อ',
                        style: GoogleFonts.notoSansThaiLooped(),
                      )),
                )
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.grey.shade700,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Get.back();
            },
          )
        ],
      )),
    );
  }));
}
