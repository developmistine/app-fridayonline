import 'package:fridayonline/enduser/controller/track.ctr.dart';
import 'package:fridayonline/enduser/models/brands/shopfilter.model.dart';
import 'package:fridayonline/enduser/models/showproduct/product.sku.model.dart';
import 'package:fridayonline/enduser/services/brands/brands.service.dart';
import 'package:fridayonline/enduser/services/showproduct/showproduct.sku.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ShowProductSkuCtr extends GetxController {
  final TrackCtr trackCtr = Get.put(TrackCtr());
  final RxBool isLoadingProduct = false.obs;
  RxInt indexPrdOption = (-1).obs;
  RxInt stock = 0.obs;
  RxString imageFirst = "".obs;
  RxMap<int, int?> selectedOptions = <int, int?>{}.obs;
  RxInt itemId = 0.obs;
  RxDouble htmlHeight = 0.0.obs;
  Rxn<dynamic> productPrice = Rxn<dynamic>();
  Rxn<dynamic> productTier = Rxn<dynamic>();
  Map<String, VideoPlayerController>? videoCtr = {};
  Map<String, GlobalKey<State<HtmlWidget>>> htmlKey = {};
  RxInt indexActive = (-1).obs;
  RxBool isOptionOutStock = false.obs;

  RxBool isExpanded = false.obs;
  RxBool isSetAppbar = false.obs;
  //
  ScrollController scrollController = ScrollController();

  Rx<String> activeKey = "".obs;
  Rx<String> reminderText = "".obs;
  Rx<int> activeSlide = 0.obs;
  // เก็บข้อมูลสินค้าเป็น Map โดยใช้ productId เป็น key
  var productCache = <String, EndUserProductDetail>{}.obs;
  // เก็บข้อมูลสินค้าปัจจุบันที่กำลังดู
  Rxn<EndUserProductDetail> productDetail = Rxn<EndUserProductDetail>();
  // สร้าง GlobalKey ใหม่ทุกครั้งที่โหลดสินค้าใหม่

  late Future<ShopProductFilter?> shopProductsFuture;

  Future<void> fetchB2cProductDetail(productId, String referrer) async {
    productId = productId.toString();
    isSetAppbar.value = false;
    try {
      // ถ้ามีข้อมูลใน cache แล้ว ไม่ต้องโหลดใหม่
      if (productCache.containsKey(productId)) {
        var product = productDetail.value!.data;
        setTrackProduct(
            product.shopId,
            product.productId,
            product.title,
            product.catId,
            product.catName,
            productValue(productPrices: productDetail.value!.data.productPrice),
            referrer);
        productDetail.value = productCache[productId];
        isSetAppbar.value = false;
        productCache.removeWhere((key, value) => key == productId);
        return;
      }
      isLoadingProduct.value = true;
      // โหลดข้อมูลจาก API และเก็บลง cache
      final product = await fetchProductDetailService(productId);
      productCache[productId] = product!;
      productDetail.value = product;
      var data = productDetail.value!.data;
      setTrackProduct(
          data.shopId,
          data.productId,
          data.title,
          data.catId,
          data.catName,
          productValue(productPrices: productDetail.value!.data.productPrice),
          referrer);
    } finally {
      if (productDetail.value == null) {
        isLoadingProduct.value = false;
      } else {
        getHtmlHeight(productId);
        shopProductsFuture = fetchShopProductFilterServices(
          0,
          productDetail.value!.data.shopDetailed.shopId,
          'sales',
          '',
          0,
        );
        if (productDetail.value!.data.tierVariations.isEmpty) {
          if (productDetail.value!.data.stock == 0) {
            isOptionOutStock.value = true;
          }
        } else if (productDetail.value!.data.tierVariations.length == 1) {
          isOptionOutStock.value = productDetail.value!.data.tierVariations
                  .first.options.first.displayIndicators ==
              2;
        }
        productPrice.value = productDetail.value!.data.productPrice.copyWith();
        productTier.value = productDetail.value!.data.tierVariations;
        isLoadingProduct.value = false;
      }
    }
  }

  void getHtmlHeight(String productId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // สร้าง GlobalKey ใหม่ทุกครั้งที่โหลดสินค้าใหม่
      htmlKey[productId] = GlobalKey<State<HtmlWidget>>();
      // htmlKey.putIfAbsent(productId, () => GlobalKey<State<HtmlWidget>>());

      final context = htmlKey[productId]?.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          htmlHeight.value = renderBox.size.height;
        }
      }
    });
  }

  setTrackProduct(int? shopId, int? productId, String? productName, int? catId,
      String? catName, double? price, String referrer) {
    trackCtr.shopId = shopId;
    trackCtr.productId = productId;
    trackCtr.productName = productName;
    trackCtr.catId = catId;
    trackCtr.catName = catName;
    trackCtr.price = price;
    trackCtr.referrer = referrer;
  }

  productValue({required productPrices}) {
    if (!productPrices.haveDiscount) {
      return productPrices.priceBeforeDiscount.singleValue > 0
          ? productPrices.priceBeforeDiscount.singleValue
          : productPrices.priceBeforeDiscount.rangeMax;
    } else {
      return productPrices.price.singleValue > 0
          ? productPrices.price.singleValue
          : productPrices.price.rangeMax;
    }
  }
}
