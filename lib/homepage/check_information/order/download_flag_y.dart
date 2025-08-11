import 'package:fridayonline/homepage/check_information/order/order_new/dowload_flag_y.dart';
// import 'package:fridayonline/homepage/check_information/order/order_orderdetail.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/check_information/check_information_controller.dart';
import '../../theme/themeimage_menu.dart';

class MslDownloadFlagY extends StatefulWidget {
  const MslDownloadFlagY({
    super.key,
    required this.dataController,
    required this.width,
    required this.height,
    required ScrollController firstController,
    required this.shopType,
  }) : _firstController = firstController;

  final CheckInformationOrderOrderAllController dataController;
  final double width;
  final double height;
  final ScrollController _firstController;
  final String shopType;

  @override
  State<MslDownloadFlagY> createState() => _MslDownloadFlagYState();
}

class _MslDownloadFlagYState extends State<MslDownloadFlagY> {
  bool isShowDiscount = false;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: ListView(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.dataController.headerStatus!,
                                style: const TextStyle(color: Colors.black)),
                            Text(widget.dataController.statusDiscription!,
                                style: const TextStyle(
                                    color: Color(0XFF20BE79),
                                    fontWeight: FontWeight.bold)),
                            Text(
                                widget.dataController.infornation_orderdetail!
                                    .repName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey)),
                            Text(
                                'รอบการขาย ${widget.dataController.ordercamp!}',
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                widget.dataController.infornation_orderdetail!
                                    .orderDate,
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 15,
                                    color: Colors.grey)),
                            Text(
                                widget.dataController.infornation_orderdetail!
                                    .repTel
                                    .replaceAllMapped(
                                        RegExp(r'(\d{3})(\d{3})(\d+)'),
                                        (Match m) => "${m[1]}-${m[2]}-${m[3]}"),
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 15,
                                    color: Colors.grey)),
                          ],
                        ),
                      )
                    ]),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: BorderDirectional(
                        bottom: BorderSide(
                      width: 2,
                      color: theme_color_df,
                    ))),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Text(
                    'รายการสินค้า',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: ListView.builder(
                  controller: widget._firstController,
                  shrinkWrap: true,
                  itemCount: widget.dataController.infornation_orderdetail!
                      .orderDetail.length,
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
                              if (widget.dataController.infornation_orderdetail!
                                      .orderDetail[index].image ==
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
                                          .infornation_orderdetail!
                                          .orderDetail[index]
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
                                          'รหัส ${widget.dataController.infornation_orderdetail!.orderDetail[index].billCode}'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        widget
                                            .dataController
                                            .infornation_orderdetail!
                                            .orderDetail[index]
                                            .billDesc,
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
                                        '${NumberFormat.decimalPattern().format(widget.dataController.infornation_orderdetail!.orderDetail[index].amount)} บาท',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 9,
                                      ),
                                      Text(
                                          'x${widget.dataController.infornation_orderdetail!.orderDetail[index].qtyConfirm}',
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
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ค่าจัดส่ง'),
                        Text(
                          "${myFormat.format(widget.dataController.infornation_orderdetail!.shipFee)} บาท",
                          style: const TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('ส่วนลดทั้งหมด'),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isShowDiscount = !isShowDiscount;
                                });
                              },
                              child: isShowDiscount
                                  ? Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: theme_red,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          size: 20,
                                          color: Colors.white,
                                          Icons.arrow_drop_up_rounded,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: theme_red,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          size: 20,
                                          color: Colors.white,
                                          Icons.arrow_drop_down_rounded,
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                        Text(
                          "- ${myFormat.format(widget.dataController.infornation_orderdetail!.discount.fold(0, (sum, item) => sum + item.price) + widget.dataController.infornation_orderdetail!.pointDiscount)} บาท",
                          style: TextStyle(color: theme_red),
                        )
                      ],
                    ),
                    if (isShowDiscount &&
                        widget.dataController.infornation_orderdetail!
                                .pointDiscount >
                            0)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme_color_df.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('ส่วนลด BW Point'),
                            Text(
                              "${myFormat.format(widget.dataController.infornation_orderdetail!.pointDiscount)} บาท",
                              style: TextStyle(color: theme_red),
                            )
                          ],
                        ),
                      ),
                    if (isShowDiscount)
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: widget.dataController
                            .infornation_orderdetail!.discount.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme_color_df.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget
                                        .dataController
                                        .infornation_orderdetail!
                                        .discount[index]
                                        .name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  width: 18,
                                ),
                                Text(
                                  '${myFormat.format(widget.dataController.infornation_orderdetail!.discount[index].price)} บาท',
                                  style: TextStyle(color: theme_red),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'รวมเป็นเงิน',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            )
                          ],
                        ),
                        Text(
                          "${myFormat.format(widget.dataController.infornation_orderdetail!.totalAmount)} บาท",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '*ข้อมูลอาจมีการเปลี่ยนแปลง',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: theme_red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              widget.dataController.infornation_orderdetail!.cancelFlag
                  ? Container(
                      width: Get.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              side: BorderSide(
                                  width: 2, color: Colors.grey.shade700),
                              backgroundColor: Colors.white),
                          onPressed: () {
                            reasonBottomSheet(
                                context,
                                widget.dataController.infornation_orderdetail!
                                    .orderId,
                                widget.shopType,
                                "");
                          },
                          child: Text(
                            'ยกเลิกคำสั่งซื้อ',
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}

class EnduserDownloadFlagY extends StatefulWidget {
  const EnduserDownloadFlagY({
    super.key,
    required this.dataController,
    required this.width,
    required this.height,
    required ScrollController firstController,
  }) : _firstController = firstController;

  final CheckInformationOrderOrderAllController dataController;
  final double width;
  final double height;
  final ScrollController _firstController;

  @override
  State<EnduserDownloadFlagY> createState() => _EnduserDownloadFlagYState();
}

class _EnduserDownloadFlagYState extends State<EnduserDownloadFlagY> {
  bool isShowDiscount = false;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: ListView(
        children: [
          Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.dataController.headerStatus!,
                            style: const TextStyle(color: Colors.black)),
                        Text(widget.dataController.statusDiscription!,
                            style: widget.dataController.statusOrder! == 'N'
                                ? const TextStyle(color: Colors.orange)
                                : const TextStyle(
                                    color: Color(0XFF20BE79),
                                  )),
                        Text(widget.dataController.name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey)),
                        Text('รอบการขาย ${widget.dataController.ordercamp!}',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(''),
                        Text(
                          widget.dataController.orderDate!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.phone,
                              size: 14,
                              color: Colors.amber.shade700,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () async {
                                final Uri launchUri = Uri(
                                  scheme: 'tel',
                                  path: widget.dataController.userTel,
                                );
                                if (await canLaunchUrl(launchUri)) {
                                  // print('ok');
                                  await launchUrl(launchUri);
                                }
                              },
                              child: Text(
                                  widget.dataController.userTel!
                                      .replaceAllMapped(
                                          RegExp(r'(\d{3})(\d{3})(\d+)'),
                                          (Match m) =>
                                              "${m[1]}-${m[2]}-${m[3]}"),
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      height: 2,
                                      fontSize: 13,
                                      color: Colors.amber.shade700)),
                            ),
                          ],
                        ),
                        Text(
                          widget.dataController.recieveType!,
                          style:
                              const TextStyle(height: 1.5, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: BorderDirectional(
                        bottom: BorderSide(
                      width: 2,
                      color: theme_color_df,
                    ))),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Text(
                    'รายการสินค้า',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              // if (1 < 0)
              Container(
                color: Colors.white,
                child: ListView.builder(
                  controller: widget._firstController,
                  shrinkWrap: true,
                  itemCount: widget.dataController
                      .infornation_orderdetail_enduser!.orderDetail.length,
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
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                        .infornation_orderdetail_enduser!
                                        .orderDetail[index]
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
                                          "รหัส ${widget.dataController.infornation_orderdetail_enduser!.orderDetail[index].billCode}"),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        widget
                                            .dataController
                                            .infornation_orderdetail_enduser!
                                            .orderDetail[index]
                                            .billDesc,
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
                                        '${NumberFormat.decimalPattern().format(widget.dataController.infornation_orderdetail_enduser!.orderDetail[index].amount)} บาท',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                          'x${widget.dataController.infornation_orderdetail_enduser!.orderDetail[index].qtyConfirm}',
                                          style: TextStyle(
                                              color: theme_color_df,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.dataController.recieveType ==
                        "รับสินค้าเอง (COD)")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ค่าจัดส่ง'),
                          Text(
                              "${myFormat.format(widget.dataController.infornation_orderdetail_enduser!.shipFee)} บาท")
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('ส่วนลดทั้งหมด'),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isShowDiscount = !isShowDiscount;
                                });
                              },
                              child: isShowDiscount
                                  ? Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: theme_red,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          size: 20,
                                          color: Colors.white,
                                          Icons.arrow_drop_up_rounded,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: theme_red,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          size: 20,
                                          color: Colors.white,
                                          Icons.arrow_drop_down_rounded,
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                        Text(
                          "- ${myFormat.format(widget.dataController.infornation_orderdetail_enduser!.pointDiscount + widget.dataController.infornation_orderdetail_enduser!.couponDiscount)} บาท",
                          style: TextStyle(color: theme_red),
                        )
                      ],
                    ),
                    if (isShowDiscount &&
                        widget.dataController.infornation_orderdetail_enduser!
                                .pointDiscount >
                            0)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme_color_df.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('ส่วนลด Star Reward'),
                            Text(
                              "${myFormat.format(widget.dataController.infornation_orderdetail_enduser!.pointDiscount)} บาท",
                              style: TextStyle(color: theme_red),
                            )
                          ],
                        ),
                      ),
                    if (isShowDiscount &&
                        widget.dataController.infornation_orderdetail_enduser!
                                .couponDiscount >
                            0)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme_color_df.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('ส่วนลดคูปอง'),
                            Text(
                              "- ${myFormat.format(widget.dataController.infornation_orderdetail_enduser!.couponDiscount)} บาท",
                              style: TextStyle(color: theme_red),
                            )
                          ],
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'รวมเป็นเงิน',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            )
                          ],
                        ),
                        Text(
                          "${widget.dataController.totalAmount!} บาท",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '*ข้อมูลอาจมีการเปลี่ยนแปลง',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: theme_red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              widget.dataController.infornation_orderdetail_enduser!.cancelFlag
                  ? Container(
                      width: Get.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              side: BorderSide(
                                  width: 2, color: Colors.grey.shade700),
                              backgroundColor: Colors.white),
                          onPressed: () {
                            reasonBottomSheet(
                                context,
                                widget.dataController
                                    .infornation_orderdetail_enduser!.orderId,
                                widget.dataController.shopType.toString(),
                                "");
                          },
                          child: Text(
                            'ยกเลิกคำสั่งซื้อ',
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
