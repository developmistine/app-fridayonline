import 'package:get/get.dart';
import '../../model/market/market_lode_product.dart';
import '../../service/market/market_service.dart';

class MarketLoadmoreController extends GetxController {
  MarketLoadmore? item; //เรียกใช้ model ProductHotItemLoadmore
  var isAddLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  var itemList = List<ProductRecommend>.empty(growable: true).obs;
  var itemProduct = 0;

  void resetItem() {
    itemList.clear();
    itemProduct = 0;
  }

  void addItem() async {
    //ฟังก์ชันสำหรับเรีกข้อมูล Load more
    try {
      itemProduct = 0;
      isAddLoading(true); // สถานะการโหลดข้อมูล true
      item =
          await getMarketlodeProductCall(); //เรียกใช้งาน service สำหรับเรีกข้อมูล Load more
      itemProduct = item!.productRecommend.length;
      itemList.addAll(item!.productRecommend);
    } finally {
      isAddLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}
