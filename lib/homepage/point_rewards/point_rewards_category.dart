import 'package:fridayonline/analytics/analytics_engine.dart';
import 'package:fridayonline/homepage/point_rewards/point_rewards_category_list.dart';
import 'package:fridayonline/homepage/point_rewards/point_rewards_category_search.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/point_rewards/point_rewards_controller.dart';
import '../../model/point_rewards/point_rewards_get_category.dart';
import '../../model/point_rewards/point_rewards_get_msl_info.dart';
import '../../model/point_rewards/point_rewards_menu.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/point_rewards/point_rewards_sevice.dart';
import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';
import '../widget/appbar_cart.dart';

class point_rewards_category extends StatefulWidget {
  final String mparamurl;

  const point_rewards_category({super.key, required this.mparamurl});

  @override
  State<point_rewards_category> createState() => _point_rewards_categoryState();
}

class _point_rewards_categoryState extends State<point_rewards_category> {
  get lsRepSeq => null;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: appBarTitleCart(
            MultiLanguages.of(context)!.translate('me_bw_point'), ""),
        body: DefaultTabController(
          length: 2,
          child: FutureBuilder(
            //future: GetMslInfoSevice(),
            future: Future.wait([
              GetMslInfoSevice(),
              GetPointRewardsMenuCall(),
              GetPointCategoryCall(),
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              //ตรวจสอบว่าโหลดข้อมูลได้ไหม
              //กรณีโหลดข้อมูลได้
              if (snapshot.connectionState == ConnectionState.done) {
                var result = snapshot.data;
                GetMslinfo mslInfo = result![0];
                Menupoint menuPoint = result[1];
                Pointcategory menuCategory = result[2];

                return Padding(
                  padding: const EdgeInsets.only(left: 5, top: 0, right: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CachedNetworkImage(
                            imageUrl: menuPoint.datamenu[0].img,
                            width: 40,
                            height: 40,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    menuPoint.datamenu[0].nameMenu,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'คุณมี ${NumberFormat.decimalPattern().format(mslInfo.bprBalance)} ${MultiLanguages.of(context)!.translate('point_text')} ',
                                    style: TextStyle(color: theme_color_df),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black12,
                        thickness: 0.9,
                      ),
                      InkWell(
                        onTap: () {
                          // print("sss");
                          Get.find<SearchPointRewardsController>().reset();
                          Get.to(() => const point_rewards_category_search());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(6)),
                          height: 35,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: theme_color_df,
                                ),
                                Text(
                                  MultiLanguages.of(context)!
                                      .translate('product_search_rewards'),
                                  style: TextStyle(color: theme_color_df),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      TabBar(
                          labelColor: theme_color_df,
                          indicatorColor: theme_color_df,
                          unselectedLabelColor: const Color(0xFFABABAB),
                          indicatorWeight: 2.0,
                          tabs: [
                            Tab(
                              child: Text(
                                  MultiLanguages.of(context)!
                                      .translate('search_rewards_tab1'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  )),
                            ),
                            Tab(
                              child: Text(
                                  MultiLanguages.of(context)!
                                      .translate('search_rewards_tab2'),
                                  style: const TextStyle(fontSize: 14)),
                            ),
                          ]),
                      Expanded(
                        child: TabBarView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GridView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 2,
                                        ),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: menuCategory.childrenData[0]
                                            .childrenData.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () {
                                              switch (index) {
                                                case 0:
                                                  _trackGA(
                                                      'click_redeem_points_under500');
                                                case 1:
                                                  _trackGA(
                                                      'click_redeem_points_501-1000');
                                                case 2:
                                                  _trackGA(
                                                      'click_redeem_points_1001-2000');
                                                case 3:
                                                  _trackGA(
                                                      'click_redeem_points_2001-3000');
                                                case 4:
                                                  _trackGA(
                                                      'click_redeem_points_3001-5000');
                                                case 5:
                                                  _trackGA(
                                                      'click_redeem_points_more5000');
                                                default:
                                                  break;
                                              }
                                              Get.to(() =>
                                                  point_rewards_category_list(
                                                      mparamIdcat: menuCategory
                                                          .childrenData[0]
                                                          .childrenData[index]
                                                          .categoryId
                                                          .toString(),
                                                      mNameTh: menuCategory
                                                          .childrenData[0]
                                                          .childrenData[index]
                                                          .nameTh,
                                                      mProintStart: menuCategory
                                                          .childrenData[0]
                                                          .childrenData[index]
                                                          .startPoint,
                                                      mProintEnd: menuCategory
                                                          .childrenData[0]
                                                          .childrenData[index]
                                                          .endPoint,
                                                      mTypeList: "point"));
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: menuCategory
                                                  .childrenData[0]
                                                  .childrenData[index]
                                                  .imageUrl,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GridView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 2,
                                        ),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: menuCategory.childrenData[1]
                                            .childrenData.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () {
                                              switch (index) {
                                                case 0:
                                                  _trackGACategory(
                                                      'click_redeem_points_category01',
                                                      menuCategory
                                                          .childrenData[1]
                                                          .childrenData[index]
                                                          .nameTh
                                                          .toString());
                                                case 1:
                                                  _trackGACategory(
                                                      'click_redeem_points_category02',
                                                      menuCategory
                                                          .childrenData[1]
                                                          .childrenData[index]
                                                          .nameTh
                                                          .toString());
                                                case 2:
                                                  _trackGACategory(
                                                      'click_redeem_points_category03',
                                                      menuCategory
                                                          .childrenData[1]
                                                          .childrenData[index]
                                                          .nameTh
                                                          .toString());
                                                case 3:
                                                  _trackGACategory(
                                                      'click_redeem_points_category04',
                                                      menuCategory
                                                          .childrenData[1]
                                                          .childrenData[index]
                                                          .nameTh
                                                          .toString());
                                                case 4:
                                                  _trackGACategory(
                                                      'click_redeem_points_category05',
                                                      menuCategory
                                                          .childrenData[1]
                                                          .childrenData[index]
                                                          .nameTh
                                                          .toString());
                                                case 5:
                                                  _trackGACategory(
                                                      'click_redeem_points_category06',
                                                      menuCategory
                                                          .childrenData[1]
                                                          .childrenData[index]
                                                          .nameTh
                                                          .toString());
                                                case 6:
                                                  _trackGACategory(
                                                      'click_redeem_points_category07',
                                                      menuCategory
                                                          .childrenData[1]
                                                          .childrenData[index]
                                                          .nameTh
                                                          .toString());
                                                case 7:
                                                  _trackGACategory(
                                                      'click_redeem_points_category08',
                                                      menuCategory
                                                          .childrenData[1]
                                                          .childrenData[index]
                                                          .nameTh
                                                          .toString());
                                                default:
                                                  break;
                                              }
                                              Get.to(
                                                () =>
                                                    point_rewards_category_list(
                                                        mparamIdcat:
                                                            menuCategory
                                                                .childrenData[1]
                                                                .childrenData[
                                                                    index]
                                                                .categoryId
                                                                .toString(),
                                                        mNameTh: menuCategory
                                                            .childrenData[1]
                                                            .childrenData[index]
                                                            .nameTh,
                                                        mProintStart:
                                                            menuCategory
                                                                .childrenData[1]
                                                                .childrenData[
                                                                    index]
                                                                .startPoint,
                                                        mProintEnd: menuCategory
                                                            .childrenData[1]
                                                            .childrenData[index]
                                                            .endPoint,
                                                        mTypeList:
                                                            "ponitcategory"),
                                              );
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: menuCategory
                                                  .childrenData[1]
                                                  .childrenData[index]
                                                  .imageUrl,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
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

  Future<void> _trackGA(String name) async {
    SetData data = SetData();
    AnalyticsEngine.sendAnalyticsEvent(
        name, await data.repCode, await data.repSeq, await data.repType);
  }

  Future<void> _trackGACategory(String name, String cateName) async {
    SetData data = SetData();
    AnalyticsEngine.sendAnalyticsEventBWpoint(name, cateName,
        await data.repCode, await data.repSeq, await data.repType);
  }
}
