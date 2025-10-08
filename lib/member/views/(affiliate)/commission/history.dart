import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/datepicker.dart';
import 'package:fridayonline/member/components/shimmer/shimmer.card.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.commission.ctr.dart';
import 'package:fridayonline/member/views/(affiliate)/commission/earns.dart';
import 'package:fridayonline/member/views/(affiliate)/commission/orders.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

final historyTabs = [
  {"name": "ประวัติรายการ", "key": "orders"},
  {"name": "รายรับของฉัน", "key": "earnings"},
];

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  final affCommissionCtl = Get.find<AffiliateCommissionCtr>();

  late final TabController _tab;
  DateTime initialStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime initialEnd = DateTime.now();

  final formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    final startStr = formatter.format(initialStart);
    final endStr = formatter.format(initialEnd);

    affCommissionCtl.getCommissionSummary(
        page: 'orders', period: 'range', str: startStr, end: endStr);
    affCommissionCtl.getCommissionSummary(
        page: 'earnings', period: 'month', str: startStr, end: endStr);

    _tab = TabController(length: historyTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
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
          'ประวัติรายการ',
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF1F1F1F),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          // Gradient header (fixed height)
          Container(
            height: 120,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
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
                Obx(() {
                  final affCommissionCtl = Get.find<AffiliateCommissionCtr>();
                  final summary = affCommissionCtl.commissionOrdersData.value;
                  final periodText = summary?.period ?? '-';

                  if (affCommissionCtl.isCommissionOrdersLoading.value ||
                      affCommissionCtl.isCommissionEarnsLoading.value) {
                    return Center(
                      child: Column(
                        spacing: 8,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShimmerCard(
                            width: 100,
                            height: 12,
                            radius: 6,
                            color: Colors.white24,
                          ),
                          ShimmerCard(
                            width: 170,
                            height: 16,
                            radius: 6,
                            color: Colors.white24,
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ช่วงระยะเวลา :',
                          style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final range = await showRangePickerBottomSheet(
                                initialStart: initialStart,
                                initialEnd: initialEnd,
                                period: _tab.index == 0 ? 'range' : 'month');

                            if (range != null) {
                              final startStr = range["start"]!;
                              final endStr = range["end"]!;

                              setState(() {
                                initialStart = DateTime.parse(startStr);
                                initialEnd = DateTime.parse(endStr);
                              });

                              affCommissionCtl.selectedDate(startStr, endStr,
                                  _tab.index == 0 ? 'range' : 'month');
                              // printWhite('$startStr - $endStr');
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                periodText,
                                style: GoogleFonts.ibmPlexSansThai(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
          const SizedBox(height: 10),
          Material(
            color: Colors.white, // <- tab background
            child: TabBar(
              controller: _tab,
              indicatorColor: themeColorDefault,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: themeColorDefault,
              unselectedLabelColor: const Color(0xFF393939),
              labelStyle: GoogleFonts.ibmPlexSansThai(
                  fontSize: 14, fontWeight: FontWeight.w500),
              unselectedLabelStyle: GoogleFonts.ibmPlexSansThai(
                  fontSize: 14, fontWeight: FontWeight.w500),
              tabs: historyTabs
                  .map((v) => Tab(height: 42, text: v['name'] as String))
                  .toList(),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _OrdersList(),
                _EarningsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AffiliateCommissionCtr>();

    return Obx(() {
      final summary = c.commissionOrdersData.value;
      final orders = summary?.commission ?? [];

      if (c.isCommissionOrdersLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (orders.isEmpty) {
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/search/zero_search.png',
                    width: 120),
              ),
              Text('ไม่พบประวัติรายการ',
                  style: GoogleFonts.ibmPlexSansThai(fontSize: 14)),
            ],
          ),
        );
      }

      return SafeArea(
        top: false,
        child: ListView.separated(
          itemCount: orders.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: Color(0xFFF3F3F4)),
          itemBuilder: (context, index) {
            final item = orders[index];
            final date = item.displayDate;
            final totalOrders = item.summary.totalOrders;
            final totalAmount = item.summary.totalAmount;

            return InkWell(
              onTap: () => Get.to(() => Orders(
                  str: item
                      .date)), // ระวัง type: ถ้าเป็น DateTime แปลงเป็น String ก่อน
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(date,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF1F1F1F))),
                          const SizedBox(height: 2),
                          Text(totalOrders,
                              style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF5A5A5A))),
                        ],
                      ),
                    ),
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
                                  color: const Color(0xFF1F1F1F)),
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
      );
    });
  }
}

class _EarningsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AffiliateCommissionCtr>();

    return Obx(() {
      final summary = c.commissionEarnsData.value;
      final earns = summary?.commission ?? [];

      if (c.isCommissionEarnsLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (earns.isEmpty) {
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/search/zero_search.png',
                    width: 120),
              ),
              Text('ไม่พบประวัติรายรับ',
                  style: GoogleFonts.ibmPlexSansThai(fontSize: 14)),
            ],
          ),
        );
      }

      return SafeArea(
        top: false,
        child: ListView.separated(
          itemCount: earns.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: Color(0xFFF3F3F4)),
          itemBuilder: (context, index) {
            final item = earns[index];
            final date = item.displayDate;
            final totalAmount = item.summary.totalAmount;

            final status = item.status;
            final statusLabel = status?.label ?? '';
            final statusBg = _hexToColor(status?.colorCode ?? '#fafafafa');

            return InkWell(
              onTap: () => Get.to(() => Earns(str: item.date)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(date,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF1F1F1F))),
                          const SizedBox(height: 2),
                          StatusChip(label: statusLabel, bg: statusBg),
                        ],
                      ),
                    ),
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
                                  color: const Color(0xFF1F1F1F)),
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
      );
    });
  }
}

Color _hexToColor(String hex) {
  var h = hex.replaceAll('#', '');
  if (h.length == 6) h = 'FF$h';
  return Color(int.parse(h, radix: 16));
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color bg;
  const StatusChip({super.key, required this.label, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      decoration: ShapeDecoration(
        color: bg.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(
        label,
        style: GoogleFonts.ibmPlexSansThai(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: bg,
        ),
      ),
    );
  }
}
