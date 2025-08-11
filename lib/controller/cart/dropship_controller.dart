import 'package:get/get.dart';

import '../../model/cart/dropship/drop_ship_address.dart';
import '../../model/cart/dropship/dropship_model.dart';
import '../../model/cart/dropship/dropship_status_addcart.dart';
// import '../../service/cart/dropship/dropship_address_service.dart';
// import '../../service/cart/dropship/dropship_service.dart';

//? dropship get cart
class FetchCartDropshipController extends GetxController {
  Dropship? itemDropship;
  var isDataLoading = false.obs;
  var isChangeLanguage = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCartDropship();
  }

  refreshDataFalse() {
    for (var element in itemDropship!.cartHeader.cartDetail) {
      element.isChecked = false;
    }
    update();
  }

  fetchCartDropship() async {
    try {
      isDataLoading(true);
      //! ห้ามลบ เป็นการปิดการ call Dropship Cart
      // itemDropship = await getDropshipProduct();
      itemDropship = Dropship(
          cartHeader: CartHeader(
              cartDetail: [],
              repCode: '',
              repType: '',
              repSeq: '',
              totalAmount: 0,
              totalItem: 0));
      // log(" fetch ${itemDropship!.cardHeader.toJson()}");
      update();
    } finally {
      isDataLoading(false);
      isChangeLanguage(false);
    }
  }
}

//? dropship address
class FetchAddressDropshipController extends GetxController {
  DropshipGetAddress? itemDropship;
  var isDataLoading = false.obs;
  var isChangeLanguage = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchDropshipAddress();
  }

  fetchDropshipAddress() async {
    try {
      isDataLoading(true);
      // !ห้ามลบ เป็นการปืิดการ call Dropship Address
      // itemDropship = await getDropshipAddress();
      itemDropship = DropshipGetAddress(
        address: [],
        repCode: '',
        repSeq: '',
        repType: '',
      );
      update();
    } finally {
      isDataLoading(false);
      isChangeLanguage(false);
    }
  }
}

//? edit cart dropship
class DropshipEditCart extends GetxController {
  CartDropshipStatus? itemDropship;
  var isDataLoading = false.obs;

  editCart(billB2C, qty, action) async {
    try {
      isDataLoading(true);
      // !ห้ามลบ เป็นการปืิดการ call Dropship Address
      // itemDropship = await dropshipEditcart(billB2C, qty, action);
      itemDropship = CartDropshipStatus(
          code: '', message1: '', message2: '', message3: '');
      // log(" fetch ${itemDropship!.cardHeader.toJson()}");
      await Get.find<FetchCartDropshipController>().fetchCartDropship();
      update();
    } finally {
      isDataLoading(false);
    }
  }
}
