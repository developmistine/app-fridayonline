import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.payment.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:fridayonline/member/utils/cached_image.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress/step_progress.dart';

class SettingAffPayment extends StatefulWidget {
  const SettingAffPayment({super.key});

  @override
  State<SettingAffPayment> createState() => _SettingAffPaymentState();
}

class _SettingAffPaymentState extends State<SettingAffPayment> {
  final affAccountCtl = Get.find<AffiliateAccountCtr>();

  int _currentStep = 0;

  final Color active = themeColorDefault;
  final Color inactive = const Color(0xFFE6E6E6);

  final _labels = const [
    'ผู้รับผลประโยชน์',
    'ข้อมูลธนาคาร',
    'ข้อมูลภาษี',
  ];

  bool get _isFirst => _currentStep == 0;
  bool get _isLast => _currentStep == _labels.length - 1;

  Future<void> _goNext() async {
    final affCtr = Get.find<AffiliateAccountCtr>();
    if (affCtr.isSavingPayment.value) return;

    final isDraft = affCtr.paymentStatus.value == 'draft';
    final lastIndex = _labels.length - 1;

    if (_currentStep == 0) {
      affCtr.submitted.value = true; // step 1
      if (!affCtr.isPaymentStep1Valid) return;
    } else if (_currentStep == 1) {
      affCtr.submittedBank.value = true; // step 2
      if (!affCtr.isPaymentStep2Valid) return;
    } else if (_currentStep == lastIndex) {
      affCtr.submittedTax.value = true; // step 3
      if (!affCtr.isPaymentStep3Valid) return;
    }

    if (_currentStep == lastIndex) {
      await affCtr.submitPayment(
          currentStep: _currentStep, finalSubmit: true, isEdit: !isDraft);
      return;
    }

    if (isDraft) {
      await affCtr.submitPayment(currentStep: _currentStep);
    } // auto-save (draft)
    setState(() => _currentStep++);
  }

  void _goBack() {
    if (_isFirst) {
      Get.back();
      return;
    }
    setState(() => _currentStep--);
  }

  @override
  void initState() {
    super.initState();
    affAccountCtl.getPaymentInfo();
    affAccountCtl.getPrefix();
    affAccountCtl.getBank();
  }

  @override
  void dispose() {
    affAccountCtl.clearForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (affAccountCtl.isLoadingPaymentInfo.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      final status = affAccountCtl.paymentStatus.value;
      // final isDraft = status == 'draft';
      final isEditing = affAccountCtl.paymentMode.value == PaymentPageMode.edit;

      final a = affAccountCtl.paymentInfo.value?.accountInfo;
      final b = affAccountCtl.paymentInfo.value?.bankInfo;
      final t = affAccountCtl.paymentInfo.value?.taxInfo;

      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: Colors.black.withValues(alpha: 0.4),
          backgroundColor: Colors.white,
          foregroundColor: themeColorDefault,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: Get.back,
          ),
          title: Text(
            'ตั้งค่าการชำระเงิน',
            style: GoogleFonts.ibmPlexSansThai(
              color: const Color(0xFF1F1F1F),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: isEditing
                ? Row(
                    children: [
                      if (!_isFirst)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _goBack,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              side: BorderSide(color: themeColorDefault),
                              foregroundColor: themeColorDefault,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'กลับ',
                              style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      const SizedBox(width: 10),
                      Obx(() {
                        final saving = affAccountCtl.isSavingPayment.value;
                        return Expanded(
                          child: ElevatedButton(
                            onPressed: _goNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColorDefault,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: saving
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'กำลังบันทึก...',
                                        style: GoogleFonts.ibmPlexSansThai(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                : Text(
                                    _isLast ? 'ส่ง' : 'ต่อไป',
                                    style: GoogleFonts.ibmPlexSansThai(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                          ),
                        );
                      }),
                    ],
                  )
                : OutlinedButton(
                    onPressed: () {
                      affAccountCtl.enterEdit();
                      setState(() => _currentStep = 0);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: BorderSide(color: themeColorDefault),
                      foregroundColor: themeColorDefault,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'แก้ไข',
                      style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (isEditing) ...[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  color: Colors.white,
                  child: StepProgress(
                    padding: EdgeInsets.all(8),
                    totalSteps: _labels.length,
                    currentStep: _currentStep,
                    theme: StepProgressThemeData(
                        activeForegroundColor: active,
                        defaultForegroundColor: inactive,
                        nodeLabelAlignment: StepLabelAlignment.bottom,
                        stepLineSpacing: 2,
                        stepLineStyle: StepLineStyle(
                          lineThickness: 2,
                        ),
                        nodeLabelStyle: StepLabelStyle(
                            titleMaxLines: 2,
                            maxWidth: 110,
                            titleStyle: GoogleFonts.ibmPlexSansThai(
                              fontSize: 12,
                              color: const Color(0xFF4D4D4D),
                            ))),
                    highlightOptions: StepProgressHighlightOptions
                        .highlightCompletedNodesAndLines,
                    nodeTitles: _labels,
                    nodeIconBuilder: (index, currentStepIndex) {
                      if (index < currentStepIndex) {
                        return _buildNumberNode(
                          number: index + 1,
                          bgColor: active,
                          borderColor: active,
                          textColor: Colors.white,
                        );
                      } else if (index == currentStepIndex) {
                        return _buildNumberNode(
                          number: index + 1,
                          bgColor: Colors.white,
                          borderColor: active,
                          textColor: active,
                        );
                      } else {
                        return _buildNumberNode(
                          number: index + 1,
                          bgColor: Colors.white,
                          borderColor: inactive,
                          textColor: const Color(0xFF6F6F6F),
                        );
                      }
                    },
                    nodeLabelBuilder: (index, currentStepIndex) {
                      if (index < currentStepIndex ||
                          index == currentStepIndex) {
                        return Text(
                          _labels[index],
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 12,
                            color: active,
                          ),
                        );
                      } else {
                        return Text(
                          _labels[index],
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 12,
                            color: const Color(0xFF4D4D4D),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                StepContent(step: _currentStep),
              ] else ...[
                _buildPaymentStatus(),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: Colors.white,
                      child: Text(
                        'ข้อมูลผู้รับผลประโยชน์',
                        style: GoogleFonts.ibmPlexSansThai(
                          color: const Color(0xFF1F1F1F),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _buildShowInformation(
                        title: 'ประเภทบัญชี', value: a?.accountType ?? '-'),
                    _buildShowInformation(
                        title: 'คำนำหน้า', value: a?.prename ?? '-'),
                    _buildShowInformation(
                        title: 'ชื่อ-นามสกุล',
                        value: '${a?.firstName ?? "-"} ${a?.lastName ?? "-"}'),
                    _buildShowInformation(
                        title: 'เบอร์โทร', value: a?.phone ?? '-'),
                    _buildShowInformation(
                        title: 'ที่อยู่',
                        value:
                            '${a?.address1 ?? '-' "-"} ${a?.tumbon ?? "-"} ${a?.amphur ?? "-"} ${a?.province ?? "-"} ${a?.postCode ?? "-"}'),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: Colors.white,
                      child: Text(
                        'ข้อมูลธนาคาร',
                        style: GoogleFonts.ibmPlexSansThai(
                          color: const Color(0xFF1F1F1F),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _buildShowInformation(
                        title: 'ธนาคาร', value: b?.bank ?? '-'),
                    _buildShowInformation(
                        title: 'ชื่อสาขาธนาคาร',
                        value: b?.bankBranchAddress ?? '-'),
                    _buildShowInformation(
                        title: 'ชื่อบัญชี', value: b?.bankAccountName ?? '-'),
                    _buildShowInformation(
                        title: 'หมายเลขบัญชีธนาคาร',
                        value: b?.bankAccountNumber ?? '-'),
                    _buildShowInformation(
                        type: 'image',
                        title:
                            'รูปหน้าบัญชีธนาคารของผู้รับผลประโยชน์ (Book bank)',
                        value: b?.bankBookImage ?? ''),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ข้อมูลภาษี',
                            style: GoogleFonts.ibmPlexSansThai(
                              color: const Color(0xFF1F1F1F),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'เอกสารรับรอง WHT',
                            style: GoogleFonts.ibmPlexSansThai(
                              color: const Color(0xFF1F1F1F),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildShowInformation(
                        title: 'เลขประจำตัวผู้เสียภาษี',
                        value: t?.taxId ?? '-'),
                    _buildShowInformation(
                        type: 'image',
                        title: 'บัตรประจำตัวประชาชน',
                        value: t?.idCardImage ?? ''),
                  ],
                )
              ]
            ],
          ),
        ),
      );
    });
  }
}

Widget _buildNumberNode({
  required int number,
  required Color bgColor,
  required Color borderColor,
  required Color textColor,
}) {
  const double size = 34;
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: bgColor,
      shape: BoxShape.circle,
      border: Border.all(color: borderColor, width: 2),
    ),
    alignment: Alignment.center,
    child: Text(
      '$number',
      style: GoogleFonts.ibmPlexSansThai(
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    ),
  );
}

Widget _buildPaymentStatus() {
  final affCtr = Get.find<AffiliateAccountCtr>();
  final status = affCtr.paymentInfo.value?.statusCode ?? '';
  final title = affCtr.paymentInfo.value?.statusMessage ?? '';
  final desc = affCtr.paymentInfo.value?.description ?? '';

  final color = switch (status) {
    "pending" => const Color(0xFFFFF3E2),
    "rejected" => const Color(0xFFFFE9E9),
    "approved" => const Color(0xFFF4FFF8),
    _ => Colors.grey,
  };

  final icon = switch (status) {
    "pending" => 'assets/images/affiliate/status_pending.svg',
    "approved" => 'assets/images/affiliate/status_approved.svg',
    "rejected" => 'assets/images/affiliate/status_rejected.svg',
    _ => 'assets/images/affiliate/status_pending.svg',
  };

  return Container(
    padding: EdgeInsets.all(10),
    color: color,
    child: Row(
      spacing: 10,
      children: [
        SvgPicture.asset(
          icon,
          width: 36,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.ibmPlexSansThai(
                  color: const Color(0xFF1F1F1F),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                desc,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.ibmPlexSansThai(
                  color: const Color(0xFF5A5A5A),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget _buildShowInformation(
    {String? type = 'text', required String title, required String value}) {
  final show = switch (type) {
    "text" => Text(
        value,
        style: GoogleFonts.ibmPlexSansThai(
          color: const Color(0xFF1F1F1F),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    "image" => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: value == ''
            ? Image.asset(
                'assets/images/empty_image_banner.png',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              )
            : CacheImageBannerShop(url: value)),
    _ => Text('-'),
  };

  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.ibmPlexSansThai(
              color: const Color(0xFFB3B1B8),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            )),
        show,
      ],
    ),
  );
}
