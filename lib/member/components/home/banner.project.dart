import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/webview/webview.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/member/services/track/track.service.dart';
import 'package:fridayonline/member/utils/cached_image.dart';
import 'package:get/get.dart';

class BannerProject extends StatefulWidget {
  const BannerProject({super.key});

  @override
  State<BannerProject> createState() => _BannerProjectState();
}

class _BannerProjectState extends State<BannerProject> {
  final EndUserHomeCtr endUserHomeCtr = Get.find();
  final CarouselSliderController _controller = CarouselSliderController();
  final signInController = Get.put(EndUserSignInCtr());

  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (endUserHomeCtr.isLoadingProjectsBanner.value) {
        return const SizedBox.shrink();
      }

      final resp = endUserHomeCtr.homeProjectsBanner;
      final items = resp?.data ?? const [];
      if (resp == null || resp.code == '-9' || items.isEmpty) {
        return const SizedBox.shrink();
      }

      final canSlide = items.length > 1;

      return SizedBox(
        width: Get.width,
        child: CarouselSlider.builder(
          carouselController: _controller,
          itemCount: items.length,
          itemBuilder: (context, index, _) {
            final item = items[index];
            final img = item.image;
            if (img.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (_navigating) return;
                  _navigating = true;

                  if (item.actionType != 1) return;
                  final sw = Stopwatch()..start();

                  String result = '';
                  try {
                    result = await Get.to(() => WebViewApp(
                          mparamurl: item.actionValue,
                          mparamTitleName: 'สิทธิพิเศษ',
                        ));
                  } finally {
                    sw.stop();
                    final secs = (sw.elapsedMilliseconds / 1000).round();
                    final spent = secs < 1 ? 1 : secs;

                    try {
                      final actionFlag = result == 'accept' ? 'accept' : 'view';
                      if (item.pgmId != 0) {
                        await setTrackIncentiveContentViewServices(
                          item.contentId,
                          item.contentName,
                          'home_incentive',
                          spent,
                          item.pgmId,
                          actionFlag,
                        );
                      }
                    } catch (_) {}

                    _navigating = false;
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CacheImageBannerB2C(
                    url: img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 100,
            viewportFraction: 1,
            autoPlay: canSlide,
            enableInfiniteScroll: canSlide,
            scrollPhysics: canSlide
                ? const PageScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 500),
          ),
        ),
      );
    });
  }
}
