import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridayonline/member/components/shimmer/shimmer.card.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.commission.ctr.dart';
import 'package:fridayonline/member/views/(affiliate)/dashboard/dashboard.dart';
import 'package:fridayonline/member/models/affiliate/dashboard.products.dart'
    as product;
import 'package:fridayonline/member/models/affiliate/option.model.dart'
    as option;
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final List<option.Datum> commissionOption = [
  option.Datum(id: 0, name: '', label: 'ทั้งหมด'),
  option.Datum(id: 1, name: 'desc', label: 'คอมมิชชั่นมาก → น้อย'),
  option.Datum(id: 2, name: 'asc', label: 'คอมมิชชั่นน้อย → มาก'),
];

class ProductPerformance extends StatefulWidget {
  const ProductPerformance({super.key});

  @override
  State<ProductPerformance> createState() => _ProductPerformanceState();
}

class _ProductPerformanceState extends State<ProductPerformance> {
  final affCommissionCtl = Get.find<AffiliateCommissionCtr>();
  late final FocusNode _searchFocus;
  late final ScrollController _scrollCtr;
  final RxBool _showBackToTop = false.obs;

  Worker? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _searchFocus = FocusNode();

    _scrollCtr = ScrollController()
      ..addListener(() {
        _showBackToTop.value = _scrollCtr.offset > 300;
        if (_scrollCtr.position.pixels >=
            _scrollCtr.position.maxScrollExtent - 200) {
          affCommissionCtl.loadMoreFilteredProducts(); // โหลดเพิ่ม
        }
      });

    // เริ่มโหลดข้อมูลครั้งแรก (ใช้ฟิลเตอร์ปัจจุบันใน controller)
    affCommissionCtl.refreshProductPerformance();

    // debounce การค้นหา 400ms แล้วค่อย refresh
    _searchDebounce = debounce<String?>(
      affCommissionCtl.searchKeyword,
      (_) => affCommissionCtl.refreshProductPerformance(),
      time: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _scrollCtr.dispose();
    _searchDebounce?.dispose();
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
        shadowColor: Colors.black.withOpacity(0.0), // <- withOpacity
        title: Text(
          'ประสิทธิภาพของสินค้า',
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF1F1F1F),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final loading =
                  affCommissionCtl.isProductPerformanceLoading.value;
              final loadingMore =
                  affCommissionCtl.isProductPerformanceLoadingMore.value;
              final data = affCommissionCtl.productPerformanceData.value;
              final total = data?.total ?? 0;
              final List<product.Product> products = data?.products ?? [];

              return Material(
                color: Colors.white,
                child: SafeArea(
                  top: false,
                  child: ListView(
                    controller: _scrollCtr,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      _filtersHeader(total),

                      if (loading)
                        ...List.generate(
                          4,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            child: ShimmerCard(
                              width: double.infinity,
                              height: 100,
                              radius: 12,
                              color: Colors.grey.shade200,
                            ),
                          ),
                        )
                      else if (!loading && products.isEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/images/affiliate/no_result.svg'),
                              Text(
                                'ไม่มีข้อมูล',
                                style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 14,
                                  color: const Color(0xFF5A5A5A),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...List.generate(products.length, (i) {
                          final p = products[i];
                          return Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                ProductPerfItem(item: p, index: i),
                              ],
                            ),
                          );
                        }),

                      // โหลดเพิ่ม
                      if (loadingMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2)),
                        ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() => _showBackToTop.value
          ? FloatingActionButton.small(
              onPressed: () => _scrollCtr.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ),
              backgroundColor: themeColorDefault,
              child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
            )
          : const SizedBox.shrink()),
    );
  }

  Widget _filtersHeader(int total) {
    final ctl = affCommissionCtl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown 2 ตัว: หมวดหมู่ / คอมมิชชั่น
          Row(
            children: [
              Expanded(
                child: SelectOption(
                  ctl: ctl,
                  type: OptionKey.category,
                  placeholder: 'หมวดหมู่',
                  onChanged: (_, __) {
                    // เมื่อเปลี่ยนหมวดหมู่ -> โหลดใหม่
                    affCommissionCtl.refreshProductPerformance();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SelectOption(
                  ctl: ctl,
                  type: OptionKey.commission,
                  placeholder: 'ค่าคอมมิชชั่นที่ได้รับ',
                  onChanged: (_, __) {
                    // เมื่อเปลี่ยนเรียงคอมมิชชั่น -> โหลดใหม่
                    affCommissionCtl.refreshProductPerformance();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 36,
            child: TextField(
              focusNode: _searchFocus,
              style: TextStyle(fontSize: 14, color: themeColorDefault),
              cursorColor: themeColorDefault,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (v) => affCommissionCtl.searchKeyword.value = v.trim(),
              onSubmitted: (_) => affCommissionCtl.refreshProductPerformance(),
              decoration: InputDecoration(
                constraints: const BoxConstraints.tightFor(height: 36),
                isDense: true,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                hintText: 'ค้นหาสินค้า',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: themeColorDefault.withOpacity(.6),
                ),
                prefixIcon: Center(
                  child: Icon(Icons.search, size: 18, color: themeColorDefault),
                ),
                prefixIconConstraints:
                    const BoxConstraints.tightFor(width: 32, height: 36),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE2E2E4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: themeColorDefault, width: 1.2),
                ),
                suffixIcon: Obx(() {
                  final hasText =
                      (affCommissionCtl.searchKeyword.value ?? '').isNotEmpty;
                  if (!hasText) return const SizedBox.shrink();
                  return IconButton(
                    icon: const Icon(Icons.clear,
                        size: 16, color: Color(0xFF9DA3AE)),
                    onPressed: () {
                      affCommissionCtl.searchKeyword.value = '';
                      _searchFocus.unfocus();
                      affCommissionCtl.refreshProductPerformance();
                    },
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'จำนวนสินค้า',
                style: GoogleFonts.ibmPlexSansThai(
                  color: const Color(0xFFB3B1B8),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '$total รายการ',
                style: GoogleFonts.ibmPlexSansThai(
                  color: const Color(0xFFB3B1B8),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SelectOption extends StatelessWidget {
  final AffiliateCommissionCtr ctl;
  final OptionKey type;
  final String placeholder;
  final bool forceReadOnly;
  final void Function(OptionKey type, int id)? onChanged; // optional callback

  const SelectOption({
    super.key,
    required this.ctl,
    required this.type,
    required this.placeholder,
    this.forceReadOnly = false,
    this.onChanged,
  });

  List<option.Datum> _items() {
    switch (type) {
      case OptionKey.category:
        return ctl.categoryOptionData;
      case OptionKey.commission:
        return commissionOption;
    }
  }

  int? _selectedId() {
    switch (type) {
      case OptionKey.category:
        return ctl.selectedCategoryId.value;
      case OptionKey.commission:
        return ctl.selectedCommissionId.value;
    }
  }

  void _setSelectedId(int id) {
    switch (type) {
      case OptionKey.category:
        ctl.selectedCategoryId.value = id;
        break;
      case OptionKey.commission:
        ctl.selectedCommissionId.value = id;
        break;
    }
    onChanged?.call(type, id);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = _items();
      final ids = items.map((e) => e.id).toSet();

      final int? sel = _selectedId();
      final int? value = (sel != null && ids.contains(sel))
          ? sel
          : (items.isNotEmpty ? items.first.id : null);

      final String? selectedLabel =
          value == null ? null : items.firstWhere((o) => o.id == value).label;

      final valueStyle =
          TextStyle(fontSize: 14, color: const Color(0xFF1F1F1F));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(placeholder,
              style: GoogleFonts.ibmPlexSansThai(
                  color: Color(0xFF5A5A5A),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: const Color(0xFFE2E2E4)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                isDense: true,
                value: value, // <- โชว์ตัวแรกถ้ายังไม่มีเลือก
                hint: Text(placeholder,
                    style: TextStyle(fontSize: 14, color: Color(0xFF9DA3AE))),
                disabledHint:
                    Text(selectedLabel ?? placeholder, style: valueStyle),
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF6B7280)),
                items: items.map((o) {
                  return DropdownMenuItem<int>(
                    value: o.id,
                    child: Text(o.label, style: valueStyle),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v == null) return;
                  _setSelectedId(v);
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
