import 'package:fridayonline/model/payment_type/payment_type.model.dart';
import 'package:fridayonline/service/cart/payment_type.service.dart';
import 'package:get/get.dart';

class PaymentTypeCtr extends GetxController {
  PaymentType? paymentTypeData;
  // Map<String, GetSupplierDelivery> supplierDelivery = {};

  RxBool isLoading = false.obs;
  RxBool isLoadingSupplier = false.obs;
  getPaymentType() async {
    try {
      isLoading.value = true;
      paymentTypeData = await paymentType();
    } finally {
      isLoading.value = false;
    }
  }
}
