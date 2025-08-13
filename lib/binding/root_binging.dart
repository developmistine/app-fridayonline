import 'package:appfridayecommerce/controller/app_controller.dart';
import 'package:appfridayecommerce/controller/log_analytics/log_analytics_ctr.dart';
import 'package:appfridayecommerce/enduser/controller/brand.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/cart.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/chat.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/coint.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/coupon.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/enduser.home.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/enduser.signin.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/fair.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/notify.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/order.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/review.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/search.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/showproduct.category.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/showproduct.sku.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/topproduct.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/track.ctr.dart';
import 'package:appfridayecommerce/enduser/views/(cart)/cart.main.dart';
import 'package:get/get.dart';
import '../controller/update_app_controller.dart';
import '../enduser/controller/category.ctr.dart';

class RootBinging implements Bindings {
  // ทำการ override dependencies ออกมา 1 ตัว
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(UpdateAppController());
    // log analytics
    Get.put(LogAnalyticsController());
    // enduser
    Get.put(EndUserSignInCtr());
    Get.put(EndUserHomeCtr());
    Get.put(ShowProductCategoryCtr());
    Get.put(ShowProductSkuCtr());
    Get.put(ReviewEndUserCtr());
    Get.put(EndUserCartCtr());
    Get.put(EndUserCouponCartCtr());
    Get.put(CheckboxController());
    Get.put(OrderController());
    Get.put(SearchProductCtr());
    Get.put(MyReviewCtr());
    Get.put(CategoryCtr());
    Get.put(TopProductsCtr());
    Get.put(BrandCtr());
    Get.put(TrackCtr());
    Get.put(NotifyController());
    Get.put(WebSocketController());
    Get.put(ChatController());
    Get.put(FairController());
    Get.put(CoinCtr());
  }
}
