import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/controller/track.ctr.dart';
import 'package:fridayonline/member/views/(coupon)/coupon.all.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CouponEndUserV2 extends StatelessWidget {
  const CouponEndUserV2({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isSmall = compact;
    final EndUserHomeCtr endUserHomeCtr = Get.find();

    return Obx(() {
      final isLoading = endUserHomeCtr.isLoadingCoupon.value;
      final hv = endUserHomeCtr.homeVouchers?.value;
      final hide = isLoading || hv == null || hv.code == "-9";

      return Visibility(
        visible: !hide,
        maintainState: true,
        child: isSmall
            ? _SmallCouponCard(endUserHomeCtr: endUserHomeCtr)
            : _CouponCard(endUserHomeCtr: endUserHomeCtr),
      );
    });
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({required this.endUserHomeCtr});
  final EndUserHomeCtr endUserHomeCtr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1EA3A3A3),
                    blurRadius: 24,
                    offset: Offset(0, 3.57),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  final coupon = endUserHomeCtr.homeVouchers!.value.data;
                  Get.find<TrackCtr>().setDataTrack(
                    coupon.contentId,
                    coupon.contentHeader,
                    "home_coupon",
                  );
                  Get.to(() => const CouponAll());
                },
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              const SizedBox(width: 4),
                              Image.asset(
                                'assets/images/b2c/icon/coupon3.png',
                                width: 18,
                                height: 18,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  (endUserHomeCtr.homeVouchers?.value.data
                                              .voucherTitle ??
                                          "")
                                      .trim(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(height: 10),
                      Container(
                        height: 29,
                        padding: const EdgeInsets.all(6),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF5FAFE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // obx
                              Expanded(
                                child: Text(
                                  endUserHomeCtr.homeVouchers?.value.data
                                          .voucherDesc ??
                                      "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: GoogleFonts.ibmPlexSansThai(
                                    color: const Color(0xFF1F1F1F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                'เก็บเลย',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ibmPlexSansThai(
                                  color: themeColorDefault,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SmallCouponCard extends StatelessWidget {
  const _SmallCouponCard({required this.endUserHomeCtr});
  final EndUserHomeCtr endUserHomeCtr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1EA3A3A3),
                    blurRadius: 24,
                    offset: Offset(0, 3.57),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: GestureDetector(
                  onTap: () {
                    final coupon = endUserHomeCtr.homeVouchers!.value.data;
                    Get.find<TrackCtr>().setDataTrack(
                      coupon.contentId,
                      coupon.contentHeader,
                      "home_coupon",
                    );
                    Get.to(() => const CouponAll());
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 4),
                              Image.asset('assets/images/b2c/icon/coupon3.png',
                                  width: 28, height: 28),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (endUserHomeCtr.homeVouchers?.value.data
                                                  .voucherTitle ??
                                              '')
                                          .trim(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: GoogleFonts.ibmPlexSansThai(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      (endUserHomeCtr.homeVouchers?.value.data
                                                  .voucherDesc ??
                                              '')
                                          .trim(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: GoogleFonts.ibmPlexSansThai(
                                        fontSize: 10,
                                        color: const Color(0xFF5A5A5A),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 56),
                          child: Text(
                            'เก็บเลย',
                            textAlign: TextAlign.center,
                            softWrap: false,
                            overflow: TextOverflow.visible,
                            style: GoogleFonts.ibmPlexSansThai(
                              color: themeColorDefault,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
