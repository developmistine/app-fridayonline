import 'package:fridayonline/enduser/controller/brand.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/enduser/controller/track.ctr.dart';
import 'package:fridayonline/enduser/services/track/track.service.dart';
import 'package:fridayonline/print.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

class GetRouteLogger extends RouteObserver<PageRoute<dynamic>> {
  final Map<String, DateTime> _enterTimes = {};
  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is PopupRoute || route.settings.name == null) {
      return;
    }

    final currentName = route.settings.name ?? 'unknown';
    final previousName = previousRoute?.settings.name ?? 'unknown';

    printWhite("📍 [GetX] User navigated to: $currentName from $previousName");

    // ✅ ถ้ามี previousRoute ที่เคยเข้า → ต้องเก็บ log ก่อนเปลี่ยน
    if (previousRoute != null && previousName != 'unknown') {
      final enterTime = _enterTimes[previousName];
      if (enterTime != null && previousName.startsWith('/ShowProductSku')) {
        final duration = DateTime.now().difference(enterTime).inSeconds;
        _sendPageView(currentName, duration, previousName);
        _enterTimes.remove(previousName);
      }
    }
    // if (previousName == '/EndUserHome') {
    //   _handleLeaveEndUserHome();
    // }

    // ✅ จากนั้นเก็บเวลาเข้า route ใหม่
    _enterTimes[currentName] = DateTime.now();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route is PopupRoute || route.settings.name == null) {
      printWhite("🛑 [GetX] Skipped pop logging for Dialog or unnamed route");
      return;
    }

    final currentName = route.settings.name ?? 'unknown';
    final previousName = previousRoute!.settings.name ?? 'unknown';
    final enterTime = _enterTimes[currentName];

    if (previousName.startsWith('/BrandStore')) {
      var id = previousName.split('/').last.split('?').first;
      Get.find<BrandCtr>().resetVal();
      Get.find<BrandCtr>().fetchShopData(int.tryParse(id) ?? 0);
    } else if (previousName.startsWith('/ShowProductSku')) {
      var id = previousName.split('/').last;
      Get.find<ShowProductSkuCtr>()
          .fetchB2cProductDetail(id, Get.find<TrackCtr>().referrer ?? "");
    }
    if (enterTime != null) {
      final duration = DateTime.now().difference(enterTime).inSeconds;
      _sendPageView(currentName, duration, previousName);
      _enterTimes.remove(currentName);
    }
  }

  void _sendPageView(
      String routeName, int timeSpentSeconds, String previousRoute) {
    var sellerId = 0;
    var skipPage = [
      "unknown",
      "/SplashScreen",
      "/",
      "/EndUserProductMedias",
      "/ProductListPage",
      "/DevProductDetail",
      "/MyHomePage",
    ];
    if (skipPage.contains(routeName)) {
      return;
    }
    if (routeName.startsWith('/ShowProductSku')) {
      routeName = "/ShowProductSku";
    }
    if (routeName.startsWith('/BrandStore')) {
      sellerId = int.tryParse(Get.parameters['id'] ?? '0') ?? 0;
      routeName = "/BrandStore";
    }
    if (routeName.startsWith('/EndUserHome')) {
      routeName = "home_page";
    }
    if (previousRoute.startsWith('/EndUserHome')) {
      previousRoute = "home_page";
    }
    if (previousRoute.startsWith('/ShowProductSku')) {
      previousRoute = "/ShowProductSku";
    }
    if (routeName == '/OrderCheckout' || routeName == '/MyOrderDetail') {
      routeName = "order_detail_page";
    }
    routeName = renameRoute(routeName);

    var trackData = Get.find<TrackCtr>();
    if (trackData.trackContentId != null &&
        trackData.trackContentType != "" &&
        routeName != 'top_products_page' &&
        routeName != 'top_products_page' &&
        routeName != 'home_page') {
      setTrackContentViewServices(
              trackData.trackContentId!,
              trackData.trackContentTitle ?? "",
              trackData.trackContentType ?? "",
              timeSpentSeconds,
              sellerId: sellerId)
          .then((value) {
        Get.find<TrackCtr>().clearTrackData();
      });
    }
    if (routeName == 'product_detail_page') {
      trackData.trackContentId = trackData.productId;

      setTrackProductViewServices(
          trackData.shopId!,
          trackData.productId!,
          trackData.productName!,
          trackData.catId!,
          trackData.catName!,
          0,
          trackData.price!,
          setFormPage(trackData, previousRoute),
          trackData.referrer!,
          timeSpentSeconds);
    }
    setTrackPageViewServices('page_view', routeName, timeSpentSeconds,
            trackData.trackContentId ?? 0,
            sellerId: sellerId)
        .then((value) {
      if (routeName != 'home_page') {
        Get.find<TrackCtr>().clearTrackData();
      }
    });
  }

  List<String> homePage = [
    "home_banner",
    "home_favorite",
    "home_flashsale",
    "home_recommend",
    "home_popup",
    "home_popup_small"
  ];
  List<String> topProductPage = [
    "top_products_page",
  ];
  List<String> categoryPage = [
    "category_detail_page",
  ];
  List<String> shopDetailPage = [
    "brand_detail_page",
    'shop_content',
    'shop_flashsale'
  ];
  List<String> productBrandsPage = [
    "shop_product",
  ];
  List<String> searchProduct = [
    "search_product",
  ];

  String setFormPage(TrackCtr trackData, String previousRoute) {
    if (homePage.contains(trackData.referrer!)) {
      return "home_page";
    } else if (categoryPage.contains(trackData.referrer!)) {
      return "category_detail_page";
    } else if (topProductPage.contains(trackData.referrer!)) {
      return "top_products_page";
    } else if (shopDetailPage.contains(trackData.referrer!)) {
      return "brand_detail_page";
    } else if (productBrandsPage.contains(trackData.referrer!)) {
      return "product_brands_page";
    } else if (searchProduct.contains(trackData.referrer!)) {
      return "search_page";
    } else {
      return renameRoute(previousRoute);
    }
  }

  String renameRoute(String routeName) {
    switch (routeName) {
      case '/NotifyList':
        {
          routeName = 'notify_page';
          break;
        }
      case '/RegisterScreen':
        {
          routeName = 'register_page';
          break;
        }
      case '/ChatApp':
        {
          routeName = 'chat_page';
          break;
        }
      case '/ChatAppWithSeller':
        {
          routeName = 'chat_seller';
          break;
        }
      case '/ChatAppWithPlatform':
        {
          routeName = 'chat_platform';
          break;
        }
      case '/ShowReviewProductSku':
        {
          routeName = 'review_page';
          break;
        }
      case '/MyReview':
        {
          routeName = 'my_review';
          break;
        }
      case '/EditRating':
        {
          routeName = 'edit_review';
          break;
        }
      case '/SignInScreen':
        {
          routeName = 'login_page';
          break;
        }
      case '/EndUserCart':
        {
          routeName = 'cart_page';
          break;
        }
      case '/EndUserHomePage':
        {
          routeName = 'profile_page';
          break;
        }
      case '/EndUserCartSummary':
        {
          routeName = 'cart_ordersummary_page';
          break;
        }
      case '/EndUserSearch':
        {
          routeName = 'search_page';
          break;
        }
      case '/FlashSaleEndUser':
        {
          routeName = 'flashsale_page';
          break;
        }
      case '/SubCategory':
        {
          routeName = 'category_detail_page';
          break;
        }
      case '/ShortMenuAll':
        {
          routeName = 'keyicon_page';
          break;
        }
      case '/EndUserSearchResult':
        {
          routeName = 'search_result';
          break;
        }
      case '/CouponAll':
        {
          routeName = 'coupon_page';
          break;
        }
      case '/CouponMe':
        {
          routeName = 'couponme_page';
          break;
        }
      case '/BrandStore':
        {
          routeName = 'brand_detail_page';
          break;
        }
      case '/TopProductsWeekly':
        {
          routeName = 'top_products_page';
          break;
        }
      case '/ShowProductSku':
        {
          routeName = 'product_detail_page';
          break;
        }
      case '/MyOrderHistory':
        {
          routeName = 'myorder_page';
          break;
        }
      case '/MyOrderDetail':
        {
          routeName = 'order_detail_page';
          break;
        }
      case '/Settings':
        {
          routeName = 'profile_settings_page';
          break;
        }
      case '/EditProfile':
        {
          routeName = 'profile_edit_page';
          break;
        }
      case '/MyAddress':
        {
          routeName = 'myaddress_page';
          break;
        }
      case '/Instructions':
        {
          routeName = 'about_policy_page';
          break;
        }
      case '/VersionApp':
        {
          routeName = 'version_page';
          break;
        }
      case '/DeleteAccount':
        {
          routeName = 'delete_account_page';
          break;
        }
      case '/ShippingDetail':
        {
          routeName = 'shipping_detail_page';
          break;
        }
      case '/HelpFriday':
        {
          routeName = 'help_page';
          break;
        }
      case '/AllBrandB2C':
        {
          routeName = 'brand_all_page';
          break;
        }
      case '/ShowProductCategory':
        {
          routeName = 'category_detail_page';
          break;
        }
      case '/EndUserChangePayment':
        {
          routeName = 'change_payment_page';
          break;
        }
      case '/ShowProductBrands':
        {
          routeName = 'product_brands_page';
          break;
        }
      case '/ShopFlashSale':
        {
          routeName = 'brand_flashsale_page';
          break;
        }
      case '/EndUserCartCoupon':
        {
          routeName = 'cart_coupon_page';
          break;
        }
      case '/CouponDetail':
        {
          routeName = 'coupon_detail_page';
          break;
        }
      case '/BundleProducts':
        {
          routeName = 'bundle_products_page';
          break;
        }
      default:
        {
          break;
        }
    }
    return routeName;
  }
}
