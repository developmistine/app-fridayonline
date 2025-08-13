import 'package:appfridayecommerce/enduser/models/category/sort.model.dart';
import 'package:appfridayecommerce/enduser/models/search/search.suggest.model.dart';
import 'package:appfridayecommerce/enduser/models/showproduct/product.category.model.dart';
import 'package:appfridayecommerce/enduser/services/category/category.service.dart';
import 'package:appfridayecommerce/enduser/services/search/search.service.dart';
import 'package:get/get.dart';

class SearchProductCtr extends GetxController {
  final RxBool isLoadingSearch = false.obs;
  final RxBool isLoadingSuggest = false.obs;
  final RxBool isLoadingSort = false.obs;
  ProductContent? productCategory;
  SearchSuggest? suggest;
  RxBool isLoadingMore = false.obs;
  RxString keyword = "".obs;
  Sort? sortData;
  RxInt activeTab = 0.obs;
  RxBool isPriceUp = false.obs;
  RxString sortByVal = "".obs;
  RxString orderByVal = "".obs;

  fetchProductByKeyword(
      String key, int offset, String order, String sortBy) async {
    orderByVal.value = order;
    sortByVal.value = sortBy;
    keyword.value = key;
    try {
      isLoadingSearch.value = true;
      productCategory = await searchItemService(key, offset, order, sortBy);
    } finally {
      isLoadingSearch.value = false;
    }
  }

  fetchProductSuggust(int offset) async {
    try {
      isLoadingSuggest.value = true;
      suggest = await searchSuggestService(offset);
    } finally {
      isLoadingSuggest.value = false;
    }
  }

  void resetProductCategory() {
    if (productCategory != null && productCategory!.data.length > 20) {
      productCategory!.data = productCategory!.data.sublist(0, 20);
    }
  }

  Future<ProductContent?>? fetchMoreProductSearch(
      String key, int offset, String order, String sortBy) async {
    keyword.value = key;
    return await searchItemService(key, offset, order, sortBy);
  }

  void resetProductSuggest() {
    if (suggest != null && suggest!.data.length > 20) {
      suggest!.data = suggest!.data.sublist(0, 20);
    }
  }

  Future<SearchSuggest?>? fetchMoreProductSuggest(int offset) async {
    return await searchSuggestService(offset);
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
}
