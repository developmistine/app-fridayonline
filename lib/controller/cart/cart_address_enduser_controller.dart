// !controller for fetch cart items

import 'package:fridayonline/model/cart/enduser/enduser_address.dart';
import 'package:fridayonline/service/cart/enduser/enduser_service.dart';
import 'package:get/get.dart';

class FetchCartEndUsersAddress extends GetxController {
  EndUserAddress? addressEndUser;
  var isDataLoading = false.obs;
  RxInt selectedAddress = 0.obs;
  fetchEnduserAddress() async {
    try {
      isDataLoading(true);
      addressEndUser = await getEnduserAddress();
    } finally {
      isDataLoading(false);
    }
  }
}
