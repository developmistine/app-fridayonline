import 'package:flutter/material.dart';
import 'package:fridayonline/member/widgets/common_dialog.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Object?> popupUpdateApp(
    {required String urlStore, required BuildContext context}) {
  return dialogCommon(
    insetPadding: 16,
    context,
    isDismiss: false,
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 24,
        children: [
          Image.asset("assets/images/update/software-update.png",
              width: 231.40),
          Text(
            'แอปใหม่พร้อมให้ใช้งานแล้ว!',
            style: GoogleFonts.ibmPlexSansThai(
              color: const Color(0xFF1F1F1F),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'กรุณาอัปเดตแอปเวอร์ชันใหม่ใน Store ของท่าน\nเพื่อยกระดับประสบการณ์การใช้งานที่ดียิ่งขึ้น',
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSansThai(
              color: const Color(0xFF5A5A5A),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final url = Uri.parse(urlStore);

                try {
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'ไม่สามารถเปิด Mistine Shop ได้';
                  }
                } catch (e) {
                  Get.back();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('เกิดข้อผิดพลาด'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(
                "อัปเดตเลย!",
                style: GoogleFonts.ibmPlexSansThai(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    title: "",
    hideHeader: true,
    hideHeaderDivider: true,
  );
}
