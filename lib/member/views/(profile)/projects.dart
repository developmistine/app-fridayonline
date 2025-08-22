import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:google_fonts/google_fonts.dart';

final mockData = [
  {
    "content_id": 1265,
    "action_type": 4,
    "action_value": "1265",
    "content_name": "แบนเนอร์มิสทิน ลด 50.- วันที่ 15-24 สิงหาคม 2568",
    "start_date": "15/08/2025 00:01:37",
    "end_date": "24/08/2025 23:59:37",
    "image": "assets/images/banner/accidental_insurance.png",
    "image_desktop": "assets/images/banner/accidental_insurance.png"
  },
  {
    "content_id": 1265,
    "action_type": 4,
    "action_value": "1265",
    "content_name": "แบนเนอร์มิสทิน ลด 50.- วันที่ 15-24 สิงหาคม 2568",
    "start_date": "15/08/2025 00:01:37",
    "end_date": "24/08/2025 23:59:37",
    "image": "assets/images/banner/accidental_insurance.png",
    "image_desktop": "assets/images/banner/accidental_insurance.png"
  },
];

class SpecialProjects extends StatelessWidget {
  const SpecialProjects({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: GoogleFonts.ibmPlexSansThai(),
            ),
          ),
          textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: appBarMasterEndUser('โครงการพิเศษ'),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: mockData.length,
                    itemBuilder: (context, index) {
                      final item = mockData[index];
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: ShapeDecoration(
                              color: Colors.white, // CI-Band-White
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x19BCBCBC),
                                  blurRadius: 14,
                                  offset: Offset(0, 1),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/banner/accidental_insurance.png',
                                    width: double.infinity,
                                    height: 87,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  item['content_name'] as String,
                                  style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 14,
                                    color: const Color(0xFF1F1F1F),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
