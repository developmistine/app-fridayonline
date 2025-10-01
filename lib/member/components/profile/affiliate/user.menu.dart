import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fridayonline/member/views/(affiliate)/commission/commission.dart';
import 'package:fridayonline/member/views/(affiliate)/dashboard.dart';
import 'package:fridayonline/member/views/(affiliate)/shop.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final menuData = [
  {'icon': 'assets/images/affiliate/affi_menu_1.svg', 'title': "ภาพรวมของฉัน"},
  {'icon': 'assets/images/affiliate/affi_menu_2.svg', 'title': "ค่าคอมมิชชั่น"},
  {
    'icon': 'assets/images/affiliate/affi_menu_3.svg',
    'title': "ดูร้านค้าของฉัน"
  },
];

class UserMenu extends StatelessWidget {
  const UserMenu({super.key});

  void navigateToPage(String title) {
    if (title.isEmpty) return;

    switch (title) {
      case "ดูร้านค้าของฉัน":
        Get.to(() => const AffiliateShop());
        break;
      case "ค่าคอมมิชชั่น":
        Get.to(() => const Commission());
        break;
      case "ภาพรวมของฉัน":
        Get.to(() => const Dashboard());
        break;
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'เมนู',
              style: GoogleFonts.ibmPlexSansThai(
                color: const Color(0xFF1F1F1F),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menuData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
                mainAxisExtent: 64,
              ),
              itemBuilder: (context, i) {
                final v = menuData[i];
                return InkWell(
                  onTap: () {
                    navigateToPage(v['title'] ?? '');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 6,
                    children: [
                      SvgPicture.asset(
                        v['icon'] ?? '',
                        width: 32,
                        height: 32,
                      ),
                      Text(
                        v['title'] ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSansThai(
                          color: Color(0xFF333333),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
