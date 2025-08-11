import 'dart:async';

import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/controller/badger/badger_controller.dart';
import 'package:fridayonline/controller/cart/cart_controller.dart';
import 'package:fridayonline/controller/cart/dropship_controller.dart';
import 'package:fridayonline/controller/catelog/catelog_controller.dart';
import 'package:fridayonline/controller/flashsale/flash_controller.dart';
import 'package:fridayonline/controller/home/home_controller.dart';
import 'package:fridayonline/controller/notification/notification_controller.dart';
import 'package:fridayonline/controller/pro_filecontroller.dart';
import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
import 'package:fridayonline/enduser/controller/brand.ctr.dart';
import 'package:fridayonline/enduser/controller/category.ctr.dart';
import 'package:fridayonline/enduser/controller/enduser.home.ctr.dart';
import 'package:fridayonline/enduser/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/enduser/controller/order.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.category.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/enduser/controller/topproduct.ctr.dart';
import 'package:fridayonline/enduser/controller/track.ctr.dart';
import 'package:fridayonline/enduser/services/track/track.service.dart';
import 'package:fridayonline/enduser/utils/image_preloader.dart';
// import 'package:fridayonline/enduser/views/(brand)/brand.store.dart';
import 'package:fridayonline/enduser/views/(cart)/cart.main.dart';
import 'package:fridayonline/enduser/views/(category)/subcategory.view.dart';
import 'package:fridayonline/enduser/views/(coupon)/coupon.all.dart';
import 'package:fridayonline/enduser/views/(order)/order.checkout.dart';
import 'package:fridayonline/enduser/views/(order)/order.detail.dart';
import 'package:fridayonline/homepage/home/home_special_promotion_bwpoint.dart';
import 'package:fridayonline/homepage/myhomepage.dart';

import 'package:fridayonline/homepage/notify/notify_promotionlist.dart';
import 'package:fridayonline/homepage/page_showproduct/List_product.dart';
import 'package:fridayonline/homepage/page_showproduct/product_detail.dart';
import 'package:fridayonline/enduser/views/(showproduct)/show.category.view.dart';
import 'package:fridayonline/enduser/views/(top)/top.product.dart';
import 'package:fridayonline/homepage/check_information/payment/payment_cutomer.dart';
import 'package:fridayonline/homepage/flashsale/flashsale_detail.dart';
import 'package:fridayonline/homepage/home/home_new/home_more_special/home_special_project.dart';
import 'package:fridayonline/homepage/pageactivity/cart_activity.dart';
import 'package:fridayonline/homepage/srisawad/onboarding.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/webview/webview_app.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:fridayonline/homepage/widget/appbar_cart_share.dart';
import 'package:fridayonline/model/flashsale/flashsale.dart';
import 'package:fridayonline/model/point_rewards/point_rewards_get_msl_info.dart';
import 'package:fridayonline/model/push/notify.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/flashsale/flashsale_service.dart';
import 'package:fridayonline/service/logapp/interaction.dart';
import 'package:fridayonline/service/logapp/logapp_service.dart';
import 'package:fridayonline/service/notify/informationPushNotify_sevice.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:fridayonline/service/point_rewards/point_rewards_sevice.dart';
import 'package:fridayonline/service/profileuser/getprofile.dart';
import 'package:fridayonline/service/profileuser/mslinfo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Timer? debounce;
Future<void> managePushMain(
    message, BuildContext context, String channel) async {
  PushNotify? pushNotify;
  if (message.runtimeType == PushNotify) {
    pushNotify = message;
  } else if (message.runtimeType == RemoteMessage) {
    var json = message.data['notification_type'];
    pushNotify = pushNotifyFromJson(json.toString());
  } else {
    pushNotify = pushNotifyFromJson(message);
  }
  if (pushNotify == null) return;

  SetData data = SetData();

  String pushTitle = pushNotify.pushTitle;
  String userPushType = pushNotify.userType;
  String productId = pushNotify.productId;
  String sellerId = pushNotify.sellerId;
  String orderType = pushNotify.orderType;
  String orderId = pushNotify.orderId;
  var pushType = pushNotify.contentType.toString().toLowerCase();
  var contentIndex = pushNotify.contentIndex;
  var contentId = pushNotify.contentId;
  var billCode = pushNotify.billCode;
  var fsCode = pushNotify.fsCode;
  var categoryID = pushNotify.categoryId;
  var catalogType = pushNotify.catalogType;
  var campaign = pushNotify.campaign;
  var brand = pushNotify.brand;
  var media = pushNotify.media;
  var url = pushNotify.url;
  var channelId = pushNotify.channelId;
  var sectionId = pushNotify.sectionId;
  var notifyId = pushNotify.notifyId;
  var pushImg = pushNotify.imgUrl;

  var repType = await data.repType;
  if (repType == "null") {
    repType = "";
  }

  var mChannel = '24';
  await LogAppTisCall(mChannel, channelId);
  var ctr = Get.find<EndUserSignInCtr>();
  var shoCategoryCtr = Get.find<ShowProductCategoryCtr>();
  var categoryCtr = Get.find<CategoryCtr>();
  var endUserHomeCtr = Get.find<EndUserHomeCtr>();
  var productSkuCtr = Get.find<ShowProductSkuCtr>();
  var brandCtr = Get.find<BrandCtr>();
  var topProductCtr = Get.find<TopProductsCtr>();
  var orderController = Get.find<OrderController>();
  var trackCtr = Get.find<TrackCtr>();

  if (pushType == 'regis_srisawad') {
    await loadImageOnboarding();
    Get.offAll(() => const OnBoarding());
    return;
  }
  // push หา b2c
  if (userPushType == '5' || userPushType == '0') {
    endUserHomeCtr.endUserGetAllHomePage();
    // กรณี login b2c อยู่แล้ว
    if (repType == '5' || repType == '0') {
      setTrackContentViewServices(
        int.parse(notifyId),
        pushTitle,
        channel,
        0,
      );
      // trackCtr.setDataTrack(int.parse(notifyId), pushTitle, channel);
      switch (pushType) {
        case 'notify_order':
          {
            Get.offAllNamed('/EndUserHome', parameters: {'changeView': "2"});
            if (orderType == '0') {
              orderController
                  .fetchOrderDetailCheckOut(int.tryParse(orderId) ?? 0);
              await Get.to(() => const OrderCheckout())!.then((value) {
                orderController.orderTracking = null;
                orderController.fetchNotifyOrderTracking(10627, 0);
              });
            } else {
              orderController.fetchOrderDetail(int.tryParse(orderId) ?? 0);
              await Get.to(() => const MyOrderDetail())!.then((value) {
                orderController.orderTracking = null;
                orderController.fetchNotifyOrderTracking(10627, 0);
              });
            }
            break;
          }
        case 'cart':
          {
            Get.to(() => const EndUserCart());
            break;
          }
        case 'notify':
          {
            Get.offAllNamed('/EndUserHome', parameters: {'changeView': "2"});
            break;
          }
        case 'coupon':
          {
            Get.to(() => const CouponAll());
            break;
          }
        case 'category':
          {
            trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
            shoCategoryCtr.fetchProductByCategoryId(4, categoryID, 0);
            await Get.to(() => const ShowProductCategory())!.then((res) {
              trackCtr.clearLogContent();
            });
            break;
          }
        case 'category_sort':
          {
            trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
            var catId = int.tryParse(categoryID) ?? 0;
            categoryCtr.fetchSubCategory(catId);
            shoCategoryCtr.fetchProductByCategoryIdWithSort(
                int.tryParse(categoryID) ?? 0, 0, "ctime", "", 40, 0);
            await Get.to(() => const SubCategory())!.then((res) {
              trackCtr.clearLogContent();
            });
            break;
          }
        case 'top_product':
          {
            trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
            topProductCtr.setActiveTab(0);
            topProductCtr.fetchTopProducts(
                endUserHomeCtr.topSalesWeekly!.data.first.prodlineId);
            await Get.to(() => Obx(() {
                      if (endUserHomeCtr.isLoadingTopSales.value) {
                        return const SizedBox();
                      }
                      return const TopProductsWeekly();
                    }))!
                .then((res) {
              trackCtr.clearLogContent();
            });

            break;
          }
        case 'product_sku':
          {
            trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
            productSkuCtr.fetchB2cProductDetail(productId, 'push');
            await Get.toNamed(
              '/ShowProductSku/$productId',
            )!
                .then((value) {
              trackCtr.clearLogContent();
            });
            break;
          }
        case 'seller':
          {
            trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
            brandCtr.fetchShopData(int.parse(sellerId));
            await Get.toNamed('/BrandStore/${int.parse(sellerId)}',
                    arguments: 0,
                    parameters: {
                  "sectionId": sectionId.toString(),
                  "viewType": '0'
                })!
                .then((value) {
              trackCtr.clearLogContent();
            });
            break;
          }
        case 'seller_category':
          {
            trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
            brandCtr.fetchShopData(int.parse(sellerId));
            await Get.toNamed('/BrandStore/${int.parse(sellerId)}',
                    arguments: 1,
                    parameters: {
                  "sectionId": sectionId.toString(),
                  "viewType": '1'
                })!
                .then((value) {
              trackCtr.clearLogContent();
            });
            break;
          }
        case 'fair':
          {
            trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
            await Get.offAllNamed('/EndUserHome',
                    parameters: {'changeView': "2"})!
                .then((value) {
              trackCtr.clearLogContent();
            });
            break;
          }
        default:
          {
            break;
          }
      }
    } else {
      // กรณี msl ได้ push ที่เป็นของ b2c
      trackCtr.setDataTrack(int.parse(notifyId), pushTitle, channel);
      switch (pushType) {
        case 'notify_order':
          {
            ctr
                .settingPreferencePush('1', '', '5', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              Get.offAllNamed('/EndUserHome', parameters: {'changeView': "2"});
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                if (orderType == '0') {
                  orderController
                      .fetchOrderDetailCheckOut(int.tryParse(orderId) ?? 0);
                  await Get.to(() => const OrderCheckout())!.then((value) {
                    orderController.orderTracking = null;
                    orderController.fetchNotifyOrderTracking(10627, 0);
                  });
                } else {
                  orderController.fetchOrderDetail(int.tryParse(orderId) ?? 0);
                  await Get.to(() => const MyOrderDetail())!.then((value) {
                    orderController.orderTracking = null;
                    orderController.fetchNotifyOrderTracking(10627, 0);
                  });
                }
              });
            });
            break;
          }
        case 'cart':
          {
            ctr
                .settingPreferencePush('1', '', '5', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              Get.offAllNamed('/EndUserHome', parameters: {'changeView': "0"});
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.to(() => const EndUserCart());
              });
            });
            break;
          }
        case 'notify':
          {
            ctr
                .settingPreferencePush('1', '', '5', await data.b2cCustID)
                .then((res) {
              Get.offAllNamed('/EndUserHome', parameters: {'changeView': "2"});
            });
            break;
          }
        case 'coupon':
          {
            ctr
                .settingPreferencePush('1', '', '5', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              Get.offAllNamed('/EndUserHome', parameters: {'changeView': "0"});
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.to(() => const CouponAll());
              });
            });
            break;
          }
        case 'category':
          {
            ctr
                .settingPreferencePush('1', '', '5', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }

              Get.offAllNamed('/EndUserHome', parameters: {'changeView': "0"});
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
                shoCategoryCtr.fetchProductByCategoryId(4, categoryID, 0);
                await Get.to(() => const ShowProductCategory())!.then((res) {
                  trackCtr.clearLogContent();
                });
              });
            });

            break;
          }
        case 'category_sort':
          {
            ctr
                .settingPreferencePush('1', '', '5', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              Get.offAllNamed('/EndUserHome', parameters: {'changeView': "0"});
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
                var catId = int.tryParse(categoryID) ?? 0;
                categoryCtr.fetchSubCategory(catId);
                shoCategoryCtr.fetchProductByCategoryIdWithSort(
                    int.tryParse(categoryID) ?? 0, 0, "ctime", "", 40, 0);
                await Get.to(() => const SubCategory())!.then((res) {
                  trackCtr.clearLogContent();
                });
              });
            });

            break;
          }
        case 'top_product':
          {
            ctr
                .settingPreferencePush('1', '', '5', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              Get.offAllNamed('/EndUserHome', parameters: {'changeView': "0"});
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
                topProductCtr.setActiveTab(0);
                topProductCtr.fetchTopProducts(
                    endUserHomeCtr.topSalesWeekly!.data.first.prodlineId);
                await Get.to(() => Obx(() {
                          if (endUserHomeCtr.isLoadingTopSales.value) {
                            return const SizedBox();
                          }
                          return const TopProductsWeekly();
                        }))!
                    .then((res) {
                  trackCtr.clearLogContent();
                });
              });
            });

            break;
          }
        case 'product_sku':
          {
            ctr
                .settingPreferencePush('1', '', '5', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              Get.offAllNamed('/EndUserHome', parameters: {'changeView': "0"});
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
                productSkuCtr.fetchB2cProductDetail(productId, 'push');
                await Get.toNamed(
                  '/ShowProductSku/$productId',
                )!
                    .then((value) {
                  trackCtr.clearLogContent();
                });
              });
            });

            break;
          }
        case 'seller':
          {
            ctr
                .settingPreferencePush('1', '', '5', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              Get.offAllNamed('/EndUserHome', parameters: {'changeView': "0"});
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
                brandCtr.fetchShopData(int.parse(sellerId));
                await Get.toNamed('/BrandStore/${int.parse(sellerId)}',
                        arguments: 0,
                        parameters: {
                      "sectionId": sectionId.toString(),
                      "viewType": '0'
                    })!
                    .then((value) {
                  trackCtr.clearLogContent();
                });
              });
            });
            break;
          }
        case 'seller_category':
          {
            ctr
                .settingPreferencePush('1', '', '5', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              Get.offAllNamed('/EndUserHome', parameters: {'changeView': "0"});
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
                brandCtr.fetchShopData(int.parse(sellerId));
                await Get.toNamed('/BrandStore/${int.parse(sellerId)}',
                        arguments: 1,
                        parameters: {
                      "sectionId": sectionId.toString(),
                      "viewType": '1'
                    })!
                    .then((value) {
                  trackCtr.clearLogContent();
                });
              });
            });
            break;
          }
        case 'fair':
          {
            ctr
                .settingPreferencePush('1', '', '5', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              trackCtr.setLogContentAddToCart(int.parse(notifyId), channel);
              await Get.offAllNamed('/EndUserHome',
                      parameters: {'changeView': "2"})!
                  .then((value) {
                trackCtr.clearLogContent();
              });
            });
            break;
          }
        default:
          {
            break;
          }
      }
    }
  } else if (repType == '0' &&
      (userPushType == "2" || userPushType == "1" || userPushType == "")) {
    return;
  } else {
    // push หา msl
    if (repType == '2' || repType == '1') {
      if (contentId != "") {
        InteractionLogger.logPush(
            contentId: contentId,
            contentName: pushTitle,
            contentImage: pushImg);
      }
      // กรณีเป็น msl หรือ ลูกค้า
      switch (pushType) {
        case "url":
          {
            Get.to(() => WebViewFullScreen(mparamurl: url));
            break;
          }
        case "category":
          {
            Get.put(ProductFromBanner()).fetch_product_banner(categoryID, '');
            Get.to(() => Scaffold(
                appBar: appbarShare(
                  "รายการสินค้า",
                  "",
                  mChannel,
                  channelId,
                ),
                body: Obx(() => Get.put(ProductFromBanner()).isDataLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : showList(
                        Get.put(ProductFromBanner()).BannerProduct!.skucode,
                        '24',
                        contentIndex,
                        ref: 'push',
                        contentId: contentIndex,
                      ))));
            break;
          }
        case "sku":
          {
            // Get.find<CategoryProductDetailController>().fetchproductdetail(
            //     "", billCode, "", fsCode, '24', contentIndex, '');
            // // จากนั้นไปที่ รายละเอียดสินค้าที่เป็น Webview
            // Get.toNamed('/my_detail',
            //     parameters: {'mchannel': '24', 'mchannelId': contentIndex});
            Get.find<ProductDetailController>().productDetailController(
                '', billCode, '', fsCode, '24', contentIndex);
            Get.to(() => ProductDetailPage(
                  ref: 'push',
                  contentId: contentIndex,
                ));
            break;
          }
        case "sharecatalog":
          {
            Get.toNamed("/sharecatalog");
            break;
          }
        // ไปที่หน้า ข้อมูลการสั่งซื้อ EndUser (push: EndUser)
        case "vieworder":
          {
            Get.toNamed("/enduser_check_information",
                parameters: {'select': '1'});
            //Get.toNamed("/enduser_check_information");
            break;
          }
        // ไปที่หน้า ข้อมูลการสั่งซื้อของ EndUser (push: Msl)
        case "vieworderenduser":
          {
            Get.toNamed("/check_information_order");
            break;
          }
        case "promotion":
          {
            // Get.find<NotificationPromotionListController>()
            //     .get_pam_notification_data();
            Get.find<NotificationPromotionListController>()
                .get_promotionList('101', "GetPromotionGroup");
            Get.find<AppController>().setCurrentNavInget(3);
            Get.to(
              transition: Transition.rightToLeft,
              () => notify_promotionlist(
                  idparm: '101', typedataapi: "GetPromotionGroup"),
            );
            break;
          }
        case "activity":
          {
            var activityUrl = await GetYupinActivity('GetYupinActivity');
            Get.to(
                transition: Transition.rightToLeft,
                () => WebViewFullScreen(mparamurl: activityUrl.toString()));
            break;
          }
        case "news":
          {
            var newsUrl = await GetYupinActivity('GetYupinNews');
            Get.to(
                transition: Transition.rightToLeft,
                () => WebViewFullScreen(mparamurl: newsUrl.toString()));
            break;
          }
        case "notifynormal":
          {
            Get.find<AppController>().setCurrentNavInget(3);
            Get.toNamed("/backAppbarnotify", parameters: {'changeView': '3'});
            // Get.toNamed("/promotion");
            break;
          }
        case "leadtomsl":
          {
            // setMslFromLead();
            break;
          }
        case "extra":
          {
            Get.to(() => const HomeSpecialProject());
            break;
          }
        case "flashsale":
          {
            Flashsale? flashSaleData = await FlashsaleHomeService();
            if (flashSaleData!.flashSale.isNotEmpty) {
              Get.to(() => FlashSaleDetail(
                    contentId: flashSaleData.flashSale[0].id,
                  ));
            } else {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(10),
                      titlePadding: const EdgeInsets.only(top: 20, bottom: 0),
                      actionsPadding: const EdgeInsets.only(top: 0, bottom: 0),
                      actionsAlignment: MainAxisAlignment.end,
                      title: Text(
                        textAlign: TextAlign.center,
                        "แจ้งเตือน",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme_color_df),
                      ),
                      content: const Text(
                          textAlign: TextAlign.center,
                          'ขออภัยค่ะ\nขณะนี้ Flash Sale ยังไม่เปิด'),
                      actions: [
                        const Divider(
                          color: Color(0XFFD9D9D9),
                          thickness: 1,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Text(
                                textAlign: TextAlign.center,
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
              debugPrint('ยังไม่เปิด');
            }
            break;
          }
        case "payment":
          {
            Mslinfo profile = await getProfileMSL();
            Get.to(() => payment_cutomer(profile.mslInfo.arBal));
            break;
          }
        case "pointhome":
          {
            Get.to(() => const SpecialPromotionBwpoint(type: 'push'));
            break;
          }
        case "pointcategorydetail":
          {
            var cpRepSeq = await data.repSeq;
            var cpRepCode = await data.repCode;
            GetMslinfo? mslinfo = await GetMslInfoSevice();
            var idCard = mslinfo!.idcardRequire;
            var cpFscode = fsCode;
            if (idCard == "Y") {
              Get.to(() => WebViewFullScreen(
                  mparamurl:
                      "${baseurl_web_view}main-less/main_less.php?repseq=$cpRepSeq&repcode=$cpRepCode"));
            } else {
              Get.to(() => webview_app(
                  mparamurl:
                      "${base_url_web_fridayth}bwpoint/product?billCode=$cpFscode",
                  mparamTitleName: 'คะแนนสะสม',
                  mparamType: 'rewards_detail',
                  mparamValue: cpFscode));
            }
            break;
          }
        case "cataloghome":
          {
            Get.find<AppController>().setCurrentNavInget(1);
            Get.offAll(() => MyHomePage(
                  typeView: 'catelog',
                  indexCatelog: int.parse(catalogType),
                ));
            break;
          }
        case "catalogdetail":
          {
            var catalogtype = '';
            if (catalogType == "0") {
              catalogtype = "7";
            } else if (catalogType == "1") {
              catalogtype = "8";
            }
            Get.find<CatelogDetailController>()
                .get_catelog_detail(campaign, brand, media);
            Get.toNamed('/catelog_detail',
                parameters: {"channel": catalogtype.toString()});
            break;
          }
        case "cart":
          {
            Get.to(() => const Cart());
            break;
          }
        case "checkin":
          {
            var cpRepSeq = await data.repSeq;
            var cpRepCode = await data.repCode;
            var tokenApp = await data.tokenId;
            var urlCheckIn =
                "https://club.fridayth.com/yclub/activity/checkin/index.php?chanel=BANNER?ProjectCode=Notify&Repcode=$cpRepCode&RefCode=$cpRepCode&RepSeq=$cpRepSeq&RefID=$cpRepSeq&RepType=2&TokenApp=$tokenApp";
            Get.to(() => WebViewFullScreen(mparamurl: urlCheckIn));
            break;
          }
        default:
          {
            Get.toNamed("/");
            break;
          }
      }
    } else {
      if (contentId != "") {
        InteractionLogger.logPush(
            contentId: contentId,
            contentName: pushTitle,
            contentImage: pushImg);
      }
      // กรณี msl ได้ push ที่เป็นของ msl แต่ switch ตัวเองมาใช้งาน b2c อยู่
      switch (pushType) {
        case "sharecatalog":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.toNamed("/sharecatalog");
              });
            });
            break;
          }
        case "url":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.to(() => WebViewFullScreen(mparamurl: url));
              });
            });

            break;
          }
        case "category":
          {
            ctr
                .settingPreferencePush('1', '', '2', await data.b2cCustID)
                .then((val) async {
              await fetchMslCallData();
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.put(ProductFromBanner())
                    .fetch_product_banner(categoryID, '');
                Get.to(() => Scaffold(
                    appBar:
                        appbarShare('รายการสินค้า', "", mChannel, contentIndex),
                    body: Obx(
                        () => Get.put(ProductFromBanner()).isDataLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : showList(
                                Get.put(ProductFromBanner())
                                    .BannerProduct!
                                    .skucode,
                                '26',
                                contentIndex,
                                ref: 'push',
                                contentId: contentIndex,
                              ))));
              });
            });

            break;
          }
        case "sku":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.find<ProductDetailController>().productDetailController(
                    campaign, billCode, "", fsCode, '26', contentIndex);
                Get.to(() => ProductDetailPage(
                      ref: 'push',
                      contentId: contentIndex,
                    ));
              });
            });

            break;
          }
        case "customer_list":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.toNamed("/sharecatalog");
              });
            });
            break;
          }
        case "vieworder":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.toNamed("/enduser_check_information",
                    parameters: {'select': '1'});
              });
            });

            break;
          }
        case "text":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.toNamed("/sharecatalog");
              });
            });
            break;
          }
        case "vieworderenduser":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.toNamed("/check_information_order");
              });
            });

            break;
          }
        case "promotion":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.find<NotificationPromotionListController>()
                    .get_promotionList('101', "GetPromotionGroup");
                Get.find<AppController>().setCurrentNavInget(3);
                Get.to(
                  transition: Transition.rightToLeft,
                  () => notify_promotionlist(
                      idparm: '101', typedataapi: "GetPromotionGroup"),
                );
              });
            });

            break;
          }
        case "activity":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                var activityUrl = await GetYupinActivity('GetYupinActivity');
                Get.to(
                    transition: Transition.rightToLeft,
                    () => WebViewFullScreen(mparamurl: activityUrl.toString()));
              });
            });

            break;
          }
        case "news":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                var newsUrl = await GetYupinActivity('GetYupinNews');
                Get.to(
                    transition: Transition.rightToLeft,
                    () => WebViewFullScreen(mparamurl: newsUrl.toString()));
              });
            });

            break;
          }
        case "notifynormal":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.find<AppController>().setCurrentNavInget(3);
                Get.toNamed("/backAppbarnotify",
                    parameters: {'changeView': '3'});
              });
            });
            break;
          }
        case "leadtomsl":
          {
            //setMslFromLead();
            break;
          }
        case "extra":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.find<AppController>().setCurrentNavInget(3);
                Get.to(() => const HomeSpecialProject());
              });
            });

            break;
          }
        case "flashsale":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Flashsale? flashSaleData = await FlashsaleHomeService();
                if (flashSaleData!.flashSale.isNotEmpty) {
                  Get.offAll(() => MyHomePage());
                  Get.find<AppController>().setCurrentNavInget(3);
                  Get.to(() => FlashSaleDetail(
                        contentId: flashSaleData.flashSale[0].id,
                      ));
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(10),
                            titlePadding:
                                const EdgeInsets.only(top: 20, bottom: 0),
                            actionsPadding:
                                const EdgeInsets.only(top: 0, bottom: 0),
                            actionsAlignment: MainAxisAlignment.end,
                            title: Text(
                              textAlign: TextAlign.center,
                              "แจ้งเตือน",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme_color_df),
                            ),
                            content: const Text(
                                textAlign: TextAlign.center,
                                'ขออภัยค่ะ\nขณะนี้ Flash Sale ยังไม่เปิด'),
                            actions: [
                              const Divider(
                                color: Color(0XFFD9D9D9),
                                thickness: 1,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Center(
                                  child: Text(
                                      textAlign: TextAlign.center,
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
                    debugPrint('ยังไม่เปิด');
                  });
                }
              });
            });

            break;
          }
        case "payment":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Mslinfo profile = await getProfileMSL();
                Get.to(() => payment_cutomer(profile.mslInfo.arBal));
              });
            });

            break;
          }
        case "pointhome":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.to(() => const SpecialPromotionBwpoint(type: 'push'));
              });
            });

            break;
          }
        case "pointcategorydetail":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                var cpRepSeq = await data.repSeq;
                var cpRepCode = await data.repCode;
                GetMslinfo? mslinfo = await GetMslInfoSevice();
                var idCard = mslinfo!.idcardRequire;
                var cpFscode = fsCode;
                if (idCard == "Y") {
                  Get.to(() => WebViewFullScreen(
                      mparamurl:
                          "${baseurl_web_view}main-less/main_less.php?repseq=$cpRepSeq&repcode=$cpRepCode"));
                } else {
                  Get.to(() => webview_app(
                      mparamurl:
                          "${base_url_web_fridayth}bwpoint/product?billCode=$cpFscode",
                      mparamTitleName: 'คะแนนสะสม',
                      mparamType: 'rewards_detail',
                      mparamValue: cpFscode));
                }
              });
            });

            break;
          }
        case "cataloghome":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.offAll(() => MyHomePage(
                      typeView: "catelog",
                      indexCatelog: int.parse(catalogType),
                    ));
              });
            });
            break;
          }
        case "catalogdetail":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                var catalogtype = "";
                if (catalogType == "0") {
                  catalogtype = "7";
                } else if (catalogType == "1") {
                  catalogtype = "8";
                }
                Get.find<CatelogDetailController>()
                    .get_catelog_detail(campaign, brand, media);
                Get.toNamed('/catelog_detail',
                    parameters: {"channel": catalogtype.toString()});
              });
            });

            break;
          }
        case "cart":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                Get.to(() => const Cart());
              });
            });

            break;
          }
        case "checkin":
          {
            ctr
                .settingPreference('1', '', '2', await data.b2cCustID)
                .then((res) async {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }
              debounce = Timer(const Duration(milliseconds: 1000), () async {
                var cpRepSeq = await data.repSeq;
                var cpRepCode = await data.repCode;
                var tokenApp = await data.tokenId;
                var urlCheckIn =
                    "https://club.fridayth.com/yclub/activity/checkin/index.php?chanel=BANNER?ProjectCode=Notify&Repcode=$cpRepCode&RefCode=$cpRepCode&RepSeq=$cpRepSeq&RefID=$cpRepSeq&RepType=2&TokenApp=$tokenApp";
                Get.to(() => WebViewFullScreen(mparamurl: urlCheckIn));
              });
            });

            break;
          }
        default:
          {
            ctr.settingPreference('1', '', '2', await data.b2cCustID);
            break;
          }
      }
    }
  }
}

fetchMslCallData() {
  Get.find<AppController>().setCurrentNavInget(0);
  Get.find<DraggableFabController>().draggable_Fab();
  Get.find<BannerController>().get_banner_data();
  Get.find<FavoriteController>().get_favorite_data();
  Get.find<SpecialPromotionController>().get_promotion_data();
  Get.find<ProductHotItemHomeController>().get_product_hotitem_data();
  Get.find<ProductHotIutemLoadmoreController>().resetItem();
  Get.find<CatelogController>().get_catelog();
  Get.find<NotificationController>().get_notification_data();
  Get.find<ProfileController>().get_profile_data();
  Get.find<ProfileSpecialProjectController>().get_special_project_data();
  Get.find<FetchCartItemsController>().fetch_cart_items();
  Get.find<FetchCartDropshipController>().fetchCartDropship();
  Get.find<FlashsaleTimerCount>().flashSaleHome();
  Get.find<BadgerController>().get_badger();
  Get.find<BadgerProfileController>().get_badger_profile();
  Get.find<BadgerController>().getBadgerMarket();
  Get.find<PopUpStatusController>().ChangeStatusViewPopupFalse();
  Get.find<KeyIconController>().get_keyIcon_data();
  Get.find<HomePointController>().get_home_point_data(false);
  Get.find<HomeContentSpecialListController>().get_home_content_data("");
  Get.to(() => MyHomePage());
}
