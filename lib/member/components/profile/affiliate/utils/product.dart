import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fridayonline/member/components/utils/share.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart';
import 'package:fridayonline/member/utils/cached_image.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:google_fonts/google_fonts.dart';

Widget productItem({
  required AffiliateProduct product,
  VoidCallback? onTap,
  bool? showShare = true,
}) {
  final isHide = product.status == 'hide';

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
            side: const BorderSide(
              width: 0.2,
              color: Color.fromARGB(255, 179, 179, 179),
            ),
          ),
          child: Stack(
            children: [
              Padding(
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
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            alignment: Alignment.center,
                            child: CacheImageProducts(url: product.image),
                          ),
                          if (product.isImageOverlayed)
                            const IgnorePointer(
                              child: SizedBox(
                                width: double.infinity,
                                // ถ้า imageOverlay อาจเป็น null ให้ใส่ค่า default ตามเหมาะสม
                                child: CacheImageOverlay(url: ''),
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
                            height: 34,
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
                          Row(
                            children: [
                              if (product.ratingStar > 0)
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
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
                                        myFormat.format(product.ratingStar),
                                        style: GoogleFonts.ibmPlexSansThai(
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                SizedBox(
                                  height: 16,
                                ),
                              if (product.unitSales != "")
                                Text(
                                  product.unitSales,
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 10,
                                    color: Colors.grey.shade700,
                                  ),
                                )
                            ],
                          ),
                          if (product.discount > 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              spacing: 3,
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
                                )
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
                          Text(
                            product.commission,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ibmPlexSansThai(
                              color: Colors.deepOrange.shade700,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (showShare == true)
                Positioned(
                  right: 14,
                  bottom: 14,
                  child: InkWell(
                    onTap: () {
                      shareDialog(
                          shareType: 'product',
                          shareTitle: 'แชร์เพื่อรับค่าคอมมิชชั่นนี้',
                          product: ShareProduct(
                            productId: product.productId,
                            title: product.title,
                            image: product.image,
                            discount: product.discount,
                            price: product.price,
                            priceBfDiscount: product.priceBeforeDiscount,
                            commission: product.commission,
                          ));
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF00AEEF) /* New-CI-Band-Sky */,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(56.39),
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/affiliate/share.svg',
                        width: 22,
                        package: null,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
      if (isHide) ...[
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Positioned(
            top: 10,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  'ซ่อน',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            )),
      ],
      if (product.isOutOfStock)
        const Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: SizedBox(
              width: 68,
              height: 68,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: Center(
                  child: Text(
                    'สินค้าหมด',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
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

Widget productItemList({
  required AffiliateProduct product,
  VoidCallback? onTap,
}) {
  final isHide = product.status == 'hide';
  return Stack(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          // รูปสินค้า
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Image.network(product.image,
                    width: 60, height: 60, fit: BoxFit.cover),
                if (product.isOutOfStock)
                  const Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: SizedBox(
                        width: 38,
                        height: 38,
                        child: CircleAvatar(
                          backgroundColor: Colors.black45,
                          child: Center(
                            child: Text(
                              'หมด',
                              style: TextStyle(
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
                if (isHide)
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .28),
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ชื่อ + ราคา
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                if (product.discount > 0 && product.price > 0)
                  Row(
                    spacing: 6,
                    children: [
                      Text(
                        '฿${myFormat.format(product.price)}',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '฿${myFormat.format(product.priceBeforeDiscount)}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    '฿${myFormat.format(product.priceBeforeDiscount)}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                Text(
                  product.commission,
                  style: TextStyle(
                    color: Colors.deepOrange.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      if (isHide) ...[
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .62),
                  borderRadius: BorderRadius.circular(999),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: .18)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/affiliate/cardmenu/eye_off.svg',
                      width: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ซ่อนอยู่',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ],
  );
}
