// ignore_for_file: non_constant_identifier_names

// import 'dart:developer';

import '../../model/home/banner_image.dart';
import '../../model/home/banner_product.dart';
import '../../model/home/draggable_fab_model.dart';
import '../../model/home/favorite.dart';
import '../../model/home/favorite_product.dart';
import '../../model/home/hoem_get_point.dart';
import '../../model/home/home_new_content.dart';
import '../../model/home/keyIcon.dart';
// import '../../model/home/popup_promotion_model.dart';
import '../../model/home/product_hot_item.dart';
import '../../model/home/product_hot_item_loadmore.dart';
// import '../../model/home/special_discount.dart';
// import '../../model/home/special_discount_loadmore.dart';
import '../../model/home/special_promotion.dart';
import '../../service/home/home_service.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  HomeBanner? banner; //เรียกใช้ model HomeBanner
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

  get_banner_data() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      banner =
          await call_banner_image(); //เรียกใช้งาน service สำหรับเรีกข้อมูล แบนเนอร์
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

class FavoriteController extends GetxController {
  GetFavorite? favorite;

  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

  get_favorite_data() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      favorite = await call_favorite_items();
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

class SpecialPromotionController extends GetxController {
  SpecialPromotion? promotion; //เรียกใช้ model SpecialPromotion

  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

  get_promotion_data() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      promotion =
          await call_special_promotion(); //เรียกใช้งาน service สำหรับเรีกข้อมูล Special Promotion
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

// class SpecialDiscountController extends GetxController {
//   // controller สำหรับเรียกข้อมูล Special Discount
//   SpecialDiscount? discount; //เรียกใช้ model SpecialDiscount

//   var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

//   fetch_special_discount() async {
//     //ฟังก์ชันสำหรับเรีกข้อมูล Special Discount
//     try {
//       isDataLoading(true); // สถานะการโหลดข้อมูล true
//       discount =
//           await call_special_discount(); //เรียกใช้งาน service สำหรับเรีกข้อมูล Special Discount
//       // print("ton");
//       // print(discount?.toJson());
//     } finally {
//       isDataLoading(false); // สถานะการโหลดข้อมูล false

//     }
//   }
// }

// class SpecialDiscountLoadMoreController extends GetxController {
//   // controller สำหรับเรียกข้อมูล Special Discount
//   SpecialProductLoadMore? discount; //เรียกใช้ model SpecialDiscount

//   var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

//   fetch_special_discount() async {
//     //ฟังก์ชันสำหรับเรีกข้อมูล Special Discount
//     try {
//       isDataLoading(true); // สถานะการโหลดข้อมูล true
//       discount =
//           await call_specialdiscount_loadmore(); //เรียกใช้งาน service สำหรับเรีกข้อมูล Special Discount
//       // print("ton");
//       //print(discount?.toJson());
//     } finally {
//       isDataLoading(false); // สถานะการโหลดข้อมูล false

//     }
//   }
// }

class ProductHotItemHomeController extends GetxController {
  ProductHotItem? productHotItem; //เรียกใช้ model ProductHotItem

  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

  get_product_hotitem_data() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      productHotItem =
          await call_first_load_product_hotitem(); //เรียกใช้งาน service สำหรับเรีกข้อมูล สินค้า 12 ตัวแรก
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

class ProductHotIutemLoadmoreController extends GetxController {
  ProductHotItemLoadmore? item; //เรียกใช้ model ProductHotItemLoadmore
  var isAddLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  var itemList = List<HotItemasLoadMore>.empty(growable: true).obs;
  var itemProduct = 0;

  void resetItem() {
    itemList.clear();
    itemProduct = 0;
  }

  void addItem() async {
    //ฟังก์ชันสำหรับเรีกข้อมูล Load more
    try {
      itemProduct = 0;
      isAddLoading(true); // สถานะการโหลดข้อมูล true
      item =
          await call_load_more_product_hotitem(); //เรียกใช้งาน service สำหรับเรีกข้อมูล Load more
      itemProduct = item!.hotItemasLoadMore.length;
      itemList.addAll(item!.hotItemasLoadMore);
    } finally {
      isAddLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

// !controller for get banner product
class ProductFromBanner extends GetxController {
  GetProductByCategoryBanner? BannerProduct;
  String pathShare = '';
  var isDataLoading = false.obs;
  var isScrollLoading = false.obs;
  fetch_product_banner(categoryID, campaign) async {
    if (campaign == "" && categoryID != "") {
      campaign = "''";
      pathShare = "$categoryID/$campaign";
    } else if (campaign != "" && campaign != "") {
      pathShare = "$categoryID/$campaign";
    } else {
      pathShare = "";
    }

    try {
      isDataLoading(true);
      BannerProduct = await call_product_banner(categoryID, campaign);
    } finally {
      isDataLoading(false);
    }
  }
}

// !controller for get favorite items
class FavoriteItemController extends GetxController {
  GetFavorite? favoriteItemController;

  var isDataLoading = false.obs;
  // @override
  // void onInit() {
  //   super.onInit();
  //   favoriteItem();
  // }

  favoriteItem() async {
    try {
      isDataLoading(true);
      favoriteItemController = await call_favorite_items();
    } finally {
      // log("Items is ${favoriteItemController!.favorite.toList().toString()}");
      isDataLoading(false);
    }
  }
}

// !controller for get favorite product
class FavoriteGetProductController extends GetxController {
  GetFavoriteProduct? favoriteProduct;

  var isDataLoading = false.obs;

  fetch_favorite_product(categoryID) async {
    isDataLoading(true);
    favoriteProduct = await call_favorite_product(categoryID);
    isDataLoading(false);
  }
}

class PopUpStatusController extends GetxController {
  var isViewPopup = false;
  var isViewPopupTranfer = false.obs;
  var draggableFab = false;
  var isViewPopupLeadRegis = false;
  void ChangeStatusViewPopup() {
    isViewPopup = true;
  }

  void ChangeStatusViewPopupFalse() {
    isViewPopup = false;
  }

  changeStatusViewPopupTranfer(bool bool) {
    isViewPopupTranfer.value = bool;
  }

  draggableFabUpdate() {
    draggableFab = true;
  }

  void ChangeStatusViewPopupLeadRegis() {
    isViewPopupLeadRegis = true;
  }
}

//? keyIcon
class KeyIconController extends GetxController {
  GetKeyIcon? keyIcon;
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

  get_keyIcon_data() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      keyIcon =
          await call_key_icon(); //เรียกใช้งาน service สำหรับเรีกข้อมูล แบนเนอร์
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

//? hoem get point
class HomePointController extends GetxController {
  HomeGetPoint? home_point;
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  var isLoadingPoint = false.obs;
  var isShow = false.obs;
  get_home_point_data(bool isShowPoint) async {
    isShow(isShowPoint);
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      home_point = await call_home_point(
          isShowPoint); //เรียกใช้งาน service สำหรับเรีกข้อมูล แบนเนอร์
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  showHidePoint(bool flag) async {
    isShow(flag);
    try {
      isLoadingPoint(true);
      home_point = await call_home_point(flag);
    } finally {
      isLoadingPoint(false);
    }
  }
}

//? hoem new content
class HomeContentSpecialListController extends GetxController {
  HomeNewContent? home_content;
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

  get_home_content_data(seemore) async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      home_content = await call_home_new_content(
          seemore); //เรียกใช้งาน service สำหรับเรีกข้อมูล แบนเนอร์
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

class DraggableFabController extends GetxController {
  DraggableFabModel? popUpData;
  var draggableFab = false.obs;
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

  draggableFabUpdate() {
    draggableFab = true.obs;
    update();
  }

  draggable_Fab() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      popUpData = await call_draggable_fab();
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}
