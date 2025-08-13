import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/components/profile/menu.section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutFridayV2 extends StatelessWidget {
  const AboutFridayV2({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> menuList = {
      "aboutFridayItems": [
        {
          "icon": "assets/images/profileimg/policy.png",
          "title": "นโยบายความเป็นส่วนตัว"
        },
        {
          "icon": "assets/images/profileimg/delete_profile.png",
          "title": "คำขอลบบัญชี"
        }
      ],
    };
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Theme(
          data: Theme.of(context).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle: GoogleFonts.notoSansThaiLooped())),
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: appBarMasterEndUser('เกี่ยวกับ Friday'),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: buildMenuSection("", menuList["aboutFridayItems"]!),
            ),
          ),
        ));
  }
}
