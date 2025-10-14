import 'dart:async';

import 'package:fridayonline/member/models/brands/brands.model.dart';
import 'package:fridayonline/member/models/brands/shopbanner.model.dart';
import 'package:fridayonline/member/models/brands/shopcategory.model.dart';
import 'package:fridayonline/member/models/brands/shopcontent.model.dart';
import 'package:fridayonline/member/models/brands/shopfilter.model.dart';
import 'package:fridayonline/member/models/brands/shopflashsale.model.dart';
import 'package:fridayonline/member/models/brands/shopinfo.model.dart';
import 'package:fridayonline/member/models/brands/shopvouchers.model.dart';
import 'package:fridayonline/member/models/category/sort.model.dart';
import 'package:fridayonline/member/services/brands/brands.service.dart';
import 'package:fridayonline/member/services/category/category.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BrandCtr extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var isLoadingShopBrands = false.obs;
  var isLoadingSort = false.obs;
  var isLoadingShop = false.obs;
  var isLoadingShopContent = false.obs;
  var isLoadingShopBanner = false.obs;
  var isLoadingShopCategory = false.obs;
  var isLoadingShopProductFilter = false.obs;
  var isLoadingShopVouchers = false.obs;
  var isLoadingShopFlashSale = false.obs;

  Rxn<ShopInfo> shopInfoDev = Rxn();

  BrandsList? brandsList;
  BrandsList? shopBrandsList;
  Sort? sortData;

  ShopInfo? shopInfo;
  ShopContent? shopContent;
  ShopBanner? shopBanner;
  ShopCategory? shopCategory;
  ShopProductFilter? shopProductFilter;
  ShopsVouchers? shopVouchers;
  ShopsFlashSale? shopFlashSale;

  var shopInfoCache = <String, ShopInfo>{}.obs;
  var shopContentCache = <String, ShopContent>{}.obs;
  var shopCategoryCache = <String, ShopCategory>{}.obs;
  var shopFlashSaleCache = <String, ShopsFlashSale>{}.obs;
  var shopVouchersCache = <String, ShopsVouchers>{}.obs;

  RxInt activeTab = 0.obs;
  RxInt activeCat = (-9).obs;
  RxBool isPriceUp = false.obs;
  int sectionIdVal = 0;
  int shopIdVal = 0;
  int brandIdVal = 0;
  int catIdVal = 0;
  int subIdVal = 0;
  String sortByVal = "";
  String orderByVal = "";
  RxInt current = 0.obs;
  RxDouble volume = 0.0.obs;

  RxDouble opacity = 0.0.obs;
  RxBool showSort = false.obs;
  RxBool isSetAppbar = false.obs;
  RxBool showClaimedCoupon = false.obs;

  RxMap<int, int?> selectedCoupon = <int, int?>{}.obs;

  // ?Flash Sale
  RxBool isCloseFlashSale = true.obs;
  RxString countdown = "00:00:00".obs;
  RxBool isLoadMoreFlashSale = false.obs;

  void setshowClaimedCoupon() {
    showClaimedCoupon.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      showClaimedCoupon.value = false;
    });
  }

// 2. แก้ไข scrollToSection ให้ใช้ ValueKey
  void scrollToSection(int shopId, int contentId) {
    final context = Get.context; // หรือใช้ context ที่มีอยู่
    if (context != null) {
      final valueKey = ValueKey('shop_${shopId}_section_$contentId');

      // หา widget ที่มี key นี้
      final element = _findElementByKey(context as Element, valueKey);
      if (element != null) {
        Scrollable.ensureVisible(
          element,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.375,
        );
      }
    }
  }

// 3. Helper function สำหรับหา Element โดยใช้ Key
  Element? _findElementByKey(Element root, Key key) {
    Element? found;

    void visitor(Element element) {
      if (element.widget.key == key) {
        found = element;
        return;
      }
      element.visitChildren(visitor);
    }

    root.visitChildren(visitor);
    return found;
  }

  void fetchShopData(int shopId, {String path = 'shops'}) {
    shopIdVal = shopId;

    fetchShopInfo(shopId, path);
    fetchShopContent(shopId, path);
    fetchShopCategory(shopId, path);
    fetchShopCoupon(shopId, path);
    fetchShopFlashSale(shopId, 10, 0, path);
  }

  Future<void> fetchShopFlashSale(
      int shopId, int limit, int offset, String path) async {
    try {
      isLoadingShopFlashSale.value = true;
      if (shopFlashSaleCache.containsKey(shopId.toString())) {
        shopFlashSale = shopFlashSaleCache[shopId.toString()];
        // if (shopFlashSaleCache.length > 1) {
        // shopFlashSaleCache
        //     .removeWhere((key, value) => key == shopId.toString());
        // }
        return;
      }

      shopFlashSale =
          await fetchShopFlashSaleServices(shopId, limit, offset, path: path);
      shopFlashSaleCache[shopId.toString()] = shopFlashSale!;
    } finally {
      if (shopFlashSale!.code != "-9") {
        Timer.periodic(
            const Duration(seconds: 1),
            (timer) => updateCountdown(timer, shopFlashSale!.data.startDate,
                shopFlashSale!.data.endDate));
        isLoadingShopFlashSale.value = false;
      }
    }
  }

  void updateCountdown(Timer timer, String startDate, String endDate) {
    DateTime start = DateFormat('dd/MM/yyyy HH:mm:ss').parse(startDate);
    DateTime end = DateFormat('dd/MM/yyyy HH:mm:ss').parse(endDate);

    Duration diffEnd = end.difference(DateTime.now());
    Duration diffStart = start.difference(DateTime.now());
    if (diffStart.isNegative) {
      if (diffEnd.isNegative) {
        countdown.value = "00:00:00";
        timer.cancel();
        isCloseFlashSale.value = true;
      } else {
        if (isCloseFlashSale.value) {
          isCloseFlashSale.value = false;
        }
        int hours = diffEnd.inHours;
        int minutes = (diffEnd.inMinutes % 60);
        int seconds = (diffEnd.inSeconds % 60);

        countdown.value =
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }
    }
  }

  Future<void> fetchBrads(String pageType, int catId) async {
    try {
      isLoading.value = true;
      brandsList = await fetchBrandsServices(pageType, catId);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchShopBrand(int shopId) async {
    try {
      isLoadingShopBrands.value = true;
      shopBrandsList = await fetchShopBrandsServices(shopId);
    } finally {
      isLoadingShopBrands.value = false;
    }
  }

  Future<void> fetchShopCoupon(int shopId, String path) async {
    try {
      if (shopVouchersCache.containsKey(shopId.toString())) {
        shopVouchers = shopVouchersCache[shopId.toString()];
        // if (shopVouchersCache.length > 1) {
        // shopVouchersCache.removeWhere((key, value) => key == shopId.toString());
        // }
        return;
      }
      isLoadingShopVouchers.value = true;
      shopVouchers = await fetchShopCouponServices(shopId, path: path);
      shopVouchersCache[shopId.toString()] = shopVouchers!;
    } finally {
      isLoadingShopVouchers.value = false;
    }
  }

  Future<void> fetchShopInfo(int shopId, String path) async {
    try {
      isLoadingShop.value = true;

      if (shopInfoCache.containsKey(shopId.toString())) {
        shopInfo = shopInfoCache[shopId.toString()];
        // if (shopInfoCache.length > 1) {
        // shopInfoCache.removeWhere((key, value) => key == shopId.toString());
        // }
        return;
      }

      shopInfo = await fetchShopInfoServices(shopId, path);
      shopInfoCache[shopId.toString()] = shopInfo!;
      // shopInfoDev.value = await fetchShopInfoServices(shopId);
    } finally {
      isLoadingShop.value = false;
    }
  }

  Future<void> fetchShopContent(int shopId, String path) async {
    try {
      isLoadingShopContent.value = true;
      if (shopContentCache.containsKey(shopId.toString())) {
        shopContent = shopContentCache[shopId.toString()];
        return;
      }

      shopContent = await fetchShopContentServices(shopId, path);
      shopContentCache[shopId.toString()] = shopContent!;
    } finally {
      isLoadingShopContent.value = false;
    }
  }

  Future<void> fetchShopCategory(int shopId, String path) async {
    try {
      isLoadingShopCategory.value = true;
      if (shopCategoryCache.containsKey(shopId.toString())) {
        shopCategory = shopCategoryCache[shopId.toString()];
        // if (shopCategoryCache.length > 1) {
        // shopCategoryCache.removeWhere((key, value) => key == shopId.toString());
        // }
        return;
      }

      shopCategory = await fetchShopCategoryServices(shopId, path);
      shopCategoryCache[shopId.toString()] = shopCategory!;
    } finally {
      isLoadingShopCategory.value = false;
    }
  }

  Future<void> fetchShopProductFilter(
    int sectionId,
    int shopId,
    String sortBy,
    String orderBy,
    int offset, {
    String path = 'shops',
  }) async {
    sectionIdVal = sectionId;
    shopIdVal = shopId;
    sortByVal = sortBy;
    orderByVal = orderBy;
    try {
      isLoadingShopProductFilter.value = true;
      shopProductFilter = await fetchShopProductFilterServices(
          sectionId, shopId, sortBy, orderBy, offset,
          path: path);
    } finally {
      isLoadingShopProductFilter.value = false;
    }
  }

  Future<void> fetchShopBanner() async {
    try {
      isLoadingShopBanner.value = true;
      shopBanner = await fetchShopBannerServices();
    } finally {
      isLoadingShopBanner.value = false;
    }
  }

  Future<void> fetchSort() async {
    try {
      isLoadingSort.value = true;
      sortData = await fetchSortService();
    } finally {
      isLoadingSort.value = false;
    }
  }

  void setActiveTab(index) {
    activeTab.value = index;
  }

  void setActiveCat(index) {
    activeCat.value = index;
  }

  void resetVal() {
    activeTab.value = 0;
    opacity.value = 0;
    showSort.value = false;
    isSetAppbar.value = false;

    isPriceUp.value = false;
    sectionIdVal = 0;
  }

  Future<ShopProductFilter?>? fetchMoreShopProductFilter(
    int sectionId,
    int shopId,
    String sortBy,
    String orderBy,
    int offset, {
    String path = 'shops',
  }) async {
    return await fetchShopProductFilterServices(
        sectionId, shopId, sortBy, orderBy, offset,
        path: path);
  }

  void resetShopProductFilter() {
    if (shopProductFilter != null &&
        shopProductFilter!.data.products.length > 40) {
      shopProductFilter!.data.products =
          shopProductFilter!.data.products.sublist(0, 40);
    }
  }

  // ? loadmore flashsale
  Future<ShopsFlashSale?>? fetchMoreFlashSale(offet,
      {String path = 'shops'}) async {
    return await fetchShopFlashSaleServices(shopIdVal, 20, offet, path: path);
  }

  // ? reset flashsale
  void resetFlashSale() {
    if (shopFlashSale != null &&
        shopFlashSale!.data.productContent.length > 20) {
      shopFlashSale!.data.productContent =
          shopFlashSale!.data.productContent.sublist(0, 20);
    }
  }
}
