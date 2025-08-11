// import 'package:lottie/lottie.dart';

import 'package:fridayonline/safearea.dart';

import '../../../controller/app_controller.dart';
import '../../../controller/badger/badger_controller.dart';
import '../../../controller/cart/cart_controller.dart';
import '../../../controller/cart/dropship_controller.dart';
import '../../../controller/category/category_controller.dart';
import '../../../controller/catelog/catelog_controller.dart';
import '../../../controller/home/home_controller.dart';
import '../../../controller/notification/notification_controller.dart';
import '../../../controller/pro_filecontroller.dart';
import '../../../homepage/myhomepage.dart';
// import '../../../homepage/pageactivity/widget_appbar_title_only.dart';
import '../../../homepage/theme/theme_color.dart';
import '../../../homepage/theme/themeimage_menu.dart';
import '../../../service/languages/multi_languages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../service/logapp/logapp_service.dart';
import '../../theme/theme_loading.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  final multiLanguages = MultiLanguages(); //ใช้สำหรับการแปลภาษา

  String? lang = 'th'; //เก็บตัวย่อของภาษาที่จะแปล
  var langBack; //เก็บตัวย่อของภาษาที่จะแปล
  bool isChecked1 = true; //ใช้ตรวจสอบ checkbox ตัวที่1 |ไทย|
  bool isChecked2 = false; //ใช้ตรวจสอบ checkbox ตัวที่2 |พม่า|
  bool isChecked3 = false; //ใช้ตรวจสอบ checkbox ตัวที่3 |กัมพูชา|

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    setState(() {
      langBack = Get.parameters[
          'lang']; //รับภาษาปัจจุบันมาเก็บไวใน ที่ส่งมาจาก url มาเก็บไว้ใน lang
      lang = Get.parameters[
          'lang']; //รับภาษาปัจจุบันมาเก็บไวใน ที่ส่งมาจาก url มาเก็บไว้ใน lang

      //กรณี lang เป็นภาษาไทย
      if (lang == 'th') {
        isChecked1 = true;
        isChecked2 = false;
        isChecked3 = false;

        //กรณี lang เป็นภาษาพม่า
      } else if (lang == 'my') {
        isChecked1 = false;
        isChecked2 = true;
        isChecked3 = false;

        //กรณี lang เป็นภาษากัมพูชา
      } else if (lang == 'km') {
        isChecked1 = false;
        isChecked2 = false;
        isChecked3 = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: SafeAreaProvider(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                multiLanguages.setLocale(context,
                    Locale(langBack)); //ทำการส่งตัวแปรภาษาไปเปลี่ยนภาษา
                Navigator.pop(context, false);
              },
            ),
            backgroundColor: theme_color_df,
            centerTitle: true,
            elevation: 0,
            title: Text(
              MultiLanguages.of(context)!.translate('title_changeLang'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'notoreg',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 40),
                child: Text(
                    MultiLanguages.of(context)!.translate('language_choose'),
                    style: TextStyle(fontSize: 18, color: theme_color_df)),
              )),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isChecked1 = true;
                          isChecked2 = false;
                          isChecked3 = false;
                          lang = 'th';
                          multiLanguages.setLocale(
                              context,
                              const Locale(
                                  'th')); //ทำการส่งตัวแปรภาษาไปเปลี่ยนภาษา
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: img_language_thai,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                        MultiLanguages.of(context)!
                                            .translate('language_th'),
                                        style: const TextStyle(fontSize: 18)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: theme_color_df,
                            side: BorderSide(color: theme_color_df),
                            value: isChecked1,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  isChecked2 = false;
                                  isChecked3 = false;
                                  lang = 'th';
                                  multiLanguages.setLocale(
                                      context,
                                      const Locale(
                                          'th')); //ทำการส่งตัวแปรภาษาไปเปลี่ยนภาษา
                                }
                                isChecked1 = value!;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isChecked1 = false;
                          isChecked2 = true;
                          isChecked3 = false;
                          lang = 'my';
                          multiLanguages.setLocale(
                              context,
                              const Locale(
                                  'my')); //ทำการส่งตัวแปรภาษาไปเปลี่ยนภาษา
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: img_language_myanmar,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                        MultiLanguages.of(context)!
                                            .translate('language_my'),
                                        style: const TextStyle(fontSize: 18)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: theme_color_df,
                            side: BorderSide(color: theme_color_df),
                            value: isChecked2,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  isChecked1 = false;
                                  isChecked3 = false;
                                  lang = 'my';
                                  multiLanguages.setLocale(
                                      context,
                                      const Locale(
                                          'my')); //ทำการส่งตัวแปรภาษาไปเปลี่ยนภาษา
                                }
                                isChecked2 = value!;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isChecked1 = false;
                          isChecked2 = false;
                          isChecked3 = true;
                          lang = 'km';
                          multiLanguages.setLocale(
                              context,
                              const Locale(
                                  'km')); //ทำการส่งตัวแปรภาษาไปเปลี่ยนภาษา
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: img_language_cambodian,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                        MultiLanguages.of(context)!
                                            .translate('language_km'),
                                        style: const TextStyle(fontSize: 18)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: theme_color_df,
                            side: BorderSide(color: theme_color_df),
                            // fillColor: MaterialStateProperty.all(theme_color_df),
                            value: isChecked3,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  isChecked1 = false;
                                  isChecked2 = false;
                                  lang = 'km';
                                  multiLanguages.setLocale(
                                      context,
                                      const Locale(
                                          'km')); //ทำการส่งตัวแปรภาษาไปเปลี่ยนภาษา
                                }
                                isChecked3 = value!;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(theme_color_df),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side:
                                          BorderSide(color: theme_color_df)))),
                      onPressed: () async {
                        multiLanguages.setLocale(context,
                            Locale(lang!)); //ทำการส่งตัวแปรภาษาไปเปลี่ยนภาษา

                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                content: Center(
                                  child: theme_loading_df,
                                ));
                          },
                        );
                        await Future.delayed(const Duration(seconds: 2));
                        Get.find<AppController>().setCurrentNavInget(0);
                        Get.find<DraggableFabController>().draggable_Fab();
                        Get.find<BannerController>().get_banner_data();
                        Get.find<FavoriteController>().get_favorite_data();
                        Get.find<SpecialPromotionController>()
                            .get_promotion_data();
                        // Get.find<SpecialDiscountController>()
                        //     .fetch_special_discount();
                        Get.find<ProductHotItemHomeController>()
                            .get_product_hotitem_data();
                        Get.find<NotificationController>()
                            .get_notification_data();
                        Get.find<ProductHotIutemLoadmoreController>()
                            .resetItem();
                        Get.find<CatelogController>().get_catelog();
                        Get.find<FetchCartItemsController>()
                            .isChangeLanguage(true);
                        Get.find<FetchCartDropshipController>()
                            .fetchCartDropship();
                        Get.find<CategoryMenuController>().isDataLoading(true);
                        Get.find<ProfileController>().get_profile_data();
                        Get.find<ProfileSpecialProjectController>()
                            .get_special_project_data();
                        Get.find<BadgerController>().get_badger();
                        Get.find<BadgerProfileController>()
                            .get_badger_profile();
                        Get.find<BadgerController>().getBadgerMarket();
                        Get.find<KeyIconController>().get_keyIcon_data();
                        Get.find<HomePointController>()
                            .get_home_point_data(false);
                        Get.find<HomeContentSpecialListController>()
                            .get_home_content_data("");

                        //เก็บ log เปลี่ยนภาษา
                        LogAppLanguageCall("ChangeLanguage", lang);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      },
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                              MultiLanguages.of(context)!
                                  .translate('alert_confirm'),
                              style: const TextStyle(fontSize: 18)),
                        ),
                      ))),
            ),
          ),
        ),
      ),
    );
  }
}
