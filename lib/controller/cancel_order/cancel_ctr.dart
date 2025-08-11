import 'package:fridayonline/model/cancel_order/cancel_model.dart';
import 'package:fridayonline/model/respose_center.dart';
import 'package:fridayonline/service/cancel_order/cancel_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelProductController extends GetxController {
  List<String> reasonText = [];
  RxInt? checkedIndex = 0.obs;
  RxBool isCheck = false.obs;
  RxBool isOther = false.obs;
  RxBool isDataLoading = false.obs;
  RxBool saveDataLoading = false.obs;
  List<Cancelreason>? cancleReason = [];
  Rx<TextEditingController> otherNoteCtr = TextEditingController().obs;
  Resposecenter? response;

  fetchCancelReason(int shopType) async {
    try {
      isDataLoading(true);
      cancleReason = await getCancleReason(shopType);
    } catch (e) {
      debugPrint('error is $e');
    } finally {
      isDataLoading(false);
    }
  }

  saveCancelOrderFn(String orderId, String endUserId, String campaign,
      String cancelId, String note, String shopType) async {
    try {
      saveDataLoading(true);
      response = await saveCancelOrder(
          orderId, endUserId, campaign, cancelId, note, shopType);
    } catch (e) {
      debugPrint('error is $e');
    } finally {
      saveDataLoading(false);
    }
  }
}
