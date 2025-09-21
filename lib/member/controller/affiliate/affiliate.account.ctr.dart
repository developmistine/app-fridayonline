// lib/member/controller/affiliate/affiliate.account.ctr.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fridayonline/member/components/utils/status.dialog.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:fridayonline/member/services/affiliate/affiliate.service.dart';

enum ApplyField { shop, username, email, phone }

class AffiliateAccountCtr extends GetxController {
  /// ===== Dependencies =====
  late final ProfileCtl profileCtl;
  late final ProfileOtpCtr otpCtl;
  final _service = AffiliateService();

  /// ===== Global / Account Status =====
  final validStatus =
      'not_applied'.obs; // approved | pending | rejected | not_applied
  final validStatusMsg = ''.obs;
  final isCheckingStatus = false.obs;

  /// ===== Apply/Register (ฟอร์มสมัคร) =====
  // controllers
  final shopNameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  // observable values
  final shop = ''.obs;
  final username = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final agreed = false.obs;

  // validation state
  final submitted = false.obs;
  final RxSet<ApplyField> touched = <ApplyField>{}.obs;
  void markTouched(ApplyField f) => touched.add(f);

  // async states
  final isSubmitting = false.obs;

  // username checking
  final isCheckingUsername = false.obs;
  final usernameAvailable = RxnBool();
  final usernameApiMsg = RxnString();

  // --- Validators ---
  String? _vShop(String v) => v.trim().isEmpty ? 'กรุณากรอกชื่อร้าน' : null;
  String? _vEmail(String v) {
    final t = v.trim();
    if (t.isEmpty) return 'กรุณากรอกอีเมล';
    final re = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    return re.hasMatch(t) ? null : 'รูปแบบอีเมลไม่ถูกต้อง';
  }

  String? _vUsername(String v) {
    final t = v.trim();
    if (t.isEmpty) return 'กรุณากรอก Username';
    final re = RegExp(r'^[a-zA-Z0-9._-]+$');
    return re.hasMatch(t) ? null : 'รูปแบบ Username ไม่ถูกต้อง';
  }

  String? _vPhone(String v) {
    final d = v.replaceAll(RegExp(r'\D'), '');
    if (d.isEmpty) return 'กรุณากรอกเบอร์โทร';
    return d.length == 10 ? null : 'กรุณาใส่เบอร์ 10 หลัก';
  }

  String? get errorShop => _vShop(shop.value);
  String? get errorUsername => _vUsername(username.value);
  String? get errorEmail => _vEmail(email.value);
  String? get errorPhone => _vPhone(phone.value);

  bool get showShopError =>
      (submitted.value || touched.contains(ApplyField.shop)) &&
      errorShop != null;
  bool get showUsernameError =>
      (submitted.value || touched.contains(ApplyField.username)) &&
      errorUsername != null;
  bool get showEmailError =>
      (submitted.value || touched.contains(ApplyField.email)) &&
      errorEmail != null;
  bool get showPhoneError =>
      (submitted.value || touched.contains(ApplyField.phone)) &&
      errorPhone != null;
  bool get showAgreeError => submitted.value && !agreed.value;

  bool get isValid =>
      _vShop(shop.value) == null &&
      _vUsername(username.value) == null &&
      _vEmail(email.value) == null &&
      _vPhone(phone.value) == null &&
      agreed.value;

  // ======= PUBLIC MUTATORS =======
  void toggleAgree() => agreed.toggle();
  void onShopChanged(String v) => shop.value = v;
  void onUsernameChanged(String v) => username.value = v;
  void onEmailChanged(String v) => email.value = v;
  void onPhoneChanged(String v) => phone.value = v;

  @override
  void onInit() {
    super.onInit();

    profileCtl = Get.put(ProfileCtl());
    otpCtl = Get.put(ProfileOtpCtr());

    ever(profileCtl.profileData, _prefillFromProfile);

    // sync controller <-> rx
    ever(shop, (v) => shopNameCtrl.text = v);
    ever(username, (v) => usernameCtrl.text = v);
    ever(email, (v) => emailCtrl.text = v);
    ever(phone, (v) => phoneCtrl.text = v);

    // debounce ตรวจสอบ username
    debounce<String>(
      username,
      (val) async {
        if (_vUsername(val) != null) {
          usernameAvailable.value = null;
          usernameApiMsg.value = null;
          return;
        }
        await _checkUsername(val);
      },
      time: const Duration(milliseconds: 500),
    );

    // โหลดสถานะครั้งแรก
    Future.microtask(checkStatus);
  }

  @override
  void onReady() {
    super.onReady();
    if (!isCheckingStatus.value) checkStatus();
  }

  @override
  void onClose() {
    shopNameCtrl.dispose();
    usernameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    clearForm();
    super.onClose();
  }

  // ================  ACCOUNT STATUS  ==================
  Future<void> checkStatus() async {
    if (isCheckingStatus.value) return;
    isCheckingStatus.value = true;
    try {
      final res = await _service.checkStatus();
      validStatus.value = res?.status ?? 'not_applied';
      validStatusMsg.value =
          res?.message ?? 'การสมัครของท่านอยู่ระหว่างการตรวจสอบข้อมูล';
    } catch (_) {
      // เงียบไว้เหมือนเดิม
    } finally {
      isCheckingStatus.value = false;
    }
  }

  // ==============  USERNAME CHECK FLOW  ==============
  Future<void> _checkUsername(String val) async {
    isCheckingUsername.value = true;
    try {
      final u = await _service.checkUsername(val);
      final ok = u?.available ?? false;
      usernameAvailable.value = ok;
      usernameApiMsg.value = u?.message;
    } catch (_) {
      usernameAvailable.value = null;
      usernameApiMsg.value = 'ตรวจสอบชื่อผู้ใช้ไม่สำเร็จ';
    } finally {
      isCheckingUsername.value = false;
    }
  }

  // ===============  REGISTER FLOW  ===================
  void clearForm() {
    shop.value = '';
    username.value = '';
    email.value = '';
    phone.value = '';
    agreed.value = false;

    submitted.value = false;
    touched.clear();

    usernameAvailable.value = null;
    usernameApiMsg.value = null;

    shopNameCtrl.clear();
    usernameCtrl.clear();
    emailCtrl.clear();
    phoneCtrl.clear();
  }

  void _prefillFromProfile(dynamic p) {
    if (p == null) return;
    if (email.value.isEmpty && !touched.contains(ApplyField.email)) {
      final e = p.email ?? '';
      email.value = e;
      if (emailCtrl.text != e) emailCtrl.text = e;
    }
    if (phone.value.isEmpty && !touched.contains(ApplyField.phone)) {
      final m = p.mobile ?? '';
      phone.value = m;
      if (phoneCtrl.text != m) phoneCtrl.text = m;
    }
  }

  Future<bool> _registerAffiliate() async {
    isSubmitting.value = true;
    try {
      final res = await _service.register(
        username: username.value.trim(),
        shopName: shop.value.trim(),
        email: email.value.trim(),
        mobile: phone.value.trim(),
      );

      final ok = (res?.code.toString() == '100');
      if (ok) {
        await showAffDialog(true, 'สำเร็จ', 'ส่งคำขอเรียบร้อย');

        // อัปเดตสถานะหลังสมัคร
        validStatus.value = 'pending';
        validStatusMsg.value = 'การสมัครของท่านอยู่ระหว่างการตรวจสอบข้อมูล';

        FocusManager.instance.primaryFocus?.unfocus();
        clearForm();
        return true;
      } else {
        await showAffDialog(
          false,
          'เกิดข้อผิดพลาด',
          res?.message ?? 'ลงทะเบียนไม่สำเร็จ',
        );
        return false;
      }
    } catch (e) {
      Get.snackbar('ผิดพลาด', '$e');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> submit() async {
    submitted.value = true;

    final canSubmit = isValid && (usernameAvailable.value == true);
    if (!canSubmit) return;

    await _registerAffiliate();
  }
}
