import 'package:get/get.dart';

class OrderHistoryController extends GetxController {
  var isShowMore = List<bool>.generate(20, (index) => false).obs;

  void toggleShowMore(int index) {
    isShowMore[index] = !isShowMore[index];
  }
}
