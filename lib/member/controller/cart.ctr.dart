import 'package:fridayonline/member/models/address/address.model.dart';
import 'package:fridayonline/member/models/cart/cart.bundle.model.dart';
import 'package:fridayonline/member/models/cart/cart.checkout.dart';
import 'package:fridayonline/member/models/cart/cart.checkout.input.dart';
import 'package:fridayonline/member/models/cart/cart.update.output.dart'
    as update_model;
import 'package:fridayonline/member/models/cart/getcart.model.dart';
import 'package:fridayonline/member/services/address/adress.service.dart';
import 'package:fridayonline/member/services/cart/cart.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class EndUserCartCtr extends GetxController {
  RxBool isLoadingCart = false.obs;
  RxBool isLoadingcChekcout = false.obs;
  RxBool isLoadingAddress = false.obs;
  RxBool isLoadingBundleProduct = false.obs;
  RxBool isFetchingLoadmore = false.obs;

  Rx<GetCartItems>? cartItems;
  Rx<CartCheckOut>? checkoutItems;
  AddressList? addressList;
  RxMap<int, int?> selectedOptions = <int, int?>{}.obs;
  RxString imageFirst = "".obs;
  // List<TierVariation>? originalTier;
  Rxn<List<Widget>> productPrice = Rxn<List<Widget>>();
  Rxn<dynamic> productTier = Rxn<dynamic>();
  RxInt stock = 0.obs;
  List<List<TextEditingController>>? qtyCtrs;
  late List<List<SlidableController>> controllers;
  late List<SlidableController> outstockController = [];
  List<Item>? outstockItems;
  Rxn<update_model.DiscountBreakdown> discountBreakdown =
      Rxn<update_model.DiscountBreakdown>();
  RxInt itemId = 0.obs;
  RxBool showEditCart = false.obs;
  Rxn<List<update_model.VoucherRecommend>> voucherRecommend =
      Rxn<List<update_model.VoucherRecommend>>();
  Map<String, String> paymentType = {};
  List<dynamic> problematicItems = [];
  List<dynamic> problematicGroups = [];
  String routeName = "";
  Rx<List<PackagedBundleInfo>> packageBundle = Rx([]);
  RxMap<String, bool> isActiveButton = <String, bool>{}.obs;

  BundleDeal? bundleProduct;

  setActiveButton(key) {
    isActiveButton[key] = true;
    isActiveButton.refresh();
    Future.delayed(const Duration(milliseconds: 200), () {
      isActiveButton[key] = false;
      isActiveButton.refresh();
    });
  }

  fetchCartItems() async {
    try {
      isLoadingCart.value = true;
      final items = await getCartService();
      cartItems = items.obs;
      await setInit();
      return cartItems;
    } finally {
      packageBundle.value = [];
      for (var items in cartItems!.value.data) {
        packageBundle.value = [
          ...packageBundle.value,
          ...items.packagedBundleInfo
        ];
      }
      isLoadingCart.value = false;
    }
  }

  fetchCartCheckOut(CartCheckOutInput input) async {
    try {
      isLoadingcChekcout.value = true;
      final items = await cartCheckOutService(input);
      checkoutItems = items.obs;
    } finally {
      isLoadingcChekcout.value = false;
    }
  }

  fetchAddressList() async {
    try {
      isLoadingAddress.value = true;
      addressList = await fetchAddressListService();
    } finally {
      isLoadingAddress.value = false;
    }
  }

  fetchBundleProduct(int bundleId, int offset) async {
    try {
      isLoadingBundleProduct(true);
      bundleProduct = await getBundelDealService(bundleId, offset);
    } finally {
      isLoadingBundleProduct(false);
    }
  }

  //? loadmore recommend
  Future<BundleDeal?>? fetchMoreBundleProductws(bundleId, offset) async {
    return await getBundelDealService(bundleId, offset);
  }

  // ? reset recommend
  void resetBundleProducts() {
    if (bundleProduct != null &&
        bundleProduct!.data.bundleDealProducts.length > 40) {
      bundleProduct!.data.bundleDealProducts =
          bundleProduct!.data.bundleDealProducts.sublist(0, 40);
    }
  }

  Future<Rx<GetCartItems>?>? fetchCartNoLoad() async {
    try {
      cartItems!.refresh();
      final items = await getCartService();
      cartItems!.value = items;
      await setInit();
      return cartItems;
    } finally {
      // cartItems!.refresh();
    }
  }

  setPaymentType(String type, String val) {
    paymentType['type'] = type;
    paymentType['value'] = val;
    update();
  }

  setInit() {
    qtyCtrs = List.generate(
      cartItems!.value.data.length,
      (index) => List.generate(
        cartItems!.value.data[index].items.length,
        (productIndex) {
          final quantity =
              cartItems!.value.data[index].items[productIndex].productQty;
          return TextEditingController(text: quantity.toString());
        },
      ),
    );
    outstockItems = cartItems!.value.data
        .expand((shop) => shop.items)
        .where((item) => item.stock == 0)
        .toList();
  }

  clearVal() {
    selectedOptions.clear();
    imageFirst.value = "";
    productPrice = Rxn<List<Widget>>();
    productTier = Rxn<dynamic>();
    stock.value = 0;
    if (qtyCtrs != null) {
      qtyCtrs!.clear();
    }
    outstockController.clear();
    if (outstockItems != null) {
      outstockItems!.clear();
    }
    discountBreakdown = Rxn<update_model.DiscountBreakdown>();
    itemId.value = 0;
    showEditCart.value = false;
    if (voucherRecommend.value != null) {
      voucherRecommend.value!.clear();
    }
  }

  clearWhenback() {
    selectedOptions.clear();
    imageFirst.value = "";
    productPrice = Rxn<List<Widget>>();
    productTier = Rxn<dynamic>();
    stock.value = 0;

    outstockController.clear();
    if (outstockItems != null) {
      outstockItems!.clear();
    }
    discountBreakdown = Rxn<update_model.DiscountBreakdown>();
    itemId.value = 0;
    showEditCart.value = false;
    if (voucherRecommend.value != null) {
      voucherRecommend.value!.clear();
    }
  }
}
