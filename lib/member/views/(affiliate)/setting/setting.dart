import 'package:flutter/material.dart';
import 'package:fridayonline/member/views/(affiliate)/setting/setting.payment.dart';
import 'package:fridayonline/member/views/(affiliate)/setting/setting.account.dart';

import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final menuData = [
  {"title": "บัญชี", "icon": ""},
  {"title": "ตั้งค่าการชำระเงิน", "icon": ""},
];

class SettingAccount extends StatefulWidget {
  const SettingAccount({super.key});

  @override
  State<SettingAccount> createState() => _SettingAccountState();
}

class _SettingAccountState extends State<SettingAccount> {
  void handleOnTap(String title) {
    switch (title) {
      case "บัญชี":
        Get.to(() => SettingAffAccount());
        break;

      case "ตั้งค่าการชำระเงิน":
        Get.to(() => SettingAffPayment());
        break;
      default:
    }
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
          'การตั้งค่า',
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF1F1F1F),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        color: Colors.transparent,
        child: ListView(
          padding: EdgeInsets.only(top: 12),
          children: menuData
              .map(
                (item) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: const Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 232, 232, 232),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    // leading: const Icon(Icons.settings, color: Colors.black54),
                    title: Text(
                      item['title'] ?? '',
                      style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.black38),
                    onTap: () {
                      handleOnTap(item['title'] ?? '');
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
