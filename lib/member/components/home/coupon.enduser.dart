import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/controller/track.ctr.dart';
import 'package:fridayonline/member/models/home/home.vouchers.model.dart';
import 'package:fridayonline/member/services/coupon/coupon.services.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(anonymous)/signin.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:fridayonline/member/views/(coupon)/coupon.all.dart';
import 'package:fridayonline/member/views/(coupon)/coupon.detail.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CouponEndUser extends StatelessWidget {
  const CouponEndUser({super.key});

  @override
  Widget build(BuildContext context) {
    final EndUserHomeCtr endUserHomeCtr = Get.find();

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Obx(() {
        if (!endUserHomeCtr.isLoadingCoupon.value) {
          if (endUserHomeCtr.homeVouchers!.value.code == "-9") {
            return const SizedBox();
          }
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        var coupon = endUserHomeCtr.homeVouchers!.value.data;
                        Get.find<TrackCtr>().setDataTrack(coupon.contentId,
                            coupon.contentHeader, "home_coupon");
                        Get.to(() => const CouponAll());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'คูปองสุดคุ้ม',
                            style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              var coupon =
                                  endUserHomeCtr.homeVouchers!.value.data;
                              Get.find<TrackCtr>().setDataTrack(
                                  coupon.contentId,
                                  coupon.contentHeader,
                                  "home_coupon");
                              Get.to(() => const CouponAll());
                            },
                            child: Row(
                              children: [
                                Text(
                                  "ดูเพิ่มเติม",
                                  style: GoogleFonts.ibmPlexSansThai(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: themeColorDefault),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircleAvatar(
                                      backgroundColor: themeColorDefault,
                                      foregroundColor: Colors.white,
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 13,
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                          mainAxisExtent: 275,
                        ),
                        itemCount: endUserHomeCtr
                            .homeVouchers!.value.data.vouchers.length,
                        itemBuilder: (context, index) {
                          return CouponItem(
                              data: endUserHomeCtr
                                  .homeVouchers!.value.data.vouchers[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}

class CouponItem extends StatefulWidget {
  final Voucher data;
  const CouponItem({
    super.key,
    required this.data,
  });

  @override
  State<CouponItem> createState() => _CouponItemState();
}

class _CouponItemState extends State<CouponItem> {
  final EndUserHomeCtr endUserHomeCtr = Get.find();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            SizedBox(
              height: 78,
              child: Card(
                elevation: 0,
                child: Row(
                  children: [
                    Container(
                      color: Colors.grey.shade100,
                      height: Get.height,
                      child: CachedNetworkImage(
                        imageUrl: widget.data.image.trim(),
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) {
                          return const SizedBox(
                              width: 80,
                              child: Icon(Icons.local_activity_rounded));
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(() =>
                                CouponDetail(couponId: widget.data.couponId));
                          },
                          highlightColor: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.data.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "ขั้นต่ำ ฿${myFormat.format(widget.data.rewardInfo.minSpend)}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      widget.data.timeInfo.timeFormat,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
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
                      ),
                    ),
                    if (!widget.data.quotaInfo.fullyClaimed &&
                        !widget.data.userStatus.isClaimed)
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 48,
                        height: 24,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(themeColorDefault),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 4),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            shadowColor:
                                WidgetStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () async {
                            SetData data = SetData();
                            if (await data.b2cCustID == 0) {
                              Get.to(() => const SignInScreen());
                              return;
                            }
                            var res = await addVoucherItemsService(
                                widget.data.couponId);
                            if (res.code == '100') {
                              endUserCouponCtr.setshowClaimedCouponHome(
                                  widget.data.couponId);
                              widget.data.userStatus.isClaimed = true;
                              setState(() {});
                            } else {
                              if (!Get.isDialogOpen!) {
                                dialogAlert([
                                  Text(
                                    res.message,
                                    style: GoogleFonts.ibmPlexSansThai(
                                        color: Colors.white, fontSize: 12),
                                  )
                                ]);
                                endUserHomeCtr.fetchCoupon();
                              }
                              Future.delayed(const Duration(seconds: 1), () {
                                Get.back();
                              });
                            }
                          },
                          child: Text(
                            'เก็บ',
                            style: GoogleFonts.ibmPlexSansThai(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                    else if (widget.data.userStatus.isUsed)
                      Image.asset(
                        'assets/images/coupon/coupon_used.png',
                        width: 65,
                      )
                    else
                      Obx(() {
                        if (endUserCouponCtr.showClaimedCoupon.value &&
                            endUserCouponCtr.indexClick.value ==
                                widget.data.couponId) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(right: 12),
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
                          margin: const EdgeInsets.only(right: 12),
                          width: 48,
                          height: 24,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                                side: BorderSide(color: themeColorDefault),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                )),
                            onPressed: () async {
                              SetData data = SetData();
                              if (await data.b2cCustID == 0) {
                                Get.to(() => const SignInScreen());
                                return;
                              }
                              if (widget.data.shopId == 0) {
                                Get.find<EndUserCartCtr>().fetchCartItems();
                                Get.to(() => const EndUserCart());
                              } else {
                                Get.find<BrandCtr>()
                                    .fetchShopData(widget.data.shopId);
                                Get.toNamed(
                                  '/BrandStore/${widget.data.shopId}',
                                );
                              }
                            },
                            child: Text(
                              'ใช้โค้ด',
                              style: GoogleFonts.ibmPlexSansThai(
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
            ),
            if (widget.data.quotaInfo.fullyClaimed)
              Positioned(
                right: 4,
                child: SizedBox(
                    width: 60,
                    child: Image.asset(
                        'assets/images/coupon/coupon_sold_out.png')),
              )
          ],
        ));
  }
}
