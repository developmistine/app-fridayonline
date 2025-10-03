import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/datefilter.dart';
import 'package:fridayonline/member/components/shimmer/shimmer.card.dart';
import 'package:fridayonline/member/components/utils/share.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.commission.ctr.dart';
import 'package:fridayonline/member/models/affiliate/dashboard.overview.dart';
import 'package:fridayonline/member/views/(affiliate)/dashboard/product.performance.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fridayonline/member/models/affiliate/dashboard.products.dart'
    as product;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final affCommissionCtl = Get.find<AffiliateCommissionCtr>();

  String period = 'yesterday';
  DateTime initialStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime initialEnd = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd');

  late String selectedName;

  String _defaultMetricNameWithValue(List<DashBoardOverviewMetric> metrics) {
    for (final m in metrics) {
      final hasVal = (m.value != 0) || m.points.any((p) => p.value != 0);
      if (hasVal) return m.name;
    }
    return metrics.isNotEmpty ? metrics.first.name : '';
  }

  @override
  void initState() {
    super.initState();
    selectedName = ''; // ปล่อยว่าง: เดี๋ยวเลือกให้อัตโนมัติเมื่อข้อมูลมา

    final startStr = formatter.format(initialStart);
    final endStr = formatter.format(initialEnd);

    affCommissionCtl.getDbOverViewData(
      period: period,
      str: period == 'range' ? startStr : '',
      end: period == 'range' ? endStr : '',
    );

    affCommissionCtl.getFirstProductPerformanceSummary(
      period: period,
      str: period == 'range' ? startStr : '',
      end: period == 'range' ? endStr : '',
      limit: 5,
      offset: 0,
    );
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
        shadowColor: Colors.black.withValues(alpha: 0.0),
        title: Text(
          'ภาพรวมของฉัน',
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
          dateFilter(
            selectedPeriod: period,
            initialRangeStart: initialStart,
            initialRangeEnd: initialEnd,
            onPeriodChanged: (p) => setState(() => period = p),
            onSelected: (str, end) {
              setState(() {
                initialStart = DateTime.parse(str);
                initialEnd = DateTime.parse(end);
              });
              affCommissionCtl.selectDatefilter(period, str, end);
            },
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: SafeArea(
                top: false,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        spacing: 12,
                        children: [
                          _buildMetric(),
                          _buildProductPerformance(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric() {
    return Obx(() {
      final loading = affCommissionCtl.isDbOverviewLoading.value;
      final d = affCommissionCtl.dashboardOverviewData.value;
      final List<DashBoardOverviewMetric> metrics = d?.metrics ?? const [];

      bool metricHasAnyValue(DashBoardOverviewMetric m) {
        if (m.value != 0) return true;
        return m.points.any((p) => p.value != 0);
      }

      final bool allZero = metrics.isEmpty || !metrics.any(metricHasAnyValue);

      if (d == null || metrics.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Center(
            child: Text('ไม่มีข้อมูลช่วงที่เลือก',
                style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 14, color: const Color(0xFF5A5A5A))),
          ),
        );
      }

      String defaultMetricNameWithValue(List<DashBoardOverviewMetric> ms) {
        for (final m in ms) {
          if (metricHasAnyValue(m)) return m.name;
        }
        return ms.isNotEmpty ? ms.first.name : '';
      }

      final Set<String> allNames = metrics.map((m) => m.name).toSet();
      final String effectiveSelectedName =
          (selectedName.isNotEmpty && allNames.contains(selectedName))
              ? selectedName
              : defaultMetricNameWithValue(metrics);

      final DashBoardOverviewMetric selected = metrics.firstWhere(
          (m) => m.name == effectiveSelectedName,
          orElse: () => metrics.first);

      // เตรียมข้อมูลกราฟ
      final String dateLabel = d.date;
      final String selectedLabel = selected.label;

      final List<FlSpot> spots = List.generate(
        selected.points.length,
        (i) => FlSpot(i.toDouble(), selected.points[i].value),
      );

      final double maxY = () {
        if (selected.points.isEmpty) return 1.0;
        final m =
            selected.points.map((e) => e.value).reduce((a, b) => a > b ? a : b);
        return m == 0 ? 1.0 : m * 1.2;
      }();

      final int lastIndex = spots.isEmpty ? 0 : spots.length - 1;

      bool isInt(double v) => (v - v.roundToDouble()).abs() < 1e-6;
      String fmtInt(double v) => NumberFormat('#,##0').format(v);

      String pctStr(num r) => NumberFormat('#,##0.00').format(r.abs());
      Color pctColor(num r) => r > 0
          ? const Color(0xFF0A9338)
          : r < 0
              ? const Color(0xFFD32F2F)
              : const Color(0xFF9E9E9E);

      // แกนล่าง: ถ้าจุด > 10 ให้หารให้เหลือประมาณ 10 ช่อง
      final int totalX = selected.points.length;
      final int step = totalX > 10 ? (totalX / 10).ceil() : 1;
      final double bottomInterval = step.toDouble();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(
          children: [
            // header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ตัวชี้วัดสำคัญ',
                  style: GoogleFonts.ibmPlexSansThai(
                    color: const Color(0xFF1F1F1F),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  dateLabel,
                  style: GoogleFonts.ibmPlexSansThai(
                    color: const Color(0xFFB3B1B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            if (loading)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.28,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) => ShimmerCard(
                  width: double.infinity,
                  height: 100,
                  radius: 12,
                  color: Colors.grey.shade300,
                ),
              )
            else
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                crossAxisCount: 3,
                childAspectRatio: 1.28,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: d.metrics.map((m) {
                  final isSel = m.name == effectiveSelectedName;
                  final color = pctColor(m.ratio);
                  final pct = pctStr(m.ratio);

                  return InkWell(
                    onTap: () => setState(() => selectedName = m.name),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSel
                              ? themeColorDefault
                              : const Color(0xFFF3F3F4),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            Text(
                              m.displayValue,
                              style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  m.ratio > 0
                                      ? Icons.add
                                      : (m.ratio < 0
                                          ? Icons.remove
                                          : Icons.horizontal_rule),
                                  size: 10,
                                  color: color,
                                ),
                                Text(
                                  '$pct %',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

            if (allZero)
              SizedBox()
            else ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'แนวโน้ม$selectedLabel',
                  style: GoogleFonts.ibmPlexSansThai(
                    color: const Color(0xFF1F1F1F),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: lastIndex.toDouble(),
                    minY: 0,
                    maxY: maxY,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      verticalInterval: 1,
                      getDrawingVerticalLine: (_) =>
                          FlLine(color: Colors.transparent, strokeWidth: 1),
                      horizontalInterval: maxY / 4,
                      getDrawingHorizontalLine: (_) => const FlLine(
                          color: Color(0xFFEFEFEF), strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            if (!isInt(value)) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                fmtInt(value),
                                style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 10,
                                  color: const Color(0xFF9E9E9E),
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: bottomInterval,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= selected.points.length) {
                              return const SizedBox.shrink();
                            }
                            final label = selected.points[i].timestamp;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                label,
                                style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 10,
                                  color: const Color(0xFF9E9E9E),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: true,
                      getTouchedSpotIndicator: (barData, spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                            FlLine(
                              color: themeColorDefault.withValues(alpha: .7),
                              strokeWidth: 1.5,
                              dashArray: [4, 4],
                            ),
                            const FlDotData(show: true),
                          );
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) =>
                            const Color(0xFF1F1F1F).withValues(alpha: .92),
                        tooltipPadding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 3),
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((barSpot) {
                            final idx = barSpot.x.round();
                            final ts =
                                (idx >= 0 && idx < selected.points.length)
                                    ? selected.points[idx].timestamp
                                    : '';
                            final disp =
                                (idx >= 0 && idx < selected.points.length)
                                    ? selected.points[idx].displayValue
                                    : barSpot.y.toStringAsFixed(2);
                            return LineTooltipItem(
                              '$ts\n',
                              GoogleFonts.ibmPlexSansThai(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: disp,
                                  style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: false,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        color: themeColorDefault,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              themeColorDefault.withValues(alpha: 0.18),
                              themeColorDefault.withValues(alpha: .03),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      );
    });
  }

  Widget _buildProductPerformance() {
    return Obx(() {
      final loading = affCommissionCtl.isFirstProductPerformanceLoading.value;
      final d = affCommissionCtl.firstProductPerformanceData.value;

      final List<product.Product> all =
          (d?.products ?? const <product.Product>[]).toList();

      final List<product.Product> products =
          all.length > 5 ? all.sublist(0, 5) : all;

      final int total = d?.total ?? all.length;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ประสิทธิภาพสินค้า',
                  style: GoogleFonts.ibmPlexSansThai(
                    color: const Color(0xFF1F1F1F),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () => Get.to(() => const ProductPerformance()),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'ดูทั้งหมด',
                        style: GoogleFonts.ibmPlexSansThai(
                          color: const Color(0xFF00AEEF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00AEEF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_forward_ios_outlined,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (loading)
              ListView.separated(
                padding: EdgeInsets.only(top: 8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) => ShimmerCard(
                  width: double.infinity,
                  height: 80,
                  radius: 12,
                  color: Colors.grey.shade200,
                ),
              ),

            if (!loading && products.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/images/affiliate/no_result.svg'),
                      Text(
                        'ไม่มีข้อมูล',
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 14,
                          color: const Color(0xFF5A5A5A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // list (คงสไตล์เดิม)
            ...List.generate(products.length, (i) {
              final p = products[i];
              return Column(
                children: [
                  ProductPerfItem(item: p, index: i),
                  if (i != products.length - 1)
                    const Divider(height: 16, color: Color(0xFFF3F3F4)),
                ],
              );
            }),
          ],
        ),
      );
    });
  }
}

class ProductPerfItem extends StatelessWidget {
  const ProductPerfItem({
    super.key,
    required this.item,
    required this.index,
  });

  final product.Product item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final String title = item.title;
    final String imgPath = item.image;
    final String imgUrl = imgPath;

    final int units = _toInt(item.placedUnits);
    final double sales = _toDouble(item.placedSales);
    final double commission = _toDouble(item.commisionEstimate);
    final int ranking = index + 1;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFECECED)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: imgUrl.isNotEmpty
                        ? Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const ThumbFallback(),
                            loadingBuilder: (c, w, p) =>
                                p == null ? w : const ThumbFallback(),
                          )
                        : const ThumbFallback(),
                  ),
                ),
              ),
              if (ranking <= 3)
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 29,
                    height: 30,
                    padding: const EdgeInsets.all(2),
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.00, 0.50),
                        end: Alignment(1.00, 0.50),
                        colors: [
                          const Color(0xFF0487CC),
                          const Color(0xFF4FBBF3)
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(7),
                            topLeft: Radius.circular(7)),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Text(
                          '$ranking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.ibmPlexSansThai(
                          color: const Color(0xFF1F1F1F),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        shareDialog(
                          shareType: 'product',
                          shareTitle: 'แชร์สินค้า',
                          product: ShareProduct(
                            productId: item.productId,
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFE2F2FC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(56.39),
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/affiliate/share.svg',
                          width: 18,
                          color: themeColorDefault,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(4),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF8F8F8),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFF3F3F4),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Row(
                    spacing: 4,
                    children: [
                      Expanded(
                        child: _kv(
                          label: 'จำนวนที่ขายได้',
                          value: _numFmt.format(units),
                        ),
                      ),
                      Expanded(
                        child: _kv(
                          label: 'ยอดขาย',
                          value: '฿ ${_moneyFmt.format(sales)}',
                        ),
                      ),
                      Expanded(
                        child: _kv(
                          label: 'ค่าคอมโดยประมาณ',
                          value: '฿ ${_moneyFmt.format(commission)}',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF333333),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF333333),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class ThumbFallback extends StatelessWidget {
  const ThumbFallback({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF3F3F4),
      child: const Icon(Icons.image_not_supported_outlined,
          size: 20, color: Color(0xFFBDBDBD)),
    );
  }
}

final _numFmt = NumberFormat('#,##0');
final _moneyFmt = NumberFormat('#,##0.##');

int _toInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v?.toString() ?? '') ?? 0;
}

double _toDouble(dynamic v) {
  if (v is double) return v;
  if (v is num) return v.toDouble();
  return double.tryParse(v?.toString() ?? '') ?? 0.0;
}
