import 'package:fridayonline/member/controller/coint.ctr.dart';
import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:fridayonline/member/models/checkin/checkin.model.dart';
import 'package:fridayonline/member/services/checkin/checkin.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(anonymous)/signin.dart';
import 'package:fridayonline/member/views/(initials)/fair/fair.view.dart';
import 'package:fridayonline/member/views/(profile)/friday.coin.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Coin extends StatefulWidget {
  const Coin({super.key});

  @override
  State<Coin> createState() => _CoinState();
}

class _CoinState extends State<Coin> {
  final coinController = Get.find<CoinCtr>();
  final signInController = Get.put(EndUserSignInCtr());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (coinController.isLoadingCheckIn.value) {
        return const SizedBox();
      }
      return Container(
        margin: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 18),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                    const Color.fromARGB(255, 140, 28, 214),
                    themeColorDefault
                  ])),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                coinController.checkIn!.value.checkinTitle,
                                style: GoogleFonts.ibmPlexSansThai(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Image.asset(
                                'assets/images/b2c/icon/coin.png',
                                width: 20,
                              )
                            ],
                          ),
                          Text(
                            coinController.checkIn!.value.checkinDesc,
                            style: GoogleFonts.ibmPlexSansThai(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),

                    // const SizedBox(width: 20),
                    Expanded(
                      child: Obx(() {
                        if (coinController.isLoadingCheckIn.value) {
                          return const SizedBox();
                        }
                        var today = coinController.checkIn!.value.data
                            .firstWhereOrNull((e) => e.isToday);
                        if (today == null) {
                          return const SizedBox();
                        }
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: today.isCompleted
                              ? Row(
                                  key: const ValueKey('checked_in'),
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      'assets/images/b2c/icon/check.png',
                                      width: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'เช็คอินแล้ว',
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.ibmPlexSansThai(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              : InkWell(
                                  onTap: () async {
                                    if (signInController.custId == 0) {
                                      Get.to(() => const SignInScreen());
                                      return;
                                    }
                                    var point = coinController
                                        .checkIn!.value.data
                                        .firstWhereOrNull((e) => e.isToday);
                                    if (point != null) {
                                      await collectCoinsService(point.points)
                                          .then((res) {
                                        if (res == "100") {
                                          notifyAlert([
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              'ยินดีด้วย',
                                              style:
                                                  GoogleFonts.ibmPlexSansThai(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              'ขอบคุณที่คุณกลับมาอีกครั้ง รับรางวัลของคุณไปเลย',
                                              style:
                                                  GoogleFonts.ibmPlexSansThai(
                                                      fontSize: 14),
                                            ).paddingSymmetric(horizontal: 18),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                              child: Image.asset(
                                                'assets/images/b2c/icon/coin3.png',
                                                width: 200,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF1C9AD6)),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'คุณได้รับ ',
                                                    style: GoogleFonts
                                                        .ibmPlexSansThai(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                  ),
                                                  Text(
                                                    '+${point.points} coin',
                                                    style: GoogleFonts
                                                        .ibmPlexSansThai(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.yellow),
                                                  ),
                                                  Image.asset(
                                                    'assets/images/b2c/icon/coin.png',
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            GestureDetector(
                                                onTap: Get.back,
                                                child: Text(
                                                  'ปิดหน้าต่างนี้',
                                                  style: GoogleFonts
                                                      .ibmPlexSansThai(),
                                                )),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                          ]).then((res) async {
                                            point.isCompleted = true;
                                            coinController.checkIn!.refresh();
                                            coinController.fetchCheckIn();
                                            Get.put(ProfileCtl())
                                                .fetchProfile();
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    key: const ValueKey('checkin_button'),
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                        colors: [
                                          Color(0xFFFFA92C),
                                          Color(0xFFFFCC00),
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      'รับ +${today.points} เหรียญ',
                                      style: GoogleFonts.ibmPlexSansThai(
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() {
              if (signInController.isLoading.value ||
                  signInController.custId == 0) {
                return const SizedBox();
              }
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0XFFF4F4F4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, left: 6, right: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                "Coin ของฉัน : ${myFormat.format(
                                  coinController.checkIn?.value.availableAmount,
                                )} Coin",
                                style: GoogleFonts.ibmPlexSansThai(
                                    color: const Color(0XFF5A5A5A),
                                    fontSize: 14)),
                            const SizedBox(
                              width: 4,
                            ),
                            Image.asset(
                              'assets/images/b2c/icon/coin.png',
                              width: 18,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => FridayCoin());
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'ดูข้อมูล',
                                style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 13,
                                    color: themeColorDefault,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              SizedBox(
                                width: 20,
                                child: CircleAvatar(
                                    backgroundColor: themeColorDefault,
                                    child: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    )),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: CheckInProgress())
          ],
        ),
      );
    });
  }
}

class CheckInProgress extends StatelessWidget {
  CheckInProgress({super.key});
  Color _getCircleColor(DayData day) {
    if (day.isCompleted) {
      return const Color(0xFF26A464);
    } else if (day.isToday) {
      return Colors.orange;
    } else if (day.isLocked) {
      return Colors.grey[300]!;
    } else {
      return Colors.red; // Sunday special case
    }
  }

  Widget _getCircleContent(DayData day) {
    if (day.isCompleted) {
      return const Icon(
        Icons.check,
        color: Colors.white,
        size: 24,
      );
    } else if (day.isToday) {
      return Text(
        'วันนี้',
        style: GoogleFonts.ibmPlexSansThai(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (day.isLocked) {
      return Icon(
        Icons.lock,
        color: Colors.grey[600],
        size: 20,
      );
    } else {
      return Image.asset(
        'assets/images/b2c/icon/gift.png',
        width: 24,
      );
    }
  }

  final coinController = Get.find<CoinCtr>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (coinController.isLoadingCheckIn.value) {
        return const SizedBox();
      }

      var items = coinController.checkIn!.value.data;
      if (items.isEmpty) {
        return const SizedBox();
      }
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F9FE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                for (int i = 0;
                    i < coinController.checkIn!.value.data.length;
                    i++) ...[
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '+${items[i].points}',
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: items[i].isCompleted
                                ? const Color(0xFF26A464)
                                // ? Colors.grey[600],
                                : items[i].isToday
                                    ? Colors.orange[700]
                                    : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Circle with status
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getCircleColor(items[i]),
                            boxShadow: items[i].isToday
                                ? [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: i == items.length - 1
                              ? Image.asset(
                                  'assets/images/b2c/icon/gift.png',
                                  width: 24,
                                )
                              : Center(
                                  child: _getCircleContent(items[i]),
                                ),
                        ),

                        // Day name
                        Text(
                          items[i].dayName,
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: items[i].isCompleted
                                ? const Color(0xFF26A464)
                                : items[i].isToday
                                    ? Colors.orange[700]
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < items.length - 1)
                    const Expanded(
                        child: Divider(
                      thickness: 3,
                    ))
                ],
              ],
            ),
          ],
        ),
      );
    });
  }
}
