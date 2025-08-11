// ignore_for_file: non_constant_identifier_names

import 'package:fridayonline/model/notify/informationPushPromotionGroup.dart';
// import 'package:fridayonline/model/push/pam_push_history.dart';
import 'package:get/get.dart';
import '../../model/notify/informationpush.dart';
import '../../service/notify/informationPushNotify_sevice.dart';

class NotificationController extends GetxController {
  InformationPushNotify? notify; //เรียกใช้ model InformationPushNotify
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  //ListPamPushHistory? listPamPushHistory;
  int countBadger = 0;

  get_notification_data() async {
    int countBadger1 = 0;
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      notify =
          await Information_Push(); //เรียกใช้งาน service สำหรับเรีกข้อมูล maeket
      //listPamPushHistory = await pamPushHistory();
      // try {
      //   for (int i = 0; i < listPamPushHistory!.items.length; i++) {
      //     if (listPamPushHistory!.items[i].isOpen == false) {
      //       countBadger1 = countBadger1 + 1;
      //     }
      //   }
      // } catch (e) {
      //   countBadger1 = 0;
      // }

      countBadger = countBadger1;
    } finally {
      update();
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  // get_notification_data_update() async {
  //   int countBadger1 = 0;
  //   try {
  //     isDataLoading(true);
  //     listPamPushHistory = await pamPushHistory();
  //     try {
  //       for (int i = 0; i < listPamPushHistory!.items.length; i++) {
  //         if (listPamPushHistory!.items[i].isOpen == false) {
  //           countBadger1 = countBadger1 + 1;
  //         }
  //       }
  //     } catch (e) {
  //       countBadger1 = 0;
  //     }
  //     countBadger = countBadger1;
  //     update();
  //   } finally {
  //     update();
  //     isDataLoading(false); // สถานะการโหลดข้อมูล false
  //   }
  // }
}

class NotificationPromotionListController extends GetxController {
  InformationPushPromotionGroup?
      promotionList; //เรียกใช้ model InformationPushNotify
  //ListPamPushHistory? listPamPushHistory;
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

  int countBadger = 0;
  get_promotionList(idparm, typedataapi) async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      promotionList = await Information_Push_PromotionList(
          idparm: idparm, typedataapi: typedataapi);
      update();
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  get_promotionList_reset(idparm, typedataapi) async {
    promotionList = await Information_Push_PromotionList(
        idparm: idparm, typedataapi: typedataapi);
    update();
  }

  // get_pam_notification_data() async {
  //   int countBadger1 = 0;
  //   try {
  //     isDataLoading(true);
  //     listPamPushHistory = await pamPushHistory();
  //     try {
  //       for (int i = 0; i < listPamPushHistory!.items.length; i++) {
  //         if (listPamPushHistory!.items[i].isOpen == false) {
  //           countBadger1 = countBadger1 + 1;
  //         }
  //       }
  //     } catch (e) {
  //       countBadger1 = 0;
  //     }

  //     countBadger = countBadger1;
  //   } finally {
  //     update();
  //     isDataLoading(false);
  //   }
  // }

  // get_pam_notification_reset() async {
  //   listPamPushHistory = await pamPushHistory();
  //   update();
  // }
}
