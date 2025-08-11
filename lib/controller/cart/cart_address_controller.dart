// !controller for fetch cart items

import 'package:get/get.dart';

import '../../model/cart/card_noti_address.dart';
import '../../service/cart/card_noti_address_service.dart';

class FetchCartNotiAddress extends GetxController {
  NotifyAddress? addressCart;
  var isDataLoading = false.obs;
  fetchNotiAddress() async {
    try {
      isDataLoading(true);
      addressCart = await getAddressCart();
      update();
    } finally {
      isDataLoading(false);
    }
  }
}
