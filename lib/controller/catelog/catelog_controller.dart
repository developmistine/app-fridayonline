// ignore_for_file: non_constant_identifier_names

import '../../model/catelog/catelog_detail.dart';
import '../../model/catelog/catelog_ecatalog.dart';
import '../../model/catelog/catelog_hand_bill.dart';
import '../../model/catelog/catelog_list_product_by_page.dart';
import '../../service/catelog/catelog_service.dart';
import 'package:get/get.dart';

class CatelogController extends GetxController {
  //Controller สำหรับเรียกข้อมูลรายละเอียดแค็ตตาล็อก
  CatelogEcatalogDetail? eCatalog; //เรียกใช้ model CatelogEcatalogDetail
  CatelogHandBillDetail? hCatalog; //เรียกใช้ model CatelogHandBillDetail
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  get_catelog() async {
    //ฟังก์ชัันสำหรับเรียกข้อมูลรายละเอียดเล่มแค็ตตาล็อก
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      eCatalog =
          await get_catelog_EcatalogDetail(); //เรียกใช้งาน service สำหรับเรียกข้อมูลแค็ตตาล็อก
      hCatalog =
          await get_catelog_HendBillDetail(); //เรียกใช้งาน service สำหรับเรียกข้อมูลแค็ตตาล็อก
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

class CatelogDetailController extends GetxController {
  //Controller สำหรับเรียกข้อมูลรายละเอียดแค็ตตาล็อก
  CatelogDetail? catelog_detail; //เรียกใช้ model CatelogDetail
  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล
  // ignore: prefer_typing_uninitialized_variables
  var text_bottom; //ใช้เก็บสถานะสินค้าหน้าแรกของเล่มแค็ตตาล็อก

  get_catelog_detail(CatalogCampaign, CatalogBrand, CatalogMedia) async {
    //ฟังก์ชัันสำหรับเรียกข้อมูลรายละเอียดเล่มแค็ตตาล็อก
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      catelog_detail = await call_catelog_detail(CatalogCampaign, CatalogBrand,
          CatalogMedia); //เรียกใช้งาน service สำหรับเรียกข้อมูลรายละเอียดเล่มแค็ตตาล็อก

      //ตรวจสอบว่าหน้าแรกของเล่มแค็ตตาล็อกมีสินค้าไหม
      if (catelog_detail?.ecatalogDetail[0].flagViewProduct == 'Y') {
        //กรณีที่มีสินค้า
        text_bottom =
            'ดูรายการสินค้า'; //ให้ สถานะสินค้าหน้าแรกของเล่มแค็ตตาล็อก = ดูรายการสินค้า
      } else {
        //กรณีที่ไม่มีสินค้า
        text_bottom =
            'เลื่อนหน้าถัดไป'; //ให้ สถานะสินค้าหน้าแรกของเล่มแค็ตตาล็อก = เลื่อนหน้าถัดไป
      }
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  set_text_bottom(flagViewProduct) async {
    //ฟังก์ชัันสำหรับเซ็ตสถานะสินค้าหน้าแรกของเล่มแค็ตตาล็อก

    if (flagViewProduct == 'Y') {
      //ถ้าสถานะ =  Y
      text_bottom =
          'ดูรายการสินค้า'; //ให้ สถานะสินค้าหน้าแรกของเล่มแค็ตตาล็อก = ดูรายการสินค้า
    } else {
      text_bottom =
          'เลื่อนหน้าถัดไป'; //ให้ สถานะสินค้าหน้าแรกของเล่มแค็ตตาล็อก = เลื่อนหน้าถัดไป
    }
  }
}

class CatelogSetFirstPageController extends GetxController {
  // Controller สำหรับเซ็นหน้าเล่มแค็ตตาล็อกเมื่อกดเลือกมาจาก ลิสแค็ตตาล็อก
  // ignore: prefer_typing_uninitialized_variables
  var page; //ใช้สำหรับเก็บ index ของหน้าแค็ตตาล็อกที่เลือกมาจากหน้า ลิสแค็ตตาล็อก
  var pageName;

  set_first_page(index, pageDetail) {
    page = index; //เซ็ตให้แสดง หน้าที่เลือกก่อน
    pageName = pageDetail;
  }
}

class CatelogListProductByPageController extends GetxController {
  // Controller สำหรับเรียกข้อมูลสินค้าที่อยู่ในหน้าแค็ตตาล็อก
  CatalogListProductByPage?
      catelog_list_product_by_page; //เรียกใช้ model CatelogDetail

  var isDataLoading = false.obs; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

  get_catelog_list_product_by_page(
      PageDetail, Campaign, Brand, MediaCode) async {
    //ฟังก์ชันสำหรับเรียกข้อมูลสินค้าที่อยู่ในหน้าแค็ตตาล็อก
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล = true
      catelog_list_product_by_page = await call_catelog_list_product_by_page(
          PageDetail,
          Campaign,
          Brand,
          MediaCode); //เรียกใช้งาน service สำหรับเรียกข้อมูลสินค้าที่อยู่ในหน้าแค็ตตาล็อก
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล = false
    }
  }
}
