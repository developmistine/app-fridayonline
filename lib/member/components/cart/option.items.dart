import 'dart:async';
import 'dart:ui';
import 'package:fridayonline/member/components/showproduct/sku.addtocart.dart';
import 'package:fridayonline/member/models/cart/getcart.model.dart';
import 'package:fridayonline/member/models/showproduct/option.sku.dart';
import 'package:fridayonline/member/models/showproduct/tier.variations.model.dart'
    as tier_variation;
import 'package:fridayonline/member/services/cart/cart.service.dart';
import 'package:fridayonline/member/services/showproduct/showproduct.sku.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:fridayonline/member/views/(showproduct)/medias.sku.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionItems extends StatelessWidget {
  const OptionItems({
    super.key,
    required this.shopId,
    required this.shopProductItems,
    required this.layout,
  });
  final int shopId;
  final Item shopProductItems;
  final int layout;

  @override
  Widget build(BuildContext context) {
    final TextEditingController qtyController =
        TextEditingController(text: shopProductItems.productQty.toString());
    String previousValue = "1";

    if (layout == 2) {
      return SizedBox(
        height: 24,
        child: OutlinedButton(
            onPressed: () {
              previousValue = "1";
              cartCtr.productTier.value = shopProductItems.tierVariations;
              cartCtr.stock.value = shopProductItems.normalStock;
              cartCtr.imageFirst.value = shopProductItems.productImage;
              cartCtr.productPrice.value = null;
              cartCtr.itemId.value = 0;
              showOption(qtyController, previousValue).then((value) {
                cartCtr.selectedOptions.clear();
              });
            },
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: themeColorDefault, width: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
            child: Text(
              'เปลี่ยนตัวเลือก',
              style: TextStyle(color: themeColorDefault, fontSize: 12),
            )),
      );
    }

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () async {
        previousValue = "1";
        for (int tierIndex = 0;
            tierIndex < shopProductItems.tierVariationsIndex.length;
            tierIndex++) {
          cartCtr.selectedOptions[tierIndex] =
              shopProductItems.tierVariationsIndex[tierIndex];
        }

        List<SelectedTier> listTier = [];

        for (var entry in cartCtr.selectedOptions.entries.toList()) {
          if (entry.value != null) {
            int selectedIndex = entry.value!;
            var option = shopProductItems
                .tierVariations[entry.key].options[selectedIndex];
            if (option.displayIndicators == 0) {
              listTier.add(SelectedTier(
                key: entry.key,
                value: selectedIndex,
              ));
            }
          }
        }
        loadingProductStock(context);
        SetData data = SetData();
        var custId = await data.b2cCustID;
        EndUserProductOptions optionSelected = EndUserProductOptions(
            custId: custId,
            productId: shopProductItems.productId,
            shopId: shopId,
            selectedTiers: listTier,
            quantity: int.parse(qtyController.text));
        tier_variation.TierVariations? res =
            await fetchProductTierVariationService(optionSelected);
        Get.back();
        cartCtr.productTier.value = res!.data.tierVariations;
        cartCtr.stock.value = shopProductItems.normalStock;
        cartCtr.imageFirst.value = shopProductItems.productImage;
        cartCtr.itemId.value = 0;
        showOption(qtyController, previousValue).then((value) {
          cartCtr.selectedOptions.clear();
        });
        cartCtr.productPrice.value = shopProductItems.haveDiscount
            ? [
                Text(
                  "฿${myFormat.format(
                    shopProductItems.price,
                  )}",
                  style: GoogleFonts.ibmPlexSansThai(
                    color: Colors.deepOrange.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                )
              ]
            : [
                Text(
                  "฿${myFormat.format(shopProductItems.priceBeforeDiscount)}",
                  style: GoogleFonts.ibmPlexSansThai(
                    color: Colors.deepOrange.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                )
              ];
      },
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.2),
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.only(left: 4, right: 12),
            height: 20,
            child: Text(
              shopProductItems.selectItem,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: Colors.grey.shade700,
          )
        ],
      ),
    );
  }

  Future<dynamic> showOption(
      TextEditingController qtyController, String previousValue) {
    return Get.bottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0))),
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return SafeArea(
          child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          int indexOpen =
                                              cartCtr.selectedOptions[0] ?? 0;

                                          var imageUrls = shopProductItems
                                              .tierVariations[0].options
                                              .map((e) => e.image)
                                              .toList();
                                          Get.to(() => EndUserProductMedias(
                                              mediaUrls: imageUrls,
                                              index: indexOpen));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 100,
                                                // padding: const EdgeInsets.all(8),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade100),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: CachedNetworkImage(
                                                    imageUrl: cartCtr
                                                        .imageFirst.value),
                                              ),
                                              Positioned(
                                                top: 2,
                                                right: 2,
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  alignment: Alignment.topRight,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade500,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      const Icon(
                                                        Icons.arrow_outward,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                      Positioned(
                                                        top: 6,
                                                        right: 6,
                                                        child: Transform.rotate(
                                                          angle: 3.2,
                                                          child: const Icon(
                                                            Icons.arrow_outward,
                                                            color: Colors.white,
                                                            size: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children:
                                                cartCtr.productPrice.value ??
                                                    [],
                                          ),
                                          Text(
                                            'คลัง : ${myFormat.format(cartCtr.stock.value)}',
                                            style: GoogleFonts.ibmPlexSansThai(
                                                fontSize: 12,
                                                color: Colors.grey.shade700),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  IconButton(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    color: Colors.grey.shade700,
                                  )
                                ],
                              ),
                              const Divider(),
                              Container(
                                color: Colors.grey.shade100,
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      color: Colors.white,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        primary: false,
                                        itemCount: shopProductItems
                                            .tierVariations.length,
                                        itemBuilder: (context, index) {
                                          var tierVariation =
                                              cartCtr.productTier.value[index];

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tierVariation.name,
                                                style:
                                                    GoogleFonts.ibmPlexSansThai(
                                                        fontSize: 12),
                                              ),
                                              Wrap(
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          tierVariation
                                                              .options.length;
                                                      i++)
                                                    InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          await selectProduct(
                                                              index, i);
                                                          qtyController.text =
                                                              "1";
                                                          previousValue = "1";
                                                          setState(
                                                            () {},
                                                          );
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6),
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: cartCtr.selectedOptions[index] ==
                                                                              i &&
                                                                          tierVariation.options[i].displayIndicators !=
                                                                              2
                                                                      ? Border.all(
                                                                          color: Colors
                                                                              .deepOrange
                                                                              .shade700)
                                                                      : null,
                                                                  color: tierVariation.options[i].displayIndicators ==
                                                                          2
                                                                      ? Colors
                                                                          .grey
                                                                          .shade50
                                                                      : cartCtr.selectedOptions[index] ==
                                                                              i
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .grey
                                                                              .shade100,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4)),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              if (index == 0)
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              2),
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                                  child: Stack(
                                                                    children: [
                                                                      Image(
                                                                        width:
                                                                            30,
                                                                        height:
                                                                            25,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image:
                                                                            CachedNetworkImageProvider(
                                                                          shopProductItems
                                                                              .tierVariations[index]
                                                                              .options[i]
                                                                              .image,
                                                                        ),
                                                                        errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          return SizedBox(
                                                                            width:
                                                                                30,
                                                                            height:
                                                                                25,
                                                                            child:
                                                                                Icon(
                                                                              Icons.image_not_supported,
                                                                              color: Colors.grey.shade500,
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                      if (tierVariation
                                                                              .options[
                                                                                  i]
                                                                              .displayIndicators ==
                                                                          2)
                                                                        Positioned
                                                                            .fill(
                                                                          child:
                                                                              BackdropFilter(
                                                                            filter:
                                                                                ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8), // ปรับค่า sigma ให้เบลอ
                                                                            child:
                                                                                Container(
                                                                              color: Colors.white.withOpacity(0.5), // สีขาวโปร่งแสง 50%
                                                                            ),
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ConstrainedBox(
                                                                constraints:
                                                                    const BoxConstraints(
                                                                        maxWidth:
                                                                            140),
                                                                child: Text(
                                                                  tierVariation
                                                                      .options[
                                                                          i]
                                                                      .optionValue,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFonts.ibmPlexSansThai(
                                                                      fontSize: 12,
                                                                      color: tierVariation.options[i].displayIndicators == 2
                                                                          ? Colors.grey.shade400
                                                                          : cartCtr.selectedOptions[index] == i
                                                                              ? Colors.deepOrange.shade700
                                                                              : null),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        color: Colors.white,
                                        child: const Divider()),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 12, bottom: 12),
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'จำนวน',
                                            style: GoogleFonts.ibmPlexSansThai(
                                                fontSize: 12),
                                          ),
                                          Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade100),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    if (qtyController.text ==
                                                        "") {
                                                      return;
                                                    }
                                                    int qty = int.parse(
                                                            qtyController
                                                                .text) -
                                                        1;
                                                    if (qty < 1) return;
                                                    qtyController.text =
                                                        qty.toString();
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0),
                                                    child: Text('-'),
                                                  ),
                                                ),
                                                const VerticalDivider(width: 2),
                                                SizedBox(
                                                    height: 30,
                                                    width: 40,
                                                    child: Center(
                                                      child: TextFormField(
                                                          controller:
                                                              qtyController,
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .center,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .ibmPlexSansThai(
                                                                  fontSize: 12),
                                                          onChanged: (value) {
                                                            if (value.isEmpty) {
                                                              return;
                                                            } else if (int
                                                                    .parse(
                                                                        value) >
                                                                cartCtr.stock
                                                                    .value) {
                                                              // ถ้าค่าที่ป้อนเกิน maxQuantity ให้คืนค่าก่อนหน้า
                                                              qtyController
                                                                      .text =
                                                                  previousValue;
                                                              qtyController
                                                                      .selection =
                                                                  TextSelection
                                                                      .fromPosition(
                                                                TextPosition(
                                                                    offset: qtyController
                                                                        .text
                                                                        .length),
                                                              );
                                                            } else {
                                                              // บันทึกค่าปัจจุบันเป็นค่าเดิมสำหรับการตรวจสอบในอนาคต
                                                              previousValue =
                                                                  value;
                                                            }
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  isCollapsed:
                                                                      true,
                                                                  // filled: false,
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  labelStyle:
                                                                      GoogleFonts
                                                                          .ibmPlexSansThai()),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number),
                                                    )),
                                                const VerticalDivider(width: 2),
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    if (qtyController.text ==
                                                        "") {
                                                      qtyController.text = "1";
                                                      return;
                                                    }
                                                    int qty = int.parse(
                                                            qtyController
                                                                .text) +
                                                        1;
                                                    1;
                                                    if (qty >
                                                        cartCtr.stock.value) {
                                                      return;
                                                    }
                                                    qtyController.text =
                                                        qty.toString();
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0),
                                                    child: Text('+'),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (cartCtr.selectedOptions.values.length !=
                                      shopProductItems.tierVariations.length ||
                                  cartCtr.selectedOptions.values
                                      .any((element) => element == null)) {
                                final nullKeys = cartCtr.selectedOptions.entries
                                    .where((entry) => entry.value == null)
                                    .map((entry) => entry.key)
                                    .toList();

                                dialogAlert([
                                  const Icon(
                                    Icons.notification_important,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  Text(
                                    'กรุณาเลือกตัวเลือก "${shopProductItems.tierVariations[nullKeys.isEmpty ? 0 : nullKeys.first].name}"',
                                    style: GoogleFonts.ibmPlexSansThai(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ]);
                                Future.delayed(
                                    const Duration(milliseconds: 1200), () {
                                  Get.back();
                                });
                                return;
                              }
                              Get.back();
                              Future.delayed(const Duration(milliseconds: 1),
                                  () {
                                loadingProductStock(context);
                              });
                              var productId = shopProductItems.productId;
                              var oldItemId = shopProductItems.selectItemId;
                              await updateOptionCartService(
                                      shopId,
                                      productId,
                                      oldItemId,
                                      cartCtr.itemId.value,
                                      int.parse(qtyController.text),
                                      2)
                                  .then((res) async {
                                Get.back();
                                if (res!.code == "100") {
                                  dialogAlert([
                                    const Icon(
                                      Icons.shopping_cart_checkout_rounded,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    Text(
                                      res.message,
                                      style: GoogleFonts.ibmPlexSansThai(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ]);
                                  Future.delayed(
                                      const Duration(milliseconds: 1500), () {
                                    Get.back();
                                  });
                                  // await controller.deselectAllCart();
                                  var newCart = await cartCtr.fetchCartNoLoad();
                                  await controller.removeSelection(
                                      shopId, oldItemId, productId);
                                  for (var newCart in newCart!.value.data) {
                                    // await controller.deselectAllForShop(
                                    //     shopId, newCart.items);
                                    if (newCart.shopId == shopId) {
                                      var newData = newCart.items
                                          .firstWhereOrNull((item) =>
                                              item.productId == productId);
                                      if (newData != null) {
                                        shopProductItems.addOnId =
                                            newData.addOnId;
                                        shopProductItems.bundleId =
                                            newData.bundleId;
                                        shopProductItems.cartContent =
                                            newData.cartContent;
                                        shopProductItems.cartId =
                                            newData.cartId;
                                        shopProductItems.discount =
                                            newData.discount;
                                        shopProductItems.haveDiscount =
                                            newData.haveDiscount;
                                        shopProductItems.isAddOnItem =
                                            newData.isAddOnItem;
                                        shopProductItems.isFreeGift =
                                            newData.isFreeGift;
                                        shopProductItems.isInPreview =
                                            newData.isInPreview;
                                        shopProductItems.isPreOrder =
                                            newData.isPreOrder;
                                        shopProductItems.normalStock =
                                            newData.normalStock;
                                        shopProductItems.price = newData.price;
                                        shopProductItems.priceBeforeDiscount =
                                            newData.priceBeforeDiscount;
                                        shopProductItems.productId =
                                            newData.productId;

                                        shopProductItems.productImage =
                                            newData.productImage;
                                        shopProductItems.productName =
                                            newData.productName;
                                        shopProductItems.productQty =
                                            newData.productQty;
                                        shopProductItems.promotionStock =
                                            newData.promotionStock;
                                        shopProductItems.selectItem =
                                            newData.selectItem;
                                        shopProductItems.selectItemId =
                                            newData.selectItemId;
                                        shopProductItems.status =
                                            newData.status;
                                        shopProductItems.stock = newData.stock;
                                        shopProductItems.tierVariationsIndex =
                                            newData.tierVariationsIndex;
                                        shopProductItems.tierVariations =
                                            newData.tierVariations;
                                        shopProductItems.totalCanBuyQuantity =
                                            newData.totalCanBuyQuantity;
                                        // cartCtr.itemId.value =
                                        //     newData.selectItemId;
                                        // await controller.removeSelection(
                                        //     newCart.shopId,
                                        //     newData.selectItemId,
                                        //     newData.productId);
                                        await controller.addSelection(
                                            newCart.shopId, newData);
                                        await controller.updateCart();
                                        // await controller.removeSelection(
                                        //     shopId, oldItemId, productId);
                                      }
                                    }
                                  }
                                } else {
                                  dialogAlert([
                                    const Icon(
                                      Icons.notification_important,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        res.message,
                                        style: GoogleFonts.ibmPlexSansThai(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ]);
                                  Future.delayed(
                                      const Duration(milliseconds: 1500), () {
                                    Get.back();
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Builder(builder: (context) {
                                bool isAllSelected = cartCtr
                                            .selectedOptions.values.length ==
                                        shopProductItems
                                            .tierVariations.length &&
                                    cartCtr.selectedOptions.values
                                        .every((element) => element != null);
                                return Container(
                                    width: Get.width,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: isAllSelected
                                            ? themeColorDefault
                                            : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Center(
                                      child: Text('ยืนยัน',
                                          style: GoogleFonts.ibmPlexSansThai(
                                              color: isAllSelected
                                                  ? Colors.white
                                                  : Colors.grey,
                                              fontSize: 13)),
                                    ));
                              }),
                            ),
                          ),
                        ],
                      )))));
    }));
  }

  manageTierWithQty() async {
    bool isAllSelected = cartCtr.selectedOptions.values.length ==
            shopProductItems.tierVariations.length &&
        cartCtr.selectedOptions.values.every((element) => element != null);
    if (isAllSelected) {
      loadingProductTier(Get.context);
    }

    int proId = shopProductItems.productId;

    bool isAllUnselected =
        cartCtr.selectedOptions.values.every((element) => element == null);
    List<SelectedTier> listTier = [];

    for (var entry in cartCtr.selectedOptions.entries.toList()) {
      if (entry.value != null) {
        int selectedIndex = entry.value!;
        var option =
            cartCtr.productTier.value[entry.key].options[selectedIndex];
        if (option.displayIndicators == 0) {
          listTier.add(SelectedTier(
            key: entry.key,
            value: selectedIndex,
          ));
        }
      }
    }
    SetData data = SetData();
    var custId = await data.b2cCustID;
    EndUserProductOptions optionSelected = EndUserProductOptions(
      custId: custId,
      productId: proId,
      shopId: shopId,
      selectedTiers: listTier,
      quantity: int.parse(qtyController.text),
    );
    tier_variation.TierVariations? res =
        await fetchProductTierVariationService(optionSelected);

    if (isAllUnselected) {
      cartCtr.stock.value = shopProductItems.stock;
      cartCtr.productPrice.value = productPriceWidget(
          productPrices: res!.data.productPrice, showPercent: false);
      cartCtr.productTier.value = res.data.tierVariations;
    } else {
      cartCtr.productTier.value = res!.data.tierVariations;
      cartCtr.stock.value = res.data.stock;
      cartCtr.itemId.value = res.data.itemId;
      cartCtr.productPrice.value = productPriceWidget(
          productPrices: res.data.productPrice, showPercent: false);
    }
    if (isAllSelected) {
      // Future.delayed(Duration(seconds: 4), () {
      Get.back();
      // });
    }
  }

  Future<void> selectProduct(int index, int i) async {
    if (cartCtr.productTier.value[index].options[i].displayIndicators == 2) {
      return;
    }

    if (cartCtr.selectedOptions[index] == i) {
      cartCtr.selectedOptions[index] = null;
      if (index == 0) {
        cartCtr.imageFirst.value = shopProductItems.productImage;
      }
    } else {
      // ถ้าไม่ใช่ตัวเลือกเดิม ให้เลือก option ใหม่
      cartCtr.selectedOptions[index] = i;
      if (index == 0) {
        cartCtr.imageFirst.value =
            shopProductItems.tierVariations[index].options[i].image;
      }
    }

    await manageTierWithQty();
  }

  // Future<void> selectProduct(int index, int i) async {
  //   if (cartCtr.productTier.value[index].options[i].displayIndicators == 2) {
  //     return;
  //   }

  //   int proId = shopProductItems.productId;
  //   if (cartCtr.selectedOptions[index] == i) {
  //     cartCtr.selectedOptions[index] = null;
  //     if (index == 0) {
  //       cartCtr.imageFirst.value = shopProductItems.productImage;
  //     }
  //   } else {
  //     // ถ้าไม่ใช่ตัวเลือกเดิม ให้เลือก option ใหม่
  //     cartCtr.selectedOptions[index] = i;
  //     if (index == 0) {
  //       cartCtr.imageFirst.value =
  //           shopProductItems.tierVariations[index].options[i].image;
  //     }
  //   }
  //   // printWhite(
  //   //     jsonEncode(showProductCtr.productDetail.value!.data.tierVariations));

  //   bool isAllUnselected =
  //       cartCtr.selectedOptions.values.every((element) => element == null);

  //   List<SelectedTier> listTier = [];

  //   for (var entry in cartCtr.selectedOptions.entries.toList()) {
  //     if (entry.value != null) {
  //       int selectedIndex = entry.value!;
  //       var option =
  //           shopProductItems.tierVariations[entry.key].options[selectedIndex];
  //       if (option.displayIndicators == 0) {
  //         listTier.add(SelectedTier(
  //           key: entry.key,
  //           value: selectedIndex,
  //         ));
  //       }
  //     }
  //   }

  //   if (isAllUnselected) {
  //     cartCtr.stock.value = shopProductItems.stock;
  //     cartCtr.productPrice.value = shopProductItems.haveDiscount
  //         ? [
  //             Text(
  //               "฿${myFormat.format(shopProductItems.price)}",
  //               style: GoogleFonts.ibmPlexSansThai(
  //                 color: Colors.deepOrange.shade700,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 24,
  //               ),
  //             )
  //           ]
  //         : [
  //             Text(
  //               "฿${myFormat.format(shopProductItems.priceBeforeDiscount)}",
  //               style: GoogleFonts.ibmPlexSansThai(
  //                 color: Colors.deepOrange.shade700,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 24,
  //               ),
  //             )
  //           ];

  //     cartCtr.productTier.value = shopProductItems.tierVariations;
  //   } else {
  //     SetData data = SetData();
  //     var custId = await data.b2cCustID;
  //     EndUserProductOptions optionSelected = EndUserProductOptions(
  //         custId: custId,
  //         productId: proId,
  //         shopId: shopId,
  //         quantity: int.parse(qtyController.text),
  //         selectedTiers: listTier);
  //     tier_variation.TierVariations? res =
  //         await fetchProductTierVariationService(optionSelected);
  //     cartCtr.productTier.value = res!.data.tierVariations;
  //     cartCtr.stock.value = res.data.stock;
  //     cartCtr.itemId.value = res.data.itemId;
  //     cartCtr.productPrice.value = productPriceWidget(
  //         productPrices: res.data.productPrice, showPercent: false);
  //   }
  // }
}

productPriceWidget({required productPrices, required bool showPercent}) {
  if (!productPrices.haveDiscount) {
    return [
      Text(
        productPrices.priceBeforeDiscount.singleValue > 0
            ? '฿${myFormat.format(productPrices.priceBeforeDiscount.singleValue)} '
            : "฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMin)} - ${myFormat.format(productPrices.priceBeforeDiscount.rangeMax)}",
        style: GoogleFonts.ibmPlexSansThai(
          color: Colors.deepOrange.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      )
    ];
  } else {
    return [
      if (productPrices.price.singleValue > 0)
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('฿${myFormat.format(productPrices.price.singleValue)} ',
                style: GoogleFonts.ibmPlexSansThai(
                  color: Colors.deepOrange.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                )),
            if (productPrices.priceBeforeDiscount.singleValue > 0)
              Text(
                '฿${myFormat.format(productPrices.priceBeforeDiscount.singleValue)}',
                style: GoogleFonts.ibmPlexSansThai(
                  decoration: TextDecoration.lineThrough,
                  fontSize: 14,
                  height: 2.4,
                  color: Colors.grey.shade400,
                ),
              )
            else
              Text(
                '฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMin)} - ฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMax)}',
                style: GoogleFonts.ibmPlexSansThai(
                    decoration: TextDecoration.lineThrough,
                    height: 2.4,
                    fontSize: 14,
                    color: Colors.grey.shade400),
              ),
          ],
        )
      else
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '฿${myFormat.format(productPrices.price.rangeMin)} - ฿${myFormat.format(productPrices.price.rangeMax)}',
              style: GoogleFonts.ibmPlexSansThai(
                color: Colors.deepOrange.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            Text(
              '฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMin)} - ฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMax)}',
              style: GoogleFonts.ibmPlexSansThai(
                  decoration: TextDecoration.lineThrough,
                  height: 2.4,
                  fontSize: 14,
                  color: Colors.grey.shade400),
            ),
          ],
        ),
      if (productPrices.discount > 0 && showPercent)
        Container(
          margin: const EdgeInsets.only(left: 2, top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.red.shade50,
          ),
          child: Text(
            '${productPrices.discount} %',
            style: GoogleFonts.ibmPlexSansThai(
                color: Colors.deepOrange, fontSize: 10, height: 1.4),
          ),
        )
    ];
  }
}
