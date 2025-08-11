import 'package:get/get.dart';

class AppController extends GetxController {
  RxInt _currentIndex = 0.obs;
  RxInt currentIndexB2c = 0.obs;

  // Get
  GetCurrentNavInget() => _currentIndex.value;
  GetCurrentNavIngetB2C() => currentIndexB2c.value;

  // // Set
  setCurrentNavInget(int value) {
    _currentIndex.value = value;
    update();
    return value;
  }

  setCurrentNavIngetB2c(int value) {
    currentIndexB2c.value = value;
    update();
    return value;
  }

  // ดำเนินการ Set ในส่วนของการ POPUP การแจ้งการลงทะเบียน
  RxInt _currentsetstatuschick = 0.obs;

  // Get
  Getcurrentsetstatuschick() => _currentsetstatuschick.value;

  // // Set
  Setcurrentsetstatuschick(int value) {
    _currentsetstatuschick.value = value;
    update();
    return value;
  }
}
