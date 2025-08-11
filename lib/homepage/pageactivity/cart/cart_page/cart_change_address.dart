// ignore_for_file: must_be_immutable

import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/cart/dropship_controller.dart';
import '../../../../service/cart/dropship/dropship_address_service.dart';
import '../../../theme/theme_color.dart';
import 'cart_edit_address.dart';

class EditAddress extends StatelessWidget {
  EditAddress({super.key, required this.page});
  String page;
  @override
  Widget build(BuildContext context) {
    // String? routeName = ModalRoute.of(context)?.settings.name;

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              leading: BackButton(
                color: Colors.white,
                onPressed: () {
                  switch (page) {
                    case "page1":
                      {
                        Get.until((route) => (Get.currentRoute == '/Cart' ||
                            Get.currentRoute == '/cart_activity' ||
                            Get.currentRoute == '/show_case_cart_activity'));
                        break;
                      }
                    case "page2":
                      {
                        Get.until(
                            (route) => Get.currentRoute == '/CartOrderSummary');
                        break;
                      }
                    case "pageshowcase":
                      {
                        Get.until((route) =>
                            Get.currentRoute == '/show_case_cart_activity');
                        break;
                      }
                    default:
                      {
                        break;
                      }
                  }
                },
              ),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              centerTitle: true,
              backgroundColor: theme_color_df,
              title: const Text(
                "ที่อยู่จัดส่ง Friday ส่งด่วน",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'notoreg',
                    fontWeight: FontWeight.bold),
              ),
            )),
        body: GetBuilder<FetchAddressDropshipController>(builder: (snapshot) {
          if (!snapshot.isDataLoading.value) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.itemDropship!.address.length,
                    itemBuilder: (context, index) {
                      return snapshot
                                  .itemDropship!.address[index].addressType ==
                              '1'
                          ? Container(
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  highlightColor:
                                      theme_color_df.withOpacity(0.8),
                                  onTap: () async {
                                    await setMainAddressDropship(
                                      snapshot.itemDropship!.address[index]
                                          .addressId,
                                    );
                                    await Get.put(
                                            FetchAddressDropshipController())
                                        .fetchDropshipAddress();
                                    switch (page) {
                                      case "page1":
                                        {
                                          Get.until((route) => (Get
                                                      .currentRoute ==
                                                  '/Cart' ||
                                              Get.currentRoute ==
                                                  '/cart_activity' ||
                                              Get.currentRoute ==
                                                  '/show_case_cart_activity'));
                                          break;
                                        }
                                      case "page2":
                                        {
                                          Get.until((route) =>
                                              Get.currentRoute ==
                                                  '/CartOrderSummary' ||
                                              Get.currentRoute ==
                                                  '/cart_activity');
                                          break;
                                        }
                                      case "pageshowcase":
                                        {
                                          Get.until((route) =>
                                              Get.currentRoute == '/Cart' ||
                                              Get.currentRoute ==
                                                  '/cart_activity');
                                          break;
                                        }
                                      default:
                                        {
                                          break;
                                        }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.location_pin,
                                              color: theme_red,
                                            ),
                                            Expanded(
                                              child: Text(
                                                snapshot.itemDropship!
                                                    .address[index].nameReceive,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.to(
                                                  () =>
                                                      const DropshipEditAddress(),
                                                  arguments: [
                                                    "แก้ไขที่อยู่จัดส่งสินค้า",
                                                    snapshot.itemDropship!
                                                        .address[index],
                                                    "Edit"
                                                  ],
                                                );
                                              },
                                              child: Text(
                                                "แก้ไข",
                                                style: TextStyle(
                                                  color: theme_color_df,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Stack(
                                          children: [
                                            Text(
                                              '                      ${snapshot.itemDropship!.address[index].addressLine1} ${snapshot.itemDropship!.address[index].nameTumbon} ${snapshot.itemDropship!.address[index].nameAmphur} ${snapshot.itemDropship!.address[index].nameProvince} ${snapshot.itemDropship!.address[index].postCode}',
                                              style:
                                                  const TextStyle(height: 1.8),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              theme_color_df),
                                                  onPressed: () {},
                                                  child: const Text(
                                                    "ที่อยู่หลัก",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )),
                                            )
                                          ],
                                        ),
                                        RichText(
                                            text: TextSpan(
                                                text: "เบอร์โทร : ",
                                                style: TextStyle(
                                                    fontFamily: 'notoreg',
                                                    fontWeight: FontWeight.bold,
                                                    color: theme_grey_text),
                                                children: [
                                              TextSpan(
                                                  text:
                                                      "(+66) ${snapshot.itemDropship!.address[index].mobileNo}",
                                                  style: const TextStyle(
                                                      fontFamily: 'notoreg',
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ]))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  highlightColor:
                                      theme_color_df.withOpacity(0.8),
                                  onTap: () async {
                                    await setMainAddressDropship(
                                      snapshot.itemDropship!.address[index]
                                          .addressId,
                                    );
                                    await Get.put(
                                            FetchAddressDropshipController())
                                        .fetchDropshipAddress();
                                    switch (page) {
                                      case "page1":
                                        {
                                          Get.until((route) => (Get
                                                      .currentRoute ==
                                                  '/Cart' ||
                                              Get.currentRoute ==
                                                  '/cart_activity' ||
                                              Get.currentRoute ==
                                                  '/show_case_cart_activity'));
                                          break;
                                        }
                                      case "page2":
                                        {
                                          Get.until((route) =>
                                              Get.currentRoute ==
                                              '/CartOrderSummary');
                                          break;
                                        }
                                      case "pageshowcase":
                                        {
                                          Get.until((route) =>
                                              Get.currentRoute == '/Cart' ||
                                              Get.currentRoute ==
                                                  '/cart_activity');
                                          break;
                                        }
                                      default:
                                        {
                                          break;
                                        }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.location_pin,
                                              color: theme_red,
                                            ),
                                            Expanded(
                                              child: Text(
                                                snapshot.itemDropship!
                                                    .address[index].nameReceive,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.to(
                                                  () =>
                                                      const DropshipEditAddress(),
                                                  arguments: [
                                                    "แก้ไขที่อยู่จัดส่งสินค้า",
                                                    snapshot.itemDropship!
                                                        .address[index],
                                                    "Edit"
                                                  ],
                                                );
                                              },
                                              child: Text(
                                                "แก้ไข",
                                                style: TextStyle(
                                                  color: theme_color_df,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Text(
                                          '${snapshot.itemDropship!.address[index].addressLine1} ${snapshot.itemDropship!.address[index].nameTumbon} ${snapshot.itemDropship!.address[index].nameAmphur} ${snapshot.itemDropship!.address[index].nameProvince} ${snapshot.itemDropship!.address[index].postCode}',
                                          style: const TextStyle(height: 1.8),
                                        ),
                                        RichText(
                                            text: TextSpan(
                                                text: "เบอร์โทร : ",
                                                style: TextStyle(
                                                    fontFamily: 'notoreg',
                                                    fontWeight: FontWeight.bold,
                                                    color: theme_grey_text),
                                                children: [
                                              TextSpan(
                                                  text:
                                                      "(+66) ${snapshot.itemDropship!.address[index].mobileNo}",
                                                  style: const TextStyle(
                                                      fontFamily: 'notoreg',
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ]))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                  //? ปุ่มเพิ่มที่อยู่ใหม่
                  buttonAddaddress()
                ],
              ),
            );
          } else {
            return Center(
              child: theme_loading_df,
            );
          }
        }),
      ),
    );
  }

  buttonAddaddress() {
    return Container(
      margin: const EdgeInsets.all(12),
      child: DottedBorder(
        padding: EdgeInsets.zero,
        borderType: BorderType.RRect,
        radius: const Radius.circular(20),
        color: theme_color_df,
        dashPattern: const [8, 8],
        strokeWidth: 2,
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              side: const BorderSide(
                style: BorderStyle.none,
              ),
            ),
            onPressed: () {
              Get.to(
                () => const DropshipEditAddress(),
                arguments: ["เพิ่มที่อยู่จัดส่งสินค้า", "Add"],
              );
            },
            child: const Text(
              'เพิ่มที่อยู่ใหม่',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
