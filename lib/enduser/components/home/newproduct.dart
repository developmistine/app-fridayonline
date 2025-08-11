import 'package:fridayonline/enduser/controller/enduser.home.ctr.dart';
import 'package:fridayonline/enduser/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/enduser/models/home/home.content.model.dart';
import 'package:fridayonline/enduser/utils/cached_image.dart';
import 'package:fridayonline/enduser/utils/event.dart';
import 'package:fridayonline/enduser/widgets/gap.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NewCollection extends StatelessWidget {
  const NewCollection({super.key});

  @override
  Widget build(BuildContext context) {
    final EndUserHomeCtr endUserHomeCtr = Get.find();

    return Obx(() {
      return !endUserHomeCtr.isLoadingNewProduts.value
          ? endUserHomeCtr.newProducts!.code == '-9'
              ? const SizedBox()
              : Column(
                  children: [
                    const Gap(
                      height: 8,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: Get.width,
                          height: 300,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black,
                                  Colors.transparent,
                                ],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.asset(
                              'assets/images/b2c/background/bg-yellow.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: endUserHomeCtr
                                .newProducts!.data.contentTypeDetail.length,
                            itemBuilder: (context, index) {
                              var contentDetails = endUserHomeCtr
                                  .newProducts!.data.contentTypeDetail[index];
                              if (contentDetails.contentType != 3) {
                                return const SizedBox();
                              }

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'สินค้าใหม่',
                                          style: GoogleFonts.notoSansThaiLooped(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            eventBanner(
                                                contentDetails
                                                    .contentDetail.first,
                                                'home_newproducts');
                                          },
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'ดูทั้งหมด',
                                                    style: GoogleFonts
                                                        .notoSansThaiLooped(
                                                            fontSize: 14),
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 16,
                                                  )
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount:
                                          contentDetails.contentDetail.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        ContentDetail detail =
                                            contentDetails.contentDetail[index];
                                        return SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(
                                                detail.productContent.length,
                                                (index) {
                                              ProductContent productItem =
                                                  detail.productContent[index];
                                              return SizedBox(
                                                width: 160,
                                                // height: 260,
                                                child: NewProductItem(
                                                    product: productItem),
                                              );
                                            }),
                                          ),
                                        );
                                      }),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )
          : const SizedBox();
    });
  }
}

class NewProductItem extends StatelessWidget {
  final ProductContent product;
  const NewProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<ShowProductSkuCtr>()
            .fetchB2cProductDetail(product.productId, '');
        Get.toNamed(
          '/ShowProductSku/${product.productId}',
        );
        // Get.to(() => const ShowProductSku());
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(0, 4),
                blurRadius: 3,
                spreadRadius: 1,
              )
            ]),
        // shadowColor: Colors.red,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CacheImageProducts(
                    setHeight: false,
                    url: product.image,
                    // height: ,
                  ),
                  if (product.isImageOverlayed)
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: CachedNetworkImage(
                          imageUrl: product.imageOverlay,
                          width: 180,
                        )),
                  if (product.isOutOfStock)
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Center(
                          child: Text(
                            'สินค้าหมด',
                            style: GoogleFonts.notoSansThaiLooped(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Text(
                        "      ${product.title}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSansThaiLooped(
                            color: Colors.black, fontSize: 12),
                      ),
                      Positioned(
                        top: 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: CachedNetworkImage(
                            imageUrl: product.icon,
                            width: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (product.discount > 0)
                    Row(
                      children: [
                        Text(
                          '฿${myFormat.format(product.price)}',
                          style: GoogleFonts.notoSansThaiLooped(
                              color: Colors.deepOrange.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '฿${myFormat.format(product.priceBeforeDiscount)}',
                          style: GoogleFonts.notoSansThaiLooped(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey.shade500,
                              fontSize: 12),
                        ),
                      ],
                    )
                  else
                    Text(
                      '฿${myFormat.format(product.priceBeforeDiscount)}',
                      style: GoogleFonts.notoSansThaiLooped(
                          color: Colors.deepOrange.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  // Text(
                  //   '฿ ${myFormat.format(product.discount)}',
                  //   style: GoogleFonts.notoSansThaiLooped(
                  //       decoration: TextDecoration.lineThrough,
                  //       decorationStyle: TextDecorationStyle.solid,
                  //       color: Colors.grey.shade700,
                  //       fontSize: 10),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
