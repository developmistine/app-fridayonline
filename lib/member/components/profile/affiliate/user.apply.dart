// lib/member/views/(affiliate)/apply.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fridayonline/member/controller/affiliate.dart';
import 'package:get/get.dart';
import 'package:fridayonline/theme.dart';

enum ApplyField { shop, email, phone }

class Apply extends StatefulWidget {
  const Apply({super.key});

  @override
  State<Apply> createState() => _ApplyState();
}

class _ApplyState extends State<Apply> {
  final AffiliateController affiliateCtl = Get.put(AffiliateController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: const Color(0xFFF8F8F8) /* Gray-25 */,
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
            _FieldLabel(title: 'ชื่อร้านค้าของท่าน', requiredMark: true),
            _InputBox(
              controller: affiliateCtl.shopNameCtrl,
              hint: 'เสื้อผ้าแฟชั่น By คุณนัท',
              ctl: affiliateCtl,
              field: ApplyField.shop,
              onChanged: affiliateCtl.onShopChanged,
            ),

            // ===== อีเมล =====
            _FieldLabel(title: 'อีเมล', requiredMark: true),
            _InputBox(
              controller: affiliateCtl.emailCtrl,
              hint: 'example@friday.co.th',
              keyboardType: TextInputType.emailAddress,
              ctl: affiliateCtl,
              field: ApplyField.email,
              onChanged: affiliateCtl.onEmailChanged,
            ),

            // ===== เบอร์โทร =====
            _FieldLabel(title: 'หมายเลขโทรศัพท์', requiredMark: true),
            _InputBox(
              controller: affiliateCtl.phoneCtrl,
              hint: '0XX-XXX-XXXX',
              keyboardType: TextInputType.phone,
              ctl: affiliateCtl,
              field: ApplyField.phone,
              onChanged: affiliateCtl.onPhoneChanged,
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
                      onTap: affiliateCtl.toggleAgree,
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
                            color: affiliateCtl.agreed.value
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
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                              text: 'ข้อกำหนดและเงื่อนไข',
                              style: const TextStyle(
                                color: Color(0xFF1C9AD6),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()),
                          const TextSpan(
                            text: ' ของ ฟรายเดย์ Affiliate',
                            style: TextStyle(
                              color: Color(0xFF5A5A5A),
                              fontSize: 14,
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
              () => affiliateCtl.showAgreeError
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
                    affiliateCtl.shop.value,
                    affiliateCtl.email.value,
                    affiliateCtl.phone.value,
                    affiliateCtl.agreed.value
                  );
                  final ok = affiliateCtl.isValid;
                  return ElevatedButton(
                    onPressed: ok ? affiliateCtl.submit : null,
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

class _FieldLabel extends StatelessWidget {
  final String title;
  final bool requiredMark;
  const _FieldLabel({required this.title, this.requiredMark = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: Row(
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
    );
  }
}

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final Color textColor;
  final Color? hintColor;
  final ValueChanged<String>? onChanged;
  final AffiliateController ctl;
  final ApplyField field;

  const _InputBox({
    super.key,
    required this.controller,
    required this.hint,
    required this.ctl,
    required this.field,
    this.keyboardType,
    this.textColor = const Color(0xFF1F1F1F),
    this.hintColor,
    this.onChanged,
  });

  String? _errorText() {
    switch (field) {
      case ApplyField.shop:
        return ctl.errorShop;
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
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: formatters,
              textInputAction: TextInputAction.next,
              onChanged: onChanged,
              style: TextStyle(
                  color: textColor, fontSize: 14, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  color: hintColor ?? const Color(0xFF8C8A94),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
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
          return const SizedBox(height: 4); // spacing เล็ก ๆ
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
