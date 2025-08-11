import 'package:fridayonline/homepage/point_rewards/point_rewards_coupon_detail_starbucks_genqrcode.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../service/languages/multi_languages.dart';
import '../../service/point_rewards/point_rewards_sevice.dart';

import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';

class point_rewards_coupon_detail_starbucks extends StatefulWidget {
  const point_rewards_coupon_detail_starbucks({
    super.key,
    required this.mparamCouponCode,
    required this.mparamCouponName,
    required this.mparamImgCoupon,
    required this.mparamExpDate,
    required this.mparamCouponType,
    required this.mparamUseCoupon,
  });
  final String mparamCouponCode;
  final String mparamCouponName;
  final String mparamImgCoupon;
  final String mparamExpDate;
  final String mparamCouponType;
  final String mparamUseCoupon;

  @override
  State<point_rewards_coupon_detail_starbucks> createState() =>
      _point_rewards_coupon_detaiState(mparamCouponCode, mparamCouponName,
          mparamImgCoupon, mparamExpDate, mparamCouponType, mparamUseCoupon);
}

class _point_rewards_coupon_detaiState
    extends State<point_rewards_coupon_detail_starbucks> {
  final String mparamCouponCode;
  final String mparamCouponName;
  final String mparamImgCoupon;
  final String mparamExpDate;
  final String mparamCouponType;
  final String mparamUseCoupon;

  get lsRepSeq => null;

  _point_rewards_coupon_detaiState(
      this.mparamCouponCode,
      this.mparamCouponName,
      this.mparamImgCoupon,
      this.mparamExpDate,
      this.mparamCouponType,
      this.mparamUseCoupon);

  @override
  void initState() {
    super.initState();
    // print('mparamUseCoupon ' + mparamUseCoupon);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              if (mparamUseCoupon == 'N') {
                Navigator.pop(context, true);
              } else {
                Navigator.pop(context, false);
              }
            },
          ),
          centerTitle: true,
          backgroundColor: theme_color_df,
          title: Text(
            MultiLanguages.of(context)!.translate('coupon_me'),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'notoreg',
                fontWeight: FontWeight.bold),
          ),
        ),
        //AppBarRelodeMaster(
        //     MultiLanguages.of(context)!.translate('coupon_me'),
        //     '/back_appbar_coupon_detail'),
        // appBarTitleMaster(MultiLanguages.of(context)!.translate('coupon_me')),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: Future.wait([
              GetcouponlistCall(),
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              //ตรวจสอบว่าโหลดข้อมูลได้ไหม
              //กรณีโหลดข้อมูลได้
              if (snapshot.connectionState == ConnectionState.done) {
                //    var result = snapshot.data;
                // Rewardscouponlist pRewardscouponlist = result![0];

                return Center(
                  child: Column(
                    children: [
                      Stack(clipBehavior: Clip.none, children: <Widget>[
                        Image.asset(
                            width: 350,
                            height: 350,
                            'assets/images/e_coupon_100.jpg'),
                        // CachedNetworkImage(
                        //   imageUrl:
                        //       "https://s3.catalog-yupin.com/DDS/Banner/Mistine/B.jpg",
                        //   alignment: Alignment.center,
                        // ),
                        Positioned(
                          // draw a red marble
                          top: 186,
                          right: 8,
                          child: Column(
                            children: [
                              QrImageView(
                                data: mparamCouponCode,
                                size: 76,
                              ),
                              Transform.translate(
                                offset: const Offset(0.0, -5),
                                child: Text(
                                  mparamCouponCode,
                                  style: const TextStyle(
                                    fontSize: 6,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      ButtonTheme(
                        minWidth: 150.0,
                        height: 40.0,
                        child: SizedBox(
                          width: 334,
                          height: 60,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all<Color>(
                                    Colors.white),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    theme_color_df),
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: BorderSide(
                                            color: theme_color_df)))),
                            onPressed: () async {
                              Get.to(() =>
                                  point_rewards_coupon_detail_starbucks_genqrcode(
                                    mparamCouponCode: mparamCouponCode,
                                    mparamCouponName: mparamCouponName,
                                    mparamImgCoupon: mparamImgCoupon,
                                    mparamExpDate: mparamExpDate,
                                    mparamCouponType: mparamCouponType,
                                    mparamUseCoupon: mparamUseCoupon,
                                  ));
                            },
                            child: const Text('รับสิทธิ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                //กรณีไม่สามารถโหลดข้อมูลได้
              } else {
                return Center(
                  heightFactor: 15,
                  child: theme_loading_df,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
