import 'package:appfridayecommerce/enduser/controller/notify.ctr.dart';
import 'package:appfridayecommerce/enduser/models/notify/notify.model.dart';
import 'package:appfridayecommerce/enduser/models/orders/orderdetail.checkout.model.dart';
import 'package:appfridayecommerce/enduser/models/orders/orderdetail.model.dart';
import 'package:appfridayecommerce/enduser/models/orders/orderheader.model.dart';
import 'package:appfridayecommerce/enduser/models/orders/orderlist.checkout.model.dart';
import 'package:appfridayecommerce/enduser/models/orders/orderlist.model.dart';
import 'package:appfridayecommerce/enduser/services/notify/order.notify.service.dart';
import 'package:appfridayecommerce/enduser/services/orders/order.service.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var isLoading = false.obs;
  var isLoadingList = false.obs;
  var isLoadingListCheckOut = false.obs;
  var isLoadingDetail = false.obs;
  var isLoadingDetailCheckOut = false.obs;
  var isLoadingNotifyOrder = false.obs;

  var isLoadingMore = false.obs;
  var isLoadingMoreOrderList = false.obs;

  OrdersHeader? header;
  OrdersList? orderList;
  OrdersListCheckOut? orderListCheckOut;
  OrderDetail? orderDetail;
  OrderDetailCheckOut? orderDetailChekcOut;
  B2CNotify? orderTracking;
  RxString orderHeaderName = "".obs;
  RxInt initialIndex = 0.obs;
  int orderTypeCtr = 0;
  int orderShopId = 0;

  Future<OrdersHeader?> fetchOrderHeader() async {
    try {
      isLoading.value = true;
      header = await fetchOrderHeadersService();
      fetchOrderList(header!.data[0].orderType, 0);
      return header;
    } finally {
      isLoading.value = false;
    }
  }

  fetchOrderList(int orderType, int offset) async {
    orderTypeCtr = orderType;
    try {
      isLoadingList.value = true;
      if (orderType == 0) {
        orderListCheckOut =
            await fetchOrderListCheckOutService(orderType, offset);
      } else {
        orderList = await fetchOrderListService(orderType, 0, offset);
      }
    } finally {
      isLoadingList.value = false;
    }
  }

  fetchOrderDetail(int orderId) async {
    orderShopId = orderId;
    try {
      isLoadingDetail.value = true;
      orderDetail = await fetchOrderDetailService(orderId);
    } finally {
      isLoadingDetail.value = false;
    }
  }

  fetchOrderDetailCheckOut(int orderId) async {
    orderShopId = orderId;
    try {
      isLoadingDetailCheckOut.value = true;
      orderDetailChekcOut = await fetchOrderDetailCheckOutService(orderId);
    } finally {
      isLoadingDetailCheckOut.value = false;
    }
  }

  fetchNotifyOrderTracking(int groupId, int offset) async {
    Get.find<NotifyController>().fetchCountNotify();
    try {
      isLoadingNotifyOrder(true);
      orderTracking = await fetchNotifyOrderTrackingService(groupId, offset);
    } finally {
      isLoadingNotifyOrder(false);
    }
  }

  Future<OrdersList?>? fetchMoreOrderList(offset) async {
    return await fetchOrderListService(orderTypeCtr, 0, offset);
  }

  Future<OrdersListCheckOut?>? fetchMoreOrderListCheckOut(offset) async {
    return await fetchOrderListCheckOutService(orderTypeCtr, offset);
  }

  void resetOrderList() {
    if (orderList != null && orderList!.data.length > 10) {
      orderList!.data = orderList!.data.sublist(0, 10);
    }
  }

  Future<B2CNotify?>? fetchMoreNotify(offset) async {
    return await fetchNotifyOrderTrackingService(10627, offset);
  }

  void resetOrderNotify() {
    if (orderTracking != null && orderTracking!.data.length > 10) {
      orderTracking!.data = orderTracking!.data.sublist(0, 10);
    }
  }
}
