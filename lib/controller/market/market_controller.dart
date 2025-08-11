// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import '../../model/market/market_home_model.dart';
import '../../service/market/market_service.dart';
class MarketController extends GetxController {
  MarketMainPageModel? banner; //เรียกใช้ model MarketMainPageModel
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  var statusReload = false;

  get_market_data() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      banner =
          await fetchMarketMainPage(); //เรียกใช้งาน service สำหรับเรีกข้อมูล maeket
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
      statusReload = true;
    }
  }

  set_reload() {
    statusReload = false;
  }


}



