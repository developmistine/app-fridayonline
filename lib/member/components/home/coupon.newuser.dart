import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/controller/coupon.ctr.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/services/coupon/coupon.services.dart';
import 'package:fridayonline/member/views/(anonymous)/signin.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:fridayonline/member/views/(coupon)/coupon.detail.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CouponNewUser extends StatefulWidget {
  const CouponNewUser({super.key});

  @override
  State<CouponNewUser> createState() => _CouponNewUserState();
}

class _CouponNewUserState extends State<CouponNewUser> {
  final EndUserHomeCtr endUserHomeCtr = Get.find();
  final EndUserCouponCartCtr endUserCouponCtr = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!endUserHomeCtr.isLoadingCouponNewUser.value) {
        if (endUserHomeCtr.homeVouchersNewUser!.value.code == "-9") {
          return const SizedBox();
        }
        return Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 255,
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300.withOpacity(0.5),
                          offset: const Offset(0, 6),
                          blurRadius: 4,
                          // spreadRadius: 1,
                        )
                      ],
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFE2F2FC),
                            Color(0xFFBFE4F8),
                          ])),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 45,
                      ),
                      for (var index = 0;
                          index <
                              endUserHomeCtr.homeVouchersNewUser!.value.data
                                  .vouchers.length;
                          index++)
                        Builder(builder: (context) {
                          var coupon = endUserHomeCtr
                              .homeVouchersNewUser!.value.data.vouchers[index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 80.0, bottom: 4),
                            child: SizedBox(
                              height: 100,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                clipBehavior: Clip.none,
                                children: [
                                  Card(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, top: 8, bottom: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  coupon.title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts
                                                      .notoSansThaiLooped(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                Text(
                                                  "ขั้นต่ำ ฿${coupon.rewardInfo.minSpend}",
                                                  style: GoogleFonts
                                                      .notoSansThaiLooped(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .grey.shade700),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      coupon
                                                          .timeInfo.timeFormat,
                                                      style: GoogleFonts
                                                          .notoSansThaiLooped(
                                                              fontSize: 12,
                                                              color: Colors.grey
                                                                  .shade600),
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(() =>
                                                            CouponDetail(
                                                                couponId: coupon
                                                                    .couponId));
                                                      },
                                                      child: Text(
                                                        "เงื่อนไข",
                                                        style: GoogleFonts
                                                            .notoSansThaiLooped(
                                                                fontSize: 12,
                                                                color:
                                                                    themeColorDefault),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (!coupon.quotaInfo.fullyClaimed &&
                                            !coupon.userStatus.isClaimed)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 50,
                                              height: 30,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              themeColorDefault),
                                                  onPressed: () async {
                                                    SetData data = SetData();
                                                    if (await data.b2cCustID ==
                                                        0) {
                                                      Get.to(() =>
                                                          const SignInScreen());
                                                      return;
                                                    }
                                                    var res =
                                                        await addVoucherItemsService(
                                                            coupon.couponId);
                                                    if (res.code == '100') {
                                                      endUserCouponCtr
                                                          .setshowClaimedCouponHome(
                                                              coupon.couponId);
                                                      coupon.userStatus
                                                          .isClaimed = true;
                                                      setState(() {});
                                                    } else {
                                                      if (!Get.isDialogOpen!) {
                                                        dialogAlert([
                                                          Text(
                                                            res.message,
                                                            style: GoogleFonts
                                                                .notoSansThaiLooped(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                          )
                                                        ]);
                                                        endUserHomeCtr
                                                            .fetchCoupon();
                                                      }
                                                      Future.delayed(
                                                          const Duration(
                                                              seconds: 1), () {
                                                        Get.back();
                                                      });
                                                    }
                                                  },
                                                  child: const Text(
                                                    'เก็บ',
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                  )),
                                            ),
                                          )
                                        else if (coupon.userStatus.isUsed)
                                          Image.asset(
                                            'assets/images/coupon/coupon_used.png',
                                            width: 65,
                                          )
                                        else
                                          Obx(() {
                                            if (endUserCouponCtr
                                                    .showClaimedCoupon.value &&
                                                endUserCouponCtr
                                                        .indexClick.value ==
                                                    coupon.couponId) {
                                              return Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 12),
                                                  ),
                                                  Positioned(
                                                    top: -18,
                                                    right: 2,
                                                    child: Lottie.asset(
                                                        width: 50,
                                                        height: 50,
                                                        'assets/images/lottie/checked.json'),
                                                  )
                                                ],
                                              );
                                            }
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  right: 12),
                                              width: 48,
                                              height: 24,
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4,
                                                        horizontal: 4),
                                                    side: BorderSide(
                                                        color:
                                                            themeColorDefault),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    )),
                                                onPressed: () async {
                                                  SetData data = SetData();
                                                  if (await data.b2cCustID ==
                                                      0) {
                                                    Get.to(() =>
                                                        const SignInScreen());
                                                    return;
                                                  }
                                                  if (coupon.shopId == 0) {
                                                    Get.find<EndUserCartCtr>()
                                                        .fetchCartItems();
                                                    Get.to(() =>
                                                        const EndUserCart());
                                                  } else {
                                                    Get.find<BrandCtr>()
                                                        .fetchShopData(
                                                            coupon.shopId);
                                                    Get.toNamed(
                                                      '/BrandStore/${coupon.shopId}',
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  'ใช้โค้ด',
                                                  style: GoogleFonts
                                                      .notoSansThaiLooped(
                                                    color: themeColorDefault,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            );
                                          })
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: -82,
                                    top: 4,
                                    child: CachedNetworkImage(
                                        width: 93, imageUrl: coupon.image),
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                    ],
                  ),
                ),
                if (endUserHomeCtr.homeVouchersNewUser!.value.data.contentImg !=
                    "")
                  Positioned(
                    top: -10,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: endUserHomeCtr
                              .homeVouchersNewUser!.value.data.contentImg,
                          width: 300,
                        ),
                        Text(
                          endUserHomeCtr
                              .homeVouchersNewUser!.value.data.contentHeader,
                          style: GoogleFonts.notoSansThaiLooped(
                              height: 1,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                //
              ],
            ),
            const SizedBox(
              height: 18,
            )
          ],
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
