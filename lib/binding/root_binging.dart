import 'package:fridayonline/controller/address/address_controller.dart';
import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/controller/cart/cart_address_enduser_controller.dart';
import 'package:fridayonline/controller/cart/cart_cheer_controller.dart';
import 'package:fridayonline/controller/cart/cart_controller.dart';
import 'package:fridayonline/controller/cart/coupon_discount_controller.dart';
import 'package:fridayonline/controller/cart/delivery_controller.dart';
import 'package:fridayonline/controller/cart/point_controller.dart';
import 'package:fridayonline/controller/cart/star_controller.dart';
import 'package:fridayonline/controller/category/category_controller.dart';
import 'package:fridayonline/controller/catelog/catelog_controller.dart';
import 'package:fridayonline/controller/check_information/check_information_controller.dart';
import 'package:fridayonline/controller/home/home_controller.dart';
import 'package:fridayonline/controller/log_analytics/log_analytics_ctr.dart';
import 'package:fridayonline/controller/pro_filecontroller.dart';
import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/controller/reviews/revies_ctr.dart';
import 'package:fridayonline/controller/search_product/search_controller.dart';
import 'package:fridayonline/enduser/controller/brand.ctr.dart';
import 'package:fridayonline/enduser/controller/cart.ctr.dart';
import 'package:fridayonline/enduser/controller/chat.ctr.dart';
import 'package:fridayonline/enduser/controller/coint.ctr.dart';
import 'package:fridayonline/enduser/controller/coupon.ctr.dart';
import 'package:fridayonline/enduser/controller/enduser.home.ctr.dart';
import 'package:fridayonline/enduser/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/enduser/controller/fair.ctr.dart';
import 'package:fridayonline/enduser/controller/notify.ctr.dart';
import 'package:fridayonline/enduser/controller/order.ctr.dart';
import 'package:fridayonline/enduser/controller/review.ctr.dart';
import 'package:fridayonline/enduser/controller/search.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.category.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/enduser/controller/topproduct.ctr.dart';
import 'package:fridayonline/enduser/controller/track.ctr.dart';
import 'package:fridayonline/enduser/views/(cart)/cart.main.dart';
import 'package:get/get.dart';
import '../controller/badger/badger_controller.dart';
import '../controller/cart/cart_address_controller.dart';
// import '../controller/cart/coupon_discount_controller.dart';
import '../controller/cart/dropship_controller.dart';
import '../controller/cart/save_order_controller.dart';
import '../controller/flashsale/flash_controller.dart';
import '../controller/lead/lead_controller.dart';
import '../controller/market/market_controller.dart';
import '../controller/market/market_loadmore_controller.dart';
import '../controller/notification/notification_controller.dart';
import '../controller/point_rewards/point_rewards_controller.dart';
import '../controller/return_product_controller.dart';
import '../controller/update_app_controller.dart';
import '../enduser/controller/category.ctr.dart';

class RootBinging implements Bindings {
  // ทำการ override dependencies ออกมา 1 ตัว
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(AppController());
    Get.put(FlashsaleTimerCount());
    // *** page category
    Get.put(
        CategoryProductlistController()); // get product in category ตามประเภทที่เลือก
    Get.put(CategoryMenuController()); // get menu list in category
    Get.put(
        CategoryProductDetailController()); // get detail for show webview product
    // *** end page category

    // *** page webview
    Get.put(Category_getData_webview_controller()); // !get data from webview

    // *** End page webview
    //? search product
    Get.put(ShowSearchProductController()); // get detail for search product
    Get.put(ShowPopularProductController()); // get popular for search
    //? end search
    //  *** PageCart
    Get.put(CartItemsEdit()); //! call for edit cart shopping
    Get.put(DropshipEditCart()); //! call for edit cart dropship shopping
    Get.put(FetchCartItemsController()); //! call for fetch cart shopping
    Get.put(FetchPointMember()); //! call for fetch point
    Get.put(FetchCouponDiscount());
    Get.put(FetchCartEndUsersAddress()); //! call for fetch cart address
    Get.put(FetchStar()); //! start call
    Get.put(FetchCartNotiAddress()); //! call for fetch cart address
    Get.put(FetchDeliveryChange()); //! call for fetch delivery change
    Get.put(SaveOrderController()); //! call to save order
    Get.put(SaveOrderDropship()); //! call to save order dropship
    Get.put(FetchCartDropshipController()); //? call product dropship
    Get.put(CheerCartCtr()); //? call product dropship
    // *** end
    //******Point Rewards******* */
    Get.put(SearchPointRewardsController());
    Get.put(PointRewardsCategoryListConfirm());
    Get.put(OtpTimerController());
    /****************** */

    //******Check Information******* */
    Get.put(EndUserOrderCtr());

    //******Market******* */
    Get.put(MarketController());
    Get.put(MarketLoadmoreController());
    /****************** */

    /******Badger********/
    Get.put(BadgerController());
    Get.put(BadgerProfileController());
    /******Badger********/
    /******NotificationController*******/
    Get.put(NotificationController());
    Get.put(NotificationPromotionListController());
    /******Badger********/

    // Get coupon MSL

    //page catelog =====================================
    Get.put(CatelogController()); //ใช้ get catelog
    Get.put(CatelogDetailController()); //ใช้ get รายละเอียด catelog
    Get.put(
        CatelogSetFirstPageController()); // ใช้ set firts page สำหรับแสดงหน้า catelog
    Get.put(
        CatelogListProductByPageController()); // ใช้ get สินค้าที่อยู่ในแต่ละหน้าของหน้า catelog
    // =================================================

    Get.put(ProfileController()); // เป็น Controller
    Get.put(ProfileSpecialProjectController()); // เป็น Controller
    Get.put(ProductDetailController());

    //page home ==============================================
    Get.put((ProductFromBanner)); //get banner and product fron banner
    Get.put((FavoriteGetProductController)); //get favorite items
    Get.put(FavoriteItemController()); // get favorite
    Get.put(DraggableFabController());
    Get.put(ReviewsCtr());
    Get.put(BannerController()); //get banner items
    Get.put(FavoriteController()); //get favorite items
    Get.put(SpecialPromotionController()); //ใช้ get ค่า special promotion
    //Get.put(SpecialDiscountController()); //ใช้ get ค่า special content
    // Get.put(
    //     SpecialDiscountLoadMoreController()); //ใช้ get ค่า special content load more
    Get.put(ProductHotItemHomeController()); //ใช้ get ค่า ProductHotItemHome
    Get.put(ProductHotIutemLoadmoreController());
    Get.put(PopUpStatusController());
    Get.put(KeyIconController());
    Get.put(HomePointController());
    Get.put(HomePointController());
    Get.put(HomeContentSpecialListController());
    // =======================================================

    //profile page ============================================
    Get.put(SetSelectInformation()); //ใช้ set tap bar หน้า check information
    Get.put(
        CheckInformationOrderOrderAllController()); //ใช้สำหรับจัดการรายการสั่งซื้อ
    Get.put(
        CheckInformationDeliveryStatusController()); //ใช้สำหรับเรียกข้อมูลสถานะการจัดส่ง
    Get.put(
        CheckInformationOrderHistoryController()); //ใช้สำหรับเรียกข้อมูลประวัติรายการสั่งซื้อ
    Get.put(ApproveOrderController());
    Get.put(PayMentController());
    // =======================================================
    //update app
    Get.put(UpdateAppController());

    //lead
    Get.put(LeadRegisterController());
    Get.put(ProfileLeadController());

    // return product
    Get.put(ReturnProductController());

    // log analytics
    Get.put(LogAnalyticsController());

    //address
    Get.put(AddressController());

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
