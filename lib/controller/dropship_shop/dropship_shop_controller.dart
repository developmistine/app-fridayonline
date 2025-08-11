// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:get/get.dart';

import '../../model/cart/dropship/dropship_productdetail_model.dart';
import '../../model/dropship/dropship_banner_model.dart';
import '../../model/dropship/dropship_product_model.dart';
import '../../model/dropship/dropship_supplier_model.dart';
import '../../service/dropship_shop/dropship_shop_service.dart';

class FetchDropshipShop extends GetxController {
  List<GetDropshipBanner>? bannerDropship;
  List<GetDropshipCategoryProduct>? productDropship;
  GetDropshipProductDetail? productDetail;
  GetDropshipProductBySupplier? supplierProduct;
  var isDataLoading = false.obs;
  var isDropshipLoading = false.obs;
  var isProductDetailLoading = false.obs;
  var isChangeLanguage = false.obs;
  var isSupplierLoading = false.obs;
  // @override
  fetchBannerDropship() async {
    try {
      isDataLoading(true);
      bannerDropship = await dropshipShop();
      update();
    } finally {
      isDataLoading(false);
      isChangeLanguage(false);
    }
  }

  fetchProductDropship() async {
    try {
      isDropshipLoading(true);
      productDropship = await dropshipProductbyCategory();
      update();
    } finally {
      isDropshipLoading(false);
    }
  }

  fetchProductDetailDropship(productCode) async {
    try {
      isProductDetailLoading(true);
      productDetail = await getDropshipProductDetail(productCode);
      update();
    } finally {
      isProductDetailLoading(false);
    }
  }

  fetchProductSupplierDropship(supplierCode) async {
    try {
      isSupplierLoading(true);
      supplierProduct = await getDropshipProductSupplier(supplierCode);
      update();
    } finally {
      isSupplierLoading(false);
    }
  }
}
