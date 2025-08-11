import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/home/home_controller.dart';
import '../../../model/set_data/set_data.dart';
import '../../../service/logapp/logapp_service.dart';
import '../../../service/pathapi.dart';
import '../../pageactivity/cart/cart_theme/cart_all_theme.dart';
import '../../theme/constants.dart';
import '../../theme/theme_color.dart';
import '../../webview/webview_full_screen.dart';

class HomeShowPoint extends StatelessWidget {
  const HomeShowPoint({super.key});

  @override
  Widget build(BuildContext context) {
    HomePointController isShow = Get.find<HomePointController>();

    //? โชว์ poin หรือ star
    return GetX<HomePointController>(builder: (homePoint) {
      if (!homePoint.isDataLoading.value) {
        if (homePoint.home_point!.isShowPoint) {
          return Container(
            margin: EdgeInsets.zero,
            color: theme_color_df,
            child: InkWell(
              onTap: () async {
                SetData data = SetData();
                var mRepType = await data.repType;
                var mRepcode = await data.repCode;
                var mRepSeq = await data.repSeq;
                var mEndUserID = await data.enduserId;

                if (mRepType == "2") {
                  var mchannel = "18";
                  LogAppTisCall(mchannel, '');
                  Get.toNamed('/special_promotion_bwpoint');
                } else if (mRepType == "1") {
                  var paramUrl =
                      "${baseurl_web_view}starrewardsgetpiont?Repcode=$mRepcode&RepSeq=$mRepSeq&RepType=$mRepType&EndUserID=$mEndUserID";
                  var mchannel = "21";
                  LogAppTisCall(mchannel, '');
                  Get.to(() => WebViewFullScreen(
                      mparamurl: Uri.encodeFull(paramUrl.toString())));
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                height: 70,
                decoration: (BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 28, 115, 156),
                        spreadRadius: 0,
                        blurRadius: 6,
                        offset: Offset(0, 8), // changes position of shadow
                      ),
                    ])),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                          margin: const EdgeInsets.only(top: 4, bottom: 4),
                          child: CachedNetworkImage(
                            imageUrl: homePoint.home_point!.img,
                          )),
                    ),
                    const Expanded(
                      flex: 1,
                      child: VerticalDivider(
                        indent: 15,
                        endIndent: 15,
                        thickness: 1.2,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    if (isShow.home_point!.repType == '2') {
                                      isShow
                                          .showHidePoint(!isShow.isShow.value);
                                    } else {
                                      return;
                                    }
                                  },
                                  child: isShow.home_point!.repType == '2'
                                      ? Obx(
                                          () => !isShow.isLoadingPoint.value
                                              ? Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: isShow.isShow.value
                                                          ? Text(
                                                              myFormat.format(
                                                                  int.parse(homePoint
                                                                      .home_point!
                                                                      .point)),
                                                              style: TextStyle(
                                                                  color:
                                                                      theme_color_df,
                                                                  fontSize: 24,
                                                                  inherit:
                                                                      false,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))
                                                          : Text(homePoint.home_point!.point,
                                                              style: TextStyle(
                                                                  color:
                                                                      theme_color_df,
                                                                  fontSize: 24,
                                                                  inherit:
                                                                      false,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ),
                                                    !isShow.isShow.value
                                                        ? Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    height: 14,
                                                                    'assets/images/home/showEye.png'),
                                                                const Text(
                                                                  ' กดเพื่อดูคะแนน',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    height: 14,
                                                                    'assets/images/home/hideEye.png'),
                                                                const Text(
                                                                    ' กดเพื่อซ่อนคะแนน',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey)),
                                                              ],
                                                            ),
                                                          )
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: 18,
                                                  width: 18,
                                                  child: theme_loading_df),
                                        )
                                      : Text(
                                          myFormat.format(int.parse(
                                              homePoint.home_point!.point)),
                                          style: TextStyle(
                                              color: theme_color_df,
                                              fontSize: 36,
                                              inherit: false,
                                              fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            homePoint.home_point!.repType == '2'
                                ? Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: theme_color_df,
                                    size: 26,
                                  )
                                : const Text(' ดวง',
                                    style: TextStyle(
                                        height: 0.5,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold))
                            // homePoint.home_point!.repType == '1'
                            //     ? const Text(' ดวง',
                            //         style: TextStyle(
                            //             height: 0.5,
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold))
                            //     : const Text(' คะแนน',
                            //         style: TextStyle(
                            //             height: 0.5,
                            //             overflow: TextOverflow.ellipsis,
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold))
                          ],
                        ))
                  ]),
                ),
              ),
            ),
          );
        }
      } else {
        return Container(
          color: Colors.white,
          child: Shimmer.fromColors(
            highlightColor: kBackgroundColor,
            baseColor: const Color(0xFFE0E0E0),
            child: Container(
              margin: const EdgeInsets.all(16),
              height: 70,
              decoration: (BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              )),
            ),
          ),
        );
      }
      return Container();
    });
  }
}
