// lib/member/controller/affiliate/affiliate.content.ctr.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/utils/status.dialog.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart'
    as content;
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:fridayonline/member/services/affiliate/affiliate.service.dart';

enum AddContentField { contentName, contentType }

class LoadListState<T> {
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final RxList<T> items = <T>[].obs;

  int _reqId = 0;
  int nextReqId() => ++_reqId;

  bool get isEmpty => items.isEmpty;
}

class AffiliateContentCtr extends GetxController {
  final _service = AffiliateService();

  final volume = 0.0.obs;

  final categoryEmpty = false.obs;
  final contentEmpty = false.obs;
  final contentTypeData = [].obs;

  final RxList<content.ContentData> viewContentData =
      <content.ContentData>[].obs;
  final RxList<content.ContentData> viewCategoryData =
      <content.ContentData>[].obs;
  final RxList<content.ContentData> editContentData =
      <content.ContentData>[].obs;
  final RxList<content.ContentData> editCategoryData =
      <content.ContentData>[].obs;
  final RxList<content.ContentData> editContentDataById =
      <content.ContentData>[].obs;
  final RxList<content.ContentData> editCategoryDataById =
      <content.ContentData>[].obs;

  final isLoadingContentView = false.obs;
  final isLoadingCategoryView = false.obs;
  final isLoadingContentEdit = false.obs;
  final isLoadingCategoryEdit = false.obs;
  final isLoadingContentById = false.obs;

  // fields
  final contentName = ''.obs;
  final contentTypeId = RxnInt();
  final contentNameCtrl = TextEditingController();

  // media selections
  final RxnInt editingContentId = RxnInt();
  final selectedImages = <File>[].obs; // Image / Carousel
  final Rx<File?> selectedVideo = Rx<File?>(null);
  final selectedText = ''.obs;
  final selectedProducts = <AffiliateProduct>[].obs;
  final RxString previewUrls = ''.obs;

  // validation state
  final isSubmitting = false.obs;

  final submittedAddContent = false.obs;
  final RxSet<AddContentField> touchedAddContent = <AddContentField>{}.obs;
  void markTouchedAddContent(AddContentField f) => touchedAddContent.add(f);

  final bool _suspendAutoClearOnTypeChange = false;

  RxBool _pickLoadingFlag(String page, String target) {
    if (page == 'view' && target == 'content') return isLoadingContentView;
    if (page == 'view' && target == 'category') return isLoadingCategoryView;
    if (page == 'modify' && target == 'content') return isLoadingContentEdit;
    return isLoadingCategoryEdit; // modify + category
  }

  String mapContentType(int? id) {
    switch (id) {
      case 1:
        return "image";
      case 2:
        return "product";
      case 3:
        return "video";
      case 4:
        return "text";
      default:
        return "image"; // fallback
    }
  }

  @override
  void onInit() {
    super.onInit();

    ever<int?>(contentTypeId, (_) {
      if (_suspendAutoClearOnTypeChange) return;
      clearSelectedMedia(); // ← ยังล้างสื่อเมื่อ user เปลี่ยน type เอง
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
  String? vContentName(String v, {bool category = false}) {
    final t = v.trim();
    if (t.isEmpty) return null;

    if (t.length > 20) return 'จำกัดไม่เกิน 20 ตัวอักษร';
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
    final isEdit = editingContentId.value != null;
    if (id == null || id == 0) return 'กรุณาเลือกประเภทเนื้อหา';

    switch (id) {
      case 1: // Banner
      case 5: // Carousel
        if (selectedImages.isNotEmpty) return null;
        if (isEdit && previewUrls.value.trim().isNotEmpty) return null;
        return 'กรุณาอัปโหลดรูปภาพอย่างน้อย 1 รูป';

      case 3: // วิดีโอ
        if (selectedVideo.value != null) return null;
        if (isEdit && previewUrls.value.trim().isNotEmpty) return null;
        return 'กรุณาอัปโหลดวิดีโอ';

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

  int? _typeIdFromString(String? t) {
    switch (t) {
      case 'Image':
        return 1;
      case 'Category':
      case 'Product':
        return 2;
      case 'Video':
        return 3;
      case 'Text':
        return 4;
      case 'Carousel':
        return 5;
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

  Future<void> sortContent(String target, int contentId) async {
    final targetForApi = target == 'category' ? 'categories' : 'contents';
    try {
      await _service.sortContent(target: targetForApi, contentId: contentId);
      moveContentToTopEverywhere(
        target: target,
        itemId: contentId,
      );
    } catch (_) {}
  }

  Future<void> hideContent(String target, int contentId, String status) async {
    try {
      await _service.hideContent(
          target: target, contentId: contentId, status: status);
      changeStatusEverywhere(target: target, itemId: contentId, status: status);
    } catch (_) {}
  }

  Future<bool> deleteContent(
    String tab,
    int contentId,
  ) async {
    try {
      final res = await _service.deleteContent(
        tabType: tab,
        contentId: contentId,
      );
      if (res?.code == '100') {
        _removeItemEverywhere(target: tab, itemId: contentId);
        await showAffDialog(true, 'สำเร็จ', 'ลบข้อมูลเรียบร้อยแล้ว');
        return true;
      } else {
        await showAffDialog(
            false, 'ผิดพลาด', res?.message ?? 'ไม่สามารถบันทึกข้อมูลได้');
        return false;
      }
    } catch (_) {
      await showAffDialog(false, 'ผิดพลาด', 'ไม่สามารถบันทึกข้อมูลได้');
      return false;
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
      final isEdit = editingContentId.value != null;
      loadingAffiliate(true);

      final res = isEdit
          ? await _service.updateContent(
              contentId: editingContentId.value ?? 0,
              type: mapContentType(contentTypeId.value),
              name: contentName.value,
              text: selectedText.value,
              products: selectedProducts.map((p) => p.productId).toList(),
              files: contentTypeId.value == 3
                  ? selectedVideo.value != null
                      ? [selectedVideo.value!]
                      : []
                  : selectedImages,
            )
          : await _service.createContent(
              type: mapContentType(contentTypeId.value),
              name: contentName.value,
              text: selectedText.value,
              products: selectedProducts
                  .map((p) => {"product_id": p.productId})
                  .toList(),
              files: contentTypeId.value == 3
                  ? selectedVideo.value != null
                      ? [selectedVideo.value!]
                      : []
                  : selectedImages,
            );

      await loadingAffiliate(false);
      if (res?.code == '100') {
        await showAffDialog(true, 'สำเร็จ', 'บันทึกข้อมูลเรียบร้อย');
        clearAddContentData();
        await Future.wait([
          getAffiliateContent(page: 'view', target: 'content', contentId: 0),
          getAffiliateContent(page: 'modify', target: 'content', contentId: 0),
        ]);
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
      await loadingAffiliate(false);
      isSubmitting.value = false;
    }
  }

  // กดบันทึก "สร้างหมวดหมู่"
  Future<bool> validateAndSubmitCategory() async {
    if (isSubmitting.value) return false;

    isSubmitting.value = true;
    submittedAddContent.value = true;

    final hasNameErr = vContentName(contentName.value, category: true) != null;
    final uploadErr = vUploadRequired();
    if (hasNameErr || uploadErr != null) {
      isSubmitting.value = false;
      return false;
    }

    try {
      final isEdit = editingContentId.value != null;
      loadingAffiliate(true);

      final payloadProducts = selectedProducts.map((p) => p.productId).toList();

      final res = isEdit
          ? await _service.updateCategory(
              type: mapContentType(contentTypeId.value),
              contentId: editingContentId.value ?? 0,
              name: contentName.value,
              products: payloadProducts,
            )
          : await _service.createCategory(
              categoryName: contentName.value,
              products: payloadProducts,
            );

      await loadingAffiliate(false);

      if (res?.code == '100') {
        final int contentIdResult = editingContentId.value ?? 0;
        final String catNameResult = contentName.value;
        final productsResult = selectedProducts.toList();

        await showAffDialog(true, 'สำเร็จ', 'บันทึกข้อมูลเรียบร้อย');
        Future.microtask(() {
          clearAddContentData();
        });

        await Future.wait([
          getAffiliateContent(page: 'view', target: 'category', contentId: 0),
          getAffiliateContent(page: 'modify', target: 'category', contentId: 0),
        ]);

        Get.back(result: {
          'contentId': contentIdResult,
          'catName': catNameResult,
          'products': productsResult,
        });
      } else {
        await showAffDialog(
            false, 'ผิดพลาด', res?.message ?? 'ไม่สามารถบันทึกข้อมูลได้');
      }
      return true;
    } catch (e) {
      await showAffDialog(false, 'ผิดพลาด', 'ไม่สามารถบันทึกข้อมูลได้');
      return false;
    } finally {
      await loadingAffiliate(false);
      isSubmitting.value = false;
    }
  }

  Future<void> getAffiliateContent({
    required String page, // 'view' | 'modify'
    required String target, // 'content' | 'category'
    required int contentId,
  }) async {
    final loading = _pickLoadingFlag(page, target);

    loading.value = true;
    try {
      final res = await _service.getAffiliateContent(
        page: page,
        target: target,
        contentId: contentId,
      );

      final data = res?.data;
      if (page == 'view') {
        if (target == 'content') {
          viewContentData.assignAll(data ?? []);
          contentEmpty.value = viewContentData.isEmpty;
        } else if (target == 'category') {
          viewCategoryData.assignAll(data ?? []);
          categoryEmpty.value = viewCategoryData.isEmpty;
        }
      } else {
        if (target == 'content') {
          editContentData.assignAll(data ?? []);
        } else if (target == 'category') {
          editCategoryData.assignAll(data ?? []);
        }
      }
    } catch (e, st) {
      if (page == 'view') {
        if (target == 'content') {
          viewContentData.clear();
          contentEmpty.value = true;
        } else if (target == 'category') {
          viewCategoryData.clear();
          categoryEmpty.value = true;
        }
      } else {
        if (target == 'content') editContentData.clear();
        if (target == 'category') editCategoryData.clear();
      }
      debugPrint('getAffiliateContent error: $e\n$st');
    } finally {
      loading.value = false;
    }
  }

  Future<void> getAffiliateContentById({
    required String page, // 'view' | 'modify'
    required String target, // 'content' | 'category'
    required int contentId,
  }) async {
    isLoadingContentById.value = true;

    editingContentId.value = contentId;
    submittedAddContent.value = false;
    touchedAddContent.clear();
    clearSelectedMedia();
    contentName.value = '';
    contentNameCtrl.clear();
    contentTypeId.value = null;
    previewUrls.value = '';

    try {
      final res = await _service.getAffiliateContent(
        page: page,
        target: target,
        contentId: contentId,
      );

      final data = res?.data;

      if (target == 'content') {
        editContentDataById.assignAll(data ?? []);

        if (editContentDataById.isEmpty) return;

        final d = editContentDataById.first;

        if (d.items.isEmpty) return;
        final item = d.items.first;

        // ---- พรีฟิลชื่อ ----
        final name = item.name;
        contentName.value = name;
        if (contentNameCtrl.text != name) {
          contentNameCtrl.text = name;
        }

        // ---- พรีฟิลประเภท ----
        final tId = _typeIdFromString(d.contentType);
        if (tId != null && tId > 0) {
          contentTypeId.value = tId;
        }

        switch (contentTypeId.value) {
          case 1: // image (banner)
          case 5: // carousel
            previewUrls.value = item.images;
            break;

          case 2: // product
            // ถ้าโมเดลตรงกันอยู่แล้ว ใส่ได้เลย
            selectedProducts.assignAll(item.attachedProduct);
            break;

          case 3: // video
            previewUrls.value = item.images;
            break;

          case 4: // text
            selectedText.value = item.description;
            break;
        }
      } else {
        // target == 'category'
        editCategoryDataById.assignAll(data ?? []);

        if (editCategoryDataById.isEmpty) return;

        final d = editCategoryDataById.first;

        if (d.items.isEmpty) return;
        final item = d.items.first;

        // ---- พรีฟิลชื่อ ----
        final name = item.name;
        contentName.value = name;
        if (contentNameCtrl.text != name) {
          contentNameCtrl.text = name;
        }

        // ---- พรีฟิลประเภท ----
        final tId = _typeIdFromString(d.contentType);
        if (tId != null && tId > 0) {
          contentTypeId.value = tId;
        }
        selectedProducts.assignAll(item.attachedProduct);
      }
    } catch (e, st) {
      if (target == 'content') {
        editContentDataById.clear();
      } else {
        editCategoryDataById.clear();
      }
      debugPrint('getAffiliateContentById error: $e\n$st');
    } finally {
      isLoadingContentById.value = false;
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

  List<RxList<ContentData>> _boxesForTarget(String target) {
    return target == 'content'
        ? [viewContentData, editContentData]
        : [viewCategoryData, editCategoryData];
  }

  void changeStatusEverywhere({
    required String target, // 'content' | 'category'
    required int itemId,
    required String status,
  }) {
    final boxes = _boxesForTarget(target);

    for (final box in boxes) {
      bool changed = false;

      for (final cd in box) {
        final idx = cd.items.indexWhere((it) => it.id == itemId);
        if (idx != -1) {
          final oldItem = cd.items[idx];
          if (oldItem.status != status) {
            cd.items[idx] = oldItem.copyWith(status: status);
            changed = true;
          }
        }
      }

      if (changed) box.refresh();
    }
  }

  bool moveContentToIndexEverywhere({
    required String target, // 'content' | 'category'
    required int itemId,
    required int newIndex,
  }) {
    bool moved = false;

    for (final box in _boxesForTarget(target)) {
      final secIdx =
          box.indexWhere((sec) => sec.items.any((it) => it.id == itemId));
      if (secIdx > -1 && secIdx != newIndex) {
        final section = box.removeAt(secIdx);
        final to = newIndex.clamp(0, box.length);
        box.insert(to, section);

        // บังคับ Obx รีเฟรช
        box.assignAll(List<content.ContentData>.of(box));
        moved = true;
      }
    }

    return moved;
  }

  void moveContentToTopEverywhere({
    required String target,
    required int itemId,
  }) {
    moveContentToIndexEverywhere(target: target, itemId: itemId, newIndex: 0);
  }

  void moveItemToBottomEverywhere({
    required String target,
    required int itemId,
  }) {
    final boxes = _boxesForTarget(target);
    for (final box in boxes) {
      bool changed = false;
      for (final cd in box) {
        final from = cd.items.indexWhere((it) => it.id == itemId);
        if (from != -1) {
          final item = cd.items.removeAt(from);
          cd.items.add(item);
          changed = true;
        }
      }
      if (changed) box.refresh();
    }
  }

  void _removeItemEverywhere({
    required String target, // 'content' | 'category'
    required int itemId,
  }) {
    final boxes = target == 'content'
        ? [viewContentData, editContentData]
        : [viewCategoryData, editCategoryData];

    for (final box in boxes) {
      bool changed = false;

      for (final cd in box) {
        final before = cd.items.length;
        cd.items.removeWhere((it) => it.id == itemId);
        if (cd.items.length != before) changed = true;
      }

      box.removeWhere((cd) => cd.items.isEmpty);

      if (changed) box.refresh();
    }

    // อัปเดต flag ว่าง (ถ้าใช้ใน UI)
    contentEmpty.value = viewContentData.isEmpty;
    categoryEmpty.value = viewCategoryData.isEmpty;
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
    editingContentId.value = null;
    contentTypeId.value = null;
    contentName.value = '';
    contentNameCtrl.clear();
    submittedAddContent.value = false;
    touchedAddContent.clear();
    contentEmpty.value = false;
    previewUrls.value = '';

    selectedProducts.clear(); // << เพิ่ม
  }

  void clearSelectedMedia() {
    selectedImages.clear();
    selectedVideo.value = null;
    selectedText.value = '';
    selectedProducts.clear(); // << เพิ่ม
  }
}
