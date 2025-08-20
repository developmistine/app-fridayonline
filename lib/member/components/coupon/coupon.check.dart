import 'dart:ui';

import 'package:fridayonline/member/controller/coupon.ctr.dart';
import 'package:fridayonline/member/services/coupon/coupon.services.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(coupon)/coupon.detail.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:fridayonline/member/models/cart/cart.update.input.dart'
    as update_input;

final endUserCouponCtr = Get.find<EndUserCouponCartCtr>();

class CouponCardWithCheck extends StatelessWidget {
  final dynamic voucher;
  final int index;
  final bool isCheckedProduct;

  const CouponCardWithCheck({
    super.key,
    required this.voucher,
    required this.index,
    required this.isCheckedProduct,
  });
  // canUse

  @override
  Widget build(BuildContext context) {
    if (!isCheckedProduct) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey.shade300)),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.grey.shade200,
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.network(
                    voucher.image.trim(),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.local_activity_rounded);
                    },
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      color: Colors.white.withOpacity(0.5), // สีขาวโปร่งแสง 50%
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            voucher.title,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ขั้นต่ำ ฿${myFormat.format(voucher.rewardInfo.minSpend)}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          if (voucher.quotaInfo.percentageUsed.toDouble() > 50)
                            LinearPercentIndicator(
                              padding: const EdgeInsets.only(right: 40),
                              alignment: MainAxisAlignment.center,
                              animation: true,
                              lineHeight: 4.0,
                              animationDuration: 1500,
                              percent: (voucher.quotaInfo.percentageUsed
                                      .toDouble()) /
                                  100,
                              backgroundColor: Colors.grey.shade200,
                              linearGradient: const LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment(0.8, 1),
                                tileMode: TileMode.mirror,
                                colors: <Color>[
                                  Color.fromARGB(255, 228, 40, 7),
                                  Color.fromARGB(255, 239, 161, 36),
                                ],
                              ),
                              barRadius: const Radius.circular(10),
                            ),
                        ],
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: Container(
                            color: Colors.white
                                .withOpacity(0.5), // สีขาวโปร่งแสง 50%
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        voucher.timeInfo.timeFormat,
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          Get.to(
                              () => CouponDetail(couponId: voucher.couponId));
                        },
                        child: Text(
                          'เงื่อนไข',
                          style: TextStyle(
                            fontSize: 10,
                            color: themeColorDefault,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey.shade600)),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      color: Colors.white.withOpacity(0.5), // สีขาวโปร่งแสง 50%
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
          ],
        ),
      );
    } else if (!voucher.canUse) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey.shade300)),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.grey.shade200,
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.network(
                    voucher.image.trim(),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.local_activity_rounded);
                    },
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      color: Colors.white.withOpacity(0.5), // สีขาวโปร่งแสง 50%
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            voucher.title,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ขั้นต่ำ ฿${myFormat.format(voucher.rewardInfo.minSpend)}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          if (voucher.quotaInfo.percentageUsed.toDouble() > 50)
                            LinearPercentIndicator(
                              padding: const EdgeInsets.only(right: 40),
                              alignment: MainAxisAlignment.center,
                              animation: true,
                              lineHeight: 4.0,
                              animationDuration: 1500,
                              percent: (voucher.quotaInfo.percentageUsed
                                      .toDouble()) /
                                  100,
                              backgroundColor: Colors.grey.shade200,
                              linearGradient: const LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment(0.8, 1),
                                tileMode: TileMode.mirror,
                                colors: <Color>[
                                  Color.fromARGB(255, 228, 40, 7),
                                  Color.fromARGB(255, 239, 161, 36),
                                ],
                              ),
                              barRadius: const Radius.circular(10),
                            ),
                        ],
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: Container(
                            color: Colors.white
                                .withOpacity(0.5), // สีขาวโปร่งแสง 50%
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        voucher.timeInfo.timeFormat,
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          Get.to(
                              () => CouponDetail(couponId: voucher.couponId));
                        },
                        child: Text(
                          'เงื่อนไข',
                          style: TextStyle(
                            fontSize: 10,
                            color: themeColorDefault,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Obx(() {
              if (!endUserCouponCtr
                  .shopVouchers.value![index].userStatus.isClaimed) {
                return InkWell(
                  onTap: () async {
                    var res = await addVoucherItemsService(voucher.couponId);
                    if (res.code == '100') {
                      if (endUserCouponCtr.selectedCoupon[voucher.shopId] ==
                          index) {
                        endUserCouponCtr.selectedCoupon[voucher.shopId] = -1;
                      } else {
                        endUserCouponCtr.selectedCoupon[voucher.shopId] = index;
                      }
                      endUserCouponCtr.shopVouchers.value![index].userStatus
                          .isClaimed = true;
                      endUserCouponCtr.shopVouchers.refresh();
                      endUserCouponCtr.setshowClaimedCoupon();
                    } else {
                      if (!Get.isDialogOpen!) {
                        dialogAlert([
                          Text(
                            res.message,
                            style: GoogleFonts.ibmPlexSansThai(
                                color: Colors.white, fontSize: 12),
                          )
                        ]);
                        Future.delayed(const Duration(seconds: 1), () {
                          Get.back();
                          Get.back();
                        });
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: themeColorDefault,
                        borderRadius: BorderRadius.circular(4)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: const Text(
                      'เก็บ',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                );
              }

              return Obx(() {
                if (endUserCouponCtr.showClaimedCoupon.value &&
                    endUserCouponCtr.selectedCoupon[voucher.shopId] == index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(left: 4),
                      ),
                      Positioned(
                        top: -18,
                        right: -12,
                        child: Lottie.asset(
                            width: 50,
                            height: 50,
                            'assets/images/lottie/checked.json'),
                      )
                    ],
                  );
                }
                return Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey.shade500)),
                );
              });
            }),
            const SizedBox(width: 12),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        endUserCouponCtr.promotionData.shopVouchers =
            endUserCouponCtr.promotionDataCheckOut.shopVouchers;
        // printWhite(jsonEncode(endUserCouponCtr.promotionData.shopVouchers));
        // เช็คว่าร้านนี้มีคูปองที่เลือกไว้หรือไม่
        if (!endUserCouponCtr.selectedCoupon.containsKey(voucher.shopId) ||
            endUserCouponCtr.selectedCoupon[voucher.shopId] == null) {
          // ถ้าไม่มีคูปองที่เลือกไว้ ให้เลือกคูปองนี้
          endUserCouponCtr.selectedCoupon[voucher.shopId] = index;
          endUserCouponCtr.couponShopId.value = voucher.shopId;

          endUserCouponCtr.promotionData.shopVouchers
              .removeWhere((element) => element.shopId == voucher.shopId);
          endUserCouponCtr.promotionData.shopVouchers.add(
              update_input.ShopVoucher(
                  shopId: voucher.shopId,
                  unusedShopVoucher: true,
                  vouchers: [voucher.couponId]));

          for (var coupon in endUserCouponCtr.promotionData.shopVouchers) {
            if (coupon.shopId == voucher.shopId) {
              coupon.unusedShopVoucher = false;
              coupon.vouchers = [voucher.couponId];
              break; // เพิ่ม break เพื่อหยุด loop เมื่อเจอแล้ว
            }
          }
        } else {
          // ถ้ามีคูปองที่เลือกไว้แล้ว
          if (endUserCouponCtr.selectedCoupon[voucher.shopId] == index) {
            // ถ้าคลิกคูปองเดิมที่เลือกไว้ ให้ยกเลิกการเลือก
            endUserCouponCtr.selectedCoupon[voucher.shopId] = -1;
            endUserCouponCtr.couponShopId.value = 0;
            endUserCouponCtr.promotionData.shopVouchers
                .removeWhere((element) => element.shopId == voucher.shopId);
            endUserCouponCtr.promotionData.shopVouchers.add(
                update_input.ShopVoucher(
                    shopId: voucher.shopId,
                    unusedShopVoucher: true,
                    vouchers: [voucher.couponId]));

            for (var coupon in endUserCouponCtr.promotionData.shopVouchers) {
              if (coupon.shopId == voucher.shopId) {
                coupon.unusedShopVoucher = true;
                coupon.vouchers = [voucher.couponId];
                break;
              }
            }
          } else {
            // ถ้าคลิกคูปองใหม่ ให้เปลี่ยนการเลือก
            endUserCouponCtr.selectedCoupon[voucher.shopId] = index;
            endUserCouponCtr.couponShopId.value = voucher.shopId;
            endUserCouponCtr.promotionData.shopVouchers
                .removeWhere((element) => element.shopId == voucher.shopId);
            endUserCouponCtr.promotionData.shopVouchers.add(
                update_input.ShopVoucher(
                    shopId: voucher.shopId,
                    unusedShopVoucher: true,
                    vouchers: [voucher.couponId]));

            for (var coupon in endUserCouponCtr.promotionData.shopVouchers) {
              if (coupon.shopId == voucher.shopId) {
                coupon.unusedShopVoucher = false;
                coupon.vouchers = [voucher.couponId];
                break;
              }
            }
          }
        }
        // printWhite(jsonEncode(endUserCouponCtr.promotionData.shopVouchers));
        for (var voucher in endUserCouponCtr.shopVouchers.value!) {
          voucher.userStatus.isSelected = false;
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey.shade300)),
        child: Row(
          children: [
            Container(
              color: Colors.grey.shade200,
              width: 90,
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Image.network(
                voucher.image.trim(),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.local_activity_rounded);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            voucher.title,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ขั้นต่ำ ฿${myFormat.format(voucher.rewardInfo.minSpend)}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          if (voucher.quotaInfo.percentageUsed.toDouble() > 50)
                            LinearPercentIndicator(
                              padding: const EdgeInsets.only(right: 40),
                              alignment: MainAxisAlignment.center,
                              animation: true,
                              lineHeight: 4.0,
                              animationDuration: 1500,
                              percent:
                                  (voucher.quotaInfo.percentageUsed.toDouble() +
                                          60) /
                                      100,
                              backgroundColor: Colors.grey.shade200,
                              linearGradient: const LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment(0.8, 1),
                                tileMode: TileMode.mirror,
                                colors: <Color>[
                                  Color.fromARGB(255, 228, 40, 7),
                                  Color.fromARGB(255, 239, 161, 36),
                                ],
                              ),
                              barRadius: const Radius.circular(10),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        voucher.timeInfo.timeFormat,
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          Get.to(
                              () => CouponDetail(couponId: voucher.couponId));
                        },
                        child: Text(
                          'เงื่อนไข',
                          style: TextStyle(
                            fontSize: 10,
                            color: themeColorDefault,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Obx(() {
              if (endUserCouponCtr.selectedCoupon[voucher.shopId] == index ||
                  (voucher.userStatus.isSelected &&
                      (!endUserCouponCtr.selectedCoupon
                          .containsKey(voucher.shopId)))) {
                return Icon(
                  Icons.check_circle,
                  color: themeColorDefault,
                );
              } else if (!endUserCouponCtr
                  .shopVouchers.value![index].userStatus.isClaimed) {
                return InkWell(
                  onTap: () async {
                    var res = await addVoucherItemsService(voucher.couponId);
                    if (res.code == '100') {
                      if (endUserCouponCtr.selectedCoupon[voucher.shopId] ==
                          index) {
                        endUserCouponCtr.selectedCoupon[voucher.shopId] = -1;
                      } else {
                        endUserCouponCtr.selectedCoupon[voucher.shopId] = index;
                      }
                      endUserCouponCtr.shopVouchers.value![index].userStatus
                          .isClaimed = true;
                      endUserCouponCtr.shopVouchers.refresh();
                      endUserCouponCtr.setshowClaimedCoupon();
                    } else {
                      if (!Get.isDialogOpen!) {
                        dialogAlert([
                          Text(
                            res.message,
                            style: GoogleFonts.ibmPlexSansThai(
                                color: Colors.white, fontSize: 12),
                          )
                        ]);
                        Future.delayed(const Duration(seconds: 1), () {
                          Get.back();
                          Get.back();
                        });
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: themeColorDefault,
                        borderRadius: BorderRadius.circular(4)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: const Text(
                      'เก็บ',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                );
              } else if (endUserCouponCtr.showClaimedCoupon.value &&
                  endUserCouponCtr.selectedCoupon[voucher.shopId] == index) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(left: 4),
                    ),
                    Positioned(
                      top: -18,
                      right: -12,
                      child: Lottie.asset(
                          width: 50,
                          height: 50,
                          'assets/images/lottie/checked.json'),
                    )
                  ],
                );
              }

              return Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey.shade600)),
              );
            }),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class CouponCardPlatformWithCheck extends StatelessWidget {
  final dynamic voucher;
  final int index;
  final bool isCheckedProduct;

  const CouponCardPlatformWithCheck({
    super.key,
    required this.voucher,
    required this.index,
    required this.isCheckedProduct,
  });
  // canUse

  @override
  Widget build(BuildContext context) {
    if (!isCheckedProduct) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey.shade300)),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.grey.shade200,
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.network(
                    voucher.image.trim(),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.local_activity_rounded);
                    },
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      color: Colors.white.withOpacity(0.5), // สีขาวโปร่งแสง 50%
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            voucher.title,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ขั้นต่ำ ฿${myFormat.format(voucher.rewardInfo.minSpend)}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          if (voucher.quotaInfo.percentageUsed.toDouble() > 50)
                            LinearPercentIndicator(
                              padding: const EdgeInsets.only(right: 40),
                              alignment: MainAxisAlignment.center,
                              animation: true,
                              lineHeight: 4.0,
                              animationDuration: 1500,
                              percent: (voucher.quotaInfo.percentageUsed
                                      .toDouble()) /
                                  100,
                              backgroundColor: Colors.grey.shade200,
                              linearGradient: const LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment(0.8, 1),
                                tileMode: TileMode.mirror,
                                colors: <Color>[
                                  Color.fromARGB(255, 228, 40, 7),
                                  Color.fromARGB(255, 239, 161, 36),
                                ],
                              ),
                              barRadius: const Radius.circular(10),
                            ),
                        ],
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: Container(
                            color: Colors.white
                                .withOpacity(0.5), // สีขาวโปร่งแสง 50%
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        voucher.timeInfo.timeFormat,
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          Get.to(
                              () => CouponDetail(couponId: voucher.couponId));
                        },
                        child: Text(
                          'เงื่อนไข',
                          style: TextStyle(
                            fontSize: 10,
                            color: themeColorDefault,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey.shade600)),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      color: Colors.white.withOpacity(0.5), // สีขาวโปร่งแสง 50%
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
          ],
        ),
      );
    } else if (!voucher.canUse) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey.shade300)),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.grey.shade200,
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.network(
                    voucher.image.trim(),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.local_activity_rounded);
                    },
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      color: Colors.white.withOpacity(0.5), // สีขาวโปร่งแสง 50%
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            voucher.title,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ขั้นต่ำ ฿${myFormat.format(voucher.rewardInfo.minSpend)}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          if (voucher.quotaInfo.percentageUsed.toDouble() > 50)
                            LinearPercentIndicator(
                              padding: const EdgeInsets.only(right: 40),
                              alignment: MainAxisAlignment.center,
                              animation: true,
                              lineHeight: 4.0,
                              animationDuration: 1500,
                              percent: (voucher.quotaInfo.percentageUsed
                                      .toDouble()) /
                                  100,
                              backgroundColor: Colors.grey.shade200,
                              linearGradient: const LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment(0.8, 1),
                                tileMode: TileMode.mirror,
                                colors: <Color>[
                                  Color.fromARGB(255, 228, 40, 7),
                                  Color.fromARGB(255, 239, 161, 36),
                                ],
                              ),
                              barRadius: const Radius.circular(10),
                            ),
                        ],
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: Container(
                            color: Colors.white
                                .withOpacity(0.5), // สีขาวโปร่งแสง 50%
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        voucher.timeInfo.timeFormat,
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          Get.to(
                              () => CouponDetail(couponId: voucher.couponId));
                        },
                        child: Text(
                          'เงื่อนไข',
                          style: TextStyle(
                            fontSize: 10,
                            color: themeColorDefault,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Builder(builder: (context) {
              if (!voucher.userStatus.isClaimed) {
                return InkWell(
                  onTap: () async {
                    var res = await addVoucherItemsService(voucher.couponId);
                    if (res.code == '100') {
                      if (endUserCouponCtr.selectedCoupon[voucher.shopId] ==
                          index) {
                        endUserCouponCtr.selectedCoupon[voucher.shopId] = -1;
                        endUserCouponCtr.couponPlatformId.value = 0;
                      } else {
                        endUserCouponCtr.selectedCoupon[voucher.shopId] = index;
                        endUserCouponCtr.couponPlatformId.value =
                            voucher.couponId;
                      }
                      endUserCouponCtr.shopVouchers.value![index].userStatus
                          .isClaimed = true;
                      endUserCouponCtr.shopVouchers.refresh();
                      endUserCouponCtr.setshowClaimedCoupon();
                    } else {
                      if (!Get.isDialogOpen!) {
                        dialogAlert([
                          Text(
                            res.message,
                            style: GoogleFonts.ibmPlexSansThai(
                                color: Colors.white, fontSize: 12),
                          )
                        ]);
                        Future.delayed(const Duration(seconds: 1), () {
                          Get.back();
                          Get.back();
                        });
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: themeColorDefault,
                        borderRadius: BorderRadius.circular(4)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: const Text(
                      'เก็บ',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                );
              }

              return Obx(() {
                if (endUserCouponCtr.showClaimedCoupon.value &&
                    endUserCouponCtr.selectedCoupon[voucher.shopId] == index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(left: 4),
                      ),
                      Positioned(
                        top: -18,
                        right: -12,
                        child: Lottie.asset(
                            width: 50,
                            height: 50,
                            'assets/images/lottie/checked.json'),
                      )
                    ],
                  );
                }
                return Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey.shade500)),
                );
              });
            }),
            const SizedBox(width: 12),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        endUserCouponCtr.promotionData.platformVouchers.clear();
        if (endUserCouponCtr.couponPlatformId.value == voucher.couponId) {
          endUserCouponCtr.couponPlatformId.value = 0;
          endUserCouponCtr.promotionData.unusedPlatformVoucher = true;
        } else {
          endUserCouponCtr.promotionData.platformVouchers.add(voucher.couponId);
          endUserCouponCtr.promotionData.unusedPlatformVoucher = false;
          endUserCouponCtr.couponPlatformId.value = voucher.couponId;
        }
        // printWhite(endUserCouponCtr.promotionData.unusedPlatformVoucher);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey.shade300)),
        child: Row(
          children: [
            Container(
              color: Colors.grey.shade200,
              width: 90,
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CachedNetworkImage(
                imageUrl: voucher.image,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) {
                  return const Icon(
                    Icons.local_activity_rounded,
                    size: 40,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            voucher.title,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ขั้นต่ำ ฿${myFormat.format(voucher.rewardInfo.minSpend)}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          if (voucher.quotaInfo.percentageUsed.toDouble() > 50)
                            LinearPercentIndicator(
                              padding: const EdgeInsets.only(right: 40),
                              alignment: MainAxisAlignment.center,
                              animation: true,
                              lineHeight: 4.0,
                              animationDuration: 1500,
                              percent:
                                  (voucher.quotaInfo.percentageUsed.toDouble() +
                                          60) /
                                      100,
                              backgroundColor: Colors.grey.shade200,
                              linearGradient: const LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment(0.8, 1),
                                tileMode: TileMode.mirror,
                                colors: <Color>[
                                  Color.fromARGB(255, 228, 40, 7),
                                  Color.fromARGB(255, 239, 161, 36),
                                ],
                              ),
                              barRadius: const Radius.circular(10),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        voucher.timeInfo.timeFormat,
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          Get.to(
                              () => CouponDetail(couponId: voucher.couponId));
                        },
                        child: Text(
                          'เงื่อนไข',
                          style: TextStyle(
                            fontSize: 10,
                            color: themeColorDefault,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Obx(() {
              if (endUserCouponCtr.couponPlatformId.value == voucher.couponId) {
                return Icon(
                  Icons.check_circle,
                  color: themeColorDefault,
                );
              }
              return Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey.shade600)),
              );
            }),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
