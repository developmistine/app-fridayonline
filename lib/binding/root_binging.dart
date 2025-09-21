import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/controller/log_analytics/log_analytics_ctr.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.product.ctr.dart';
import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/controller/chat.ctr.dart';
import 'package:fridayonline/member/controller/coint.ctr.dart';
import 'package:fridayonline/member/controller/coupon.ctr.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/member/controller/fair.ctr.dart';
import 'package:fridayonline/member/controller/notify.ctr.dart';
import 'package:fridayonline/member/controller/order.ctr.dart';
import 'package:fridayonline/member/controller/review.ctr.dart';
import 'package:fridayonline/member/controller/search.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.category.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/controller/topproduct.ctr.dart';
import 'package:fridayonline/member/controller/track.ctr.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:get/get.dart';
import '../controller/update_app_controller.dart';
import '../member/controller/category.ctr.dart';

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
    //affiliate
    Get.put(AffiliateAccountCtr());
    Get.put(AffiliateContentCtr());
    Get.put(AffiliateProductCtr());
  }
}
