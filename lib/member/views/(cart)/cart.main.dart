import 'dart:async';
import 'dart:convert';

import 'package:fridayonline/member/components/cache/image/cache.image.dart';
import 'package:fridayonline/member/components/cart/appbar.cart.dart';
import 'package:fridayonline/member/components/cart/option.items.dart';
import 'package:fridayonline/member/components/cart/outstock.product.dart';
import 'package:fridayonline/member/components/cart/storer.coupon.dart';
import 'package:fridayonline/member/components/cart/storer.shipping.discount.dart';
import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/controller/chat.ctr.dart';
import 'package:fridayonline/member/controller/coupon.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/models/cart/cart.checkout.input.dart'
    as checkout_model;
import 'package:fridayonline/member/models/cart/cart.update.input.dart';
import 'package:fridayonline/member/models/cart/getcart.model.dart';
import 'package:fridayonline/member/models/chat/seller.list.model.dart';
import 'package:fridayonline/member/services/cart/cart.service.dart';
import 'package:fridayonline/member/services/chat/chat.service.dart';
import 'package:fridayonline/member/services/coupon/coupon.services.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(cart)/cart.bundle.dart';
import 'package:fridayonline/member/views/(cart)/cart.coupon.dart';
import 'package:fridayonline/member/views/(cart)/cart.sumary.dart';
import 'package:fridayonline/member/views/(chat)/chat.seller.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/print.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fridayonline/member/models/cart/cart.update.input.dart'
    as update_input;

final EndUserCartCtr cartCtr = Get.find();
final ShowProductSkuCtr showProductCtr = Get.find();
final CheckboxController controller = Get.put(CheckboxController());
final EndUserCouponCartCtr endUserCouponCtr = Get.find();

class EndUserCart extends StatefulWidget {
  const EndUserCart({super.key});

  @override
  State<EndUserCart> createState() => _EndUserCartState();
}

class _EndUserCartState extends State<EndUserCart>
    with TickerProviderStateMixin {
  bool slideOpen = false;
  List<List<SlidableController>> controllers = [];
  List<SlidableController> outstockController = [];

  Timer? debounce;
  bool isLoaded = false;
  var previousValue = "1";

  @override
  void dispose() {
    if (!mounted) return;
    // cartCtr.qtyCtrs!.clear();
    cartCtr.outstockItems!.clear();
    previousValue = "1";

    controllers.clear();
    outstockController.clear();
    cartCtr.problematicGroups.clear();
    cartCtr.problematicItems.clear();
    super.dispose();
  }

  setControllerSlide() async {
    if (!isLoaded) {
      isLoaded = true;

      controllers = List.generate(
        cartCtr.cartItems!.value.data.length,
        (index) => List.generate(
          cartCtr.cartItems!.value.data[index].items.length,
          (productIndex) {
            return SlidableController(this);
          },
        ),
      );

      outstockController = List.generate(
        cartCtr.outstockItems!.length,
        (productIndex) {
          return SlidableController(this);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        // if (didPop) {
        //   return;
        // }
        controller.selectedKeys.clear();
        controller.seleletedProuduct.clear();
        cartCtr.clearWhenback();
        endUserCouponCtr.clearVal();
        previousValue = "1";
      },
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Theme(
          data: Theme.of(context).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle: GoogleFonts.ibmPlexSansThai())),
            textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: Colors.white,
                  appBar: appbarCart(),
                  body: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        color: Colors.grey.shade100,
                      ),
                      RefreshIndicator(
                        color: Colors.amber,
                        onRefresh: () async {
                          controller.deselectAllCart();
                          cartCtr.problematicGroups.clear();
                          cartCtr.problematicItems.clear();
                          cartCtr.fetchCartItems().then((res) {
                            setControllerSlide();
                          });
                        },
                        child:
                            // GetBuilder<EndUserCartCtr>(builder: (cartCtr) {
                            Obx(() {
                          if (cartCtr.isLoadingCart.value) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          } else {
                            setControllerSlide();
                            List<Datum> cartShop =
                                cartCtr.cartItems!.value.data;

                            if (cartShop.isNotEmpty) {
                              return Container(
                                color: Colors.grey.shade100,
                                height: Get.height,
                                child: SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          itemCount: cartShop.length,
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var isShopOutStock = cartShop[index]
                                                .items
                                                .every(
                                                    (item) => item.stock == 0);
                                            if (isShopOutStock) {
                                              return const SizedBox();
                                            }

                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  left: 8, right: 8, top: 8),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: bundleProduts(
                                                    cartShop, index, context),
                                              ),
                                            );
                                          }),
                                      OutStockProduct(
                                        outstockItems: cartCtr.outstockItems!,
                                        outstockController: outstockController,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/cart/zero_cart.png',
                                    width: 150,
                                  ),
                                  const Text(
                                    'ไม่พบสินค้าในตะกร้า',
                                  ),
                                ],
                              ));
                            }
                          }
                        }),
                      ),
                    ],
                  ),
                  bottomNavigationBar: bottomSheetCart(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> bundleProduts(
      List<Datum> cartShop, int index, BuildContext context) {
    return [
      headerShop(cartShop, index),
      const Divider(
        height: 0,
      ),
      Builder(
        builder: (context) {
          // สร้าง Map สำหรับจัดกลุ่มสินค้าตาม bundle_id
          var groupedItems = <int, List<Item>>{};

          for (var item in cartShop[index].items) {
            int bundleId = item.bundleId;
            if (!groupedItems.containsKey(bundleId)) {
              groupedItems[bundleId] = [];
            }
            groupedItems[bundleId]!.add(item);
          }

          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: groupedItems.length, // จำนวนกลุ่มของ bundle
            itemBuilder: (context, bundleIndex) {
              // ค้นหา bundleId ของ group ที่จะแสดง
              var bundleId = groupedItems.keys.elementAt(bundleIndex);

              // ใช้ Rx สำหรับ bundle
              var bundle = cartCtr.packageBundle.value
                  .firstWhereOrNull((bundle) => bundle.bundleId == bundleId)
                  .obs;

              return Obx(() {
                // print(cartCtr.packageBundle.value);
                // if (cartCtr.packageBundle.value.isEmpty) {
                //   return const SizedBox();
                // }
                // ตรวจสอบการเปลี่ยนแปลงของ bundle
                return Column(
                  crossAxisAlignment: cartCtr.packageBundle.value.isEmpty
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.start,
                  children: [
                    // ถ้ามี bundle ก็แสดง header ของ bundle แค่ครั้งเดียว
                    if (bundle.value != null)
                      InkWell(
                        onTap: () {
                          cartCtr.fetchBundleProduct(bundle.value!.bundleId, 0);
                          Get.to(() =>
                              BundleProducts(bundleId: bundle.value!.bundleId));
                        },
                        child: Container(
                          width: Get.width,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.deepOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_mall,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    bundle.value!.bannerText,
                                    style: const TextStyle(
                                      fontSize: 11,
                                    ),
                                  )
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (cartShop[index].items[bundleIndex].bundleId != 0)
                      const Divider(),

                    // แสดงสินค้าของกลุ่มนี้
                    ...groupedItems[bundleId]!.map((item) {
                      return Column(
                        children: [
                          // if (item.bundleId == 0) Text('xxx'),
                          listProductbyShop(cartShop, item, index,
                              cartShop[index].items.indexOf(item)),
                        ],
                      );
                    })
                  ],
                );
              });
              // ถ้าไม่มี bundle
            },
          );
        },
      ),
      const Divider(
        height: 0,
      ),
      if (cartShop[index].discountVoucher != "")
        shopVoucherText(cartShop, index, context)
      else
        const SizedBox(),
      if (cartShop[index].shippingVoucher.isNotEmpty)
        ShippingDiscountDetail(
            context: context, cartShop: cartShop, index: index),
    ];
  }

  Widget listProductbyShop(
      List<Datum> cartShop, Item items, int index, int productIndex) {
    return Builder(builder: (context) {
      if (items.stock == 0) {
        return const SizedBox();
      }

      // ตรวจสอบว่า item นี้อยู่ในกลุ่มที่มีปัญหาหรือไม่
      bool isInProblematicGroup = _isItemInProblematicGroup(items);
      bool isInProblematicItems = _isItemInProblematicItems(items);

      // ตรวจสอบว่าเป็น item แรกในกลุ่มที่มีปัญหาหรือไม่ (เพื่อแสดง error message)
      bool shouldShowGroupError =
          _shouldShowGroupErrorMessage(items, cartShop, productIndex);

      // ดึง error message
      String errorMessage = _getErrorMessage(items);

      var matchingItem = matchErrorText(items);
      if (matchingItem != null) {
        errorMessage =
            matchingItem['error_message'] ?? ''; // ดึง error_message หากมี
      }

      return Container(
        color: isInProblematicGroup || isInProblematicItems
            ? Colors.red.shade50
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // แสดง error message เฉพาะ item แรกในกลุ่มเท่านั้น
              shouldShowGroupError
                  ? _buildErrorMessageWidget(errorMessage)
                  : const SizedBox(),

              productItems(index, productIndex, context, items, cartShop,
                  matchingItem, errorMessage),
            ],
          ),
        ),
      );
    });
  }

// ตรวจสอบว่า item อยู่ในกลุ่มที่มีปัญหาหรือไม่
  bool _isItemInProblematicGroup(Item item) {
    return cartCtr.problematicGroups.any((group) {
      return group['item_briefs'].any((brief) =>
          brief['item_id'] == item.selectItemId &&
          brief['product_id'] == item.productId);
    });
  }

// ตรวจสอบว่า item อยู่ใน problematic items หรือไม่
  bool _isItemInProblematicItems(Item item) {
    return cartCtr.problematicItems.any((problematicItem) =>
        problematicItem['item_id'] == item.selectItemId &&
        problematicItem['product_id'] == item.productId);
  }

// ตรวจสอบว่าควรแสดง group error message หรือไม่
  bool _shouldShowGroupErrorMessage(
      Item currentItem, List<Datum> cartShop, int currentProductIndex) {
    // หากไม่อยู่ในกลุ่มที่มีปัญหา ไม่ต้องแสดง
    if (!_isItemInProblematicGroup(currentItem)) {
      return false;
    }

    // หา group ที่ item นี้อยู่
    int groupIndex = cartCtr.problematicGroups.indexWhere((group) {
      return group['item_briefs'].any((brief) =>
          brief['item_id'] == currentItem.selectItemId &&
          brief['product_id'] == currentItem.productId);
    });

    if (groupIndex == -1) return false;

    // หา item แรกในกลุ่มนี้จาก cartShop
    var currentGroup = cartCtr.problematicGroups[groupIndex];
    var itemBriefsInGroup = currentGroup['item_briefs'];

    // หา index ของ item แรกในกลุ่มนี้ใน cartShop
    int firstItemIndexInGroup = -1;
    for (int i = 0; i < cartShop.length; i++) {
      for (var shopItem in cartShop[i].items) {
        bool isInCurrentGroup = itemBriefsInGroup.any((brief) =>
            brief['item_id'] == shopItem.selectItemId &&
            brief['product_id'] == shopItem.productId);

        if (isInCurrentGroup) {
          // หา product index ของ item นี้
          int productIndexInShop = cartShop[i].items.indexOf(shopItem);
          if (firstItemIndexInGroup == -1 ||
              productIndexInShop < firstItemIndexInGroup) {
            firstItemIndexInGroup = productIndexInShop;
          }
        }
      }
    }

    // แสดง error เฉพาะ item แรกในกลุ่ม
    return currentProductIndex == firstItemIndexInGroup;
  }

// ดึง error message จากกลุ่มที่ item อยู่
  String _getErrorMessage(Item item) {
    // ตรวจสอบใน problematic groups
    for (var group in cartCtr.problematicGroups) {
      bool isInGroup = group['item_briefs'].any((brief) =>
          brief['item_id'] == item.selectItemId &&
          brief['product_id'] == item.productId);

      if (isInGroup) {
        return group['error_message'] ?? '';
      }
    }

    // ตรวจสอบใน problematic items
    for (var problematicItem in cartCtr.problematicItems) {
      if (problematicItem['item_id'] == item.selectItemId &&
          problematicItem['product_id'] == item.productId) {
        return problematicItem['error_message'] ?? '';
      }
    }

    return '';
  }

  Widget _buildErrorMessageWidget(String errorMessage) {
    if (errorMessage.isEmpty) return const SizedBox();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              errorMessage,
              style: GoogleFonts.ibmPlexSansThai(
                color: Colors.red.shade700,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headerShop(List<Datum> cartShop, int index) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Obx(() {
              var key = cartShop[index].shopId;
              if (controller.seleletedProuduct[key] != null) {
                if (controller.seleletedProuduct[key]!.length ==
                    cartShop[index]
                        .items
                        .where((element) =>
                            element.normalStock != 0 && element.stock != 0)
                        .length) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      controller.deselectAllForShop(
                          cartShop[index].shopId, cartShop[index].items);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2.0, right: 4),
                      child: Container(
                          height: 18,
                          width: 18,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: Colors.blue,
                                width: 0.8,
                              ),
                              color: Colors.blue),
                          child: const Icon(Icons.check,
                              size: 14, color: Colors.white)),
                    ),
                  );
                }
              }

              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  controller.selectAllForShop(
                      cartShop[index].shopId, cartShop[index].items);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2.0, right: 4),
                  child: Container(
                    height: 18,
                    width: 18,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 0.8,
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                ),
              );
            }),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Get.find<BrandCtr>().fetchShopData(cartShop[index].shopId);
                // Get.to(() => const BrandStore());
                Get.toNamed('/BrandStore/${cartShop[index].shopId}');
              },
              child: Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: cartShop[index].icon,
                      width: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: Get.width - 140),
                    child: Text(
                      cartShop[index].shopName,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.ibmPlexSansThai(
                          fontWeight: FontWeight.w900, fontSize: 13),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                  )
                ],
              ),
            ),
            InkWell(
                onTap: () async {
                  SetData data = SetData();
                  int custId = await data.b2cCustID;
                  var res = await addChatRoomService(cartShop[index].shopId);
                  final message = {
                    "event": "customer_readall_message",
                    "receiver_id": res.data.sellerId,
                    "is_me": true,
                    "message_data": {
                      "chat_room_id": res.data.chatRoomId,
                      "sender_role": "customer",
                      "sender_id": await data.b2cCustID
                    }
                  };
                  final webSocketController = Get.find<WebSocketController>();
                  webSocketController.channel!.sink.add(jsonEncode(message));
                  final chatController = Get.find<ChatController>();
                  chatController.openChatRoom.value = res.data.chatRoomId;
                  Get.to(() => ChatAppWithSeller(
                        shop: SellerChat(
                            chatRoomId: res.data.chatRoomId,
                            customerId: custId,
                            customerName: '',
                            customerImage: '',
                            sellerId: res.data.sellerId,
                            sellerName: cartShop[index].shopName,
                            sellerImage: cartShop[index].icon,
                            messageType: 1,
                            messageText: '',
                            lastSend: '',
                            unRead: 0),
                        channel: webSocketController.channel!,
                      ));
                },
                child: Image.asset("assets/images/b2c/chat/chat-grey.png",
                    width: 24)),
          ],
        ),
      ]),
    );
  }

  Widget errorMessageWidget(int groupIndex) {
    return Stack(
      children: [
        SizedBox(
          width: Get.width,
          height: 20,
        ),
        Positioned(
          left: 0,
          child: Text(
            "${cartCtr.problematicGroups[groupIndex]['error_message']}",
            style: const TextStyle(
                fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget productItems(
      int index,
      int productIndex,
      BuildContext context,
      Item shopProductItems,
      List<Datum> cartShop,
      matchingItem,
      String errorMessage) {
    return Slidable(
      key: ValueKey('${index}_$productIndex'),
      endActionPane: ActionPane(
        extentRatio: 0.20,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (s) async {
              loadingProductStock(context);
              var res = await deleteCartService([shopProductItems.cartId]);
              endUserCouponCtr.promotionDataCheckOut.shopVouchers.removeWhere(
                  (element) => element.shopId == cartShop[index].shopId);
              Get.back();
              if (res!.code == "100") {
                var indexItem = cartCtr.cartItems!.value.data[index].items
                    .indexWhere((e) => e.cartId == shopProductItems.cartId);
                cartShop[index].items.removeAt(indexItem);
                cartCtr.qtyCtrs![index].removeAt(indexItem);

                if (controller.seleletedProuduct.isNotEmpty &&
                    controller.seleletedProuduct
                        .containsKey(cartShop[index].shopId)) {
                  if (controller.seleletedProuduct.values
                      .any((e) => e.map((e) => e.selectItemId).contains(
                            shopProductItems.selectItemId,
                          ))) {
                    await controller.removeSelection(
                        cartShop[index].shopId,
                        shopProductItems.selectItemId,
                        shopProductItems.productId);
                  }
                }
                if (cartShop[index].items.isEmpty) {
                  cartShop.removeAt(index);
                  cartCtr.qtyCtrs!.removeAt(index);
                  controllers.removeAt(index);
                }
              }
              cartCtr.fetchCartNoLoad();
              setState(() {});
            },
            backgroundColor: themeRed,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Uncheckbox(shopId: cartShop[index].shopId, item: shopProductItems),
          Expanded(
            child: Stack(
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.bottomCenter,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Get.find<ShowProductSkuCtr>().selectedOptions.clear();
                    Get.find<ShowProductSkuCtr>().indexPrdOption = (-1).obs;
                    Get.find<ShowProductSkuCtr>().activeKey = "".obs;
                    Get.find<ShowProductSkuCtr>().activeSlide = 0.obs;
                    Get.find<ShowProductSkuCtr>().isSetAppbar.value = false;
                    isLoaded = false;
                    controller.selectedKeys.clear();
                    controller.seleletedProuduct.clear();
                    cartCtr.clearWhenback();
                    endUserCouponCtr.clearVal();
                    Get.find<ShowProductSkuCtr>().fetchB2cProductDetail(
                        shopProductItems.productId, 'cart');
                    Get.toNamed(
                      '/ShowProductSku/${shopProductItems.productId}',
                    );
                    // Get.to(
                    //     () =>
                    //         const ShowProductSku(),
                    //     preventDuplicates:
                    //         false);
                  },
                  child: Container(
                      constraints: const BoxConstraints(minWidth: 80),
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 0.1, color: Colors.grey.shade700)),
                      child:
                          CacheImageCart(url: shopProductItems.productImage)),
                ),
                Container(
                  width: Get.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: Colors.black45,
                  ),
                  child: shopProductItems.normalStock <= 10 &&
                          shopProductItems.normalStock > 0
                      ? Center(
                          child: Text(
                            'เหลือ ${shopProductItems.normalStock} ชิ้น',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        )
                      : const SizedBox(),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shopProductItems.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                if (shopProductItems.normalStock == 0)
                  Text(
                    'ตัวเลือกสินค้าที่เลือกไม่ถูกต้อง',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
                  )
                else if (shopProductItems.tierVariations.isNotEmpty)
                  OptionItems(
                      shopId: cartShop[index].shopId,
                      shopProductItems: shopProductItems,
                      layout: 1),
                const SizedBox(
                  height: 12,
                ),
                if (shopProductItems.normalStock == 0)
                  Align(
                      alignment: Alignment.centerRight,
                      child: OptionItems(
                          shopId: cartShop[index].shopId,
                          shopProductItems: shopProductItems,
                          layout: 2))
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!shopProductItems.haveDiscount)
                        Text(
                          '฿${myFormat.format(shopProductItems.priceBeforeDiscount)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange.shade700),
                        )
                      else
                        Row(
                          children: [
                            Text(
                              '฿${myFormat.format(shopProductItems.price)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange.shade700),
                            ),
                            Text(
                              ' ฿${myFormat.format(shopProductItems.priceBeforeDiscount)}',
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  height: 2.4,
                                  fontSize: 10,
                                  color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade100),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                var qty =
                                    cartCtr.qtyCtrs![index][productIndex].text;
                                if (qty == "1" || qty == "" || qty == "0") {
                                  return;
                                }
                                var shopId = cartShop[index].shopId;
                                cartCtr.setActiveButton(
                                    "r-$shopId-${shopProductItems.productId}");

                                deleteQty(shopId, index, productIndex,
                                    shopProductItems);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Obx(() {
                                  var shopId = cartShop[index].shopId;
                                  Color color = Colors.black;
                                  if (cartCtr.isActiveButton[
                                          'r-$shopId-${shopProductItems.productId}'] ==
                                      null) {
                                    color = Colors.black;
                                  } else if (cartCtr.isActiveButton[
                                      'r-$shopId-${shopProductItems.productId}']!) {
                                    color = Colors.grey;
                                  } else {
                                    color = Colors.black;
                                  }
                                  return Text(
                                    '-',
                                    style: GoogleFonts.ibmPlexSansThai(
                                        color: color),
                                  );
                                }),
                              ),
                            ),
                            const VerticalDivider(width: 2),
                            SizedBox(
                                height: 30,
                                width: 40,
                                child: Center(
                                  child: TextFormField(
                                      onTap: () {
                                        if (cartCtr
                                                .qtyCtrs![index][productIndex]
                                                .text
                                                .length ==
                                            1) {
                                          cartCtr.qtyCtrs![index][productIndex]
                                                  .selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset: cartCtr
                                                      .qtyCtrs![index]
                                                          [productIndex]
                                                      .text
                                                      .length);
                                        }
                                      },
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          var shopId = cartShop[index].shopId;
                                          changeQty(shopId, index, productIndex,
                                              shopProductItems);
                                        }
                                      },
                                      controller: cartCtr.qtyCtrs![index]
                                          [productIndex],
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                      decoration: const InputDecoration(
                                          isCollapsed: true,
                                          border: InputBorder.none,
                                          labelStyle: TextStyle()),
                                      keyboardType: TextInputType.number),
                                )),
                            const VerticalDivider(width: 2),
                            InkWell(
                              onTap: () {
                                var shopId = cartShop[index].shopId;
                                cartCtr.setActiveButton(
                                    "a-$shopId-${shopProductItems.productId}");
                                addQty(shopId, index, productIndex,
                                    shopProductItems);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Obx(() {
                                  var shopId = cartShop[index].shopId;
                                  Color color = Colors.black;
                                  if (cartCtr.isActiveButton[
                                          'a-$shopId-${shopProductItems.productId}'] ==
                                      null) {
                                    color = Colors.black;
                                  } else if (cartCtr.isActiveButton[
                                      'a-$shopId-${shopProductItems.productId}']!) {
                                    color = Colors.grey;
                                  } else {
                                    color = Colors.black;
                                  }
                                  return Text(
                                    '+',
                                    style: GoogleFonts.ibmPlexSansThai(
                                        color: color),
                                  );
                                }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                if (shopProductItems.cartContent.isNotEmpty)
                  Column(
                    children: [
                      for (int i = 0;
                          i < shopProductItems.cartContent.length;
                          i++)
                        Text(
                          shopProductItems.cartContent[i].content,
                          style: TextStyle(
                              fontSize: 10, color: Colors.deepOrange.shade600),
                        ),
                    ],
                  ),
                if (matchingItem != null)
                  Text(
                    errorMessage,
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  bool groupMatched(List<dynamic> result, Item shopProductItems) {
    bool isGroupMatched = result.any((e) {
      return e['item_id'] == shopProductItems.selectItemId &&
          e['product_id'] == shopProductItems.productId;
    });
    return isGroupMatched;
  }

  bool problemMatchedItem(Item shopProductItems) {
    bool problematicItemsMatched = cartCtr.problematicItems.any((element) =>
        element['item_id'] == shopProductItems.productId ||
        element['item_id'] == shopProductItems.selectItemId);
    return problematicItemsMatched;
  }

  matchErrorText(Item shopProductItems) {
    var matchingItem = cartCtr.problematicItems.firstWhere(
      (element) =>
          element['item_id'] == shopProductItems.productId ||
          element['item_id'] == shopProductItems.selectItemId,
      orElse: () => null, // ใช้ orElse เพื่อให้ไม่เกิด error หากไม่พบ
    );
    return matchingItem;
  }

  int groupErrorText(Item shopProductItems) {
    int groupIndex = cartCtr.problematicGroups.indexWhere((group) {
      return group['item_briefs'].any((e) {
        return e['item_id'] == shopProductItems.selectItemId &&
            e['product_id'] == shopProductItems.productId;
      });
    });
    // return 0;
    return groupIndex;
  }

  Widget shopVoucherText(
      List<Datum> cartShop, int index, BuildContext context) {
    return InkWell(
      onTap: () async {
        if (controller.seleletedProuduct[cartShop[index].shopId] == null) {
          loadingProductStock(context);
          await fetchVoucherRecommend(cartShop[index].shopId).then((res) {
            endUserCouponCtr.shopName.value = res!.data.shopName;
            endUserCouponCtr.shopVouchers.value = res.data.shopVouchers;
            Get.back();
            storerCoupon(context);
          });
        } else {
          if (endUserCouponCtr.isLoadingCouponShop[index] == true) {
            return;
          }
          var selectedShop = endUserCouponCtr.shopVouchersUpdate.value!
              .firstWhereOrNull(
                  (element) => element.shopId == cartShop[index].shopId);
          if (selectedShop == null) {
            endUserCouponCtr.shopName.value = cartShop[index].shopName;
            endUserCouponCtr.shopVouchers.value = [];
            endUserCouponCtr.shopId.value = cartShop[index].shopId;
            await storerCouponSelected(context).then((res) async {
              endUserCouponCtr.isLoadingCouponShop[index] = true;
              await controller.updateCart();
              endUserCouponCtr.isLoadingCouponShop[index] = false;
            });
            return;
          }
          endUserCouponCtr.shopVouchers.value = selectedShop.shopVouchers;
          endUserCouponCtr.shopName.value = selectedShop.shopName;
          endUserCouponCtr.shopId.value = selectedShop.shopId;
          var cuponSelected = selectedShop.shopVouchers
              .indexWhere((element) => element.userStatus.isSelected);
          if (cuponSelected != -1) {
            endUserCouponCtr.selectedCoupon[endUserCouponCtr.shopId.value] =
                cuponSelected;
          }

          await storerCouponSelected(context).then((res) async {
            endUserCouponCtr.isLoadingCouponShop[index] = true;
            await controller.updateCart();
            endUserCouponCtr.isLoadingCouponShop[index] = false;
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
            top: 8.0,
            left: 8,
            right: 8,
            bottom: cartShop[index].shippingVoucher.isNotEmpty ? 0 : 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              if (endUserCouponCtr.discountVoucher.value!.firstWhereOrNull(
                      (element) => element.shopId == cartShop[index].shopId) !=
                  null) {
                var showUpdateDiscountVoucher = endUserCouponCtr
                    .discountVoucher.value!
                    .where(
                        (element) => element.shopId == cartShop[index].shopId)
                    .first
                    .discountVoucher;
                if (endUserCouponCtr.isLoadingCouponShop[index] ?? false) {
                  return const Text(
                    "กำลังโหลด...",
                    style: TextStyle(fontSize: 12),
                  );
                } else {
                  if (showUpdateDiscountVoucher == "") {
                    return Text(
                      cartShop[index].discountVoucher,
                      style: const TextStyle(fontSize: 12),
                    );
                  }
                  if (controller.seleletedProuduct[cartShop[index].shopId] ==
                      null) {
                    return Text(
                      showUpdateDiscountVoucher,
                      style: const TextStyle(fontSize: 12),
                    );
                  } else {
                    return Text(
                      showUpdateDiscountVoucher,
                      style: const TextStyle(fontSize: 12),
                    );
                  }
                }
              } else {
                return Text(
                  cartShop[index].discountVoucher,
                  style: const TextStyle(fontSize: 12),
                );
              }
            }),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: Colors.grey.shade700,
            )
          ],
        ),
      ),
    );
  }

  Widget bottomSheetCart(BuildContext context) {
    return Obx(() {
      return !cartCtr.isLoadingCart.value &&
              cartCtr.cartItems!.value.data.isNotEmpty
          ? SafeArea(
              child: IntrinsicHeight(
              child: Container(
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(88, 0, 0, 0),
                    offset: Offset(0.0, -12.0),
                    blurRadius: 12,
                    spreadRadius: -20,
                  ),
                ]),
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 8,
                ),
                child: Column(
                  children: [
                    if (!cartCtr.showEditCart.value)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'โค้ดส่วนลดของ Friday',
                              style: TextStyle(fontSize: 13),
                            ),
                            InkWell(
                              onTap: () async {
                                await Get.to(() => const EndUserCartCoupon())!
                                    .then((value) {
                                  if (value == null) {
                                    controller.updateCart();
                                  } else {
                                    controller.updateCart();
                                  }
                                });
                              },
                              child: Obx(() {
                                if (cartCtr.discountBreakdown.value != null) {
                                  return Row(
                                    children: [
                                      if (cartCtr.discountBreakdown.value!
                                              .discountDisplay.text !=
                                          '')
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: const Color(0xFF1C9AD6)),
                                          ),
                                          child: Text(
                                            cartCtr.discountBreakdown.value!
                                                .discountDisplay.text,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF1C9AD6)),
                                          ),
                                        )
                                      else
                                        const Text(
                                          'กดใช้โค้ด',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.grey,
                                        size: 12,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      )
                                    ],
                                  );
                                }
                                return const Row(
                                  children: [
                                    Text(
                                      'กดใช้โค้ด',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.grey,
                                      size: 12,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    )
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    const Divider(
                      height: 0,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          var response = controller.generateOutputJson();
                          final totalLength =
                              "${response.map((shop) => (shop['product_briefs'] as List).length).fold<int>(0, (sum, length) => sum + length)}";
                          final itemLength =
                              "${cartCtr.cartItems!.value.data.expand((e) => e.items).where((item) => item.normalStock != 0 && item.stock != 0).length}";
                          // printWhite("click selected length : $totalLength");
                          // printWhite("all items can selected : $itemLength");
                          if (totalLength == itemLength) {
                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await controller.deselectAllCart();
                                await controller.updateCart();
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 18,
                                    width: 18,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 0.8,
                                      ),
                                      color: Colors.blue,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text('ทั้งหมด'),
                                ],
                              ),
                            );
                          }
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await controller.deselectAllCart();
                              await controller.selectAllCart();
                              // for (var data in cartCtr.cartItems!.value.data) {
                              //   await controller.selectAllForShop(
                              //       data.shopId,
                              //       data.items
                              //           .where((item) =>
                              //               item.normalStock != 0 &&
                              //               item.stock != 0)
                              //           .toList());
                              // }
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 18,
                                  width: 18,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      width: 0.8,
                                    ),
                                    color: Colors.transparent,
                                  ),
                                ),
                                const Text('ทั้งหมด'),
                              ],
                            ),
                          );
                        }),
                        if (cartCtr.showEditCart.value)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: OutlinedButton(
                                onPressed: () async {
                                  if (controller
                                      .seleletedProuduct.values.isEmpty) {
                                    dialogAlert([
                                      const Icon(
                                        Icons.notification_important,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      Text(
                                        'กรุณาเลือกสินค้าอย่างน้อย 1 ชิ้น',
                                        style: GoogleFonts.ibmPlexSansThai(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      )
                                    ]);
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      Get.back();
                                    });
                                    return;
                                  }
                                  // popup confirm delete
                                  Get.dialog(Theme(
                                    data: Theme.of(context).copyWith(
                                      elevatedButtonTheme:
                                          ElevatedButtonThemeData(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  textStyle: GoogleFonts
                                                      .ibmPlexSansThai())),
                                      textTheme:
                                          GoogleFonts.ibmPlexSansThaiTextTheme(
                                        Theme.of(context).textTheme,
                                      ),
                                    ),
                                    child: AlertDialog(
                                      actionsAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      contentPadding: EdgeInsets.zero,
                                      actionsPadding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              'คุณต้องการลบสินค้าที่เลือกใช่หรือไม่',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          const Divider(
                                            height: 0,
                                          ),
                                          SizedBox(
                                            height: 40,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 40,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      child: const Center(
                                                        child: Text(
                                                          'ไม่',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 40,
                                                  child: VerticalDivider(
                                                    width: 0,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 40,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Get.back();
                                                        loadingProductStock(
                                                            context);
                                                        var response =
                                                            await deleteCartService(controller
                                                                .seleletedProuduct
                                                                .values
                                                                .expand(
                                                                    (element) =>
                                                                        element)
                                                                .map(
                                                                  (e) =>
                                                                      e.cartId,
                                                                )
                                                                .toList());
                                                        Get.back();
                                                        if (response!.code ==
                                                            "100") {
                                                          await controller
                                                              .deselectAllCart();
                                                          await controller
                                                              .updateCart();
                                                          await cartCtr
                                                              .fetchCartNoLoad();
                                                        }
                                                        endUserCouponCtr
                                                            .promotionDataCheckOut
                                                            .shopVouchers
                                                            .clear();
                                                      },
                                                      child: Center(
                                                        child: Text('ใช่',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .deepOrange
                                                                    .shade700,
                                                                fontSize: 12)),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                                },
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    side: const BorderSide(
                                        color: Colors.grey, width: 0.8)),
                                child: Text(
                                  'ลบ',
                                  style: GoogleFonts.ibmPlexSansThai(),
                                )),
                          )
                        else
                          Row(
                            children: [
                              Obx(() {
                                if (cartCtr.discountBreakdown.value == null) {
                                  return Row(
                                    children: [
                                      const Text(
                                        'รวม',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        ' ฿0',
                                        style: TextStyle(
                                            color: Colors.deepOrange.shade700,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      Get.bottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0))),
                                          showDetail(context));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'รวม',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              ' ฿${myFormat.format(cartCtr.discountBreakdown.value!.total.value)}',
                                              style: TextStyle(
                                                  color: Colors
                                                      .deepOrange.shade700,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'ส่วนลด',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              ' ฿${myFormat.format(cartCtr.discountBreakdown.value!.totalSaved.value)}',
                                              style: TextStyle(
                                                color:
                                                    Colors.deepOrange.shade400,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Icon(
                                              Icons.info_outline,
                                              size: 18,
                                              color: Colors.grey,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }
                              }),
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                height: 40,
                                child: Obx(() {
                                  return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: themeColorDefault,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4))),
                                      onPressed: () async {
                                        if (controller
                                            .seleletedProuduct.values.isEmpty) {
                                          dialogAlert([
                                            const Icon(
                                              Icons.notification_important,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            Text(
                                              'กรุณาเลือกสินค้าอย่างน้อย 1 ชิ้น',
                                              style:
                                                  GoogleFonts.ibmPlexSansThai(
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                            )
                                          ]);
                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            Get.back();
                                          });
                                          return;
                                        }
                                        SetData data = SetData();

                                        var res =
                                            controller.generateOutputJson();
                                        List<checkout_model.CheckoutShopOrder>
                                            shopUpdate = res.map((shop) {
                                          // สร้างรายการ ProductBriefs สำหรับแต่ละ shop
                                          List<ProductBrief> productBriefs =
                                              (shop['product_briefs'] as List)
                                                  .map((brief) {
                                            return ProductBrief(
                                              productId: brief['product_id'],
                                              itemId: brief['item_id'],
                                            );
                                          }).toList();

                                          // เพิ่ม UpdatedShopOrder ลงใน shopList
                                          return checkout_model
                                              .CheckoutShopOrder(
                                            productBriefs: productBriefs,
                                            shopId: shop['shop_id'],
                                          );
                                        }).toList();

                                        var payload =
                                            checkout_model.CartCheckOutInput(
                                          custId: await data.b2cCustID,
                                          checkoutShopOrders: shopUpdate,
                                          promotionData:
                                              checkout_model.PromotionData(
                                                  freeShipping: [],
                                                  unusedPlatformVoucher:
                                                      endUserCouponCtr
                                                          .promotionData
                                                          .unusedPlatformVoucher,
                                                  platformVouchers:
                                                      endUserCouponCtr
                                                          .promotionData
                                                          .platformVouchers,
                                                  shopVouchers: endUserCouponCtr
                                                      .promotionShop),
                                        );
                                        // printWhite(jsonEncode(payload));
                                        await chekcon(payload);
                                      },
                                      child: Text(
                                        'ชำระเงิน(${controller.seleletedProuduct.values.fold(0, (sum, list) => sum + list.length)})',
                                        style: GoogleFonts.ibmPlexSansThai(
                                            fontWeight: FontWeight.w500),
                                      ));
                                }),
                              ),
                            ],
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ))
          : const SizedBox();
    });
  }

  Future<void> chekcon(checkout_model.CartCheckOutInput payload) async {
    var condition = await cartCheckConService(payload);
    // ตรวจสอบสถานะโค้ดจาก API
    if (condition.code == "-9") {
      // ตรวจสอบว่ามี problematicItems หรือไม่
      if (condition.data.problematicItems.isNotEmpty) {
        var proItem = condition.data.problematicItems;
        cartCtr.problematicItems.clear();
        // ทำการวนลูปเพื่อดึงข้อมูลจาก problematicItems และอัปเดตตัวแปร problematicItems
        for (int i = 0; i < proItem.length; i++) {
          // แทนที่ข้อมูลใน problematicItems
          cartCtr.problematicItems.add({
            'shop_id': proItem[i].shopId,
            'product_id': proItem[i].productId,
            'item_id': proItem[i].itemId,
            'error_message': proItem[i].errorMessage,
          });
        }
      } else {
        cartCtr.problematicItems.clear();
      }
      if (condition.data.problematicGroups.isNotEmpty) {
        var proGroup = condition.data.problematicGroups;
        cartCtr.problematicGroups.clear();

        for (int i = 0; i < proGroup.length; i++) {
          // แทนที่ข้อมูลใน problematicItems
          cartCtr.problematicGroups.add({
            'item_briefs': proGroup[i].itemBriefs.map((brief) {
              // สำหรับแต่ละ itemBrief ให้เก็บข้อมูลที่จำเป็น
              return {
                'shop_id': brief.shopId,
                'product_id': brief.productId,
                'item_id': brief.itemId,
              };
            }).toList(), // แปลง itemBriefs ให้เป็น List ของ Map
            'error_message': proGroup[i].errorMessage,
          });
        }
      } else {
        cartCtr.problematicGroups.clear();
      }
      setState(() {});
    } else {
      cartCtr.problematicItems.clear();
      cartCtr.problematicGroups.clear();
      setState(() {});
      // printJSON(cartCtr.problematicItems);
      // print('dev');
      // printJSON(cartCtr.problematicGroups);
      cartCtr.fetchCartCheckOut(payload);
      cartCtr.fetchAddressList();

      Get.to(() => const EndUserCartSummary());
    }
  }

  Widget bottomSheetCart2(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                textStyle: GoogleFonts.ibmPlexSansThai())),
        textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      child: Obx(() {
        return !cartCtr.isLoadingCart.value &&
                cartCtr.cartItems!.value.data.isNotEmpty
            ? IntrinsicHeight(
                child: Container(
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: []),
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 8,
                  ),
                  child: Column(
                    children: [
                      const Divider(
                        height: 0,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() {
                            var response = controller.generateOutputJson();
                            final totalLength =
                                "${response.map((shop) => (shop['product_briefs'] as List).length).fold<int>(0, (sum, length) => sum + length)}";
                            final itemLength =
                                "${cartCtr.cartItems!.value.data.expand((e) => e.items).where((item) => item.normalStock != 0 && item.stock != 0).length}";
                            // printWhite("click selected length : $totalLength");
                            // printWhite("all items can selected : $itemLength");
                            if (totalLength == itemLength) {
                              return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await controller.deselectAllCart();
                                  await controller.updateCart();
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: 18,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 0.8,
                                        ),
                                        color: Colors.blue,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'ทั้งหมด',
                                      style: GoogleFonts.ibmPlexSansThai(),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await controller.deselectAllCart();
                                await controller.selectAllCart();

                                Get.back();
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 18,
                                    width: 18,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 0.8,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  Text(
                                    'ทั้งหมด',
                                    style: GoogleFonts.ibmPlexSansThai(),
                                  ),
                                ],
                              ),
                            );
                          }),
                          Row(
                            children: [
                              Obx(() {
                                if (cartCtr.discountBreakdown.value == null) {
                                  return Row(
                                    children: [
                                      const Text(
                                        'รวม',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        ' ฿0',
                                        style: TextStyle(
                                            color: Colors.deepOrange.shade700,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'รวม',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              ' ฿${myFormat.format(cartCtr.discountBreakdown.value!.total.value)}',
                                              style: TextStyle(
                                                  color: Colors
                                                      .deepOrange.shade700,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'ส่วนลด',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              ' ฿${myFormat.format(cartCtr.discountBreakdown.value!.totalSaved.value)}',
                                              style: TextStyle(
                                                color:
                                                    Colors.deepOrange.shade400,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              size: 12,
                                              color: Colors.grey,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }
                              }),
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                height: 40,
                                child: Obx(() {
                                  return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: themeColorDefault,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4))),
                                      onPressed: () async {
                                        if (controller
                                            .seleletedProuduct.values.isEmpty) {
                                          dialogAlert([
                                            const Icon(
                                              Icons.notification_important,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            Text(
                                              'กรุณาเลือกสินค้าอย่างน้อย 1 ชิ้น',
                                              style:
                                                  GoogleFonts.ibmPlexSansThai(
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                            )
                                          ]);
                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            Get.back();
                                          });
                                          return;
                                        }
                                        SetData data = SetData();

                                        var res =
                                            controller.generateOutputJson();
                                        List<checkout_model.CheckoutShopOrder>
                                            shopUpdate = res.map((shop) {
                                          // สร้างรายการ ProductBriefs สำหรับแต่ละ shop
                                          List<ProductBrief> productBriefs =
                                              (shop['product_briefs'] as List)
                                                  .map((brief) {
                                            return ProductBrief(
                                              productId: brief['product_id'],
                                              itemId: brief['item_id'],
                                            );
                                          }).toList();

                                          // เพิ่ม UpdatedShopOrder ลงใน shopList
                                          return checkout_model
                                              .CheckoutShopOrder(
                                            productBriefs: productBriefs,
                                            shopId: shop['shop_id'],
                                          );
                                        }).toList();

                                        var payload =
                                            checkout_model.CartCheckOutInput(
                                          custId: await data.b2cCustID,
                                          checkoutShopOrders: shopUpdate,
                                          promotionData:
                                              checkout_model.PromotionData(
                                                  freeShipping: [],
                                                  unusedPlatformVoucher:
                                                      endUserCouponCtr
                                                          .promotionData
                                                          .unusedPlatformVoucher,
                                                  platformVouchers:
                                                      endUserCouponCtr
                                                          .promotionData
                                                          .platformVouchers,
                                                  shopVouchers: endUserCouponCtr
                                                      .promotionShop),
                                        );
                                        await chekcon(payload);
                                      },
                                      child: Text(
                                        'ชำระเงิน(${controller.seleletedProuduct.values.fold(0, (sum, list) => sum + list.length)})',
                                        style: GoogleFonts.ibmPlexSansThai(
                                            fontWeight: FontWeight.w500),
                                      ));
                                }),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox();
      }),
    );
  }

  // รายละเอียดส่วนลด , สรุปราคา
  Widget showDetail(BuildContext context) {
    return SafeArea(
      child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'รายละเอียดส่วนลด',
                        style: GoogleFonts.ibmPlexSansThai(
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cartCtr.discountBreakdown.value!.subtotal.label,
                          style: GoogleFonts.ibmPlexSansThai(fontSize: 13),
                        ),
                        Text(
                            "฿${myFormat.format(cartCtr.discountBreakdown.value!.subtotal.value)}",
                            style: GoogleFonts.ibmPlexSansThai(fontSize: 13)),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 0,
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      shrinkWrap: true,
                      primary: false,
                      itemCount:
                          cartCtr.discountBreakdown.value!.breakdown.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cartCtr.discountBreakdown.value!.breakdown[index]
                                  .label,
                              style: GoogleFonts.ibmPlexSansThai(fontSize: 13),
                            ),
                            Text(
                                "- ฿${myFormat.format(cartCtr.discountBreakdown.value!.breakdown[index].value)}",
                                style:
                                    GoogleFonts.ibmPlexSansThai(fontSize: 13)),
                          ],
                        );
                      }),
                  const Divider(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cartCtr.discountBreakdown.value!.totalSaved.label,
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            "- ฿${myFormat.format(cartCtr.discountBreakdown.value!.totalSaved.value)}",
                            style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrange.shade700)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cartCtr.discountBreakdown.value!.total.label,
                          style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            "฿${myFormat.format(cartCtr.discountBreakdown.value!.total.value)}",
                            style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  bottomSheetCart2(context)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 12),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void changeQty(
      int shopId, int index, int productIndex, Item shopProductItems) {
    var qty = cartCtr.qtyCtrs![index][productIndex].text;

    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 500), () async {
      // endUserCouponCtr.promotionDataCheckOut.shopVouchers
      //     .removeWhere((element) => element.shopId == shopId);
      var res = await addToCartService(shopId, shopProductItems.productId,
          shopProductItems.selectItemId, int.parse(qty), 2);
      if (res!.code == "-9") {
        if (!Get.isDialogOpen!) {
          dialogAlert([
            const Icon(
              Icons.notification_important,
              color: Colors.white,
              size: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                res.message,
                style: GoogleFonts.ibmPlexSansThai(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ]);
          Future.delayed(const Duration(seconds: 1), () async {
            Get.back();
            await controller.updateCart();
          });
        }
        await cartCtr.fetchCartNoLoad();
        return;
      } else {
        // await cartCtr.fetchCartNoLoad();
        await controller.addSelection(shopId, shopProductItems);
        await controller.updateCart();
      }
    });
  }

  Future<void> addQty(
      int shopId, int index, int productIndex, Item shopProductItems) async {
    var qty = cartCtr.qtyCtrs![index][productIndex].text;
    var newQty = int.parse(qty) + 1;

    cartCtr.qtyCtrs![index][productIndex].text = newQty.toString();

    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 500), () async {
      var res = await addToCartService(shopId, shopProductItems.productId,
          shopProductItems.selectItemId, newQty, 2);
      if (res!.code == "-9") {
        if (!Get.isDialogOpen!) {
          dialogAlert([
            const Icon(
              Icons.notification_important,
              color: Colors.white,
              size: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Center(
                child: Text(
                  res.message,
                  style: GoogleFonts.ibmPlexSansThai(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ]);
          Future.delayed(const Duration(seconds: 1), () async {
            Get.back();
            await controller.addSelection(shopId, shopProductItems);
            await controller.updateCart();
          });
        }
        // await cartCtr.fetchCartNoLoad();
        return;
      } else {
        // await cartCtr.fetchCartNoLoad();
        await controller.addSelection(shopId, shopProductItems);
        await controller.updateCart();
        // await cartCtr.fetchCartNoLoad();
      }
    });
  }

  void deleteQty(
      int shopId, int index, int productIndex, Item shopProductItems) {
    var qty = cartCtr.qtyCtrs![index][productIndex].text;
    var newQty = int.parse(qty) - 1;
    cartCtr.qtyCtrs![index][productIndex].text = newQty.toString();
    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 500), () async {
      // endUserCouponCtr.promotionDataCheckOut.shopVouchers
      //     .removeWhere((element) => element.shopId == shopId);
      await addToCartService(shopId, shopProductItems.productId,
          shopProductItems.selectItemId, newQty, 2);

      await controller.addSelection(shopId, shopProductItems);
      await controller.updateCart();
      await cartCtr.fetchCartNoLoad();
    });
  }
}

class ShippingDiscountDetail extends StatelessWidget {
  const ShippingDiscountDetail({
    super.key,
    required this.context,
    required this.cartShop,
    required this.index,
  });

  final BuildContext context;
  final List<Datum> cartShop;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        storeShippingDiscount(context, cartShop, index);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                cartShop[index]
                    .shippingVoucher
                    .map((e) => e.description)
                    .join(","),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: Colors.grey.shade700,
            )
          ],
        ),
      ),
    );
  }
}

class Uncheckbox extends StatefulWidget {
  final int shopId;
  final Item item;
  const Uncheckbox({super.key, required this.shopId, required this.item});

  @override
  State<Uncheckbox> createState() => _UncheckboxState();
}

class _UncheckboxState extends State<Uncheckbox> {
  @override
  Widget build(BuildContext context) {
    final key =
        '${widget.shopId}-${widget.item.selectItemId}-${widget.item.productId}';
    if (widget.item.normalStock == 0) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 28.0,
          right: 8,
          left: 4,
        ),
        child: Container(
          height: 18,
          width: 18,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: Colors.grey.shade400,
              width: 0.8,
            ),
            color: Colors.grey.shade100,
          ),
        ),
      );
    }

    return Obx(() {
      // ฟังการเปลี่ยนแปลงของ selectedKeys
      final isChecked = controller.selectedKeys.contains(key);

      return InkWell(
        onTap: () {
          if (isChecked) {
            controller.removeSelection(
                widget.shopId, widget.item.selectItemId, widget.item.productId);
          } else {
            controller.addSelection(widget.shopId, widget.item);
            controller.updateCart();
          }
        },
        child: Container(
          height: 18,
          width: 18,
          margin:
              const EdgeInsets.only(left: 4, right: 12, top: 28, bottom: 28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: isChecked ? Colors.blue : Colors.grey.shade400,
              width: 0.8,
            ),
            color: isChecked ? Colors.blue : Colors.transparent,
          ),
          child: isChecked
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
      );
    });
  }
}

class CheckboxController extends GetxController {
  // ใช้ RxSet สำหรับเก็บค่าที่เลือก
  RxSet<String> selectedKeys = <String>{}.obs;
  RxMap<int, List<Item>> seleletedProuduct = <int, List<Item>>{}.obs;

  // เพิ่มการเลือก
  addSelection(int shopId, Item item) async {
    final key = '$shopId-${item.selectItemId}-${item.productId}';
    selectedKeys.add(key); // ใช้ RxSet.add() แทน
    if (!seleletedProuduct.containsKey(shopId)) {
      seleletedProuduct[shopId] = [];
    }
    seleletedProuduct[shopId]!.addIf(
      !seleletedProuduct[shopId]!
          .where((element) => element.selectItemId == item.selectItemId)
          .isNotEmpty,
      item,
    );
    seleletedProuduct.refresh();
    // await controller.updateCart();
    // await cartCtr.fetchCartNoLoad();
  }

  // ลบการเลือก
  removeSelection(int shopId, int itemId, int productId) async {
    final key = '$shopId-$itemId-$productId';
    printWhite(selectedKeys);
    if (!selectedKeys.contains(key)) {
      return;
    }
    selectedKeys.remove(key); // ใช้ RxSet.remove() แทน
    seleletedProuduct[shopId]!
        .removeWhere((element) => element.selectItemId == itemId);
    endUserCouponCtr.selectedCoupon[shopId] = -1;
    endUserCouponCtr.promotionData.shopVouchers
        .removeWhere((element) => element.shopId == shopId);
    endUserCouponCtr.promotionDataCheckOut.shopVouchers
        .removeWhere((element) => element.shopId == shopId);
    // endUserCouponCtr.promotionData.platformVouchers.clear();
    // endUserCouponCtr.promotionData.unusedPlatformVoucher = true;
    // endUserCouponCtr.couponPlatformId.value = 0;
    if (seleletedProuduct[shopId]!.isEmpty) {
      seleletedProuduct.remove(shopId);
    }
    seleletedProuduct.refresh();
    if (selectedKeys.isEmpty) {
      cartCtr.discountBreakdown.value = null;
    }
    // else {
    await controller.updateCart();
    // await cartCtr.fetchCartNoLoad();
    // }
  }

  // เลือกร้านทั้งหมด
  selectAllCart() async {
    for (var data in cartCtr.cartItems!.value.data) {
      // make key
      final keys = data.items
          .where((element) => element.normalStock != 0 && element.stock != 0)
          .map((product) =>
              '${data.shopId}-${product.selectItemId}-${product.productId}')
          .toSet();
      selectedKeys.addAll(keys);
      if (!seleletedProuduct.containsKey(data.shopId)) {
        seleletedProuduct[data.shopId] = [];
      }
      seleletedProuduct[data.shopId]!.clear();
      seleletedProuduct[data.shopId]!.addAll(
        data.items
            .where((element) => element.normalStock != 0 && element.stock != 0)
            .where((id) => !seleletedProuduct[data.shopId]!
                .contains(id)) // กรองเฉพาะค่าที่ไม่มีใน List ปัจจุบัน
            .toList(), // แปลงกลับเป็น List
      );
      seleletedProuduct.refresh();
    }
    await controller.updateCart();
  }

  // เลือกทั้งหมดสำหรับ shop ที่ระบุ
  selectAllForShop(int shopId, List<Item> products) async {
    final keys = products
        .where((element) => element.normalStock != 0 && element.stock != 0)
        .map(
            (product) => '$shopId-${product.selectItemId}-${product.productId}')
        .toSet();
    selectedKeys.addAll(keys);
    if (!seleletedProuduct.containsKey(shopId)) {
      seleletedProuduct[shopId] = [];
    }
    seleletedProuduct[shopId]!.clear();
    seleletedProuduct[shopId]!.addAll(
      products
          .where((element) => element.normalStock != 0 && element.stock != 0)
          .where((id) => !seleletedProuduct[shopId]!
              .contains(id)) // กรองเฉพาะค่าที่ไม่มีใน List ปัจจุบัน
          .toList(), // แปลงกลับเป็น List
    );

    seleletedProuduct.refresh();
    await controller.updateCart();
    // await cartCtr.fetchCartNoLoad();
  }

  // ยกเลิกการเลือกทั้งหมดสำหรับ shop ที่ระบุ
  deselectAllForShop(int shopId, List<Item> products) async {
    final keys = products
        .map(
            (product) => '$shopId-${product.selectItemId}-${product.productId}')
        .toSet();
    selectedKeys.removeAll(keys);
    seleletedProuduct[shopId]!.clear();
    if (seleletedProuduct[shopId]!.isEmpty) {
      seleletedProuduct.remove(shopId);
    }
    seleletedProuduct.refresh();
    endUserCouponCtr.promotionData.shopVouchers
        .removeWhere((element) => element.shopId == shopId);
    endUserCouponCtr.promotionDataCheckOut.shopVouchers
        .removeWhere((element) => element.shopId == shopId);
    endUserCouponCtr.selectedCoupon[shopId] = -1;
    // endUserCouponCtr.promotionData.platformVouchers.clear();
    // endUserCouponCtr.promotionData.unusedPlatformVoucher = true;
    // endUserCouponCtr.couponPlatformId.value = 0;
    if (selectedKeys.isEmpty) {
      cartCtr.discountBreakdown.value = null;
    }
    //  else {
    await controller.updateCart();
    // await cartCtr.fetchCartNoLoad();
    // }
  }

  // ยกเลิกการเลือกทั้งหมด
  deselectAllCart() {
    seleletedProuduct.clear();
    seleletedProuduct.refresh();
    selectedKeys.clear();
    cartCtr.discountBreakdown.value = null;
    endUserCouponCtr.selectedCoupon.clear();
    endUserCouponCtr.promotionData.shopVouchers.clear();
    endUserCouponCtr.promotionDataCheckOut.shopVouchers.clear();
    endUserCouponCtr.promotionData.platformVouchers.clear();
    endUserCouponCtr.promotionData.unusedPlatformVoucher = true;
    endUserCouponCtr.couponPlatformId.value = 0;
    endUserCouponCtr.promotionDataCheckOut.platformVouchers.clear();
    endUserCouponCtr.promotionDataCheckOut.unusedPlatformVoucher = true;
  }

  // สร้าง JSON ขาออก
  List<Map<String, dynamic>> generateOutputJson() {
    final Map<int, List<Map<String, int>>> groupedData = {};

    for (final key in selectedKeys) {
      final parts = key.split('-');
      final shopId = int.parse(parts[0]);
      final itemId = int.parse(parts[1]);
      final productId = int.parse(parts[2]);

      // ถ้าไม่มี shop_id ใน map ให้เพิ่มใหม่
      if (!groupedData.containsKey(shopId)) {
        groupedData[shopId] = [];
      }

      // เพิ่ม product_briefs เข้าไปในกลุ่มที่เกี่ยวข้อง
      groupedData[shopId]!.add({
        "product_id": productId,
        "item_id": itemId,
      });
    }

    // แปลงเป็น JSON ขาออก
    return groupedData.entries.map((entry) {
      return {
        "shop_id": entry.key,
        "product_briefs": entry.value,
      };
    }).toList();
  }

  Future<void> updateCart() async {
    SetData data = SetData();
    var res = controller.generateOutputJson();

    List<UpdatedShopOrder> shopList = res.map((shop) {
      // สร้างรายการ ProductBriefs สำหรับแต่ละ shop
      List<ProductBrief> productBriefs =
          (shop['product_briefs'] as List).map((brief) {
        return ProductBrief(
          productId: brief['product_id'],
          itemId: brief['item_id'],
        );
      }).toList();

      // เพิ่ม UpdatedShopOrder ลงใน shopList
      return UpdatedShopOrder(
        productBriefs: productBriefs,
        shopId: shop['shop_id'],
      );
    }).toList();

    UpdateCartInput updateInput = UpdateCartInput(
        actionType: 1,
        custId: await data.b2cCustID,
        sessionId: await data.sessionId,
        updatedShopOrders: shopList,
        promotionData: endUserCouponCtr.promotionData);
    // printWhite(updateInput);
    // printWhite('input ยิง update หน้าแรก');
    // printWhite(jsonEncode(updateInput));
    var updateData = await updateCartService(updateInput);
    // printWhite(jsonEncode(updateData));

    cartCtr.discountBreakdown.value = updateData!.data.discountBreakdown;
    cartCtr.voucherRecommend.value = updateData.data.voucherRecommend;
    // cartCtr.packageBundle.refresh();
    for (var shop in updateData.data.cartDetail) {
      for (var bundle in shop.packagedBundleInfo) {
        // ค้นหา bundle ที่ตรงกับ bundleId จาก cartCtr.packageBundle.value
        var existingBundle = cartCtr.packageBundle.value.firstWhereOrNull(
          (e) => e.bundleId == bundle.bundleId,
        );

        // ถ้ามี bundle ที่ตรงกัน, อัปเดตค่า
        if (existingBundle != null) {
          // อัปเดตค่าใน existingBundle ตามที่คุณต้องการ
          existingBundle.bannerText = bundle.bannerText;
          existingBundle.bannerType = bundle.bannerType;
          existingBundle.bundleId = bundle.bundleId;
          // อัปเดตค่าอื่น ๆ ตามต้องการ
        }
      }
      for (var cart in cartCtr.cartItems!.value.data) {
        for (var shop2 in shopList) {
          if (cart.shopId == shop2.shopId) {
            for (var items in shop2.productBriefs) {
              var existingUpdatePrice = cart.items.firstWhereOrNull((e) =>
                  e.selectItemId == items.itemId &&
                  e.productId == items.productId);
              if (existingUpdatePrice != null) {
                for (var shopItem in shop.items) {
                  if (shopItem.productId == existingUpdatePrice.productId &&
                      shopItem.selectItemId ==
                          existingUpdatePrice.selectItemId) {
                    existingUpdatePrice.haveDiscount = shopItem.haveDiscount;
                    existingUpdatePrice.price = shopItem.price;
                    existingUpdatePrice.priceBeforeDiscount =
                        shopItem.priceBeforeDiscount;
                    existingUpdatePrice.productQty = shopItem.productQty;
                    // printWhite(jsonEncode(existingUpdatePrice));
                    cartCtr.setInit();
                  }
                }
              }
            }
          }
        }
      }
    }

    cartCtr.packageBundle.refresh();

    endUserCouponCtr.shopVouchersUpdate.value = updateData.data.shopVouchers;
    endUserCouponCtr.discountVoucher.value = updateData.data.cartDetail;

    for (var data in updateData.data.shopVouchers) {
      for (var data2 in data.shopVouchers) {
        if (data2.userStatus.isSelected) {
          endUserCouponCtr.promotionDataCheckOut.shopVouchers
              .removeWhere((e) => e.shopId == data.shopId);
          endUserCouponCtr.promotionDataCheckOut.shopVouchers.add(
              update_input.ShopVoucher(
                  shopId: data.shopId,
                  unusedShopVoucher: false,
                  vouchers: [data2.couponId]));
        }
      }
    }

    for (var data in updateData.data.voucherRecommend) {
      for (var data2 in data.vouchers) {
        if (!data2.canUse &&
            endUserCouponCtr.couponPlatformId.value == data2.couponId) {
          endUserCouponCtr.couponPlatformId.value = 0;
          endUserCouponCtr.promotionData.platformVouchers.clear();
        }
      }
    }

    List<update_input.ShopVoucher> mergeShop =
        endUserCouponCtr.promotionDataCheckOut.shopVouchers.map((shop) {
      // ค้นหา shop_id ใน array2
      var matchingShop = endUserCouponCtr.promotionData.shopVouchers.firstWhere(
        (s) => s.shopId == shop.shopId,
        orElse: () => shop,
      );

      return update_input.ShopVoucher(
        shopId: shop.shopId,
        unusedShopVoucher: matchingShop.unusedShopVoucher,
        vouchers: shop.vouchers,
      );
    }).toList();

    endUserCouponCtr.promotionShop = mergeShop;

    // printWhite(jsonEncode(mergedArray));
  }

  clearVal() {
    selectedKeys.clear();
    seleletedProuduct.clear();
  }
}
