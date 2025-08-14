import 'dart:async';
import 'dart:ui';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/models/showproduct/option.sku.dart';
import 'package:fridayonline/member/services/cart/cart.service.dart';
import 'package:fridayonline/member/services/showproduct/showproduct.sku.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(anonymous)/signin.dart';
import 'package:fridayonline/member/views/(showproduct)/medias.sku.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fridayonline/member/models/showproduct/product.sku.model.dart'
    as product_model;
import 'package:fridayonline/member/models/showproduct/tier.variations.model.dart'
    as tier_variation;

final ShowProductSkuCtr showProductCtr = Get.find();
TextEditingController qtyController = TextEditingController(text: '1');
String previousValue = "1";

class BottomAddToCart extends StatefulWidget {
  const BottomAddToCart({
    required this.context,
    required this.startAnimation,
    required this.startImageKey,
    super.key,
  });
  final BuildContext context;
  final void Function(BuildContext context, Offset startPosition, String url)
      startAnimation;
  final GlobalKey<State<StatefulWidget>> startImageKey;

  @override
  State<BottomAddToCart> createState() => _BottomAddToCartState();
}

class _BottomAddToCartState extends State<BottomAddToCart> {
  Timer? debounce;
  bool clickedMinus = false;
  bool clickedPlus = false;
  @override
  void initState() {
    previousValue = "1";
    super.initState();
  }

  @override
  void dispose() {
    previousValue = "1";
    super.dispose();
  }

  addToCart() async {
    // showProductCtr.itemId.value = 0;
    return Get.bottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0))),
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      handleClick(String type) {
        switch (type) {
          case 'plus':
            {
              setState(() {
                clickedPlus = true;
              });
              Future.delayed(const Duration(milliseconds: 200), () {
                setState(() {
                  clickedPlus = false;
                });
              });
              break;
            }
          case 'minus':
            {
              setState(() {
                clickedMinus = true;
              });
              Future.delayed(const Duration(milliseconds: 200), () {
                setState(() {
                  clickedMinus = false;
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

      return SafeArea(
        child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Obx(() {
                return SingleChildScrollView(
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
                                          showProductCtr.selectedOptions[0] ??
                                              0;
                                      indexOpen > 0
                                          ? indexOpen = indexOpen + 1
                                          : 0;

                                      Get.to(() => EndUserProductMedias(
                                          mediaUrls: showProductCtr
                                              .productDetail
                                              .value!
                                              .data
                                              .optionImages,
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
                                                    color:
                                                        Colors.grey.shade100),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: CachedNetworkImage(
                                              key: widget.startImageKey,
                                              imageUrl: showProductCtr
                                                  .imageFirst.value,
                                              errorWidget:
                                                  (context, url, error) {
                                                return Icon(
                                                  Icons.shopify,
                                                  color: Colors.grey.shade200,
                                                );
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: 2,
                                            right: 2,
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              padding: const EdgeInsets.all(2),
                                              alignment: Alignment.topRight,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade500,
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
                                      Obx(() {
                                        return Row(
                                            children: productPriceWidget(
                                                productPrices: showProductCtr
                                                    .productPrice.value,
                                                showPercent: false));
                                      }),
                                      Text(
                                        'คลัง : ${myFormat.format(showProductCtr.stock.value)}',
                                        style: GoogleFonts.notoSansThaiLooped(
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
                                  child: Obx(() {
                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: showProductCtr
                                          .productTier.value.length,
                                      itemBuilder: (context, index) {
                                        product_model.TierVariation
                                            tierVariation = showProductCtr
                                                .productTier.value[index];

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tierVariation.name,
                                              style: GoogleFonts
                                                  .notoSansThaiLooped(
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
                                                        setState(
                                                          () {},
                                                        );
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(4),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: showProductCtr.selectedOptions[index] ==
                                                                            i &&
                                                                        tierVariation.options[i].displayIndicators !=
                                                                            2
                                                                    ? Border.all(
                                                                        color: Colors
                                                                            .deepOrange
                                                                            .shade700)
                                                                    : null,
                                                                color: tierVariation
                                                                            .options[
                                                                                i]
                                                                            .displayIndicators ==
                                                                        2
                                                                    ? Colors
                                                                        .grey
                                                                        .shade50
                                                                    : showProductCtr.selectedOptions[index] ==
                                                                            i
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .grey
                                                                            .shade100,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(4)),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            if (index == 0)
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            2),
                                                                clipBehavior: Clip
                                                                    .antiAlias,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4)),
                                                                child: Stack(
                                                                  children: [
                                                                    Image(
                                                                      width: 30,
                                                                      height:
                                                                          25,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image:
                                                                          CachedNetworkImageProvider(
                                                                        showProductCtr
                                                                            .productDetail
                                                                            .value!
                                                                            .data
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
                                                                            color:
                                                                                Colors.grey.shade500,
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
                                                                          filter: ImageFilter.blur(
                                                                              sigmaX: 0.8,
                                                                              sigmaY: 0.8), // ปรับค่า sigma ให้เบลอ
                                                                          child:
                                                                              Container(
                                                                            color:
                                                                                Colors.white.withOpacity(0.5), // สีขาวโปร่งแสง 50%
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
                                                                    .options[i]
                                                                    .optionValue,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: GoogleFonts.notoSansThaiLooped(
                                                                    fontSize: 12,
                                                                    color: tierVariation.options[i].displayIndicators == 2
                                                                        ? Colors.grey.shade400
                                                                        : showProductCtr.selectedOptions[index] == i
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
                                    );
                                  }),
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    color: Colors.white,
                                    child: const Divider()),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                      bottom: showProductCtr
                                                  .productDetail
                                                  .value!
                                                  .data
                                                  .teaserFlashsale
                                                  .promotionId ==
                                              0
                                          ? 12
                                          : (int.tryParse(qtyController.text) ??
                                                      0) >
                                                  showProductCtr
                                                      .productDetail
                                                      .value!
                                                      .data
                                                      .promotionStock
                                              ? 12
                                              : 0),
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Obx(() {
                                        if (showProductCtr.reminderText.value ==
                                            "") {
                                          return const SizedBox();
                                        }
                                        return SizedBox(
                                          width: Get.width,
                                          child: Text(
                                            showProductCtr.reminderText.value,
                                            style: TextStyle(
                                                fontSize: 11,
                                                color:
                                                    Colors.deepOrange.shade700),
                                          ),
                                        );
                                      }),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'จำนวน',
                                            style:
                                                GoogleFonts.notoSansThaiLooped(
                                                    fontSize: 12),
                                          ),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                height: 36,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade100),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        handleClick('minus');
                                                        if (qtyController
                                                                .text ==
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
                                                        if (debounce
                                                                ?.isActive ??
                                                            false) {
                                                          debounce!.cancel();
                                                        }
                                                        debounce = Timer(
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                            () async {
                                                          await manageTierWithQty();
                                                        });

                                                        setState(
                                                          () {},
                                                        );
                                                      },
                                                      child: Container(
                                                        height: Get.height,
                                                        alignment:
                                                            Alignment.center,
                                                        color: clickedMinus
                                                            ? Colors
                                                                .grey.shade100
                                                            : Colors.white,
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      12.0),
                                                          child: Text('-'),
                                                        ),
                                                      ),
                                                    ),
                                                    const VerticalDivider(
                                                        width: 2),
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
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .notoSansThaiLooped(
                                                                      fontSize:
                                                                          12),
                                                              onChanged:
                                                                  (value) async {
                                                                if (value
                                                                    .isEmpty) {
                                                                  return;
                                                                } else if (int
                                                                        .parse(
                                                                            value) >
                                                                    showProductCtr
                                                                        .stock
                                                                        .value) {
                                                                  // ถ้าค่าที่ป้อนเกิน stock ให้คืนค่าก่อนหน้า
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
                                                                if (debounce
                                                                        ?.isActive ??
                                                                    false) {
                                                                  debounce!
                                                                      .cancel();
                                                                }
                                                                debounce = Timer(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                    () async {
                                                                  await manageTierWithQty();
                                                                });

                                                                setState(
                                                                  () {},
                                                                );
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                      isCollapsed:
                                                                          true,
                                                                      // filled: false,
                                                                      border: InputBorder
                                                                          .none,
                                                                      labelStyle:
                                                                          GoogleFonts
                                                                              .notoSansThaiLooped()),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number),
                                                        )),
                                                    const VerticalDivider(
                                                        width: 2),
                                                    InkWell(
                                                      onTap: () async {
                                                        handleClick('plus');
                                                        if (qtyController
                                                                .text ==
                                                            "") {
                                                          qtyController.text =
                                                              "1";
                                                          return;
                                                        }
                                                        int qty = int.parse(
                                                                qtyController
                                                                    .text) +
                                                            1;
                                                        1;
                                                        if (qty >
                                                            showProductCtr.stock
                                                                .value) return;

                                                        qtyController.text =
                                                            qty.toString();
                                                        if (debounce
                                                                ?.isActive ??
                                                            false) {
                                                          debounce!.cancel();
                                                        }
                                                        debounce = Timer(
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                            () async {
                                                          await manageTierWithQty();
                                                        });
                                                        setState(
                                                          () {},
                                                        );
                                                      },
                                                      child: Container(
                                                        height: Get.height,
                                                        color: clickedPlus
                                                            ? Colors
                                                                .grey.shade100
                                                            : Colors.white,
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      12.0),
                                                          child: Text('+'),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              if (showProductCtr.selectedOptions
                                                          .values.length ==
                                                      showProductCtr
                                                          .productDetail
                                                          .value!
                                                          .data
                                                          .tierVariations
                                                          .length &&
                                                  showProductCtr
                                                      .selectedOptions.values
                                                      .any((element) =>
                                                          element == null))
                                                Container(
                                                  height: 30,
                                                  width: 100,
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          SetData storeData = SetData();
                          if (await storeData.loginStatus != '1') {
                            Get.to(() => const SignInScreen());
                            return;
                          }
                          if (showProductCtr.selectedOptions.values.length !=
                                  showProductCtr.productDetail.value!.data
                                      .tierVariations.length ||
                              showProductCtr.selectedOptions.values
                                  .any((element) => element == null)) {
                            final nullKeys = showProductCtr
                                .selectedOptions.entries
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
                                'กรุณาเลือกตัวเลือก "${showProductCtr.productDetail.value!.data.tierVariations[nullKeys.isEmpty ? 0 : nullKeys.first].name}"',
                                style: GoogleFonts.notoSansThaiLooped(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ]);
                            Future.delayed(const Duration(milliseconds: 1200),
                                () {
                              Get.back();
                            });
                            return;
                          }
                          Future.delayed(const Duration(milliseconds: 1), () {
                            loadingProductStock(context);
                          });
                          var shopId =
                              showProductCtr.productDetail.value!.data.shopId;
                          var productId = showProductCtr
                              .productDetail.value!.data.productId;
                          if (showProductCtr.itemId.value == 0) {
                            SetData data = SetData();
                            var custId = await data.b2cCustID;
                            EndUserProductOptions optionSelected =
                                EndUserProductOptions(
                                    custId: custId,
                                    productId: productId,
                                    shopId: shopId,
                                    quantity: int.parse(qtyController.text),
                                    selectedTiers: []);
                            tier_variation.TierVariations? res =
                                await fetchProductTierVariationService(
                                    optionSelected);
                            showProductCtr.itemId.value = res!.data.itemId;
                          }
                          await addToCartService(
                                  shopId,
                                  productId,
                                  showProductCtr.itemId.value,
                                  int.parse(qtyController.text),
                                  1)
                              .then((res) {
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
                                  style: GoogleFonts.notoSansThaiLooped(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ]);
                              final RenderBox renderBox = widget
                                  .startImageKey.currentContext!
                                  .findRenderObject() as RenderBox;
                              final Offset position =
                                  renderBox.localToGlobal(Offset.zero);

                              widget.startAnimation(context, position,
                                  showProductCtr.imageFirst.value);
                              Get.find<EndUserCartCtr>().fetchCartItems();
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
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.notoSansThaiLooped(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ]);
                              Future.delayed(const Duration(milliseconds: 2000),
                                  () {
                                Get.back();
                              });
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Obx(() {
                            bool isAllSelected =
                                showProductCtr.selectedOptions.values.length ==
                                        showProductCtr.productDetail.value!.data
                                            .tierVariations.length &&
                                    showProductCtr.selectedOptions.values
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
                                  child: Text('เพิ่มสินค้าไปยังตะกร้า',
                                      style: GoogleFonts.notoSansThaiLooped(
                                          color: isAllSelected
                                              ? Colors.white
                                              : Colors.grey,
                                          fontSize: 13)),
                                ));
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            )),
      );
    }));
  }

  manageTierWithQty() async {
    bool isAllSelected = showProductCtr.selectedOptions.values.length ==
            showProductCtr.productDetail.value!.data.tierVariations.length &&
        showProductCtr.selectedOptions.values
            .every((element) => element != null);
    if (isAllSelected) {
      loadingProductTier(context);
    }

    int proId = showProductCtr.productDetail.value!.data.productId;

    bool isAllUnselected = showProductCtr.selectedOptions.values
        .every((element) => element == null);
    List<SelectedTier> listTier = [];

    for (var entry in showProductCtr.selectedOptions.entries.toList()) {
      if (entry.value != null) {
        int selectedIndex = entry.value!;
        var option = showProductCtr.productDetail.value!.data
            .tierVariations[entry.key].options[selectedIndex];
        if (option.displayIndicators == 0) {
          listTier.add(SelectedTier(
            key: entry.key,
            value: selectedIndex,
          ));
        }
      }
    }

    if (isAllUnselected) {
      showProductCtr.stock.value =
          showProductCtr.productDetail.value!.data.stock;
      showProductCtr.productPrice.value =
          showProductCtr.productDetail.value!.data.productPrice;
      showProductCtr.productTier.value =
          showProductCtr.productDetail.value!.data.tierVariations;
    } else {
      var shopId = showProductCtr.productDetail.value!.data.shopId;
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
      showProductCtr.productTier.value = res!.data.tierVariations;
      showProductCtr.stock.value = res.data.stock;
      showProductCtr.itemId.value = res.data.itemId;
      showProductCtr.productPrice.value = res.data.productPrice;
      showProductCtr.reminderText.value =
          res.data.selectedVariation.reminderText;
    }
    if (isAllSelected) {
      // Future.delayed(Duration(seconds: 4), () {
      Get.back();
      // });
    }
  }

  Future<void> selectProduct(int index, int i) async {
    if (showProductCtr.productTier.value[index].options[i].displayIndicators ==
        2) {
      return;
    }

    if (showProductCtr.selectedOptions[index] == i) {
      showProductCtr.selectedOptions[index] = null;
      if (index == 0) {
        showProductCtr.imageFirst.value = showProductCtr
            .productDetail.value!.data.productImages.image
            .firstWhere((element) => element.defaultFlag == 1,
                orElse: () => showProductCtr
                    .productDetail.value!.data.productImages.image.first)
            .image;
      }
    } else {
      // ถ้าไม่ใช่ตัวเลือกเดิม ให้เลือก option ใหม่
      showProductCtr.selectedOptions[index] = i;
      if (index == 0) {
        showProductCtr.imageFirst.value = showProductCtr
            .productDetail.value!.data.productImages.image
            .firstWhere((element) =>
                element.keyImage ==
                showProductCtr
                    .productDetail.value!.data.productDatail[i].keyImage)
            .image;
      }
    }
    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }
    // debounce = Timer(const Duration(milliseconds: 500), () async {
    await manageTierWithQty();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (showProductCtr.productDetail.value!.data.stock <= 0) {
        return SafeArea(
            child: Container(
          alignment: Alignment.center,
          height: 50,
          color: Colors.grey.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.remove_shopping_cart_rounded,
                color: Colors.grey.shade400,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                'สินค้าหมดสต๊อก',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
        ));
      }
      return SafeArea(
        child: InkWell(
          onTap: () async {
            qtyController.text = '1';
            // กรณีเลือก options ก่อน
            if (showProductCtr.indexPrdOption.value != -1) {
              loadingProductStock(context);
              List<SelectedTier> listTier = [
                SelectedTier(key: 0, value: showProductCtr.indexPrdOption.value)
              ];
              var shopId = showProductCtr.productDetail.value!.data.shopId;
              SetData data = SetData();
              var custId = await data.b2cCustID;
              EndUserProductOptions optionSelected = EndUserProductOptions(
                  custId: custId,
                  productId: showProductCtr.productDetail.value!.data.productId,
                  shopId: shopId,
                  selectedTiers: listTier,
                  quantity: int.parse(qtyController.text));
              tier_variation.TierVariations? res =
                  await fetchProductTierVariationService(optionSelected);
              showProductCtr.selectedOptions.clear();

              for (int idxt = 0;
                  idxt <
                      showProductCtr
                          .productDetail.value!.data.tierVariations.length;
                  idxt++) {
                if (idxt == 0) {
                  if (showProductCtr
                          .productDetail
                          .value!
                          .data
                          .tierVariations[0]
                          .options[showProductCtr.indexPrdOption.value]
                          .displayIndicators ==
                      2) {
                    showProductCtr.selectedOptions[idxt] = null;
                  } else {
                    showProductCtr.selectedOptions[0] =
                        showProductCtr.indexPrdOption.value;
                  }
                } else {
                  showProductCtr.selectedOptions[idxt] = null;
                }
              }
              showProductCtr.productTier.value = res!.data.tierVariations;
              showProductCtr.itemId.value = res.data.itemId;
              showProductCtr.stock.value = res.data.stock;
              showProductCtr.imageFirst.value = showProductCtr
                  .productDetail.value!.data.productImages.image
                  .firstWhere((element) =>
                      element.keyImage ==
                      showProductCtr
                          .productDetail
                          .value!
                          .data
                          .productDatail[showProductCtr.indexPrdOption.value]
                          .keyImage)
                  .image;
              showProductCtr.productPrice.value = res.data.productPrice;
              Get.back();
              addToCart().then((res) {
                showProductCtr.productPrice.value =
                    showProductCtr.productDetail.value!.data.productPrice;
                showProductCtr.productTier.value =
                    showProductCtr.productDetail.value!.data.tierVariations;
                showProductCtr.reminderText.value = "";
              });
            } else {
              showProductCtr.selectedOptions.clear();
              // กรณัีไม่ท่ี่เลือก options
              loadingProductStock(context);
              if (showProductCtr
                  .productDetail.value!.data.tierVariations.isEmpty) {
                showProductCtr.imageFirst.value = showProductCtr
                    .productDetail.value!.data.productImages.image[0].image;
              } else {
                showProductCtr.imageFirst.value = showProductCtr
                    .productDetail.value!.data.productImages.image
                    .firstWhere((element) => element.defaultFlag == 1,
                        orElse: () => showProductCtr.productDetail.value!.data
                            .productImages.image.first)
                    .image;
              }

              showProductCtr.stock.value =
                  showProductCtr.productDetail.value!.data.stock;
              for (int it = 0;
                  it <
                      showProductCtr
                          .productDetail.value!.data.tierVariations.length;
                  it++) {
                showProductCtr.selectedOptions[it] = null;
              }

              Get.back();
              addToCart().then((res) {
                showProductCtr.productPrice.value =
                    showProductCtr.productDetail.value!.data.productPrice;
                showProductCtr.productTier.value =
                    showProductCtr.productDetail.value!.data.tierVariations;
                showProductCtr.reminderText.value = "";
              });
            }
          },
          child: Container(
            height: 55,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Color.fromARGB(88, 0, 0, 0),
                offset: Offset(0.0, -12.0),
                blurRadius: 12,
                spreadRadius: -20,
              ),
            ]),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: themeColorDefault),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_shopping_cart_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        'เพิ่มไปยังตะกร้า',
                        style: GoogleFonts.notoSansThaiLooped(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

productPriceWidget({required productPrices, required bool showPercent}) {
  if (!productPrices.haveDiscount) {
    return [
      Text(
        productPrices.priceBeforeDiscount.singleValue > 0
            ? '฿${myFormat.format(productPrices.priceBeforeDiscount.singleValue)} '
            : "฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMin)} - ${myFormat.format(productPrices.priceBeforeDiscount.rangeMax)}",
        style: GoogleFonts.notoSansThaiLooped(
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
                style: GoogleFonts.notoSansThaiLooped(
                  color: Colors.deepOrange.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                )),
            if (productPrices.priceBeforeDiscount.singleValue > 0)
              Text(
                '฿${myFormat.format(productPrices.priceBeforeDiscount.singleValue)}',
                style: GoogleFonts.notoSansThaiLooped(
                  decoration: TextDecoration.lineThrough,
                  fontSize: 14,
                  height: 2.4,
                  color: Colors.grey.shade400,
                ),
              )
            else
              Text(
                '฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMin)} - ฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMax)}',
                style: GoogleFonts.notoSansThaiLooped(
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
              style: GoogleFonts.notoSansThaiLooped(
                color: Colors.deepOrange.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            Text(
              '฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMin)} - ฿${myFormat.format(productPrices.priceBeforeDiscount.rangeMax)}',
              style: GoogleFonts.notoSansThaiLooped(
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
            style: GoogleFonts.notoSansThaiLooped(
                color: Colors.deepOrange, fontSize: 10, height: 1.4),
          ),
        )
    ];
  }
}
