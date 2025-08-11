// ignore_for_file: deprecated_member_use

import 'package:fridayonline/controller/address/address_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/formatter_text.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/service/address/addresssearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../service/address/address.dart';

class NewAddress extends StatefulWidget {
  const NewAddress({super.key});

  @override
  State<NewAddress> createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  final _formKey = GlobalKey<FormState>();
  String tumbon = '';
  String tumbonID = '';
  String amphur = '';
  String amphurID = '';
  String province = '';
  String provinceID = '';
  String postCode = '';
  bool defaultFlag = false;
  TextEditingController nameContact = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController addressLine = TextEditingController();
  TextEditingController addressShow = TextEditingController();
  TextEditingController note = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: const Color(0XFFF5F5F5),
        appBar: appBarTitleMaster('ที่อยู่จัดส่ง'),
        body: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 8, bottom: 8),
                  child: Text(
                    'ช่องทางติดต่อ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameContact,
                  style: TextStyle(color: theme_grey_text),
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                          text: "ชื่อ-นามสกุล ผู้รับสินค้า",
                          style: TextStyle(
                              color: theme_grey_text,
                              fontSize: 14,
                              fontFamily: 'notoreg'),
                          children: const [
                            TextSpan(
                                text: " *",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20)),
                          ]),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    // border only bottom
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "กรุณาระบุ ชื่อ-นามสกุล ผู้รับสินค้า";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  inputFormatters: [maskFormatterPhone],
                  keyboardType: TextInputType.phone,
                  controller: phoneNumber,
                  style: TextStyle(color: theme_grey_text),
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                          text: "เบอร์โทรศัพท์",
                          style: TextStyle(
                              color: theme_grey_text,
                              fontSize: 14,
                              fontFamily: 'notoreg'),
                          children: const [
                            TextSpan(
                                text: " *",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20)),
                          ]),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    // border only bottom
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "กรุณาระบุ เบอร์โทรศัพท์";
                    } else if (value.length < 12) {
                      return "กรุณาระบุให้ครบ 10 หลัก";
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 8, bottom: 8),
                  child: Text(
                    'ที่อยู่จัดส่ง',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: addressLine,
                  maxLength: 100,
                  style: TextStyle(color: theme_grey_text),
                  decoration: InputDecoration(
                    counterText: "",
                    label: RichText(
                      text: TextSpan(
                          text: "บ้านเลขที่,ซอย,ถนน",
                          style: TextStyle(
                              color: theme_grey_text,
                              fontSize: 14,
                              fontFamily: 'notoreg'),
                          children: const [
                            TextSpan(
                                text: " *",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20)),
                          ]),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    // border only bottom
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "กรุณาระบุ บ้านเลขที่,ซอย,ถนน";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  onTap: () async {
                    Address? addressData = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Searchaddress(),
                      ),
                    );
                    setState(() {
                      if (addressData != null) {
                        addressShow.text =
                            '${addressData.tumbon} ${addressData.amphur} ${addressData.province} ${addressData.postCode}';

                        tumbon = addressData.tumbon;
                        tumbonID = addressData.tumbonID;
                        amphur = addressData.amphur;
                        amphurID = addressData.amphurID;
                        province = addressData.province;
                        provinceID = addressData.provinceID;
                        postCode = addressData.postCode;
                      }
                    });
                  },
                  controller: addressShow,
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: theme_grey_text),
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                          text: "จังหวัด/อำเภอ,เขต/ตำบล,แขวง/รหัสไปรษณีย์",
                          style: TextStyle(
                              color: theme_grey_text,
                              fontSize: 14,
                              fontFamily: 'notoreg'),
                          children: const [
                            TextSpan(
                                text: " *",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20)),
                          ]),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    // border only bottom
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "กรุณาระบุ จังหวัด/อำเภอ,เขต/ตำบล,แขวง/รหัสไปรษณีย์";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: note,
                  maxLines: 1,
                  maxLength: 100,
                  style: TextStyle(color: theme_grey_text),
                  decoration: InputDecoration(
                    counterText: "",
                    label: RichText(
                      text: TextSpan(
                          text: "รายละเอียดเพิ่มเติม เช่น หลังคาสีแดง",
                          style: TextStyle(
                              color: theme_grey_text,
                              fontSize: 14,
                              fontFamily: 'notoreg'),
                          children: const [
                            TextSpan(
                                text: "",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20)),
                          ]),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    // border only bottom
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.grey),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 8, bottom: 8),
                  child: Text(
                    'ตั้งค่าเพิ่มเติม',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 8, bottom: 8, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'ตั้งเป็นที่อยู่ค่าเริ่มต้น',
                            style: TextStyle(color: Color(0XFF7B7B7B)),
                          ),
                        ),
                        FlutterSwitch(
                          inactiveColor: const Color.fromRGBO(196, 196, 196, 1),
                          activeColor: theme_color_df,
                          activeText: 'เปิด',
                          activeTextColor: Colors.white,
                          activeTextFontWeight: FontWeight.normal,
                          inactiveText: 'ปิด',
                          inactiveTextFontWeight: FontWeight.normal,
                          valueFontSize: 14.0,
                          showOnOff: true,
                          inactiveTextColor: Colors.black,
                          value: defaultFlag,
                          onToggle: (val) {
                            setState(() {
                              defaultFlag = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: const Color(0XFFABABAB),
                  height: 0.7,
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 18),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme_color_df),
                        onPressed: () async {
                          bool validate = _formKey.currentState!.validate();
                          if (validate) {
                            int flagDefault = 0;
                            if (defaultFlag) {
                              flagDefault = 1;
                            }

                            Get.put(AddressController()).saveAddressMsl(
                                addressLine.text,
                                "",
                                amphurID,
                                flagDefault,
                                note.text,
                                nameContact.text,
                                phoneNumber.text
                                    .replaceAll(RegExp(r'[^0-9\.]'), ''),
                                tumbonID,
                                provinceID,
                                postCode);

                            showMaterialModalBottomSheet(
                                isDismissible: false,
                                enableDrag: false,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0))),
                                builder: (builder) {
                                  return WillPopScope(
                                    onWillPop: () async => false,
                                    child: MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          textScaler:
                                              const TextScaler.linear(1)),
                                      child: GetBuilder<AddressController>(
                                          builder: (data) {
                                        if (data.isDataLoadingUpdate.value) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 355,
                                                child: Lottie.asset(
                                                    width: 180,
                                                    'assets/images/loading_line.json'),
                                              ),
                                            ],
                                          );
                                        } else {
                                          if (data.response!.code == 1000 &&
                                              data.response!.message ==
                                                  "success") {
                                            return MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      textScaler:
                                                          const TextScaler
                                                              .linear(1.0)),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Lottie.asset(
                                                      width: 160,
                                                      height: 160,
                                                      'assets/images/cart/success_lottie.json'),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 20),
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      'บันทึกที่อยู่ใหม่เรียบร้อยค่ะ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: SizedBox(
                                                      width: 280,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    theme_color_df),
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'ตกลง',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              ),
                                            );
                                          } else {
                                            //? กรณีที่เกิด ข้อผิดพลาด
                                            return MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(textScaleFactor: 1),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Lottie.asset(
                                                      width: 160,
                                                      height: 160,
                                                      'assets/images/cart/error_confirm.json'),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 20),
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้งค่ะ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: SizedBox(
                                                        width: 280,
                                                        child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        theme_color_df),
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              'ตกลง',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18),
                                                            ))),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                      }),
                                    ),
                                  );
                                });
                          }
                        },
                        child: const Text(
                          "บันทึกข้อมูล",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )))
              ],
            ),
          ),
        ),
        // bottomNavigationBar: SizedBox(
        //   height: 60,
        //   child: ElevatedButton(
        //       style: ButtonStyle(
        //           foregroundColor:
        //               MaterialStateProperty.all<Color>(Colors.white),
        //           backgroundColor:
        //               MaterialStateProperty.all<Color>(theme_color_df),
        //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //               RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(0),
        //                   side: BorderSide(color: theme_color_df)))),
        //       onPressed: () async {
        //         bool validate = _formKey.currentState!.validate();
        //         if (validate) {
        //           int flagDefault = 0;
        //           if (defaultFlag) {
        //             flagDefault = 1;
        //           }

        //           Get.put(AddressController()).saveAddressMsl(
        //               addressLine.text,
        //               "",
        //               amphurID,
        //               flagDefault,
        //               note.text,
        //               nameContact.text,
        //               phoneNumber.text.replaceAll(RegExp(r'[^0-9\.]'), ''),
        //               tumbonID,
        //               provinceID,
        //               postCode);

        //           showMaterialModalBottomSheet(
        //               isDismissible: false,
        //               enableDrag: false,
        //               context: context,
        //               shape: const RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.only(
        //                       topLeft: Radius.circular(30.0),
        //                       topRight: Radius.circular(30.0))),
        //               builder: (builder) {
        //                 return WillPopScope(
        //                   onWillPop: () async => false,
        //                   child: MediaQuery(
        //                     data: MediaQuery.of(context).copyWith(
        //                         textScaler: const TextScaler.linear(1)),
        //                     child:
        //                         GetBuilder<AddressController>(builder: (data) {
        //                       if (data.isDataLoadingUpdate.value) {
        //                         return Column(
        //                           mainAxisSize: MainAxisSize.min,
        //                           children: [
        //                             SizedBox(
        //                               height: 355,
        //                               child: Lottie.asset(
        //                                   width: 180,
        //                                   'assets/images/loading_line.json'),
        //                             ),
        //                           ],
        //                         );
        //                       } else {
        //                         if (data.response!.code == 1000 &&
        //                             data.response!.message == "success") {
        //                           return MediaQuery(
        //                             data: MediaQuery.of(context)
        //                                 .copyWith(textScaler: const TextScaler.linear(1.0)),
        //                             child: Column(
        //                               mainAxisSize: MainAxisSize.min,
        //                               children: [
        //                                 Lottie.asset(
        //                                     width: 160,
        //                                     height: 160,
        //                                     'assets/images/cart/success_lottie.json'),
        //                                 const Padding(
        //                                   padding: EdgeInsets.symmetric(
        //                                       vertical: 8.0, horizontal: 20),
        //                                   child: Text(
        //                                     textAlign: TextAlign.center,
        //                                     'เพิ่มที่อยู่สำเร็จ',
        //                                     style: TextStyle(
        //                                         fontWeight: FontWeight.bold,
        //                                         fontSize: 18),
        //                                   ),
        //                                 ),
        //                                 const SizedBox(height: 20),
        //                                 Align(
        //                                   alignment: Alignment.bottomCenter,
        //                                   child: SizedBox(
        //                                     width: 280,
        //                                     child: ElevatedButton(
        //                                       style: ElevatedButton.styleFrom(
        //                                           backgroundColor:
        //                                               theme_color_df),
        //                                       onPressed: () async {
        //                                         Navigator.pop(context);
        //                                         Navigator.pop(context);
        //                                       },
        //                                       child: const Text(
        //                                         'ตกลง',
        //                                         style: TextStyle(
        //                                             color: Colors.white,
        //                                             fontSize: 18),
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ),
        //                                 const SizedBox(
        //                                   height: 10,
        //                                 )
        //                               ],
        //                             ),
        //                           );
        //                         } else {
        //                           //? กรณีที่เกิด ข้อผิดพลาด
        //                           return MediaQuery(
        //                             data: MediaQuery.of(context)
        //                                 .copyWith(textScaleFactor: 1),
        //                             child: Column(
        //                               mainAxisSize: MainAxisSize.min,
        //                               children: [
        //                                 Lottie.asset(
        //                                     width: 160,
        //                                     height: 160,
        //                                     'assets/images/cart/error_confirm.json'),
        //                                 const Padding(
        //                                   padding: EdgeInsets.symmetric(
        //                                       vertical: 8.0, horizontal: 20),
        //                                   child: Text(
        //                                     textAlign: TextAlign.center,
        //                                     'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้งค่ะ',
        //                                     style: TextStyle(
        //                                         fontWeight: FontWeight.bold,
        //                                         fontSize: 18),
        //                                   ),
        //                                 ),
        //                                 const SizedBox(height: 20),
        //                                 Align(
        //                                   alignment: Alignment.bottomCenter,
        //                                   child: SizedBox(
        //                                       width: 280,
        //                                       child: ElevatedButton(
        //                                           style:
        //                                               ElevatedButton.styleFrom(
        //                                                   backgroundColor:
        //                                                       theme_color_df),
        //                                           onPressed: () async {
        //                                             Navigator.pop(context);
        //                                           },
        //                                           child: const Text(
        //                                             'ตกลง',
        //                                             style: TextStyle(
        //                                                 color: Colors.white,
        //                                                 fontSize: 18),
        //                                           ))),
        //                                 ),
        //                                 const SizedBox(
        //                                   height: 10,
        //                                 )
        //                               ],
        //                             ),
        //                           );
        //                         }
        //                       }
        //                     }),
        //                   ),
        //                 );
        //               });
        //         }
        //       },
        //       child:
        //           const Text('บันทึกข้อมูล', style: TextStyle(fontSize: 20))),
        // ),
      ),
    );
  }
}
