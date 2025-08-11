import 'package:get/get.dart';

import '../../model/cart/dropship/dropship_status_addcart.dart';
import '../../model/cart/save_order.dart';
import '../../service/cart/cart_save_order_service.dart';

// !controller for save order
class SaveOrderController extends GetxController {
  SaveOrder? itemsSaveOrder;

  var isDataLoading = false.obs;

  saveOrderCart(Map<String, dynamic> orderTotal) async {
    try {
      isDataLoading(true);
      itemsSaveOrder = await saveorderService(orderTotal);
      update();
      return itemsSaveOrder;
    } finally {
      isDataLoading(false);
    }
  }

  saveOrderEndUserCart(Map<String, dynamic> orderTotal) async {
    try {
      isDataLoading(true);
      itemsSaveOrder = await saveorderEndUserService(orderTotal);
      update();
      return itemsSaveOrder;
    } finally {
      isDataLoading(false);
    }
  }
}

//? controller for save order dropship
class SaveOrderDropship extends GetxController {
  CartDropshipStatus? saveDropship;

  var isDataLoading = false.obs;

  saveOrderCartDropship(Map<String, dynamic> orderTotal) async {
    try {
      isDataLoading(true);
      // ! ห้ามลบ เป็นการปิดการ call Dropship Cart
      // saveDropship = await saveOrderDropship(orderTotal);
      saveDropship = CartDropshipStatus(
          code: "", message1: "", message2: '', message3: '');
      update();
      return saveDropship;
    } finally {
      isDataLoading(false);
    }
  }
}
