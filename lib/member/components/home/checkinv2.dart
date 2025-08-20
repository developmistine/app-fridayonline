import 'package:fridayonline/member/controller/coint.ctr.dart';
import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(anonymous)/signin.dart';
import 'package:fridayonline/member/views/(profile)/friday.coin.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CoinV2 extends StatefulWidget {
  const CoinV2({super.key, this.compact = false});
  final bool compact;

  @override
  State<CoinV2> createState() => _CoinState();
}

class _CoinState extends State<CoinV2> {
  final coinController = Get.find<CoinCtr>();
  final signInController = Get.put(EndUserSignInCtr());
  @override
  Widget build(BuildContext context) {
    final isSmall = widget.compact;
    return Obx(() {
      if (coinController.isLoadingCheckIn.value) {
        return const SizedBox();
      }

      if (isSmall) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white /* CI-Band-White */,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1EA3A3A3),
                    blurRadius: 24,
                    offset: Offset(0, 3.57),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  if (signInController.custId == 0) {
                    Get.to(() => const SignInScreen());
                    return;
                  } else {
                    Get.to(() => FridayCoin());
                  }
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
                            Image.asset(
                              'assets/images/b2c/icon/coin.png',
                              width: 28,
                              height: 28,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'เช็คอินแจก Coin',
                                    style: GoogleFonts.ibmPlexSansThai(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Obx(() {
                                    final loadingOrGuest =
                                        signInController.isLoading.value ||
                                            signInController.custId == 0;

                                    final amount = loadingOrGuest
                                        ? 0
                                        : (coinController.checkIn?.value
                                                .availableAmount ??
                                            0);

                                    return Text(
                                      "Coin ของฉัน : ${myFormat.format(amount)} Coin",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.ibmPlexSansThai(
                                        fontSize: 10,
                                        color: const Color(0xFF5A5A5A),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'เช็คอิน',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSansThai(
                          color: themeColorDefault,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white /* CI-Band-White */,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1EA3A3A3),
                    blurRadius: 24,
                    offset: Offset(0, 3.57),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  if (signInController.custId == 0) {
                    Get.to(() => const SignInScreen());
                    return;
                  } else {
                    Get.to(() => FridayCoin());
                  }
                },
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Image.asset(
                                    'assets/images/b2c/icon/coin.png',
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'เช็คอินแจก Coin',
                                    style: GoogleFonts.ibmPlexSansThai(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text('เช็คอิน',
                                style: GoogleFonts.ibmPlexSansThai(
                                  color: themeColorDefault,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() {
                        final isLoadingOrGuest =
                            signInController.isLoading.value ||
                                signInController.custId == 0;

                        final amount = isLoadingOrGuest
                            ? 0
                            : (coinController.checkIn?.value.availableAmount ??
                                0);

                        return Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Coin ของฉัน : ${myFormat.format(amount)} Coin",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.ibmPlexSansThai(
                                    color: const Color(0xFF1F1F1F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  child: CircleAvatar(
                                    backgroundColor: themeColorDefault,
                                    child: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }
    });
  }
}
