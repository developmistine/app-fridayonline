import 'package:fridayonline/member/models/affiliate/commission.balance.model.dart';
import 'package:fridayonline/member/models/affiliate/commission.condition.model.dart';
import 'package:fridayonline/member/models/affiliate/commission.sumearning.model.dart'
    as earn;
import 'package:fridayonline/member/models/affiliate/commission.sumorder.model.dart'
    as order;
import 'package:fridayonline/member/models/affiliate/commission.dtlearning.model.dart'
    as earndtl;
import 'package:fridayonline/member/models/affiliate/commission.dtlorder.model.dart'
    as orderdtl;
import 'package:fridayonline/member/models/affiliate/dashboard.overview.dart';
import 'package:fridayonline/member/models/affiliate/dashboard.products.dart';
import 'package:fridayonline/member/models/affiliate/dashboard.summary.dart';
import 'package:fridayonline/member/models/affiliate/option.model.dart'
    as option;
import 'package:fridayonline/member/models/affiliate/option.model.dart';
import 'package:get/get.dart';

import 'package:fridayonline/member/services/affiliate/affiliate.service.dart';

enum OptionKey {
  category,
  commission,
}

class AffiliateCommissionCtr extends GetxController {
  final _service = AffiliateService();

  final isAffiliateConditionLoading = false.obs;
  final isCommissionBalanceLoading = false.obs;
  final isFirstCommissionOrdersLoading = false.obs;
  final isCommissionOrdersLoading = false.obs;
  final isCommissionEarnsLoading = false.obs;
  final isDtlOrdersLoading = false.obs;
  final isDtlEarnsLoading = false.obs;
  final isDbOverviewLoading = false.obs;
  final isFirstProductPerformanceLoading = false.obs;
  final isProductPerformanceLoading = false.obs;
  final isProductPerformanceLoadingMore = false.obs;
  final isAccSummaryLoading = false.obs;

  final Rx<order.Data?> firstCommissionOrdersData = Rx<order.Data?>(null);
  final Rx<order.Data?> commissionOrdersData = Rx<order.Data?>(null);
  final Rx<earn.Data?> commissionEarnsData = Rx<earn.Data?>(null);
  final Rx<orderdtl.Data?> ordersDtlData = Rx<orderdtl.Data?>(null);
  final Rx<earndtl.Data?> earnsDtlData = Rx<earndtl.Data?>(null);
  final Rx<CommissionBalanceData?> commissionBalanceData =
      Rx<CommissionBalanceData?>(null);
  final RxList<AffiliateConditionData?> affiliateConditionData =
      <AffiliateConditionData>[].obs;
  final Rx<DashBoardOverviewData?> dashboardOverviewData =
      Rx<DashBoardOverviewData?>(null);
  final Rx<DashBoardProductsData?> firstProductPerformanceData =
      Rx<DashBoardProductsData?>(null);
  final Rx<DashBoardProductsData?> productPerformanceData =
      Rx<DashBoardProductsData?>(null);
  final Rx<AccountSummaryData?> accSummaryData = Rx<AccountSummaryData?>(null);

  final hasMorePerformanceProduct = true.obs;
  final totalPerformanceProduct = 0.obs;
  int _lastPerformanceProductReqId = 0;
  int _performanceProductOffset = 0;
  final int pageSize = 20;

  final RxList<option.Datum> categoryOptionData = <option.Datum>[].obs;

  final selectedCategoryId = RxnInt();
  final selectedCommissionId = RxnInt();
  final searchKeyword = RxnString();

  String _period = '';
  String _start = '';
  String _end = '';

  @override
  void onInit() {
    super.onInit();
    getOption('category');
  }

  void _ensureOptionDefaultsSelected() {
    if (selectedCategoryId.value == null &&
        categoryOptionData.any((e) => e.id == 0)) {
      selectedCategoryId.value = 0;
    }

    if (selectedCommissionId.value == null) {
      selectedCommissionId.value = 0;
    }
  }

  String get _orderBy {
    final id = selectedCommissionId.value ?? 0;
    if (id == 1) return 'desc';
    if (id == 2) return 'asc';
    return '';
  }

  int get _categoryId => selectedCategoryId.value ?? 0;
  String get _keyword => searchKeyword.value ?? '';

  void setProductDateRange(
      {required String period, required String start, required String end}) {
    _period = period;
    _start = start;
    _end = end;
  }

  Future<void> getFirstCommissionSummary({
    required String page,
    String? period,
    String? str,
    String? end,
  }) async {
    isFirstCommissionOrdersLoading.value = true;

    try {
      final order.AffiliateSummaryOrder? res =
          await _service.getSummaryOrder(page: page);
      firstCommissionOrdersData.value = res?.data;
    } catch (e, _) {
      firstCommissionOrdersData.value = null;
    } finally {
      isFirstCommissionOrdersLoading.value = false;
    }
  }

  Future<void> getCommissionSummary({
    required String page,
    String? period,
    String? str,
    String? end,
  }) async {
    final isOrders = page == 'orders';

    if (isOrders) {
      isCommissionOrdersLoading.value = true;
    } else {
      isCommissionEarnsLoading.value = true;
    }

    try {
      if (isOrders) {
        final order.AffiliateSummaryOrder? res = await _service.getSummaryOrder(
            page: page, period: period, str: str, end: end);
        commissionOrdersData.value = res?.data;
      } else {
        final earn.AffiliateSummaryEarning? res = await _service
            .getSummaryEarning(page: page, period: period, str: str, end: end);
        commissionEarnsData.value = res?.data;
      }
    } catch (e, st) {
      // Optionally log error
      if (isOrders) {
        commissionOrdersData.value = null;
      } else {
        commissionEarnsData.value = null;
      }
    } finally {
      if (isOrders) {
        isCommissionOrdersLoading.value = false;
      } else {
        isCommissionEarnsLoading.value = false;
      }
    }
  }

  Future<void> getCommissionCondition() async {
    isAffiliateConditionLoading.value = true;
    try {
      final res = await _service.getCommissionCondition();
      affiliateConditionData.value = res?.data ?? [];
    } catch (_) {
      affiliateConditionData.value = [];
    } finally {
      isAffiliateConditionLoading.value = false;
    }
  }

  Future<void> getCommissionBalance() async {
    isCommissionBalanceLoading.value = true;
    try {
      final res = await _service.getCommissionBalance();
      commissionBalanceData.value = res?.data;
    } catch (_) {
      commissionBalanceData.value = null;
    } finally {
      isCommissionBalanceLoading.value = false;
    }
  }

  Future<void> getOrderDtl(String date) async {
    isDtlOrdersLoading.value = true;
    try {
      final res = await _service.getCommissionOrderDetail(date: date);
      ordersDtlData.value = res?.data;
    } catch (_) {
      ordersDtlData.value = null;
    } finally {
      isDtlOrdersLoading.value = false;
    }
  }

  Future<void> getEaringDtl(String date) async {
    isDtlEarnsLoading.value = true;
    try {
      final res = await _service.getCommissionEarningDetail(date: date);
      earnsDtlData.value = res?.data;
    } catch (_) {
      earnsDtlData.value = null;
    } finally {
      isDtlEarnsLoading.value = false;
    }
  }

  Future<void> getOption(String key) async {
    try {
      final Option? u = await _service.getOption(key);
      final List<option.Datum> ok = u?.data ?? <option.Datum>[];
      categoryOptionData.assignAll(ok);
    } catch (e) {
      categoryOptionData.value = [];
    }
  }

  Future<void> refreshProductPerformance() async {
    _performanceProductOffset = 0;
    hasMorePerformanceProduct.value = true;
    await _fetchProductPerformance(reset: true);
  }

  Future<void> loadMoreFilteredProducts() async {
    if (isProductPerformanceLoading.value || !hasMorePerformanceProduct.value)
      return;

    _performanceProductOffset += pageSize;
    await _fetchProductPerformance(reset: false);
  }

  Future<void> _fetchProductPerformance({required bool reset}) async {
    final reqId = ++_lastPerformanceProductReqId;

    if (reset) {
      isProductPerformanceLoading.value = true;
    } else {
      isProductPerformanceLoadingMore.value = true;
    }

    try {
      _ensureOptionDefaultsSelected();

      final DashBoardProducts? res = await _service.getDbProductPerformance(
        period: _period,
        str: _start,
        end: _end,
        categoryId: _categoryId,
        orderBy: _orderBy,
        keyword: _keyword,
        limit: pageSize,
        offset: _performanceProductOffset,
      );

      if (reqId != _lastPerformanceProductReqId) return;

      final DashBoardProductsData? data = res?.data;
      final List<dynamic> list = data?.products ?? const [];
      totalPerformanceProduct.value = data?.total ?? 0;

      totalPerformanceProduct.value = data?.total ?? 0;

      if (reset) {
        productPerformanceData.value = data;
      } else {
        final current = productPerformanceData.value;
        if (current == null) {
          productPerformanceData.value = data;
        } else {
          final merged = DashBoardProductsData(
            total: data?.total ?? current.total,
            products: <Product>[
              ...(current.products),
              ...List<Product>.from(list),
            ],
          );
          productPerformanceData.value = merged;
        }
      }

      hasMorePerformanceProduct.value = list.length >= pageSize;

      productPerformanceData.refresh();
    } catch (e, st) {
      if (reset) {
        productPerformanceData.value = null;
      }
      hasMorePerformanceProduct.value = false;
      // printError(info: '_fetchPerformanceProduct: $e\n$st');
    } finally {
      if (reset) {
        isProductPerformanceLoading.value = false;
      } else {
        isProductPerformanceLoadingMore.value = false;
      }
    }
  }

  Future<void> getFirstProductPerformanceSummary({
    String? period,
    String? str,
    String? end,
    int? categoryId,
    String? orderBy,
    String? keyword,
    int? limit,
    int? offset,
  }) async {
    isFirstProductPerformanceLoading.value = true;
    try {
      final DashBoardProducts? res = await _service.getDbProductPerformance(
        period: period ?? '',
        str: str ?? '',
        end: end ?? '',
        categoryId: categoryId ?? 0,
        orderBy: orderBy ?? '',
        keyword: keyword ?? '',
        limit: limit ?? pageSize,
        offset: offset ?? 0,
      );
      firstProductPerformanceData.value = res?.data;
    } catch (e, st) {
      firstProductPerformanceData.value = null;
      // printError(info: 'getFirstProductPerformanceSummary: $e\n$st');
    } finally {
      isFirstProductPerformanceLoading.value = false;
    }
  }

  Future<void> getDbOverViewData({
    String? period,
    String? str,
    String? end,
  }) async {
    isDbOverviewLoading.value = true;
    try {
      final DashBoardOverview? res = await _service.getDbOverview(
        period: period ?? '',
        str: str ?? '',
        end: end ?? '',
      );
      dashboardOverviewData.value = res?.data;
    } catch (e, _) {
      dashboardOverviewData.value = null;
    } finally {
      isDbOverviewLoading.value = false;
    }
  }

  Future<void> getAccountSummary() async {
    isAccSummaryLoading.value = true;
    try {
      final res = await _service.getAccountSummary();
      accSummaryData.value = res?.data;
    } catch (e, _) {
      accSummaryData.value = null;
    } finally {
      isAccSummaryLoading.value = false;
    }
  }

  void selectedDate(String str, String end, String period) async {
    await getCommissionSummary(
        page: 'orders', period: 'range', str: str, end: end);
    await getCommissionSummary(
        page: 'earnings', period: period, str: str, end: end);

    setProductDateRange(period: period, start: str, end: end);
    await refreshProductPerformance();
  }

  void selectDatefilter(String period, String str, String end) async {
    setProductDateRange(period: period, start: str, end: end);

    await Future.wait([
      getDbOverViewData(period: period, str: str, end: end),
      getFirstProductPerformanceSummary(period: period, str: str, end: end),
      refreshProductPerformance(),
    ]);
  }
}
