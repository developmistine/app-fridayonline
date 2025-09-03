import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/myorder.ctr.dart';
import 'package:fridayonline/member/controller/order.ctr.dart';
import 'package:fridayonline/member/controller/review.ctr.dart';
import 'package:fridayonline/member/models/orders/orderlist.model.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(cart)/cart.sumary.dart';
import 'package:fridayonline/member/views/(order)/order.checkout.dart';
import 'package:fridayonline/member/views/(order)/order.detail.dart';
import 'package:fridayonline/member/views/(profile)/edit.rating.dart';
import 'package:fridayonline/member/views/(profile)/myreview.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fridayonline/member/models/orders/orderlist.checkout.model.dart'
    as checkout;
import 'package:google_fonts/google_fonts.dart';

final orderCtr = Get.find<OrderController>();

class OrderHistoryCard extends StatefulWidget {
  final List<Datum> data;
  final Function(dynamic index) setTab;
  final int indexTab;

  const OrderHistoryCard(
      {super.key,
      required this.data,
      required this.setTab,
      required this.indexTab});

  @override
  State<OrderHistoryCard> createState() => _OrderHistoryCardState();
}

class _OrderHistoryCardState extends State<OrderHistoryCard>
    with SingleTickerProviderStateMixin {
  final OrderHistoryController controller = Get.put(OrderHistoryController());

  List<Widget> _getStatusButtons(String status, index) {
    switch (status) {
      case 'สำเร็จ':
        {
          return [
            if (widget.data[index].reviewStatus == 1)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColorDefault,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
                onPressed: () {
                  // Get.to(() => const MyReview());
                  Get.find<MyReviewCtr>()
                      .fetchPendingReview(widget.data[index].orderId);
                  Get.to(() => const EditRating());
                },
                child: const Text(
                  'ให้คะแนน',
                  style: TextStyle(fontSize: 14),
                ),
              )
            else if (widget.data[index].reviewStatus == 2)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColorDefault,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
                onPressed: () {
                  Get.find<MyReviewCtr>()
                      .fetchReviewed(widget.data[index].orderId);
                  Get.to(() => const MyReview());
                },
                child: const Text(
                  'ดูคะแนน',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            const SizedBox(
              width: 8,
            ),
            buttonDetail('other', index)
          ];
        }
      default:
        {
          return [buttonDetail('other', index)];
        }
    }
  }

  ElevatedButton buttonDetail(String page, int index) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Colors.grey.shade700,
              width: 1,
            ),
          ),
        ),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
      ),
      onPressed: () async {
        if (page == 'checkout') {
          orderCtr.fetchOrderDetailCheckOut(widget.data[index].orderId);
          await Get.to(() => const OrderCheckout());
        } else {
          orderCtr.fetchOrderDetail(widget.data[index].orderId);
          var res = await Get.to(() => MyOrderDetail(
                tab: widget.indexTab,
              ));
          if (res != null) {
            widget.setTab(4);
          }
        }
      },
      child: const Text(
        'ดูรายละเอียด',
        style: TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }

  Color _getStatusColor(String status) {
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

  final ScrollController _scrollController = ScrollController();

  int offset = 20;

  @override
  void initState() {
    super.initState();
    // ตรวจสอบการเลื่อนถึงท้ายรายการ
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !orderCtr.isLoadingMoreOrderList.value) {
        fetMoreOrder();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    orderCtr.resetOrderList();
    _scrollController.dispose();
    offset = 20;
  }

  void fetMoreOrder() async {
    orderCtr.isLoadingMoreOrderList.value = true;
    try {
      final newsOrder = await orderCtr.fetchMoreOrderList(offset);

      if (newsOrder!.data.isNotEmpty) {
        orderCtr.orderList!.data.addAll(newsOrder.data);
        offset += 20;
      }
    } finally {
      orderCtr.isLoadingMoreOrderList.value = false; // จบการโหลดข้อมูล
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/order/zero_order.png',
            width: 150,
          ),
          const Text('ไม่พบข้อมูลการสั่งซื้อ'),
        ],
      );
    }
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: widget.data.length +
                (orderCtr.isLoadingMoreOrderList.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == widget.data.length && orderCtr.isLoadingMore.value) {
                // แสดง loader เมื่อมีการโหลดข้อมูลเพิ่มเติม
                return const SizedBox.shrink();
              }
              return InkWell(
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                splashColor: Colors.transparent,
                onTap: () async {
                  orderCtr.fetchOrderDetail(widget.data[index].orderId);
                  var res = await Get.to(() => MyOrderDetail(
                        tab: widget.indexTab,
                      ));
                  if (res != null) {
                    widget.setTab(4);
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadowColor: Colors.grey[100],
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Get.find<BrandCtr>().fetchShopData(
                                          widget.data[index].shopInfo.shopId);
                                      // Get.to(() => const BrandStore());
                                      Get.toNamed(
                                          '/BrandStore/${widget.data[index].shopInfo.shopId}');
                                    },
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          child: CachedNetworkImage(
                                            imageUrl: widget
                                                .data[index].shopInfo.icon,
                                            width: 18,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          widget.data[index].shopInfo.shopName,
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
                                ),
                                Text(
                                  widget.data[index].orderStatus.description,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: _getStatusColor(widget
                                          .data[index].orderStatus.colorCode
                                          .toLowerCase())),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: widget.data[index].itemGroups.length,
                            itemBuilder: (context, subIndex) {
                              var group =
                                  widget.data[index].itemGroups[subIndex];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 0.4),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: group.image,
                                        width: 76,
                                        height: 82,
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            height: 82,
                                            width: 82,
                                            color: Colors.grey.shade100,
                                            child: const Icon(Icons
                                                .image_not_supported_rounded),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              group.productName,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  group.itemName,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  "x ${group.amount}",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  widget.indexTab == 5
                                                      ? Text(
                                                          '฿${myFormat.format(group.refundAmountPerItem)}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        )
                                                      : Text(
                                                          '฿${myFormat.format(group.price)}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  if (group.haveDisCount)
                                                    Text(
                                                      '฿${myFormat.format(group.priceBeforeDiscount)}',
                                                      style: TextStyle(
                                                          height: 2,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          color: Colors
                                                              .grey.shade400,
                                                          fontSize: 13),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'สินค้ารวม ${widget.data[index].summary.productCount} รายการ: ฿${myFormat.format(widget.data[index].summary.finalTotal)}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: _getStatusButtons(
                                  widget.data[index].orderStatus.description,
                                  index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Obx(() {
            if (orderCtr.isLoadingMoreOrderList.value) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Text(
                  'กำลังโหลด...',
                  style: TextStyle(color: themeColorDefault),
                ),
              );
            }
            return const SizedBox();
          })
        ],
      ),
    );
  }
}

// ?  check out
class OrderHistoryCheckOutCard extends StatefulWidget {
  final List<checkout.Datum> data;
  final Function(dynamic index) setTab;
  final int indexTab;

  const OrderHistoryCheckOutCard(
      {super.key,
      required this.data,
      required this.setTab,
      required this.indexTab});

  @override
  State<OrderHistoryCheckOutCard> createState() =>
      _OrderHistoryCheckOutCardState();
}

class _OrderHistoryCheckOutCardState extends State<OrderHistoryCheckOutCard>
    with SingleTickerProviderStateMixin {
  final OrderHistoryController controller = Get.put(OrderHistoryController());

  ElevatedButton buttonDetail(int index) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Colors.grey.shade700,
              width: 1,
            ),
          ),
        ),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
      ),
      onPressed: () async {
        orderCtr.fetchOrderDetailCheckOut(widget.data[index].orderId);
        await Get.to(() => const OrderCheckout());
      },
      child: const Text(
        'ดูรายละเอียด',
        style: TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }

  Color _getStatusColor(String status) {
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

  final ScrollController _scrollController = ScrollController();

  int offset = 20;

  @override
  void initState() {
    super.initState();
    // ตรวจสอบการเลื่อนถึงท้ายรายการ
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !orderCtr.isLoadingMoreOrderList.value) {
        fetMoreOrder();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    orderCtr.resetOrderList();
    _scrollController.dispose();
    offset = 20;
  }

  void fetMoreOrder() async {
    orderCtr.isLoadingMoreOrderList.value = true;
    try {
      final newsOrder = await orderCtr.fetchMoreOrderListCheckOut(offset);

      if (newsOrder!.data.isNotEmpty) {
        orderCtr.orderListCheckOut!.data.addAll(newsOrder.data);
        offset += 20;
      }
    } finally {
      orderCtr.isLoadingMoreOrderList.value = false; // จบการโหลดข้อมูล
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/order/zero_order.png',
            width: 150,
          ),
          const Text('ไม่พบข้อมูลการสั่งซื้อ'),
        ],
      );
    }
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: widget.data.length +
                (orderCtr.isLoadingMoreOrderList.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == widget.data.length && orderCtr.isLoadingMore.value) {
                // แสดง loader เมื่อมีการโหลดข้อมูลเพิ่มเติม
                return const SizedBox.shrink();
              }
              return InkWell(
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                splashColor: Colors.transparent,
                onTap: () async {
                  orderCtr.fetchOrderDetailCheckOut(widget.data[index].orderId);
                  await Get.to(() => const OrderCheckout());
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadowColor: Colors.grey[100],
                  child: Column(
                    children: [
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: widget.data[index].shopList.length,
                          itemBuilder: (context, shopIndex) {
                            var shopList =
                                widget.data[index].shopList[shopIndex];
                            return ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Get.find<BrandCtr>().fetchShopData(
                                                shopList.shopInfo.shopId);
                                            // Get.to(() => const BrandStore());
                                            Get.toNamed(
                                                '/BrandStore/${shopList.shopInfo.shopId}');
                                          },
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      shopList.shopInfo.icon,
                                                  width: 18,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                shopList.shopInfo.shopName,
                                                style:
                                                    GoogleFonts.ibmPlexSansThai(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w900),
                                              ),
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 4.0),
                                                child: Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size: 14,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        widget.data[index].orderStatus
                                            .description,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: _getStatusColor(widget
                                                .data[index]
                                                .orderStatus
                                                .colorCode
                                                .toLowerCase())),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: shopList.itemGroups.length,
                                    itemBuilder: (context, itemIndex) {
                                      var group =
                                          shopList.itemGroups[itemIndex];
                                      return Column(
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 0.4),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: CachedNetworkImage(
                                                    imageUrl: group.image,
                                                    width: 76,
                                                    height: 82,
                                                    fit: BoxFit.cover,
                                                    errorWidget:
                                                        (context, url, error) {
                                                      return Container(
                                                        height: 82,
                                                        width: 82,
                                                        color: Colors
                                                            .grey.shade100,
                                                        child: const Icon(Icons
                                                            .image_not_supported_rounded),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        group.productName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            group.itemName,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            "x ${group.amount}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              '฿${myFormat.format(group.price)}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                            if (group
                                                                .haveDiscount)
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                            if (group
                                                                .haveDiscount)
                                                              Text(
                                                                '฿${myFormat.format(group.priceBeforeDiscount)}',
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Divider(
                                    height: 0,
                                  )
                                ],
                              ),
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'สินค้ารวม  ${widget.data[index].summary.productCount} รายการ',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'จำนวนเงินที่ต้องชำระ',
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "฿${myFormat.format(widget.data[index].summary.finalTotal)}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: themeColorDefault),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                buttonDetail(index),
                                const SizedBox(
                                  width: 4,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      SetData data = SetData();
                                      var custId = await data.b2cCustID;
                                      final paymentType = widget.data[index]
                                          .paymentMethod.paymentChannelName
                                          .toLowerCase();
                                      final url = getPaymentUrl(
                                          paymentType,
                                          custId,
                                          widget.data[index].orderId,
                                          await data.accessToken);
                                      if (url != null) {
                                        await handlePaymentNavigation(url);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: themeColorDefault),
                                    child: const Text('ชำระเงินทันที'))
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Obx(() {
            if (orderCtr.isLoadingMoreOrderList.value) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Text(
                  'กำลังโหลด...',
                  style: TextStyle(color: themeColorDefault),
                ),
              );
            }
            return const SizedBox();
          })
        ],
      ),
    );
  }
}
