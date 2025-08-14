import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/components/home/checkin.dart';
import 'package:fridayonline/member/components/showproduct/nodata.dart';
import 'package:fridayonline/member/components/webview/webview_full.dart';
import 'package:fridayonline/member/controller/coint.ctr.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:fridayonline/member/models/fair/coininfo.model.dart';
import 'package:fridayonline/member/services/checkin/checkin.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(profile)/friday.coin.more.dart';
import 'package:fridayonline/member/widgets/seeall.button.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FridayCoin extends StatelessWidget {
  FridayCoin({super.key});
  final coinController = Get.find<CoinCtr>();

  @override
  Widget build(BuildContext context) {
    coinController.fetchTransaction();
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: appBarMasterEndUser('Friday Online Coin'),
        body: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1)),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/b2c/background/bg-coin.png',
                fit: BoxFit.cover,
              ),
              SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Obx(() {
                          if (coinController.isLoadingTransaction.value) {
                            return const SizedBox(
                              height: 45,
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Coin ของฉัน :',
                                          style: GoogleFonts.notoSansThaiLooped(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          " ${myFormat.format(
                                            coinController.transaction!.data
                                                .availableAmount,
                                          )} Coin",
                                          style: GoogleFonts.notoSansThaiLooped(
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
                                    InkWell(
                                      onTap: () async {
                                        SetData data = SetData();
                                        var token = await data.accessToken;
                                        var custId = await data.b2cCustID;
                                        Get.to(() => Scaffold(
                                              appBar: appBarMasterEndUser(
                                                  'Friday Online coin'),
                                              body: WebViewFullScreen(
                                                  mparamurl:
                                                      '${webview_b2c}coin/info?token=$token&custId=$custId'),
                                            ));
                                      },
                                      child: const Icon(
                                        Icons.help_outline_rounded,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                if (coinController
                                    .transaction!.data.expiryInfo.isNotEmpty)
                                  Text(
                                    coinController.transaction!.data
                                        .expiryInfo[0].displayText,
                                    style: GoogleFonts.notoSansThaiLooped(
                                        color: Colors.white, fontSize: 14),
                                  ),
                              ],
                            );
                          }
                        }),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.all(8),
                            child: Obx(() {
                              var today = coinController.checkIn!.value.data
                                  .firstWhereOrNull((e) => e.isToday);
                              return Column(
                                children: [
                                  Text(
                                    'เช็คอินรายวัน',
                                    style: GoogleFonts.notoSansThaiLooped(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'เช็คอินรายวันเพื่อรับคูปองสุดพิเศษ!',
                                    style: GoogleFonts.notoSansThaiLooped(),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  CheckInProgress(),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  if (!today!.isCompleted)
                                    InkWell(
                                      onTap: () async {
                                        var point = coinController
                                            .checkIn!.value.data
                                            .firstWhereOrNull((e) => e.isToday);
                                        if (point != null) {
                                          await collectCoinsService(
                                                  point.points)
                                              .then((res) {
                                            if (res == "100") {
                                              point.isCompleted = true;
                                              coinController.checkIn!.refresh();
                                              coinController.fetchCheckIn();
                                              coinController.fetchTransaction();
                                              Get.put(ProfileCtl())
                                                  .fetchProfile();
                                            }
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            gradient: const LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  Color(0xFFFF512F),
                                                  Color(0xFFF09819),
                                                ])),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รับรางวัล',
                                                style: GoogleFonts
                                                    .notoSansThaiLooped(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Image.asset(
                                                'assets/images/b2c/icon/gift2.png',
                                                width: 20,
                                              )
                                            ]),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              );
                            })),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ประวัติการทำรายการ',
                              style: GoogleFonts.notoSansThaiLooped(
                                  fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                                onTap: () async {
                                  coinController.fetchTransaction(offset: 0);
                                  await Get.to(() => const FridayCoinMore())!
                                      .then((value) {
                                    coinController.fetchTransaction(offset: 0);
                                  });
                                },
                                child: buttonSeeAll())
                          ],
                        ),
                        Obx(() {
                          if (coinController.isLoadingTransaction.value) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          } else if (coinController
                              .transaction!.data.items.isNotEmpty) {
                            var items = coinController.transaction!.data.items;
                            return ListView.builder(
                              padding: const EdgeInsets.only(bottom: 36),
                              shrinkWrap: true,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                var item = items[index];
                                if (index > 4) {
                                  return const SizedBox();
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.coinName),
                                            Text(
                                              item.cDate,
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          _getCoinContent(item.coinAmount),
                                          style: GoogleFonts.notoSansThaiLooped(
                                              color: _getCoinColor(
                                                  item.coinAmount > 0)),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                );
                              },
                            );
                          } else {
                            return Center(
                                heightFactor: 1.5,
                                child: nodataTitle(
                                    context, 'ไม่พบประวัติการทำรายการ'));
                          }
                        }),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCoinColor(bool isCheckin) {
    if (isCheckin) {
      return Colors.orange;
    } else {
      return Colors.black;
    }
  }

  String _getCoinContent(int coin) {
    if (coin > 0) {
      return "+ ${myFormat.format(coin)}";
    } else {
      return myFormat.format(coin);
    }
  }

  void help({required List<Info> data}) {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          )),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'วิธีการเก็บคะแนน',
                style:
                    GoogleFonts.notoSansThaiLooped(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  for (var item in data)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.key,
                              style: GoogleFonts.notoSansThaiLooped(
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              item.value,
                              style: GoogleFonts.notoSansThaiLooped(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                  const Divider(),
                  SizedBox(
                    width: Get.width,
                    height: 40,
                    child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                            foregroundColor: themeColorDefault,
                            side: BorderSide(color: themeColorDefault),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: Text('ปิดหน้าต่าง',
                            style: GoogleFonts.notoSansThaiLooped(
                                fontWeight: FontWeight.w500))),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
