import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/components/showproduct/nodata.dart';
import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/models/coupon/coupon.user.model.dart';
import 'package:fridayonline/member/models/coupon/vouchers.group.user.model.dart';
import 'package:fridayonline/member/services/coupon/coupon.services.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(anonymous)/signin.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:fridayonline/member/views/(coupon)/coupon.detail.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class EndUserCouponMeCtr extends GetxController {
  RxInt active = 0.obs;
  RxInt voucherPage = 0.obs;
  RxInt voucherType = 0.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isLoading = false.obs;

  List<VoucherSummary> voucherSum = [];
  VoucherUser? voucherUser;

  void resetVoucher() {
    if (voucherUser != null && voucherUser!.data.vouchers.length > 20) {
      voucherUser!.data.vouchers = voucherUser!.data.vouchers.sublist(0, 20);
    }
  }

  setActive(int no) {
    active.value = no;
  }

  fetchVoucherUserCtr(int offset) async {
    try {
      isLoading.value = true;
      voucherUser =
          await fetchVoucherUser(voucherPage.value, voucherType.value, offset);
      return voucherUser;
    } finally {
      isLoading.value = false;
    }
  }

  Future<VoucherUser?>? fetchMoreVoucher(offset) async {
    return await fetchVoucherUser(voucherPage.value, voucherType.value, offset);
  }
}

class CouponMe extends StatefulWidget {
  const CouponMe({super.key});

  @override
  State<CouponMe> createState() => _CouponMeState();
}

class _CouponMeState extends State<CouponMe> {
  final ctr = Get.put(EndUserCouponMeCtr());
  final ScrollController _scrollController = ScrollController();

  int offset = 20;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !ctr.isLoadingMore.value) {
        fetchMoreCoupon();
      }
    });
    ctr.active.value = 0;
    ctr.voucherPage.value = 0;
    ctr.voucherType.value = 0;
    ctr.setActive(0);
    fetchData();
  }

  fetchData() async {
    var res = await ctr.fetchVoucherUserCtr(0);
    ctr.voucherSum = res!.data.voucherSummary;
    setState(() {});
  }

  void fetchMoreCoupon() async {
    ctr.isLoadingMore.value = true;
    try {
      final newReviews = await ctr.fetchMoreVoucher(offset);

      if (newReviews!.data.vouchers.isNotEmpty) {
        ctr.voucherUser!.data.vouchers.addAll(newReviews.data.vouchers);
        offset += 20;
      }
    } finally {
      ctr.isLoadingMore.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    ctr.active.value = 0;
    ctr.voucherPage.value = 0;
    ctr.voucherType.value = 0;
    ctr.voucherSum = [];
    offset = 20;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
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
            backgroundColor: Colors.grey.shade50,
            appBar: appBarMasterEndUser('รายละเอียดคูปอง'),
            body: FutureBuilder(
                future: fetchVoucherGroupUser(),
                builder: (context, AsyncSnapshot<VoucherGroupUser?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      // heightFactor: 18,
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (snapshot.data!.code == "-9") {
                    return const Center(
                      child: Text('ไม่พบรายละเอียดคูปอง'),
                    );
                  }
                  VoucherGroupUser? couponData = snapshot.data;
                  return Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              List.generate(couponData!.data.length, (index) {
                            return ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 100),
                              child: InkWell(
                                onTap: () {
                                  ctr.active.value = index;
                                  ctr.voucherPage.value =
                                      couponData.data[index].voucherPage;
                                  ctr.voucherType.value =
                                      couponData.data[index].voucherGroupId;
                                  ctr.fetchVoucherUserCtr(0);
                                },
                                child: Obx(() {
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: ctr.active.value == index
                                            ? Border(
                                                bottom: BorderSide(
                                                    width: 2,
                                                    color: themeColorDefault))
                                            : null),
                                    child: Text(
                                      "${couponData.data[index].voucherGroup}  (${ctr.voucherSum.isNotEmpty ? ctr.voucherSum[index].count : "0"})",
                                      textAlign: TextAlign.center,
                                      style: ctr.active.value == index
                                          ? TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: themeColorDefault,
                                              fontSize: 13)
                                          : const TextStyle(fontSize: 13),
                                    ),
                                  );
                                }),
                              ),
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        child: Obx(
                          () {
                            if (ctr.isLoading.value) {
                              return const Center(
                                heightFactor: 28,
                                child: CircularProgressIndicator.adaptive(),
                              );
                            } else if (ctr.voucherUser!.code == '-9') {
                              return Center(
                                child: nodataTitle(context, "ไม่พบข้อมูลคูปอง"),
                              );
                            }
                            var data = ctr.voucherUser!.data;
                            ctr.voucherSum = data.voucherSummary;
                            if (data.vouchers.isEmpty) {
                              return Center(
                                child: nodataTitle(context, "ไม่พบข้อมูลคูปอง"),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              // itemCount: data.vouchers.length,
                              itemCount: data.vouchers.length +
                                  (ctr.isLoadingMore.value ? 1 : 0),
                              padding:
                                  const EdgeInsets.only(left: 84.0, right: 4),
                              itemBuilder: (context, index) {
                                if (index ==
                                        ctr.voucherUser!.data.vouchers.length &&
                                    ctr.isLoadingMore.value) {
                                  // แสดง loader เมื่อมีการโหลดข้อมูลเพิ่มเติม
                                  return const SizedBox.shrink();
                                }
                                var coupon = data.vouchers[index];
                                return SizedBox(
                                  height: 100,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        child: Row(children: [
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    coupon.title,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts
                                                        .notoSansThaiLooped(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  Text(
                                                    "ขั้นต่ำ ฿${myFormat.format(coupon.rewardInfo.minSpend)}",
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade800,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  if (coupon.quotaInfo
                                                          .percentageUsed
                                                          .toDouble() >=
                                                      50)
                                                    SizedBox(
                                                      height: 10,
                                                      width: 150,
                                                      child:
                                                          LinearPercentIndicator(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 40),
                                                        alignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        animation: true,
                                                        lineHeight: 4.0,
                                                        animationDuration: 1500,
                                                        percent: (coupon
                                                                .quotaInfo
                                                                .percentageUsed
                                                                .toDouble()) /
                                                            100,
                                                        backgroundColor: Colors
                                                            .grey.shade200,
                                                        linearGradient:
                                                            const LinearGradient(
                                                          begin: Alignment
                                                              .bottomLeft,
                                                          end:
                                                              Alignment(0.8, 1),
                                                          tileMode:
                                                              TileMode.mirror,
                                                          colors: <Color>[
                                                            Color.fromARGB(255,
                                                                228, 40, 7),
                                                            Color.fromARGB(255,
                                                                239, 161, 36),
                                                          ],
                                                        ),
                                                        barRadius: const Radius
                                                            .circular(10),
                                                      ),
                                                    ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        coupon.timeInfo
                                                            .timeFormat,
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey.shade800,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Get.to(() => CouponDetail(
                                                              couponId: coupon
                                                                  .couponId));
                                                        },
                                                        child: Text(
                                                          'เงื่อนไข',
                                                          style: TextStyle(
                                                            color:
                                                                themeColorDefault,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Builder(builder: (context) {
                                              if (coupon.quotaInfo.fullyUsed) {
                                                return Image.asset(
                                                    'assets/images/coupon/coupon_sold_out.png');
                                              } else if (coupon
                                                  .userStatus.isUsed) {
                                                return Image.asset(
                                                    'assets/images/coupon/coupon_used.png');
                                              }
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14),
                                                child: OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                      foregroundColor:
                                                          themeColorDefault,
                                                      side: BorderSide(
                                                          color:
                                                              themeColorDefault),
                                                      shape: RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              color:
                                                                  themeColorDefault),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4))),
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
                                                    data.vouchers[index].canUse
                                                        ? 'ใช้โค้ด'
                                                        : 'ใช้ทีหลัง',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts
                                                        .notoSansThaiLooped(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ]),
                                      ),
                                      Positioned(
                                        left: -82,
                                        top: 4,
                                        child: CachedNetworkImage(
                                          imageUrl: coupon.image.trim(),
                                          width: 93,
                                          errorWidget: (context, url, error) {
                                            return Icon(
                                              Icons.local_attraction_rounded,
                                              color: Colors.grey.shade400,
                                              size: 40,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  );
                }),
          ),
        ));
  }
}
