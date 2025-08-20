import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget nodata(BuildContext context) {
  return MediaQuery(
    data:
        MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/search/zero_search.png',
              width: 150,
            ),
          ),
          Text(
            'ไม่พบข้อมูลสินค้า',
            style: GoogleFonts.ibmPlexSansThai(),
          )
        ],
      ),
    ),
  );
}

Widget nodataTitle(BuildContext context, String title) {
  return MediaQuery(
    data:
        MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/search/zero_search.png',
              width: 150,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.ibmPlexSansThai(),
          )
        ],
      ),
    ),
  );
}
