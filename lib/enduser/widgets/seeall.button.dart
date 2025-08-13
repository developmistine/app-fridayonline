import 'package:appfridayecommerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buttonSeeAll() {
  return Row(
    children: [
      Text(
        'ดูทั้งหมด',
        style: GoogleFonts.notoSansThaiLooped(
            fontSize: 13,
            color: themeColorDefault,
            fontWeight: FontWeight.w500),
      ),
      const SizedBox(
        width: 4,
      ),
      SizedBox(
        width: 20,
        child: CircleAvatar(
            backgroundColor: themeColorDefault,
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 14,
            )),
      )
    ],
  );
}
