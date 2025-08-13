import 'package:appfridayecommerce/enduser/controller/showproduct.sku.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/track.ctr.dart';
import 'package:appfridayecommerce/enduser/models/showproduct/product.category.model.dart';
import 'package:appfridayecommerce/enduser/services/showproduct/showproduct.sku.service.dart';
import 'package:appfridayecommerce/enduser/utils/format.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RalatedProduct extends StatefulWidget {
  final String productId;
  const RalatedProduct({super.key, required this.productId});

  @override
  State<RalatedProduct> createState() => _RalatedProductState();
}

class _RalatedProductState extends State<RalatedProduct> {
  Future<ProductContent?>? _myFuture;

  @override
  void initState() {
    super.initState();
    _myFuture = fetchRelatedProduct(); // เรียก API แค่ครั้งเดียว
  }

  Future<ProductContent?> fetchRelatedProduct() async {
    return await fetchProductRelateService(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: _myFuture,
          builder: (context, AsyncSnapshot<ProductContent?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            var data = snapshot.data;
            if (data!.code == "-9" || data.data.isEmpty) {
              return const SizedBox();
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        indent: 50,
                        color: Colors.grey.shade600,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: Text(
                          'สินค้าแนะนำ',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSansThaiLooped(fontSize: 14),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        endIndent: 50,
                        color: Colors.grey.shade600,
                      )),
                    ],
                  ),
                ),
                MasonryGridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (Get.width >= 768.0) ? 4 : 2,
                  ),
                  itemCount: data.data.length,
                  itemBuilder: (context, index) {
                    var product = data.data[index];
                    return InkWell(
                      onTap: () {
                        Get.find<TrackCtr>().clearLogContent();
                        if (widget.productId == product.productId.toString()) {
                          return;
                        }
                        // videoController!.pause();
                        Get.find<ShowProductSkuCtr>().selectedOptions.clear();
                        Get.find<ShowProductSkuCtr>().indexPrdOption = (-1).obs;
                        Get.find<ShowProductSkuCtr>().activeKey = "".obs;
                        Get.find<ShowProductSkuCtr>().activeSlide = 0.obs;
                        Get.find<ShowProductSkuCtr>().isSetAppbar.value = false;
                        Get.find<ShowProductSkuCtr>().isExpanded.value = false;
                        Get.find<ShowProductSkuCtr>().indexActive.value = -1;
                        Get.find<ShowProductSkuCtr>().isOptionOutStock.value =
                            false;

                        Get.find<ShowProductSkuCtr>().fetchB2cProductDetail(
                            product.productId, 'product_detail_relate');
                        Get.toNamed(
                          '/ShowProductSku/${product.productId}',
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 0,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  Center(
                                    child: CachedNetworkImage(
                                      imageUrl: product.image,
                                      height: 185,
                                      errorWidget: (context, url, error) {
                                        return Container(
                                          width: Get.width,
                                          height: Get.height,
                                          color: Colors.grey.shade50,
                                          child: Icon(
                                            Icons.shopify,
                                            color: Colors.grey.shade200,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if (product.isImageOverlayed)
                                    CachedNetworkImage(
                                        imageUrl: product.imageOverlay)
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        if (product.icon != "")
                                          Text(
                                            "      ${product.title}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          )
                                        else
                                          Text(product.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 13,
                                              )),
                                        if (product.icon != "")
                                          Positioned(
                                            left: 0,
                                            top: 4,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              child: CachedNetworkImage(
                                                imageUrl: product.icon,
                                                width: 14,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    if (product.ratingStar > 0)
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[50],
                                            border: Border.all(
                                                color: Colors.yellow,
                                                width: 0.5)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RatingBarIndicator(
                                              itemSize: 8,
                                              rating: 1,
                                              direction: Axis.horizontal,
                                              itemCount: 1,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                              itemBuilder: (context, index) =>
                                                  Image.asset(
                                                'assets/images/review/fullStar.png',
                                                color: Colors.amber,
                                              ),
                                            ),
                                            Text(
                                              product.ratingStar.toString(),
                                              style: GoogleFonts
                                                  .notoSansThaiLooped(
                                                      fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Builder(builder: (context) {
                                          if (product.discount > 0) {
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "฿${myFormat.format(product.price)}",
                                                  style: GoogleFonts
                                                      .notoSansThaiLooped(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .deepOrange
                                                              .shade700),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  "฿${myFormat.format(product.priceBeforeDiscount)}",
                                                  style: GoogleFonts
                                                      .notoSansThaiLooped(
                                                          fontSize: 11,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          color: Colors
                                                              .grey.shade700),
                                                ),
                                              ],
                                            );
                                          }
                                          return Text(
                                            '฿${myFormat.format(product.priceBeforeDiscount)}',
                                            style:
                                                GoogleFonts.notoSansThaiLooped(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .deepOrange.shade700),
                                          );
                                        }),
                                        Text(
                                          product.unitSales,
                                          style: GoogleFonts.notoSansThaiLooped(
                                              fontSize: 10),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ]),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
