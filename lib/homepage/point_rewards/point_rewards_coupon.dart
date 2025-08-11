import 'package:fridayonline/homepage/point_rewards/point_rewards_coupon_detail.dart';
import 'package:fridayonline/homepage/point_rewards/point_rewards_coupon_detail_starbucks.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

import '../../model/point_rewards/point_rewards_get_couponlist.dart';

import '../../service/languages/multi_languages.dart';
import '../../service/point_rewards/point_rewards_sevice.dart';

import '../theme/theme_loading.dart';

import '../widget/appbarmaster.dart';

class point_rewards_coupon extends StatefulWidget {
  final String mparamurl;

  const point_rewards_coupon({super.key, required this.mparamurl});

  @override
  State<point_rewards_coupon> createState() => _point_rewards_categoryState();
}

class _point_rewards_categoryState extends State<point_rewards_coupon> {
  get lsRepSeq => null;

  _getReload(val) async {
    if (val == true) {
      setState(() {});
    } else {
      print('not reload');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: appBarTitleMaster(
            MultiLanguages.of(context)!.translate('coupon_me')),
        // appBarTitleCart(MultiLanguages.of(context)!.translate('coupon_me')),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FutureBuilder(
            future: Future.wait([
              GetcouponlistCall(),
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              //ตรวจสอบว่าโหลดข้อมูลได้ไหม
              //กรณีโหลดข้อมูลได้
              if (snapshot.connectionState == ConnectionState.done) {
                var result = snapshot.data;
                Rewardscouponlist pRewardscouponlist = result![0];

                if (pRewardscouponlist.couponlist.isNotEmpty) {
                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: pRewardscouponlist.couponlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x32000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(0),
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(0),
                                    ),
                                    child: CachedNetworkImage(
                                      fadeInCurve: Curves.easeIn,
                                      imageUrl: pRewardscouponlist
                                          .couponlist[index].imgCoupon,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(pRewardscouponlist
                                                .couponlist[index].couponName),
                                            SizedBox(
                                              width: 150,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (pRewardscouponlist
                                                          .couponlist[index]
                                                          .usecoupon ==
                                                      "N") {
                                                    showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                            elevation: 0,
                                                            backgroundColor:
                                                                const Color(
                                                                    0xffffffff),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const SizedBox(
                                                                    height: 15),
                                                                const Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [],
                                                                ),
                                                                const SizedBox(
                                                                    height: 15),
                                                                const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              2.0),
                                                                  child: Text(
                                                                    "คุณต้องการใช้คูปองหรือไม่",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'notoreg'),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 20),
                                                                const Divider(
                                                                  height: 1,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            InkWell(
                                                                          highlightColor:
                                                                              Colors.grey[200],
                                                                          onTap:
                                                                              () {
                                                                            //do somethig

                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "ปิด",
                                                                              style: TextStyle(fontSize: 15.0, color: theme_color_df, fontWeight: FontWeight.bold, fontFamily: 'notoreg'),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            InkWell(
                                                                          highlightColor:
                                                                              Colors.grey[200],
                                                                          onTap:
                                                                              () {
                                                                            //do somethig
                                                                            Navigator.pop(context,
                                                                                false);
                                                                            //เป็นการ Update ข้อมูลว่ามีการเปิดใช้คูปองนี้แล้ว จาก N ,Y
                                                                            UpdateUsecouponCall(mCouponCode: pRewardscouponlist.couponlist[index].couponCode);

                                                                            if (pRewardscouponlist.couponlist[index].couponType ==
                                                                                "S") {
                                                                              Navigator.of(context)
                                                                                  .push(
                                                                                    MaterialPageRoute(builder: (_) => point_rewards_coupon_detail_starbucks(mparamCouponCode: pRewardscouponlist.couponlist[index].couponCode, mparamCouponName: pRewardscouponlist.couponlist[index].couponName, mparamImgCoupon: pRewardscouponlist.couponlist[index].imgCoupon, mparamExpDate: pRewardscouponlist.couponlist[index].expDate, mparamCouponType: pRewardscouponlist.couponlist[index].couponType, mparamUseCoupon: pRewardscouponlist.couponlist[index].usecoupon)),
                                                                                  )
                                                                                  .then((val) => val ? _getReload(val) : null);
                                                                            } else {
                                                                              Navigator.of(context)
                                                                                  .push(
                                                                                    MaterialPageRoute(builder: (_) => point_rewards_coupon_detail(mparamCouponCode: pRewardscouponlist.couponlist[index].couponCode, mparamCouponName: pRewardscouponlist.couponlist[index].couponName, mparamImgCoupon: pRewardscouponlist.couponlist[index].imgCoupon, mparamExpDate: pRewardscouponlist.couponlist[index].expDate, mparamCouponType: pRewardscouponlist.couponlist[index].couponType, mparamUseCoupon: pRewardscouponlist.couponlist[index].usecoupon)),
                                                                                  )
                                                                                  .then((val) => val ? _getReload(val) : null);
                                                                            }
                                                                          },
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "ตกลง",
                                                                              style: TextStyle(fontSize: 15.0, color: theme_color_df, fontWeight: FontWeight.bold, fontFamily: 'notoreg'),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Divider(
                                                                  height: 1,
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        context: context);
                                                  } else {
                                                    //กดดูรายละเอียดข้อมุลคูปอง
                                                    print("cvcTOn");
                                                    // ทดสอบ สตารบัค
                                                    if (pRewardscouponlist
                                                            .couponlist[index]
                                                            .couponType ==
                                                        "S") {
                                                      Navigator.of(context)
                                                          .push(
                                                            MaterialPageRoute(
                                                                builder: (_) => point_rewards_coupon_detail_starbucks(
                                                                    mparamCouponCode: pRewardscouponlist
                                                                        .couponlist[
                                                                            index]
                                                                        .couponCode,
                                                                    mparamCouponName: pRewardscouponlist
                                                                        .couponlist[
                                                                            index]
                                                                        .couponName,
                                                                    mparamImgCoupon: pRewardscouponlist
                                                                        .couponlist[
                                                                            index]
                                                                        .imgCoupon,
                                                                    mparamExpDate: pRewardscouponlist
                                                                        .couponlist[
                                                                            index]
                                                                        .expDate,
                                                                    mparamCouponType: pRewardscouponlist
                                                                        .couponlist[
                                                                            index]
                                                                        .couponType,
                                                                    mparamUseCoupon: pRewardscouponlist
                                                                        .couponlist[
                                                                            index]
                                                                        .usecoupon)),
                                                          )
                                                          .then((val) => val
                                                              ? _getReload(val)
                                                              : null);
                                                    } else {
                                                      Navigator.of(context)
                                                          .push(
                                                            MaterialPageRoute(
                                                                builder: (_) => point_rewards_coupon_detail(
                                                                    mparamCouponCode: pRewardscouponlist
                                                                        .couponlist[
                                                                            index]
                                                                        .couponCode,
                                                                    mparamCouponName: pRewardscouponlist
                                                                        .couponlist[
                                                                            index]
                                                                        .couponName,
                                                                    mparamImgCoupon: pRewardscouponlist
                                                                        .couponlist[
                                                                            index]
                                                                        .imgCoupon,
                                                                    mparamExpDate: pRewardscouponlist
                                                                        .couponlist[
                                                                            index]
                                                                        .expDate,
                                                                    mparamCouponType: pRewardscouponlist
                                                                        .couponlist[
                                                                            index]
                                                                        .couponType,
                                                                    mparamUseCoupon: pRewardscouponlist
                                                                        .couponlist[
                                                                            index]
                                                                        .usecoupon)),
                                                          )
                                                          .then((val) => val
                                                              ? _getReload(val)
                                                              : null);
                                                    }

                                                    // Get.to(() =>
                                                    //     point_rewards_coupon_detail(
                                                    //       mparamCouponCode:
                                                    //           pRewardscouponlist
                                                    //               .couponlist[index]
                                                    //               .couponCode,
                                                    //       mparamCouponName:
                                                    //           pRewardscouponlist
                                                    //               .couponlist[index]
                                                    //               .couponName,
                                                    //       mparamImgCoupon:
                                                    //           pRewardscouponlist
                                                    //               .couponlist[index]
                                                    //               .imgCoupon,
                                                    //       mparamExpDate:
                                                    //           pRewardscouponlist
                                                    //               .couponlist[index]
                                                    //               .expDate,
                                                    //       mparamCouponType:
                                                    //           pRewardscouponlist
                                                    //               .couponlist[index]
                                                    //               .couponType,
                                                    //     ));
                                                  }
                                                  // print("object2");

                                                  // Respond to button press
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      pRewardscouponlist
                                                                  .couponlist[
                                                                      index]
                                                                  .usecoupon ==
                                                              "N"
                                                          ? Colors.blue
                                                          : Colors.black26,
                                                ),
                                                child: Text(
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    pRewardscouponlist
                                                                .couponlist[
                                                                    index]
                                                                .usecoupon ==
                                                            "N"
                                                        ? MultiLanguages.of(
                                                                context)!
                                                            .translate(
                                                                'coupon_use')
                                                        : MultiLanguages.of(
                                                                context)!
                                                            .translate(
                                                                'coupon_detail')),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  );
                } else {
                  return Center(
                    heightFactor: 5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                              'assets/images/logo/logofriday.png',
                              width: 70),
                        ),
                        const Text('ไม่พบข้อมูล'),
                      ],
                    ),
                  );
                }

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
