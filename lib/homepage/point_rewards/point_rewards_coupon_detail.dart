// ignore_for_file: prefer_interpolation_to_compose_strings

// import 'package:fridayonline/homepage/point_rewards/point_rewards_coupon.dart';
import 'package:fridayonline/homepage/webview/webview_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

// import '../../model/point_rewards/point_rewards_get_couponlist.dart';

import '../../service/languages/multi_languages.dart';
import '../../service/pathapi.dart';
import '../../service/point_rewards/point_rewards_sevice.dart';

import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';

import '../webview/webview_full_screen.dart';

// import '../widget/appbar_relode.dart';
// import '../widget/appbarmaster.dart';

class point_rewards_coupon_detail extends StatefulWidget {
  const point_rewards_coupon_detail({
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
  State<point_rewards_coupon_detail> createState() =>
      _point_rewards_coupon_detaiState(mparamCouponCode, mparamCouponName,
          mparamImgCoupon, mparamExpDate, mparamCouponType, mparamUseCoupon);
}

class _point_rewards_coupon_detaiState
    extends State<point_rewards_coupon_detail> {
  var mparamCouponCode;
  var mparamCouponName;
  var mparamImgCoupon;
  var mparamExpDate;
  var mparamCouponType;
  var mparamUseCoupon;

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
    // TODO: implement initState
    super.initState();
    print('mparamUseCoupon ' + mparamUseCoupon);
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
                // var result = snapshot.data;
                // Rewardscouponlist pRewardscouponlist = result![0];

                return Column(
                  children: [
                    Container(
                      color: Colors.green[700],
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                mparamCouponName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              Text('คูปองหมดอายุ:' + mparamExpDate,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CachedNetworkImage(
                        imageUrl: mparamImgCoupon,
                        alignment: Alignment.center,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            mparamCouponType == "L"
                                ? SizedBox(
                                    height: 100,
                                    child: SfBarcodeGenerator(
                                      value: mparamCouponCode,
                                      showValue: true,
                                    ),
                                  )
                                : Text("รหัส : " + mparamCouponCode,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.black)),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 5, right: 5),
                              child: mparamCouponType == "P"
                                  ? const Text(
                                      "กรุณาแสดง รหัส 10 หลัก กับพนักงานที่สถานีบริการน้ำมันพีที",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.black))
                                  : const Text(""),
                            ),
                            ButtonTheme(
                              minWidth: 150.0,
                              height: 40.0,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            theme_color_df),
                                    shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            side: BorderSide(
                                                color: theme_color_df)))),
                                onPressed: () {
                                  if (mparamCouponType == "P") {
                                    var url =
                                        "${baseurl_yclub}yclub/bwpoint/pt_discount_rule.php";
                                    Get.to(() => WebViewFullScreen(
                                        mparamurl:
                                            Uri.encodeFull(url.toString())));
                                  } else if (mparamCouponType == "D") {
                                    var url =
                                        "${baseurl_web_view}v_coupon_detail?ImgCoupon=$mparamImgCoupon&CouponName=$mparamCouponName";

                                    Get.to(() => webview_app(
                                        mparamurl:
                                            Uri.encodeFull(url.toString()),
                                        mparamTitleName: "ส่วนลดของฉัน"));
                                  } else {
                                    var url =
                                        "${baseurl_yclub}yclub/bwpoint/vouchers_lotus.php";
                                    Get.to(() => WebViewFullScreen(
                                        mparamurl:
                                            Uri.encodeFull(url.toString())));
                                  }
                                },
                                child: Text(
                                    MultiLanguages.of(context)!
                                        .translate('coupon_detail_click'),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
