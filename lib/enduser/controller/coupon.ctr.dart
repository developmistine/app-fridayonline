import 'package:fridayonline/enduser/models/cart/cart.update.output.dart';
import 'package:fridayonline/enduser/models/cart/cart.update.input.dart'
    as update_input;
import 'package:fridayonline/enduser/models/coupon/vouchers.recommend.model.dart';
import 'package:get/get.dart';

class EndUserCouponCartCtr extends GetxController {
  RxBool isShowMore = false.obs;
  RxMap<int, bool> isLoadingCouponShop = <int, bool>{}.obs;
  RxMap<int, int?> selectedCoupon = <int, int?>{}.obs;

  RxInt couponPlatformId = 0.obs;
  RxInt couponShopId = 0.obs;

  Rxn<List<ShopVoucher>> shopVouchers = Rxn();
  Rxn<List<DataShopVoucher>> shopVouchersUpdate = Rxn();
  Rx<String> shopName = "".obs;
  Rx<int> shopId = 0.obs;
  RxBool showClaimedCoupon = false.obs;
  RxInt indexClick = 0.obs;
  update_input.PromotionData promotionData = update_input.PromotionData(
      platformVouchers: [],
      shopVouchers: [],
      unusedPlatformVoucher: true,
      freeShipping: []);
  update_input.PromotionData promotionDataCheckOut = update_input.PromotionData(
      platformVouchers: [],
      shopVouchers: [],
      unusedPlatformVoucher: true,
      freeShipping: []);

  List<update_input.ShopVoucher> promotionShop = [];
  Rxn<List<CartDetail>> discountVoucher = Rxn([]);

  setshowClaimedCoupon() {
    showClaimedCoupon.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      showClaimedCoupon.value = false;
    });
  }

  setshowClaimedCouponHome(int id) {
    showClaimedCoupon.value = true;
    indexClick.value = id;
    Future.delayed(const Duration(seconds: 1), () {
      showClaimedCoupon.value = false;
      indexClick.value = 0;
    });
  }

  clearVal() {
    shopName.value = "";
    shopId.value = 0;
    couponPlatformId.value = 0;
    couponShopId.value = 0;
    selectedCoupon.clear();
    shopVouchers = Rxn();
    shopVouchersUpdate = Rxn();
    promotionData = update_input.PromotionData(
        platformVouchers: [],
        shopVouchers: [],
        unusedPlatformVoucher: true,
        freeShipping: []);
    promotionDataCheckOut = update_input.PromotionData(
        platformVouchers: [],
        shopVouchers: [],
        unusedPlatformVoucher: true,
        freeShipping: []);
    promotionShop = [];
    discountVoucher = Rxn([]);
  }
}
