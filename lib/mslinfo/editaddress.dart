import 'package:fridayonline/homepage/theme/theme_color.dart';

import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/mslinfo/editaddressdetail.dart';
import 'package:flutter/material.dart';

import '../service/languages/multi_languages.dart';

final titles = ["me_change_address1", "me_change_address2"];

// แก้ไขเพิ่มเติม
class EditAddress extends StatelessWidget {
  const EditAddress({super.key});

  get children => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitleMaster(
            MultiLanguages.of(context)!.translate('me_shipping_address')),
        body: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                // settextheader('แก้ไขที่อยู่จัดส่งสินค้า'),
                ListView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // <-- this will disable scroll
                    shrinkWrap: true,
                    itemCount: titles.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 80,
                            child: Center(
                                child: GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              editaddressdetail("1")));
                                } else if (index == 1) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              editaddressdetail("2")));
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 300,
                                height: 55,
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: theme_color_df),
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: theme_color_df),
                                child: Text(
                                  MultiLanguages.of(context)!
                                      .translate(titles[index]),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            )),
                          ),
                        ],
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
