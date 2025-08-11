import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buttonSeeAll() {
  return Row(
    children: [
      Text(
        'ดูทั้งหมด',
        style: GoogleFonts.notoSansThaiLooped(
            fontSize: 13, color: theme_color_df, fontWeight: FontWeight.w500),
      ),
      const SizedBox(
        width: 4,
      ),
      SizedBox(
        width: 20,
        child: CircleAvatar(
            backgroundColor: theme_color_df,
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 14,
            )),
      )
    ],
  );
}
