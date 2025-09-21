import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.content.add.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/product.dart';
import 'package:fridayonline/member/models/home/home.content.model.dart';

import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopShowCategory extends StatefulWidget {
  final String catName;
  final List products;

  const ShopShowCategory(this.catName, this.products, {super.key});

  @override
  State<ShopShowCategory> createState() => _ShopShowCategoryState();
}

class _ShopShowCategoryState extends State<ShopShowCategory> {
  @override
  Widget build(BuildContext context) {
    final String catName = widget.catName;
    final List products = widget.products;
    final int total = products.length;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: themeColorDefault,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
        title: Text(
          'รวมของน่าซื้อ By คุณนัท',
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF1F1F1F),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: ไปหน้าแก้ไข (ปุ่มซ้าย)
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(color: themeColorDefault),
                    foregroundColor: themeColorDefault,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'แก้ไข',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: ไปหน้าแก้ไข (ปุ่มขวา)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColorDefault,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      SvgPicture.asset(
                        'assets/images/affiliate/share.svg',
                        width: 20,
                        height: 20,
                      ),
                      Text(
                        'แชร์หมวดหมู่',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            // หัวข้อ
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  catName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const FieldLabel(title: 'รายการสินค้า'),
                    FieldLabel(title: '$total รายการ'), // << ไม่มี ; ตรงนี้
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.72, // ปรับสัดส่วนตามดีไซน์
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                final product = ProductContent.fromJson(p);

                return productItem(product: product);
              },
            ),
          ],
        ),
      ),
    );
  }
}
