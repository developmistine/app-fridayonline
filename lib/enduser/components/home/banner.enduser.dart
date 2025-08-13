import 'package:fridayonline/enduser/components/shimmer/shimmer.card.dart';
import 'package:fridayonline/enduser/controller/enduser.home.ctr.dart';
import 'package:fridayonline/enduser/utils/cached_image.dart';
import 'package:fridayonline/enduser/utils/event.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerEndUser extends StatefulWidget {
  const BannerEndUser({
    super.key,
  });

  @override
  State<BannerEndUser> createState() => _BannerEndUserState();
}

class _BannerEndUserState extends State<BannerEndUser> {
  final EndUserHomeCtr endUserHomeCtr = Get.find();
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return !endUserHomeCtr.isLoadingBanner.value
          ? endUserHomeCtr.homeBanner!.code == "-9"
              ? SizedBox(
                  height: Get.width >= 768 ? Get.height / 7.3 : Get.height / 8,
                )
              : Stack(
                  children: [
                    SizedBox(
                      width: Get.width,
                      height: Get.width >= 768
                          ? Get.height / 2.5
                          : Get.height / 2.7,
                      child: CarouselSlider.builder(
                        carouselController: _controller,
                        itemCount: endUserHomeCtr.homeBanner!.data.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            SizedBox(
                          width: Get.width,
                          child: InkWell(
                            onTap: () {
                              var bannerItem =
                                  endUserHomeCtr.homeBanner!.data[itemIndex];
                              eventBanner(bannerItem, 'home_banner');
                            },
                            child: CacheImageBannerB2C(
                              url: endUserHomeCtr
                                  .homeBanner!.data[itemIndex].image,
                            ),
                          ),
                        ),
                        options: CarouselOptions(
                            aspectRatio: 1,
                            viewportFraction: 1,
                            autoPlay: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                    ),
                    Positioned(
                      bottom: -6,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            endUserHomeCtr.homeBanner!.data.length, (index) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(index),
                            child: Container(
                              width: 8.0,
                              // width: _current == index ? 16 : 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: (_current == index
                                          ? Colors.white
                                          : Colors.grey.shade400)
                                      .withOpacity(
                                          _current == index ? 0.9 : 0.5)),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                )
          : Stack(
              children: [
                ShimmerCard(
                  color: Colors.grey.shade50,
                  width: Get.width,
                  height: Get.width >= 768 ? Get.height / 2 : Get.height / 2.7,
                  radius: 0,
                ),
                Positioned.fill(
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Image.asset(
                      'assets/images/b2c/logo/logo_bg.png',
                      width: 80,
                    ),
                  )),
                )
              ],
            );
    });
  }
}
