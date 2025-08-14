import 'dart:async';
import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/category.ctr.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/member/controller/order.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.category.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/controller/topproduct.ctr.dart';
import 'package:fridayonline/member/controller/track.ctr.dart';
import 'package:fridayonline/member/models/push/push.model.dart';
import 'package:fridayonline/member/services/track/track.service.dart';
import 'package:fridayonline/member/utils/image_preloader.dart';
// import 'package:fridayonline/enduser/views/(brand)/brand.store.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:fridayonline/member/views/(category)/subcategory.view.dart';
import 'package:fridayonline/member/views/(coupon)/coupon.all.dart';
import 'package:fridayonline/member/views/(order)/order.checkout.dart';
import 'package:fridayonline/member/views/(order)/order.detail.dart';
import 'package:fridayonline/member/views/(showproduct)/show.category.view.dart';
import 'package:fridayonline/member/views/(top)/top.product.dart';
import 'package:fridayonline/preferrence.dart';
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
  var categoryID = pushNotify.categoryId;
  var sectionId = pushNotify.sectionId;
  var notifyId = pushNotify.notifyId;

  var repType = await data.repType;
  if (repType == "null") {
    repType = "";
  }

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
    // Get.offAll(() => const OnBoarding());
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
  }
}
