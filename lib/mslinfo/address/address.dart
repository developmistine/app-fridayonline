// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:fridayonline/controller/address/address_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/mslinfo/address/edit_address.dart';
import 'package:fridayonline/mslinfo/address/new_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressNew extends StatelessWidget {
  const AddressNew({super.key});
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: appBarTitleMaster('ที่อยู่จัดส่ง'),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GetBuilder<AddressController>(builder: (data) {
              if (data.isDataLoading.value) {
                return Center(
                  child: theme_loading_df,
                );
              } else {
                return ListView(
                  children: [
                    if (data.addressList1!.data.isNotEmpty)
                      for (var i = 0; i < 1; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'ที่อยู่ตั้งต้น',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          'ข้อมูลที่อยู่ ที่สมัครสมาชิกไว้ไม่สามารถแก้ไขได้',
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.red),
                                        ),
                                        Text(
                                          data.addressList1!.data[i]
                                                      .deliverContact ==
                                                  ""
                                              ? data.repName!
                                              : data.addressList1!.data[i]
                                                  .deliverContact,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${data.addressList1!.data[i].addrline1} ${data.addressList1!.data[i].addrline2} ${data.addressList1!.data[i].addrline3} ${data.addressList1!.data[i].tumbonName} ${data.addressList1!.data[i].amphurName} ${data.addressList1!.data[i].provinceName} ${data.addressList1!.data[i].postalCode}',
                                          style:
                                              TextStyle(color: theme_grey_text),
                                        ),
                                        if (data.addressList1!.data[i]
                                                .deliveryNote !=
                                            "")
                                          Row(
                                            children: [
                                              const Expanded(
                                                child: Text(
                                                  'รายละเอียด',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  data.addressList1!.data[i]
                                                      .deliveryNote,
                                                  style: TextStyle(
                                                      color: theme_grey_text),
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
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                data.addressList1!.data[i]
                                                    .mobileNo
                                                    .replaceAllMapped(
                                                        RegExp(
                                                            r'(\d{3})(\d{3})(\d+)'),
                                                        (Match m) =>
                                                            "${m[1]}-${m[2]}-${m[3]}"),
                                                style: TextStyle(
                                                    color: theme_grey_text),
                                              ),
                                            )
                                          ],
                                        ),
                                        if (data.addressList1!.data[i]
                                                .defaultFlag ==
                                            "1")
                                          Container(
                                            width: 65,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                                color: theme_color_df,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: theme_color_df,
                                                  width: 1,
                                                )),
                                            child: const Text(
                                              'ที่อยู่หลัก',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        'ที่อยู่เพิ่มเติม',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (data.addressList3!.data.length >=
                        data.addressShow!.showList)
                      for (var i = 0; i < data.addressShow!.showList; i++)
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.addressList3!.data[i]
                                                        .deliverContact ==
                                                    ""
                                                ? data.repName!
                                                : data.addressList3!.data[i]
                                                    .deliverContact,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${data.addressList3!.data[i].addrline1} ${data.addressList3!.data[i].addrline2} ${data.addressList3!.data[i].addrline3} ${data.addressList3!.data[i].tumbonName} ${data.addressList3!.data[i].amphurName} ${data.addressList3!.data[i].provinceName} ${data.addressList3!.data[i].postalCode}',
                                            style: TextStyle(
                                                color: theme_grey_text),
                                          ),
                                          if (data.addressList3!.data[i]
                                                  .deliveryNote !=
                                              "")
                                            Row(
                                              children: [
                                                const Expanded(
                                                  child: Text(
                                                    'รายละเอียด',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    data.addressList3!.data[i]
                                                        .deliveryNote,
                                                    style: TextStyle(
                                                        color: theme_grey_text),
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
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  data.addressList3!.data[i]
                                                      .mobileNo
                                                      .replaceAllMapped(
                                                          RegExp(
                                                              r'(\d{3})(\d{3})(\d+)'),
                                                          (Match m) =>
                                                              "${m[1]}-${m[2]}-${m[3]}"),
                                                  style: TextStyle(
                                                      color: theme_grey_text),
                                                ),
                                              )
                                            ],
                                          ),
                                          if (data.addressList3!.data[i]
                                                  .defaultFlag ==
                                              "1")
                                            Container(
                                              width: 65,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                  color: theme_color_df,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: theme_color_df,
                                                    width: 1,
                                                  )),
                                              child: const Text(
                                                'ที่อยู่หลัก',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditAddress(
                                                    addressId: data
                                                        .addressList3!
                                                        .data[i]
                                                        .msladdrId,
                                                    addressType: data
                                                        .addressList3!
                                                        .data[i]
                                                        .addrtype,
                                                    addressLine: data
                                                        .addressList3!
                                                        .data[i]
                                                        .addrline1,
                                                    mobileNo: data.addressList3!
                                                        .data[i].mobileNo,
                                                    contactName: data
                                                        .addressList3!
                                                        .data[i]
                                                        .deliverContact,
                                                    note: data.addressList3!
                                                        .data[i].deliveryNote,
                                                    defaultFlag: data
                                                        .addressList3!
                                                        .data[i]
                                                        .defaultFlag,
                                                    tumbonName: data
                                                        .addressList3!
                                                        .data[i]
                                                        .tumbonName,
                                                    tumbonCode: data
                                                        .addressList3!
                                                        .data[i]
                                                        .tumbonCode,
                                                    amphurName: data
                                                        .addressList3!
                                                        .data[i]
                                                        .amphurName,
                                                    amphurCode: data
                                                        .addressList3!
                                                        .data[i]
                                                        .amphurCode,
                                                    provinceName: data
                                                        .addressList3!
                                                        .data[i]
                                                        .provinceName,
                                                    provinceCode: data
                                                        .addressList3!
                                                        .data[i]
                                                        .provinceCode,
                                                    postalCode: data
                                                        .addressList3!
                                                        .data[i]
                                                        .postalCode,
                                                  ),
                                                ),
                                              );
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
                              ),
                            )

                            // Container(
                            //   alignment: Alignment.center,
                            //   decoration: BoxDecoration(
                            //     boxShadow: [
                            //       BoxShadow(
                            //         color: Colors.grey.withOpacity(0.1),
                            //         spreadRadius: 5,
                            //         blurRadius: 7,
                            //         offset: const Offset(0, 3),
                            //       ),
                            //     ],
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(10),
                            //   ),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(16),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Padding(
                            //           padding: const EdgeInsets.only(bottom: 4),
                            //           child: Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             children: [
                            //               Text(
                            //                 data.addressList3!.data[i]
                            //                             .deliverContact ==
                            //                         ""
                            //                     ? data.repName!
                            //                     : data.addressList3!.data[i]
                            //                         .deliverContact,
                            //                 style: const TextStyle(
                            //                     fontSize: 14,
                            //                     fontWeight: FontWeight.bold),
                            //               ),
                            //               GestureDetector(
                            //                 onTap: () {
                            //                   Navigator.push(
                            //                     context,
                            //                     MaterialPageRoute(
                            //                       builder: (context) =>
                            //                           EditAddress(
                            //                         addressId: data.addressList3!
                            //                             .data[i].msladdrId,
                            //                         addressType: data
                            //                             .addressList3!
                            //                             .data[i]
                            //                             .addrtype,
                            //                         addressLine: data
                            //                             .addressList3!
                            //                             .data[i]
                            //                             .addrline1,
                            //                         mobileNo: data.addressList3!
                            //                             .data[i].mobileNo,
                            //                         contactName: data
                            //                             .addressList3!
                            //                             .data[i]
                            //                             .deliverContact,
                            //                         note: data.addressList3!
                            //                             .data[i].deliveryNote,
                            //                         defaultFlag: data
                            //                             .addressList3!
                            //                             .data[i]
                            //                             .defaultFlag,
                            //                         tumbonName: data.addressList3!
                            //                             .data[i].tumbonName,
                            //                         tumbonCode: data.addressList3!
                            //                             .data[i].tumbonCode,
                            //                         amphurName: data.addressList3!
                            //                             .data[i].amphurName,
                            //                         amphurCode: data.addressList3!
                            //                             .data[i].amphurCode,
                            //                         provinceName: data
                            //                             .addressList3!
                            //                             .data[i]
                            //                             .provinceName,
                            //                         provinceCode: data
                            //                             .addressList3!
                            //                             .data[i]
                            //                             .provinceCode,
                            //                         postalCode: data.addressList3!
                            //                             .data[i].postalCode,
                            //                       ),
                            //                     ),
                            //                   );
                            //                 },
                            //                 child: const Text(
                            //                   'แก้ไข',
                            //                   style: TextStyle(
                            //                     fontSize: 14,
                            //                     color: Color(0XFF2EA9E1),
                            //                     fontWeight: FontWeight.bold,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         Text(
                            //           '${data.addressList3!.data[i].addrline1} ${data.addressList3!.data[i].addrline2} ${data.addressList3!.data[i].addrline3} \n${data.addressList3!.data[i].tumbonName} ${data.addressList3!.data[i].amphurName} ${data.addressList3!.data[i].provinceName} ${data.addressList3!.data[i].postalCode}',
                            //           style: const TextStyle(
                            //             color: Colors.grey,
                            //             fontSize: 13,
                            //           ),
                            //         ),
                            //         if (data.addressList3!.data[i].deliveryNote !=
                            //             "")
                            //           Text(
                            //             'Note : ${data.addressList3!.data[i].deliveryNote}',
                            //             style: const TextStyle(
                            //               color: Colors.grey,
                            //               fontSize: 13,
                            //             ),
                            //           ),
                            //         Padding(
                            //           padding: const EdgeInsets.only(top: 4),
                            //           child: Row(
                            //             children: [
                            //               const Text(
                            //                 'เบอร์โทร',
                            //                 style: TextStyle(
                            //                   fontSize: 14,
                            //                   fontWeight: FontWeight.bold,
                            //                 ),
                            //               ),
                            //               const SizedBox(
                            //                 width: 20,
                            //               ),
                            //               Text(
                            //                 data.addressList3!.data[i].mobileNo
                            //                     .replaceAllMapped(
                            //                         RegExp(
                            //                             r'(\d{3})(\d{3})(\d+)'),
                            //                         (Match m) =>
                            //                             "${m[1]}-${m[2]}-${m[3]}"),
                            //                 style: const TextStyle(
                            //                   fontSize: 14,
                            //                   color: Colors.grey,
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         if (data.addressList3!.data[i].defaultFlag ==
                            //             "1")
                            //           Padding(
                            //             padding: const EdgeInsets.only(top: 8.0),
                            //             child: SizedBox(
                            //               height: 30,
                            //               child: ElevatedButton(
                            //                   style: ButtonStyle(
                            //                       foregroundColor:
                            //                           MaterialStateProperty.all<Color>(
                            //                               Colors.white),
                            //                       backgroundColor:
                            //                           MaterialStateProperty.all<
                            //                               Color>(theme_color_df),
                            //                       shape: MaterialStateProperty.all<
                            //                               RoundedRectangleBorder>(
                            //                           RoundedRectangleBorder(
                            //                               borderRadius:
                            //                                   BorderRadius.circular(50),
                            //                               side: BorderSide(color: theme_color_df)))),
                            //                   onPressed: () async {},
                            //                   child: const Text('ที่อยู่หลัก', style: TextStyle(fontSize: 12))),
                            //             ),
                            //           ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            )
                    else
                      for (var i = 0; i < data.addressList3!.data.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.addressList3!.data[i]
                                                      .deliverContact ==
                                                  ""
                                              ? data.repName!
                                              : data.addressList3!.data[i]
                                                  .deliverContact,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${data.addressList3!.data[i].addrline1} ${data.addressList3!.data[i].addrline2} ${data.addressList3!.data[i].addrline3} ${data.addressList3!.data[i].tumbonName} ${data.addressList3!.data[i].amphurName} ${data.addressList3!.data[i].provinceName} ${data.addressList3!.data[i].postalCode}',
                                          style:
                                              TextStyle(color: theme_grey_text),
                                        ),
                                        if (data.addressList3!.data[i]
                                                .deliveryNote !=
                                            "")
                                          Row(
                                            children: [
                                              const Expanded(
                                                child: Text(
                                                  'รายละเอียด',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  data.addressList3!.data[i]
                                                      .deliveryNote,
                                                  style: TextStyle(
                                                      color: theme_grey_text),
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
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                data.addressList3!.data[i]
                                                    .mobileNo
                                                    .replaceAllMapped(
                                                        RegExp(
                                                            r'(\d{3})(\d{3})(\d+)'),
                                                        (Match m) =>
                                                            "${m[1]}-${m[2]}-${m[3]}"),
                                                style: TextStyle(
                                                    color: theme_grey_text),
                                              ),
                                            )
                                          ],
                                        ),
                                        if (data.addressList3!.data[i]
                                                .defaultFlag ==
                                            "1")
                                          Container(
                                            width: 65,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                                color: theme_color_df,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: theme_color_df,
                                                  width: 1,
                                                )),
                                            child: const Text(
                                              'ที่อยู่หลัก',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditAddress(
                                                  addressId: data.addressList3!
                                                      .data[i].msladdrId,
                                                  addressType: data
                                                      .addressList3!
                                                      .data[i]
                                                      .addrtype,
                                                  addressLine: data
                                                      .addressList3!
                                                      .data[i]
                                                      .addrline1,
                                                  mobileNo: data.addressList3!
                                                      .data[i].mobileNo,
                                                  contactName: data
                                                      .addressList3!
                                                      .data[i]
                                                      .deliverContact,
                                                  note: data.addressList3!
                                                      .data[i].deliveryNote,
                                                  defaultFlag: data
                                                      .addressList3!
                                                      .data[i]
                                                      .defaultFlag,
                                                  tumbonName: data.addressList3!
                                                      .data[i].tumbonName,
                                                  tumbonCode: data.addressList3!
                                                      .data[i].tumbonCode,
                                                  amphurName: data.addressList3!
                                                      .data[i].amphurName,
                                                  amphurCode: data.addressList3!
                                                      .data[i].amphurCode,
                                                  provinceName: data
                                                      .addressList3!
                                                      .data[i]
                                                      .provinceName,
                                                  provinceCode: data
                                                      .addressList3!
                                                      .data[i]
                                                      .provinceCode,
                                                  postalCode: data.addressList3!
                                                      .data[i].postalCode,
                                                ),
                                              ),
                                            );
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
                            ),
                          ),
                        ),
                    if (data.addressList3!.data.length <
                        data.addressShow!.showList)
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            side: MaterialStateProperty.all(BorderSide(
                              width: 2,
                              color: theme_color_df,
                            )),
                          ),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewAddress(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '+ เพิ่มที่อยู่ใหม่',
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
