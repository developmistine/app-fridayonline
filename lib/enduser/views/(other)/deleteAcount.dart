import 'package:appfridayecommerce/enduser/components/appbar/appbar.master.dart';
import 'package:appfridayecommerce/enduser/services/profile/profile.service.dart';
import 'package:appfridayecommerce/enduser/views/(other)/changeverify.dart';
import 'package:appfridayecommerce/enduser/views/(profile)/edit.telphoneNum.dart';
import 'package:appfridayecommerce/enduser/widgets/dialog.confirm.dart';
import 'package:appfridayecommerce/enduser/widgets/dialog.dart';
import 'package:appfridayecommerce/enduser/widgets/dialog.error.dart';
import 'package:appfridayecommerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    textStyle: GoogleFonts.notoSansThaiLooped()))),
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: appBarMasterEndUser('สำคัญ'),
          body: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'โดยการคลิก "ดำเนินการต่อ" คุณได้ยอมรับเงื่อนไขต่อไปนี้:',
                  style: GoogleFonts.notoSansThaiLooped(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._buildBulletPoints([
                  "บัญชีผู้ใช้ที่ถูกลบจะไม่สามารถกู้คืนได้อีก หากลบบัญชีผู้ใช้สำเร็จแล้ว คุณจะไม่สามารถเข้าสู่ระบบด้วยบัญชีเดิมและตรวจสอบข้อมูลในบัญชีได้อีก",
                  "คุณจะไม่สามารถลบบัญชีผู้ใช้ได้หากมีการสั่งซื้อ ยอดเงิน หรือการดำเนินการทางกฎหมายค้างอยู่ในระบบ",
                  "หลังจากลบบัญชีสำเร็จแล้ว Friday จะยังเก็บข้อมูลบางส่วนไว้ตามนโยบายความเป็นส่วนตัวของ Friday และข้อกฎหมายที่เกี่ยวข้อง",
                  "Friday ถือสิทธิ์ขาดในการปฏิเสธไม่ให้สร้างบัญชีผู้ใช้ใหม่ด้วยข้อมูลเดิมในอนาคต",
                  "การลบบัญชีผู้ใช้ไม่ส่งผลให้หนี้คงค้างหรือภาระผูกพันใด ๆ ที่มีอยู่ถูกยกเลิก",
                ]),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
              child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: themeColorDefault,
                shape: const RoundedRectangleBorder()),
            onPressed: () async {
              loadingProductStock(context);
              var profile = await ApiProfile().fetchProfile();
              Get.back();
              if (profile == null) {
                dialogError('เกิดข้อผิดพลาด\nกรุณาลองใหม่อีกครั้ง');
                Future.delayed(const Duration(seconds: 1), () {
                  Get.back();
                });
              } else {
                if (profile.isUnpaid) {
                  dialogConfirm(profile.messageUnpaid, 'ปิด', '');
                  return;
                }
                if (profile.mobile == "") {
                  dialogAlert([
                    Text(
                      'กรุณายืนยันหมายเลขโทรศัพท์',
                      style: GoogleFonts.notoSansThaiLooped(
                          fontSize: 13, color: Colors.white),
                    )
                  ]);
                  Future.delayed(const Duration(seconds: 1), () async {
                    Get.back();
                    await Get.to(() => const EditTelphoneNumber(), arguments: {
                      "mobile": profile.mobile,
                      "displayName": profile.displayName,
                    })!
                        .then((result) {});
                  });
                } else {
                  Get.to(() => ChangeVerify(phone: profile.mobile));
                }
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('ดำเนินการต่อ'),
            ),
          )),
        ),
      ),
    );
  }
}

List<Widget> _buildBulletPoints(List<String> items) {
  return items.map((text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Icon(Icons.circle, size: 6, color: Colors.black54),
          ), // จุดนำหน้า
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.notoSansThaiLooped(
                  fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }).toList();
}
