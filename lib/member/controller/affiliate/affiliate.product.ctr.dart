// lib/member/controller/affiliate/affiliate.product.ctr.dart
import 'package:get/get.dart';

class AffiliateProductCtr extends GetxController {
  /// ===== Product (จัดเรียง/กรอง) =====
  final productEmpty = false.obs;
  final tabSort = 0.obs;
  final isPriceUp = false.obs;

  // ตั้งค่าแท็บเรียงลำดับ
  void setSortTab(int index, int priceIndex) {
    if (tabSort.value == index && index == priceIndex) {
      isPriceUp.toggle();
    } else {
      tabSort.value = index;
      if (index != priceIndex) {
        isPriceUp.value = false;
      }
    }
  }
}
