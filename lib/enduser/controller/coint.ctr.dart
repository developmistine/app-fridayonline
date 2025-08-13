import 'package:appfridayecommerce/enduser/models/checkin/checkin.model.dart';
import 'package:appfridayecommerce/enduser/models/fair/cointransaction.model.dart';
import 'package:appfridayecommerce/enduser/services/checkin/checkin.service.dart';
import 'package:appfridayecommerce/enduser/services/fair/fair.service.dart';
import 'package:get/get.dart';

class CoinCtr extends GetxController {
  Rx<CheckInData>? checkIn;
  CoinsTransaction? transaction;
  final RxBool isLoadingCheckIn = false.obs;
  final RxBool isLoadingTransaction = false.obs;
  final RxBool isLoadingMore = false.obs;

  fetchCheckIn() async {
    try {
      isLoadingCheckIn.value = true;
      var item = await fetchCheckInDataService();
      checkIn = item.obs;
    } finally {
      isLoadingCheckIn.value = false;
    }
  }

  setCheckIn() async {
    var item = await fetchCheckInDataService();
    checkIn = item.obs;
    checkIn!.refresh();
  }

  fetchTransaction({int? offset}) async {
    try {
      isLoadingTransaction.value = true;
      transaction = await fetchCoinsTransactionService(0);
    } finally {
      isLoadingTransaction.value = false;
    }
  }

  Future<CoinsTransaction?>? fetchMoreTransaction(offet) async {
    return await fetchCoinsTransactionService(offet);
  }
}
