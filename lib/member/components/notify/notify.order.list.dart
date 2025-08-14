import 'package:fridayonline/member/controller/order.ctr.dart';
import 'package:fridayonline/member/services/notify/order.notify.service.dart';
import 'package:fridayonline/member/views/(order)/order.checkout.dart';
import 'package:fridayonline/member/views/(order)/order.detail.dart';
import 'package:fridayonline/member/widgets/dialog.confirm.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget orderNotiList({required Function(dynamic number) setOffset}) {
  final notifyOrder = Get.find<OrderController>();
  return Obx(() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'อัพเดตคำสั่งซื้อ',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              GestureDetector(
                onTap: () {
                  dialogConfirm('คุณต้องการทำเครื่องหมายว่าอ่านทั้งหมดหรือไม่?',
                          'ยกเลิก', 'ตกลง')
                      .then((res) async {
                    if (res == 1) {
                      await fetchNotifyReadService(0, true).then((value) {
                        notifyOrder.fetchNotifyOrderTracking(10627, 0);
                      });
                    }
                  });
                },
                child: Text(
                  'อ่านทั้งหมด',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: notifyOrder.orderTracking!.data.length +
              (notifyOrder.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == notifyOrder.orderTracking!.data.length &&
                notifyOrder.isLoadingMore.value) {
              return const SizedBox.shrink();
            }
            var data = notifyOrder.orderTracking!.data[index];
            return InkWell(
              onTap: () async {
                if (data.isRead == false) {
                  await fetchNotifyReadService(data.actionId, false)
                      .then((res) {
                    loadingProductStock(context);
                    Get.back();
                  });
                }
                if (notifyOrder.orderTracking!.data[index].idInfo.orderType ==
                    0) {
                  notifyOrder.fetchOrderDetailCheckOut(data.idInfo.orderId);
                  await Get.to(() => const OrderCheckout())!.then((value) {
                    setOffset(10);
                    notifyOrder.orderTracking = null;
                    notifyOrder.fetchNotifyOrderTracking(10627, 0);
                  });
                } else {
                  notifyOrder.fetchOrderDetail(data.idInfo.orderId);
                  await Get.to(() => const MyOrderDetail())!.then((value) {
                    setOffset(10);
                    notifyOrder.orderTracking = null;
                    notifyOrder.fetchNotifyOrderTracking(10627, 0);
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: data.isRead ? Colors.white : Colors.grey.shade200,
                  border: const Border(
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 191, 191, 191),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      data.image,
                      width: 38,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.title,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              data.subTitle,
                              softWrap: true,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text(
                              data.dateTime,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade700,
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
      ],
    );
  });
}
