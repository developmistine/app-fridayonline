// lib/member/views/(affiliate)/apply.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:get/get.dart';
import 'package:fridayonline/theme.dart';

class UserApply extends StatefulWidget {
  const UserApply({super.key});

  @override
  State<UserApply> createState() => _ApplyState();
}

class _ApplyState extends State<UserApply> {
  final affAccountCtl = Get.find<AffiliateAccountCtr>();
  final profileCtl = Get.find<ProfileCtl>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    affAccountCtl.clearForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: const Color(0xFFF8F8F8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            // ===== หัวข้อ =====
            SizedBox(
              width: double.infinity,
              height: 41,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      spacing: 6,
                      children: [
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(-1.00, 0.50),
                                end: Alignment(0.00, 0.50),
                                colors: [Color(0x001C9AD6), Color(0xFF1C9AD6)],
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'ลงทะเบียนเลยตอนนี้',
                          style: TextStyle(
                            color: Color(0xFF1F1F1F),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.00, 0.50),
                                end: Alignment(1.00, 0.50),
                                colors: [Color(0xFF1C9AD6), Color(0x001C9AD6)],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== ชื่อร้าน =====

            Column(
              spacing: 4,
              children: [
                ApplyFieldLabel(
                  title: 'ชื่อร้านค้าของท่าน',
                  requiredMark: true,
                  counterController: affAccountCtl.shopNameCtrl,
                  maxLength: 50,
                ),
                ApplyInputBox(
                  controller: affAccountCtl.shopNameCtrl,
                  hint: 'เสื้อผ้าแฟชั่น',
                  ctl: affAccountCtl,
                  field: ApplyField.shop,
                  onChanged: affAccountCtl.onShopChanged,
                ),
              ],
            ),

            // ===== Username =====
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ApplyFieldLabel(
                  title: 'ชื่อผู้ใช้ (username)',
                  requiredMark: true,
                  counterController: affAccountCtl.shopNameCtrl,
                  maxLength: 24,
                ),
                ApplyInputBox(
                  controller: affAccountCtl.usernameCtrl,
                  hint: 'fridayshop',
                  ctl: affAccountCtl,
                  field: ApplyField.username,
                  onChanged: affAccountCtl.onUsernameChanged,
                ),
                Text(
                  'กรุณาระบุชื่อผู้ใช้ (username) สำหรับลิงก์โปรไฟล์ของท่าน โดยจะต้องประกอบไปด้วยตัวอักษร ตัวเลข ขีดล่าง และจุดเท่านั้น',
                  style: TextStyle(
                    color: Color.fromARGB(255, 102, 102, 102),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            // ===== อีเมล =====
            Column(
              spacing: 4,
              children: [
                ApplyFieldLabel(title: 'อีเมล', requiredMark: true),
                ApplyInputBox(
                  controller: affAccountCtl.emailCtrl,
                  hint: 'example@friday.co.th',
                  keyboardType: TextInputType.emailAddress,
                  ctl: affAccountCtl,
                  field: ApplyField.email,
                  onChanged: affAccountCtl.onEmailChanged,
                ),
              ],
            ),

            // ===== เบอร์โทร =====
            Column(
              spacing: 4,
              children: [
                ApplyFieldLabel(title: 'หมายเลขโทรศัพท์', requiredMark: true),
                ApplyInputBox(
                  controller: affAccountCtl.phoneCtrl,
                  hint: '0XX-XXX-XXXX',
                  keyboardType: TextInputType.phone,
                  ctl: affAccountCtl,
                  field: ApplyField.phone,
                  onChanged: affAccountCtl.onPhoneChanged,
                ),
              ],
            ),

            // ===== Checkbox + Terms =====
            SizedBox(
              width: double.infinity,
              height: 42,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: affAccountCtl.toggleAgree,
                      child: Container(
                        width: 16,
                        height: 16,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF5FAFE),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFF1C9AD6),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: affAccountCtl.agreed.value
                                ? const Color(0xFF1C9AD6)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text:
                                'ฉันยืนยันว่าข้อมูลทั้งหมดที่กรอกไปเป็นความจริง และยอมรับ ',
                            style: TextStyle(
                              color: Color(0xFF5A5A5A),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                              text: 'ข้อกำหนดและเงื่อนไข',
                              style: const TextStyle(
                                color: Color(0xFF1C9AD6),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()),
                          const TextSpan(
                            text: ' ของ ฟรายเดย์ Affiliate',
                            style: TextStyle(
                              color: Color(0xFF5A5A5A),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => affAccountCtl.showAgreeError
                  ? const Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 24), // ขยับให้ตรงแนวข้อความ
                      child: Text(
                        'กรุณายอมรับข้อกำหนดและเงื่อนไข',
                        style:
                            TextStyle(color: Color(0xFFF44336), fontSize: 12),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            // ===== ปุ่ม Submit =====
            SizedBox(
              width: double.infinity,
              child: Obx(
                () {
                  final _ = (
                    affAccountCtl.shop.value,
                    affAccountCtl.email.value,
                    affAccountCtl.phone.value,
                    affAccountCtl.agreed.value
                  );
                  final ok = affAccountCtl.isValid;
                  return ElevatedButton(
                    onPressed: ok ? affAccountCtl.submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColorDefault,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ).copyWith(
                      backgroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.disabled)) {
                          return themeColorDefault.withValues(alpha: 0.5);
                        }
                        return themeColorDefault;
                      }),
                    ),
                    child: const Text(
                      'สมัครฟรายเดย์ Affiliate',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApplyFieldLabel extends StatelessWidget {
  final String title;
  final bool requiredMark;
  final TextEditingController? counterController;
  final int? maxLength;
  const ApplyFieldLabel({
    super.key,
    required this.title,
    this.requiredMark = false,
    this.counterController,
    this.maxLength,
  });

  bool get _showCounter => counterController != null && maxLength != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF5A5A5A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (requiredMark)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Color(0xFFF44336),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          if (_showCounter)
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: counterController!,
              builder: (context, value, _) {
                final len = value.text.length;
                final over = len > (maxLength!);
                return Text(
                  '$len/${maxLength!}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: over
                        ? const Color(0xFFF44336)
                        : const Color(0xFF9DA3AE),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class ApplyInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final Color textColor;
  final Color? hintColor;
  final ValueChanged<String>? onChanged;
  final AffiliateAccountCtr ctl;
  final ApplyField field;

  // NEW: username เดิมจากโปรไฟล์ (ใช้เฉพาะ field == ApplyField.username)
  final String? originalUsername;

  const ApplyInputBox({
    super.key,
    required this.controller,
    required this.hint,
    required this.ctl,
    required this.field,
    this.keyboardType,
    this.textColor = const Color(0xFF1F1F1F),
    this.hintColor,
    this.onChanged,
    this.originalUsername, // NEW
  });

  String? _errorText() {
    switch (field) {
      case ApplyField.shop:
        return ctl.errorShop;
      case ApplyField.username:
        return ctl.errorUsername;
      case ApplyField.email:
        return ctl.errorEmail;
      case ApplyField.phone:
        return ctl.errorPhone;
    }
  }

  bool _showError() {
    switch (field) {
      case ApplyField.shop:
        return ctl.showShopError;
      case ApplyField.username:
        return ctl.showUsernameError;
      case ApplyField.email:
        return ctl.showEmailError;
      case ApplyField.phone:
        return ctl.showPhoneError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPhone = field == ApplyField.phone;
    final formatters = isPhone
        ? <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ]
        : const <TextInputFormatter>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFE2E2E4)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) ctl.markTouched(field);
              },
              child: TextField(
                maxLength: field == ApplyField.shop
                    ? 50
                    : field == ApplyField.username
                        ? 24
                        : null,
                maxLines: 1,
                controller: controller,
                keyboardType: keyboardType,
                inputFormatters: formatters,
                textInputAction: TextInputAction.next,
                onChanged: onChanged,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                    color:
                        hintColor ?? const Color.fromARGB(255, 160, 158, 167),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  // ⬇️ ซ่อน icon เมื่อ username เท่ากับของเดิม
                  suffixIcon: field == ApplyField.username
                      ? Obx(() {
                          final localErr = ctl.errorUsername;
                          final uname = ctl.username.value.trim();
                          final sameAsOriginal =
                              (originalUsername?.trim().isNotEmpty ?? false) &&
                                  (uname == originalUsername!.trim());

                          if (localErr != null ||
                              uname.isEmpty ||
                              sameAsOriginal) {
                            return const SizedBox.shrink();
                          }
                          if (ctl.isCheckingUsername.value) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)),
                            );
                          }
                          if (ctl.usernameAvailable.value == true) {
                            return const Icon(Icons.check_circle,
                                size: 18, color: Colors.green);
                          }
                          if (ctl.usernameAvailable.value == false) {
                            return const Icon(Icons.cancel,
                                size: 18, color: Colors.red);
                          }
                          return const SizedBox.shrink();
                        })
                      : null,
                ),
              )),
        ),
        Obx(() {
          final _ = (
            ctl.shop.value,
            ctl.email.value,
            ctl.phone.value,
            ctl.submitted.value
          );
          final show = _showError();
          final err = _errorText();
          if (!show || err == null) return const SizedBox.shrink();
          return const SizedBox(height: 4);
        }),
        Obx(() {
          final _ = (
            ctl.shop.value,
            ctl.email.value,
            ctl.phone.value,
            ctl.submitted.value
          );
          final show = _showError();
          final err = _errorText();
          if (!show || err == null) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Text(
              err,
              style: const TextStyle(color: Color(0xFFF44336), fontSize: 12),
            ),
          );
        }),
      ],
    );
  }
}
