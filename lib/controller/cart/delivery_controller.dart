// !controller for fetch cart items
// import 'dart:developer';

import 'package:fridayonline/model/cart/enduser/enduser_getdetails_delivery.dart';
import 'package:fridayonline/service/cart/delivery_service.dart';
import 'package:fridayonline/service/cart/enduser/enduser_service.dart';
import 'package:get/get.dart';

import '../../model/cart/delivery_change.dart';

class FetchDeliveryChange extends GetxController {
  ChangeDelivery? isChange;
  EnduserGetDetailDelivery? isEnduserChange;

  RxBool isDataLoading = false.obs;
  RxBool isDataLoadingEndUser = false.obs;

  RxInt indexChange = 0.obs;
  change(n) {
    indexChange.value = n;
    update();
  }

  // change price
  fetchDeliveryChange(totalAmount) async {
    try {
      isDataLoading(true);
      isChange = await changeDeliver(totalAmount);
      update();
    } finally {
      isDataLoading(false);
    }
  }

  // change type
  fetchEndUserChangeDelivery(totalAmount) async {
    try {
      isDataLoadingEndUser(true);
      isEnduserChange = await enduserGetDetailDelivery(totalAmount);
    } finally {
      isDataLoadingEndUser(false);
    }
  }
}
