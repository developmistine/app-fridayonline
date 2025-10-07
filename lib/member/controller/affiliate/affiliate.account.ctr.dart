// lib/member/controller/affiliate/affiliate.account.ctr.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fridayonline/member/models/affiliate/bank.model.dart' as bank;
import 'package:fridayonline/member/models/affiliate/profile.model.dart'
    as profile;
import 'package:fridayonline/member/models/affiliate/payment.model.dart'
    as payment;
import 'package:fridayonline/member/models/affiliate/option.model.dart'
    as option;
import 'package:fridayonline/member/models/affiliate/share.model.dart';
import 'package:fridayonline/member/models/affiliate/tips.model.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';

import 'package:fridayonline/member/components/utils/status.dialog.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:fridayonline/member/services/affiliate/affiliate.service.dart';
import 'package:image_picker/image_picker.dart';

enum ApplyField { shop, username, email, phone }

enum PaymentField {
  prefix,
  firstName,
  lastName,
  address,
  addressPick,
  phone,
  accountType,
  bankId,
  bankBranch,
  bankName,
  bankNumber,
  bookBank,
  thaiIdCard,
  taxId,
}

enum PaymentPageMode { view, edit }

class AffiliateAccountCtr extends GetxController {
  /// ===== Dependencies =====
  // late final ProfileCtl profileCtl;
  late final ProfileOtpCtr otpCtl;
  final _service = AffiliateService();

  /// ===== Global / Account Status =====
  final validStatus =
      'not_applied'.obs; // approved | pending | rejected | not_applied
  final validStatusMsg = ''.obs;
  final isCheckingStatus = false.obs;
  final paymentStatus = 'draft'.obs; // approved | pending | rejected | draft
  final paymentMode = PaymentPageMode.view.obs;
  //profile
  final isLoadingTipsSlide = false.obs;
  final isLoadingProfileData = false.obs;
  final isLoadingPaymentInfo = false.obs;
  final isSavingPayment = false.obs;
  final RxList<AffiliateTipsData> tipsSlideData = <AffiliateTipsData>[].obs;
  final Rxn<payment.Data> paymentInfo = Rxn<payment.Data>();
  final Rxn<profile.Data> profileData = Rxn<profile.Data>();
  final Rxn<List<bank.Datum>> bankData = Rxn<List<bank.Datum>>();
  final Rxn<List<option.Datum>> prefixData = Rxn<List<option.Datum>>();
  final Rxn<int> totalItems = Rxn<int>();

  //share
  final isLoadingShareData = false.obs;
  final Rxn<ShareData> shareData = Rxn<ShareData>();

  /// ===== Apply/Register (ฟอร์มสมัคร) =====
  // controllers
  final shopNameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  // payment
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final bankbranchCtrl = TextEditingController();
  final bankNameCtrl = TextEditingController();
  final bankNumberCtrl = TextEditingController();
  final taxIdCtrl = TextEditingController();

  // observable values
  final shop = ''.obs;
  final username = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final agreed = false.obs;
  final cover = ''.obs;
  final image = ''.obs;
  final Rxn<File> coverFile = Rxn<File>();
  final Rxn<File> avatarFile = Rxn<File>();

  final firstname = ''.obs;
  final lastname = ''.obs;
  final address = ''.obs;
  final selectedAddressText = RxnString();
  final provinceId = RxnInt();
  final amphurId = RxnInt();
  final tambonId = RxnInt();
  final postCode = RxnString();
  final bankId = RxnInt();
  final bankBranch = RxnString();
  final bankName = RxnString();
  final bankNumber = RxnString();
  final Rxn<File> bookBankFile = Rxn<File>();
  final Rxn<File> thaiIdCardFile = Rxn<File>();
  final bookBankUrl = RxnString();
  final thaiIdCardUrl = RxnString();
  final taxId = ''.obs;

  final selectedAccountTypeId = RxnInt();
  final prefix = RxnInt();

  // validation state
  final submitted = false.obs;
  final submittedBank = false.obs;
  final submittedTax = false.obs;
  final RxSet<ApplyField> touched = <ApplyField>{}.obs;
  final RxSet<PaymentField> paymentTouched = <PaymentField>{}.obs;
  void markTouched(ApplyField f) => touched.add(f);
  void markPaymentTouched(PaymentField f) => paymentTouched.add(f);

  // async states
  final isSubmitting = false.obs;

  // username checking
  final isCheckingUsername = false.obs;
  final usernameAvailable = RxnBool();
  final usernameApiMsg = RxnString();

  // --- Validators ---
  String? _vShop(String v) {
    final t = v.trim();
    if (t.isEmpty) return 'กรุณากรอกชื่อร้าน';
    if (t.length > 50) return 'ชื่อร้านต้องไม่เกิน 50 ตัวอักษร';
    return null;
  }

  String? _vEmail(String v) {
    final t = v.trim();
    if (t.isEmpty) return 'กรุณากรอกอีเมล';
    final re = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    return re.hasMatch(t) ? null : 'รูปแบบอีเมลไม่ถูกต้อง';
  }

  String? _vUsername(String v) {
    final t = v.trim();
    if (t.isEmpty) return 'กรุณากรอก Username';
    if (t.length > 24) return 'ไม่เกิน 24 ตัวอักษร';

    final re = RegExp(r'^[a-zA-Z0-9._-]+$');
    return re.hasMatch(t) ? null : 'รูปแบบ Username ไม่ถูกต้อง';
  }

  String? _vPhone(String v) {
    final d = v.replaceAll(RegExp(r'\D'), '');
    if (d.isEmpty) return 'กรุณากรอกเบอร์โทร';
    return d.length == 10 ? null : 'กรุณาใส่เบอร์ 10 หลัก';
  }

  String? _vNonEmpty(String? v) {
    final t = (v ?? '').trim();
    return t.isEmpty ? 'กรุณาระบุ' : null;
  }

  String? _vBankNumber(String? v) {
    final d = (v ?? '').replaceAll(RegExp(r'\D'), '');
    if (d.isEmpty) return 'กรุณาระบุ';
    if (d.length < 10 || d.length > 12) return 'รูปแบบเลขบัญชีไม่ถูกต้อง';
    return null;
  }

  String? _vThaiTaxId(String v) {
    final d = v.replaceAll(RegExp(r'\D'), '');
    if (d.isEmpty) return 'กรุณาระบุ';
    if (d.length != 13) return 'กรุณาระบุให้ครบ 13 หลัก';

    if (RegExp(r'^(\d)\1{12}$').hasMatch(d)) return 'รูปแบบไม่ถูกต้อง';

    int sum = 0;
    for (int i = 0; i < 12; i++) {
      sum += int.parse(d[i]) * (13 - i);
    }
    final check = (11 - (sum % 11)) % 10;
    if (check != int.parse(d[12])) return 'เลขบัตรประชาชนไม่ถูกต้อง';
    return null;
  }

  String? get errorShop => _vShop(shop.value);
  String? get errorUsername => _vUsername(username.value);
  String? get errorEmail => _vEmail(email.value);
  String? get errorPhone => _vPhone(phone.value);
  String? get errorFirstName => _vNonEmpty(firstname.value);
  String? get errorLastName => _vNonEmpty(lastname.value);
  String? get errorAddress => _vNonEmpty(address.value);
  String? get errorAccountType =>
      selectedAccountTypeId.value == null ? 'กรุณาเลือกประเภทบัญชี' : null;
  String? get errorAddressPick =>
      selectedAddressText.value == null ? 'กรุณาเลือกที่อยู่' : null;
  String? get errorBankId => bankId.value == null ? 'กรุณาเลือกธนาคาร' : null;
  String? get errorBankBranch => _vNonEmpty(bankBranch.value);
  String? get errorBankName => _vNonEmpty(bankName.value);
  String? get errorBankNumber => _vBankNumber(bankNumber.value);
  String? get errorBookBank =>
      hasBookBankImage ? null : 'กรุณาอัปโหลดรูปหน้าบัญชีธนาคาร';
  String? get errorThaiIdCard =>
      hasThaiIdCardImage ? null : 'กรุณาอัปโหลดรูปบัตรประจำตัวประชาชน';
  String? get errorPrefix => prefix.value == null ? 'กรุณาเลือกคำนำหน้า' : null;

  String? get errorTaxId => _vThaiTaxId(taxId.value);

  bool get hasBookBankImage =>
      bookBankFile.value != null ||
      (bookBankUrl.value?.trim().isNotEmpty ?? false);

  bool get hasThaiIdCardImage =>
      thaiIdCardFile.value != null ||
      (thaiIdCardUrl.value?.trim().isNotEmpty ?? false);

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
  bool get showFirstNameError =>
      (submitted.value || paymentTouched.contains(PaymentField.firstName)) &&
      errorFirstName != null;
  bool get showLastNameError =>
      (submitted.value || paymentTouched.contains(PaymentField.lastName)) &&
      errorLastName != null;
  bool get showAddressError =>
      (submitted.value || paymentTouched.contains(PaymentField.address)) &&
      errorAddress != null;
  bool get showPhoneErrorPayment =>
      (submitted.value || paymentTouched.contains(PaymentField.phone)) &&
      errorPhone != null;
  bool get showPrefixError =>
      (submitted.value || paymentTouched.contains(PaymentField.accountType)) &&
      errorPrefix != null;
  bool get showAccountTypeError =>
      (submitted.value || paymentTouched.contains(PaymentField.accountType)) &&
      errorAccountType != null;
  bool get showAddressPickError =>
      (submitted.value || paymentTouched.contains(PaymentField.addressPick)) &&
      errorAddressPick != null;
  bool get showBankIdError =>
      (submittedBank.value || paymentTouched.contains(PaymentField.bankId)) &&
      errorBankId != null;
  bool get showBankBranchError =>
      (submittedBank.value ||
          paymentTouched.contains(PaymentField.bankBranch)) &&
      errorBankBranch != null;
  bool get showBankNameError =>
      (submittedBank.value || paymentTouched.contains(PaymentField.bankName)) &&
      errorBankName != null;

  bool get showBankNumberError =>
      (submittedBank.value ||
          paymentTouched.contains(PaymentField.bankNumber)) &&
      errorBankNumber != null;
  bool get showBookBankError =>
      (submittedBank.value || paymentTouched.contains(PaymentField.bookBank)) &&
      errorBookBank != null;
  bool get showThaiIdCardError =>
      (submittedTax.value ||
          paymentTouched.contains(PaymentField.thaiIdCard)) &&
      errorThaiIdCard != null;
  bool get showTaxIdError =>
      (submittedTax.value || paymentTouched.contains(PaymentField.taxId)) &&
      errorTaxId != null;

  bool get _basicFieldsValid =>
      _vShop(shop.value) == null &&
      _vUsername(username.value) == null &&
      _vEmail(email.value) == null &&
      _vPhone(phone.value) == null;

  bool get isPaymentStep1Valid =>
      errorPrefix == null &&
      errorAccountType == null &&
      errorFirstName == null &&
      errorLastName == null &&
      errorPhone == null &&
      errorAddress == null &&
      errorAddressPick == null;

  bool get isPaymentStep2Valid =>
      errorBankId == null &&
      errorBankBranch == null &&
      errorBankName == null &&
      errorBankNumber == null &&
      errorBookBank == null;

  bool get isPaymentStep3Valid => errorThaiIdCard == null && errorTaxId == null;

  bool get isValid => isValidByMode(isUpdate: false);

  bool get isValidForUpdate => isValidByMode(isUpdate: true);

  bool isValidByMode({required bool isUpdate}) {
    return isUpdate ? _basicFieldsValid : (_basicFieldsValid && agreed.value);
  }

  final _picker = ImagePicker();

  Future<void> pickThaiIdCard(ImageSource src) async {
    final x = await _picker.pickImage(source: src, imageQuality: 85);
    if (x != null) thaiIdCardFile.value = File(x.path);
  }

  Future<void> pickBookBank(ImageSource src) async {
    final x = await _picker.pickImage(source: src, imageQuality: 85);
    if (x != null) bookBankFile.value = File(x.path);
  }

  Future<void> pickCover() async {
    final x =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (x != null) coverFile.value = File(x.path);
  }

  Future<void> pickAvatar() async {
    final x =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (x != null) avatarFile.value = File(x.path);
  }

  void onTaxIdChanged(String v) => taxId.value = v;
  void setAccountType(int id) {
    selectedAccountTypeId.value = id;
  }

  void setPrefix(int id) {
    prefix.value = id;
  }

  void setSelectedAddress(Map data) {
    int? toInt(dynamic v) =>
        v is int ? v : (v is String ? int.tryParse(v) : null);

    selectedAddressText.value = data['display_text'] as String?;
    provinceId.value = toInt(data['province_id']);
    amphurId.value = toInt(data['amphur_id']);
    tambonId.value = toInt(data['tambon_id']);
    postCode.value = (data['post_code']?.toString());
  }

  void enterEdit() => paymentMode.value = PaymentPageMode.edit;
  void exitEdit() => paymentMode.value = PaymentPageMode.view;

  void decideInitialMode() {
    paymentMode.value = (paymentStatus.value == 'draft')
        ? PaymentPageMode.edit
        : PaymentPageMode.view;
  }

  // ======= PUBLIC MUTATORS =======
  void toggleAgree() => agreed.toggle();
  void onShopChanged(String v) => shop.value = v;
  void onUsernameChanged(String v) => username.value = v;
  void onEmailChanged(String v) => email.value = v;
  void onPhoneChanged(String v) => phone.value = v;
  void onFirstNameChanged(String v) => firstname.value = v;
  void onLastNameChanged(String v) => lastname.value = v;
  void onAddressChanged(String v) => address.value = v;
  void setBankId(int id) => bankId.value = id;
  void onBankBranchChanged(String v) => bankBranch.value = v;
  void onBankNameChanged(String v) => bankName.value = v;
  void onBankNumberChanged(String v) => bankNumber.value = v;

  @override
  void onInit() {
    super.onInit();

    final profileCtl = Get.put(ProfileCtl());
    otpCtl = Get.put(ProfileOtpCtr());

    ever(profileCtl.profileData, prefillFromProfile);

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

    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    addressCtrl.dispose();
    bankbranchCtrl.dispose();
    bankNameCtrl.dispose();
    bankNumberCtrl.dispose();
    taxIdCtrl.dispose();

    clearForm();
    super.onClose();
  }

  // ================  ACCOUNT STATUS  ==================
  Future<void> checkStatus() async {
    if (isCheckingStatus.value) return;
    isCheckingStatus.value = true;
    try {
      final res = await _service.checkStatus();
      if (res?.status == 'approved') {
        await getProfile();
      }
      validStatus.value = res?.status ?? 'not_applied';
      validStatusMsg.value =
          res?.message ?? 'การสมัครของท่านอยู่ระหว่างการตรวจสอบข้อมูล';
    } catch (_) {
      // เงียบไว้เหมือนเดิม
    } finally {
      isCheckingStatus.value = false;
    }
  }

  Future<void> getProfile() async {
    isLoadingProfileData.value = true;
    try {
      final res = await _service.getProfile();
      profileData.value = res?.data;
      totalItems.value = res?.data.itemCount;
    } catch (_) {
    } finally {
      isLoadingProfileData.value = false;
    }
  }

  Future<void> getPaymentInfo() async {
    isLoadingPaymentInfo.value = true;
    try {
      final res = await _service.getPaymentInfo();
      final d = res?.data;
      paymentInfo.value = d;
      if (d != null) {
        paymentStatus.value = d.statusCode;
        _applyPaymentInfoToState(d);
      }
      decideInitialMode();
    } catch (_) {
    } finally {
      isLoadingPaymentInfo.value = false;
    }
  }

  Future<void> getBank() async {
    try {
      final res = await _service.getBank();
      bankData.value = res?.data ?? [];
    } catch (_) {
    } finally {}
  }

  Future<void> getPrefix() async {
    try {
      final res = await _service.getPrefix();
      prefixData.value = res?.data ?? [];
    } catch (_) {
    } finally {}
  }

  Future<void> getAffiliateTips() async {
    isLoadingTipsSlide.value = true;
    try {
      final res = await _service.getAffiliateTips();
      tipsSlideData.assignAll(res?.data ?? []);
    } catch (e, _) {
      tipsSlideData.value = [];
    } finally {
      isLoadingTipsSlide.value = false;
    }
  }

  Future<ShareData?> getShareData({
    required String shareType,
    required int productId,
    required String channel,
    required int? categoryId,
  }) async {
    isLoadingShareData.value = true;
    try {
      final res = await _service.getShare(
        shareType: shareType,
        productId: productId,
        channel: channel,
        categoryId: categoryId,
      );
      return res?.data;
    } catch (e, _) {
      shareData.value = null;
      return null;
    } finally {
      isLoadingShareData.value = false;
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

  void clearBookBank() {
    bookBankFile.value = null;
    bookBankUrl.value = null;
  }

  void clearThaiIdCard() {
    thaiIdCardFile.value = null;
    thaiIdCardUrl.value = null;
  }

  void clearForm() {
    shop.value = '';
    username.value = '';
    email.value = '';
    phone.value = '';
    agreed.value = false;

    prefix.value = null;
    firstname.value = '';
    lastname.value = '';
    address.value = '';
    firstNameCtrl.clear();
    lastNameCtrl.clear();
    addressCtrl.clear();
    selectedAccountTypeId.value = null;
    selectedAddressText.value = null;
    provinceId.value = amphurId.value = tambonId.value = null;
    postCode.value = null;
    selectedAddressText.value = null;
    bankId.value = null;
    bankBranch.value = null;
    bankName.value = null;

    bankNumber.value = null;
    bankbranchCtrl.clear();
    bankNameCtrl.clear();
    bankNumberCtrl.clear();
    bookBankFile.value = null;
    taxId.value = '';
    taxIdCtrl.clear();
    thaiIdCardFile.value = null;

    submitted.value = false;
    submittedBank.value = false;
    submittedTax.value = false;
    paymentTouched.clear();
    touched.clear();
    usernameAvailable.value = null;
    usernameApiMsg.value = null;

    shopNameCtrl.clear();
    usernameCtrl.clear();
    emailCtrl.clear();
    phoneCtrl.clear();

    coverFile.value = null;
    avatarFile.value = null;
  }

  void clearAfterUpdate() {
    submitted.value = false;
    touched.clear();
    usernameApiMsg.value = null;

    coverFile.value = null;
    avatarFile.value = null;
  }

  void prefillFromProfile(dynamic p) {
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

  String _buildAddressDisplay({
    String? tambon,
    String? amphur,
    String? province,
    String? postCode,
  }) {
    final parts = <String>[
      if ((tambon ?? '').trim().isNotEmpty) tambon!.trim(),
      if ((amphur ?? '').trim().isNotEmpty) amphur!.trim(),
      if ((province ?? '').trim().isNotEmpty) province!.trim(),
      if ((postCode ?? '').trim().isNotEmpty) postCode!.trim(),
    ];
    return parts.join(' ');
  }

  void _applyPaymentInfoToState(payment.Data d) {
    final a = d.accountInfo;
    final b = d.bankInfo;
    final t = d.taxInfo;

    final addressText = _buildAddressDisplay(
      tambon: a.tumbon,
      amphur: a.amphur,
      province: a.province,
      postCode: a.postCode,
    );
    // ---- STEP 1: ผู้รับผลประโยชน์ ----
    selectedAccountTypeId.value =
        a.accountType == 'บุคคลธรรมดา' ? 1 : 2; // int?
    prefix.value = a.prenameId == 0 ? null : a.prenameId;
    firstname.value = a.firstName;
    lastname.value = a.lastName;
    phone.value = a.phone;
    address.value = a.address1;

    provinceId.value = a.provinceId;
    amphurId.value = a.amphurId;
    tambonId.value = a.tumbonId;
    postCode.value = a.postCode.toString();
    selectedAddressText.value =
        (a.amphurId == 0 || a.tumbonId == 0 || a.provinceId == 0)
            ? null
            : addressText;

    firstNameCtrl.text = firstname.value;
    lastNameCtrl.text = lastname.value;
    phoneCtrl.text = phone.value;
    addressCtrl.text = address.value;

    // ---- STEP 2: ธนาคาร ----
    bankId.value = b.bankId;
    bankBranch.value = b.bankBranchAddress;
    bankName.value = b.bankAccountName;
    bankNumber.value = b.bankAccountNumber;

    bankbranchCtrl.text = bankBranch.value ?? '';
    bankNameCtrl.text = bankName.value ?? '';
    bankNumberCtrl.text = bankNumber.value ?? '';

    // file url bankBookImage & idCardImage
    bookBankUrl.value =
        (b.bankBookImage.trim().isEmpty) ? null : b.bankBookImage;
    thaiIdCardUrl.value = (t.idCardImage.trim().isEmpty) ? null : t.idCardImage;

    // ---- STEP 3: WHT ----
    taxId.value = t.taxId;
    taxIdCtrl.text = taxId.value;
  }

  Future<bool> _registerAffiliate() async {
    isSubmitting.value = true;
    try {
      loadingAffiliate(true);

      final res = await _service.register(
        username: username.value.trim(),
        shopName: shop.value.trim(),
        email: email.value.trim(),
        mobile: phone.value.trim(),
      );
      await loadingAffiliate(false);

      final ok = (res?.code.toString() == '100');
      if (ok) {
        await showAffDialog(true, 'สำเร็จ', 'ส่งคำขอเรียบร้อย');

        validStatus.value = 'approved';
        await getProfile();
        // validStatusMsg.value = 'การสมัครของท่านอยู่ระหว่างการตรวจสอบข้อมูล';

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
      Get.snackbar('ผิดพลาด', 'ลงทะเบียนไม่สำเร็จ');
      return false;
    } finally {
      await loadingAffiliate(false);
      isSubmitting.value = false;
    }
  }

  Future<bool> _updateProfile() async {
    isSubmitting.value = true;
    try {
      loadingAffiliate(true);

      final res = await _service.updateProfile(
          username: username.value.trim(),
          shopName: shop.value.trim(),
          email: email.value.trim(),
          mobile: phone.value.trim(),
          cover: coverFile.value,
          avatar: avatarFile.value);

      await loadingAffiliate(false);

      final ok = (res?.code.toString() == '100');
      if (ok) {
        await showAffDialog(true, 'สำเร็จ', 'ส่งคำขอเรียบร้อย');

        FocusManager.instance.primaryFocus?.unfocus();
        await getProfile();
        // clearAfterUpdate();
        return true;
      } else {
        await showAffDialog(
          false,
          'เกิดข้อผิดพลาด',
          res?.message ?? 'บันทึกข้อมูลไม่สำเร็จ',
        );
        return false;
      }
    } catch (e) {
      Get.snackbar('ผิดพลาด', 'บันทึกข้อมูลไม่สำเร็จ');
      return false;
    } finally {
      await loadingAffiliate(false);
      isSubmitting.value = false;
    }
  }

  Future<bool> _setPaymentInfo({int? currentStep, required bool idEdit}) async {
    isSubmitting.value = true;
    try {
      loadingAffiliate(true);

      final accountInfo = {
        "prename_id": prefix.value,
        "first_name": firstname.value,
        "last_name": lastname.value,
        "phone": phone.value,
        "address_1": address.value,
        "address_2": "",
        "tumbon_id": tambonId.value,
        "amphur_id": amphurId.value,
        "province_id": provinceId.value,
        "post_code": postCode.value
      };

      final bankInfo = {
        "bank_id": bankId.value,
        "bank_branch": bankBranch.value,
        "bank_account_number": bankNumber.value,
        "bank_account_name": bankName.value
      };

      final taxInfo = {"tax_id": taxId.value};

      final res = await _service.setPaymentInfo(
        accountInfo: idEdit
            ? accountInfo
            : currentStep == 0
                ? accountInfo
                : null,
        bankInfo: idEdit
            ? bankInfo
            : currentStep == 1
                ? bankInfo
                : null,
        taxInfo: idEdit
            ? taxInfo
            : currentStep == 2
                ? taxInfo
                : null,
        bookBank: bookBankFile.value,
        idCard: thaiIdCardFile.value,
      );
      await loadingAffiliate(false);

      final ok = (res?.code == '100');
      if (ok) {
        // await showAffDialog(true, 'สำเร็จ', 'ส่งคำขอเรียบร้อย');

        FocusManager.instance.primaryFocus?.unfocus();
        // clearForm();
        return true;
      } else {
        await showAffDialog(
          false,
          'เกิดข้อผิดพลาด',
          res?.message ?? 'ส่งข้อมูลไม่สำเร็จ',
        );
        return false;
      }
    } catch (e) {
      Get.snackbar('ผิดพลาด', 'ส่งข้อมูลไม่สำเร็จ');
      return false;
    } finally {
      await loadingAffiliate(false);
      isSubmitting.value = false;
    }
  }

  Future<void> submit({bool isUpdate = false}) async {
    submitted.value = true;

    final basicOk = isValidByMode(isUpdate: isUpdate);
    final usernameOk = isUpdate || ((usernameAvailable.value ?? false) == true);

    if (!(basicOk && usernameOk)) return;

    if (isUpdate) {
      await _updateProfile();
    } else {
      await _registerAffiliate();
    }
  }

  Future<bool> submitPayment(
      {int? currentStep, bool finalSubmit = false, bool isEdit = false}) async {
    if (isSavingPayment.value) return false;

    if (finalSubmit) {
      submitted.value = true; // step 1
      submittedBank.value = true; // step 2
      submittedTax.value = true; // step 3

      final allOk =
          isPaymentStep1Valid && isPaymentStep2Valid && isPaymentStep3Valid;
      if (!allOk) return false;
    } else if (currentStep != null) {
      // บันทึกเฉพาะสเต็ป (auto-save)
      if (currentStep == 0) {
        submitted.value = true;
        if (!isPaymentStep1Valid) return false;
      } else if (currentStep == 1) {
        submittedBank.value = true;
        if (!isPaymentStep2Valid) return false;
      } else if (currentStep == 2) {
        submittedTax.value = true;
        if (!isPaymentStep3Valid) return false;
      }
    }

    // --------- Save ----------
    isSavingPayment.value = true;
    try {
      final ok =
          await _setPaymentInfo(currentStep: currentStep, idEdit: isEdit);
      if (finalSubmit && ok) {
        await showAffDialog(
            true, 'ส่งข้อมูลสำเร็จ', 'กรุณารอเจ้าหน้าที่ตรวจสอบข้อมูล');
        await getPaymentInfo();
        exitEdit();
      }
      return ok;
    } catch (_) {
      return false;
    } finally {
      isSavingPayment.value = false;
    }
  }
}
