import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.apply.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.header.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.menu.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.slide.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:fridayonline/safearea.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final productData = [
  {
    "total": 315,
    "products": [
      {
        "icon":
            "https://ct.fridayth.com/b2c/seller/000021/logo20250725143715_0.jpg",
        "product_id": 10353,
        "title": "FOOT FIX HEEL CR.50G ครีมบำรุงส้นเท้าแตกฟุตฟิกซ์ 50กรัม",
        "discount": 0,
        "price": 0,
        "price_before_discount": 69,
        "labels": [],
        "rating_star": 5,
        "have_video": true,
        "unit_sales": "ขายได้ 17 ชิ้น",
        "image":
            "https://ct.fridayth.com/b2c/product/000021/40970/img/20250509160359_1.webp",
        "currency": "",
        "is_image_overlayed": true,
        "image_overlay": "https://ct.fridayth.com/b2c/file/frame1.png",
        "is_out_of_stock": false
      },
      {
        "icon":
            "https://ct.fridayth.com/b2c/seller/000021/logo20250725143715_0.jpg",
        "product_id": 10398,
        "title": "HERBAL TOOTHBRUSH แปรงสีฟัน เฮอร์บัล 14 กรัม",
        "discount": 0,
        "price": 0,
        "price_before_discount": 39,
        "labels": [],
        "rating_star": 0,
        "have_video": true,
        "unit_sales": "ขายได้ 13 ชิ้น",
        "image":
            "https://ct.fridayth.com/b2c/product/000021/41014/img/20250509160404_1.webp",
        "currency": "",
        "is_image_overlayed": true,
        "image_overlay": "https://ct.fridayth.com/b2c/file/frame1.png",
        "is_out_of_stock": false
      },
      {
        "icon":
            "https://ct.fridayth.com/b2c/seller/000021/logo20250725143715_0.jpg",
        "product_id": 13466,
        "title":
            "DALAR LALA OIL LIQUID CUSHION SPF 50 PA+++ 7G.  ดาลาร์ ลาลา ออยล์ ลิควิด คุชชั่น เอสพีเอฟ 50 พีเอ +++ 7 กรัม ",
        "discount": 0,
        "price": 0,
        "price_before_discount": 69,
        "labels": [],
        "rating_star": 0,
        "have_video": true,
        "unit_sales": "ขายได้ 12 ชิ้น",
        "image":
            "https://ct.fridayth.com/b2c/product/000021/45159/img/20250516182553_1.webp",
        "currency": "",
        "is_image_overlayed": true,
        "image_overlay": "https://ct.fridayth.com/b2c/file/frame1.png",
        "is_out_of_stock": false
      },
      {
        "icon":
            "https://ct.fridayth.com/b2c/seller/000021/logo20250725143715_0.jpg",
        "product_id": 13442,
        "title":
            "MISTINE  VISIO EYEBROW MASCARA  2G. มิสทิน วิซิโอ  อายบราว มาสคาร่า",
        "discount": 0,
        "price": 0,
        "price_before_discount": 119,
        "labels": [],
        "rating_star": 0,
        "have_video": true,
        "unit_sales": "ขายได้ 10 ชิ้น",
        "image":
            "https://ct.fridayth.com/b2c/product/000021/45104/img/20250516182541_1.webp",
        "currency": "",
        "is_image_overlayed": true,
        "image_overlay": "https://ct.fridayth.com/b2c/file/frame1.png",
        "is_out_of_stock": false
      },
      {
        "icon":
            "https://ct.fridayth.com/b2c/seller/000021/logo20250725143715_0.jpg",
        "product_id": 13446,
        "title":
            "VENUS FOREVER PERFECT SUPER POWDER SPF25 PA++  10G วีนัส ฟอร์เอเวอร์  เพอร์เฟค ซุปเปอร์ เพาเดอร์ เอสพีเอฟ 25 พีเอ++  10 ก.",
        "discount": 0,
        "price": 0,
        "price_before_discount": 229,
        "labels": [],
        "rating_star": 0,
        "have_video": true,
        "unit_sales": "ขายได้ 10 ชิ้น",
        "image":
            "https://ct.fridayth.com/b2c/product/000021/45113/img/20250516182543_1.webp",
        "currency": "",
        "is_image_overlayed": true,
        "image_overlay": "https://ct.fridayth.com/b2c/file/frame1.png",
        "is_out_of_stock": false
      },
      {
        "icon":
            "https://ct.fridayth.com/b2c/seller/000021/logo20250725143715_0.jpg",
        "product_id": 12536,
        "title":
            "SNOW FROZEN WHITENING SUNSCEEN FACIAL CREAM SPF 50 PA++++  30ML. มิสทิน สโนว์ โฟรเซ่น ไวท์เทนนิ่ง ซันสกรีน เฟเชียล ครีม เอสพีเอฟ 50 พีเอ++++  30ml.",
        "discount": 0,
        "price": 0,
        "price_before_discount": 199,
        "labels": [],
        "rating_star": 0,
        "have_video": true,
        "unit_sales": "ขายได้ 10 ชิ้น",
        "image":
            "https://ct.fridayth.com/b2c/product/000021/43185/img/20250509181233_1.webp",
        "currency": "",
        "is_image_overlayed": true,
        "image_overlay": "https://ct.fridayth.com/b2c/file/frame1.png",
        "is_out_of_stock": false
      },
      {
        "icon":
            "https://ct.fridayth.com/b2c/seller/000021/logo20250725143715_0.jpg",
        "product_id": 10332,
        "title":
            "NATURAL FUK KAO SHOWER 200ML ครีมอาบน้ำเนเชอรัล ฟักข้าว 200 มล.",
        "discount": 0,
        "price": 0,
        "price_before_discount": 89,
        "labels": [],
        "rating_star": 0,
        "have_video": true,
        "unit_sales": "ขายได้ 8 ชิ้น",
        "image":
            "https://ct.fridayth.com/b2c/product/000021/40949/img/20250509160355_1.webp",
        "currency": "",
        "is_image_overlayed": true,
        "image_overlay": "https://ct.fridayth.com/b2c/file/frame1.png",
        "is_out_of_stock": false
      },
      {
        "icon":
            "https://ct.fridayth.com/b2c/seller/000021/logo20250725143715_0.jpg",
        "product_id": 13430,
        "title": "PURE ROSE BLUSH ON  เพียวโรสบลัชออน ",
        "discount": 0,
        "price": 0,
        "price_before_discount": 149,
        "labels": [],
        "rating_star": 0,
        "have_video": true,
        "unit_sales": "ขายได้ 7 ชิ้น",
        "image":
            "https://ct.fridayth.com/b2c/product/000021/45064/img/20250516182532_1.webp",
        "currency": "",
        "is_image_overlayed": true,
        "image_overlay": "https://ct.fridayth.com/b2c/file/frame1.png",
        "is_out_of_stock": false
      },
      {
        "icon":
            "https://ct.fridayth.com/b2c/seller/000021/logo20250725143715_0.jpg",
        "product_id": 13390,
        "title": "MISTINE EYE BRUSH มิสทิน อาย บรัช",
        "discount": 0,
        "price": 0,
        "price_before_discount": 69,
        "labels": [],
        "rating_star": 0,
        "have_video": true,
        "unit_sales": "ขายได้ 6 ชิ้น",
        "image":
            "https://ct.fridayth.com/b2c/product/000021/45015/img/20250516182524_1.webp",
        "currency": "",
        "is_image_overlayed": true,
        "image_overlay": "https://ct.fridayth.com/b2c/file/frame1.png",
        "is_out_of_stock": false
      },
    ]
  }
];

class AffiliateUser extends StatefulWidget {
  const AffiliateUser({super.key});

  @override
  State<AffiliateUser> createState() => _AffiliateUserState();
}

class _AffiliateUserState extends State<AffiliateUser> {
  final affAccountCtl = Get.find<AffiliateAccountCtr>();

  @override
  void initState() {
    super.initState();
    affAccountCtl.checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items =
        ((productData[0]['products'] as List?) ?? [])
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

    return SafeAreaProvider(child: Obx(() {
      if (affAccountCtl.isCheckingStatus.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      final status = affAccountCtl.validStatus.value;
      final statusMsg = affAccountCtl.validStatusMsg.value;
      final isNotApplied = status == 'not_applied';
      final isPending = status == 'pending';
      // final isRejected = status == 'rejected';
      final isApproved = status == 'approved';

      return Scaffold(
        backgroundColor: isApproved
            ? const Color.fromARGB(255, 244, 244, 244)
            : Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(spacing: 6, children: [
            UserHeader(),
            SafeArea(
                top: false,
                child: isNotApplied
                    ? Column(children: [
                        UserSlides(),
                        UserApply(),
                      ])
                    : isApproved
                        ? Column(
                            children: [
                              UserMenu(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: buildProductSection(items),
                              )
                            ],
                          )
                        : Container(
                            height: 400,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 12,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Image.asset(
                                    isPending
                                        ? 'assets/images/affiliate/register_pending.png'
                                        : 'assets/images/affiliate/register_rejected.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      isPending
                                          ? 'อยู่ระหว่างการตรวจสอบ'
                                          : 'ไม่ผ่านการตรวจสอบ',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.ibmPlexSansThai(
                                        color: const Color(0xFF1F1F1F),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      statusMsg,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.ibmPlexSansThai(
                                        color: const Color(0xFF5A5A5A),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))
          ]),
        ),
      );
    }));
  }
}
