import 'package:fridayonline/analytics/analytics_engine.dart';
import 'package:fridayonline/homepage/myhomepage.dart';
import 'package:fridayonline/homepage/point_rewards/point_rewards_coupon.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
// import 'package:fridayonline/homepage/widget/appbar_cart.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/point_rewards/point_rewards_get_couponlist.dart';
import '../../model/point_rewards/point_rewards_get_msl_info.dart';
import '../../model/point_rewards/point_rewards_menu.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/pathapi.dart';
import '../../service/point_rewards/point_rewards_sevice.dart';
import '../point_rewards/point_rewards_category.dart';
import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';
import '../webview/webview_full_screen.dart';
import '../widget/cartbutton.dart';

//by jukkapun_s
class SpecialPromotionBwpoint extends StatefulWidget {
  const SpecialPromotionBwpoint({super.key, this.type});
  final type;

  @override
  State<SpecialPromotionBwpoint> createState() =>
      _SpecialPromotionBwpointState();
}

class _SpecialPromotionBwpointState extends State<SpecialPromotionBwpoint> {
  String? lsRepSeq = '';
  String? lsRepCode = '';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  void callMenu_point() async {
    // var mslregist = await GetMenu_pointRewards();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // ดำเนินการ Load Data
    loadgetSharedPreferences();
    // กรณีที่ระบบทำการ LoadData
  }

  // ตั้งค่าเริ่มต้น
  void loadgetSharedPreferences() async {
    // เรียกใช้งาน SharedPreferences ที่เป็น future
    final SharedPreferences prefs = await _prefs;
    // ทำการ Get Data
    setState(() {
      // ทำการ Get ข้อมูลออกมาจาก SharedPreferences
      lsRepSeq = prefs.getString("RepSeq")!;
      lsRepCode = prefs.getString("RepCode")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
              onPressed: (() {
                if ((widget.type == 'profile') ||
                    (widget.type == 'notify') ||
                    (widget.type == 'push')) {
                  Navigator.pop(context);
                } else {
                  Get.off(
                      transition: Transition.rightToLeft, () => MyHomePage());
                }
              }),
              color: Colors.white),
          centerTitle: true,
          backgroundColor: theme_color_df,
          title: Text(
            MultiLanguages.of(context)!.translate('me_bw_point'),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'notoreg',
                fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CartIconButton(),
            )
          ],
        ),

        // appBarTitleCart(
        //     MultiLanguages.of(context)!.translate('me_bw_point')),
        body: SingleChildScrollView(
          child: FutureBuilder(
            //future: GetMslInfoSevice(),
            future: Future.wait([
              GetMslInfoSevice(),
              GetPointRewardsMenuCall(),
              GetcouponlistCall(),
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              //ตรวจสอบว่าโหลดข้อมูลได้ไหม
              //กรณีโหลดข้อมูลได้
              if (snapshot.connectionState == ConnectionState.done) {
                var result = snapshot.data;
                GetMslinfo mslInfo = result![0];
                Menupoint menuPoint = result[1];
                Rewardscouponlist mCountCoupon = result[2];

                return Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          "https://s3.catalog-yupin.com/Images/bw-point-reward.webp",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(0, -1),
                              end: const Alignment(0, 1),
                              colors: <Color>[
                                theme_color_df,
                                const Color(0xFF41D9D9),
                              ], // Gradient from https://learnui.design/tools/gradient-generator.html
                              tileMode: TileMode.mirror,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(children: [
                              Center(
                                child: Text(
                                  mslInfo.repName,
                                  style: const TextStyle(
                                      fontFamily: 'notoreg',
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${NumberFormat.decimalPattern().format(mslInfo.bprBalance)} ',
                                        // '0',
                                        style: const TextStyle(
                                            fontFamily: 'notoreg',
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Transform.translate(
                                        offset: const Offset(0, -1),
                                        child: Text(
                                          MultiLanguages.of(context)!
                                              .translate('order_point'),
                                          style: const TextStyle(
                                              fontFamily: 'notoreg',
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: menuPoint.datamenu.length,
                        itemBuilder: (context, index) {
                          return Card(
                              color: Colors.white,
                              child: ListTile(
                                  tileColor: Colors.white,
                                  onTap: () {
                                    // print(menu_point.datamenu[index].menuType);
                                    if (menuPoint.datamenu[index].menuType ==
                                        "rewards") {
                                      _trackGA('click_member_bwpoint_menu');
                                      Get.to(() => point_rewards_category(
                                          mparamurl:
                                              menuPoint.datamenu[index].img));
                                      // Get.to(() => point_rewards_category_list(
                                      //     mparamurl:
                                      //         menu_point.datamenu[index].img));
                                    } else if (menuPoint
                                            .datamenu[index].menuType ==
                                        "history") {
                                      _trackGA(
                                          'click_member_history_point_menu');
                                      Get.to(() => WebViewFullScreen(
                                          mparamurl:
                                              "${sp_fridayth}webnew/getbwpoint?RepCode=$lsRepSeq"));
                                    } else if (menuPoint
                                            .datamenu[index].menuType ==
                                        "calculate") {
                                      _trackGA('click_member_howpoint_menu');
                                      Get.to(() => WebViewFullScreen(
                                          mparamurl:
                                              "$baseurl_yclub/yclub/bwpoint/how_point_count.php"));
                                    } else if (menuPoint
                                            .datamenu[index].menuType ==
                                        "rule") {
                                      _trackGA('click_member_rulepoint_menu');
                                      Get.to(() => WebViewFullScreen(
                                          mparamurl:
                                              "$baseurl_yclub/yclub/bwpoint/rule.php"));
                                    } else if (menuPoint
                                            .datamenu[index].menuType ==
                                        "coupon") {
                                      _trackGA('click_member_coupon_menu');
                                      Get.to(() => point_rewards_coupon(
                                          mparamurl:
                                              menuPoint.datamenu[index].img));
                                    }
                                  },
                                  title: Row(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: menuPoint.datamenu[index].img,
                                        width: 40,
                                        height: 40,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            menuPoint.datamenu[index].nameMenu,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'notoreg'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Stack(
                                        children: [
                                          if (menuPoint.datamenu[index]
                                                      .menuType ==
                                                  "coupon" &&
                                              mCountCoupon.countCoupon
                                                      .toString() !=
                                                  "0")
                                            // Badge(
                                            //   alignment: Alignment.center,
                                            //
                                            //   badgeStyle: badges.BadgeStyle(
                                            // badgeColor: Colors.red,
                                            // ),
                                            //   elevation: 1,
                                            //   badgeContent: Text(
                                            //       mCountCoupon.countCoupon
                                            //           .toString(),
                                            //       style: const TextStyle(
                                            //           color: Colors.white,
                                            //           fontSize: 13)),
                                            // )
                                            badges.Badge(
                                                //
                                                badgeContent: SizedBox(
                                                    child: Center(
                                                  child: Text(
                                                      mCountCoupon.countCoupon
                                                          .toString(),
                                                      style: const TextStyle(
                                                          inherit: false,
                                                          color: Colors.white,
                                                          fontSize: 12)),
                                                )),
                                                badgeStyle:
                                                    const badges.BadgeStyle(
                                                        badgeColor: Colors.red))
                                          else
                                            Container()
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                  iconColor: theme_color_df));
                        }),
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

  Future<void> _trackGA(String name) async {
    SetData data = SetData();
    AnalyticsEngine.sendAnalyticsEvent(
        name, await data.repCode, await data.repSeq, await data.repType);
  }
}
