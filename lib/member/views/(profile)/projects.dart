import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/components/webview/webview.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecialProjects extends StatelessWidget {
  const SpecialProjects({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileCtl profileCtl = Get.put(ProfileCtl());

    return Obx(() {
      if (profileCtl.isLoadingSpecial.value) {
        return const SizedBox();
      }

      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: GoogleFonts.ibmPlexSansThai(),
              ),
            ),
            textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: Scaffold(
            backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
            appBar: appBarMasterEndUser('โครงการพิเศษ'),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  profileCtl.isLoadingSpecial.value
                      ? Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : (profileCtl.specialData.value!.code == "-9" ||
                              profileCtl.specialData.value!.data.isEmpty
                          ? SizedBox(
                              height: Get.height / 1.5,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/search/zero_search.png',
                                    width: 150,
                                  ),
                                  const Text('ยังไม่มีโครงการพิเศษในขณะนี้'),
                                ],
                              )),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount:
                                    profileCtl.specialData.value!.data.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      profileCtl.specialData.value!.data[index];
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.to(
                                              () => WebViewApp(
                                                    mparamurl: item.actionValue,
                                                    mparamTitleName:
                                                        item.contentName,
                                                  ),
                                              routeName: 'activity_page');
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(12),
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            shadows: [
                                              BoxShadow(
                                                color: Color(0x19BCBCBC),
                                                blurRadius: 14,
                                                offset: Offset(0, 1),
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  item.image,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                item.contentName,
                                                style:
                                                    GoogleFonts.ibmPlexSansThai(
                                                  fontSize: 14,
                                                  color:
                                                      const Color(0xFF1F1F1F),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              // Text(
                                              //   'ช้อปทุกเดือนก็ได้รับสิทธิ์ความคุ้มครองฟรี!เพียงมียอดซื้อสะสม\nตั้งแต่ ฿800บาท ขึ้นไปต่อเดือนก็จะได้รับสิทธิ์ประกันโดยไม่มีค่าใช้จ่ายเพิ่มเติมมอบความมั่นใจให้ทุกการช้อป',
                                              //   style:
                                              //       GoogleFonts.ibmPlexSansThai(
                                              //     fontSize: 12,
                                              //     color:
                                              //         const Color(0xFF8C8A94),
                                              //     fontWeight: FontWeight.w400,
                                              //   ),
                                              //   maxLines: 2,
                                              //   overflow: TextOverflow.ellipsis,
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  );
                                },
                              ),
                            ))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
