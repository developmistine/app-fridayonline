import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/utils/cached_image.dart';
import 'package:fridayonline/member/utils/event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupperDeal extends StatelessWidget {
  const SupperDeal({super.key});

  @override
  Widget build(BuildContext context) {
    final EndUserHomeCtr endUserHomeCtr = Get.find();

    return Obx(() {
      return !endUserHomeCtr.isLoadingSupperDeal.value
          ? endUserHomeCtr.supperDeal!.code == '-9'
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: endUserHomeCtr
                        .supperDeal!.data.contentTypeDetail.length,
                    itemBuilder: (context, index) {
                      var contentDetails = endUserHomeCtr
                          .supperDeal!.data.contentTypeDetail[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                            contentDetails.contentDetail.length, (idx) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              eventBanner(contentDetails.contentDetail[idx],
                                  "home_super_deal");
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: CacheImageBannerShop(
                                  url: contentDetails.contentDetail[idx].image),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                )
          : const SizedBox();
    });
  }
}
