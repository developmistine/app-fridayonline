import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/edit.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fridayonline/theme.dart';

class ShopAddContent extends StatefulWidget {
  const ShopAddContent({super.key, this.contentId});
  final int? contentId;

  @override
  State<ShopAddContent> createState() => _ShopAddContentState();
}

class _ShopAddContentState extends State<ShopAddContent> {
  final affContentCtl = Get.find<AffiliateContentCtr>();
  bool get isEdit => widget.contentId != null;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // โหลดชนิดเนื้อหา
      await affContentCtl.getContentType();

      if (isEdit) {
        await affContentCtl.getAffiliateContentById(
          page: 'modify',
          target: 'content',
          contentId: widget.contentId!,
        );
      } else {
        affContentCtl.clearAddContentData();
      }
    });
  }

  @override
  void dispose() {
    affContentCtl.clearAddContentData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = affContentCtl.isLoadingContentById.value;

      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: themeColorDefault,
          title: Text(
            isEdit ? 'แก้ไขเนื้อหา' : 'เพิ่มเนื้อหา',
            style: GoogleFonts.ibmPlexSansThai(
              color: const Color(0xFF1F1F1F),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back), onPressed: Get.back),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Obx(() {
              return ElevatedButton(
                onPressed: (affContentCtl.isSubmitting.value || loading)
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
                    : Text(
                        isEdit ? 'อัพเดต' : 'บันทึก',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            }),
          ),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.white,
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        const FieldLabel(
                            title: 'ประเภทเนื้อหา', requiredMark: true),
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
                        FieldLabel(
                          title: 'ชื่อเนื้อหา',
                          counterController: affContentCtl.contentNameCtrl,
                          maxLength: 20,
                        ),
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
                        PreviewContent(
                          isEdit: isEdit,
                        ),
                        renderValidateFileText(
                            affContentCtl.contentTypeId.value ?? 0),
                        Obx(() {
                          final err = affContentCtl.vUploadRequired();
                          final show =
                              affContentCtl.submittedAddContent.value &&
                                  err != null;
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

                      final hasRemotePreview =
                          affContentCtl.previewUrls.value.trim().isNotEmpty;
                      final hasLocalImage =
                          affContentCtl.selectedImages.isNotEmpty;
                      final hasLocalVideo =
                          affContentCtl.selectedVideo.value != null;

                      final bool hideForMedia = switch (id) {
                        1 => hasRemotePreview || hasLocalImage, // image
                        5 => hasRemotePreview ||
                            hasLocalImage, // carousel (ถ้าใช้ URL เดียว)
                        3 => hasRemotePreview || hasLocalVideo, // video
                        _ => false,
                      };

                      if (hideForMedia) return const SizedBox.shrink();

                      // ของชนิดอื่น (product/text) ใช้ตรรกะนับเหมือนเดิม
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
                          target: 'content',
                          contentTypeId: id,
                          currentCount: count,
                          max: max);
                    })
                  ],
                ),
              ),
      );
    });
  }
}

// ====== Widgets ย่อย ======
class FieldLabel extends StatelessWidget {
  final String title;
  final bool requiredMark;
  final TextEditingController? counterController;
  final int? maxLength;
  const FieldLabel({
    super.key,
    required this.title,
    this.requiredMark = false,
    this.counterController,
    this.maxLength,
  });
  bool get _showCounter => counterController != null && maxLength != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
          if (_showCounter)
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: counterController!,
              builder: (context, value, _) {
                final len = value.text
                    .length; // ถ้าต้องการนับ grapheme ใช้ package:characters
                final over = len > (maxLength!);
                return Text(
                  '$len/${maxLength!}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: over
                        ? const Color(0xFFF44336)
                        : const Color(0xFF9DA3AE),
                  ),
                );
              },
            ),
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
              maxLength: field == AddContentField.contentName ? 20 : null,
              maxLines: 1,
              controller: controller,
              textInputAction: TextInputAction.next,
              onChanged: onChanged,
              decoration: InputDecoration(
                counterText: '',
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
  final bool forceReadOnly; // optional override

  const _SelectContentType({
    super.key,
    required this.ctl,
    required this.placeholder,
    required this.field,
    this.forceReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedId = ctl.contentTypeId.value;
      final items = ctl.contentTypeData;
      final bool isEditing = ctl.editingContentId.value != null;
      final bool readOnly = forceReadOnly || isEditing;

      final ids = items.map((o) => o.id as int).toSet();
      final int? dropValue =
          (selectedId != null && ids.contains(selectedId)) ? selectedId : null;
      final String? selectedLabel = dropValue == null
          ? null
          : (items.firstWhere((o) => o.id == dropValue).label as String);

      final bgColor = readOnly ? const Color(0xFFF3F4F6) : Colors.white;
      final borderColor =
          readOnly ? const Color(0xFFDCDEE3) : const Color(0xFFE2E2E4);
      final iconColor =
          readOnly ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
      final valueStyle = TextStyle(
          fontSize: 14,
          color: readOnly ? const Color(0xFF6B7280) : const Color(0xFF1F1F1F));
      final hintStyle = TextStyle(
          fontSize: 14,
          color: readOnly ? const Color(0xFFB0B8C5) : const Color(0xFF9DA3AE));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: ShapeDecoration(
              color: bgColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: IgnorePointer(
              ignoring: readOnly,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  isDense: true,
                  value: dropValue,
                  hint: Text(placeholder, style: hintStyle),
                  disabledHint: Text(
                    selectedLabel ?? placeholder,
                    style: valueStyle,
                  ),
                  icon:
                      Icon(Icons.keyboard_arrow_down_rounded, color: iconColor),
                  items: items.map((o) {
                    return DropdownMenuItem<int>(
                      value: o.id as int,
                      child: Text(o.label as String, style: valueStyle),
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
          ),
          if (readOnly) ...[
            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(Icons.lock, size: 14, color: Color(0xFF9CA3AF)),
                SizedBox(width: 6),
                Text('ไม่สามารถแก้ไขฟิลด์นี้ในโหมดแก้ไขได้',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
              ],
            ),
          ],
          if (ctl.showContentTypeError &&
              ctl.vContentType(ctl.contentTypeId.value) != null)
            const SizedBox(height: 4),
          if (ctl.showContentTypeError &&
              ctl.vContentType(ctl.contentTypeId.value) != null)
            Text(
              ctl.vContentType(ctl.contentTypeId.value)!,
              style: const TextStyle(color: Color(0xFFF44336), fontSize: 12),
            ),
        ],
      );
    });
  }
}
