// import 'dart:developer';
import 'package:fridayonline/model/register/addressuser.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:http/http.dart' as http;

// Path  URL ในการ Get  API เพื่อมาทำการแสดงข้อมูล
// ระบบทำการไป Call Path จากตัวหลักกลับมาเพื่อที่จะทำการแสดงข้อมูล
String baseurl = "${baseurl_yupinmodern}api/addressremove";
Map<String, String> headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

// เป็นส่วนที่ระบบทำการ Get ข้อม
Future<Addressuser> GetAddresslocation() async {
  var url = Uri.parse(baseurl);
  var response = await http.get(url);

  // log('${response.statusCode}');
  //serviceaddress.dart log('${response.body}');

  // กรณีที่ทำการ GetData ออกมาได้แล้ว
  var jsonString = response.body;
  // ข้อมูลที่เก็บเข้ามาก็ตามโครงสร้างของระบบเลย
  Addressuser addresslist = addressuserFromJson(jsonString);
  // ดูก่อนว่ามี Data กี่ตัวก่อน

  return addresslist;
}

// เป็นส่วนที่ส่งข้อมูลเข้ามา  เพื่อที่จะทำการแก้ไขและเปลี่ยนแปลงที่อยู่
// ส่ง Parameter ในการรับส่งข้อมูลให้เรียบร้อย
Future<bool> CustomerEditAddress(
    String repCode,
    String repSeq,
    String address,
    String tumbon,
    String tumbonID,
    String amphur,
    String amphurID,
    String province,
    String provinceID,
    String postCode,
    String option) async {
  return true;
}
