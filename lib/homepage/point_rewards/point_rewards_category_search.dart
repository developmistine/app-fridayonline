import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/point_rewards/point_rewards_controller.dart';
import '../../model/point_rewards/point_rewards_get_category_detail_list.dart';
// import '../../model/point_rewards/point_rewards_get_msl_info.dart';
import '../../model/set_data/set_data.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/pathapi.dart';
// import '../../service/point_rewards/point_rewards_sevice.dart';
import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';
import '../webview/webview_app.dart';
import '../webview/webview_full_screen.dart';
import '../widget/appbar_cart.dart';

class point_rewards_category_search extends StatefulWidget {
  const point_rewards_category_search({Key? key}) : super(key: key);

  @override
  State<point_rewards_category_search> createState() =>
      _point_rewards_category_searchState();
}

class _point_rewards_category_searchState
    extends State<point_rewards_category_search> {
  SetData dataSet = SetData();
  TextEditingController editingController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   Get.find<SearchPointRewardsController>().get_search_data();
  // }

  Rewardsgetcategory? test;
  void filterSearchResults(String query) async {
    if (query.isNotEmpty) {
      Get.find<SearchPointRewardsController>().get_search_datas(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
          appBar: appBarTitleCart(
              MultiLanguages.of(context)!.translate('me_bw_point'), ""),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: const AlignmentDirectional(0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) async {
                              filterSearchResults(value);
                            },
                            controller: editingController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              hintText: MultiLanguages.of(context)!
                                  .translate('product_search_rewards'),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: theme_color_df,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0x00000000),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0x00000000),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: InkWell(
                                onTap: () async {
                                  filterSearchResults(editingController.text);
                                },
                                child: Icon(
                                  Icons.search_sharp,
                                  color: theme_color_df,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black12,
                thickness: 0.5,
              ),
              GetX<SearchPointRewardsController>(
                builder: ((data) {
                  if (data.statusSearch.value) {
                    if (!data.isDataLoading.value) {
                      if (data.getCategory!.productGroup.isNotEmpty) {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: data.getCategory!.productGroup.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () async {
                                  // print(123);
                                  // id_card ต้องการเลขบัตรประชาชนก่อนถึงจะสามารถแลกคะแนนได้
                                  var cpRepSeq = await dataSet.repSeq;
                                  var cpRepCode = await dataSet.repCode;
                                  var cpFscode = data
                                      .getCategory!.productGroup[index].fscode;
                                  if (data.mslInfo!.idcardRequire == "Y") {
                                    Get.to(() => WebViewFullScreen(
                                        mparamurl:
                                            // "${baseurl_web_view}main-less/main_less.php?repseq=$cpRepSeq&repcode=$cpRepCode"
                                            "${baseurl_web_view}main-less/main_less.php?repseq=$cpRepSeq&repcode=$cpRepCode&channel=app&typeOpen=app"));
                                  } else {
                                    Get.to(() => webview_app(
                                        mparamurl:
                                            "${base_url_web_fridayth}bwpoint/product?billCode=$cpFscode",
                                        mparamTitleName:
                                            MultiLanguages.of(context)!
                                                .translate('point_titleView'),
                                        mparamType: 'rewards_detail',
                                        mparamValue: cpFscode));
                                    //
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 8, 16, 4),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 4,
                                                color: Color(0x32000000),
                                                offset: Offset(0, 2),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(0),
                                                  bottomRight:
                                                      Radius.circular(0),
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                ),
                                                child: CachedNetworkImage(
                                                  fadeInCurve: Curves.easeIn,
                                                  imageUrl: data
                                                      .getCategory!
                                                      .productGroup[index]
                                                      .imageUrl,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        data
                                                            .getCategory!
                                                            .productGroup[index]
                                                            .productName,
                                                        style: TextStyle(
                                                            color:
                                                                theme_color_df,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(data
                                                              .getCategory!
                                                              .productGroup[
                                                                  index]
                                                              .couponList[0]
                                                              .detailCoupon),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Expanded(
                          child: Center(
                            child: Text('ไม่พบข้อมูล'),
                          ),
                        );
                      }
                    } else {
                      return Expanded(
                        child: Center(
                          child: theme_loading_df,
                        ),
                      );
                    }
                  }
                  return Container();
                  // return Expanded(
                  //   child: Center(
                  //     child: theme_loading_df,
                  //   ),
                  // );
                }),
              ),
            ],
          )),
    );
  }
}
