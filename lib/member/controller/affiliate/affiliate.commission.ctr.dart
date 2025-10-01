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
import 'package:get/get.dart';

import 'package:fridayonline/member/services/affiliate/affiliate.service.dart';

class AffiliateCommissionCtr extends GetxController {
  final _service = AffiliateService();

  final isAffiliateConditionLoading = false.obs;
  final isCommissionBalanceLoading = false.obs;
  final isFirstCommissionOrdersLoading = false.obs;
  final isCommissionOrdersLoading = false.obs;
  final isCommissionEarnsLoading = false.obs;
  final isDtlOrdersLoading = false.obs;
  final isDtlEarnsLoading = false.obs;

  final Rx<order.Data?> firstCommissionOrdersData = Rx<order.Data?>(null);
  final Rx<order.Data?> commissionOrdersData = Rx<order.Data?>(null);
  final Rx<earn.Data?> commissionEarnsData = Rx<earn.Data?>(null);
  final Rx<orderdtl.Data?> ordersDtlData = Rx<orderdtl.Data?>(null);
  final Rx<earndtl.Data?> earnsDtlData = Rx<earndtl.Data?>(null);
  final Rx<CommissionBalanceData?> commissionBalanceData =
      Rx<CommissionBalanceData?>(null);
  final RxList<AffiliateConditionData?> affiliateConditionData =
      <AffiliateConditionData>[].obs;

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

  void selectedDate(String str, String end) async {
    await getCommissionSummary(
        page: 'orders', period: 'range', str: str, end: end);
    await getCommissionSummary(
        page: 'earnings', period: 'range', str: str, end: end);
  }
}
