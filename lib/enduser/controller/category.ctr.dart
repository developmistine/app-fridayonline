import 'package:appfridayecommerce/enduser/models/category/sort.model.dart';
import 'package:appfridayecommerce/enduser/models/category/subcategory.model.dart';
import 'package:appfridayecommerce/enduser/services/category/category.service.dart';
import 'package:get/get.dart';

class CategoryCtr extends GetxController {
  var isLoading = false.obs;
  var isLoadingSort = false.obs;
  SubCategorie? subcategory;
  Sort? sortData;
  RxInt activeTab = 0.obs;
  RxInt activeCat = (-9).obs;
  RxBool isPriceUp = false.obs;

  fetchSubCategory(int catId) async {
    try {
      isLoading.value = true;
      subcategory = await fetchSubCategoryService(catId);
    } finally {
      isLoading.value = false;
    }
  }

  fetchSort() async {
    try {
      isLoadingSort.value = true;
      sortData = await fetchSortService();
    } finally {
      isLoadingSort.value = false;
    }
  }

  setActiveTab(index) {
    activeTab.value = index;
  }

  setActiveCat(index) {
    activeCat.value = index;
  }
}
