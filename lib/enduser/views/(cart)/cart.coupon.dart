import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/components/coupon/coupon.check.dart';
import 'package:fridayonline/enduser/controller/cart.ctr.dart';
import 'package:fridayonline/enduser/controller/coupon.ctr.dart';
import 'package:fridayonline/enduser/models/coupon/vouchers.platform.model.dart';
import 'package:fridayonline/enduser/models/coupon/vouchers.shopcode.model.dart';
import 'package:fridayonline/enduser/services/coupon/coupon.services.dart';
import 'package:fridayonline/enduser/views/(cart)/cart.main.dart';
import 'package:fridayonline/enduser/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:google_fonts/google_fonts.dart';

class EndUserCartCoupon extends StatefulWidget {
  const EndUserCartCoupon({super.key});

  @override
  State<EndUserCartCoupon> createState() => _EndUserCartCouponState();
}

class _EndUserCartCouponState extends State<EndUserCartCoupon> {
  final EndUserCouponCartCtr endUserCouponCtr = Get.find();

  final EndUserCartCtr cartCtr = Get.find();

  final CheckboxController productCheckedCtr = Get.find();

  final TextEditingController textCtr = TextEditingController();

  String errorCoupon = "";

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Theme(
          data: Theme.of(context).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle: GoogleFonts.notoSansThaiLooped())),
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: appBarMasterEndUser('เลือกคูปองส่วนลด Friday'),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Obx(() {
                    return productCheckedCtr.seleletedProuduct.isEmpty
                        ? const NoSelectedProduct()
                        : Container(
                            width: Get.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              // border: Border(
                              //     bottom: BorderSide(
                              //         color: Colors.grey[300]!, width: 1))
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  height: 55,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: textCtr,
                                          decoration: const InputDecoration(
                                            hintText:
                                                'เพิ่มโค้ดส่วนลดร้านค้า', // ลายน้ำ
                                            hintStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey), // สีลายน้ำ
                                            filled: true, // เปิดใช้งานพื้นหลัง
                                            fillColor: Colors
                                                .white, // พื้นหลังสีเทาอ่อน
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.2), // มุมโค้ง
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width:
                                                      0.2), // ขอบสีเทาเข้มเมื่อ active
                                            ),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.2)),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal:
                                                        16.0), // ระยะห่างภายใน
                                          ),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black), // สีข้อความ
                                          cursorColor:
                                              Colors.grey, // สีของ Cursor
                                          textInputAction: TextInputAction
                                              .done, // ปุ่ม Done บนคีย์บอร์ด
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    '[a-zA-Z0-9]')), // กรองเฉพาะภาษาอังกฤษและตัวเลข
                                          ],
                                          onChanged: (value) {
                                            textCtr.text = value.toUpperCase();
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      SizedBox(
                                        height: 40,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                            ),
                                            onPressed: () async {
                                              if (textCtr.text == "") {
                                                return;
                                              }
                                              await getCodeService(
                                                      endUserCouponCtr
                                                          .shopId.value,
                                                      textCtr.text,
                                                      'platform')
                                                  .then((res) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                if (res!.code != '100') {
                                                  errorCoupon =
                                                      res.data.messageText;
                                                  return;
                                                }
                                                setPlatformCode(res);
                                                Get.back();
                                              });
                                            },
                                            child: const Text('ใช้โค้ด')),
                                      )
                                    ],
                                  ),
                                ),
                                if (errorCoupon != "")
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      errorCoupon,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.notoSansThaiLooped(
                                          fontSize: 12, color: Colors.red),
                                    ),
                                  ),
                                if (cartCtr.voucherRecommend.value != null &&
                                    cartCtr.voucherRecommend.value!.isNotEmpty)
                                  const Gap(height: 8),
                                if (cartCtr.voucherRecommend.value != null &&
                                    cartCtr.voucherRecommend.value!.isNotEmpty)
                                  ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        cartCtr.voucherRecommend.value!.length,
                                    itemBuilder: (context, index) {
                                      var voucher = cartCtr
                                          .voucherRecommend.value![index];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            voucher.voucherTypeText,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: voucher.vouchers.length,
                                            itemBuilder: (context, subIndex) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child:
                                                    CouponCardPlatformWithCheck(
                                                        voucher: voucher
                                                            .vouchers[subIndex],
                                                        index: index,
                                                        isCheckedProduct: true),
                                              );
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  )
                                else
                                  const Center(
                                    heightFactor: 15,
                                    child: Text('ไม่พบข้อมูล'),
                                  ),
                              ],
                            ),
                          );
                  }),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 0.5, color: Colors.grey[300]!),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() {
                        return endUserCouponCtr.couponPlatformId.value != 0
                            ? const Text(
                                'เลือกโค้ดแล้ว 1 โค้ด',
                                style: TextStyle(fontSize: 12),
                              )
                            : const SizedBox();
                      }),
                      SizedBox(
                        width: Get.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: theme_color_df,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ))),
                          onPressed: () {
                            if (endUserCouponCtr.couponPlatformId.value == 0) {
                              Get.back(result: null);
                            } else {
                              Get.back(
                                  result:
                                      endUserCouponCtr.couponPlatformId.value);
                            }
                          },
                          child: const Text(
                            'ตกลง',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  setPlatformCode(VouchersShopCode res) {
    endUserCouponCtr.promotionData.platformVouchers.clear();

    endUserCouponCtr.promotionData.platformVouchers
        .add(res.data.shopVoucher.couponId);
    endUserCouponCtr.promotionData.unusedPlatformVoucher = false;
    endUserCouponCtr.couponPlatformId.value = res.data.shopVoucher.couponId;
  }
}

class NoSelectedProduct extends StatelessWidget {
  const NoSelectedProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: Get.width,
            color: Colors.yellow.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 4,
                ),
                const Icon(
                  Icons.info,
                  color: Colors.amber,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'กรุณาเลือกสินค้าในตะกร้าที่ต้องการใช้งานโค้ดส่วนลด',
                  style: GoogleFonts.notoSansThaiLooped(fontSize: 13),
                ),
              ],
            )),
        FutureBuilder(
          future: fetchPlatFormVoucherRecommend(),
          builder: (BuildContext context,
              AsyncSnapshot<PlatformRecommend?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            } else if (snapshot.hasData) {
              PlatformRecommend? coupon = snapshot.data;
              if (coupon!.data.isEmpty) {
                return const Center(
                  heightFactor: 15,
                  child: Text('ไม่พบข้อมูล'),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: coupon.data.length,
                itemBuilder: (context, index) {
                  var voucher = coupon.data[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voucher.voucherTypeText,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: voucher.vouchers.length,
                        itemBuilder: (context, subIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CouponCardPlatformWithCheck(
                                voucher: voucher.vouchers[subIndex],
                                index: index,
                                isCheckedProduct: true),
                          );
                        },
                      )
                    ],
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
