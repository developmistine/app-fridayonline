import 'package:fridayonline/homepage/check_information/delivery_status/delivery_status_tacking_b2c.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controller/check_information/check_information_controller.dart';

class DeliveryMslDownloadFlagYB2C extends StatefulWidget {
  const DeliveryMslDownloadFlagYB2C({
    super.key,
    required this.dataController,
    required this.width,
    required this.height,
    required ScrollController firstController,
  }) : _firstController = firstController;

  final CheckInformationDeliveryStatusController dataController;
  final double width;
  final double height;
  final ScrollController _firstController;

  @override
  State<DeliveryMslDownloadFlagYB2C> createState() =>
      _DeliveryMslDownloadFlagYB2CState();
}

class _DeliveryMslDownloadFlagYB2CState
    extends State<DeliveryMslDownloadFlagYB2C> {
  bool isShowDiscount = false;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget
                              .dataController.delivery_orderdetail_b2c!.repName,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          widget.dataController.delivery_orderdetail_b2c!
                              .orderStatus.description,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget
                                          .dataController
                                          .delivery_orderdetail_b2c!
                                          .orderStatus
                                          .colorCode ==
                                      "R"
                                  ? Colors.red
                                  : widget
                                              .dataController
                                              .delivery_orderdetail_b2c!
                                              .orderStatus
                                              .colorCode ==
                                          "G"
                                      ? Colors.green
                                      : widget
                                                  .dataController
                                                  .delivery_orderdetail_b2c!
                                                  .orderStatus
                                                  .colorCode ==
                                              "Y"
                                          ? Colors.yellow
                                          : Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        const Text(
                          'วันที่สั่งซื้อ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: Text(
                            widget.dataController.delivery_orderdetail_b2c!
                                .orderDate,
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ที่อยู่จัดส่ง',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: Text(
                            widget.dataController.delivery_orderdetail_b2c!
                                .address.shippingAddress,
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'เบอร์โทร',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(
                          width: 38,
                        ),
                        Expanded(
                          child: Text(
                            widget.dataController.delivery_orderdetail_b2c!
                                .address.shippingPhone
                                .replaceAllMapped(
                                    RegExp(r'(\d{3})(\d{3})(\d+)'),
                                    (Match m) => "${m[1]}-${m[2]}-${m[3]}"),
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: Get.width,
                decoration: const BoxDecoration(
                  color: Color(0XFFC3EAFF),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text(
                    widget.dataController.delivery_orderdetail_b2c!.shippingInfo
                                .trackingNo !=
                            ""
                        ? 'สถานะการจัดส่ง'
                        : 'รายการสินค้า',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              if (widget.dataController.delivery_orderdetail_b2c!.shippingInfo
                      .trackingNo !=
                  "")
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DeliveryStatusTrackingB2C(
                                    url: widget
                                        .dataController
                                        .delivery_orderdetail_b2c!
                                        .shippingInfo
                                        .trackingUrl,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: theme_color_df,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                textStyle: const TextStyle(
                                    fontSize: 15, fontFamily: 'notoreg')),
                            child: const Text(
                              'รายละเอียดการจัดส่ง',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'หมายเลขติดตามพัสดุ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            widget.dataController.delivery_orderdetail_b2c!
                                .shippingInfo.trackingNo,
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ขนส่งผู้ให้บริการ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            widget.dataController.delivery_orderdetail_b2c!
                                .shippingInfo.carrier,
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              Container(
                color: Colors.white,
                child: ListView.builder(
                  controller: widget._firstController,
                  shrinkWrap: true,
                  itemCount: widget.dataController.delivery_orderdetail_b2c!
                      .itemGroups.length,
                  itemBuilder: (context, index) {
                    return Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 0.5,
                                color: Color.fromARGB(255, 224, 224, 224)),
                          ), // Set border width
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget
                                      .dataController
                                      .delivery_orderdetail_b2c!
                                      .itemGroups[index]
                                      .image ==
                                  '')
                                Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.all(12),
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      child: Image.asset(imageError)),
                                )
                              else
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 0.5)),
                                    child: CachedNetworkImage(
                                      imageUrl: widget
                                          .dataController
                                          .delivery_orderdetail_b2c!
                                          .itemGroups[index]
                                          .image,
                                      width: ((widget.width - 32.0) / 2) / 2,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'รหัส ${widget.dataController.delivery_orderdetail_b2c!.itemGroups[index].billCode}'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        widget
                                            .dataController
                                            .delivery_orderdetail_b2c!
                                            .itemGroups[index]
                                            .billName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${NumberFormat.decimalPattern().format(widget.dataController.delivery_orderdetail_b2c!.itemGroups[index].price * widget.dataController.delivery_orderdetail_b2c!.itemGroups[index].amount)} บาท',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                          'x${widget.dataController.delivery_orderdetail_b2c!.itemGroups[index].amount}',
                                          style: TextStyle(
                                              color: theme_color_df,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(widget.dataController.delivery_orderdetail_b2c!
                        .paymentInfo.paymentMethod.paymentChannelName),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'สรุป',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    for (var i = 0;
                        i <
                            widget.dataController.delivery_orderdetail_b2c!
                                .paymentInfo.info.length;
                        i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.dataController.delivery_orderdetail_b2c!
                              .paymentInfo.info[i].text),
                          Text(
                            "${myFormat.format(widget.dataController.delivery_orderdetail_b2c!.paymentInfo.info[i].value)} บาท",
                            style: const TextStyle(color: Colors.black),
                          )
                        ],
                      ),
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
