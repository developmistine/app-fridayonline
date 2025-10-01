import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:fridayonline/member/models/affiliate/bank.model.dart' as bank;
import 'package:fridayonline/member/models/affiliate/option.model.dart'
    as option;
import 'package:fridayonline/member/services/address/adress.service.dart';
import 'package:fridayonline/member/views/(address)/search.address.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AccountType {
  final int id;
  final String name;
  const AccountType(this.id, this.name);
}

final accountTypes = const [
  AccountType(1, 'บุคคลธรรมดา'),
  AccountType(2, 'นิติบุคคล'),
];

class StepContent extends StatefulWidget {
  final int step;
  const StepContent({super.key, required this.step});

  @override
  State<StepContent> createState() => _StepContentState();
}

class _StepContentState extends State<StepContent> {
  final AffiliateAccountCtr affAccountCtl = Get.find<AffiliateAccountCtr>();

  String? _prefixById(int? id) {
    if (id == null) return null;
    final prefixList = affAccountCtl.prefixData.value;
    if (prefixList == null) return null;
    final i = prefixList.indexWhere((a) => a.id == id);
    return i == -1 ? null : prefixList[i].label;
  }

  String? _accountTypeNameById(int? id) {
    if (id == null) return null;
    final i = accountTypes.indexWhere((a) => a.id == id);
    return i == -1 ? null : accountTypes[i].name;
  }

  String? _bankNameById(int? id) {
    if (id == null) return null;
    final bankList = affAccountCtl.bankData.value;
    if (bankList == null) return null;
    final i = bankList.indexWhere((a) => a.bankId == id);
    return i == -1 ? null : bankList[i].bankName;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final name = _accountTypeNameById(
                  affAccountCtl.selectedAccountTypeId.value);
              return CustomSelectField(
                readOnly: true,
                label: 'ประเภทบัญชี',
                value: name,
                required: true,
                showError: affAccountCtl.showAccountTypeError,
                errorText: affAccountCtl.errorAccountType,
                onTap: () async {
                  final result = await showSelectionSheetStatic<AccountType>(
                    context: context,
                    title: 'ประเภทบัญชี',
                    items: accountTypes,
                    titleFor: (t) => t.name,
                  );
                  if (result != null) {
                    affAccountCtl.setAccountType(result.id); // <-- ส่ง int
                  }
                },
              );
            }),
            const SizedBox(height: 10),
            Obx(() {
              final name = _prefixById(affAccountCtl.prefix.value);
              return CustomSelectField(
                readOnly: false,
                label: 'คำนำหน้า',
                value: name,
                required: true,
                showError: affAccountCtl.showPrefixError,
                errorText: affAccountCtl.errorPrefix,
                onTap: () async {
                  final result = await showSelectionSheetStatic<option.Datum>(
                    context: context,
                    title: 'คำนำหน้า',
                    items: affAccountCtl.prefixData.value ?? [],
                    titleFor: (t) => t.name,
                  );
                  if (result != null) {
                    affAccountCtl.setPrefix(result.id); // <-- ส่ง int
                  }
                },
              );
            }),
            CustomInputField(
              label: 'ชื่อจริง',
              required: true,
              controller: affAccountCtl.firstNameCtrl,
              hintText: 'กรุณาระบุ',
              onChanged: affAccountCtl.onFirstNameChanged,
              ctl: affAccountCtl,
              field: PaymentField.firstName,
            ),
            CustomInputField(
              label: 'นามสกุล',
              required: true,
              controller: affAccountCtl.lastNameCtrl,
              hintText: 'กรุณาระบุ',
              onChanged: affAccountCtl.onLastNameChanged,
              ctl: affAccountCtl,
              field: PaymentField.lastName,
            ),
            CustomInputField(
              label: 'เบอร์โทรศัพท์',
              required: true,
              controller: affAccountCtl.phoneCtrl,
              hintText: 'กรุณาระบุ',
              onChanged: affAccountCtl.onPhoneChanged,
              keyboardType: TextInputType.phone,
              ctl: affAccountCtl,
              field: PaymentField.phone,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 13),
              child: Text(
                'ที่อยู่',
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            CustomInputField(
              label: 'บ้านเลขที่,ซอย,หมู่บ้าน,ถนน',
              required: true,
              controller: affAccountCtl.addressCtrl,
              hintText: 'กรุณาระบุ',
              onChanged: affAccountCtl.onAddressChanged,
              ctl: affAccountCtl,
              field: PaymentField.address,
            ),
            Obx(() {
              final name = affAccountCtl.selectedAddressText.value;
              return CustomSelectField(
                readOnly: false,
                label: 'จังหวัด,เขต/อำเภอ,แขวง/ตำบล,รหัสไปรษณีย์',
                value: name,
                required: true,
                showError: affAccountCtl.showAddressPickError,
                errorText: affAccountCtl.errorAddressPick,
                onTap: () async {
                  // affAccountCtl.markPaymentTouched(PaymentField.addressPick);
                  final res = await searchAddressB2cService();
                  final result =
                      await Get.to(() => B2cSearchAddress(dataAddress: res));
                  if (result != null) {
                    affAccountCtl.setSelectedAddress(result);
                  }
                },
              );
            }),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final name = _bankNameById(affAccountCtl.bankId.value);
              return CustomSelectField(
                readOnly: false,
                label: 'ธนาคาร',
                value: name,
                required: true,
                showError: affAccountCtl.showBankIdError,
                errorText: affAccountCtl.errorBankId,
                onTap: () async {
                  // affAccountCtl.markPaymentTouched(PaymentField.bankId);
                  final result = await showSelectionSheetStatic<bank.Datum>(
                    context: context,
                    title: 'ธนาคาร',
                    items: affAccountCtl.bankData.value ?? [],
                    titleFor: (t) => t.bankName,
                  );
                  if (result != null) {
                    affAccountCtl.setBankId(result.bankId);
                  }
                },
              );
            }),
            CustomInputField(
              label: 'ชื่อสาขาธนาคาร',
              required: true,
              controller: affAccountCtl.bankbranchCtrl,
              hintText: 'กรุณาระบุ',
              onChanged: affAccountCtl.onBankBranchChanged,
              ctl: affAccountCtl,
              field: PaymentField.bankBranch,
            ),
            CustomInputField(
              label: 'ชื่อบัญชี',
              required: true,
              controller: affAccountCtl.bankNameCtrl,
              hintText: 'กรุณาระบุ',
              onChanged: affAccountCtl.onBankNameChanged,
              ctl: affAccountCtl,
              field: PaymentField.bankName,
            ),
            CustomInputField(
              label: 'หมายเลขบัญชีธนาคาร',
              required: true,
              controller: affAccountCtl.bankNumberCtrl,
              hintText: 'กรุณาระบุ',
              keyboardType: TextInputType.number,
              onChanged: affAccountCtl.onBankNumberChanged,
              ctl: affAccountCtl,
              field: PaymentField.bankNumber,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 13),
              child: Text(
                'กรุณากรอกเลขที่บัญชีธนาคารที่ตรงกับชื่อของท่าน',
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'รูปหน้าบัญชีธนาคารของผู้รับผลประโยชน์ (Book bank)',
                        style: GoogleFonts.ibmPlexSansThai(
                          color: const Color(0xFF1F1F1F),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' *',
                        style: GoogleFonts.ibmPlexSansThai(
                          color: const Color(0xFFF44336),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ตัวเลือกอัปโหลด/พรีวิว
                  Obx(() {
                    final file = affAccountCtl.bookBankFile.value;
                    final rawUrl = affAccountCtl.bookBankUrl.value;
                    final hasUrl = (rawUrl != null && rawUrl.trim().isNotEmpty);
                    final url = hasUrl ? rawUrl.trim() : null;

                    if (file == null && url == null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () async {
                              affAccountCtl
                                  .markPaymentTouched(PaymentField.bookBank);
                              final src = await _pickImageSourceSheet(context);
                              if (src != null) {
                                // เลือกไฟล์ใหม่ -> เคลียร์ URL ทิ้ง
                                await affAccountCtl.pickBookBank(src);
                                affAccountCtl.bookBankUrl.value = null;
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: CustomPaint(
                              painter: DashedRRectPainter(),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 8,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: themeColorDefault,
                                      size: 30,
                                    ),
                                    Text(
                                      'ถ่ายรูปหรืออัพโหลดไฟล์',
                                      style: GoogleFonts.ibmPlexSansThai(
                                        color: themeColorDefault,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (affAccountCtl.showBookBankError &&
                              affAccountCtl.errorBookBank != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                affAccountCtl.errorBookBank!,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    color: Color(0xFFF44336), fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    }

                    Widget preview;
                    if (file != null) {
                      preview = Image.file(
                        file,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      );
                    } else {
                      preview = Image.network(
                        url!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        // กันโหลดช้า/พัง
                        loadingBuilder: (c, child, progress) {
                          if (progress == null) return child;
                          return SizedBox(
                            width: double.infinity,
                            height: 180,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: progress.expectedTotalBytes != null
                                    ? (progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!)
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (c, _, __) => Container(
                          width: double.infinity,
                          height: 180,
                          color: const Color(0xFFF5F5F5),
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image_outlined),
                        ),
                        gaplessPlayback: true,
                      );
                    }

                    return Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: preview,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: InkWell(
                                onTap: () {
                                  affAccountCtl.clearBookBank();
                                  affAccountCtl.bookBankUrl.value = null;
                                  affAccountCtl.markPaymentTouched(
                                      PaymentField.bookBank);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white60,
                                  radius: 16,
                                  child: SvgPicture.asset(
                                      'assets/images/affiliate/cardmenu/trash.svg',
                                      width: 18,
                                      color: Color(0xFFE01607)),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () async {
                                  final src =
                                      await _pickImageSourceSheet(context);
                                  if (src != null) {
                                    await affAccountCtl.pickBookBank(src);

                                    affAccountCtl.bookBankUrl.value = null;
                                    affAccountCtl.markPaymentTouched(
                                        PaymentField.bookBank);
                                  }
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'เปลี่ยนรูปภาพ',
                                      style: GoogleFonts.ibmPlexSansThai(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
          ],
        );

      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 13),
              child: Text(
                'เอกสารรับรอง WHT',
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'บัตรประจำตัวประชาชน',
                        style: GoogleFonts.ibmPlexSansThai(
                          color: const Color(0xFF1F1F1F),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' *',
                        style: GoogleFonts.ibmPlexSansThai(
                          color: const Color(0xFFF44336),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ตัวเลือกอัปโหลด/พรีวิว
                  Obx(() {
                    final file = affAccountCtl.thaiIdCardFile.value;
                    final rawUrl = affAccountCtl.thaiIdCardUrl.value;
                    final hasUrl = (rawUrl != null && rawUrl.trim().isNotEmpty);
                    final url = hasUrl ? rawUrl.trim() : null;

                    if (file == null && url == null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () async {
                              affAccountCtl
                                  .markPaymentTouched(PaymentField.bookBank);
                              final src = await _pickImageSourceSheet(context);
                              if (src != null) {
                                await affAccountCtl.pickThaiIdCard(src);
                                affAccountCtl.thaiIdCardUrl.value = null;
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: CustomPaint(
                              painter: DashedRRectPainter(),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 8,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: themeColorDefault,
                                      size: 30,
                                    ),
                                    Text(
                                      'ถ่ายรูปหรืออัพโหลดไฟล์',
                                      style: GoogleFonts.ibmPlexSansThai(
                                        color: themeColorDefault,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (affAccountCtl.showThaiIdCardError &&
                              affAccountCtl.errorThaiIdCard != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                affAccountCtl.errorThaiIdCard!,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    color: Color(0xFFF44336), fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    }

                    Widget preview;
                    if (file != null) {
                      preview = Image.file(
                        file,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      );
                    } else {
                      preview = Image.network(
                        url!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        loadingBuilder: (c, child, progress) {
                          if (progress == null) return child;
                          return SizedBox(
                            width: double.infinity,
                            height: 180,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: progress.expectedTotalBytes != null
                                    ? (progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!)
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (c, _, __) => Container(
                          width: double.infinity,
                          height: 180,
                          color: const Color(0xFFF5F5F5),
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image_outlined),
                        ),
                        gaplessPlayback: true,
                      );
                    }

                    return Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: preview,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: InkWell(
                                onTap: () {
                                  affAccountCtl.clearThaiIdCard();
                                  affAccountCtl.thaiIdCardUrl.value = null;
                                  affAccountCtl.markPaymentTouched(
                                      PaymentField.thaiIdCard);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white60,
                                  radius: 16,
                                  child: SvgPicture.asset(
                                      'assets/images/affiliate/cardmenu/trash.svg',
                                      width: 18,
                                      color: Color(0xFFE01607)),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () async {
                                  final src =
                                      await _pickImageSourceSheet(context);
                                  if (src != null) {
                                    await affAccountCtl.pickThaiIdCard(src);

                                    affAccountCtl.thaiIdCardUrl.value = null;
                                    affAccountCtl.markPaymentTouched(
                                        PaymentField.thaiIdCard);
                                  }
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'เปลี่ยนรูปภาพ',
                                      style: GoogleFonts.ibmPlexSansThai(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
            CustomInputField(
              label: 'เลขประจำตัวผู้เสียภาษี',
              required: true,
              controller: affAccountCtl.taxIdCtrl,
              hintText: 'กรุณาระบุ',
              keyboardType: TextInputType.number,
              onChanged: affAccountCtl.onTaxIdChanged,
              ctl: affAccountCtl,
              field: PaymentField.taxId,
            ),
          ],
        );
    }
  }
}

class CustomSelectField extends StatelessWidget {
  final bool readOnly;
  final String label;
  final String? value;
  final bool required;
  final VoidCallback onTap;
  final bool showError;
  final String? errorText;

  const CustomSelectField({
    super.key,
    required this.readOnly,
    required this.label,
    this.value,
    this.required = false,
    required this.onTap,
    this.showError = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return _SelectFieldBody(
      label: label,
      readOnly: readOnly,
      required: required,
      value: value,
      errText: showError ? errorText : null, // <<<<<< ใช้ค่าจริง
      isError: showError,
      onTap: onTap,
    );
  }
}

class _SelectFieldBody extends StatelessWidget {
  final String label;
  final bool readOnly;
  final bool required;
  final String? value;
  final String? errText;
  final bool isError;
  final VoidCallback onTap;

  const _SelectFieldBody(
      {required this.label,
      required this.required,
      required this.value,
      required this.errText,
      required this.onTap,
      this.isError = false,
      required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: readOnly ? () {} : onTap,
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: const Color(0xFFF3F3F4)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: label,
                          style: GoogleFonts.ibmPlexSansThai(
                            color: const Color(0xFF1F1F1F),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (required)
                          TextSpan(
                            text: ' *',
                            style: GoogleFonts.ibmPlexSansThai(
                              color: const Color(0xFFF44336),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (errText != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        errText!,
                        style: const TextStyle(
                            color: Color(0xFFF44336), fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    const SizedBox(width: double.infinity),
                    Padding(
                      padding: EdgeInsets.only(right: readOnly ? 0 : 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          value ?? 'กรุณาเลือก',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.ibmPlexSansThai(
                            color: value == null
                                ? const Color(0xFF9E9E9E)
                                : const Color(0xFF1F1F1F),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    if (!readOnly)
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF6F6F6F), size: 13),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String label;
  final bool required;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final AffiliateAccountCtr ctl;
  final PaymentField field;
  final ValueChanged<String>? onChanged;

  const CustomInputField({
    super.key,
    this.keyboardType,
    required this.label,
    this.required = false,
    required this.controller,
    required this.field,
    required this.ctl,
    this.hintText,
    this.onChanged,
  });

  String? _errorText() {
    switch (field) {
      case PaymentField.firstName:
        return ctl.errorFirstName;
      case PaymentField.lastName:
        return ctl.errorLastName;
      case PaymentField.phone:
        return ctl.errorPhone;
      case PaymentField.address:
        return ctl.errorAddress;
      case PaymentField.accountType:
        return ctl.errorAccountType;
      case PaymentField.addressPick:
        return ctl.errorAddressPick;
      case PaymentField.bankBranch:
        return ctl.errorBankBranch;
      case PaymentField.bankName:
        return ctl.errorBankName;
      case PaymentField.bankNumber:
        return ctl.errorBankNumber;
      case PaymentField.bankId:
        return ctl.errorBankId;
      case PaymentField.bookBank:
        return ctl.errorBookBank;
      case PaymentField.taxId:
        return ctl.errorTaxId;
      case PaymentField.thaiIdCard:
        return ctl.errorThaiIdCard;
      case PaymentField.prefix:
        return ctl.errorPrefix;
    }
  }

  bool _showError() {
    switch (field) {
      case PaymentField.firstName:
        return ctl.showFirstNameError;
      case PaymentField.lastName:
        return ctl.showLastNameError;
      case PaymentField.phone:
        return ctl.showPhoneError;
      case PaymentField.address:
        return ctl.showAddressError;
      case PaymentField.accountType:
        return ctl.showAccountTypeError;
      case PaymentField.addressPick:
        return ctl.showAddressPickError;
      case PaymentField.bankBranch:
        return ctl.showBankBranchError;
      case PaymentField.bankName:
        return ctl.showBankNameError;
      case PaymentField.bankNumber:
        return ctl.showBankNumberError;
      case PaymentField.bankId:
        return ctl.showBankIdError;
      case PaymentField.bookBank:
        return ctl.showBookBankError;
      case PaymentField.taxId:
        return ctl.showTaxIdError;
      case PaymentField.thaiIdCard:
        return ctl.showThaiIdCardError;
      case PaymentField.prefix:
        return ctl.showPrefixError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAddress = field == PaymentField.address;
    final isPhone = field == PaymentField.phone;
    final isBankNumber = field == PaymentField.bankNumber;
    final isTaxId = field == PaymentField.taxId;
    final formatters = <TextInputFormatter>[
      if (isBankNumber || isPhone || isTaxId)
        FilteringTextInputFormatter.digitsOnly,
      if (isBankNumber) LengthLimitingTextInputFormatter(12),
      if (isPhone) LengthLimitingTextInputFormatter(10),
      if (isTaxId) LengthLimitingTextInputFormatter(13),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFF3F3F4),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            isAddress ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isAddress)
                SizedBox(
                  height: 4,
                ),
              Row(
                children: [
                  Text(
                    label,
                    style: GoogleFonts.ibmPlexSansThai(
                      color: const Color(0xFF1F1F1F),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (required)
                    Text(
                      ' *',
                      style: GoogleFonts.ibmPlexSansThai(
                        color: const Color(0xFFF44336),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              Obx(() {
                final _ = (
                  ctl.firstname.value,
                  ctl.lastname.value,
                  ctl.phone.value,
                  ctl.address.value,
                  ctl.submitted.value,
                  ctl.paymentTouched.length
                );
                final show = _showError();
                final err = _errorText();
                if (!show || err == null) return const SizedBox.shrink();
                return Text(
                  err,
                  style:
                      const TextStyle(color: Color(0xFFF44336), fontSize: 10),
                );
              }),
            ],
          ),
          const Spacer(),
          Expanded(
            flex: 3,
            child: TextField(
              maxLength: isAddress ? 70 : null,
              maxLines: isAddress ? 3 : 1,
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: formatters,
              textAlign: TextAlign.end,
              textInputAction: TextInputAction.next,
              style: GoogleFonts.ibmPlexSansThai(
                color: const Color(0xFF1F1F1F),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: GoogleFonts.ibmPlexSansThai(
                  color: const Color(0xFF9E9E9E),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onChanged: (v) {
                onChanged?.call(v);

                ctl.markPaymentTouched(field);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<T?> showSelectionSheetStatic<T>({
  required BuildContext context,
  required String title,
  required List<T> items, // << ใส่รายการมาเลย
  required String Function(T) titleFor, // แปลง item -> ชื่อแสดง
  String Function(T)? subtitleFor, // ไม่บังคับ
  Widget Function(BuildContext, T)? leadingFor, // ไม่บังคับ
  Color barrierColor = const Color(0x59000000),
  bool isScrollControlled = true,
  bool enableDrag = true,
}) {
  return Get.bottomSheet<T>(
    _StaticSelectionSheetBody<T>(
      title: title,
      items: items,
      titleFor: titleFor,
      subtitleFor: subtitleFor,
      leadingFor: leadingFor,
    ),
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    barrierColor: barrierColor,
    enableDrag: enableDrag,
  );
}

class _StaticSelectionSheetBody<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final String Function(T) titleFor;
  final String Function(T)? subtitleFor;
  final Widget Function(BuildContext, T)? leadingFor;

  const _StaticSelectionSheetBody({
    required this.title,
    required this.items,
    required this.titleFor,
    this.subtitleFor,
    this.leadingFor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = const Radius.circular(16);
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.80,
          ),
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                      tooltip: 'ปิด',
                      onPressed: () {
                        Get.back(result: null);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: items.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('ไม่พบข้อมูล')),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final it = items[i];
                          return ListTile(
                            leading: leadingFor?.call(context, it),
                            title: Text(
                              titleFor(it),
                              style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            subtitle: subtitleFor != null
                                ? Text(subtitleFor!(it))
                                : null,
                            onTap: () => Get.back<T>(result: it),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<ImageSource?> _pickImageSourceSheet(BuildContext context) {
  return Get.bottomSheet<ImageSource>(
    Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_camera_outlined,
                color: Colors.black87,
              ),
              title: Text(
                'ถ่ายภาพ',
                style: GoogleFonts.ibmPlexSansThai(fontSize: 14),
              ),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: Colors.black87),
              title: Text(
                'เลือกจากแกลเลอรี',
                style: GoogleFonts.ibmPlexSansThai(fontSize: 14),
              ),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
    isScrollControlled: false,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x59000000),
  );
}
