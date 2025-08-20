import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/track.ctr.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AllBrandB2C extends StatelessWidget {
  const AllBrandB2C({super.key});

  @override
  Widget build(BuildContext context) {
    final brandCtr = Get.find<BrandCtr>();
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.ibmPlexSansThai())),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.ibmPlexSansThai())),
          textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
          appBar: appBarMasterEndUser('แบรนด์ทั้งหมด'),
          body: Obx(() {
            if (brandCtr.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
              ),
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Get.width >= 768 ? 4 : 3,
                    mainAxisSpacing: Get.width >= 768 ? 12 : 6,
                    crossAxisSpacing: Get.width >= 768 ? 12 : 4,
                    mainAxisExtent: Get.width >= 768 ? 120 : 80),
                itemCount: brandCtr.brandsList!.data.length,
                itemBuilder: (context, index) {
                  var items = brandCtr.brandsList!.data[index];
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Get.find<TrackCtr>()
                          .setLogContentAddToCart(items.brandId, 'mall_brands');
                      Get.find<TrackCtr>().setDataTrack(
                        items.brandId,
                        items.brandName,
                        "mall_brands",
                      );
                      brandCtr.fetchShopData(items.sellerId);
                      await Get.toNamed('/BrandStore/${items.sellerId}',
                              arguments: items.sectionId == 0 ? 0 : 1,
                              parameters: {
                            "sectionId": items.sectionId.toString(),
                            "viewType": items.sectionId == 0 ? '0' : '1',
                          })!
                          .then((res) {
                        Get.find<TrackCtr>().clearLogContent();
                      });
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              bottom: 8, top: 4, left: 4, right: 4),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.grey.shade100, width: 1)),
                          child: CachedNetworkImage(
                            imageUrl: items.icon,
                            height: Get.width >= 768 ? 120 : 60,
                            width: Get.width,
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          child: Container(
                            width: Get.width >= 768 ? 120 : 80,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 1),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              items.brandName,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.ibmPlexSansThai(
                                  height: 1.2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Get.width >= 768 ? 16 : 12),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
