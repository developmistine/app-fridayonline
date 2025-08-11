// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, camel_case_types

// import 'dart:developer';

import 'package:fridayonline/controller/cart/dropship_controller.dart';
import 'package:fridayonline/controller/product_detail/product_detail_controller.dart';
// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/cart/cart_controller.dart';
import '../../../model/cart/cart_getItems.dart';
import '../../homepage/dialogalert/customalertdialogs.dart';
import '../../model/cart/cart_model.dart';
import '../../model/cart/dropship/dropship_model.dart';
// import '../../model/cart/dropship/dropship_status_addcart.dart';
// import '../../model/dropship/dropship_product_model.dart';
import '../../service/languages/multi_languages.dart';

// function fnEditCart รวมการหยิบสินค้าใส่ตระกร้า
// context      //DataCart  ข้อมูลสินค้าที่จะนำเข้าตระกร้า // addByPage เซ็ตค่าว่ากดมาจากไหน
fnEditCart(
    context, DataCart, String addByPage, String mChannel, String mChannelId,
    {required String ref, required String contentId}) async {
  var jsonAddToCart = <fnEditCartParm>[];
  String typeEdit = '';
  //เช็คชนิดการจัดการตระกร้า // i = insert , E = edit
  if (addByPage == 'ModalWebview' ||
      addByPage == 'CategoryList' ||
      addByPage == 'loadmore_page' ||
      addByPage == 'FlashSale') {
    typeEdit = 'I'; //insert to cart
  } else {
    typeEdit = 'E'; //edit count cart (add , reduce , remove)
  }
  //? ** เช็คการหยิบสินค้าแต่ละหน้าเนื่องจาก parameters ภายในไม่เหมือนกันจึงส้รางคลาส fnEditCartParm เพื่อ map ข้อมูล

  //กรณีหยิบสินค้าหน้า webview
  if (addByPage == 'ModalWebview') {
    //หน้า webview มี type เดียว
    DataCart as ProductDetailController;

    // map ข้อมูลเข้าตัวแปร jsonAddToCart
    jsonAddToCart.add(fnEditCartParm(
        DataCart.productDetail!.billCamp,
        DataCart.productDetail!.billCode,
        DataCart.countItems.value,
        DataCart.productDetail!.brandId,
        DataCart.productDetail!.media,
        DataCart.productDetail!.isInStock,
        DataCart.productDetail!.limitDesc));
  }

  //กรณีหยิบสินค้าผ่านหน้า listproduct
  else if (addByPage == 'CategoryList' || addByPage == 'FlashSale') {
    //หน้า listproduct มี หลายtypeที่ส่งเข้ามาเพื่อโชว์ จึงไม่ fix type แต่มี params ข้างในที่เหมือนกัน(campaign,billCode, brand, fsCode)
    // DataCart as Skucode;
    jsonAddToCart.add(fnEditCartParm(
      DataCart.campaign,
      DataCart.billCode,
      1,
      DataCart.brand,
      DataCart.mediaCode,
      DataCart.isInStock,
      DataCart.limitDescription,
    ));
  }
  //กรณี ลบ สินค้าหน้าตระกร้า
  else if (addByPage == 'cart_page_delete') {
    //หน้าตระกร้า จะมี type หลักคือ ItemsGetCart แต่นำข้อมูลภายในมาใ้ช้จึง set type เป็น Carddetail
    DataCart as Carddetail;
    // map ข้อมูลเข้าตัวแปร jsonAddToCart
    jsonAddToCart.add(fnEditCartParm(DataCart.billcamp, DataCart.billCode, 0,
        DataCart.brand, DataCart.media, DataCart.isInStock, ''));
  }
  //กรณีแก้ไข สินค้าหน้าตระกร้า
  else if (addByPage == 'cart_edit_amount') {
    //
    DataCart as Carddetail;

    // map ข้อมูลเข้าตัวแปร jsonAddToCart
    jsonAddToCart.add(fnEditCartParm(
        DataCart.billcamp,
        DataCart.billCode,
        DataCart.qty,
        DataCart.brand,
        DataCart.media,
        DataCart.isInStock,
        DataCart.stockDescription));
  }
  //กรณี กดจาก loadmore_page

  else if (addByPage == 'loadmore_page') {
    //
    // DataCart.runtimeType == HotItemasLoadMore
    //     ? DataCart as HotItemasLoadMore
    //     : DataCart as DataSqlHotitemsDetail;

    // map ข้อมูลเข้าตัวแปร jsonAddToCart
    jsonAddToCart.add(fnEditCartParm(
        DataCart.campaign,
        DataCart.billcode,
        1,
        DataCart.brand,
        DataCart.media,
        DataCart.isInStock,
        DataCart.limitDesc));
  }
  // ทำการ call ไปที่ CartItemsEdit เพื่อจัดการตระกร้าสินค้า
  // log(" camp ${jsonAddToCart[0].campaign}");
  // log(" billcode ${jsonAddToCart[0].billcode}");
  // log(" brand ${jsonAddToCart[0].brand}");
  // log(" total item ${jsonAddToCart[0].totalItems}");
  // log(" media ${jsonAddToCart[0].media}");
  // log(" instock ${jsonAddToCart[0].inStock}");
  // log(" limitDescript ${jsonAddToCart[0].limitDescription}");
  if (jsonAddToCart[0].inStock) {
    ItemCartEdit? callAddItem = await Get.find<CartItemsEdit>().edit_cart(
        jsonAddToCart[0].campaign,
        jsonAddToCart[0].billcode,
        jsonAddToCart[0].totalItems,
        typeEdit,
        '1', //billtype
        jsonAddToCart[0].brand,
        jsonAddToCart[0].media,
        mChannel,
        mChannelId,
        ref,
        contentId);
    if (callAddItem!.status == 'Error') {
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: CustomAlertDialogs(
              title: MultiLanguages.of(context)!.translate('limited_stock'),
              description: callAddItem.message,
            ),
          );
        },
      ).then((val) {
        // myFocusNode.requestFocus();
        return;
      });
    }
    return callAddItem.status;
  } else {
    if (typeEdit == 'E') {
      await Get.find<CartItemsEdit>().edit_cart(
          jsonAddToCart[0].campaign,
          jsonAddToCart[0].billcode,
          jsonAddToCart[0].totalItems,
          typeEdit,
          '1', //billtype
          jsonAddToCart[0].brand,
          jsonAddToCart[0].media,
          mChannel,
          mChannelId,
          ref,
          contentId);
    } else {
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return CustomAlertDialogs(
            title: MultiLanguages.of(context)!.translate('out_stock'),
            description:
                MultiLanguages.of(context)!.translate('temporarily_out_stock'),
          );
        },
      ).then((val) {
        // myFocusNode.requestFocus();
        return;
      });
    }
  }
}

fnEditCartDropship(context, DataCart, String addByPage, String mChannel,
    String mChannelId) async {
  List<fnDropsipParm> arrayDropship = [];
  String typeEdit = '';
  if (addByPage == 'Dropship' ||
      addByPage == 'cart_add_amount' ||
      addByPage.split(' ').first == 'dropship_ProductDetail') {
    typeEdit = 'I';
  } else if (addByPage == 'cart_remove_amount') {
    typeEdit = 'E';
  } else {
    typeEdit = 'D';
  }
  if (addByPage == 'Dropship') {
    // DataCart as Product;
    // map ข้อมูลเข้าตัวแปร
    arrayDropship.add(fnDropsipParm(
      DataCart.billCode,
      1,
      typeEdit,
    ));
    await Get.put(DropshipEditCart()).editCart(arrayDropship[0].billb2c,
        arrayDropship[0].qty, arrayDropship[0].action);
  } else if (addByPage == 'cart_add_amount') {
    // map ข้อมูลเข้าตัวแปร
    DataCart as CartDetail;

    arrayDropship.add(fnDropsipParm(
      DataCart.billB2C,
      1,
      typeEdit,
    ));
    await Get.put(DropshipEditCart()).editCart(arrayDropship[0].billb2c,
        arrayDropship[0].qty, arrayDropship[0].action);
  } else if (addByPage == 'cart_remove_amount') {
    DataCart as CartDetail;

    arrayDropship.add(fnDropsipParm(
      DataCart.billB2C,
      DataCart.qty,
      typeEdit,
    ));
    await Get.put(DropshipEditCart()).editCart(arrayDropship[0].billb2c,
        arrayDropship[0].qty, arrayDropship[0].action);
  } else if (addByPage == "cart_page_delete") {
    DataCart as CartDetail;
    // map ข้อมูลเข้าตัวแปร
    arrayDropship.add(fnDropsipParm(
      DataCart.billB2C,
      0,
      typeEdit,
    ));
    await Get.put(DropshipEditCart()).editCart(arrayDropship[0].billb2c,
        arrayDropship[0].qty, arrayDropship[0].action);
  } else if (addByPage.split(' ').first == 'dropship_ProductDetail') {
    arrayDropship.add(fnDropsipParm(
      DataCart.billCode,
      int.parse(addByPage.split(' ').last),
      typeEdit,
    ));
    await Get.put(DropshipEditCart()).editCart(arrayDropship[0].billb2c,
        arrayDropship[0].qty, arrayDropship[0].action);
  } else {
    DataCart as CartDetail;

    arrayDropship.add(fnDropsipParm(
      DataCart.billB2C,
      DataCart.qty,
      'E',
    ));
    await Get.put(DropshipEditCart()).editCart(arrayDropship[0].billb2c,
        arrayDropship[0].qty, arrayDropship[0].action);
  }
}

//? เพิ่ม parameters scaffoldKey เพื่อป้องกันการโชว์ altert ซ้ำแล้วเกิด error
fnEditCartInPageCart(scaffoldKey, context, DataCart, String addByPage) async {
  var jsonAddToCart = <fnEditCartParm>[];
  if (addByPage == 'cart_edit_amount') {
    //
    DataCart as Carddetail;

    // map ข้อมูลเข้าตัวแปร jsonAddToCart
    jsonAddToCart.add(fnEditCartParm(
        DataCart.billcamp,
        DataCart.billCode,
        DataCart.qty,
        DataCart.brand,
        DataCart.media,
        DataCart.isInStock,
        DataCart.stockDescription));

    if (jsonAddToCart[0].inStock) {
      ItemCartEdit? callAddItem = await Get.find<CartItemsEdit>().edit_cart(
          jsonAddToCart[0].campaign,
          jsonAddToCart[0].billcode,
          jsonAddToCart[0].totalItems,
          'E',
          '1', //billtype
          jsonAddToCart[0].brand,
          jsonAddToCart[0].media,
          '',
          '',
          'cart',
          '');
      if (callAddItem!.status == 'Error') {
        //? หาก status error ให้โชว์ popup แจ้งเตือนพร้อมข้อคสามจาก api
        showDialog(
          barrierColor: Colors.black26,
          context: scaffoldKey.currentContext,
          builder: (context) {
            return CustomAlertDialogs(
              title: MultiLanguages.of(context)!.translate('limited_stock'),
              description: callAddItem.message,
            );
          },
        ).then((val) {
          // myFocusNode.requestFocus();
          return;
        });
      }
      //? return status การจัดการตระกร้า
      // print(callAddItem.status);
      return callAddItem.status;
    } else {
      // return 'Error';
      //? alert ในกรณีที่ สินค้าหมดสต็อก
      // return 'Error';
      ItemCartEdit? callAddItem = await Get.find<CartItemsEdit>().edit_cart(
          jsonAddToCart[0].campaign,
          jsonAddToCart[0].billcode,
          jsonAddToCart[0].totalItems,
          'E',
          '1', //billtype
          jsonAddToCart[0].brand,
          jsonAddToCart[0].media,
          '',
          '',
          'cart',
          '');
      // print(callAddItem!.status);
      if (callAddItem!.status.toLowerCase() != 'sussess') {
        //? หาก status error ให้โชว์ popup แจ้งเตือนพร้อมข้อคสามจาก api
        showDialog(
          barrierColor: Colors.black26,
          context: scaffoldKey.currentContext,
          builder: (context) {
            return CustomAlertDialogs(
              title: MultiLanguages.of(context)!.translate('out_stock'),
              description: MultiLanguages.of(context)!
                  .translate('temporarily_out_stock'),
            );
          },
        ).then((val) {
          // myFocusNode.requestFocus();
          return;
        });
      }
      //? return status การจัดการตระกร้า
      // print(callAddItem.status);
      return callAddItem.status;
    }
  }
}

//? กรณีแลกรางวัลจาก start reward
fnEditCartRewardPoint(context, DataCart, Qty, check) async {
  var jsonAddToCart = <fnEditCartParm>[];
  //หน้า listproduct มี หลายtypeที่ส่งเข้ามาเพื่อโชว์ จึงไม่ fix type แต่มี params ข้างในที่เหมือนกัน(campaign,billCode, brand, fsCode)
  //DataCart  ProductByFscode;
  if (check == 'point') {
    jsonAddToCart.add(fnEditCartParm(
      DataCart.point[0].cateCamp,
      DataCart.point[0].productCode,
      Qty,
      '1',
      DataCart.point[0].mediaCode,
      DataCart.point[0].isStock,
      '',
    ));
  } else if (check == 'pointandmoney') {
    jsonAddToCart.add(fnEditCartParm(
      DataCart.pointandmoney[0].cateCamp,
      DataCart.pointandmoney[0].productCode,
      Qty,
      '1',
      DataCart.pointandmoney[0].mediaCode,
      DataCart.pointandmoney[0].isStock,
      '',
    ));
  }

  if (jsonAddToCart[0].inStock) {
    ItemCartEdit? callAddItem = await Get.find<CartItemsEdit>().edit_cart(
        jsonAddToCart[0].campaign,
        jsonAddToCart[0].billcode,
        jsonAddToCart[0].totalItems,
        'I',
        '1', //billtype
        jsonAddToCart[0].brand,
        jsonAddToCart[0].media,
        '',
        '',
        'reward',
        '');
    if (callAddItem!.status == 'Sussess') {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Center(
              child: Text(
                'ยินดีด้วย',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'notoreg'),
              ),
            ),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Center(
                      child: Text(
                    'คุณใช้คะแนนแลกของรางวัลแล้ว\nกรุณายืนยันในตะกร้า',
                    style: TextStyle(fontFamily: 'notoreg'),
                  )),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                    MultiLanguages.of(context)!.translate('alert_close'),
                    style: const TextStyle(
                        color: Colors.blue, fontFamily: 'notoreg')),
              ),
            ],
          );
        },
      );
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Center(
              child: Text(
                'สินค้าหมดสต็อก',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Center(child: Text(callAddItem.message)),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                    MultiLanguages.of(context)!.translate('alert_close'),
                    style: const TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );
    }
    return callAddItem.status;
  } else {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Center(
            child: Text(
              'สินค้าหมดสต็อก',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text('ขออภัยค่ะ สินค้าหมดสต็อกชั่วคราว')),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(MultiLanguages.of(context)!.translate('alert_close'),
                  style: const TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}

//? class สำหรับ map parameters
class fnEditCartParm {
  String campaign;
  String billcode;
  int totalItems;
  String brand;
  String media;
  bool inStock;
  String limitDescription;
  fnEditCartParm(this.campaign, this.billcode, this.totalItems, this.brand,
      this.media, this.inStock, this.limitDescription);
}

//? class dropship
class fnDropsipParm {
  String billb2c;
  int qty;
  String action;
  fnDropsipParm(this.billb2c, this.qty, this.action);
}
