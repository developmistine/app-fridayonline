import 'package:fridayonline/controller/return_product_controller.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/theme/themeimage_menu.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../pageactivity/cart/cart_theme/cart_all_theme.dart';

class ReturnProductHistory extends StatefulWidget {
  const ReturnProductHistory({super.key});

  @override
  State<ReturnProductHistory> createState() => _ReturnProductHistoryState();
}

class _ReturnProductHistoryState extends State<ReturnProductHistory> {
  @override
  void initState() {
    super.initState();
  }

  bool showList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleMaster('ประวัติแจ้งคืนสินค้า'),
      body: GetX<ReturnProductController>(builder: (ctl) {
        return ctl.isDataLoading.value
            ? Center(child: theme_loading_df)
            : ListView(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 80),
                    padding: const EdgeInsets.only(bottom: 18),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TimelineTile(
                            axis: TimelineAxis.horizontal,
                            alignment: TimelineAlign.center,
                            isFirst: true,
                            indicatorStyle: IndicatorStyle(
                              height: 30,
                              color: theme_color_df,
                              iconStyle: IconStyle(
                                  iconData: Icons.check,
                                  fontSize: 28,
                                  color: Colors.white),
                            ),
                            beforeLineStyle: LineStyle(
                              color: Colors.cyan.shade200,
                              thickness: 3,
                            ),
                            endChild: Container(
                              padding: const EdgeInsets.all(0),
                              child: const Center(
                                  child: Text(
                                'แจ้งคืน',
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TimelineTile(
                            axis: TimelineAxis.horizontal,
                            alignment: TimelineAlign.center,
                            beforeLineStyle: LineStyle(
                              color: Colors.cyan.shade200,
                              thickness: 3,
                            ),
                            afterLineStyle: LineStyle(
                              color: theme_grey_bg,
                              thickness: 3,
                            ),
                            indicatorStyle: IndicatorStyle(
                              height: 30,
                              color: Colors.cyan.shade200,
                            ),
                            endChild: Container(
                              padding: const EdgeInsets.all(0),
                              child: const Center(
                                  child: Text(
                                'ตรวจสอบ',
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TimelineTile(
                            axis: TimelineAxis.horizontal,
                            alignment: TimelineAlign.center,
                            beforeLineStyle: LineStyle(
                              color: theme_grey_bg,
                              thickness: 3,
                            ),
                            afterLineStyle: LineStyle(
                              color: theme_grey_bg,
                              thickness: 3,
                            ),
                            indicatorStyle: IndicatorStyle(
                              height: 30,
                              color: theme_grey_bg,
                            ),
                            endChild: Container(
                              padding: const EdgeInsets.all(0),
                              child: const Center(
                                  child: Text(
                                'คืนเงิน',
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TimelineTile(
                            axis: TimelineAxis.horizontal,
                            alignment: TimelineAlign.center,
                            isLast: true,
                            beforeLineStyle: LineStyle(
                              color: theme_grey_bg,
                              thickness: 3,
                            ),
                            indicatorStyle: IndicatorStyle(
                              iconStyle: IconStyle(
                                  iconData: Icons.close,
                                  fontSize: 28,
                                  color: Colors.white),
                              height: 30,
                              width: 30,
                              color: Colors.red,
                            ),
                            endChild: Container(
                              padding: const EdgeInsets.all(0),
                              child: const Center(
                                  child: Text(
                                'ขนส่งเข้ารับ',
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // สถานะ
                  Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'สถานะ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ':',
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'อนุมัติคำร้องขอคืนสินค้า',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const Text(
                                'ระบบจะทำการคืนเงินให้ท่านภายใน 1-2 วัน'),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'วันที่แจ้ง',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade700),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        ':',
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        ctl.historyReturnBySeq!.campDate,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'ช่องทางสั่งซื้อ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade700),
                                  ),
                                ),
                                const Expanded(
                                  flex: 2,
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ':',
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'BW Order',
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // รายการสินค้า
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Text(
                          'รายการสินค้าขอคืน ${ctl.historyReturnBySeq!.creDate}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1.2,
                        color: theme_red,
                      ),
                      !showList
                          ? Container(
                              color: const Color.fromRGBO(255, 246, 244, 1),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      // flex: 4,
                                      child: Row(
                                    children: [
                                      if (ctl.historyReturnBySeq!.productDetail
                                              .length >
                                          2)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 5),
                                          child: ctl
                                                  .historyReturnBySeq!
                                                  .productDetail[0]
                                                  .image
                                                  .isEmpty
                                              ? Image.asset(
                                                  imageError,
                                                  width: 80,
                                                  height: 80,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: ctl
                                                      .historyReturnBySeq!
                                                      .productDetail[0]
                                                      .image,
                                                  width: 80,
                                                  height: 80),
                                        ),
                                      if (ctl.historyReturnBySeq!.productDetail
                                              .length >=
                                          2)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 5),
                                          child: ctl
                                                  .historyReturnBySeq!
                                                  .productDetail[1]
                                                  .image
                                                  .isEmpty
                                              ? Image.asset(
                                                  imageError,
                                                  width: 80,
                                                  height: 80,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: ctl
                                                      .historyReturnBySeq!
                                                      .productDetail[1]
                                                      .image,
                                                  width: 80,
                                                  height: 80),
                                        ),
                                      if (ctl.historyReturnBySeq!.productDetail
                                              .length >
                                          2)
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 5),
                                            child: Text(
                                              '+ ${ctl.historyReturnBySeq!.productDetail.length - 2}',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ))
                                      else
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 5),
                                          child: ctl
                                                  .historyReturnBySeq!
                                                  .productDetail[0]
                                                  .image
                                                  .isEmpty
                                              ? Image.asset(
                                                  imageError,
                                                  width: 80,
                                                  height: 80,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: ctl
                                                      .historyReturnBySeq!
                                                      .productDetail[0]
                                                      .image,
                                                  width: 80,
                                                  height: 80),
                                        ),
                                    ],
                                  )),
                                  // Spacer(),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showList = !showList;
                                      });
                                    },
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 50,
                                      color: Colors.grey.shade500,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                // animation container

                                Container(
                                  color: const Color.fromRGBO(255, 246, 244, 1),
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemCount: ctl.historyReturnBySeq!
                                        .productDetail.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 18, horizontal: 20),
                                        child: Row(
                                          children: [
                                            if (ctl
                                                .historyReturnBySeq!
                                                .productDetail[index]
                                                .image
                                                .isEmpty)
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 18.0),
                                                  child: Image.asset(
                                                    imageError,
                                                    width: 80,
                                                    height: 80,
                                                  ),
                                                ),
                                              )
                                            else
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 18.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: ctl
                                                        .historyReturnBySeq!
                                                        .productDetail[index]
                                                        .image,
                                                    width: 80,
                                                    height: 80,
                                                  ),
                                                ),
                                              ),
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'รหัส ${ctl.historyReturnBySeq!.productDetail[index].billcode}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      ctl
                                                          .historyReturnBySeq!
                                                          .productDetail[index]
                                                          .billdesc,
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'จำนวน ${ctl.historyReturnBySeq!.productDetail[index].qty} ชิ้น',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        'ราคา ${ctl.historyReturnBySeq!.productDetail[index].price} บาท ฿',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(
                                      height: 1,
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.grey.shade300,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  child: Row(children: [
                                    const Expanded(
                                      child: Divider(
                                        height: 1,
                                        thickness: 1.2,
                                        color: Colors.black,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          showList = !showList;
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'ดูย่อลง',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            Icon(Icons
                                                .keyboard_arrow_up_rounded),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: Divider(
                                        height: 1,
                                        thickness: 1.2,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ]),
                                )
                              ],
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'เหตุผล',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            ctl.historyReturnBySeq!.reasonAll.reason,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ยอดคืนเงิน',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text('(${ctl.historyReturnBySeq!.totalAll})')
                          ],
                        ),
                        Text(
                          '${ctl.historyReturnBySeq!.amount} บาท',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              );
      }),
    );
  }
}

class ProcessCard {
  String description;
  IconData icon;

  ProcessCard(this.description, this.icon);
}
