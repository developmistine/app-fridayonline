import 'dart:async';

import 'package:fridayonline/enduser/controller/brand.ctr.dart';
import 'package:fridayonline/enduser/controller/cart.ctr.dart';
import 'package:fridayonline/enduser/controller/category.ctr.dart';
import 'package:fridayonline/enduser/controller/chat.ctr.dart';
import 'package:fridayonline/enduser/controller/coint.ctr.dart';
import 'package:fridayonline/enduser/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/enduser/controller/notify.ctr.dart';
import 'package:fridayonline/enduser/controller/order.ctr.dart';
import 'package:fridayonline/enduser/models/category/category.model.dart';
import 'package:fridayonline/enduser/models/category/home.category.model.dart';
import 'package:fridayonline/enduser/models/flashsale/flashsale.model.dart';
import 'package:fridayonline/enduser/models/home/hom.mall.model.dart';
import 'package:fridayonline/enduser/models/home/home.brands.model.dart';
import 'package:fridayonline/enduser/models/home/home.content.model.dart';
import 'package:fridayonline/enduser/models/home/home.popup.model.dart';
import 'package:fridayonline/enduser/models/home/home.recommend.dart';
import 'package:fridayonline/enduser/models/home/home.short.model.dart';
import 'package:fridayonline/enduser/models/home/home.topsales.model.dart';
import 'package:fridayonline/enduser/models/home/home.vouchers.model.dart';
import 'package:fridayonline/enduser/services/category/category.service.dart';
import 'package:fridayonline/enduser/services/flashsale/flashsale.service.dart';
import 'package:fridayonline/enduser/services/home/home.service.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/print.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/home/home.banner.model.dart';

class EndUserHomeCtr extends GetxController {
  final RxBool isLoadingBanner = false.obs;
  final RxBool isLoadingShortMenu = false.obs;
  final RxBool isLoadingFlashDeal = false.obs;
  final RxBool isLoadingCoupon = false.obs;
  final RxBool isLoadingCouponNewUser = false.obs;
  final RxBool isLoadingLoadmore = false.obs;
  final RxBool isLoadingTopSales = false.obs;
  final RxBool isLoadingBrands = false.obs;
  final RxBool isLoadingMall = false.obs;
  final RxBool isLoadingNewProduts = false.obs;
  final RxBool isLoadingSupperDeal = false.obs;

  final RxBool isLoadingCategory = false.obs;

  final RxBool isShowMoreShortIcon = false.obs;
  final RxBool isFetchingLoadmore = false.obs;

  HomeBanner? homeBanner;
  HomeShortMenu? homeShortMenu;
  HomeCategory? homeCategory;
  // * Model เหมือนกันค่อยปรับ
  HomeContent? newProducts;
  HomeContent? supperDeal;
  HomeBrands? brands;
  HomeMalls? mall;
  ProductRecommend? recommend;
  ProductCategory? category;
  Rx<HomeVouchers>? homeVouchers;
  Rx<HomeVouchers>? homeVouchersNewUser;
  TopSalesWeekly? topSalesWeekly;

  // ?Flash Sale
  B2CFlashSale? flashSale;
  RxBool isCloseFlashSale = true.obs;
  RxString countdown = "00:00:00".obs;
  RxBool isLoadMoreFlashSale = false.obs;

  // ? Popup
  EndUserPopup? popupSmall;
  RxBool isViewPopup = false.obs;
  RxBool isLoadingPopup = false.obs;
  RxBool isVisibilityFair = false.obs;

  endUserGetAllHomePage() async {
    Get.find<CoinCtr>().fetchCheckIn();
    fetchPopup();
    fetchBanner();
    fetchShortMenu();
    fetchFlashDeal(0);
    fetchTopSalesWeekly();
    fetchCoupon();
    fetchCouponNewUser();
    fetchLoadmore(0);
    fetchCategory();
    fetchMall();
    fetchBrands();
    fetchNewProducts(5);
    fetchSupperDeal(6);
    Get.find<EndUserCartCtr>().fetchCartItems();
    Get.find<OrderController>().fetchNotifyOrderTracking(10627, 0);
    Get.find<BrandCtr>().fetchBrads("mall", 0);
    Get.find<BrandCtr>().fetchShopBanner();
    Get.find<CategoryCtr>().fetchSort();
    Get.find<EndUserSignInCtr>().fetchB2cCustId();
    Get.find<NotifyController>().fetchCountNotify();
    Get.find<NotifyController>().fetchNotifyGroup();

    SetData data = SetData();
    var socketCtr = Get.find<WebSocketController>();
    if (await data.b2cCustID != 0) {
      if (socketCtr.channel == null ||
          socketCtr.subscription == null ||
          !socketCtr.isConnected.value) {
        printWhite('conncet ใหม่');
        await socketCtr.connectWebSocket();
        Get.find<ChatController>().fetchSellerChat(0);
      }
    } else {
      // socketCtr.onClose();
    }

    isViewPopup.value = false;
  }

  fetchPopup() async {
    try {
      isLoadingPopup.value = true;
      popupSmall = await fetctPopupService(3);
    } finally {
      isLoadingPopup.value = false;
    }
  }

  fetchBanner() async {
    try {
      isLoadingBanner.value = true;
      homeBanner = await fetchHomeBannerService();
    } finally {
      isLoadingBanner.value = false;
    }
  }

  fetchNewProducts(int contentType) async {
    try {
      isLoadingNewProduts.value = true;
      newProducts = await fetchHomeContentService(contentType);
    } finally {
      isLoadingNewProduts.value = false;
    }
  }

  fetchSupperDeal(int contentType) async {
    try {
      isLoadingSupperDeal.value = true;

      supperDeal = await fetchHomeContentService(contentType);
    } finally {
      isLoadingSupperDeal.value = false;
    }
  }

  fetchShortMenu() async {
    try {
      isLoadingShortMenu.value = true;
      homeShortMenu = await fetchHomeShorMenuService();
    } finally {
      isLoadingShortMenu.value = false;
    }
  }

  fetchTopSalesWeekly() async {
    try {
      isLoadingTopSales.value = true;
      topSalesWeekly = await fetchTopSalesWeeklyService();
    } finally {
      isLoadingTopSales.value = false;
    }
  }

  fetchMall() async {
    try {
      isLoadingMall(true);
      mall = await fetchHomeMallService();
    } finally {
      isLoadingMall(false);
    }
  }

  fetchBrands() async {
    try {
      isLoadingBrands(true);
      brands = await fetctBrandsService();
    } finally {
      isLoadingBrands(false);
    }
  }

  fetchFlashDeal(int offset) async {
    try {
      isLoadingFlashDeal.value = true;
      flashSale = await fetchFlashSaleHomeService(offset);
    } finally {
      if (flashSale!.code != "-9") {
        Timer.periodic(
            const Duration(seconds: 1),
            (timer) => updateCountdown(
                timer, flashSale!.data.startDate, flashSale!.data.endDate));
      }
      isLoadingFlashDeal.value = false;
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

  fetchCoupon() async {
    try {
      isLoadingCoupon.value = true;
      final item = await fetchHomeVoucherService("regular_customer");
      homeVouchers = item.obs;
    } finally {
      isLoadingCoupon.value = false;
    }
  }

  fetchCouponNewUser() async {
    try {
      isLoadingCouponNewUser.value = true;
      final item = await fetchHomeVoucherService("new_customer");
      homeVouchersNewUser = item.obs;
    } finally {
      isLoadingCouponNewUser.value = false;
    }
  }

  fetchLoadmore(int offset) async {
    try {
      isLoadingLoadmore.value = true;
      recommend = await fetctProductRecommendService(offset);
    } finally {
      isLoadingLoadmore.value = false;
    }
  }

  fetchCategory() async {
    try {
      isLoadingCategory.value = true;
      homeCategory = await fetchHomeCategoryService();
    } finally {
      isLoadingCategory.value = false;
    }
  }

  //? loadmore recommend
  Future<ProductRecommend?>? fetchMoreRecommend(offet) async {
    return await fetctProductRecommendService(offet);
  }

  // ? reset recommend
  void resetRecommend() {
    if (recommend != null && recommend!.data.length > 20) {
      recommend!.data = recommend!.data.sublist(0, 20);
    }
  }

  // ? loadmore flashsale
  Future<B2CFlashSale?>? fetchMoreFlashSale(offet) async {
    return await fetchFlashSaleHomeService(offet);
  }

  // ? reset flashsale
  void resetFlashSale() {
    if (flashSale != null && flashSale!.data.productContent.length > 20) {
      flashSale!.data.productContent =
          flashSale!.data.productContent.sublist(0, 20);
    }
  }
}
