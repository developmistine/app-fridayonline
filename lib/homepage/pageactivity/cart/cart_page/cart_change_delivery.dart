// ignore_for_file: prefer_const_constructors, no_logic_in_create_state

import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/cart/delivery_controller.dart';
import '../../../../service/languages/multi_languages.dart';
import '../../../webview/webview_app.dart';

class ChangeDelivery extends StatefulWidget {
  const ChangeDelivery(this.dataDelivery, this.totalAmount, {super.key});
  final FetchDeliveryChange dataDelivery;
  final double totalAmount;
  @override
  State<ChangeDelivery> createState() =>
      _ChangeDeliveryState(dataDelivery, totalAmount);
}

class _ChangeDeliveryState extends State<ChangeDelivery> {
  _ChangeDeliveryState(this.dataDelivery, this.totalAmount);
  FetchDeliveryChange dataDelivery;
  double totalAmount;
  // int index = 0;
  var url = '${baseurl_web_view}view_shipping?language=';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleMaster(
        MultiLanguages.of(context)!.translate('shipping_details'),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: SizedBox(
          child: GetX<FetchDeliveryChange>(builder: (itemsDelivery) {
            return itemsDelivery.isDataLoading.value
                ? Center(child: theme_loading_df)
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    child: Center(
                      child: Column(
                        children: [
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            itemCount:
                                itemsDelivery.isChange!.detailDelivery!.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () async {
                                  await Get.find<FetchDeliveryChange>()
                                      .change(dataDelivery.indexChange.value);
                                  setState(() {
                                    dataDelivery.indexChange.value = i;
                                  });
                                },
                                child: Card(
                                  surfaceTintColor: Colors.white,
                                  shadowColor: theme_grey_text,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: theme_color_df)),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: dataDelivery.indexChange.value ==
                                              i
                                          ? Icon(
                                              Icons.check_box,
                                              color: theme_color_df,
                                            )
                                          : Icon(Icons.check_box_outline_blank,
                                              color: theme_color_df),
                                      title: Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        children: [
                                          Text(itemsDelivery
                                              .isChange!
                                              .detailDelivery![i]
                                              .titleDelivery),
                                          Text(
                                              "${itemsDelivery.isChange!.detailDelivery![i].price} ${MultiLanguages.of(context)!.translate('order_baht')}")
                                        ],
                                      ),
                                      subtitle: Text(
                                        itemsDelivery.isChange!
                                            .detailDelivery![i].desDelivery,
                                        style: TextStyle(height: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: theme_color_df,
                                  elevation: 0,
                                  fixedSize: Size(
                                    200,
                                    50,
                                  ),
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: theme_color_df)),
                              onPressed: () async {
                                SetData data = SetData();
                                var language = await data.language;
                                Get.to(
                                    transition: Transition.rightToLeft,
                                    () => webview_app(
                                          mparamurl: url + language,
                                          mparamTitleName: MultiLanguages.of(
                                                  context)!
                                              .translate('delivery_codition'),
                                          mparamType: '',
                                          mparamValue: '',
                                        ));
                              },
                              child: Text(MultiLanguages.of(context)!
                                  .translate('delivery_codition')))
                        ],
                      ),
                    ),
                  );
          }),
        ),
      ),
      bottomNavigationBar: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: InkWell(
          onTap: () async {
            await Get.find<FetchDeliveryChange>()
                .change(dataDelivery.indexChange.value);

            Get.back();
          },
          child: Container(
            height: 60,
            color: theme_color_df,
            child: Center(
                child: Text(
                    MultiLanguages.of(context)!.translate('alert_confirm'),
                    style: TextStyle(color: Colors.white, fontSize: 16))),
          ),
        ),
      ),
    );
  }
}
