import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop/shop.category.add.dart';
import 'package:fridayonline/member/components/showproduct/nodata.dart';
import 'package:fridayonline/member/components/utils/share.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop/shop.content.add.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/product.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart';

import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopShowCategory extends StatefulWidget {
  final int contentId;
  final String _catName;
  final List<AffiliateProduct> products;

  const ShopShowCategory(this.contentId, this._catName, this.products,
      {super.key});

  @override
  State<ShopShowCategory> createState() => _ShopShowCategoryState();
}

class _ShopShowCategoryState extends State<ShopShowCategory> {
  late int _contentId;
  late String _catName;
  late List<AffiliateProduct> _products;

  @override
  void initState() {
    super.initState();
    _contentId = widget.contentId;
    _catName = widget._catName;
    _products = List<AffiliateProduct>.from(widget.products);
  }

  @override
  Widget build(BuildContext context) {
    final int total = _products.length;
    final affAccountCtl = Get.find<AffiliateAccountCtr>();

    _products = _products.where((p) => p.status != 'hide').toList();

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
          affAccountCtl.profileData.value?.storeName ?? 'หมวดหมู่สินค้า',
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF1F1F1F),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Row(
            spacing: 10,
            children: [
              // Expanded(
              //   child: OutlinedButton(
              //     onPressed: () async {
              //       final ret = await Get.to(
              //           () => ShopAddCategory(contentId: _contentId));
              //       if (!mounted) return;
              //       if (ret != null) {
              //         setState(() {
              //           final cid = ret['contentId'];
              //           final name = ret['catName'];
              //           final prods = ret['products'];

              //           if (cid is int) _contentId = cid;
              //           if (name is String) _catName = name;
              //           if (prods is List<AffiliateProduct>) {
              //             _products = List<AffiliateProduct>.from(prods);
              //           }
              //         });
              //       }
              //     },
              //     style: OutlinedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(vertical: 10),
              //       side: BorderSide(color: themeColorDefault),
              //       foregroundColor: themeColorDefault,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     child: const Text(
              //       'แก้ไข',
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              //     ),
              //   ),
              // ),
              if (_products.isNotEmpty)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await shareDialog(
                        shareType: 'category',
                        categoryId: _contentId,
                        shareTitle: 'แชร์หมวดหมู่สินค้า',
                      );
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
                  _catName,
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

            if (_products.isEmpty)
              SizedBox(
                height: 400,
                child: Center(
                  child: nodata(context),
                ),
              ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.62,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final p = _products[index];

                return productItem(
                  product: p,
                  onTap: () {
                    Get.find<ShowProductSkuCtr>()
                        .fetchB2cProductDetail(p.productId, 'shop_content');
                    // setPauseVideo();
                    Get.toNamed(
                      '/ShowProductSku/${p.productId}',
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
