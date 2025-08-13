import 'package:appfridayecommerce/enduser/components/webview/webview.dart';
import 'package:appfridayecommerce/enduser/controller/brand.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/category.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/showproduct.category.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/showproduct.sku.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/track.ctr.dart';
import 'package:appfridayecommerce/enduser/views/(brand)/brand.category.dart';
import 'package:appfridayecommerce/enduser/views/(category)/subcategory.view.dart';
import 'package:appfridayecommerce/enduser/views/(coupon)/coupon.all.dart';
import 'package:appfridayecommerce/enduser/views/(showproduct)/show.category.view.dart';
import 'package:get/get.dart';
import 'package:appfridayecommerce/enduser/models/brands/shopcontent.model.dart'
    as shop;
import 'package:appfridayecommerce/enduser/models/notify/notify.model.dart'
    as notify;

final CategoryCtr categoryCtr = Get.find();
final BrandCtr brandCtr = Get.find<BrandCtr>();
Future<void> eventBanner(contentDetails, String contentType) async {
  var actionType = 0;
  var actionValue = "";
  int contentId = 0;

  try {
    actionType = contentDetails.actionType;
    actionValue = contentDetails.actionValue;
    contentId = contentDetails.contentId;
  } catch (e) {
    actionType = contentDetails.action.key;
    actionValue = contentDetails.action.value;
    contentId = 0;
  }

  switch (actionType) {
    case 0:
      {
        // image
        break;
      }
    case 1:
      {
        // ไปหน้า webview
        Get.find<TrackCtr>()
            .setDataTrack(0, contentDetails.contentName, contentType);
        if (contentDetails.contentName == 'รวมคูปอง') {
          Get.to(() => const CouponAll());
          break;
        } else {
          Get.to(() =>
              WebViewApp(mparamurl: actionValue, mparamTitleName: 'ฟรายเดย์'));
        }

        break;
      }
    case 2:
      {
        // prouct filter ไปหน้ารายการสินค้า
        var catid = int.tryParse(actionValue);
        if (contentType == 'home_banner') {
          Get.find<TrackCtr>().setLogContentAddToCart(contentId, contentType);
        }
        Get.find<TrackCtr>()
            .setDataTrack(contentId, contentDetails.contentName, contentType);
        categoryCtr.fetchSubCategory(catid ?? 0);
        Get.find<ShowProductCategoryCtr>().fetchProductByCategoryIdWithSort(
            catid ?? 0, 0, "ctime", "", 40, 0);
        await Get.to(() => const SubCategory())!.then((res) {
          Get.find<TrackCtr>().clearLogContent();
        });

        break;
      }
    case 3:
      {
        // ไปหน้า shop
        int shopId = int.tryParse(actionValue) ?? 0;
        var sectionId = contentDetails.sectionId ?? 0;
        var viewType = contentDetails.viewType ?? 0;
        if (contentType == 'home_banner') {
          Get.find<TrackCtr>().setLogContentAddToCart(contentId, contentType);
        }

        Get.find<TrackCtr>()
            .setDataTrack(contentId, contentDetails.contentName, contentType);
        brandCtr.fetchShopData(shopId);
        await Get.toNamed('/BrandStore/$shopId', arguments: 0, parameters: {
          "sectionId": sectionId.toString(),
          "viewType": viewType.toString()
        })!
            .then((value) {
          Get.find<TrackCtr>().clearLogContent();
        });
        break;
      }
    case 4:
      {
        //product content ไปหน้ารายการสินค้า
        if (contentType == 'home_banner') {
          Get.find<TrackCtr>().setLogContentAddToCart(contentId, contentType);
        }

        Get.find<TrackCtr>()
            .setDataTrack(contentId, contentDetails.contentName, contentType);
        Get.find<ShowProductCategoryCtr>()
            .fetchProductByCategoryId(actionType, actionValue, 0);
        await Get.to(() => const ShowProductCategory())!.then((value) {
          Get.find<TrackCtr>().clearLogContent();
        });
        break;
      }
    case 6:
      {
        // sku product
        Get.find<TrackCtr>()
            .setDataTrack(contentId, contentDetails.contentName, contentType);
        if (contentType == 'home_banner') {
          Get.find<TrackCtr>().setLogContentAddToCart(contentId, contentType);
        }
        Get.find<ShowProductSkuCtr>()
            .fetchB2cProductDetail(actionValue, contentType);
        await Get.toNamed(
          '/ShowProductSku/$actionValue',
        )!
            .then((value) {
          Get.find<TrackCtr>().clearLogContent();
        });
        break;
      }
    case 7:
      {
        // ไปหน้า shop
        int shopId = int.tryParse(actionValue) ?? 0;
        var sectionId = contentDetails.sectionId ?? 0;
        if (contentType == 'home_banner') {
          Get.find<TrackCtr>().setLogContentAddToCart(contentId, contentType);
        }

        Get.find<TrackCtr>()
            .setDataTrack(contentId, contentDetails.contentName, contentType);
        brandCtr.fetchShopData(shopId);
        await Get.toNamed('/BrandStore/$shopId', arguments: 1, parameters: {
          "sectionId": sectionId.toString(),
          "viewType": '1'
        })!
            .then((value) {
          Get.find<TrackCtr>().clearLogContent();
        });
        break;
      }
    default:
      break;
  }
}

Future<void> eventNotify(
    notify.Datum contentDetails, String contentType) async {
  switch (contentDetails.actionType) {
    case "0":
      {
        // image
        break;
      }
    case "1":
      {
        // ไปหน้า webview
        Get.find<TrackCtr>().setDataTrack(
            contentDetails.notifyId, contentDetails.title, contentType);
        if (contentDetails.title == 'รวมคูปอง') {
          Get.to(() => const CouponAll());
          break;
        } else {
          Get.to(() => WebViewApp(
              mparamurl: contentDetails.actionValue,
              mparamTitleName: 'ฟรายเดย์'));
        }
        break;
      }
    case "2":
      {
        // prouct filter ไปหน้ารายการสินค้า
        var catid = int.tryParse(contentDetails.actionValue);
        Get.find<TrackCtr>()
            .setLogContentAddToCart(contentDetails.notifyId, 'notify');
        Get.find<TrackCtr>().setDataTrack(
            contentDetails.notifyId, contentDetails.title, contentType);
        categoryCtr.fetchSubCategory(catid ?? 0);
        Get.find<ShowProductCategoryCtr>().fetchProductByCategoryIdWithSort(
            catid ?? 0, 0, "ctime", "", 40, 0);
        await Get.to(() => const SubCategory())!.then((value) {
          Get.find<TrackCtr>().clearLogContent();
        });
        break;
      }
    case "3":
      {
        Get.find<TrackCtr>()
            .setLogContentAddToCart(contentDetails.notifyId, 'notify');
        int contentId = int.tryParse(contentDetails.actionValue) ?? 0;
        // ไปหน้า shop
        Get.find<TrackCtr>().setDataTrack(
            contentDetails.notifyId, contentDetails.title, contentType);
        brandCtr.fetchShopData(contentId);
        await Get.toNamed('/BrandStore/$contentId')!.then((value) {
          Get.find<TrackCtr>().clearLogContent();
        });
        break;
      }
    case "4":
      {
        //product content ไปหน้ารายการสินค้า
        Get.find<TrackCtr>()
            .setLogContentAddToCart(contentDetails.notifyId, 'notify');
        Get.find<TrackCtr>().setDataTrack(
            contentDetails.notifyId, contentDetails.title, contentType);
        Get.find<ShowProductCategoryCtr>().fetchProductByCategoryId(
            int.tryParse(contentDetails.actionType) ?? 0,
            contentDetails.actionValue,
            0);
        await Get.to(() => const ShowProductCategory())!.then((value) {
          Get.find<TrackCtr>().clearLogContent();
        });
        break;
      }
    case "6":
      {
        // sku product
        Get.find<TrackCtr>()
            .setLogContentAddToCart(contentDetails.notifyId, 'notify');
        Get.find<TrackCtr>().setDataTrack(
            contentDetails.notifyId, contentDetails.title, contentType);
        Get.find<ShowProductSkuCtr>()
            .fetchB2cProductDetail(contentDetails.actionValue, contentType);
        await Get.toNamed(
          '/ShowProductSku/${contentDetails.actionValue}',
        )!
            .then((value) {
          Get.find<TrackCtr>().clearLogContent();
        });
        break;
      }
    default:
      break;
  }
}

void eventshopContent(shop.ContentDetail contentDetails) {
  switch (contentDetails.actionType) {
    case 1:
      {
        // case image
        break;
      }
    case 2:
      {
        Get.find<TrackCtr>().setDataTrack(contentDetails.contentId,
            contentDetails.contentName, "shop_content");
        // case url ไปหน้า webview
        Get.to(() => WebViewApp(
            mparamurl: contentDetails.actionValue,
            mparamTitleName: 'ฟรายเดย์'));

        break;
      }
    case 3:
      {
        // Get.find<TrackCtr>().setDataTrack(contentDetails.contentId,
        //     contentDetails.contentName, "shop_content");
        // case product detail
        Get.find<ShowProductSkuCtr>()
            .fetchB2cProductDetail(contentDetails.actionValue, 'shop_content');
        Get.toNamed(
          '/ShowProductSku/${contentDetails.actionValue}',
        );
        break;
      }
    case 4:
      {
        // case procuct filter shop
        int actionValue = int.tryParse(contentDetails.actionValue) ?? 0;
        Get.find<TrackCtr>().setDataTrack(contentDetails.contentId,
            contentDetails.contentName, "shop_content");
        brandCtr.fetchShopProductFilter(actionValue, brandCtr.shopIdVal,
            categoryCtr.sortData!.data.first.sortBy, "", 0);
        Get.to(() => const ShowProductBrands());
        break;
      }
    default:
      break;
  }
}
