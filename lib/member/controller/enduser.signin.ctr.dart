import 'dart:async';

import 'package:fridayonline/controller/app_controller.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/splashscreen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class EndUserSignInCtr extends GetxController {
  RxInt remainingSeconds = 60.obs;
  RxBool isAccept = false.obs;
  RxInt currentPage = 0.obs;
  List<int> listInterest = <int>[].obs;

  RxString telNumber = "".obs;
  RxString otpRef = "".obs;

  Timer? _timer; // เก็บตัวแปร Timer
  RxBool isLoading = false.obs;
  // String mslChangeView = "";
  // int indexCategory = 0;

  var custId = 0;
  var repType = "";
  var repSeq = "";

  // set interest
  void setInterest(int index) {
    if (listInterest.contains(index)) {
      listInterest.remove(index);
      return;
    }
    listInterest.add(index);
  }

  changeAccept() {
    isAccept.value = !isAccept.value;
  }

  fetchB2cCustId() async {
    try {
      isLoading(true);
      SetData data = SetData();
      custId = await data.b2cCustID;
      repType = await data.repType;
      repSeq = await data.repCode;
      if (repSeq == "null") {
        repSeq = "";
      }
    } finally {
      isLoading(false);
    }
  }

  // Start Timer
  void startTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel(); // ถ้ามี Timer อยู่ให้ยกเลิกก่อน
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainingSeconds.value == 0) {
        timer.cancel();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  // Stop Timer
  void stopTimer() {
    _timer?.cancel(); // ยกเลิก Timer ถ้ามี
    remainingSeconds.value = 0;
  }

  // reset timer
  void resetTimer() {
    _timer?.cancel(); // ยกเลิก Timer ถ้ามี
    remainingSeconds.value = 60;
  }

  // set preference login or register
  settingPreference(
      String lsSuccess, String mobile, String lsTypeUser, int cusId) async {
    // เรียกใช้งาน SharedPreferences ที่เป็น future
    final SharedPreferences prefs = await _prefs;
    // ทำการ Get Data ออกมาทำการตรวจสอบก่อน

    // กรณีที่ทำการ Set Data
    await prefs.setString("login", lsSuccess);
    await prefs.setString("B2cMobile", mobile);
    await prefs.setString("UserType", lsTypeUser);
    await prefs.setInt("B2cCustId", cusId);
    Get.find<AppController>().setCurrentNavIngetB2c(0);
    Get.offAll(() => const SplashScreen());
  }

  settingPreferencePush(
      String lsSuccess, String mobile, String lsTypeUser, int cusId) async {
    print("type is : lsTypeUser");
    // เรียกใช้งาน SharedPreferences ที่เป็น future
    final SharedPreferences prefs = await _prefs;
    // ทำการ Get Data ออกมาทำการตรวจสอบก่อน

    // กรณีที่ทำการ Set Data
    await prefs.setString("login", lsSuccess);
    await prefs.setString("B2cMobile", mobile);
    await prefs.setString("UserType", lsTypeUser);
    await prefs.setInt("B2cCustId", cusId);
    Get.find<AppController>().setCurrentNavIngetB2c(0);
  }
}
