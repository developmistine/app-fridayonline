import 'dart:async';

import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/components/showproduct/nodata.dart';
import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/models/coupon/vouchers.group.model.dart';
import 'package:fridayonline/member/models/coupon/vouchers.items.model.dart';
import 'package:fridayonline/member/services/coupon/coupon.services.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(anonymous)/signin.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:fridayonline/member/views/(coupon)/coupon.detail.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// Enhanced Controller
class CouponCtr extends GetxController {
  // Store voucher items for each group
  RxMap<int, Vouchersitems> voucherItemsMap = <int, Vouchersitems>{}.obs;

  fetchCouponItems(int groupId) async {
    try {
      final result = await fetchVoucherItemsService(groupId);
      if (result != null) {
        voucherItemsMap[groupId] = result;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {}
  }

  // Method to claim voucher and update only that coupon
  Future<bool> claimVoucher(int couponId, int groupId) async {
    try {
      var res = await addVoucherItemsService(couponId);
      if (res.code == '-9') {
        return false;
      }

      // Update only the specific coupon in the existing data
      final voucherItems = voucherItemsMap[groupId];
      if (voucherItems != null) {
        // Find and update the specific coupon
        for (var voucherType in voucherItems.data.voucherType) {
          for (var voucher in voucherType.vouchers) {
            if (voucher.couponId == couponId) {
              voucher.userStatus.isClaimed = true;
              break;
            }
          }
        }
        // Trigger reactive update
        voucherItemsMap[groupId] = voucherItems;
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error claiming voucher: $e');
      }
      return false;
    }
  }

  Vouchersitems? getVoucherItems(int groupId) {
    return voucherItemsMap[groupId];
  }
}

final couponCtr = Get.put(CouponCtr());

class CouponAll extends StatefulWidget {
  const CouponAll({super.key});

  @override
  State<CouponAll> createState() => _CouponAllState();
}

class _CouponAllState extends State<CouponAll>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final ScrollController _scrollController = ScrollController();

  List<GlobalKey> sectionKeys = [];

  VouchersGroup? voucherGroup;
  bool isLoading = false;

  void _handleScroll() {
    for (int i = 0; i < sectionKeys.length; i++) {
      final keyContext = sectionKeys[i].currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero, ancestor: null);

        if (position.dy <= kToolbarHeight + 110 &&
            position.dy + box.size.height > kToolbarHeight) {
          if (_tabController!.index != i) {
            _tabController!.animateTo(i);
          }
          break;
        }
      }
    }
  }

  void _scrollToSection(int index) {
    final keyContext = sectionKeys[index].currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0,
      );
    }
  }

  @override
  void initState() {
    setIninials();
    super.initState();
  }

  setIninials() async {
    setState(() => isLoading = true);

    voucherGroup = await fetchVoucherGroupService();
    _tabController =
        TabController(length: voucherGroup!.data.length, vsync: this);
    sectionKeys =
        List.generate(voucherGroup!.data.length, (index) => GlobalKey());

    // Pre-load all voucher items
    for (var group in voucherGroup!.data) {
      couponCtr.fetchCouponItems(group.groupId);
    }

    _scrollController.addListener(_handleScroll);
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
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
          backgroundColor: Colors.grey.shade100,
          appBar: appBarMasterEndUser('คูปองทั้งหมด'),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : voucherGroup!.code == '-9'
                  ? nodataTitle(context, "ไม่พบข้อมูลคูปอง")
                  : Column(
                      children: [
                        Container(
                          width: Get.width,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            indicatorColor: themeColorDefault,
                            indicatorWeight: 2,
                            splashFactory: NoSplash.splashFactory,
                            unselectedLabelStyle:
                                GoogleFonts.notoSansThaiLooped(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            labelStyle: GoogleFonts.notoSansThaiLooped(
                              color: themeColorDefault,
                              fontSize: 14,
                            ),
                            onTap: (index) {
                              _scrollToSection(index);
                            },
                            tabs: List.generate(
                              voucherGroup!.data.length,
                              (index) => Tab(
                                  text: voucherGroup!.data[index].groupName),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            child: Column(
                              children: [
                                ...List.generate(
                                  voucherGroup!.data.length,
                                  (index) => _buildSection(
                                      sectionKey: sectionKeys[index],
                                      title:
                                          voucherGroup!.data[index].groupName,
                                      imageUrl: voucherGroup!.data[index].image
                                          .trim(),
                                      groupId:
                                          voucherGroup!.data[index].groupId),
                                ),
                                SizedBox(
                                  height: Get.height / 1.6,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required GlobalKey sectionKey,
    required String title,
    required String imageUrl,
    required int groupId,
  }) {
    return Obx(() {
      final voucherItems = couponCtr.getVoucherItems(groupId);

      if (voucherItems == null || voucherItems.code == "-9") {
        return const SizedBox();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            key: sectionKey,
            width: Get.width,
            fit: BoxFit.cover,
            imageUrl: voucherItems.data.image.trim(),
            errorWidget: (context, url, error) {
              return Container(
                  color: Colors.white,
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey.shade200,
                    size: 34,
                  ));
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.only(left: 84.0, right: 4),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: voucherItems.data.voucherType.length,
                itemBuilder: (context, typeIndex) {
                  VoucherType voucher =
                      voucherItems.data.voucherType[typeIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          ...List.generate(voucher.vouchers.length, (index) {
                            var coupon = voucher.vouchers[index];
                            return _buildCouponCard(coupon, groupId);
                          }),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCouponCard(dynamic coupon, int groupId) {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          Card(
            shape: const RoundedRectangleBorder(),
            elevation: 0,
            child: Row(children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSansThaiLooped(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "ขั้นต่ำ ฿${myFormat.format(coupon.rewardInfo.minSpend)}",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (coupon.quotaInfo.percentageUsed.toDouble() >= 50)
                        SizedBox(
                          height: 10,
                          width: 150,
                          child: LinearPercentIndicator(
                            padding: const EdgeInsets.only(right: 40),
                            alignment: MainAxisAlignment.center,
                            animation: true,
                            lineHeight: 4.0,
                            animationDuration: 1500,
                            percent:
                                (coupon.quotaInfo.percentageUsed.toDouble()) /
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
                        ),
                      Row(
                        children: [
                          Text(
                            coupon.timeInfo.timeFormat,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              Get.to(() =>
                                  CouponDetail(couponId: coupon.couponId));
                            },
                            child: Text(
                              'เงื่อนไข',
                              style: TextStyle(
                                color: themeColorDefault,
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
                  if (coupon.quotaInfo.fullyClaimed ||
                      coupon.quotaInfo.fullyUsed) {
                    return Image.asset(
                        'assets/images/coupon/coupon_sold_out.png');
                  } else if (coupon.userStatus.isUsed) {
                    return Image.asset('assets/images/coupon/coupon_used.png');
                  } else if (!coupon.userStatus.isClaimed) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: themeColorDefault,
                        ),
                        onPressed: () async {
                          SetData data = SetData();
                          final custId = await data.b2cCustID;

                          if (custId == 0) {
                            Get.to(() => const SignInScreen());
                            return;
                          }

                          final success = await couponCtr.claimVoucher(
                              coupon.couponId, groupId);

                          if (success) {
                            dialogAlert([
                              const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 35,
                              ),
                              Text(
                                'เก็บคูปองเรียบร้อย',
                                style: GoogleFonts.notoSansThaiLooped(
                                    color: Colors.white, fontSize: 14),
                              )
                            ]);
                            Future.delayed(const Duration(milliseconds: 2000),
                                () {
                              Get.back();
                            });
                          } else {
                            dialogAlert([
                              const Icon(
                                Icons.notification_important_outlined,
                                color: Colors.white,
                                size: 35,
                              ),
                              Text(
                                'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
                                style: GoogleFonts.notoSansThaiLooped(
                                    color: Colors.white, fontSize: 14),
                              )
                            ]);
                            Future.delayed(const Duration(milliseconds: 1500),
                                () {
                              Get.back();
                            });
                          }
                        },
                        child: Text(
                          'เก็บ',
                          style: GoogleFonts.notoSansThaiLooped(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: themeColorDefault,
                          side: BorderSide(color: themeColorDefault),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: themeColorDefault),
                              borderRadius: BorderRadius.circular(4))),
                      onPressed: () async {
                        SetData data = SetData();
                        if (await data.b2cCustID == 0) {
                          Get.to(() => const SignInScreen());
                          return;
                        }
                        if (coupon.shopId == 0) {
                          Get.find<EndUserCartCtr>().fetchCartItems();
                          Get.to(() => const EndUserCart());
                        } else {
                          Get.find<BrandCtr>().fetchShopData(coupon.shopId);
                          Get.toNamed(
                            '/BrandStore/${coupon.shopId}',
                          );
                        }
                      },
                      child: Text(
                        'ใช้โค้ด',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSansThaiLooped(fontSize: 12),
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
  }
}
