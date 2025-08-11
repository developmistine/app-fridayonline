import 'package:fridayonline/controller/address/address_controller.dart';
import 'package:fridayonline/controller/cart/cart_address_enduser_controller.dart';
import 'package:fridayonline/controller/cart/cart_cheer_controller.dart';
import 'package:fridayonline/controller/cart/cart_controller.dart';
import 'package:fridayonline/controller/cart/cart_payment_type.dart';
import 'package:fridayonline/controller/cart/coupon_discount_controller.dart';
import 'package:fridayonline/controller/cart/dropship_controller.dart';
import 'package:fridayonline/controller/category/category_controller.dart';
import 'package:fridayonline/controller/home/home_controller.dart';
import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/homepage/flashsale/flashsale_detail.dart';
import 'package:fridayonline/homepage/home/home_new/home_more_special/home_special_project.dart';
import 'package:fridayonline/homepage/home/home_special_promotion_bwpoint.dart';
import 'package:fridayonline/homepage/page_showproduct/List_product.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_page/cart_endusers_change_address.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_page/cart_msl_change_address.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_widget/cart_coupon_discount.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_widget/cart_friday_order.dart';
import 'package:fridayonline/homepage/theme/formatter_text.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/webview/webview_app.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:fridayonline/homepage/widget/appbar_cart_share.dart';
import 'package:fridayonline/model/cart/cart_getItems.dart';
import 'package:fridayonline/model/cart/cart_popup_nocat.dart';
import 'package:fridayonline/model/cart/coupon_discount.dart';
import 'package:fridayonline/model/flashsale/flashsale.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/safearea.dart';
import 'package:fridayonline/service/cart/coupon_discount_service.dart';
import 'package:fridayonline/service/cart/popup_cart/getcart_popup_nocat_service.dart';
import 'package:fridayonline/service/flashsale/flashsale_service.dart';
import 'package:fridayonline/service/logapp/logapp_service.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controller/cart/cart_address_controller.dart';
import '../../../../controller/cart/delivery_controller.dart';
import '../../../../controller/cart/point_controller.dart';
import '../../../../controller/cart/star_controller.dart';
import '../../../../controller/point_rewards/point_rewards_controller.dart';
import '../../../../service/languages/multi_languages.dart';
import '../../../widget/appbarmaster.dart';
import '../cart_widget/cart_bottom_confirm.dart';
import '../cart_widget/cart_delivery_change.dart';
import '../cart_widget/cart_head_firday.dart';
import '../cart_widget/cart_point.dart';

final ctrPaymentType = Get.put(PaymentTypeCtr());
final ctrAddress = Get.find<FetchCartEndUsersAddress>();
final ctrDelevery = Get.find<FetchDeliveryChange>();
final ctrCoupon = Get.find<FetchCouponDiscount>();
final getCartCtr = Get.find<FetchCartItemsController>();

class CartOrderSummary extends StatefulWidget {
  const CartOrderSummary(this.order, this.orderDropship, this.inputors,
      this.inputorsDropship, this.typeUserPass,
      {super.key});

  final String? typeUserPass;
  final FetchCartItemsController order;
  final FetchCartDropshipController orderDropship;
  final List<TextEditingController> inputors;
  final List<TextEditingController> inputorsDropship;

  @override
  State<CartOrderSummary> createState() => _CartOrderSummaryState();
}

class _CartOrderSummaryState extends State<CartOrderSummary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? userType;

  Map<String, TextEditingController> controllers = {};

  bool isShowDiscount = false;

  setType() async {
    setState(() {
      userType = widget.typeUserPass;
    });
    if (userType == '1') {
      Get.find<FetchStar>().fetchstar(); // get star
    } else if (userType == '2') {
      Get.find<FetchPointMember>().fetchPoint(); // get point
      ctrPaymentType.getPaymentType();
    }
  }

  fetchData() async {
    if (userType == '2') {
      Get.find<FetchCartNotiAddress>().fetchNotiAddress();
      Get.find<AddressController>().fetchAddressSaveOrder();
      Get.find<CheerCartCtr>().fetchCartCheerBanner(
          widget.order.itemsCartList!.cardHeader.campaign);
      CouponDiscount? coupon = await GetCouponDiscount();
      final cartPopupNocat = await getCartPopupNocat();
      if (coupon!.isPopUp) {
        Couponlist selectedCoupon;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          modalCoupon(coupon)
              .then((_) => {
                    selectedCoupon = coupon.couponlist
                        .firstWhere((element) => element.couponDefault == true),
                    ctrCoupon.setCouponList(
                        selectedCoupon.couponId,
                        selectedCoupon.couponName,
                        selectedCoupon.price,
                        selectedCoupon.categoryCoupon)
                  })
              .then((_) => {popupNoCat(cartPopupNocat)});
        });
      } else {
        popupNoCat(cartPopupNocat);
      }
    }
  }

  void popupNoCat(PopupCartNocat? cartPopupNocat) {
    if (cartPopupNocat!.isShowPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        bool isChecked = false;
        final Future<SharedPreferences> preferences =
            SharedPreferences.getInstance();
        final SharedPreferences prefs = await preferences;

        DateTime now = DateTime.now();
        // prefs.remove("ShowPopupNoCat");
        String date = '${now.year}-${now.month}-${now.day}';
        String showPopupNoCat = prefs.getString("ShowPopupNoCat") ?? "";
        if (date != showPopupNoCat) {
          return Get.dialog(
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.5),
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: AlertDialog(
                  elevation: 0,
                  contentPadding: EdgeInsets.zero,
                  actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  content: SizedBox(
                    height: Get.height / 3,
                    width: Get.width,
                    child: CarouselSlider.builder(
                      itemCount: cartPopupNocat.popupList.length,
                      initialPage: 0,
                      slideBuilder: (index) {
                        return GestureDetector(
                          onTap: () async {
                            var mchannel = '17';
                            SetData userData = SetData();
                            var mchannelId =
                                cartPopupNocat.popupList[index].popupSeq;
                            var popupType =
                                cartPopupNocat.popupList[index].popupType;
                            LogAppTisCall(mchannel, mchannelId);
                            if (popupType.toLowerCase() == "url") {
                              Navigator.pop(context);
                              Get.to(() => WebViewFullScreen(
                                  mparamurl: cartPopupNocat
                                      .popupList[index].popupParam));
                            } else if (popupType.toLowerCase() ==
                                'coupon_rewards') {
                              String? urlContent =
                                  "${base_url_web_fridayth}bwpoint/product?billCode=${cartPopupNocat.popupList[index].popupParam}";

                              Get.to(() => webview_app(
                                  mparamurl: urlContent,
                                  mparamTitleName: MultiLanguages.of(context)!
                                      .translate('point_titleView'),
                                  mparamType: "rewards_detail",
                                  mparamValue: cartPopupNocat
                                      .popupList[index].popupParam));
                            } else if (popupType.toLowerCase() == 'category') {
                              ProductFromBanner bannerProduct =
                                  Get.put(ProductFromBanner());
                              bannerProduct.fetch_product_banner(
                                  cartPopupNocat.popupList[index].popupParam,
                                  '');
                              Get.find<CategoryProductlistController>()
                                  .fetch_product_category_byperson(
                                      cartPopupNocat
                                          .popupList[index].popupParam,
                                      "");
                              Get.toNamed('/my_list_category', parameters: {
                                'mChannel': mchannel,
                                'mChannelId': mchannelId,
                                'mTypeBack': '',
                                'mTypeGroup': 'category',
                                'ref': 'product',
                                'contentId': ''
                              });
                            } else if (popupType.toLowerCase() == 'sku') {
                              Get.find<ProductDetailController>()
                                  .productDetailController(
                                "",
                                cartPopupNocat.popupList[index].popupParam,
                                "",
                                cartPopupNocat.popupList[index].popupParam,
                                mchannel,
                                cartPopupNocat.popupList[index].popupParam,
                              );
                              Get.to(() => ProductDetailPage(
                                    ref: 'popup',
                                    contentId: mchannelId,
                                  ));
                              // });
                            } else if (popupType.toLowerCase() ==
                                'sharecatalog') {
                              Get.toNamed('/sharecatalog');
                            } else if (popupType.toLowerCase() ==
                                "coupon_popup") {
                              var repCode = await userData.repCode;
                              var repSeq = await userData.repSeq;
                              var repType = await userData.repType;
                              var tokenApp = await userData.tokenId;
                              var couponId =
                                  cartPopupNocat.popupList[index].popupParam;
                              var url =
                                  "${sp_fridayth}webnew/RecieveCoupon?couponId=$couponId&RepCode=$repCode&RepSeq=$repSeq&RepType=$repType&Token=$tokenApp";
                              Get.to(() => WebViewFullScreen(mparamurl: url));
                            } else {
                              return;
                            }
                          },
                          child: CachedNetworkImage(
                            imageUrl: cartPopupNocat.popupList[index].popupImg,
                            alignment: Alignment.center,
                          ),
                        );
                      },
                      slideTransform: const DefaultTransform(),
                      autoSliderTransitionTime:
                          const Duration(milliseconds: 400),
                      unlimitedMode:
                          cartPopupNocat.popupList.length > 1 ? true : false,
                      enableAutoSlider:
                          cartPopupNocat.popupList.length > 1 ? true : false,
                      slideIndicator: cartPopupNocat.popupList.length > 1
                          ? CircularSlideIndicator(
                              indicatorRadius: 3,
                              itemSpacing: 10,
                              padding: const EdgeInsets.only(top: 20),
                              currentIndicatorColor: Colors.red,
                              indicatorBackgroundColor: Colors.grey)
                          : CircularSlideIndicator(
                              itemSpacing: 10,
                              padding: const EdgeInsets.only(top: 20),
                              currentIndicatorColor: Colors.transparent,
                              indicatorBackgroundColor: Colors.transparent),
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                if (isChecked == true) {
                                  isChecked = false;
                                } else {
                                  isChecked = true;
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 15,
                                  height: 8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.white, width: 2)),
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: const Color(0XFFFD7F6B),
                                    side: const BorderSide(
                                        color: Color(0XFFFD7F6B), width: 2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text('ไม่ต้องแสดงอีกในวันนี้',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () async {
                            if (isChecked == true) {
                              DateTime now = DateTime.now();
                              String date =
                                  '${now.year}-${now.month}-${now.day}';
                              prefs.setString("ShowPopupNoCat", date);
                            }
                            Get.back();
                          },
                          child: const Text(
                            'ปิด',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setType();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    ctrCoupon.setEmptyCouponList();
  }

  modalCoupon(CouponDiscount coupon) {
    return Get.bottomSheet(
        isDismissible: false,
        MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 14),
                    child: Image.network(
                      coupon.imgPopUp,
                      width: 180,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 14),
                    child: Center(
                      child: Text(coupon.textPopUp,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12),
                    child: SizedBox(
                        width: Get.width,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('กดรับส่วนลด',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                  ),
                  const SizedBox(height: 12),
                ],
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaProvider(
      child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          // resizeToAvoidBottomInset: false,
          appBar: appBarTitleMaster(
              MultiLanguages.of(context)!.translate('order_summary_title')),
          body: WillPopScope(
            onWillPop: () async {
              await ctrCoupon.setEmptyCouponList();
              FetchCartDropshipController controller =
                  Get.find<FetchCartDropshipController>();
              for (var element
                  in controller.itemDropship!.cartHeader.cartDetail) {
                element.isChecked = false;
              }
              return true;
            },
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (userType == '1')
                      Obx(() {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      ctrAddress.selectedAddress.value = 0;
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: ctrAddress.selectedAddress
                                                        .value ==
                                                    0
                                                ? theme_color_df
                                                : Colors.white,
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'รับสินค้าเอง',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: ctrAddress
                                                      .selectedAddress.value ==
                                                  0
                                              ? theme_color_df
                                              : Colors.black,
                                          fontWeight: ctrAddress
                                                      .selectedAddress.value ==
                                                  0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      ctrAddress.selectedAddress.value = 1;
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: ctrAddress.selectedAddress
                                                        .value ==
                                                    1
                                                ? theme_color_df
                                                : Colors.white,
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'รับสินค้ากับสมาชิกผู้ขาย',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: ctrAddress
                                                      .selectedAddress.value ==
                                                  1
                                              ? theme_color_df
                                              : Colors.black,
                                          fontWeight: ctrAddress
                                                      .selectedAddress.value ==
                                                  1
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ctrAddress.selectedAddress.value == 0
                                ? Column(
                                    children: [
                                      notiHeaderEndUser(
                                          msg:
                                              "คำสั่งซื้อนี้ จัดส่งและชำระเงินปลายทาง ตามข้อมูลที่อยู่ที่ท่านเลือกด้านล่าง",
                                          des:
                                              "โปรดตรวจสอบก่อนยืนยันคำสั่งซื้อ"),
                                      const EndUsersAddAddress(),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      notiHeaderEndUser(
                                          msg:
                                              "ท่านสามารถติดตามคำสั่งซื้อ รับสินค้าและชำระเงินกับสมาชิก",
                                          des:
                                              "โปรดตรวจสอบข้อมูลก่อนยืนยันคำสั่งซื้อ"),
                                      mslRecieveEnd(),
                                    ],
                                  )
                          ],
                        );
                      }),

                    if (userType == '2')
                      // noti header
                      // const NotiHeader(),
                      if (userType == '2')
                        // address header
                        addressHeaderMsl(
                            widget.order.itemsCartList!.cardHeader.campaign),
                    // if (userType == '2')
                    //   Container(
                    //     height: 12,
                    //     color: Colors.grey[50],
                    //   ),
                    if (widget
                        .order.itemsCartList!.cardHeader.carddetail.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.all(8),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            headFriday(
                                context,
                                userType,
                                widget.order.itemsCartList!.cardHeader
                                    .deliveryDate),
                            Divider(
                              color: theme_color_df,
                              height: 1,
                              thickness: 1,
                            ),
                            showProductDirecsale(),
                          ],
                        ),
                      ),
                    if (widget.order.itemsCartList!.cardHeader.carddetailB2C
                        .isNotEmpty)
                      showProductSupplier(),

                    if (userType == '2')
                      // ตัวเลือกจัดส่ง
                      deliveryChange(context,
                          widget.order.itemsCartList!.cardHeader.totalAmount),
                    // widget จัดการคะแนน
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      clipBehavior: Clip.antiAlias,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: PointMethod(
                          widget.order.itemsCartList!.cardHeader.totalAmount),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    if (userType == '2')
                      // คูปองส่วนลด
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: couponDiscount(context,
                            widget.order.itemsCartList!.cardHeader.totalAmount),
                      ),
                    if (userType == '2')
                      const SizedBox(
                        height: 8,
                      ),
                    if (userType == '2')
                      GetX<CheerCartCtr>(builder: (banner) {
                        if (banner.isBannerLoading.value) {
                          return const SizedBox();
                        } else {
                          var header = banner.cartCheerBanner!.header;
                          var title = banner.cartCheerBanner!.title;
                          return banner.cartCheerBanner!.bannerDetail.isEmpty
                              ? const SizedBox()
                              : MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                    textScaler: const TextScaler.linear(1.0),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 8, left: 8, right: 8),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            header,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            title,
                                            style: TextStyle(
                                                color: theme_grey_text),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              String media = banner
                                                  .cartCheerBanner!
                                                  .bannerDetail[0]
                                                  .keyindex;

                                              String contentIndex = banner
                                                  .cartCheerBanner!
                                                  .bannerDetail[0]
                                                  .contentIndex;
                                              switch (media) {
                                                case "category":
                                                  {
                                                    var channel = "27";
                                                    var channelId = "";
                                                    LogAppTisCall(channel, "");
                                                    Get.find<
                                                            ProductFromBanner>()
                                                        .fetch_product_banner(
                                                            banner
                                                                .cartCheerBanner!
                                                                .bannerDetail[0]
                                                                .contentIndex,
                                                            "");
                                                    Get.to(
                                                      () => Scaffold(
                                                          appBar: appbarShare(
                                                              MultiLanguages.of(
                                                                      context)!
                                                                  .translate(
                                                                      'home_page_list_products'),
                                                              "cheering",
                                                              channel,
                                                              channelId),
                                                          body: WillPopScope(
                                                            onWillPop:
                                                                () async {
                                                              Get.until((route) => (Get
                                                                          .currentRoute ==
                                                                      '/Cart' ||
                                                                  Get.currentRoute ==
                                                                      '/cart_activity' ||
                                                                  Get.currentRoute ==
                                                                      '/show_case_cart_activity'));
                                                              return true;
                                                            },
                                                            child: Obx(() => Get
                                                                        .find<
                                                                            ProductFromBanner>()
                                                                    .isDataLoading
                                                                    .value
                                                                ? const Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  )
                                                                : showList(
                                                                    Get.find<
                                                                            ProductFromBanner>()
                                                                        .BannerProduct!
                                                                        .skucode,
                                                                    "27",
                                                                    "",
                                                                    ref: '',
                                                                    contentId:
                                                                        '',
                                                                  )),
                                                          )),
                                                    );
                                                    break;
                                                  }
                                                case "sku":
                                                  {
                                                    Get.find<
                                                            ProductDetailController>()
                                                        .productDetailController(
                                                      banner
                                                          .cartCheerBanner!
                                                          .bannerDetail[0]
                                                          .campaign,
                                                      contentIndex,
                                                      "",
                                                      banner
                                                          .cartCheerBanner!
                                                          .bannerDetail[0]
                                                          .fsCode,
                                                      "",
                                                      "",
                                                    );
                                                    Get.off(() =>
                                                        const ProductDetailPage(
                                                          ref: '',
                                                          contentId: '',
                                                        ));
                                                    break;
                                                  }
                                                case "coupon_rewards":
                                                  {
                                                    final urlContent =
                                                        "${base_url_web_fridayth}bwpoint/product?billCode=$contentIndex";
                                                    Get.to(() => webview_app(
                                                        mparamurl: urlContent,
                                                        mparamTitleName:
                                                            MultiLanguages
                                                                    .of(
                                                                        context)!
                                                                .translate(
                                                                    'point_titleView'),
                                                        mparamType:
                                                            "rewards_detail",
                                                        mparamValue:
                                                            contentIndex,
                                                        type: 'home'));
                                                    break;
                                                  }
                                                case "image":
                                                  {
                                                    break;
                                                  }
                                                case "url":
                                                  {
                                                    Get.to(() =>
                                                        WebViewFullScreen(
                                                            mparamurl:
                                                                contentIndex));
                                                    break;
                                                  }
                                                case "sharecatalog":
                                                  {
                                                    Get.toNamed(
                                                        '/sharecatalog');
                                                    break;
                                                  }
                                                case "extra":
                                                  {
                                                    Get.to(() =>
                                                        const HomeSpecialProject());

                                                    break;
                                                  }
                                                case "flashsale":
                                                  {
                                                    Flashsale? flashSaleData =
                                                        await FlashsaleHomeService();
                                                    if (flashSaleData!
                                                        .flashSale.isNotEmpty) {
                                                      Get.off(
                                                          () => FlashSaleDetail(
                                                                contentId:
                                                                    flashSaleData
                                                                        .flashSale[
                                                                            0]
                                                                        .id,
                                                              ));
                                                    } else {
                                                      SchedulerBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                titlePadding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 20,
                                                                        bottom:
                                                                            0),
                                                                actionsPadding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                actionsAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                title: Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  "แจ้งเตือน",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          theme_color_df),
                                                                ),
                                                                content: const Text(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    'ขออภัยค่ะ\nขณะนี้ Flash Sale ยังไม่เปิด'),
                                                                actions: [
                                                                  const Divider(
                                                                    color: Color(
                                                                        0XFFD9D9D9),
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Center(
                                                                      child: Text(
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          'ปิด',
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: theme_color_df)),
                                                                    ),
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      });
                                                      debugPrint('ยังไม่เปิด');
                                                    }
                                                    break;
                                                  }
                                                case "bwpoint":
                                                  {
                                                    Get.off(() =>
                                                        const SpecialPromotionBwpoint(
                                                            type: 'push'));
                                                    break;
                                                  }
                                                default:
                                                  {
                                                    Get.offNamed("/");
                                                    break;
                                                  }
                                              }
                                            },
                                            child: CachedNetworkImage(
                                                imageUrl: banner
                                                    .cartCheerBanner!
                                                    .bannerDetail[0]
                                                    .contentImg),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                        }
                      }),
                    Container(
                        margin:
                            const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: totalBillFriday(context)),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: bottomConfirm(context, true, 'pay', widget.inputorsDropship,
                widget.inputors, widget.typeUserPass),
          )),
    );
  }

//? ส่งฟรี dropship
  Column deliveryDropship() {
    return Column(
      children: [
        Container(
          color: const Color.fromRGBO(228, 243, 251, 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/cart/car.png',
                          width: 40,
                          scale: 1.5,
                        ),
                        Text(
                          'จัดส่งด่วน 3-5 วัน',
                          style: setTextColordf,
                        ),
                      ],
                    ),
                    Text(
                      'จัดส่งฟรี',
                      style: setTextColordf,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

// widget แสดงข้อมูลสินค้าที่จะสั่งซื้อ Directsale
  showProductDirecsale() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            itemCount: widget.order.itemsCartList!.cardHeader.carddetail.length,
            itemBuilder: (BuildContext context, int index) {
              return listCart(
                  _scaffoldKey, context, widget.inputors, index, false);
              // return FridayList(
              //     widget.order, index, false, widget.inputors, _scaffoldKey);
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1,
              height: 0,
              color: DividerThemeColor,
            ),
          ),
          summaryShop(widget.order.itemsCartList!.cardHeader.carddetail,
              context, userType)
        ],
      ),
    );
  }

  showProductSupplier() {
    var suppliers = widget.order.itemsCartList!.cardHeader.carddetailB2C;
    // Initialize controllers for each product
    for (var supplier in suppliers) {
      for (var product in supplier.carddetail) {
        controllers[product.billCode] = TextEditingController(
          text: product.qtyConfirm.toString(),
        );
      }
    }
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.zero,
      itemCount: suppliers.length,
      itemBuilder: (BuildContext context, int index) {
        var supplier =
            widget.order.itemsCartList!.cardHeader.carddetailB2C[index];

        return Container(
          margin: EdgeInsets.only(
              bottom: 8,
              left: 8,
              right: 8,
              top: widget.order.itemsCartList!.cardHeader.carddetail.isEmpty &&
                      index == 0
                  ? 8
                  : 0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headSupplier(
                  context,
                  userType,
                  widget.order.itemsCartList!.cardHeader.deliveryDate,
                  supplier),
              Divider(
                color: theme_color_df,
                height: 1,
                thickness: 1,
              ),
              ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: supplier.carddetail.length,
                  itemBuilder: (BuildContext context, int productIndex) {
                    final product = supplier.carddetail[productIndex];
                    final controller = controllers[product.billCode];

                    return listCartB2C(
                        _scaffoldKey, context, controller!, product, false);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: theme_color_df,
                      height: 0,
                    );
                  }),
              summaryShopSupplier(supplier, context, userType)
            ],
          ),
        );
      },
    );
  }

// widget สรุปรายการสั่งซื้อ friday
  MediaQuery totalBillFriday(context) {
    final suplierProductPrice = getCartCtr
        .itemsCartList!.cardHeader.carddetailB2C
        .expand((e) => e.carddetail.map((e) => e.amount))
        .fold(0.0, (previousValue, element) => previousValue + element);
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ยอดรวมสินค้า", style: textStyle16),
                      Row(
                        children: [
                          Text(
                              "รอบการขาย ${getCartCtr.itemsCartList!.cardHeader.campaign} "),
                          Text(
                              '(${widget.order.itemsCartList!.cardHeader.totalitem + widget.order.itemsCartList!.cardHeader.carddetailB2C.map((e) => e.carddetail).length} รายการ)',
                              style: TextStyle(
                                  color: theme_grey_text, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  Text(
                      '${myFormat.format(widget.order.itemsCartList!.cardHeader.totalAmount + suplierProductPrice)} บาท',
                      style: const TextStyle(fontSize: 16))
                ],
              ),
              Builder(builder: (context) {
                var supplierDeliveryPrice = getCartCtr.supplierDelivery.values
                    .map((e) => e.detailDelivery[0].price)
                    .toList()
                    .fold(
                        0,
                        (previousValue, element) =>
                            previousValue + int.parse(element));
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (userType == '2')
                      Text("ค่าจัดส่ง", style: textStyle16)
                    else if ((userType == '1' &&
                            ctrAddress.selectedAddress.value == 0) ||
                        supplierDeliveryPrice > 0)
                      const Text(
                        "ค่าจัดส่ง",
                      ),
                    if (userType == '2' &&
                        getCartCtr
                            .itemsCartList!.cardHeader.carddetail.isNotEmpty)
                      Obx(() {
                        return Text(
                            '${myFormat.format(double.parse(ctrDelevery.isChange!.detailDelivery![ctrDelevery.indexChange.value].price) + supplierDeliveryPrice)} บาท',
                            style: textStyle16);
                      })
                    else if (userType == '1' &&
                        ctrAddress.selectedAddress.value == 0 &&
                        getCartCtr
                            .itemsCartList!.cardHeader.carddetail.isNotEmpty)
                      Obx(() {
                        return Text(
                            '${myFormat.format(double.parse(ctrDelevery.isChange!.detailDelivery![ctrDelevery.indexChange.value].price) + supplierDeliveryPrice)} บาท',
                            style: textStyle16);
                      })
                    else if (userType == '1' && supplierDeliveryPrice > 0)
                      Obx(() {
                        return Text('${supplierDeliveryPrice.obs} บาท',
                            style: textStyle16);
                      })
                  ],
                );
              }),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isShowDiscount = !isShowDiscount;
                    });
                  },
                  child: Row(
                    children: [
                      Text('ส่วนลดทั้งหมด', style: textStyle16),
                      const SizedBox(
                        width: 5,
                      ),
                      isShowDiscount
                          ? Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: theme_red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Icon(
                                  size: 20,
                                  color: Colors.white,
                                  Icons.arrow_drop_up_rounded,
                                ),
                              ),
                            )
                          : Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: theme_red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Icon(
                                  size: 20,
                                  color: Colors.white,
                                  Icons.arrow_drop_down_rounded,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
                Obx(() {
                  if (ctrCoupon.listCoupon.isNotEmpty) {
                    var sumDiscount = ctrCoupon.listCoupon
                            .map((coupon) => coupon.price)
                            .reduce((a, b) => a + b) +
                        Get.find<FetchPointMember>().discount.value;
                    return Text(
                      '- ${myFormat.format(sumDiscount)} บาท',
                      style:
                          TextStyle(color: theme_red, fontSize: 16, height: 2),
                    );
                  } else {
                    var sumDiscount =
                        Get.find<FetchPointMember>().discount.value;
                    return Text('- $sumDiscount บาท',
                        style: TextStyle(
                            color: theme_red, fontSize: 16, height: 2));
                  }
                }),
              ]),
              if (userType != '3' && isShowDiscount)
                GetX<FetchPointMember>(builder: (discount) {
                  if (discount.discount.value == 0) {
                    return const SizedBox();
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: theme_color_df.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (userType == '2')
                          const Text('ส่วนลด BW Point',
                              style: TextStyle(fontSize: 16)),
                        if (userType == '1') const Text('ส่วนลด Star Reward'),
                        Text(
                          '${myFormat.format(discount.discount.value)} บาท',
                          style: TextStyle(
                              color: theme_red, fontSize: 16, height: 2),
                        )
                      ],
                    ),
                  );
                }),
              if (userType == '2' && isShowDiscount)
                Obx(() {
                  return ctrCoupon.listCoupon.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: ctrCoupon.listCoupon.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: theme_color_df.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                        ctrCoupon.listCoupon[index].name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textStyle16),
                                  ),
                                  const SizedBox(
                                    width: 18,
                                  ),
                                  Text(
                                    '${myFormat.format(ctrCoupon.listCoupon[index].price)} บาท',
                                    style: TextStyle(
                                        color: theme_red,
                                        fontSize: 16,
                                        height: 2),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const SizedBox();
                }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'รวมเป็นเงิน',
                    style: TextStyle(
                        fontWeight: boldText, fontSize: 18, height: 2),
                  ),
                  GetBuilder<FetchDeliveryChange>(builder: (delivery) {
                    return delivery.isDataLoading.value
                        ? const SizedBox()
                        : GetX<FetchPointMember>(builder: (discount) {
                            var supplierDeliveryPrice = getCartCtr
                                .supplierDelivery.values
                                .map((e) => e.detailDelivery[0].price)
                                .toList()
                                .fold(
                                    0,
                                    (previousValue, element) =>
                                        previousValue + int.parse(element));
                            final suplierProductPrice = getCartCtr
                                .itemsCartList!.cardHeader.carddetailB2C
                                .expand(
                                    (e) => e.carddetail.map((e) => e.amount))
                                .fold(
                                    0.0,
                                    (previousValue, element) =>
                                        previousValue + element);
                            if (discount.isDataLoading.value) {
                              return const SizedBox();
                            }
                            if (userType == '2' ||
                                (userType == '1' &&
                                    ctrAddress.selectedAddress.value == 0)) {
                              var fridayDeliveryPrice = double.parse(delivery
                                  .isChange!
                                  .detailDelivery![delivery.indexChange.value]
                                  .price);
                              if (widget.order.itemsCartList!.cardHeader
                                  .carddetail.isEmpty) {
                                fridayDeliveryPrice = 0.0;
                              }
                              double totalPrice = (fridayDeliveryPrice +
                                      widget.order.itemsCartList!.cardHeader
                                          .totalAmount +
                                      suplierProductPrice +
                                      supplierDeliveryPrice) -
                                  discount.discount.value -
                                  discount.disCouponPrice.value;
                              return totalPrice > 0
                                  ? Text(
                                      '${myFormat.format(totalPrice)} บาท',
                                      style: TextStyle(
                                          fontWeight: boldText, fontSize: 18),
                                    )
                                  : Text(
                                      '0 บาท',
                                      style: TextStyle(
                                          fontWeight: boldText, fontSize: 18),
                                    );
                            }
                            return Text(
                                '${myFormat.format((widget.order.itemsCartList!.cardHeader.totalAmount + suplierProductPrice + supplierDeliveryPrice - discount.discount.value - discount.disCouponPrice.value))} บาท',
                                style: TextStyle(
                                    fontWeight: boldText, fontSize: 18));
                          });
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ? EndUser รับสินค้าเอง
class EndUsersAddAddress extends StatelessWidget {
  const EndUsersAddAddress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<FetchCartEndUsersAddress>(builder: (address) {
      return address.isDataLoading.value
          ? const SizedBox()
          : address.addressEndUser!.primaryAddress.id != ""
              ? Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.find<FetchCartEndUsersAddress>()
                            .fetchEnduserAddress();
                        Get.to(() => const EndUserChangeAddress());
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 8, left: 8, right: 8),
                        clipBehavior: Clip.antiAlias,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address
                                          .addressEndUser!.primaryAddress.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${address.addressEndUser!.primaryAddress.address1} ${address.addressEndUser!.primaryAddress.tumbonName} ${address.addressEndUser!.primaryAddress.amphurName} ${address.addressEndUser!.primaryAddress.provinceName} ${address.addressEndUser!.primaryAddress.postalcode}',
                                      style: TextStyle(color: theme_grey_text),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    if (address.addressEndUser!.primaryAddress
                                            .note !=
                                        "")
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              'รายละเอียด',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              address.addressEndUser!
                                                  .primaryAddress.note,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: theme_grey_text),
                                            ),
                                          )
                                        ],
                                      ),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            'เบอร์โทร',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            formatPhoneNumber(address
                                                .addressEndUser!
                                                .primaryAddress
                                                .telnumber),
                                            style: TextStyle(
                                                color: theme_grey_text),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: theme_color_df,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: const Text(
                                            'ที่อยู่หลัก',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        if (address.addressEndUser!
                                                .primaryAddress.type !=
                                            "0")
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 1),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: theme_color_df,
                                                  width: 1,
                                                )),
                                            child: Text(
                                              address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .type ==
                                                      '1'
                                                  ? 'บ้าน'
                                                  : 'ที่ทำงาน',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: theme_color_df,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                      ],
                                    )
                                  ],
                                )),
                            Expanded(
                                child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: theme_color_df,
                            ))
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            side: BorderSide(color: theme_color_df, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () {
                            // Get.to(() => const EndUserAddAddress(),
                            //     arguments: ["ที่อยู่จัดส่งสินค้า", "", "Add"]);
                            Get.find<FetchCartEndUsersAddress>()
                                .fetchEnduserAddress();
                            Get.to(() => const EndUserChangeAddress());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                'เพิ่มที่อยู่ใหม่',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: theme_color_df),
                              ),
                            ],
                          )),
                    ),
                  ],
                );
    });
  }
}

// ? Widget notify
class NotiHeader extends StatelessWidget {
  const NotiHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<FetchCartNotiAddress>(builder: (noti) {
      return noti.isDataLoading.value
          ? const SizedBox()
          : Container(
              color: theme_red,
              // height: 30,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 1,
                      child:
                          Icon(Icons.campaign, size: 40, color: Colors.white),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        noti.addressCart!.detail,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            );
    });
  }
}

// ? widget address header
addressHeaderMsl(camp) {
  return GetBuilder<AddressController>(builder: (address) {
    if (address.isDataLoading.value) {
      return const SizedBox();
    }
    if (address.addressMslSaveOrder!.msladdrId == 0) {
      return Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                padding: const EdgeInsets.all(4),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(color: theme_color_df, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      Get.find<AddressController>().getAddressData();
                      Get.to(() => const AddressNewMsl());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 18,
                          color: theme_color_df,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          'เพิ่มที่อยู่ใหม่',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: theme_color_df),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        );
      });
    }
    return InkWell(
      onTap: () {
        Get.find<AddressController>().getAddressData();
        Get.to(() => const AddressNewMsl());
      },
      child: Builder(builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          address.addressMslSaveOrder!.deliverContact == ""
                              ? address.repName!
                              : address.addressMslSaveOrder!.deliverContact,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 12,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: theme_color_df,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: const Text(
                                        'ที่อยู่จัดส่ง',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "${address.addressMslSaveOrder!.addrline1} ${address.addressMslSaveOrder!.addrline2} ${address.addressMslSaveOrder!.tumbonName} ${address.addressMslSaveOrder!.amphurName} ${address.addressMslSaveOrder!.provinceName} ${address.addressMslSaveOrder!.postalCode}",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    'เบอร์โทร',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    formatPhoneNumber(
                                        address.addressMslSaveOrder!.mobileNo),
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: theme_color_df,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  });
}

// ? enduser รับสินค้ากับ msl
Widget mslRecieveEnd() {
  return GetX<SearchPointRewardsController>(builder: (address) {
    return address.isDataLoading.value
        ? const SizedBox()
        : Container(
            margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ข้อมูลตัวแทนขาย',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          address.mslInfo!.repName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${address.mslInfo!.address1} ${address.mslInfo!.tumbon} ${address.mslInfo!.amphur} ${address.mslInfo!.province} ${address.mslInfo!.postal}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          'เบอร์โทร',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          formatPhoneNumber(address.mslInfo!.mobileno),
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  });
}

notiHeaderEndUser({required String msg, required String des}) {
  return Container(
    color: theme_red,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            flex: 1,
            child: Icon(Icons.campaign, size: 40, color: Colors.white),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  des,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

//? ราคารวม friday
Widget summaryShop(List<Carddetail> carddetail, context, userType) {
  return MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(1.0)),
    child: Container(
      color: Colors.white,
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Divider(
            height: 1,
            color: theme_color_df,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (Get.currentRoute != "/CartOrderSummary")
                  Wrap(
                    runAlignment: WrapAlignment.end,
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      Text(
                        'รวมสินค้าทั้งหมด ${carddetail.length} รายการ',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Text(', ราคารวม ', style: TextStyle(fontSize: 14)),
                      Text(
                        '${myFormat.format(carddetail.map((e) => e.amount).fold(0.0, (previousValue, element) => previousValue + element))} บาท',
                        style: TextStyle(
                            color: theme_red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'รวมสินค้าทั้งหมด ${carddetail.length} รายการ',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '฿${myFormat.format(carddetail.map((e) => e.amount).fold(0.0, (previousValue, element) => previousValue + element))}',
                        style: const TextStyle(
                            // color: theme_red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  ),
                if (Get.currentRoute == "/CartOrderSummary" && userType == "2")
                  Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('การชำระเงิน',
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                              Obx(() {
                                return Text(
                                  ctrPaymentType.isLoading.value
                                      ? ''
                                      : ctrPaymentType
                                          .paymentTypeData!.paymentType,
                                  style: const TextStyle(fontSize: 14),
                                );
                              }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "ค่าจัดส่ง",
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                  '฿${myFormat.format(double.parse(ctrDelevery.isChange!.detailDelivery![ctrDelevery.indexChange.value].price))}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  )),
                            ],
                          )
                        ],
                      ))
                else if (Get.currentRoute == "/CartOrderSummary" &&
                    userType == "1")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'การชำระเงิน',
                            style: TextStyle(fontSize: 14),
                          ),
                          Obx(() {
                            return Text(
                              ctrAddress.selectedAddress.value == 0
                                  ? 'เก็บเงินปลายทาง'
                                  : 'ชำระเงินกับสมาชิก',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            );
                          }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ค่าจัดส่ง',
                            style: TextStyle(fontSize: 14),
                          ),
                          Obx(() {
                            if (ctrAddress.selectedAddress.value == 0) {
                              return Text(
                                  '฿${myFormat.format(double.parse(ctrDelevery.isChange!.detailDelivery![ctrDelevery.indexChange.value].price))}',
                                  style: const TextStyle(fontSize: 14));
                            }
                            return const Text("฿0");
                          }),
                        ],
                      ),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

//? ราคารวม supplier
Widget summaryShopSupplier(CarddetailB2C b2c, context, userType) {
  return MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(1.0)),
    child: Container(
      color: Colors.white,
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Divider(
            height: 1,
            color: theme_color_df,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (Get.currentRoute != "/CartOrderSummary")
                  Wrap(
                    runAlignment: WrapAlignment.end,
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      Text(
                        'รวมสินค้าทั้งหมด ${b2c.carddetail.length} รายการ',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Text(', ราคารวม ', style: TextStyle(fontSize: 14)),
                      Text(
                        '${myFormat.format(b2c.carddetail.map((e) => e.amount).fold(0.0, (previousValue, element) => previousValue + element))} บาท',
                        style: TextStyle(
                            color: theme_red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'รวมสินค้า ${b2c.carddetail.length} รายการ',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '฿${myFormat.format(b2c.carddetail.map((e) => e.amount).fold(0.0, (previousValue, element) => previousValue + element))}',
                        style: const TextStyle(
                            // color: theme_red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  ),
                if (Get.currentRoute == "/CartOrderSummary")
                  Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('การชำระเงิน',
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                              Text(
                                getCartCtr.supplierDelivery[b2c.supplierCode]!
                                    .detailDelivery[0].titleDelivery,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('ค่าจัดส่ง',
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                              Text(
                                "฿${getCartCtr.supplierDelivery[b2c.supplierCode]!.detailDelivery[0].price}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ))
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
