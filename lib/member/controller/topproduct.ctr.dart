import 'package:fridayonline/member/models/home/home.topproduct.model.dart';
import 'package:fridayonline/member/services/topproduct/topproduc.service.dart';
import 'package:get/get.dart';

class TopProductsCtr extends GetxController {
  var activeIndex = 0.obs;
  var isLoading = false.obs;
  TopProductsWeekly? topProducts;

  void setActiveTab(int index) {
    activeIndex.value = index;
  }

  fetchTopProducts(prdId) async {
    try {
      isLoading.value = true;
      topProducts = await fetchTopProductsService(prdId);
    } finally {
      isLoading.value = false;
    }
  }
}
