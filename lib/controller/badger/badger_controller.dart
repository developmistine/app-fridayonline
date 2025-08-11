// ignore_for_file: non_constant_identifier_names

import 'package:fridayonline/model/notify/informationpush.dart';
// import 'package:fridayonline/model/push/pam_push_history.dart';
import 'package:fridayonline/service/notify/informationPushNotify_sevice.dart';

import '../../model/badger/badger_notification.dart';
import '../../model/badger/badger_profile_msl.dart';
import '../../model/market/market_cart_badger.dart';
import '../../service/badger/badger.dart';
import 'package:get/get.dart';

import '../../service/market/market_service.dart';

//Controller สำหรับเรียกข้อมูล badger
class BadgerController extends GetxController {
  BadgerNotification? badgerNotify; //เรียกใช้ model BadgerNotification
  MarketCartBadger? badgerMarket;
  InformationPushNotify? notify; //เรียกใช้ model InformationPushNotify
  //ListPamPushHistory? listPamPushHistory;

  //int countBadger = 0;

  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

  get_badger() async {
    // int countBadger1 = 0;
    // int countBadger2 = 0;
    //ฟังก์ชัันสำหรับเรียกข้อมูล badger notification
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true

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
      notify =
          await Information_Push(); //เรียกใช้งาน service สำหรับเรีกข้อมูล maeket
      // try {
      //   countBadger2 =
      //       int.parse(notify!.informationPushNotify[0].notify[1].badger) +
      //           int.parse(notify!.informationPushNotify[0].notify[2].badger) +
      //           int.parse(notify!.informationPushNotify[0].notify[3].badger);
      // } catch (e) {
      //   countBadger2 = 0;
      // }

      // countBadger = countBadger1 + countBadger2;
      badgerNotify =
          await call_badger_notification(); //เรียกใช้งาน service badger notification
    } finally {
      update();
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  get_badger_profile() async {
    // //ฟังก์ชัันสำหรับเรียกข้อมูล badger notification
    // try {
    //   isDataLoading(true); // สถานะการโหลดข้อมูล true
    //   badgerProfile = await call_badger_profile_msl();
    // } finally {
    //   isDataLoading(false); // สถานะการโหลดข้อมูล false
    // }
  }

  getBadgerMarket() async {
    //ฟังก์ชัันสำหรับเรียกข้อมูล badger notification
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      badgerMarket =
          await GetBadgerCall(); //เรียกใช้งาน service badger notification
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

//Controller สำหรับเรียกข้อมูล badger
class BadgerProfileController extends GetxController {
  BadgerProfileMsl? badgerProfile;
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  get_badger_profile() async {
    //ฟังก์ชัันสำหรับเรียกข้อมูล badger notification
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      badgerProfile = await call_badger_profile_msl();
    } finally {
      update();
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}
