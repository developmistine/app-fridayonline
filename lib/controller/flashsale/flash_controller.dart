import 'dart:async';
// import 'dart:developer';
// import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:get/get.dart';

import '../../model/flashsale/flashsale.dart';
import '../../service/flashsale/flashsale_service.dart';

class FlashsaleTimerCount extends GetxController {
  Timer? countdownTimer;
  late Duration myDuration;
  Flashsale? flashSaleData;
  var isDataLoading = false.obs;

  RxString days = "".obs;
  RxString hours = "".obs;
  RxString minutes = "".obs;
  RxString seconds = "".obs;
  RxString limitTime = "".obs;
  late DateTime dateNow;
  DateTime? dataEndApi;
  DateTime? dataStartApi;
  @override
  void onInit() {
    super.onInit();
    flashSaleHome();
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    final secondsCount = 0.obs;
    secondsCount.value = myDuration.inSeconds - reduceSecondsBy;
    if (secondsCount.value < 0) {
      countdownTimer!.cancel();
      Get.put(FlashsaleTimerCount()).flashSaleHome();
      update();
    } else {
      myDuration = Duration(seconds: secondsCount.value);
    }
    String strDigits(int n) => n.toString().padLeft(2, '0');
    days.value = strDigits(myDuration.inDays); //
    hours.value = strDigits(myDuration.inHours.remainder(23));
    minutes.value = strDigits(myDuration.inMinutes.remainder(60));
    seconds.value = strDigits(myDuration.inSeconds.remainder(60));
  }

  flashSaleHome() async {
    try {
      var now = DateTime.now();

      isDataLoading(true);
      flashSaleData = await FlashsaleHomeService();
      update();
      //?end
      var apiEndDate = flashSaleData!.flashSale[0].endDate;
      var apiEndTime = flashSaleData!.flashSale[0].endTime;
      //?start
      var apiStartDate = flashSaleData!.flashSale[0].startDate;
      var apiStartTime = flashSaleData!.flashSale[0].startTime;
      //? end
      var dateEndConvert = apiEndDate.split('/');
      var timeEndConvert = apiEndTime.split(':');
      //? start
      var dateStartConvert = apiStartDate.split('/');
      var timeStartConvert = apiStartTime.split(':');
      //? หาค่าเวลาปัจจุบัน
      dateNow = DateTime(
          now.year, now.month, now.day, now.hour, now.minute, now.second);
      //? รับค่ามาเซ็ตเป็นวันเวลาสิ้นสุดจาก api
      dataEndApi = DateTime(
          int.parse(dateEndConvert[2]),
          int.parse(dateEndConvert[1]),
          int.parse(dateEndConvert[0]),
          int.parse(timeEndConvert[0]),
          int.parse(timeEndConvert[1]),
          00);
      //? รับค่ามาเซ็ตเป็นวันเวลาเริ่มจาก api
      dataStartApi = DateTime(
          int.parse(dateStartConvert[2]),
          int.parse(dateStartConvert[1]),
          int.parse(dateStartConvert[0]),
          int.parse(timeStartConvert[0]),
          int.parse(timeStartConvert[1]),
          00);

      //? คำนวณ
      // log('$dataEndApi : $dateNow');
      // log((dataEndApi.compareTo(dateNow)).toString());
      if (dataStartApi!.compareTo(dateNow) <= 0 &&
          dataEndApi!.compareTo(dateNow) >= 0) {
        final Duration duration = dataEndApi!.difference(dateNow);
        int hours = 0;
        int minutes = 0;
        int second = 0;
        List<String> parts = duration.toString().split(':');
        if (parts.length > 2) {
          hours = int.parse(parts[parts.length - 3]);
          hours < 0 ? hours = 0 : hours = hours;
        }
        if (parts.length > 1) {
          minutes = int.parse(parts[parts.length - 2]);
          minutes < 0 ? minutes = 0 : minutes = minutes;
        }
        if (parts.isNotEmpty) {
          second = double.parse(parts[parts.length - 1]).toInt();
          second < 0 ? second = 0 : second = second;
        }
        myDuration = Duration(hours: hours, minutes: minutes, seconds: second);
        countdownTimer =
            Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isDataLoading(false);
    }
  }
}
