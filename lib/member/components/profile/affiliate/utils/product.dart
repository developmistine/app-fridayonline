import 'package:flutter/material.dart';
import 'package:fridayonline/member/models/home/home.content.model.dart';
import 'package:fridayonline/member/utils/cached_image.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductItems extends StatelessWidget {
  final ProductContent product;
  final VoidCallback? onTap;

  const ProductItems({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          onTap: onTap,
          child: Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(width: 0.2, color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration:
                              BoxDecoration(color: Colors.grey.shade100),
                          alignment: Alignment.center,
                          child: CacheImageProducts(
                            url: product.image,
                          ),
                        ),
                        if (product.isImageOverlayed)
                          IgnorePointer(
                            child: SizedBox(
                              width: double.infinity,
                              child:
                                  CacheImageOverlay(url: product.imageOverlay),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ibmPlexSansThai(
                              color: Colors.black87,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        if (product.discount > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            spacing: 4,
                            children: [
                              Text(
                                '฿${myFormat.format(product.price)}',
                                style: TextStyle(
                                  color: Colors.deepOrange.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '฿${myFormat.format(product.priceBeforeDiscount)}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 11,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                color: Colors.red.shade50,
                                child: Text(
                                  '-${myFormat.format(product.discount)}%',
                                  style: GoogleFonts.ibmPlexSansThai(
                                    color: Colors.deepOrange,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            '฿${myFormat.format(product.priceBeforeDiscount)}',
                            style: TextStyle(
                              color: Colors.deepOrange.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (product.isOutOfStock)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: SizedBox(
                width: 55,
                height: 55,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Center(
                    child: Text(
                      'สินค้าหมด',
                      style: GoogleFonts.ibmPlexSansThai(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
