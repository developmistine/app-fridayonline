// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, must_be_immutable

import 'package:fridayonline/homepage/home/home_new/home_favorite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../controller/cart/cart_controller.dart';
import '../../../controller/home/home_controller.dart';
import '../../../service/languages/multi_languages.dart';
import '../../flashsale/flashsale_home.dart';
import '../../home/home_banner_slider.dart';
import '../../home/home_loadmore_product.dart';
import '../../home/home_product_hotitem.dart';
import '../../home/home_special_promotion.dart';
import '../../myhomepage.dart';
import '../../theme/theme_color.dart';

class ShowCaseHomePage extends StatefulWidget {
  ShowCaseHomePage(
      {super.key,
      required this.ChangeLanguage,
      this.keyThee,
      this.keyFour,
      this.keyFive,
      this.keySix});
  MultiLanguages ChangeLanguage;
  final GlobalKey<State<StatefulWidget>>? keyThee;
  final GlobalKey<State<StatefulWidget>>? keyFour;
  final GlobalKey<State<StatefulWidget>>? keyFive;
  final GlobalKey<State<StatefulWidget>>? keySix;

  @override
  State<ShowCaseHomePage> createState() => _ShowCaseHomePageState();
}

CartItemsEdit shoppingCart = Get.put(CartItemsEdit());

class _ShowCaseHomePageState extends State<ShowCaseHomePage> {
  ScrollController scrollController = ScrollController();
  bool showbtn = false;
  int test = 0;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset >= 1500 && showbtn != true) {
        setState(() {
          showbtn = true;
        });
      }
      if (scrollController.offset < 0.1 && showbtn != false) {
        setState(() {
          showbtn = false;
        });
      }
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        Get.find<ProductHotIutemLoadmoreController>().addItem();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool show;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000), //show/hide animation
        opacity: showbtn ? 1.0 : 0.0, //set obacity to 1 on visible, or hide
        child: FloatingActionButton.extended(
          // label cannot be null, but it's a widget
          // so it can be an empty container or something else
          label: Text(
            widget.ChangeLanguage.translate('home_page_button_to_top'),
            style: const TextStyle(fontFamily: 'notoreg', fontSize: 12),
          ),
          // ignore: prefer_const_constructors
          icon: Icon(
            Icons.arrow_circle_up,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () {
            scrollController.animateTo(
                //go to top of scroll
                0, //scroll offset to go
                duration:
                    const Duration(milliseconds: 1000), //duration of scroll
                curve: Curves.fastOutSlowIn //scroll type
                );
          },
          elevation: 40.0,
          backgroundColor: theme_color_df.withOpacity(0.5),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Showcase.withWidget(
              disableMovingAnimation: true,
              width: width,
              height: height / 1.95,
              container: InkWell(
                onTap: () {
                  setState(() {
                    ShowCaseWidget.of(context).startShowCase([widget.keyFive!]);
                  });
                },
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: SizedBox(
                    width: width / 1.1,
                    height: height / 1.95,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 60.0, top: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                                color: theme_color_df,
                                width: 250,
                                height: 80,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      MultiLanguages.of(context)!
                                          .translate('txt_guide2'),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      // MultiLanguages.of(context)!.translate('txt_guide2')
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 220.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                          theme_color_df),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.white),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          side: BorderSide(
                                              color: theme_color_df)))),
                              onPressed: () {
                                setState(() {
                                  ShowCaseWidget.of(context)
                                      .startShowCase([widget.keyFive!]);
                                });
                              },
                              child: SizedBox(
                                width: 50,
                                height: 40,
                                child: Center(
                                  child: Text(
                                      maxLines: 1,
                                      MultiLanguages.of(context)!
                                          .translate('btn_next_guide'),
                                      style: const TextStyle(fontSize: 16)),
                                ),
                              )),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()));
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              key: widget.keyThee!,
              disposeOnTap: true,
              onTargetClick: () {
                setState(() {
                  ShowCaseWidget.of(context).startShowCase([widget.keyFive!]);
                });
              },
              child: const HomeBannerSlider(),
            ),
            // Showcase(
            //     //overlayColor: theme_color_df,
            //     scrollLoadingWidget: const CircularProgressIndicator(
            //         valueColor: AlwaysStoppedAnimation(Colors.transparent)),
            //
            //     targetPadding: const EdgeInsets.all(20),
            //     descTextStyle:
            //         const TextStyle(fontSize: 16, color: Colors.white),
            //     key: widget.keyThee!,
            //     //title: 'Menu',
            //     description: widget.ChangeLanguage.translate('txt_guide2'),
            //     disposeOnTap: true,
            //     onTargetClick: () {
            //       setState(() {
            //         ShowCaseWidget.of(context).startShowCase([widget.keyFour!]);
            //       });
            //     },
            //     child: const HomeBannerSlider()),

            // Showcase(
            //   scrollLoadingWidget: const CircularProgressIndicator(
            //       valueColor: AlwaysStoppedAnimation(Colors.transparent)),
            //   //overlayColor: theme_color_df,
            //   overlayPadding: const EdgeInsets.all(3),
            //
            //   targetPadding: const EdgeInsets.all(20),
            //   descTextStyle: const TextStyle(fontSize: 16, color: Colors.white),
            //   key: widget.keyFour!,
            //   //title: 'Menu',
            //   description: widget.ChangeLanguage.translate('txt_guide3'),
            //   disposeOnTap: true,
            //   onTargetClick: () {
            //     setState(() {
            //       ShowCaseWidget.of(context).startShowCase([widget.keyFive!]);
            //     });
            //   },
            //   child: const Padding(
            //     padding: EdgeInsets.only(top: 25),
            //     child: HomeFavorite(),
            //   ),
            // ),

            Container(
              color: const Color.fromRGBO(245, 245, 245, 1),
              height: 15,
            ),
            const FlashsaleHome(),
            Container(
              color: const Color.fromRGBO(245, 245, 245, 1),
              height: 15,
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
              child: HomeSpecialPromotion(),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 10, right: 10, bottom: 10, top: 20),
            //   child: ShowCaseHomeSpecialDiscount(
            //     ChangeLanguage: widget.ChangeLanguage,
            //     keyFive: widget.keyFour,
            //     keySix: widget.keyFive!,
            //   ),
            // ),
            Showcase.withWidget(
              disableMovingAnimation: true,
              width: width,
              height: height / 3.5,
              container: InkWell(
                onTap: () {
                  setState(() {
                    ShowCaseWidget.of(context).startShowCase([widget.keySix!]);
                  });
                },
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: SizedBox(
                    width: width / 1.1,
                    height: height / 3.5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                                color: theme_color_df,
                                width: 250,
                                height: 80,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      MultiLanguages.of(context)!
                                          .translate('txt_guide3'),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 165.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                          theme_color_df),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.white),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          side: BorderSide(
                                              color: theme_color_df)))),
                              onPressed: () {
                                setState(() {
                                  ShowCaseWidget.of(context)
                                      .startShowCase([widget.keySix!]);
                                });
                              },
                              child: SizedBox(
                                width: 50,
                                height: 40,
                                child: Center(
                                  child: Text(
                                      maxLines: 1,
                                      MultiLanguages.of(context)!
                                          .translate('btn_next_guide'),
                                      style: const TextStyle(fontSize: 16)),
                                ),
                              )),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()));
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              scrollLoadingWidget: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.transparent)),
              key: widget.keyFive!,
              disposeOnTap: true,
              onTargetClick: () {
                setState(() {
                  ShowCaseWidget.of(context).startShowCase([widget.keySix!]);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 0, left: 2, right: 2),
                child: HomeFavorite(),
                // child: HomeFavorite(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.ChangeLanguage.translate('header_title'),
                    style: TextStyle(
                        fontFamily: 'notoreg',
                        color: theme_color_df,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 6, right: 6),
              child: HomeProductHotItem(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6, right: 6),
              child: Home_loadmore(width: width),
            ),
            Center(
                child: Lottie.asset(
              'assets/images/loading.json',
              width: 80,
              height: 80,
            )),
          ],
        ),
      ),
    );
  }
}
