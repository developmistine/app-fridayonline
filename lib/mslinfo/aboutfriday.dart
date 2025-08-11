// import 'package:fridayonline/controller/app_controller.dart';
// import 'package:fridayonline/homepage/splashscreen.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/webview/webview_app.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';

import 'package:fridayonline/service/pathapi.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

import '../homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import '../service/languages/multi_languages.dart';

final titles = ["me_policy_pdpa", "me_policy_delete_pdpa"];

// แก้ไขเพิ่มเติม
class AboutFriday extends StatefulWidget {
  const AboutFriday({super.key});

  @override
  State<AboutFriday> createState() => _AboutFridayState();
}

class _AboutFridayState extends State<AboutFriday> {
  void _showDialog(text) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: const EdgeInsets.all(20),
        actionsPadding:
            const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                'เราเสียใจที่คุณจะไม่ได้ใช้งานบริการของเราอีก \n แต่หากคุณได้ทำการลบบัญชีสมาชิกแล้ว \n ไม่สามารถทำการกู้กลับมาได้',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'notoreg',
                  color: Color.fromARGB(255, 124, 124, 124),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor:
                            const Color.fromARGB(255, 110, 110, 110),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    child: Text(
                      MultiLanguages.of(context)!.translate('alert_cancel'),
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'notoreg'),
                    )),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          style: BorderStyle.solid, color: theme_red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pop(context);
                    var nametitle = MultiLanguages.of(context)!
                        .translate('me_policy_delete_pdpa');
                    var url =
                        "${baseurl_yclub}yclub/policyandcondition/accountdeletion.php";
                    Get.to(() => webview_app(
                          mparamurl: url,
                          mparamTitleName: nametitle,
                          mparamType: '',
                          mparamValue: '',
                        ));
                  },
                  child: Text(
                    MultiLanguages.of(context)!.translate('alert_okay'),
                    style: TextStyle(color: theme_red, fontFamily: 'notoreg'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  get children => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleMaster(
          MultiLanguages.of(context)!.translate('me_setting')),
      body: Container(
        child: Column(
          children: [
            ListView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), // <-- this will disable scroll
                shrinkWrap: true,
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return Card(
                      color: Colors.white,
                      child: ListTile(
                          tileColor: Colors.white,
                          onTap: () {
                            // log(index.toString());
                            if (index == 0) {
                              var nametitle = MultiLanguages.of(context)!
                                  .translate('me_policy_pdpa');
                              var url =
                                  "${baseurl_yclub}yclub/policyandcondition/privacy-notice_no.php";
                              Get.to(() => webview_app(
                                    mparamurl: url,
                                    mparamTitleName: nametitle,
                                    mparamType: '',
                                    mparamValue: '',
                                  ));
                            } else if (index == 1) {
                              _showDialog("");
                            }
                          },
                          title: Text(
                            MultiLanguages.of(context)!
                                .translate(titles[index]),
                            style: const TextStyle(
                                fontSize: 14, fontFamily: 'notoreg'),
                          ),

                          //  subtitle: Text(subtitles[index]),

                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),
                          iconColor: theme_color_df));
                }),
            // Card(
            //   color: Colors.white,
            //   child: ListTile(
            //       tileColor: Colors.white,
            //       onTap: () {
            //         Get.find<AppController>().setCurrentNavInget(0);
            //         DefaultCacheManager().emptyCache();
            //         Get.offAll(() => const SplashScreen());
            //       },
            //       title: const Text(
            //         'เคลียร์แคชแอปพลิเคชัน',
            //         style: TextStyle(fontSize: 14, fontFamily: 'notoreg'),
            //       ),

            //       //  subtitle: Text(subtitles[index]),

            //       trailing: const Icon(
            //         Icons.arrow_forward_ios,
            //         size: 18,
            //       ),
            //       iconColor: theme_color_df),
            // ),
          ],
        ),
      ),
    );
  }
}
