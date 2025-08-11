// ignore_for_file: non_constant_identifier_names

import 'package:fridayonline/model/lead/check_status_lead.dart';
import 'package:fridayonline/model/lead/lead_register_model.dart';
import 'package:fridayonline/model/srisawad/register.dart';
import 'package:get/get.dart';

import '../../model/lead/lead_project_model.dart';
import '../../model/register/leadResponse.dart';
import '../../service/lead/check_status_lead.dart';
import '../../service/lead/lead_project_service.dart';
import '../../service/registermember/regis_lead_service.dart';

class LeadRegisterController extends GetxController {
  ResponseLead? leadRegis;
  GetLeadProject? leadProject;
  var isDataLoading = false.obs;
  var projectLoading = false.obs;
  RxBool show = false.obs;
  RxString websiteID = ''.obs;
  lead_register_member(LeadRegisterModel json) async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      leadRegis = await leadRegisterMember(json); //เรียกใช้งาน service
      update();
      return leadRegis;
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  register_srisawad(SrisawadRegister payload) async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      leadRegis = await srisawadRegisterMember(payload); //เรียกใช้งาน service
      update();
      return leadRegis;
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }

  lead_project() async {
    try {
      projectLoading(true); // สถานะการโหลดข้อมูล true
      leadProject = await call_projectLead();
      update();
    } finally {
      projectLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}

class ProfileLeadController extends GetxController {
  CheckStatusLead? leadStatus;
  RxBool showStatusRegis = false.obs;
  var isDataLoading = false.obs;
  check_status_lead() async {
    try {
      isDataLoading(true); // สถานะการโหลดข้อมูล true
      leadStatus = await call_check_status_lead();
      update();
      return leadStatus;
    } finally {
      isDataLoading(false); // สถานะการโหลดข้อมูล false
    }
  }
}
