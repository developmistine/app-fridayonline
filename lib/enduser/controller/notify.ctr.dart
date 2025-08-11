import 'package:fridayonline/enduser/models/notify/notify.count.model.dart';
import 'package:fridayonline/enduser/models/notify/notify.group.model.dart';
import 'package:fridayonline/enduser/models/notify/notify.model.dart';
import 'package:fridayonline/enduser/services/notify/order.notify.service.dart';
import 'package:get/get.dart';

class NotifyController extends GetxController {
  var isLoadingCount = false.obs;
  var isLoadingNotify = false.obs;
  var isLoadingNotifyGroup = false.obs;
  var isLoadingMoreNotify = false.obs;

  B2CNotify? notify;
  NotifyGroup? notifyGroup;
  int groupIdVal = 0;
  CountNotify? countNoti;

  fetchCountNotify() async {
    try {
      isLoadingCount(true);
      countNoti = await fetchNotifyCountService();
    } finally {
      isLoadingCount(false);
    }
  }

  fetchNotify(int groupId, offset) async {
    groupIdVal = groupId;
    try {
      isLoadingNotify.value = true;
      notify = await fetchNotifyService(groupId, offset);
    } finally {
      isLoadingNotify.value = false;
    }
  }

  fetchNotifyGroup() async {
    try {
      isLoadingNotifyGroup.value = true;
      notifyGroup = await fetchNotifyGroupService();
    } finally {
      isLoadingNotifyGroup.value = false;
    }
  }

  Future<B2CNotify> fetchMoreNotify(int groupId, int offset) async {
    return await fetchNotifyService(groupId, offset);
  }
}
