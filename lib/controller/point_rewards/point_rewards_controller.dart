import 'dart:async';

// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:get/get.dart';

import '../../model/point_rewards/point_rewards_category_detail_by_fscode.dart';
import '../../model/point_rewards/point_rewards_get_category.dart';
import '../../model/point_rewards/point_rewards_get_category_detail_list.dart';
import '../../model/point_rewards/point_rewards_get_msl_info.dart';
import '../../model/point_rewards/point_rewards_menu.dart';
import '../../service/point_rewards/point_rewards_sevice.dart';

class SearchPointRewardsController extends GetxController {
  Rewardsgetcategory? getCategory;
  GetMslinfo? mslInfo;

  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  var statusSearch = false.obs;

  getAddressUser() async {
    try {
      isDataLoading(true);
      mslInfo = await GetMslInfoSevice();
    } finally {
      isDataLoading(false);
    }
  }

  get_search_data() async {
    try {
      isDataLoading(true);
      statusSearch(true);
      mslInfo = await GetMslInfoSevice();
      getCategory = await GetProductByKeySearchCall('200');
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  get_search_datas(value) async {
    try {
      isDataLoading(true);
      statusSearch(true);
      mslInfo = await GetMslInfoSevice();
      getCategory = await GetProductByKeySearchCall(value);
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  reset() {
    statusSearch(false);
  }
}

class PointRewardsCategoryListConfirm extends GetxController {
  GetMslinfo? mslInfo;
  Menupoint? menuPoint;
  Pointcategory? menuCategory;
  ProductByFscode? productFscode;
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

  get_point_category_confirm(value) async {
    try {
      isDataLoading(true);
      mslInfo = await GetMslInfoSevice();
      menuPoint = await GetPointRewardsMenuCall();
      menuCategory = await GetPointCategoryCall();
      productFscode = await GetProductByFscodeCall(mparmId: value);
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

class OtpTimerController extends GetxController {
  var secondsRemaining = 180.obs;
  RxBool isCountDown = false.obs;
  Timer? _timer;
  void startTimer() {
    _timer?.cancel();
    isCountDown.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        resetTimer();
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    isCountDown.value = false;
    secondsRemaining.value = 180;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
