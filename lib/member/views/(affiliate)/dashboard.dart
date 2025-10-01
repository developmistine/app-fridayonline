import 'package:flutter/material.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _SettingAccountState();
}

class _SettingAccountState extends State<Dashboard> {
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
          'ภาพรวมของฉัน',
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF1F1F1F),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        color: Colors.transparent,
        child: Text('data'),
      ),
    );
  }
}
