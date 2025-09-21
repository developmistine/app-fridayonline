import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.product.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/product.dart';
import 'package:fridayonline/member/components/utils/status.dialog.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:fridayonline/member/models/home/home.content.model.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<List<ProductContent>?> addProductDrawer({
  bool single = false,
}) async {
  final affContentCtl = Get.find<AffiliateContentCtr>();
  final List<Map<String, dynamic>> items =
      ((productData[0]['products'] as List?) ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

  final RxSet<int> selected = <int>{}.obs;
  if (!single) {
    final presetIds = affContentCtl.selectedProducts
        .map((p) =>
            p.productId) // ถ้าโมเดลใช้ productId ให้เปลี่ยนเป็น p.productId
        .whereType<int>()
        .toSet();
    selected.addAll(presetIds);
  }

  return Get.bottomSheet<List<ProductContent>>(
    Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: LayoutBuilder(
        builder: (context, constraints) {
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
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'เลือกสินค้า',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        tooltip: 'ปิด',
                        onPressed: () => Get.back(result: null),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // รายการสินค้า
                Expanded(
                  child: SafeArea(
                    top: false,
                    bottom: single ? true : false,
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: single ? 0.66 : 0.72,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final p = items[index];
                        final id = (p['product_id'] as num?)?.toInt();
                        if (id == null) return const SizedBox.shrink();
                        final product = ProductContent.fromJson(p);

                        // -------- โหมดเลือกเดียว --------
                        if (single) {
                          return Obx(() {
                            final isSelected = selected.contains(id);
                            final isLoadingThis =
                                affContentCtl.isAddingProduct.value &&
                                    affContentCtl.addingProductId.value == id;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: 2,
                              children: [
                                productItem(product: product),
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: (isSelected || isLoadingThis)
                                      ? null
                                      : () async {
                                          final ok = await affContentCtl
                                              .addProduct('product', 0, id);
                                          if (ok) {
                                            selected.add(id);
                                          }
                                        },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.grey.shade400
                                          : (isLoadingThis
                                              ? Colors.grey.shade300
                                              : themeColorDefault),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: isLoadingThis
                                        ? Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            isSelected ? 'Added' : 'Add',
                                            style: GoogleFonts.ibmPlexSansThai(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            );
                          });
                        }

                        // -------- โหมดหลายอัน --------
                        return Obx(() {
                          final isSelected = selected.contains(id);
                          return Stack(
                            children: [
                              productItem(
                                product: product,
                                onTap: () {
                                  if (isSelected) {
                                    selected.remove(id);
                                  } else {
                                    selected.add(id);
                                  }
                                },
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: isSelected
                                      ? themeColorDefault
                                      : Colors.white,
                                  child: Icon(
                                    isSelected ? Icons.check : Icons.add,
                                    size: 16,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                      },
                    ),
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
                                  final selectedList = items
                                      .where((p) =>
                                          selected.contains(p["product_id"]))
                                      .map((p) => ProductContent.fromJson(p))
                                      .toList();

                                  Get.back(result: selectedList);
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
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.35),
    enableDrag: true,
  );
}
