import 'package:fridayonline/enduser/controller/profile.ctr.dart';
import 'package:fridayonline/enduser/widgets/webview.screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class B2cSpecialProject extends StatelessWidget {
  const B2cSpecialProject({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileCtl profileCtl = Get.put(ProfileCtl());

    return Obx(() {
      if (profileCtl.isLoadingSpecial.value) {
        return const SizedBox();
      }
      if (profileCtl.specialData.value!.code == "-9" ||
          profileCtl.specialData.value!.data.isEmpty) {
        return const SizedBox();
      }
      return Container(
        width: Get.width,
        margin: const EdgeInsets.all(4),
        child: CarouselSlider.builder(
          itemCount: profileCtl.specialData.value!.data.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
            var data = profileCtl.specialData.value!.data[itemIndex];
            return InkWell(
              onTap: () {
                Get.to(
                    () => WebViewPage(
                          url: data.actionValue,
                          title: data.contentName,
                        ),
                    routeName: 'activity_page');
              },
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: data.image,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: profileCtl.specialData.value!.data.length > 1,
              enableInfiniteScroll:
                  profileCtl.specialData.value!.data.length > 1,
              onPageChanged: (index, reason) {}),
        ),
      );
    });
  }
}
