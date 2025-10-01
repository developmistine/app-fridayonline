import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/shimmer/shimmer.card.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.commission.ctr.dart';
import 'package:fridayonline/member/models/affiliate/commission.sumearning.model.dart'
    as earn;
import 'package:fridayonline/member/models/affiliate/commission.sumorder.model.dart'
    as order;
import 'package:fridayonline/member/views/(affiliate)/commission/condition.dart';
import 'package:fridayonline/member/views/(affiliate)/commission/history.dart';
import 'package:fridayonline/member/views/(affiliate)/commission/orders.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Commission extends StatefulWidget {
  const Commission({super.key});

  @override
  State<Commission> createState() => _CommissionState();
}

class _CommissionState extends State<Commission> {
  final affCommissionCtl = Get.find<AffiliateCommissionCtr>();

  @override
  void initState() {
    super.initState();
    affCommissionCtl.getFirstCommissionSummary(page: 'orders');
    affCommissionCtl.getCommissionBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: themeColorDefault,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: Get.back,
          ),
          shadowColor: Colors.black.withValues(alpha: 0.4),
          title: Text(
            'ค่าคอมมิชชั่นของฉัน',
            style: GoogleFonts.ibmPlexSansThai(
              color: const Color(0xFF1F1F1F),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        body: Column(
          spacing: 12,
          children: [
            Container(
              height: 190,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.46, 0.00),
                  end: Alignment(0.46, 1.00),
                  colors: [Color(0xFF2291F5), Color(0xFF2EA9E1)],
                ),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/profileimg/background.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  _buildCommissionHeader(),
                ],
              ),
            ),
            _buildCommissionMenu(),
            Obx(() {
              final affCommissionCtl = Get.find<AffiliateCommissionCtr>();
              final summary = affCommissionCtl.firstCommissionOrdersData.value;
              final orders = summary?.commission ?? [];

              if (affCommissionCtl.isFirstCommissionOrdersLoading.value) {
                return Expanded(
                    child: Center(child: CircularProgressIndicator()));
              }
              return _buildCommissionHistory(orders);
            })
          ],
        ));
  }
}

Widget _buildCommissionHeader() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 4,
      children: [
        Text(
          'คอมมิชชั่นคงเหลือ :',
          style: GoogleFonts.ibmPlexSansThai(
            color: Colors.white /* Text-neutral_alt_white */,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Obx(() {
          final affCommissionCtl = Get.find<AffiliateCommissionCtr>();
          final balance = affCommissionCtl.commissionBalanceData.value;
          final value = balance?.balance ?? '฿0';

          if (affCommissionCtl.isCommissionBalanceLoading.value) {
            return ShimmerCard(
              width: 170,
              height: 28,
              radius: 6,
              color: Colors.white24,
            );
          }
          return InkWell(
            onTap: () {
              Get.to(() => History());
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 4,
              children: [
                Text(
                  value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexSansThai(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 20,
                  color: Colors.white,
                )
              ],
            ),
          );
        }),
        Obx(() {
          final affCommissionCtl = Get.find<AffiliateCommissionCtr>();
          final balance = affCommissionCtl.commissionBalanceData.value;
          final text = balance?.description ?? '-';

          if (affCommissionCtl.isCommissionBalanceLoading.value) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: const Column(
                spacing: 6,
                children: [
                  ShimmerCard(
                    width: 100,
                    height: 14,
                    radius: 2,
                    color: Colors.white24,
                  ),
                  ShimmerCard(
                    width: 170,
                    height: 14,
                    radius: 2,
                    color: Colors.white24,
                  ),
                ],
              ),
            );
          }
          return Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSansThai(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          );
        })
      ],
    ),
  );
}

Widget _buildCommissionMenu() {
  return InkWell(
    onTap: () {
      Get.to(() => Conditions());
    },
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: ShapeDecoration(
        color: Colors.white /* CI-Band-White */,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFFF3F3F4) /* Stroke-disabled */,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                SizedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Color(0xFF8C8A94),
                      ),
                      Text(
                        'กฎค่านายหน้าของตัวแทน',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.ibmPlexSansThai(
                          color: const Color(0xFF5A5A5A),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16,
                  color: Color(0xFF8C8A94),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCommissionHistory(List<order.Commission> orders) {
  if (orders.isEmpty) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/search/zero_search.png',
              width: 120,
            ),
          ),
          Text(
            'ไม่พบประวัติรายการ',
            style: GoogleFonts.ibmPlexSansThai(fontSize: 14),
          )
        ],
      ),
    );
  }

  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ประวัติรายการ',
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => History());
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      'ดูทั้งหมด',
                      style: GoogleFonts.ibmPlexSansThai(
                        color: const Color(0xFF00AEEF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00AEEF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SafeArea(
            top: false,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFF3F3F4)),
              itemBuilder: (context, index) {
                final item = orders[index];
                final date = item.displayDate;
                final summary = item.summary;
                final totalOrders = summary.totalOrders;
                final totalAmount = summary.totalAmount;

                return InkWell(
                  onTap: () {
                    Get.to(() => Orders(str: item.date));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: date + orders
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF1F1F1F),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                totalOrders,
                                style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF5A5A5A),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right: amount + chevron
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  totalAmount,
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF1F1F1F),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward_ios_outlined,
                                  size: 16, color: Color(0xFF8C8A94)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}
