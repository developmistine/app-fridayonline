import 'package:fridayonline/enduser/components/coupon/coupon.check.dart';
import 'package:fridayonline/enduser/controller/coupon.ctr.dart';
import 'package:fridayonline/enduser/services/coupon/coupon.services.dart';
import 'package:fridayonline/enduser/views/(cart)/cart.main.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fridayonline/enduser/models/cart/cart.update.input.dart'
    as update_input;

final CheckboxController controller = Get.put(CheckboxController());
final EndUserCouponCartCtr endUserCouponCtr = Get.find();

void storerCoupon(BuildContext context) {
  Get.bottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      Theme(
        data: Theme.of(context).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    textStyle: GoogleFonts.notoSansThaiLooped())),
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
            primaryTextTheme: GoogleFonts.notoSansThaiLoopedTextTheme()),
        child: SafeArea(
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 24, left: 12, right: 12, top: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'โค้ดส่วนลดของร้าน ${endUserCouponCtr.shopName.value}',
                                style: GoogleFonts.notoSansThaiLooped(
                                    fontWeight: FontWeight.w500),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey.shade700,
                                ),
                              )
                            ],
                          ),
                          const Divider(),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: Get.height / 3),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Container(
                                    width: Get.width,
                                    color: Colors.yellow.withOpacity(0.2),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
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
                                          style: GoogleFonts.notoSansThaiLooped(
                                              fontSize: 13),
                                        ),
                                      ],
                                    )),
                                const SizedBox(
                                  height: 12,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: EdgeInsets.zero,
                                  itemCount: endUserCouponCtr
                                      .shopVouchers.value!.length,
                                  itemBuilder: (context, index) {
                                    var shopVochers = endUserCouponCtr
                                        .shopVouchers.value![index];
                                    return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: CouponCardWithCheck(
                                            voucher: shopVochers,
                                            index: index,
                                            isCheckedProduct: true));
                                  },
                                ),
                                if (endUserCouponCtr
                                    .shopVouchers.value!.isEmpty)
                                  Center(
                                      child: Text(
                                    'ไม่พบโค้ดส่วนลดร้านค้า',
                                    style: GoogleFonts.notoSansThaiLooped(),
                                  )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(
                                  color: Colors.grey.shade700, width: 0.2))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: Get.width,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                                onPressed: null,
                                child: const Text(
                                  'ตกลง',
                                  style: TextStyle(),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
}

storerCouponSelected(BuildContext context) {
  TextEditingController textCtr = TextEditingController();
  String errorCoupon = "";
  return Get.bottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      Theme(
        data: Theme.of(context).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    textStyle: GoogleFonts.notoSansThaiLooped())),
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
            primaryTextTheme: GoogleFonts.notoSansThaiLoopedTextTheme()),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SafeArea(
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 24, left: 12, right: 12, top: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'โค้ดส่วนลดของร้าน ${endUserCouponCtr.shopName.value}',
                                  style: GoogleFonts.notoSansThaiLooped(
                                      fontWeight: FontWeight.w500),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.grey.shade700,
                                  ),
                                )
                              ],
                            ),
                            const Divider(),
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(minHeight: Get.height / 3),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 40,
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
                                                  color:
                                                      Colors.grey), // สีลายน้ำ
                                              filled:
                                                  true, // เปิดใช้งานพื้นหลัง
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
                                                color:
                                                    Colors.black), // สีข้อความ
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
                                              textCtr.text =
                                                  value.toUpperCase();
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
                                                        'shop')
                                                    .then((res) {
                                                  if (res!.code != '100') {
                                                    setState(() {
                                                      errorCoupon =
                                                          res.data.messageText;
                                                    });
                                                    return;
                                                  }
                                                  if (!endUserCouponCtr
                                                      .selectedCoupon
                                                      .containsKey(res
                                                          .data
                                                          .shopVoucher
                                                          .shopId)) {
                                                    endUserCouponCtr
                                                            .selectedCoupon[
                                                        res.data.shopVoucher
                                                            .shopId] = 0;
                                                  }
                                                  endUserCouponCtr
                                                          .couponShopId.value =
                                                      res.data.shopVoucher
                                                          .couponId;
                                                  endUserCouponCtr.promotionData
                                                      .shopVouchers
                                                      .add(update_input
                                                          .ShopVoucher(
                                                              shopId: res
                                                                  .data
                                                                  .shopVoucher
                                                                  .shopId,
                                                              unusedShopVoucher:
                                                                  false,
                                                              vouchers: [
                                                        res.data.shopVoucher
                                                            .couponId
                                                      ]));
                                                  for (var voucher
                                                      in endUserCouponCtr
                                                          .shopVouchers
                                                          .value!) {
                                                    voucher.userStatus
                                                        .isSelected = false;
                                                  }
                                                  controller.updateCart();
                                                  Get.back();
                                                });
                                              },
                                              child: const Text('ใช้โค้ด')),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (errorCoupon != "")
                                    Text(
                                      errorCoupon,
                                      style: GoogleFonts.notoSansThaiLooped(
                                          color: Colors.red, fontSize: 12),
                                    ).paddingOnly(top: 4),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: EdgeInsets.zero,
                                    itemCount: endUserCouponCtr
                                        .shopVouchers.value!.length,
                                    itemBuilder: (context, index) {
                                      var shopVochers = endUserCouponCtr
                                          .shopVouchers.value![index];
                                      return Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 8),
                                          child: CouponCardWithCheck(
                                              voucher: shopVochers,
                                              index: index,
                                              isCheckedProduct: true));
                                    },
                                  ),
                                  if (endUserCouponCtr
                                      .shopVouchers.value!.isEmpty)
                                    Center(
                                        child: Text(
                                      'ไม่พบโค้ดส่วนลดร้านค้า',
                                      style: GoogleFonts.notoSansThaiLooped(),
                                    )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                top: BorderSide(
                                    color: Colors.grey.shade700, width: 0.2))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Obx(() {
                              if (endUserCouponCtr.selectedCoupon[
                                          endUserCouponCtr.shopId.value] !=
                                      -1 &&
                                  endUserCouponCtr.selectedCoupon[
                                          endUserCouponCtr.shopId.value] !=
                                      null) {
                                return Row(
                                  children: [
                                    Text(
                                      'เลือกโค้ดแล้ว 1 โค้ด',
                                      style: GoogleFonts.notoSansThaiLooped(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                            SizedBox(
                              width: Get.width,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: theme_color_df,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4))),
                                  onPressed: () {
                                    controller.updateCart();
                                    Get.back();
                                  },
                                  child: const Text('ตกลง')),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ));
}
