import 'dart:convert';

import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/models/address/address.model.dart';
import 'package:fridayonline/member/services/address/adress.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(address)/search.address.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/service/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EndUserSetAddress extends StatefulWidget {
  const EndUserSetAddress({super.key});

  @override
  State<EndUserSetAddress> createState() => _EndUserNewAddressState();
}

class _EndUserNewAddressState extends State<EndUserSetAddress> {
  final TextEditingController fnameTextCtr = TextEditingController();
  final TextEditingController lnameTextCtr = TextEditingController();
  final TextEditingController telTextCtr = TextEditingController();
  final TextEditingController addressTextCtr = TextEditingController();
  final TextEditingController subDistrictTextCtr = TextEditingController();
  final TextEditingController districtTextCtr = TextEditingController();
  final TextEditingController provinTextCtr = TextEditingController();
  final TextEditingController provinCodeTextCtr = TextEditingController();
  final TextEditingController noteTextCtr = TextEditingController();
  final TextEditingController allAddressCtr = TextEditingController();

  TextStyle textLableStyle =
      TextStyle(fontSize: 13, color: Colors.grey.shade700);

  InputDecoration textFieldstyle(Widget e) {
    return InputDecoration(
      label: e,
      labelStyle: GoogleFonts.notoSansThaiLooped(),
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
    );
  }

  List<TextFieldAddress> label = [];
  List<dynamic> params = Get.arguments;
  String labelAddress = "";
  int provinceId = 0;
  int amphurId = 0;
  int tambonId = 0;
  String postCode = "";
  final _formkey = GlobalKey<FormState>();
  bool isDefault = false;
  Datum? editData;
  int addrssId = 0;
  @override
  void initState() {
    super.initState();
    label = [
      TextFieldAddress(
        labelDetail: RichText(
          text: TextSpan(
              text: "ชื่อ ผู้รับสินค้า",
              style: textLableStyle,
              children: const [
                TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red, fontSize: 20)),
              ]),
        ),
        control: fnameTextCtr,
        textValidate: 'ชื่อ',
      ),
      TextFieldAddress(
        labelDetail: RichText(
          text: TextSpan(
              text: "นามสกุล ผู้รับสินค้า",
              style: textLableStyle,
              children: const [
                TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red, fontSize: 20)),
              ]),
        ),
        control: lnameTextCtr,
        textValidate: 'นามสกุล',
      ),
      TextFieldAddress(
        labelDetail: RichText(
          text: TextSpan(
              text: "หมายเลขโทรศัพท์",
              style: textLableStyle,
              children: const [
                TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red, fontSize: 20)),
              ]),
        ),
        control: telTextCtr,
        textValidate: 'เบอร์โทรศัพท์',
      ),
      TextFieldAddress(
        labelDetail: RichText(
          text: TextSpan(
              text: "บ้านเลขที่,ซอย,หมู่บ้าน,ถนน",
              style: textLableStyle,
              children: const [
                TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red, fontSize: 20)),
              ]),
        ),
        control: addressTextCtr,
        textValidate: 'บ้านเลขที่,ซอย,หมู่บ้าน,ถนน',
      ),
      TextFieldAddress(
        labelDetail: RichText(
          text: TextSpan(
              text: "จังหวัด,เขต/อำเภอ,แขวง/ตำบล,รหัสไปรษณีย์",
              style: textLableStyle,
              children: const [
                TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red, fontSize: 20)),
              ]),
        ),
        textValidate: 'จังหวัด,เขต/อำเภอ,แขวง/ตำบล,รหัสไปรษณีย์',
        control: allAddressCtr,
      ),

      // TextFieldAddress(
      //   labelDetail: RichText(
      //     text: TextSpan(
      //         text: "รายละเอียดเพิ่มเติม เช่น หลังคาสีแดง",
      //         style: textLableStyle),
      //   ),
      //   textValidate: 'รายละเอียดเพิ่มเติม เช่น หลังคาสีแดง',
      //   control: noteTextCtr,
      // ),
    ];
    if (params.isNotEmpty && params.last.runtimeType != String) {
      editData = params.last;
      fnameTextCtr.text = editData!.firstName;
      lnameTextCtr.text = editData!.lastName;
      telTextCtr.text = formatPhoneNumber(editData!.phone);
      allAddressCtr.text = editData!.address;
      addressTextCtr.text = editData!.address1;
      labelAddress = editData!.label;
      isDefault = editData!.isDeliveryAddress;
      addrssId = editData!.id;
      provinceId = editData!.stateId;
      amphurId = editData!.cityId;
      tambonId = editData!.districtId;
      postCode = editData!.zipcode;
    } else {
      if (params.isNotEmpty && params.last == "first") {
        isDefault = true;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    fnameTextCtr.clear();
    lnameTextCtr.clear();
    telTextCtr.clear();
    addressTextCtr.clear();
    subDistrictTextCtr.clear();
    districtTextCtr.clear();
    provinTextCtr.clear();
    provinCodeTextCtr.clear();
    noteTextCtr.clear();
    allAddressCtr.clear();
    params.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Theme(
          data: Theme.of(context).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle: GoogleFonts.notoSansThaiLooped())),
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle: GoogleFonts.notoSansThaiLooped())),
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: appBarMasterEndUser(
                  params.isNotEmpty ? 'แก้ไขที่อยู่' : 'เพิ่มที่อยู่'),
              body: Container(
                color: Colors.grey.shade100,
                height: Get.height,
                child: SingleChildScrollView(
                    child: Container(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Form(
                    key: _formkey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(label.length, (index) {
                            final labelItem =
                                label[index]; // ดึง label จาก index
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0)
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'ช่องทางติดต่อ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                if (index == 3)
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'ที่อยู่',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                //? textfield
                                TextFormField(
                                  maxLength: labelItem.control == addressTextCtr
                                      ? 75
                                      : null,
                                  buildCounter: (context,
                                          {required currentLength,
                                          maxLength,
                                          required isFocused}) =>
                                      null,
                                  style: GoogleFonts.notoSansThaiLooped(
                                      fontSize: 13, color: Colors.black),
                                  inputFormatters: [
                                    labelItem.control == telTextCtr
                                        ? maskFormatterPhone
                                        : LengthLimitingTextInputFormatter(150),
                                  ],
                                  keyboardType: labelItem.control == telTextCtr
                                      ? TextInputType.phone
                                      : TextInputType.text,
                                  validator: labelItem.control != noteTextCtr
                                      ? labelItem.control == telTextCtr
                                          ? Validators.minLength(
                                              12, 'ระบุเบอร์โทรศัพท์ให้ถูกต้อง')
                                          : Validators.required(
                                              'กรุณาระบุ ${labelItem.textValidate}')
                                      : null,
                                  controller: labelItem.control,
                                  readOnly: index == 4 ? true : false,
                                  decoration:
                                      textFieldstyle(labelItem.labelDetail),
                                  onTap: () async {
                                    if (index == 4) {
                                      loadingProductStock(context);
                                      var res = await searchAddressB2cService();
                                      Get.back();
                                      var responseAddress = await Get.to(() =>
                                          B2cSearchAddress(dataAddress: res));
                                      if (responseAddress != null) {
                                        allAddressCtr.text =
                                            responseAddress['display_text'];
                                        provinceId =
                                            responseAddress["province_id"];
                                        amphurId = responseAddress["amphur_id"];
                                        tambonId = responseAddress["tambon_id"];
                                        postCode = responseAddress["post_code"]
                                            .toString();
                                      }
                                    }
                                  },
                                ),
                              ],
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'ตั้งค่า',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'ติดป้ายเป็น:',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 28,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              labelAddress = 'ที่ทำงาน';
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: labelAddress ==
                                                              'ที่ทำงาน'
                                                          ? themeColorDefault
                                                          : Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(2)),
                                              elevation: 0,
                                              backgroundColor:
                                                  labelAddress == 'ที่ทำงาน'
                                                      ? Colors.white
                                                      : Colors.grey.shade200),
                                          child: Text(
                                            'ที่ทำงาน',
                                            style: TextStyle(
                                                color:
                                                    labelAddress == 'ที่ทำงาน'
                                                        ? themeColorDefault
                                                        : Colors.black,
                                                fontSize: 13),
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    SizedBox(
                                      height: 28,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              labelAddress = 'บ้าน';
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: labelAddress ==
                                                              'บ้าน'
                                                          ? themeColorDefault
                                                          : Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(2)),
                                              elevation: 0,
                                              backgroundColor:
                                                  labelAddress == 'บ้าน'
                                                      ? Colors.white
                                                      : Colors.grey.shade200),
                                          child: Text(
                                            'บ้าน',
                                            style: TextStyle(
                                                color: labelAddress == 'บ้าน'
                                                    ? themeColorDefault
                                                    : Colors.black,
                                                fontSize: 13),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'เลือกเป็นที่อยู่ตั้งต้น:',
                                  style: TextStyle(fontSize: 13),
                                ),
                                FlutterSwitch(
                                  inactiveColor:
                                      const Color.fromRGBO(196, 196, 196, 1),
                                  activeColor: themeColorDefault,
                                  activeTextColor: Colors.white,
                                  activeTextFontWeight: FontWeight.normal,
                                  inactiveTextFontWeight: FontWeight.normal,
                                  height: 30,
                                  width: 55,
                                  activeText: "",
                                  inactiveText: "",
                                  showOnOff: true,
                                  inactiveTextColor: Colors.black,
                                  value: isDefault,
                                  onToggle: (val) {
                                    if (params.isNotEmpty &&
                                        params.last.runtimeType == String &&
                                        params.last == 'first') {
                                      alertAddress(
                                          'ที่อยู่ที่คุณเพิ่มมาเป็นอันดับแรกจะถูกตั้งเป็น \n[ค่าเริ่มต้น]');
                                    } else if (params.isNotEmpty &&
                                        params.first == 'edit' &&
                                        editData!.isDeliveryAddress) {
                                      alertAddress(
                                          'คุณไม่สามรถลบที่อยู่ตั้งต้นได้ แต่สามารถเลือกที่อยู่อื่นแทนได้');
                                    } else {
                                      setState(() {
                                        isDefault = val;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                )),
              ),
              bottomNavigationBar: SafeArea(
                  child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                color: Colors.white,
                child: params.isEmpty ||
                        (params.isNotEmpty &&
                            params.last.runtimeType == String &&
                            params.last == 'first')
                    ? Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                  height: 40, child: saveButton(context))),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                            height: 40,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: themeColorDefault),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                                onPressed: () {
                                  alertRemoveAddress('ลบที่อยู่?');
                                },
                                child: Text(
                                  'ลบที่อยู่',
                                  style: TextStyle(color: themeColorDefault),
                                )),
                          )),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: SizedBox(
                                  height: 40, child: saveButton(context)))
                        ],
                      ),
              ))),
        ),
      ),
    );
  }

  Future<dynamic> alertAddress(String msg) {
    return Get.dialog(AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 100),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansThaiLooped(fontSize: 13),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: Get.width,
                    child: Text(
                      'ตกลง',
                      style: GoogleFonts.notoSansThaiLooped(
                          color: themeColorDefault, fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<dynamic> alertRemoveAddress(String msg) {
    return Get.dialog(AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 100),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansThaiLooped(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: Get.width,
                          child: Text(
                            'ยกเลิก',
                            style: GoogleFonts.notoSansThaiLooped(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24, child: VerticalDivider()),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Get.back();
                          if (params.isNotEmpty &&
                              params.first == 'edit' &&
                              editData!.isDeliveryAddress) {
                            if (!Get.isDialogOpen!) {
                              dialogAlert([
                                const Icon(
                                  Icons.notification_important,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Text(
                                  "คุณไม่สามารถลบที่อยู่ตั้งต้นได้",
                                  style: GoogleFonts.notoSansThaiLooped(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ]);
                              Future.delayed(const Duration(seconds: 2), () {
                                Get.back();
                              });
                            }
                            return;
                          }
                          SetData data = SetData();
                          loadingProductStock(context);
                          var payload = jsonEncode({
                            "action": "delete",
                            "cust_id": await data.b2cCustID,
                            "addr_id": addrssId,
                            "default_flag": isDefault ? 1 : 0,
                            "first_name": fnameTextCtr.text,
                            "last_name": lnameTextCtr.text,
                            "address_1": addressTextCtr.text,
                            "address_2": "",
                            "tambon_id": tambonId,
                            "amphur_id": amphurId,
                            "province_id": provinceId,
                            "post_code": postCode,
                            "mobile": telTextCtr.text.replaceAll('-', ''),
                            "label": labelAddress
                          });
                          // printWhite(payload);
                          // return;
                          await setAddressService(payload).then((res) {
                            Get.back();
                            if (res!.code == '100') {
                              dialogAlert([
                                const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                const Text(
                                  'บันทึกข้อมูลเรียบร้อย',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                )
                              ]);
                              Future.delayed(const Duration(milliseconds: 1500),
                                  () {
                                Get.back();
                                Get.back(result: true);
                              });
                            } else {
                              if (!Get.isSnackbarOpen) {
                                Get.snackbar('แจ้งเตือน',
                                    'เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้งค่ะ',
                                    backgroundColor:
                                        Colors.red.withOpacity(0.8),
                                    colorText: Colors.white);
                              }
                              return;
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: Get.width,
                          child: Text(
                            'ลบ',
                            style: GoogleFonts.notoSansThaiLooped(
                                color: themeColorDefault, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  ElevatedButton saveButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: themeColorDefault,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        onPressed: () async {
          SetData data = SetData();
          if (_formkey.currentState!.validate()) {
            loadingProductStock(context);
            var payload = jsonEncode({
              "action": params.isNotEmpty && params.first == 'edit'
                  ? 'update'
                  : "insert",
              "cust_id": await data.b2cCustID,
              "addr_id": addrssId,
              "default_flag": isDefault ? 1 : 0,
              "first_name": fnameTextCtr.text,
              "last_name": lnameTextCtr.text,
              "address_1": addressTextCtr.text,
              "address_2": "",
              "tambon_id": tambonId,
              "amphur_id": amphurId,
              "province_id": provinceId,
              "post_code": postCode,
              "mobile": telTextCtr.text.replaceAll('-', ''),
              "label": labelAddress
            });
            // printWhite(payload);
            // return;
            await setAddressService(payload).then((res) {
              Get.back();
              if (res!.code == '100') {
                dialogAlert([
                  const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  const Text(
                    'บันทึกข้อมูลเรียบร้อย',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )
                ]);
                Future.delayed(const Duration(milliseconds: 1500), () {
                  Get.back();
                  Get.back(result: true);
                });
              } else {
                if (!Get.isSnackbarOpen) {
                  Get.snackbar(
                      'แจ้งเตือน', 'เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้งค่ะ',
                      backgroundColor: Colors.red.withOpacity(0.8),
                      colorText: Colors.white);
                }
                return;
              }
            });
          }
        },
        child: const Text('ยืนยัน'));
  }
}

class TextFieldAddress {
  Widget labelDetail;
  String textValidate;
  TextEditingController control = TextEditingController(); //? textcontroller

  TextFieldAddress(
      {required this.labelDetail,
      required this.control,
      required this.textValidate});
}
