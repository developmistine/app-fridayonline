import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
  const AppBar({super.key});

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
          'ลงทะเบียน ฟรายเดย์ Affiliate',
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
      padding: const EdgeInsets.all(10.0),
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
                        fontWeight: FontWeight.w500, fontSize: 16),
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
                spacing: 14,
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
                            spacing: 2,
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
                                        fontSize: 12),
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

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(),
      Steps(),
      SizedBox(
        height: 10,
      )
    ]);
  }
}
