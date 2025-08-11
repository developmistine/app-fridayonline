// import 'dart:convert';

import 'package:fridayonline/controller/cart/cart_address_enduser_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/formatter_text.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';

import 'package:fridayonline/model/cart/enduser/enduser_address.dart';
import 'package:fridayonline/service/cart/enduser/enduser_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/cart/enduser/enduser_add_data.dart';
import 'cart_enduser_add_address.dart';

class EndUserChangeAddress extends StatefulWidget {
  const EndUserChangeAddress({super.key});

  @override
  State<EndUserChangeAddress> createState() => _EndUserChangeAddressState();
}

final ScrollController controller = ScrollController();

class _EndUserChangeAddressState extends State<EndUserChangeAddress> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: WillPopScope(
        onWillPop: () async {
          Get.find<FetchCartEndUsersAddress>().fetchEnduserAddress();
          Get.until((route) => Get.currentRoute == '/CartOrderSummary');
          return true;
        },
        child: Scaffold(
            // appBar: appBarTitleMaster('ที่อยู่จัดส่ง'),
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: AppBar(
                  leading: BackButton(
                      color: Colors.white,
                      onPressed: () {
                        Get.find<FetchCartEndUsersAddress>()
                            .fetchEnduserAddress();
                        Get.until(
                            (route) => Get.currentRoute == '/CartOrderSummary');
                      }),
                  iconTheme: const IconThemeData(
                    color: Colors.white, //change your color here
                  ),
                  centerTitle: true,
                  backgroundColor: theme_color_df,
                  title: const Text(
                    "ที่อยู่จัดส่ง",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'notoreg',
                        fontWeight: FontWeight.bold),
                  ),
                )),
            body: GetX<FetchCartEndUsersAddress>(builder: (address) {
              return address.isDataLoading.value
                  ? Center(
                      child: theme_loading_df,
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      controller: controller,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16),
                        child: Column(
                          children: [
                            // ? main address
                            if (address.addressEndUser!.primaryAddress.id != "")
                              InkWell(
                                onTap: () {
                                  Get.until((route) =>
                                      Get.currentRoute == '/CartOrderSummary');
                                },
                                child: Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  address.addressEndUser!
                                                      .primaryAddress.name,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${address.addressEndUser!.primaryAddress.address1} ${address.addressEndUser!.primaryAddress.address2} ${address.addressEndUser!.primaryAddress.tumbonName} ${address.addressEndUser!.primaryAddress.amphurName} ${address.addressEndUser!.primaryAddress.provinceName} ${address.addressEndUser!.primaryAddress.postalcode}',
                                                  style: TextStyle(
                                                      color: theme_grey_text),
                                                ),
                                                if (address.addressEndUser!
                                                        .primaryAddress.note !=
                                                    "")
                                                  Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'รายละเอียด',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                          address
                                                              .addressEndUser!
                                                              .primaryAddress
                                                              .note,
                                                          style: TextStyle(
                                                              color:
                                                                  theme_grey_text),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                Row(
                                                  children: [
                                                    const Expanded(
                                                      child: Text(
                                                        'เบอร์โทร',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        formatPhoneNumber(
                                                            address
                                                                .addressEndUser!
                                                                .primaryAddress
                                                                .telnumber),
                                                        style: TextStyle(
                                                            color:
                                                                theme_grey_text),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 65,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 2),
                                                      decoration: BoxDecoration(
                                                          color: theme_color_df,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                            color:
                                                                theme_color_df,
                                                            width: 1,
                                                          )),
                                                      child: const Text(
                                                        'ที่อยู่หลัก',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    if (address
                                                            .addressEndUser!
                                                            .primaryAddress
                                                            .type !=
                                                        "0")
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                    if (address
                                                            .addressEndUser!
                                                            .primaryAddress
                                                            .type !=
                                                        "0")
                                                      Container(
                                                        width: 60,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8,
                                                                vertical: 2),
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                border:
                                                                    Border.all(
                                                                  color:
                                                                      theme_color_df,
                                                                  width: 1,
                                                                )),
                                                        child: Text(
                                                          address
                                                                      .addressEndUser!
                                                                      .primaryAddress
                                                                      .type ==
                                                                  "1"
                                                              ? 'บ้าน'
                                                              : 'ที่ทำงาน',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color:
                                                                theme_color_df,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    AryAddress json;
                                                    json = AryAddress(
                                                      id: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .id,
                                                      enduserId: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .enduserId,
                                                      name: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .name,
                                                      telnumber: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .telnumber,
                                                      type: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .type,
                                                      address1: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .address1,
                                                      address2: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .address2,
                                                      provinceId: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .provinceId,
                                                      amphurId: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .amphurId,
                                                      tumbonId: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .tumbonId,
                                                      provinceName: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .provinceName,
                                                      amphurName: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .amphurName,
                                                      tumbonName: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .tumbonName,
                                                      postalcode: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .postalcode,
                                                      note: address
                                                          .addressEndUser!
                                                          .primaryAddress
                                                          .note,
                                                    );

                                                    Get.to(
                                                        () =>
                                                            const EndUserAddAddress(),
                                                        arguments: [
                                                          "ที่อยู่จัดส่งสินค้า",
                                                          json,
                                                          "Edit",
                                                          "main",
                                                        ]);
                                                  },
                                                  child: Text(
                                                    'แก้ไข',
                                                    style: TextStyle(
                                                        color: theme_color_df),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            // ? second address
                            ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: address
                                  .addressEndUser!.secondaryAddress.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    var json = EndUserAddressData(
                                      address1: address.addressEndUser!
                                          .secondaryAddress[index].address1,
                                      id: address.addressEndUser!
                                          .secondaryAddress[index].id,
                                      enduserId: address.addressEndUser!
                                          .secondaryAddress[index].enduserId,
                                      name: address.addressEndUser!
                                          .secondaryAddress[index].name,
                                      telnumber: address.addressEndUser!
                                          .secondaryAddress[index].telnumber,
                                      type: address.addressEndUser!
                                          .secondaryAddress[index].type,
                                      address2: "",
                                      provinceName: address.addressEndUser!
                                          .secondaryAddress[index].provinceName,
                                      amphurName: address.addressEndUser!
                                          .secondaryAddress[index].amphurName,
                                      tumbonName: address.addressEndUser!
                                          .secondaryAddress[index].tumbonName,
                                      postalcode: address.addressEndUser!
                                          .secondaryAddress[index].postalcode,
                                      note: address.addressEndUser!
                                          .secondaryAddress[index].note,
                                      status: "1",
                                      provinceCode: address.addressEndUser!
                                          .secondaryAddress[index].provinceId,
                                      channel: 'app',
                                      amphurCode: address.addressEndUser!
                                          .secondaryAddress[index].amphurId,
                                      tumbonCode: address.addressEndUser!
                                          .secondaryAddress[index].tumbonId,
                                    );
                                    await manageEnduserAddress(json);
                                    Get.find<FetchCartEndUsersAddress>()
                                        .fetchEnduserAddress();
                                    Get.until((route) =>
                                        Get.currentRoute ==
                                        '/CartOrderSummary');
                                  },
                                  child: Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 6,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    address
                                                        .addressEndUser!
                                                        .secondaryAddress[index]
                                                        .name,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${address.addressEndUser!.secondaryAddress[index].address1} ${address.addressEndUser!.secondaryAddress[index].address2} ${address.addressEndUser!.secondaryAddress[index].tumbonName} ${address.addressEndUser!.secondaryAddress[index].amphurName} ${address.addressEndUser!.secondaryAddress[index].provinceName} ${address.addressEndUser!.secondaryAddress[index].postalcode}',
                                                    style: TextStyle(
                                                        color: theme_grey_text),
                                                  ),
                                                  if (address
                                                          .addressEndUser!
                                                          .secondaryAddress[
                                                              index]
                                                          .note !=
                                                      "")
                                                    Row(
                                                      children: [
                                                        const Expanded(
                                                          child: Text(
                                                            'รายละเอียด',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            address
                                                                .addressEndUser!
                                                                .secondaryAddress[
                                                                    index]
                                                                .note,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color:
                                                                    theme_grey_text),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'เบอร์โทร',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                          formatPhoneNumber(address
                                                              .addressEndUser!
                                                              .secondaryAddress[
                                                                  index]
                                                              .telnumber),
                                                          style: TextStyle(
                                                              color:
                                                                  theme_grey_text),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      if (address
                                                              .addressEndUser!
                                                              .primaryAddress
                                                              .type !=
                                                          "0")
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                      if (address
                                                              .addressEndUser!
                                                              .secondaryAddress[
                                                                  index]
                                                              .type !=
                                                          "0")
                                                        Container(
                                                          width: 60,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 2),
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  border: Border
                                                                      .all(
                                                                    color:
                                                                        theme_color_df,
                                                                    width: 1,
                                                                  )),
                                                          child: Text(
                                                            address
                                                                        .addressEndUser!
                                                                        .secondaryAddress[
                                                                            index]
                                                                        .type ==
                                                                    "1"
                                                                ? 'บ้าน'
                                                                : 'ที่ทำงาน',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color:
                                                                  theme_color_df,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      AryAddress json;
                                                      json = AryAddress(
                                                        id: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .id,
                                                        enduserId: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .enduserId,
                                                        name: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .name,
                                                        telnumber: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .telnumber,
                                                        type: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .type,
                                                        address1: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .address1,
                                                        address2: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .address2,
                                                        provinceId: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .provinceId,
                                                        amphurId: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .amphurId,
                                                        tumbonId: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .tumbonId,
                                                        provinceName: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .provinceName,
                                                        amphurName: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .amphurName,
                                                        tumbonName: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .tumbonName,
                                                        postalcode: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .postalcode,
                                                        note: address
                                                            .addressEndUser!
                                                            .secondaryAddress[
                                                                index]
                                                            .note,
                                                      );

                                                      Get.to(
                                                          () =>
                                                              const EndUserAddAddress(),
                                                          arguments: [
                                                            "ที่อยู่จัดส่งสินค้า",
                                                            json,
                                                            "Edit",
                                                            "",
                                                          ]);
                                                    },
                                                    child: Text(
                                                      'แก้ไข',
                                                      style: TextStyle(
                                                          color:
                                                              theme_color_df),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                );
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              width: Get.width,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  side: BorderSide(
                                      color: theme_color_df, width: 2),
                                ),
                                onPressed: () {
                                  Get.to(() => const EndUserAddAddress(),
                                      arguments: [
                                        "ที่อยู่จัดส่งสินค้า",
                                        "",
                                        "Add"
                                      ]);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: theme_color_df,
                                      size: 28,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'เพิ่มที่อยู่ใหม่',
                                      style: TextStyle(
                                          color: theme_color_df,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
            })),
      ),
    );
  }
}
