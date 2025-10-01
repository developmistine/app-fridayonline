// lib/member/controller/affiliate/affiliate.product.ctr.dart
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/components/utils/status.dialog.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:fridayonline/member/models/affiliate/option.model.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart';
import 'package:fridayonline/member/services/affiliate/affiliate.service.dart';
import 'package:get/get.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart'
    as content;
import 'package:fridayonline/member/models/affiliate/option.model.dart'
    as option;

enum OptionKey { category, brand, commission, store }

extension on OptionKey {
  String get asString => switch (this) {
        OptionKey.category => 'category',
        OptionKey.brand => 'brand',
        OptionKey.commission => 'commission',
        OptionKey.store => 'store',
      };
}

class AffiliateProductCtr extends GetxController {
  final _service = AffiliateService();

  // option
  final RxList<option.Datum> categoryOptionData = <option.Datum>[].obs;
  final RxList<option.Datum> brandOptionData = <option.Datum>[].obs;
  final RxList<option.Datum> commissionOptionData = <option.Datum>[].obs;
  final RxList<option.Datum> storeOptionData = <option.Datum>[].obs;
  final selectedCategoryId = RxnInt();
  final selectedBrandId = RxnInt();
  final selectedCommissionId = RxnInt();
  final selectedStoreId = RxnInt();
  final searchKeyword = RxnString();

  late final Map<OptionKey, RxList<option.Datum>> _targets;

  /// ===== Product (จัดเรียง/กรอง) =====
  final isAddingProduct = false.obs;
  final addingProductId = RxnInt();

  final productEmpty = false.obs;
  final tabSort = 0.obs;
  final isPriceUp = false.obs;
  final totalProduct = 0.obs;
  final isLoadingMore = false.obs;

  final isLoadingShopProduct = false.obs;
  final RxList<AffiliateProduct> viewProductData = <AffiliateProduct>[].obs;
  final RxList<AffiliateProduct> editProductData = <AffiliateProduct>[].obs;

  Worker? _sortWorker;
  Worker? _priceWorker;

  final RxList<AffiliateProduct> filterProductData = <AffiliateProduct>[].obs;
  final isLoadingFilter = false.obs;
  final isLoadingMoreFilter = false.obs;
  final hasMoreFilter = true.obs;
  final totalFilterProduct = 0.obs;

  final RxList<AffiliateProduct> recommendProductData =
      <AffiliateProduct>[].obs;
  final isLoadingRecommend = false.obs;
  final isLoadingMoreRecommend = false.obs;
  final hasMoreRecommend = true.obs;
  int _recommendOffset = 0;
  int _lastRecommendReqId = 0;

  final hasMoreDefault = true.obs;
  int _defaultOffset = 0;
  int _lastDefaultReqId = 0;

  final pageTarget = 'product'.obs;
  final int pageSize = 20;
  final int _offsetDefault = 0; // (ถ้าจะใช้กับ default infinite scroll)
  int _filterOffset = 0;
  int _lastFilterReqId = 0;

  int get _categoryIdForApi => selectedCategoryId.value ?? 0;
  int get _brandIdForApi => selectedBrandId.value ?? 0;
  int get _storeIdForApi => selectedStoreId.value ?? 0;

  String get _commissionNameForApi {
    final cid = selectedCommissionId.value;
    if (cid != null) {
      final item = commissionOptionData.firstWhereOrNull((e) => e.id == cid);
      if (item != null) return item.name;
    }
    final zero = commissionOptionData.firstWhereOrNull((e) => e.id == 0);
    return zero?.name ?? '';
  }

  @override
  void onInit() {
    super.onInit();

    _targets = {
      OptionKey.category: categoryOptionData,
      OptionKey.brand: brandOptionData,
      OptionKey.commission: commissionOptionData,
      OptionKey.store: storeOptionData,
    };

    // โหลดพร้อมกัน
    Future.wait(OptionKey.values.map(getOption));

    _sortWorker = ever<int>(tabSort, (_) => reloadProducts());
    _priceWorker = ever<bool>(isPriceUp, (_) {
      if (tabSort.value == 2) reloadProducts();
    });

    everAll(
      [
        selectedCategoryId,
        selectedBrandId,
        selectedStoreId,
        selectedCommissionId,
      ],
      (_) => refreshFilteredProducts(),
    );

    debounce<String?>(searchKeyword, (_) => refreshFilteredProducts(),
        time: const Duration(milliseconds: 350));
  }

  @override
  void onClose() {
    _sortWorker?.dispose();
    _priceWorker?.dispose();
    super.onClose();
  }

  void _ensureOptionDefaultsSelected() {
    if (selectedCategoryId.value == null &&
        categoryOptionData.any((e) => e.id == 0)) {
      selectedCategoryId.value = 0;
    }
    if (selectedBrandId.value == null &&
        brandOptionData.any((e) => e.id == 0)) {
      selectedBrandId.value = 0;
    }
    if (selectedStoreId.value == null &&
        storeOptionData.any((e) => e.id == 0)) {
      selectedStoreId.value = 0;
    }
    if (selectedCommissionId.value == null &&
        commissionOptionData.any((e) => e.id == 0)) {
      selectedCommissionId.value = 0;
    }
  }

  void setSortTab(int index, {int priceIndex = 2}) {
    if (tabSort.value == index && index == priceIndex) {
      isPriceUp.toggle();
    } else {
      tabSort.value = index;
      if (index != priceIndex) {
        isPriceUp.value = false;
      }
    }
  }

  String get currentSortBy {
    switch (tabSort.value) {
      case 1:
        return 'sales';
      case 2:
        return 'price';
      case 0:
      default:
        return 'ctime';
    }
  }

  String get currentOrderBy {
    if (tabSort.value == 2) {
      return isPriceUp.value ? 'asc' : 'desc';
    }
    return 'desc';
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
        await getAffiliateProduct(
          page: 'view',
          sortBy: currentSortBy,
          orderBy: currentOrderBy,
          limit: 20,
          offset: 0,
        );
        await getAffiliateProduct(
          page: 'modify',
          sortBy: currentSortBy,
          orderBy: currentOrderBy,
          limit: 20,
          offset: 0,
        );
      } else {
        await showAffDialog(
            false, 'ผิดพลาด', res?.message ?? 'ไม่สามารถบันทึกข้อมูลได้');
      }
      return true;
    } catch (_) {
      await showAffDialog(false, 'ผิดพลาด', 'ไม่สามารถบันทึกข้อมูลได้');
      return false;
    } finally {
      isAddingProduct.value = false;
      addingProductId.value = null;
    }
  }

  Future<void> getOption(OptionKey key) async {
    try {
      final Option? u = await _service.getOption(key.asString);
      final List<option.Datum> ok = u?.data ?? <option.Datum>[];
      _targets[key]!.assignAll(ok);

      if (key == OptionKey.category) {
        affContentCtl.contentTypeData.value = ok;
      }
    } catch (e) {
      _targets[key]!.value = [];
    }
  }

  Future<void> refreshDefaultProducts(
      {int limit = 20, required String page}) async {
    _defaultOffset = 0;
    hasMoreDefault.value = true;
    await getAffiliateProduct(
      page: page,
      sortBy: currentSortBy,
      orderBy: currentOrderBy,
      limit: limit,
      offset: 0,
    );
  }

  Future<void> loadMoreDefaultProducts({required String page}) async {
    if (isLoadingMore.value || !hasMoreDefault.value) return;
    _defaultOffset += pageSize;
    await getAffiliateProduct(
      page: page,
      sortBy: currentSortBy,
      orderBy: currentOrderBy,
      limit: pageSize,
      offset: _defaultOffset,
    );
  }

  Future<void> reloadProducts({int limit = 20}) async {
    await refreshDefaultProducts(limit: limit, page: 'view');
  }

  Future<void> getAffiliateProduct({
    required String page, // 'view' | 'modify'
    required String sortBy, // sales | price | ctime
    required String orderBy, // desc | asc
    required int limit,
    required int offset,
  }) async {
    final reqId = ++_lastDefaultReqId;

    if (offset == 0) {
      isLoadingShopProduct.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final res = await _service.getAffiliateProduct(
        page: page,
        sortBy: page == 'modify' ? 'ctime' : sortBy,
        orderBy: page == 'modify' ? 'desc' : orderBy,
        limit: limit,
        offset: offset,
      );

      if (reqId != _lastDefaultReqId) return;

      final data = res?.data;
      final list = data?.products ?? const <AffiliateProduct>[];
      totalProduct.value = data?.total ?? 0;

      if (page == 'view') {
        if (offset == 0) {
          viewProductData.assignAll(list);
        } else {
          viewProductData.addAll(list);
        }
        productEmpty.value = viewProductData.isEmpty;

        hasMoreDefault.value = list.length >= limit;
      } else {
        if (offset == 0) {
          editProductData.assignAll(list);
        } else {
          editProductData.addAll(list);
        }
        hasMoreDefault.value = list.length >= limit;
      }
    } catch (e) {
      if (offset == 0) {
        if (page == 'view') {
          viewProductData.clear();
          productEmpty.value = true;
          hasMoreDefault.value = false;
        } else {
          editProductData.clear();
          productEmpty.value = true;
          hasMoreDefault.value = false;
        }
      }
    } finally {
      if (offset == 0) {
        isLoadingShopProduct.value = false;
      } else {
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> refreshFilteredProducts() async {
    _filterOffset = 0;
    hasMoreFilter.value = true;
    await _fetchFiltered(reset: true);
  }

  Future<void> loadMoreFilteredProducts() async {
    if (isLoadingMoreFilter.value || !hasMoreFilter.value) return;
    _filterOffset += pageSize;
    await _fetchFiltered(reset: false);
  }

  Future<void> _fetchFiltered({required bool reset}) async {
    final reqId = ++_lastFilterReqId;

    if (reset) {
      isLoadingFilter.value = true;
    } else {
      isLoadingMoreFilter.value = true;
    }

    try {
      _ensureOptionDefaultsSelected();

      final res = await _service.getFilterProduct(
        target: pageTarget.value,
        categoryId: _categoryIdForApi,
        brandId: _brandIdForApi,
        storeId: _storeIdForApi,
        commission: _commissionNameForApi,
        seachKey: searchKeyword.value ?? '',
        limit: pageSize,
        offset: _filterOffset,
      );

      if (reqId != _lastFilterReqId) return;

      final list = res?.data.products ?? const <AffiliateProduct>[];
      totalFilterProduct.value = res?.data.total ?? 0;

      if (reset) {
        filterProductData.assignAll(list);
      } else {
        filterProductData.addAll(list);
      }
      hasMoreFilter.value = list.length >= pageSize;
    } catch (_) {
      if (reset) filterProductData.clear();
      hasMoreFilter.value = false;
    } finally {
      if (reset) {
        isLoadingFilter.value = false;
      } else {
        isLoadingMoreFilter.value = false;
      }
    }
  }

  Future<void> refreshRecommendProducts() async {
    _recommendOffset = 0;
    hasMoreRecommend.value = true;
    await _fetchRecommendProduct(reset: true);
  }

  Future<void> loadMoreRecommendProducts() async {
    if (isLoadingMoreRecommend.value || !hasMoreRecommend.value) return;
    _recommendOffset += pageSize;
    await _fetchRecommendProduct(reset: false);
  }

  Future<void> _fetchRecommendProduct({required bool reset}) async {
    final reqId = ++_lastRecommendReqId;

    if (reset) {
      isLoadingRecommend.value = true;
    } else {
      isLoadingMoreRecommend.value = true;
    }

    try {
      final res = await _service.getRecommendProduct(
        limit: pageSize,
        offset: _recommendOffset,
      );

      if (reqId != _lastRecommendReqId) return;

      final list = res?.data ?? const <AffiliateProduct>[];

      if (reset) {
        recommendProductData.assignAll(list);
      } else {
        recommendProductData.addAll(list);
      }
      hasMoreRecommend.value = list.length >= pageSize;
    } catch (_) {
      if (reset) recommendProductData.clear();
      hasMoreRecommend.value = false;
    } finally {
      if (reset) {
        isLoadingRecommend.value = false;
      } else {
        isLoadingMoreRecommend.value = false;
      }
    }
  }

  Future<bool> deleteProduct(int productId) async {
    try {
      final res = await _service.deleteProduct(productId: productId);
      if (res?.code == '100') {
        final affContentCtr = Get.find<AffiliateContentCtr>();

        _removeItemEverywhere(productId: productId);

        await Future.wait([
          affContentCtr.getAffiliateContent(
              page: 'view', target: 'content', contentId: 0),
          affContentCtr.getAffiliateContent(
              page: 'modify', target: 'content', contentId: 0),
          affContentCtr.getAffiliateContent(
              page: 'view', target: 'category', contentId: 0),
          affContentCtr.getAffiliateContent(
              page: 'modify', target: 'category', contentId: 0),
        ]);
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

  Future<void> hideProduct(
      String status, int productId, bool isProductContent) async {
    try {
      await _service.hideProduct(
          status: status,
          productId: productId,
          contentId:
              isProductContent ? affContentCtl.editingContentId.value ?? 0 : 0);
      final affContentCtr = Get.find<AffiliateContentCtr>();

      _changeStatusItemEverywhere(productId: productId, status: status);

      if (isProductContent) {
        await Future.wait([
          affContentCtl.getAffiliateContentById(
            page: 'modify',
            target: 'content',
            contentId: affContentCtl.editingContentId.value ?? 0,
          ),
          affContentCtl.getAffiliateContentById(
            page: 'modify',
            target: 'category',
            contentId: affContentCtl.editingContentId.value ?? 0,
          )
        ]);
      }

      await Future.wait([
        affContentCtr.getAffiliateContent(
            page: 'view', target: 'content', contentId: 0),
        affContentCtr.getAffiliateContent(
            page: 'modify', target: 'content', contentId: 0),
        affContentCtr.getAffiliateContent(
            page: 'view', target: 'category', contentId: 0),
        affContentCtr.getAffiliateContent(
            page: 'modify', target: 'category', contentId: 0),
      ]);
    } catch (_) {}
  }

  int _removeFromList(RxList<AffiliateProduct> list, int productId) {
    final before = list.length;
    list.removeWhere((p) => p.productId == productId);
    return before - list.length;
  }

  void _removeItemEverywhere({required int productId}) {
    final removedView = _removeFromList(viewProductData, productId);
    if (removedView > 0 && totalProduct.value > 0) {
      totalProduct.value = (totalProduct.value - removedView).clamp(0, 1 << 31);
    }

    productEmpty.value = viewProductData.isEmpty;

    _removeFromList(editProductData, productId);
    final removedFiltered = _removeFromList(filterProductData, productId);
    if (removedFiltered > 0 && totalFilterProduct.value > 0) {
      totalFilterProduct.value =
          (totalFilterProduct.value - removedFiltered).clamp(0, 1 << 31);
    }
  }

  void _changeStatusItemEverywhere({
    required int productId,
    required String status,
  }) {
    void patchProducts(RxList<AffiliateProduct> box) {
      bool touched = false;
      for (var i = 0; i < box.length; i++) {
        final p = box[i];
        if (p.productId == productId && p.status != status) {
          box[i] = p.copyWith(status: status);
          touched = true;
        }
      }
      if (touched) box.refresh();
    }

    patchProducts(viewProductData);
    patchProducts(editProductData);

    if (Get.isRegistered<AffiliateContentCtr>()) {
      final c = Get.find<AffiliateContentCtr>();

      void patchContentBoxes(RxList<content.ContentData> box) {
        bool touched = false;

        for (final cd in box) {
          for (final it in cd.items) {
            for (var i = 0; i < it.attachedProduct.length; i++) {
              final ap = it.attachedProduct[i];
              if (ap.productId == productId && ap.status != status) {
                it.attachedProduct[i] = ap.copyWith(status: status);
                touched = true;
              }
            }
          }
        }

        if (touched) box.refresh();
      }

      patchContentBoxes(c.viewContentData);
      patchContentBoxes(c.editContentData);
      patchContentBoxes(c.viewCategoryData);
      patchContentBoxes(c.editCategoryData);
      patchContentBoxes(c.editContentDataById);
      patchContentBoxes(c.editCategoryDataById);
    }
  }

  void clearSearch() => searchKeyword.value = '';
}
