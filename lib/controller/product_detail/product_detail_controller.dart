// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:get/get.dart';

import '../../model/product_detail/product_detail_model.dart';
import '../../service/product_details/product_details_services.dart';

class ProductDetailController extends GetxController {
  ProductDetailModel? productDetail;
  List<ProductDetailModel>? cacheProductDetail = [];
  ProductDetailModel? cacheProductDetailFlash;
  RxInt indexPage = 0.obs;
  RxInt indexProductGroup = 0.obs;
  RxInt countItems = 1.obs;
  List<String> listCampaign = [];
  List<String> listBillcode = [];
  List<String> listMedia = [];
  List<String> listSku = [];
  String listChannel = "";
  String listChannelId = "";

  var isDataLoading = false.obs;

  void addItemsCart() {
    if (countItems.value <= 999) {
      countItems.value = countItems.value + 1;
    }
  }

  void removeItemsCart() {
    if (countItems.value > 1) {
      countItems.value = countItems.value - 1;
    }
  }

  removeAllArray() {
    listChannel = "";
    listChannelId = "";
    cacheProductDetail!.clear();
    productDetail = null;
  }

  removeLastId() {
    if (listBillcode.isNotEmpty) {
      listChannel = "";
      listChannelId = "";
      cacheProductDetail!.removeLast();
    }
  }

  setProductDetailByProductGroup(ProductGroup prdGroup, int index) {
    productDetail!.billCamp = prdGroup.billCamp;
    productDetail!.billCode = prdGroup.billCode;
    productDetail!.media = prdGroup.media;
    productDetail!.fsCode = prdGroup.fsCode;
    productDetail!.fsCodeTemp = prdGroup.fsCodeTemp;
    productDetail!.billName = prdGroup.billName;
    productDetail!.isShareFlag = prdGroup.isShareFlag;
    productDetail!.isInStock = prdGroup.isInStock;
    productDetail!.isHousebrand = prdGroup.isHousebrand;
    productDetail!.isNetprice = prdGroup.isNetprice;
    productDetail!.specialPrice = prdGroup.specialPrice;
    productDetail!.billColor = prdGroup.billColor;
    productDetail!.brandCode = prdGroup.brandCode;
    productDetail!.brandId = prdGroup.brandId;
    productDetail!.category = prdGroup.category;
    productDetail!.subCategory = prdGroup.subCategory;
    productDetail!.reviews = prdGroup.reviews;
    productDetail!.productImages = prdGroup.productImages;
    productDetail!.description = prdGroup.description;

    indexProductGroup.value = index;
    update();
  }

  productDetailController(
      campaign, billcode, media, sku, channel, channelId) async {
    listChannel = channel;
    listChannelId = channelId;

    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      productDetail = await callProductDetails(
          campaign, billcode, media, sku, channel, channelId);
      return productDetail;
    } finally {
      if (Get.currentRoute == '/OutStockFlashSale') {
        cacheProductDetailFlash = productDetail;
      }
      cacheProductDetail!.add(productDetail!);
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  // onclose
  @override
  void onClose() {
    super.onClose();
    removeAllArray();
    indexProductGroup.value = 0;
    countItems.value = 1;
  }
}
