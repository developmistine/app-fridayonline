import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.commission.ctr.dart';
import 'package:fridayonline/member/models/affiliate/commission.dtlearning.model.dart';
import 'package:fridayonline/member/views/(affiliate)/commission/history.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Earns extends StatefulWidget {
  final String str;
  const Earns({super.key, required this.str});

  @override
  State<Earns> createState() => _EarnsState();
}

class _EarnsState extends State<Earns> with SingleTickerProviderStateMixin {
  final affCommissionCtl = Get.find<AffiliateCommissionCtr>();

  @override
  void initState() {
    super.initState();
    affCommissionCtl.getEaringDtl(widget.str);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: themeColorDefault,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: Get.back,
          ),
          shadowColor: Colors.black.withValues(alpha: 0.4),
          title: Text(
            'รายละเอียดรายรับ',
            style: GoogleFonts.ibmPlexSansThai(
              color: const Color(0xFF1F1F1F),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        body: Obx(() {
          final affCommissionCtl = Get.find<AffiliateCommissionCtr>();
          final earndtl = affCommissionCtl.earnsDtlData.value;
          final status = earndtl?.status;
          final payment = earndtl?.paymentSummary;

          return Column(
            spacing: 12,
            children: [
              _buildEarnStatus(status),
              _buildAmountsCard(earndtl),
              _buildPaymentCard(payment),
            ],
          );
        }));
  }
}

Color _hexToColor(String hex) {
  var h = hex.replaceAll('#', '');
  if (h.length == 6) h = 'FF$h';
  return Color(int.parse(h, radix: 16));
}

Widget _buildEarnStatus(Status? status) {
  final String statusName = status?.name ?? '';
  final String title = status?.label ?? '-';
  final String desc = status?.description ?? '-';
  final String colorHex = status?.colorCode ?? '#fafafafa';

  final Color bgColor = _hexToColor(colorHex);

  final String iconPath = switch (statusName) {
    'pending' => 'assets/images/affiliate/status_pending.svg',
    'approved' => 'assets/images/affiliate/status_approved.svg',
    'rejected' => 'assets/images/affiliate/status_rejected.svg',
    _ => 'assets/images/affiliate/status_pending.svg',
  };

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: bgColor.withValues(alpha: 0.1),
      border: Border.all(color: const Color(0xFFEDEDED), width: 1),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(iconPath, width: 36, height: 36),
        const SizedBox(width: 10), // <-- instead of spacing:
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
              const SizedBox(height: 2),
              Text(
                desc,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: GoogleFonts.ibmPlexSansThai(
                  color: const Color(0xFF5A5A5A),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildAmountsCard(Data? earndtl) {
  final commission = earndtl?.commissionAmount ?? '-';
  final fee = earndtl?.transactionFee ?? '-';
  final net = earndtl?.netAmount ?? '฿0';
  final status = earndtl?.status;
  final String statusLabel = status?.label ?? '';
  final statusBg = _hexToColor(status?.colorCode ?? '#fafafafa');

  Widget row(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 14,
                color: const Color(0xFF8C8A94),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1F1F1F),
              ),
            ),
          ),
        ],
      );

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFF3F3F4)),
    ),
    child: Column(
      spacing: 12,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'สถานะการรับเงิน',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 14,
                  color: const Color(0xFF8C8A94),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            StatusChip(label: statusLabel, bg: statusBg),
          ],
        ),
        row('ยอดค่าคอมมิชชั่น', commission),
        row('ค่าธรรมเนียม', fee),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'ยอดเงินที่จะได้รับ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 14,
                  color: const Color(0xFF1F1F1F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Flexible(
              child: Text(
                net,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildPaymentCard(PaymentSummary? payment) {
  final id = payment?.paymentId ?? '-';
  final bank = payment?.bank ?? '-';
  final accNo = payment?.bankAccountNumber ?? '-';
  final accNm = payment?.bankAccountName ?? '-';
  final time = payment?.createdAt ?? '-';

  Row row(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 14,
                color: const Color(0xFF8C8A94),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1F1F1F),
              ),
            ),
          ),
        ],
      );

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFF3F3F4)),
    ),
    child: Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // row('หมายเลขการชำระเงิน', id),
        row('ธนาคาร', bank),
        row('บัญชีที่ถอน', accNo),
        row('ชื่อบัญชี', accNm),
        row('วันที่ทำรายการ', time),
      ],
    ),
  );
}
