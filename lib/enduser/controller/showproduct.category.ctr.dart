import 'package:appfridayecommerce/enduser/models/category/filter.model.dart';
import 'package:appfridayecommerce/enduser/models/showproduct/product.category.model.dart';
import 'package:appfridayecommerce/enduser/services/category/category.service.dart';
import 'package:appfridayecommerce/enduser/services/showproduct/showproduct.category.service.dart';
import 'package:get/get.dart';

class ShowProductCategoryCtr extends GetxController {
  final RxBool isLoadingProductCategory = false.obs;
  ProductContent? productCategory;
  ProductsFilter? productFilter;
  RxBool isSort = false.obs;
  RxBool isLoadingMore = false.obs;
  final int itemsPerPage = 30;
  RxInt acType = 0.obs;
  RxString acValue = "".obs;
  RxInt catIdVal = 0.obs;
  RxInt subCatIdVal = 0.obs;
  RxString sortByVal = "".obs;
  RxString orderByVal = "".obs;

  fetchProductByCategoryId(
      int actionType, String actionValue, int offset) async {
    acType.value = actionType;
    acValue.value = actionValue;
    try {
      isLoadingProductCategory.value = true;
      productCategory =
          await fetchProductContentService(actionType, actionValue, offset);
    } finally {
      isLoadingProductCategory.value = false;
    }
  }

  fetchProductByCategoryIdWithSort(int catId, int subCatId, String sortBy,
      String order, int limit, int offset) async {
    catIdVal.value = catId;
    subCatIdVal.value = subCatId;
    sortByVal.value = sortBy;
    orderByVal.value = order;
    try {
      isLoadingProductCategory.value = true;
      productFilter = await fetchFilterProductCategoryService(
          catId, subCatId, sortBy, order, limit, offset);
    } finally {
      isLoadingProductCategory.value = false;
    }
  }

  void resetProductCategory() {
    if (productCategory != null && productCategory!.data.length > 10) {
      productCategory!.data = productCategory!.data.sublist(0, 10);
    }
  }

  void resetProductCategoryWithSort() {
    if (productFilter != null && productFilter!.data.products.length > 40) {
      productFilter!.data.products =
          productFilter!.data.products.sublist(0, 40);
    }
  }

  Future<ProductContent?>? fetchMoreProductCategory(
      actionType, actionValue, offset) async {
    return await fetchProductContentService(actionType, actionValue, offset);
  }

  Future<ProductsFilter?>? fetchMoreProductCategoryWithSort(int catId,
      int subCatId, String sortBy, String order, int limit, int offset) async {
    return await fetchFilterProductCategoryService(
        catId, subCatId, sortBy, order, limit, offset);
  }
}
