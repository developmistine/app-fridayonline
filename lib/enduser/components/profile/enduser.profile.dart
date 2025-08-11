import 'package:fridayonline/enduser/components/shimmer/shimmer.card.dart';
import 'package:fridayonline/enduser/controller/profile.ctr.dart';
import 'package:fridayonline/enduser/views/(profile)/edit.profile.dart';
import 'package:fridayonline/enduser/views/(profile)/friday.coin.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/formatter_text.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DataProfiles extends StatefulWidget {
  const DataProfiles({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DataProfilesState createState() => _DataProfilesState();
}

class _DataProfilesState extends State<DataProfiles> {
  final ProfileCtl profileCtl = Get.put(ProfileCtl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (profileCtl.isLoading.value) {
        return Container(
          height: 90,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const ShimmerCard(
                    width: 60,
                    height: 60,
                    radius: 50,
                  ),
                  Icon(
                    Icons.image,
                    size: 20,
                    color: icon_color_loading,
                  )
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerCard(
                      width: Get.width,
                      height: 12,
                      radius: 2,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    ShimmerCard(
                      width: Get.width,
                      height: 12,
                      radius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 120),
            ],
          ),
        );
      }

      final profile = profileCtl.profileData.value;
      final telNumFormat = profile?.mobile ?? '';

      return Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async {
                await Get.to(() => const EditProfile(), arguments: {
                  "displayName": profile?.displayName,
                  "mobile": profile?.mobile,
                  "image": profile?.image
                })?.then((result) {
                  profileCtl.fetchProfile();
                });
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        profile?.image.isNotEmpty == true
                            ? profile!.image
                            : 'assets/images/profileimg/user.png',
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                              'assets/images/profileimg/user.png',
                              width: 55,
                              height: 55);
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 14,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile?.displayName ?? 'N/A',
                          style: GoogleFonts.notoSansThaiLooped(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatTelHidden(telNumFormat),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => FridayCoin());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFF512F),
                                Color(0xFFF09819),
                              ])),
                      child: Row(
                        children: [
                          Text(
                            "Coin ของฉัน : ",
                            style: GoogleFonts.notoSansThaiLooped(
                                color: Colors.white, fontSize: 13),
                          ),
                          Text(
                            myFormat.format(profile!.coinBalance),
                            style: GoogleFonts.notoSansThaiLooped(
                                color: Colors.yellow, fontSize: 13),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Image.asset(
                            'assets/images/b2c/icon/coin2.png',
                            width: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
