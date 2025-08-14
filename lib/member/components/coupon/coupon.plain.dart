// import 'package:fridayonline/enduser/models/coupon/vouchers.detail.dart';
import 'package:fridayonline/member/views/(coupon)/coupon.detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CouponCardPlain extends StatelessWidget {
  final String logo;
  final String title;
  final String subtitle;
  final String validity;
  final dynamic rewardInfo;
  final dynamic quotaInfo;

  const CouponCardPlain({
    super.key,
    required this.logo,
    required this.title,
    required this.subtitle,
    required this.validity,
    required this.rewardInfo,
    required this.quotaInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 12),
          width: double.infinity,
          height: 104,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              const SizedBox(width: 104),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(() => const CouponDetail(
                          couponId: 0,
                        ));
                  },
                  highlightColor: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (quotaInfo.percentageUsed.toDouble() > 50)
                        LinearPercentIndicator(
                          padding: EdgeInsets.zero,
                          alignment: MainAxisAlignment.center,
                          animation: true,
                          lineHeight: 4.0,
                          animationDuration: 1500,
                          percent: (quotaInfo.percentageUsed.toDouble()) / 100,
                          backgroundColor: Colors.grey.shade200,
                          linearGradient: const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment(0.8, 1),
                            tileMode: TileMode.mirror,
                            colors: <Color>[
                              Color.fromARGB(255, 228, 40, 7),
                              Color.fromARGB(255, 239, 161, 36),
                            ],
                          ),
                          barRadius: const Radius.circular(10),
                        ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          if (quotaInfo.percentageUsed.toDouble() > 50)
                            Text(
                              'ใช้แล้ว ${quotaInfo.percentageUsed}%',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 11,
                                height: 1.3,
                              ),
                            ),
                          if (quotaInfo.percentageUsed.toDouble() > 50)
                            Text(
                              ' . ',
                              style: TextStyle(
                                  height: 0.8,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          Text(
                            validity,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 11,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        CachedNetworkImage(
          width: 104,
          imageUrl: logo,
          errorWidget: (context, url, error) {
            return const Icon(
              Icons.local_attraction_rounded,
              size: 40,
            );
          },
        ),
      ],
    );
  }
}
