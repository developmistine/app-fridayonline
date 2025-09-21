import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/edit.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fridayonline/theme.dart';

class ShopAddContent extends StatefulWidget {
  const ShopAddContent({super.key});

  @override
  State<ShopAddContent> createState() => _ShopAddContentState();
}

class _ShopAddContentState extends State<ShopAddContent> {
  final affContentCtl = Get.find<AffiliateContentCtr>();

  @override
  void initState() {
    super.initState();
    affContentCtl.getContentType();
  }

  @override
  void dispose() {
    affContentCtl.clearAddContentData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: themeColorDefault,
        title: Text(
          'เพิ่มเนื้อหา',
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF1F1F1F),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        leading:
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: Get.back),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Obx(() {
            return ElevatedButton(
              onPressed: affContentCtl.isSubmitting.value
                  ? null // disable button while submitting
                  : () => affContentCtl.validateAndSubmitContent(),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColorDefault,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: affContentCtl.isSubmitting.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'บันทึก',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            );
          }),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                const FieldLabel(title: 'ประเภทเนื้อหา', requiredMark: true),
                _SelectContentType(
                  ctl: affContentCtl,
                  placeholder: 'เลือกประเภทเนื้อหา',
                  field: AddContentField.contentType,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                const FieldLabel(title: 'ชื่อเนื้อหา'),
                InputBox(
                  controller: affContentCtl.contentNameCtrl,
                  hint: 'ชื่อเนื้อหา',
                  ctl: affContentCtl,
                  field: AddContentField.contentName,
                  onChanged: affContentCtl.onContentNameChanged,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                Obx(() {
                  final items = affContentCtl.selectedProducts.length;
                  return FieldLabel(
                    title: (affContentCtl.contentTypeId.value == 2)
                        ? 'รายการสินค้า $items รายการ'
                        : 'ตัวอย่างการแสดงผล :',
                  );
                }),
                PreviewContent(),
                Obx(() {
                  final err = affContentCtl.vUploadRequired();
                  final show =
                      affContentCtl.submittedAddContent.value && err != null;
                  if (!show) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      err,
                      style: const TextStyle(
                          color: Color(0xFFF44336), fontSize: 12),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              final id = affContentCtl.contentTypeId.value;
              if (id == null || id == 0) return const SizedBox.shrink();

              // นับจำนวนที่เลือกแล้ว
              final count = switch (id) {
                1 => affContentCtl.selectedImages.length,
                2 => affContentCtl.selectedProducts.length,
                5 => affContentCtl.selectedImages.length,
                3 => affContentCtl.selectedVideo.value == null ? 0 : 1,
                4 => affContentCtl.selectedText.value.isEmpty ? 0 : 1,
                _ => 0,
              };

              final max = switch (id) {
                1 => 1,
                2 => 20,
                5 => 10,
                3 => 1,
                4 => 1,
                _ => 0,
              };

              if (max != 0 && count >= max) {
                return const SizedBox.shrink();
              }

              return addButton(
                  contentTypeId: id, currentCount: count, max: max);
            }),
          ],
        ),
      ),
    );
  }
}

// ====== Widgets ย่อย ======
class FieldLabel extends StatelessWidget {
  final String title;
  final bool requiredMark;
  const FieldLabel({super.key, required this.title, this.requiredMark = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Color(0xFF5A5A5A),
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          if (requiredMark)
            const Text(' *',
                style: TextStyle(
                    color: Color(0xFFF44336),
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final AffiliateContentCtr ctl;
  final AddContentField field;

  const InputBox({
    super.key,
    required this.controller,
    required this.hint,
    required this.ctl,
    required this.field,
    this.onChanged,
  });

  String? _errorText() {
    switch (field) {
      case AddContentField.contentName:
        return ctl.vContentName(ctl.contentName.value);
      case AddContentField.contentType:
        return ctl.vContentType(ctl.contentTypeId.value);
    }
    return null;
  }

  bool _showError() {
    switch (field) {
      case AddContentField.contentName:
        return ctl.showContentNameError;
      case AddContentField.contentType:
        return ctl.showContentTypeError;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (f) {
            if (!f) ctl.markTouchedAddContent(field);
          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFE2E2E4)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.next,
              onChanged: onChanged,
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: hint,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color(0xFF9DA3AE), fontSize: 14),
              ),
              style: const TextStyle(color: Color(0xFF1F1F1F), fontSize: 14),
            ),
          ),
        ),

        // Error line
        Obx(() {
          final show = _showError();
          final err = _errorText();
          if (!show || err == null) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              err,
              style: const TextStyle(color: Color(0xFFF44336), fontSize: 12),
            ),
          );
        }),
      ],
    );
  }
}

class _SelectContentType extends StatelessWidget {
  final AffiliateContentCtr ctl;
  final String placeholder;
  final AddContentField field;

  const _SelectContentType({
    super.key,
    required this.ctl,
    required this.placeholder,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    final drop = Obx(() {
      final selectedId = ctl.contentTypeId.value;
      final items = ctl.contentTypeData;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFE2E2E4)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                isDense: true,
                value: selectedId,
                hint: const Text(
                  'เลือกประเภทเนื้อหา',
                  style: TextStyle(color: Color(0xFF9DA3AE), fontSize: 14),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF6B7280),
                ),
                items: items.map((o) {
                  return DropdownMenuItem<int>(
                    value: o.id,
                    child: Text(
                      o.label,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF1F1F1F)),
                    ),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v == null) return;
                  ctl.onContentTypeChanged(v);
                  ctl.markTouchedAddContent(AddContentField.contentType);
                },
              ),
            ),
          ),
        ],
      );
    });

    final errorLine = Obx(() {
      final _ = (
        ctl.contentTypeId.value,
        ctl.submittedAddContent.value,
        ctl.touchedAddContent.length
      );

      final err = ctl.vContentType(ctl.contentTypeId.value);
      final show = ctl.showContentTypeError;
      if (!show || err == null) return const SizedBox.shrink();

      return const SizedBox(height: 4);
    });

    final errorText = Obx(() {
      final _ = (
        ctl.contentTypeId.value,
        ctl.submittedAddContent.value,
        ctl.touchedAddContent.length
      );

      final err = ctl.vContentType(ctl.contentTypeId.value);
      final show = ctl.showContentTypeError;
      if (!show || err == null) return const SizedBox.shrink();

      return Text(
        err,
        style: const TextStyle(color: Color(0xFFF44336), fontSize: 12),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [drop, errorLine, errorText],
    );
  }
}
