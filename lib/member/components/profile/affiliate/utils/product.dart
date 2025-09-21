import 'package:flutter/material.dart';
import 'package:fridayonline/member/models/home/home.content.model.dart';
import 'package:fridayonline/member/utils/cached_image.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:google_fonts/google_fonts.dart';

Widget productItem({
  required ProductContent product,
  VoidCallback? onTap,
}) {
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
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ถ้าโปรเจ็กต์ไม่ได้มี extension Column.spacing ให้ลบบรรทัดนี้
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      if (product.isOutOfStock)
        const Positioned(
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      // ถ้าอยากใช้ GoogleFonts ให้เปลี่ยนเป็น GoogleFonts.ibmPlexSansThai(...)
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
  required ProductContent product,
  VoidCallback? onTap,
}) {
  return Row(
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
              'ค่าคอมมิชชั่น 12.5 %',
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
  );
}
