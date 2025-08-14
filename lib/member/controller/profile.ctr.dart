import 'dart:async';
import 'dart:io';

import 'package:fridayonline/member/models/profile/profile_data.dart';
import 'package:fridayonline/member/models/profile/profile_special.dart';
import 'package:fridayonline/member/services/profile/profile.service.dart';
import 'package:get/get.dart';

class ProfileCtl extends GetxController {
  var isLoading = false.obs;
  var isLoadingSpecial = false.obs;
  var profileData = Rxn<ProfileData>();
  var specialData = Rxn<HomeSpecialB2C>();

  var selectedDay = (DateTime.now().day).obs; // วันที่ปัจจุบัน
  var selectedMonth = (DateTime.now().month).obs; // เดือนปัจจุบัน
  var selectedYear = (DateTime.now().year + 543).obs; // เริ่มต้นด้วย พ.ศ.

  List<int> days = List.generate(31, (index) => index + 1);
  List<String> months = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม'
  ];
  List<int> years =
      List.generate(100, (index) => (DateTime.now().year + 543) - index);

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchSpecialProject();
  }

  String getSelectedDate() {
    return '${selectedDay.value} ${months[selectedMonth.value - 1]} ${selectedYear.value}';
  }

  // ฟังก์ชั่นตรวจสอบวันในเดือน
  int daysInMonth(int month, int year) {
    if (month == 2) {
      if ((year - 543) % 4 == 0 &&
          ((year - 543) % 100 != 0 || (year - 543) % 400 == 0)) {
        return 29; // ปีอธิกสุรทิน
      }
      return 28;
    } else if ([4, 6, 9, 11].contains(month)) {
      return 30;
    } else {
      return 31;
    }
  }

  void updateDays() {
    int daysCount = daysInMonth(selectedMonth.value, selectedYear.value);
    days = List.generate(daysCount, (index) => index + 1);
    if (selectedDay.value > daysCount) {
      selectedDay.value = daysCount;
    }
    update(); // บังคับอัปเดต UI
  }

  // ฟังก์ชั่นตรวจสอบวันที่ไม่เกินวันนี้
  bool isDateValid() {
    final today = DateTime.now();
    final selectedDate = DateTime(
        selectedYear.value - 543, selectedMonth.value, selectedDay.value);
    return selectedDate.isBefore(today) ||
        selectedDate.isAtSameMomentAs(today); // ตรวจสอบว่าเลือกไม่เกินวันนี้
  }

  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      final profile = await ApiProfile().fetchProfile();
      profileData.value = profile;
    } catch (e) {
      print("Error fetchProfile : $e");
    } finally {
      isLoading(false);
    }
  }

  fetchSpecialProject() async {
    try {
      isLoadingSpecial(true);
      final special = await ApiProfile().fetchSpecialProject();
      specialData.value = special;
    } finally {
      isLoadingSpecial(false);
    }
  }

  Future<void> fetchUpdateUserName(String displayName, String gender,
      String birthday, String mobile, String email) async {
    try {
      isLoading(true);
      await ApiProfile().updateUserName(
          displayName: displayName,
          gender: gender,
          birthday: birthday,
          mobile: mobile,
          email: email);
    } catch (e) {
      print("Error fetchUpdateProfile : $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    try {
      isLoading(true);
      // If upload is successful, update the profile image
      await ApiProfile().uploadProfileImage(imageFile);
      profileData.value?.image = imageFile.path;
      profileData.refresh();
    } catch (e) {
      print("Error updating profile image: $e");
    } finally {
      isLoading(false);
    }
  }
}

class ProfileOtpCtr extends GetxController {
  RxInt remainingSeconds = 60.obs;
  RxBool isAccept = false.obs;
  RxInt currentPage = 0.obs;
  List<int> listInterest = <int>[].obs;
  RxString telNumber = "".obs;
  Timer? _timer; // เก็บตัวแปร Timer

  // Start Timer
  void startTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel(); // ถ้ามี Timer อยู่ให้ยกเลิกก่อน
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainingSeconds.value == 0) {
        timer.cancel();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  // reset timer
  void resetTimer() {
    _timer?.cancel(); // ยกเลิก Timer ถ้ามี
    remainingSeconds.value = 60;
  }
}
