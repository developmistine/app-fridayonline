import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/controller/track.ctr.dart';
import 'package:fridayonline/member/utils/cached_image.dart';
import 'package:fridayonline/member/utils/format.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCategoryComponents extends StatelessWidget {
  const ProductCategoryComponents(
      {super.key,
      required this.item,
      this.startAnimation,
      this.width,
      this.heigth,
      required this.referrer});
  final dynamic item;
  final void Function(BuildContext context, Offset startPosition, String url)?
      startAnimation;
  final double? width;
  final double? heigth;
  final String referrer;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: InkWell(
        onTap: () {
          if (referrer == "product_detail_shop") {
            Get.find<TrackCtr>().clearLogContent();
          }
          Get.find<ShowProductSkuCtr>()
              .fetchB2cProductDetail(item.productId, referrer);
          Get.toNamed(
            '/ShowProductSku/${item.productId}',
          );
          // Get.to(() => const ShowProductSku());
        },
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200, width: 0.4),
              ),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: width ?? 185,
                                        child: CacheImageProducts(
                                            height: heigth, url: item.image),
                                      ),
                                      if (item.isOutOfStock)
                                        Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            width: heigth != null ? 60 : 100,
                                            height: heigth != null ? 60 : 100,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.black54,
                                              child: Center(
                                                child: Text(
                                                  'สินค้าหมด',
                                                  style: GoogleFonts
                                                      .ibmPlexSansThai(
                                                          color: Colors.white,
                                                          fontSize:
                                                              heigth != null
                                                                  ? 10
                                                                  : 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                if (item.isImageOverlayed)
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: SizedBox(
                                      width: 150,
                                      child: CacheImageOverlay(
                                        url: item.imageOverlay,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (item.discount > 0)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                              ),
                              child: Text(
                                '-${myFormat.format(item.discount)}%',
                                style: GoogleFonts.ibmPlexSansThai(
                                    color: Colors.deepOrange, fontSize: 11),
                              ),
                            )
                        ],
                      ),
                    ),
                    //? ชื่อสินค้า
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.icon == "")
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 12,
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                            )
                          else
                            Stack(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  margin: const EdgeInsets.only(top: 2),
                                  padding: const EdgeInsets.all(2),
                                  child: CacheImageLogoShop(
                                    url: item.icon,
                                  ),
                                  // CachedNetworkImage(imageUrl: item.icon),
                                ),
                                Text(
                                  "       ${item.title}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.ibmPlexSansThai(
                                      fontSize: 12,
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              if (item.ratingStar > 0)
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      color: Colors.yellow[50],
                                      border: Border.all(
                                          color: Colors.yellow, width: 0.5)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RatingBarIndicator(
                                        itemSize: 8,
                                        rating: 1,
                                        direction: Axis.horizontal,
                                        itemCount: 1,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        itemBuilder: (context, index) =>
                                            Image.asset(
                                          'assets/images/review/fullStar.png',
                                          color: Colors.amber,
                                        ),
                                      ),
                                      Text(
                                        myFormat.format(item.ratingStar),
                                        style: GoogleFonts.ibmPlexSansThai(
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              if (item.unitSales != "")
                                Text(
                                  item.unitSales,
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 10,
                                    color: Colors.grey.shade700,
                                  ),
                                )
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              item.discount > 0
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "฿${myFormat.format(item.price)}",
                                          style: GoogleFonts.ibmPlexSansThai(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.deepOrange.shade700),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "฿${myFormat.format(item.priceBeforeDiscount)}",
                                          style: GoogleFonts.ibmPlexSansThai(
                                              fontSize: 11,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey.shade700),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      "฿${myFormat.format(item.priceBeforeDiscount)}",
                                      style: GoogleFonts.ibmPlexSansThai(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange.shade700),
                                    ),
                            ],
                          ),
                        ],
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
  }
}
