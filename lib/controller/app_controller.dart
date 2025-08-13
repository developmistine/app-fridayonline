import 'package:get/get.dart';

class AppController extends GetxController {
  RxInt currentIndexB2c = 0.obs;

  setCurrentNavIngetB2c(int value) {
    currentIndexB2c.value = value;
    update();
    return value;
  }
}
