import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/product.dart';
import 'package:fridayonline/member/components/showproduct/nodata.dart';
import 'package:fridayonline/member/components/utils/status.dialog.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.product.ctr.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart';
import 'package:fridayonline/member/models/affiliate/option.model.dart'
    as option;

import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<List<AffiliateProduct>?> addProductDrawer({
  required String target,
  bool single = false,
}) async {
  final affContentCtl = Get.find<AffiliateContentCtr>();
  final affProductCtl = Get.find<AffiliateProductCtr>();

  final RxSet<int> selected = <int>{}.obs;
  if (!single) {
    final presetIds = affContentCtl.selectedProducts
        .map((p) => p.productId)
        .whereType<int>()
        .toSet();
    selected.addAll(presetIds);
  }

  return Get.bottomSheet<List<AffiliateProduct>>(
    _AddProductSheet(
      single: single,
      target: target,
      affContentCtl: affContentCtl,
      affProductCtl: affProductCtl,
      presetSelected: selected,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .35),
    enableDrag: true,
  );
}

class _AddProductSheet extends StatefulWidget {
  const _AddProductSheet({
    required this.single,
    required this.affContentCtl,
    required this.affProductCtl,
    required this.presetSelected,
    required this.target,
  });

  final bool single;
  final AffiliateContentCtr affContentCtl;
  final AffiliateProductCtr affProductCtl;
  final RxSet<int> presetSelected;
  final String target;

  @override
  __AddProductSheetState createState() => __AddProductSheetState();
}

class __AddProductSheetState extends State<_AddProductSheet> {
  late final ScrollController _scrollCtr;
  late final FocusNode _searchFocus;
  final RxBool _showBackToTop = false.obs;

  @override
  void initState() {
    super.initState();
    affProductCtl.pageTarget.value = widget.target;

    _scrollCtr = ScrollController()
      ..addListener(() {
        _showBackToTop.value = _scrollCtr.offset > 300;
        if (_scrollCtr.position.pixels >=
            _scrollCtr.position.maxScrollExtent - 200) {
          widget.affProductCtl.loadMoreFilteredProducts();
        }
      });
    _searchFocus = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.affProductCtl.refreshFilteredProducts();
    });
  }

  @override
  void dispose() {
    _scrollCtr.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final affProduct = widget.affProductCtl;
    final selected = widget.presetSelected;
    final single = widget.single;
    // final items = affProduct.filterProductData;

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scrollCtr = ScrollController();
          final showBackToTop = false.obs;
          var listenerAdded = false;

          if (!listenerAdded) {
            listenerAdded = true;
            scrollCtr.addListener(() {
              showBackToTop.value = scrollCtr.offset > 300; // เกิน 300px
            });
          }

          return SizedBox(
            height: constraints.maxHeight * 0.92,
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.black87,
                            ),
                            Text(
                              'เพิ่มรายการสินค้า',
                              style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'ปิด',
                        onPressed: () {
                          Get.back(result: null);
                          affProduct.filterProductData.clear();
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      CustomScrollView(
                        controller: _scrollCtr,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                children: [
                                  const SizedBox(height: 4),
                                  Row(children: [
                                    Expanded(
                                        child: SelectOption(
                                            ctl: affProduct,
                                            type: OptionKey.category,
                                            placeholder: 'หมวดหมู่')),
                                    const SizedBox(width: 6),
                                    Expanded(
                                        child: SelectOption(
                                            ctl: affProduct,
                                            type: OptionKey.commission,
                                            placeholder:
                                                'ค่าคอมมิชชั่นที่ได้รับ')),
                                  ]),
                                  const SizedBox(height: 4),
                                  Row(children: [
                                    Expanded(
                                        child: SelectOption(
                                            ctl: affProduct,
                                            type: OptionKey.store,
                                            placeholder: 'ร้านค้า')),
                                    const SizedBox(width: 6),
                                    Expanded(
                                        child: SelectOption(
                                            ctl: affProduct,
                                            type: OptionKey.brand,
                                            placeholder: 'แบรนด์')),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 8)),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: SizedBox(
                                height: 36,
                                child: TextField(
                                  focusNode: _searchFocus,
                                  style: TextStyle(
                                      fontSize: 14, color: themeColorDefault),
                                  cursorColor: themeColorDefault,
                                  textAlignVertical: TextAlignVertical.center,
                                  onChanged: (v) => affProduct.searchKeyword
                                      .value = v.trim(), // หรือ (_) {}
                                  decoration: InputDecoration(
                                    constraints: const BoxConstraints.tightFor(
                                        height: 36),
                                    isDense: true,
                                    isCollapsed: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    hintText: 'ค้นหาสินค้า',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color:
                                            themeColorDefault.withOpacity(.6)),
                                    prefixIcon: Center(
                                        child: Icon(Icons.search,
                                            size: 18,
                                            color: themeColorDefault)),
                                    prefixIconConstraints:
                                        const BoxConstraints.tightFor(
                                            width: 32, height: 36),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFE2E2E4)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: themeColorDefault, width: 1.2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 8)),
                          Obx(() {
                            final list = affProduct.filterProductData;

                            final safeBottom =
                                MediaQuery.of(context).padding.bottom;

                            return SliverPadding(
                              padding: EdgeInsets.fromLTRB(
                                  12, 0, 12, widget.single ? safeBottom : 0),
                              sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  childAspectRatio: 0.62,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final p = list[index];
                                    final id = p.productId;

                                    if (widget.single) {
                                      return Obx(() {
                                        final isSelected =
                                            selected.contains(id);
                                        final isLoadingThis = affProduct
                                                .isAddingProduct.value &&
                                            affProduct.addingProductId.value ==
                                                id;

                                        return Stack(
                                          key: ValueKey(id),
                                          children: [
                                            productItem(
                                                product: p, showShare: false),
                                            Positioned(
                                              bottom: 16,
                                              right: 16,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                onTap: (isSelected ||
                                                        isLoadingThis)
                                                    ? null
                                                    : () async {
                                                        // ทำให้ปุ่มเทาทันที เพื่อ UX ที่ชัดระหว่างรอ API
                                                        selected.add(id);
                                                        final ok =
                                                            await affProduct
                                                                .addProduct(
                                                                    'product',
                                                                    0,
                                                                    id);
                                                        if (!ok) {
                                                          // ถ้า fail ค่อย rollback
                                                          selected.remove(id);
                                                        }
                                                      },
                                                child: Container(
                                                  width: 34,
                                                  height: 34,
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    // เท่าทั้งตอนกำลังโหลด และตอนเลือกเสร็จ
                                                    color: (isSelected ||
                                                            isLoadingThis)
                                                        ? Colors.grey.shade400
                                                        : themeColorDefault,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: isLoadingThis
                                                      ? const SizedBox(
                                                          width: 22,
                                                          height: 22,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/images/affiliate/add_bag.svg',
                                                          width: 22,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                    }
                                    // multi select
                                    return Obx(() {
                                      final isSelected = selected.contains(id);
                                      return Stack(
                                        key: ValueKey(id),
                                        children: [
                                          productItem(
                                            showShare: false,
                                            product: p,
                                            onTap: () async {
                                              final already =
                                                  selected.contains(id);
                                              if (already) {
                                                selected.remove(id);
                                                selected.refresh();
                                                return;
                                              }
                                              if (selected.length >= 20) {
                                                await showSmallDialog(
                                                    'เลือกสินค้าได้สูงสุด 20 รายการ');
                                                return;
                                              }

                                              selected.add(id);
                                              selected.refresh();
                                            },
                                          ),
                                          Positioned(
                                            top: 14,
                                            right: 14,
                                            child: CircleAvatar(
                                              radius: 12,
                                              backgroundColor: isSelected
                                                  ? themeColorDefault
                                                  : Colors.white,
                                              child: Icon(
                                                  isSelected
                                                      ? Icons.check
                                                      : Icons.add,
                                                  size: 16,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : const Color(
                                                          0xFF6B7280)),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                                  },
                                  childCount: list.length,
                                ),
                              ),
                            );
                          }),
                          Obx(() {
                            if (!affProduct.isLoadingMoreFilter.value) {
                              return const SliverToBoxAdapter();
                            }
                            return const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2)),
                              ),
                            );
                          }),
                        ],
                      ),

                      Obx(() => affProduct.isLoadingFilter.value
                          ? Positioned.fill(
                              child: IgnorePointer(
                                child: Center(
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            )
                          : affProduct.filterProductData.isNotEmpty
                              ? SizedBox()
                              : nodata(context)),

                      // === ปุ่ม Back to Top (Box) ===
                      Obx(() {
                        if (!_showBackToTop.value) {
                          return const SizedBox.shrink();
                        }
                        final safeBottom =
                            MediaQuery.of(context).padding.bottom;

                        return Positioned(
                          right: 16,
                          bottom: safeBottom,
                          child: FloatingActionButton.small(
                            heroTag: 'backToTop',
                            backgroundColor:
                                Colors.black87.withValues(alpha: 0.3),
                            onPressed: () {
                              _searchFocus.unfocus();
                              _scrollCtr.animateTo(
                                0,
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeOutCubic,
                              );
                            },
                            child: const Icon(Icons.keyboard_arrow_up,
                                color: Colors.white),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                if (single)
                  SizedBox()
                else
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                      child: Obx(() {
                        final canSubmit = selected.isNotEmpty;
                        return ElevatedButton(
                          onPressed: canSubmit
                              ? () {
                                  final selectedList = affProduct
                                      .filterProductData
                                      .where(
                                          (p) => selected.contains(p.productId))
                                      .toList();

                                  Get.back(result: selectedList);
                                  affProduct.filterProductData.clear();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(44),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            canSubmit
                                ? 'ยืนยัน (${selected.length} รายการ)'
                                : 'เลือกสินค้า',
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SelectOption extends StatelessWidget {
  final AffiliateProductCtr ctl;
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
      case OptionKey.brand:
        return ctl.brandOptionData;
      case OptionKey.commission:
        return ctl.commissionOptionData;
      case OptionKey.store:
        return ctl.storeOptionData;
    }
  }

  int? _selectedId() {
    switch (type) {
      case OptionKey.category:
        return ctl.selectedCategoryId.value;
      case OptionKey.brand:
        return ctl.selectedBrandId.value;
      case OptionKey.commission:
        return ctl.selectedCommissionId.value;
      case OptionKey.store:
        return ctl.selectedStoreId.value;
    }
  }

  void _setSelectedId(int id) {
    switch (type) {
      case OptionKey.category:
        ctl.selectedCategoryId.value = id;
        break;
      case OptionKey.brand:
        ctl.selectedBrandId.value = id;
        break;
      case OptionKey.commission:
        ctl.selectedCommissionId.value = id;
        break;
      case OptionKey.store:
        ctl.selectedStoreId.value = id;
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

          // ไม่มี validate → ตัดส่วนแสดง error ออก
        ],
      );
    });
  }
}
