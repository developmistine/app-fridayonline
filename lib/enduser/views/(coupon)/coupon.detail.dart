import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/components/coupon/coupon.plain.dart';
import 'package:fridayonline/enduser/models/coupon/vouchers.detail.dart';
import 'package:fridayonline/enduser/services/coupon/coupon.services.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CouponDetail extends StatelessWidget {
  final int couponId;
  const CouponDetail({super.key, required this.couponId});

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
                        borderRadius: BorderRadius.circular(8)),
                    textStyle: GoogleFonts.notoSansThaiLooped())),
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: appBarMasterEndUser('รายละเอียดคูปอง'),
            body: FutureBuilder(
                future: fetchVoucherDetail(couponId),
                builder: (context, AsyncSnapshot<VoucherDetail?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (snapshot.data!.code == "-9") {
                    return const Center(
                      child: Text('ไม่พบรายละเอียดคูปอง'),
                    );
                  }
                  VoucherDetail? couponData = snapshot.data;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          color: const Color.fromRGBO(164, 214, 241, 1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 10),
                            child: CouponCardPlain(
                                logo: couponData!.data.image,
                                title: couponData.data.title,
                                subtitle:
                                    "ขั้นต่ำ ฿${couponData.data.rewardInfo.minSpend}",
                                validity: couponData.data.timeInfo.timeFormat,
                                rewardInfo: couponData.data.rewardInfo,
                                quotaInfo: couponData.data.quotaInfo),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(24),
                          width: Get.width,
                          // height: Get.height,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              ...List.generate(couponData.data.usageTerm.length,
                                  (index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      couponData.data.usageTerm[index].key,
                                      style: GoogleFonts.notoSansThaiLooped(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    ...List.generate(
                                        couponData
                                            .data.usageTerm[index].value.length,
                                        (subIndex) => _buildListItem(couponData
                                            .data
                                            .usageTerm[index]
                                            .value[subIndex]))
                                  ],
                                );
                              })
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            bottomNavigationBar: SafeArea(
                child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(color: Colors.grey.shade100, width: 1))),
              padding: const EdgeInsets.only(top: 4),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Colors.white,
                    backgroundColor: themeColorDefault),
                child: const Text('ตกลง'),
                onPressed: () {
                  Get.back();
                },
              ),
            )),
          ),
        ));
  }

  Widget _buildListItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Icon(Icons.circle, size: 4, color: Colors.black),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.notoSansThaiLooped(
                fontSize: 13, color: Colors.grey.shade700),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
