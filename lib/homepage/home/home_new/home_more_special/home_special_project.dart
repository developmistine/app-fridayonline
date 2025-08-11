import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/home/home_special_project.dart';
import '../../../../service/home/home_service.dart';

class HomeSpecialProject extends StatelessWidget {
  const HomeSpecialProject({super.key});

  @override
  Widget build(BuildContext context) {
    call_home_special_project();
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
          appBar: appBarTitleMaster('โครงการพิเศษสำหรับสมาชิก'),
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                //? tabbar controller
                Container(
                  constraints: const BoxConstraints(maxHeight: 150.0),
                  child: Material(
                    color: const Color(0xff2ffffff),
                    child: TabBar(
                      labelColor: theme_color_df,
                      indicatorColor: theme_color_df,
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        Tab(
                          child: Text(
                            'โครงการที่เข้าร่วมแล้ว',
                          ),
                        ),
                        Tab(
                          child: Text(
                            'โครงการที่ยังไม่เข้าร่วม',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //? tabbar view
                Expanded(
                  child: Center(
                    child: TabBarView(
                      children: [
                        projectIn(),
                        projectWait(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

//? โครงการเข้าร่วม
  projectIn() {
    return FutureBuilder(
        future: call_home_special_project(),
        builder: (BuildContext context,
            AsyncSnapshot<HomeSpecialProjectModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.dataApInProject.isNotEmpty) {
              var dataLength = snapshot.data!.dataApInProject.length;
              var projectIn = snapshot.data;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: dataLength,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => WebViewFullScreen(
                                    mparamurl: Uri.encodeFull(projectIn
                                            .dataApInProject[index].urlLink)
                                        .toString(),
                                  ));
                            },
                            child: Container(
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        projectIn!
                                            .dataApInProject[index].savProject,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: theme_color_df,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: projectIn
                                                  .dataApInProject[index]
                                                  .urlImg,
                                            )),
                                      ),
                                      const Text(
                                        'ระยะเวลากิจกรรม',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'รอบการขาย ${projectIn.dataApInProject[index].campaignCurrent}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal),
                                      )
                                    ],
                                  ),
                                )),
                          );
                        }),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      'assets/images/logo/logofriday.png',
                      height: 60,
                    ),
                  ),
                  const Text(
                    'ไม่มีข้อมูลโครงการพิเศษค่ะ',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              );
            }
          } else {
            return Center(
              child: theme_loading_df,
            );
          }
        });
  }

//? โครงการยังไม่เข้าร่วม
  projectWait() {
    return FutureBuilder(
        future: call_home_special_project(),
        builder: (BuildContext context,
            AsyncSnapshot<HomeSpecialProjectModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.dataApInProject.isNotEmpty) {
              var dataLength = snapshot.data!.dataApOutProject.length;
              var projectIn = snapshot.data;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: dataLength,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => WebViewFullScreen(
                                    mparamurl: Uri.encodeFull(projectIn
                                            .dataApOutProject[index].urlLink)
                                        .toString(),
                                  ));
                            },
                            child: Container(
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        projectIn!
                                            .dataApOutProject[index].savProject,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: theme_color_df,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: projectIn
                                                  .dataApOutProject[index]
                                                  .urlImg,
                                            )),
                                      ),
                                      const Text(
                                        'ระยะเวลากิจกรรม',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'รอบจำหน่าย ${projectIn.dataApOutProject[index].campaignCurrent}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      if (projectIn.dataApOutProject[index]
                                          .urlLink.isNotEmpty)
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            margin: const EdgeInsets.all(12),
                                            height: 60,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        theme_color_df),
                                                onPressed: () {
                                                  Get.to(
                                                      () => WebViewFullScreen(
                                                            mparamurl: Uri.encodeFull(
                                                                    projectIn
                                                                        .dataApOutProject[
                                                                            index]
                                                                        .urlLink)
                                                                .toString(),
                                                          ));
                                                },
                                                child: const Text(
                                                  'สมัครเข้าร่วมโครงการ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )),
                                          ),
                                        )
                                    ],
                                  ),
                                )),
                          );
                        }),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      'assets/images/logo/logofriday.png',
                      height: 60,
                    ),
                  ),
                  const Text(
                    'ไม่มีข้อมูลโครงการพิเศษค่ะ',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              );
            }
          } else {
            return Center(
              child: theme_loading_df,
            );
          }
        });
  }
}
