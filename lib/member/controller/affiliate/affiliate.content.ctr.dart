// lib/member/controller/affiliate/affiliate.content.ctr.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/utils/status.dialog.dart';
import 'package:fridayonline/member/models/home/home.content.model.dart';
import 'package:get/get.dart';
import 'package:fridayonline/member/services/affiliate/affiliate.service.dart';

enum AddContentField { contentName, contentType }

class AffiliateContentCtr extends GetxController {
  final _service = AffiliateService();

  /// ===== Summary (example) =====
  final volume = 0.0.obs;

  /// ===== Shop Content (เพิ่มเนื้อหา) =====
  final contentEmpty = false.obs;
  final contentTypeData = [].obs;

  /// ===== Category =====
  final categoryEmpty = false.obs;

  // fields
  final contentName = ''.obs;
  final contentTypeId = RxnInt();
  final contentNameCtrl = TextEditingController();

  // media selections
  final selectedImages = <File>[].obs; // Image / Carousel
  final Rx<File?> selectedVideo = Rx<File?>(null);
  final selectedText = ''.obs;
  final selectedProducts = <ProductContent>[].obs;
  final addingProductId = RxnInt();

  // validation state
  final isAddingProduct = false.obs;
  final isSubmitting = false.obs;

  final submittedAddContent = false.obs;
  final RxSet<AddContentField> touchedAddContent = <AddContentField>{}.obs;
  void markTouchedAddContent(AddContentField f) => touchedAddContent.add(f);

  String mapContentType(int? id) {
    switch (id) {
      case 1:
        return "image";
      case 3:
        return "video";
      case 4:
        return "text";
      case 5:
        return "product";
      default:
        return "image"; // fallback
    }
  }

  @override
  void onInit() {
    super.onInit();

    ever<int?>(contentTypeId, (_) {
      clearSelectedMedia();
    });
  }

  @override
  void onClose() {
    contentNameCtrl.dispose();
    clearAddContentData();
    super.onClose();
  }

  void onContentNameChanged(String v) => contentName.value = v;
  void onContentTypeChanged(int id) => contentTypeId.value = id;

  // ===== Validators =====
  String? vContentName(String v) {
    final t = v.trim();
    if (t.isEmpty) return null;
    if (t.length > 80) return 'ไม่เกิน 80 ตัวอักษร';
    return null;
  }

  String? vContentType(int? id) =>
      id == null ? 'กรุณาเลือกประเภทเนื้อหา' : null;

  bool get showContentNameError =>
      (submittedAddContent.value ||
          touchedAddContent.contains(AddContentField.contentName)) &&
      vContentName(contentName.value) != null;

  bool get showContentTypeError =>
      (submittedAddContent.value ||
          touchedAddContent.contains(AddContentField.contentType)) &&
      vContentType(contentTypeId.value) != null;

  String? vUploadRequired() {
    final id = contentTypeId.value;
    if (id == null || id == 0) return null;

    switch (id) {
      case 1: // Banner
      case 5: // Carousel
        return selectedImages.isEmpty
            ? 'กรุณาอัปโหลดรูปภาพอย่างน้อย 1 รูป'
            : null;

      case 3: // วิดีโอ
        return (selectedVideo.value == null) ? 'กรุณาอัปโหลดวิดีโอ' : null;

      case 4: // ข้อความ
        return selectedText.value.trim().isEmpty ? 'กรุณากรอกข้อความ' : null;

      case 2: //  สินค้า
        return selectedProducts.isEmpty
            ? 'กรุณาเลือกสินค้าอย่างน้อย 1 รายการ'
            : null;

      default:
        return null;
    }
  }

  // ===== API =====
  Future<void> getContentType() async {
    try {
      final u = await _service.getContentType();
      final ok = u?.data ?? [];
      contentTypeData.value = ok;
    } catch (_) {
      contentTypeData.value = [];
    }
  }

  Future<bool> addProduct(String tab, int contentId, int productId) async {
    if (isAddingProduct.value) return false;
    isAddingProduct.value = true;
    addingProductId.value = productId;
    try {
      final res = await _service.addProduct(
        tabType: tab,
        contentId: contentId,
        productId: productId,
      );
      if (res?.code == '100') {
        return true;
      } else {
        await showAffDialog(
            false, 'ผิดพลาด', res?.message ?? 'ไม่สามารถบันทึกข้อมูลได้');
        return false;
      }
    } catch (_) {
      await showAffDialog(false, 'ผิดพลาด', 'ไม่สามารถบันทึกข้อมูลได้');
      return false;
    } finally {
      isAddingProduct.value = false;
      addingProductId.value = null;
    }
  }

  // กดบันทึก "สร้างเนื้อหา"
  Future<bool> validateAndSubmitContent() async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;

    submittedAddContent.value = true;

    final hasNameErr = vContentName(contentName.value) != null;
    final hasTypeErr = vContentType(contentTypeId.value) != null;
    final uploadErr = vUploadRequired();

    if (hasNameErr || hasTypeErr || uploadErr != null) {
      isSubmitting.value = false;
      return false;
    }

    try {
      final res = await _service.createContent(
        type: mapContentType(contentTypeId.value),
        name: contentName.value,
        text: selectedText.value,
        products:
            selectedProducts.map((p) => {"product_id": p.productId}).toList(),
        files:
            contentTypeId.value == 3 ? [selectedVideo.value!] : selectedImages,
      );

      if (res?.code == '100') {
        await showAffDialog(true, 'สำเร็จ', 'บันทึกข้อมูลเรียบร้อย');
        clearAddContentData();
        Get.back();
      } else {
        await showAffDialog(
            false, 'ผิดพลาด', res?.message ?? 'ไม่สามารถบันทึกข้อมูลได้');
      }

      return true;
    } catch (e) {
      await showAffDialog(false, 'ผิดพลาด', 'ไม่สามารถบันทึกข้อมูลได้');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

// ลบสินค้าออกจากรายการที่เลือก
  void removeSelectedProductAt(int index) {
    if (index < 0 || index >= selectedProducts.length) return;
    selectedProducts.removeAt(index);
    selectedProducts.refresh();
  }

// ย้ายสินค้าไปบนสุด
  void moveSelectedProductToTop(int index) {
    if (index <= 0 || index >= selectedProducts.length) return;
    final item = selectedProducts.removeAt(index);
    selectedProducts.insert(0, item);
    selectedProducts.refresh();
  }

  // ===== Media helpers =====
  void addImages(List<File> files, {int? max}) {
    if (max != null) {
      final remain = (max - selectedImages.length).clamp(0, max);
      if (remain == 0) return;
      selectedImages.addAll(files.take(remain));
    } else {
      selectedImages.addAll(files);
    }
  }

  void removeImageAt(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  void clearAddContentData() {
    clearSelectedMedia();
    contentTypeId.value = null;
    contentName.value = '';
    contentNameCtrl.clear();
    submittedAddContent.value = false;
    touchedAddContent.clear();
    contentEmpty.value = false;

    selectedProducts.clear(); // << เพิ่ม
  }

  void clearSelectedMedia() {
    selectedImages.clear();
    selectedVideo.value = null;
    selectedText.value = '';
    selectedProducts.clear(); // << เพิ่ม
  }
}
