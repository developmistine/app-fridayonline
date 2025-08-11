import 'package:get/get.dart';
import '../service/profileuser/getprofile.dart';
import '../service/profileuser/mslinfo.dart';
import '../service/profileuser/profileuser_menu_special_project.dart';

class ProfileController extends GetxController {
  Mslinfo? profile;
  var isDataLoading = false.obs;

  get_profile_data() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      profile = await getProfileMSL(); //เรียกใช้งาน service
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

class ProfileSpecialProjectController extends GetxController {
  Menuspecialproject? specialproject;
  var isDataLoading = false.obs;

  get_special_project_data() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      specialproject = await getspecialproject(); //เรียกใช้งาน service
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}
