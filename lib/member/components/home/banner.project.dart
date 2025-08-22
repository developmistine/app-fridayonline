import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/webview/webview.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:get/get.dart';

final banner = [
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
  // {
  //   "content_id": 1265,
  //   "action_type": 4,
  //   "action_value": "1265",
  //   "content_name": "แบนเนอร์มิสทิน ลด 50.- วันที่ 15-24 สิงหาคม 2568",
  //   "start_date": "15/08/2025 00:01:37",
  //   "end_date": "24/08/2025 23:59:37",
  //   "image": "assets/images/banner/accidental_insurance.png",
  //   "image_desktop": "assets/images/banner/accidental_insurance.png"
  // },
];

class BannerProject extends StatefulWidget {
  const BannerProject({super.key});

  @override
  State<BannerProject> createState() => _BannerProjectState();
}

class _BannerProjectState extends State<BannerProject> {
  final EndUserHomeCtr endUserHomeCtr = Get.find();
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (!endUserHomeCtr.isLoadingBanner.value &&
        endUserHomeCtr.homeBanner!.code == "-9") {
      return const SizedBox();
    }

    final items = banner; // หรือ endUserHomeCtr.homeBanner!.data
    final canSlide = items.length > 1;

    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: Get.width,
              child: CarouselSlider.builder(
                key: ValueKey(items.length),
                carouselController: _controller,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int itemIndex, int _) {
                  return SizedBox(
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const WebViewApp(
                                mparamurl:
                                    "https://www.friday.co.th:8443/projects/pa-insurance",
                                mparamTitleName: 'โครงการพิเศษ',
                              ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/banner/accidental_insurance.png',
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 120,
                  viewportFraction: 1,
                  autoPlay: canSlide,
                  enableInfiniteScroll: canSlide,
                  scrollPhysics: canSlide
                      ? const PageScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  onPageChanged: (index, reason) {
                    setState(() => _current = index);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
