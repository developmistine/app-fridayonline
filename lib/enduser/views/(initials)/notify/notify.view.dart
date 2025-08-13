import 'package:appfridayecommerce/enduser/components/notify/notify.order.list.dart';
import 'package:appfridayecommerce/enduser/controller/notify.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/order.ctr.dart';
import 'package:appfridayecommerce/enduser/views/(initials)/notify/notify.list.dart';
import 'package:appfridayecommerce/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/notify/order.notify.service.dart';

class EndUserNotify extends StatefulWidget {
  const EndUserNotify({super.key});

  @override
  State<EndUserNotify> createState() => _EndUserNotifyState();
}

class _EndUserNotifyState extends State<EndUserNotify> {
  final notifyOrder = Get.find<OrderController>();
  final notifyCtr = Get.find<NotifyController>();
  final ScrollController _scrollController = ScrollController();

  int offset = 20;

  @override
  void initState() {
    super.initState();
    // ตรวจสอบการเลื่อนถึงท้ายรายการ
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchMoreProductContent();
      }
    });
  }

  setResetOffset(number) {
    setState(() {
      offset = number;
    });
  }

  void fetchMoreProductContent() async {
    notifyOrder.isLoadingMore.value = true;

    try {
      // ดึงข้อมูลใหม่จาก API
      final newData = await notifyOrder.fetchMoreNotify(offset);

      if (newData!.data.isNotEmpty) {
        notifyOrder.orderTracking!.data.addAll(newData.data);
        offset += 20;
      }
    } finally {
      notifyOrder.isLoadingMore.value = false;
    }
  }

  @override
  void dispose() {
    offset = 20;
    super.dispose();
    _scrollController.dispose();
    notifyOrder.resetOrderNotify();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.amber,
      onRefresh: () async {
        notifyOrder.fetchNotifyOrderTracking(10627, 0);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: SizedBox(
            height: Get.height,
            child: Obx(() {
              if (notifyOrder.isLoadingNotifyOrder.value ||
                  notifyCtr.isLoadingNotifyGroup.value) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              if (notifyOrder.orderTracking!.data.isEmpty &&
                  notifyCtr.notifyGroup!.data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/home/zero_noti.png',
                          width: 150),
                      const Text(
                        "ไม่พบข้อมูลคำสั่งซื้อ",
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.only(top: 8),
                        itemCount: notifyCtr.notifyGroup!.data.length,
                        itemBuilder: (context, index) {
                          var items = notifyCtr.notifyGroup!.data[index];
                          return InkWell(
                            onTap: () async {
                              notifyCtr.fetchNotify(items.groupId, 0);
                              await Get.to(
                                      () => NotifyList(title: items.title))!
                                  .then((value) async {
                                if (items.totalNotifications > 0) {
                                  loadingProductStock(context);
                                  await readStatusNotifyService(items.groupId)
                                      .then((_) {
                                    Get.back();
                                  });
                                }
                                notifyCtr.fetchNotifyGroup();
                                notifyCtr.fetchCountNotify();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade100))),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: items.image,
                                        width: 35,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          items.title,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          items.subTitle,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (items.totalNotifications > 0)
                                    Container(
                                      width: 18,
                                      height: 18,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                      child: Text(
                                        items.totalNotifications.toString(),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.notoSansThaiLooped(
                                            fontSize: 11,
                                            color: Colors.white,
                                            height: 1),
                                      ),
                                    ),
                                  SizedBox(
                                    width: 20,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.grey.shade600,
                                      size: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      if (notifyOrder.orderTracking!.data.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: orderNotiList(setOffset: setResetOffset),
                        ),
                      Obx(() {
                        if (!notifyOrder.isLoadingMore.value) {
                          return const SizedBox();
                        }
                        return Text(
                          'กำลังโหลด...',
                          style: TextStyle(color: themeColorDefault),
                        );
                      }),
                      const SizedBox(
                        height: 210,
                      )
                    ],
                  ));
            }),
          ),
        ),
      ),
    );
  }
}
