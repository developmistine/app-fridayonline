import 'package:fridayonline/homepage/dialogalert/customalertdialogs.dart';
import 'package:fridayonline/homepage/webview/webview_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/point_rewards/point_rewards_get_category_detail_list.dart';
import '../../model/point_rewards/point_rewards_get_msl_info.dart';
import '../../model/point_rewards/point_rewards_menu.dart';
import '../../model/set_data/set_data.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/pathapi.dart';
import '../../service/point_rewards/point_rewards_sevice.dart';

import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';
import '../webview/webview_full_screen.dart';
import '../widget/appbar_cart.dart';

class point_rewards_category_list extends StatefulWidget {
  const point_rewards_category_list(
      {super.key,
      required this.mparamIdcat,
      required this.mNameTh,
      required this.mProintStart,
      required this.mProintEnd,
      required this.mTypeList});
  final String? mparamIdcat;
  final String? mNameTh;
  final String? mProintStart;
  final String? mProintEnd;
  final String? mTypeList;

  @override
  State<point_rewards_category_list> createState() =>
      _point_rewards_category_listState(
          mparamIdcat, mNameTh, mProintStart, mProintEnd, mTypeList);
}

class _point_rewards_category_listState
    extends State<point_rewards_category_list> {
  var mparamIdcat;
  var mNameTh;
  var mProintStart;
  var mProintEnd;
  var mTypeList;

  _point_rewards_category_listState(this.mparamIdcat, this.mNameTh,
      this.mProintStart, this.mProintEnd, this.mTypeList);

  get lsRepSeq => null;

  SetData data = SetData();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: appBarTitleCart(
            MultiLanguages.of(context)!.translate('me_bw_point'), ""),
        body: FutureBuilder(
          //future: GetMslInfoSevice(),
          future: Future.wait([
            GetMslInfoSevice(),
            GetPointRewardsMenuCall(),
            GetCategoryDetailListCall(
                mparmId: mparamIdcat,
                mparmTypeList: mTypeList,
                mparmProintStart: mProintStart,
                mparmProintEnd: mProintEnd),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            //ตรวจสอบว่าโหลดข้อมูลได้ไหม
            //กรณีโหลดข้อมูลได้
            if (snapshot.connectionState == ConnectionState.done) {
              var result = snapshot.data;
              GetMslinfo mslInfo = result![0];
              Menupoint menuPoint = result[1];
              Rewardsgetcategory getcategory = result[2];

              var idCard = mslInfo.idcardRequire;

              // print(msl_info.idcardRequire);

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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                mNameTh,
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
                      ],
                    ),
                    const Divider(
                      color: Colors.black12,
                      thickness: 0.5,
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: getcategory.productGroup.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              if (!getcategory.productGroup[index].isInStock) {
                                return showDialog(
                                  barrierColor: Colors.black26,
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialogs(
                                      title: MultiLanguages.of(context)!
                                          .translate('out_stock'),
                                      description: MultiLanguages.of(context)!
                                          .translate('temporarily_out_stock'),
                                    );
                                  },
                                );
                              }
                              // print(id_card);
                              // id_card ต้องการเลขบัตรประชาชนก่อนถึงจะสามารถแลกคะแนนได้
                              var cpRepSeq = await data.repSeq;
                              var cpRepCode = await data.repCode;
                              var cpFscode =
                                  getcategory.productGroup[index].fscode;
                              if (idCard == "Y") {
                                Get.to(() => WebViewFullScreen(
                                    mparamurl: Uri.encodeFull(
                                        "${baseurl_web_view}main-less/main_less.php?repseq=$cpRepSeq&repcode=$cpRepCode")));
                              } else {
                                Get.to(() => webview_app(
                                    mparamurl: Uri.encodeFull(
                                        "${base_url_web_fridayth}bwpoint/product?billCode=$cpFscode"),
                                    mparamTitleName: MultiLanguages.of(context)!
                                        .translate('point_titleView'),
                                    mparamType: 'rewards_detail',
                                    mparamValue: cpFscode));
                                //
                              }
                              // print(123);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 8, 16, 4),
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(0),
                                              bottomRight: Radius.circular(0),
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                            child: Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                CachedNetworkImage(
                                                  fadeInCurve: Curves.easeIn,
                                                  imageUrl: getcategory
                                                      .productGroup[index]
                                                      .imageUrl,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                ),
                                                if (!getcategory
                                                    .productGroup[index]
                                                    .isInStock)
                                                  CachedNetworkImage(
                                                    imageUrl: getcategory
                                                        .productGroup[index]
                                                        .imageAppend,
                                                    width: 150,
                                                    fit: BoxFit.cover,
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    getcategory
                                                        .productGroup[index]
                                                        .productName,
                                                    style: TextStyle(
                                                        color: theme_color_df,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(
                                              primary: false,
                                              shrinkWrap: true,
                                              itemCount: getcategory
                                                  .productGroup[index]
                                                  .couponList
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index2) {
                                                return Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                              child: getcategory
                                                                          .productGroup[
                                                                              index]
                                                                          .couponList
                                                                          .length >
                                                                      1
                                                                  ? Text(getcategory
                                                                      .productGroup[
                                                                          index]
                                                                      .couponList[
                                                                          index2]
                                                                      .detailCoupon)
                                                                  : Text(getcategory
                                                                      .productGroup[
                                                                          index]
                                                                      .couponList[
                                                                          index2]
                                                                      .detailCoupon)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
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
                    )
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
    );
  }
}
