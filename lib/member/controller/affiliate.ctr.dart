import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.apply.dart';
import 'package:fridayonline/member/controller/category.ctr.dart';
import 'package:get/get.dart';

final CategoryCtr categoryCtr = Get.find();

class AffiliateController extends GetxController {
  // shop info
  RxBool isValidUser = true.obs;
  RxDouble volume = 0.0.obs;
  // shop content
  final contentEmpty = false.obs;

  // shop product
  final productEmpty = false.obs;
  RxInt tabSort = 0.obs;
  RxBool isPriceUp = false.obs;

  // shop category
  final categoryEmpty = false.obs;

  // apply
  final shopNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  final shop = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final agreed = false.obs;

  final submitted = false.obs;
  final RxSet<ApplyField> touched = <ApplyField>{}.obs;
  void markTouched(ApplyField f) => touched.add(f);

  void onShopChanged(String v) => shop.value = v;
  void onEmailChanged(String v) => email.value = v;
  void onPhoneChanged(String v) => phone.value = v;

  String? get errorShop => _vShop(shop.value);
  String? get errorEmail => _vEmail(email.value);
  String? get errorPhone => _vPhone(phone.value);

  bool get showShopError =>
      (submitted.value || touched.contains(ApplyField.shop)) &&
      errorShop != null;
  bool get showEmailError =>
      (submitted.value || touched.contains(ApplyField.email)) &&
      errorEmail != null;
  bool get showPhoneError =>
      (submitted.value || touched.contains(ApplyField.phone)) &&
      errorPhone != null;
  bool get showAgreeError => submitted.value && !agreed.value;

  void toggleAgree() => agreed.toggle();

  // ===== Validators =====
  String? _vShop(String v) => v.trim().isEmpty ? 'กรุณากรอกชื่อร้าน' : null;

  String? _vEmail(String v) {
    final t = v.trim();
    if (t.isEmpty) return 'กรุณากรอกอีเมล';
    final re = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!re.hasMatch(t)) return 'รูปแบบอีเมลไม่ถูกต้อง';
    return null;
  }

  String? _vPhone(String v) {
    final d = v.replaceAll(RegExp(r'\D'), '');
    if (d.isEmpty) return 'กรุณากรอกเบอร์โทร';
    if (d.length != 10) return 'กรุณาใส่เบอร์ 10 หลัก';
    return null;
  }

  bool get isValid =>
      _vShop(shop.value) == null &&
      _vEmail(email.value) == null &&
      _vPhone(phone.value) == null &&
      agreed.value;

  void submit() {
    submitted.value = true;
    if (!isValid) return;
    // TODO: ส่ง API

    isValidUser.value = true;
  }

  void setSortTab(int index, int priceIndex) {
    if (tabSort.value == index && index == priceIndex) {
      isPriceUp.toggle();
    } else {
      tabSort.value = index;
      if (index != priceIndex) {
        isPriceUp.value = false;
      }
    }
  }

  @override
  void onClose() {
    shopNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}
