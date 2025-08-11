// ignore_for_file: non_constant_identifier_names, camel_case_types, must_be_immutable, use_key_in_widget_constructors

import 'package:fridayonline/controller/category/category_controller.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
// import 'package:fridayonline/homepage/page_showproduct/List_product.dart';
import 'package:fridayonline/homepage/widget/appbar_cart.dart';
import 'package:fridayonline/homepage/widget/cartbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../service/languages/multi_languages.dart';
import '../../page_showproduct/List_product.dart';
import '../../widget/appbar_relode.dart';

class MylistCategory extends StatelessWidget {
  var mChannel = Get.parameters['mChannel'] ?? "";
  var mChannelId = Get.parameters['mChannelId'] ?? "";
  var mTypeBack = Get.parameters['mTypeBack'] ?? "";
  var mTypeGroup = Get.parameters['mTypeGroup'] ?? "";
  var ref = Get.parameters['ref'] ?? "";
  var contentId = Get.parameters['contentId'] ?? "";

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: mTypeBack == 'noti'
            ? AppBarRelodeMaster(
                MultiLanguages.of(context)!
                    .translate('home_page_list_products'),
                '/backAppbarnotify')
            : AppBar(
                leading: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // iconTheme: const IconThemeData(
                //   color: Colors.white, //change your color here
                // ),
                centerTitle: true,
                backgroundColor: theme_color_df,
                title: Text(
                  MultiLanguages.of(context)!
                      .translate('home_page_list_products'),
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
        //     MultiLanguages.of(context)!
        //         .translate('home_page_list_products'),
        //     "home"),
        body: GetX<CategoryProductlistController>(
            builder: (dataController) => dataController.isDataLoading.value
                ? const Center(child: CircularProgressIndicator())
                : mTypeGroup == "category"
                    ? showList(
                        dataController.BannerProduct!.skucode,
                        mChannel,
                        mChannelId,
                        ref: ref,
                        contentId: contentId,
                      )
                    : showList(
                        dataController.listproduct!.skucode,
                        mChannel,
                        mChannelId,
                        ref: ref,
                        contentId: contentId,
                      )),
      ),
    ); //Obx
  }
}

class ShowCaseMylistCategory extends StatefulWidget {
  ShowCaseMylistCategory({super.key, required this.ChangeLanguage});
  MultiLanguages ChangeLanguage;

  @override
  State<ShowCaseMylistCategory> createState() => _ShowCaseMylistCategoryState();
}

class _ShowCaseMylistCategoryState extends State<ShowCaseMylistCategory> {
  var mChannel = Get.parameters['mChannel'] ?? "";

  var mChannelId = Get.parameters['mChannelId'] ?? "";

  var mTypeBack = Get.parameters['mTypeBack'] ?? "";

  var mTypeGroup = Get.parameters['mTypeGroup'] ?? "";

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase([_one, _two]),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("+++++++=+");
    print(mChannel);
    print(mChannelId);
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: mTypeBack == 'noti'
            ? AppBarRelodeMaster(
                widget.ChangeLanguage.translate('home_page_list_products'),
                '/backAppbarnotify')
            : appBarTitleCart(
                widget.ChangeLanguage.translate('home_page_list_products'),
                "home"),
        body: GetX<CategoryProductlistController>(
            builder: (dataController) => dataController.isDataLoading.value
                ? const Center(child: CircularProgressIndicator())
                : mTypeGroup == "category"
                    ? showCaseShowList(
                        context,
                        dataController.BannerProduct!.skucode,
                        '',
                        '',
                        widget.ChangeLanguage,
                        _one,
                        _two)
                    : showCaseShowList(
                        context,
                        dataController.listproduct!.skucode,
                        '',
                        '',
                        widget.ChangeLanguage,
                        _one,
                        _two)),
      ),
    ); //Obx
  }
}
