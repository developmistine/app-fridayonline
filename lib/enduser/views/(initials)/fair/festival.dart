import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/controller/fair.ctr.dart';
import 'package:fridayonline/enduser/utils/event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Festival extends StatelessWidget {
  Festival({super.key});
  final fairController = Get.find<FairController>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      child: MediaQuery(
        data: MediaQuery.of(Get.context!)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: appBarMasterEndUser('Festival'),
          body: Obx(() {
            if (fairController.isLoadingNowDetail.value) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            var items = fairController.nowDetail!.data;
            if (items.isEmpty) {
              return const SizedBox();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    eventBanner(items[index], 'fair_festival');
                  },
                  child: Container(
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                  width: Get.width,
                                  imageUrl: items[index].contentImage)),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(items[index].contentName),
                          Text(
                            items[index].contentDesc,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      )),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
