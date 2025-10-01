import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fridayonline/member/components/utils/share.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:fridayonline/member/views/(affiliate)/setting/setting.dart';
import 'package:fridayonline/member/views/(affiliate)/setting/setting.account.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final performanceData = [
  {'label': "คำสั่งซื้อ", "value": "26"},
  {'label': "ยอดขาย", "value": "฿ 2,650.00"},
  {'label': "ค่าคอมมิชชั่น", "value": "฿ 850.00"}
];

final stepsData = [
  {'image': "assets/images/affiliate/affi_step_1.svg", 'title': "เปิดร้านค้า"},
  {'image': "assets/images/affiliate/affi_step_2.svg", 'title': "เลือกสินค้า"},
  {'image': "assets/images/affiliate/affi_step_3.svg", 'title': "โปรโมทร้าน"},
  {
    'image': "assets/images/affiliate/affi_step_4.svg",
    'title': "รับค่าคอมมิชชั่น"
  },
];

class AppBar extends StatelessWidget {
  const AppBar(this.isValid, {super.key});

  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        Text(
          isValid ? 'ฟรายเดย์ Affiliate' : 'ลงทะเบียน ฟรายเดย์ Affiliate',
          style: GoogleFonts.ibmPlexSansThai(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        SizedBox(
          width: 18,
        )
      ],
    );
  }
}

class Steps extends StatelessWidget {
  const Steps({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 6,
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-1.00, 0.50),
                          end: Alignment(0.00, 0.50),
                          colors: [
                            const Color(0x001C9AD6),
                            const Color(0xFF1C9AD6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'รับค่าคอมมิชชั่นได้ง่ายๆ ใน 4 ขั้นตอน',
                    style: GoogleFonts.ibmPlexSansThai(
                        fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, 0.50),
                          end: Alignment(1.00, 0.50),
                          colors: [
                            const Color(0xFF1C9AD6),
                            const Color(0x001C9AD6)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 2,
                children: [
                  ...stepsData.map((step) => Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  SvgPicture.asset(
                                    step['image'] as String,
                                    width: 32,
                                    height: 32,
                                  ),
                                  Text(
                                    step['title'] as String,
                                    style: GoogleFonts.ibmPlexSansThai(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                              if (stepsData.last != step)
                                SvgPicture.asset(
                                  'assets/images/affiliate/arrow_gradient_blue.svg',
                                  width: 22,
                                  height: 22,
                                ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Perfomance extends StatelessWidget {
  const Perfomance({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ภาพรวม',
                  style: TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/affiliate/arrow_gradient_blue.svg',
                  width: 26,
                  height: 26,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: performanceData.map((v) {
                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      Text(
                        v['value'] ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.ibmPlexSansThai(
                          color: Color(0xFF1C9AD6),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        v['label'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF5A5A5A),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final affAccountCtl = Get.find<AffiliateAccountCtr>();

    return Obx(() {
      final data = affAccountCtl.profileData.value;
      if (data == null) {
        return const SizedBox.shrink();
      }

      final avatarUrl = data.account.image;
      final hasAvatar = avatarUrl.isNotEmpty;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  // avatar
                  Container(
                    width: 55,
                    height: 55,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(110),
                      ),
                    ),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: ShapeDecoration(
                        image: hasAvatar
                            ? DecorationImage(
                                image: NetworkImage(avatarUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(57),
                        ),
                        color: const Color(0xFFF3F4F6),
                      ),
                      child: hasAvatar
                          ? null
                          : const Icon(Icons.person, color: Color(0xFF9CA3AF)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.storeName,
                          style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "เข้าร่วมเมื่อ ${data.account.dateJoined} | รายการสินค้า (${data.itemCountDisplay})",
                          style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await Get.to(() => const SettingAccount());
                // กันพลาด ถ้าหน้านู้นไม่ได้ดึงเอง ก็รีเฟรชหลังกลับมาอีกที
                await affAccountCtl.getProfile();
              },
              icon: const Icon(Icons.settings, color: Colors.white, size: 32),
              tooltip: 'ตั้งค่า',
            )
          ],
        ),
      );
    });
  }
}

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  State<UserHeader> createState() => _HeaderState();
}

class _HeaderState extends State<UserHeader> {
  final affAccountCtl = Get.find<AffiliateAccountCtr>();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.46, 0.00),
          end: Alignment(0.46, 1.00),
          colors: [Color(0xFF2291F5), Color(0xFF2EA9E1)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/profileimg/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          SafeArea(
            bottom: false,
            child: Column(children: [
              AppBar(affAccountCtl.validStatus.value == 'approved'),
              affAccountCtl.validStatus.value == 'approved'
                  ? Profile()
                  : SizedBox(),
              affAccountCtl.validStatus.value == 'approved'
                  ? Perfomance()
                  : Steps(),
            ]),
          )
        ],
      ),
    );
  }
}
