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

class B2cRequestEtax extends StatefulWidget {
  const B2cRequestEtax({super.key});

  @override
  State<B2cRequestEtax> createState() => _EndUserNewAddressState();
}

class _EndUserNewAddressState extends State<B2cRequestEtax> {
  final TextEditingController fnameTextCtr = TextEditingController();
  final TextEditingController taxNumberCtr = TextEditingController();
  final TextEditingController emailCtr = TextEditingController();
  final TextEditingController telTextCtr = TextEditingController();
  final TextEditingController addressTextCtr = TextEditingController();
  final TextEditingController subDistrictTextCtr = TextEditingController();
  final TextEditingController districtTextCtr = TextEditingController();
  final TextEditingController provinTextCtr = TextEditingController();
  final TextEditingController provinCodeTextCtr = TextEditingController();
  final TextEditingController allAddressCtr = TextEditingController();

  TextStyle textLableStyle =
      TextStyle(fontSize: 13, color: Colors.grey.shade700);

  InputDecoration textFieldstyle(Widget e) {
    return InputDecoration(
      label: e,
      labelStyle: GoogleFonts.ibmPlexSansThai(),
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
  List<TextFieldAddress> label2 = [];
  List<dynamic> params = Get.arguments;
  String labelAddress = "";
  int provinceId = 0;
  int amphurId = 0;
  int tambonId = 0;
  String postCode = "";
  final _formkey = GlobalKey<FormState>();
  bool isDefault = false;
  bool isIndividual = true;
  bool isHeadOffice = false;
  Datum? editData;
  int addrssId = 0;
  @override
  void initState() {
    super.initState();
    label = [
      TextFieldAddress(
        labelDetail: RichText(
          text: TextSpan(
              text: "ชื่อ-สกุล ผู้เสียภาษี",
              style: textLableStyle,
              children: const [
                TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red, fontSize: 20)),
              ]),
        ),
        control: fnameTextCtr,
        textValidate: 'ชื่อ-สกุล ผู้เสียภาษี',
      ),
      TextFieldAddress(
        labelDetail: RichText(
          text: TextSpan(
              text: "หมายเลขประจำตัวผู้เสียภาษี 13 หลัก",
              style: textLableStyle,
              children: const [
                TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red, fontSize: 20)),
              ]),
        ),
        control: taxNumberCtr,
        textValidate: 'หมายเลขประจำตัวผู้เสียภาษี 13 หลัก',
      ),
      TextFieldAddress(
        labelDetail: RichText(
          text: TextSpan(text: "อีเมล", style: textLableStyle, children: const [
            TextSpan(
                text: " *", style: TextStyle(color: Colors.red, fontSize: 20)),
          ]),
        ),
        control: emailCtr,
        textValidate: 'อีเมล',
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
    ];
    label2 = [
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
    ];
    if (params.isNotEmpty && params.last.runtimeType != String) {
      editData = params.last;
      fnameTextCtr.text = editData!.firstName;
      taxNumberCtr.text = formatTaxNumber(editData!.lastName);
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
    taxNumberCtr.clear();
    emailCtr.clear();
    telTextCtr.clear();
    addressTextCtr.clear();
    subDistrictTextCtr.clear();
    districtTextCtr.clear();
    provinTextCtr.clear();
    provinCodeTextCtr.clear();
    allAddressCtr.clear();
    params.clear();
  }

  switchWidget(bool isDefault, void Function(bool) onToggle) {
    return FlutterSwitch(
        inactiveColor: const Color.fromRGBO(196, 196, 196, 1),
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
        onToggle: onToggle);
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
                    textStyle: GoogleFonts.ibmPlexSansThai())),
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle: GoogleFonts.ibmPlexSansThai())),
            textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: appBarMasterEndUser('ขอใบกำกับภาษี'),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 12, left: 8, right: 8, bottom: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'รูปแบบใบกำกับภาษี :',
                            style: TextStyle(fontSize: 13),
                          ),
                          if (isIndividual)
                            Row(
                              children: [
                                OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                        foregroundColor: themeColorDefault,
                                        side: BorderSide(
                                            color: themeColorDefault)),
                                    child: const Text('บุคคลธรรมดา')),
                                const SizedBox(
                                  width: 8,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isIndividual = false;
                                        label.first.labelDetail = RichText(
                                          text: TextSpan(
                                              text: "ชื่อบริษัท",
                                              style: textLableStyle,
                                              children: const [
                                                TextSpan(
                                                    text: " *",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 20)),
                                              ]),
                                        );
                                        label.first.textValidate = 'ชื่อบริษัท';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.grey.shade300,
                                        foregroundColor: Colors.grey),
                                    child: const Text('นิติบุคคล'))
                              ],
                            )
                          else
                            Row(
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isIndividual = true;
                                        label.first.labelDetail = RichText(
                                          text: TextSpan(
                                              text: "ชื่อ-สกุล ผู้เสียภาษี",
                                              style: textLableStyle,
                                              children: const [
                                                TextSpan(
                                                    text: " *",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 20)),
                                              ]),
                                        );
                                        label.first.textValidate =
                                            'ชื่อ-สกุล ผู้เสียภาษี';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.grey.shade300,
                                        foregroundColor: Colors.grey),
                                    child: const Text('บุคคลธรรมดา')),
                                const SizedBox(
                                  width: 8,
                                ),
                                OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                        foregroundColor: themeColorDefault,
                                        side: BorderSide(
                                            color: themeColorDefault)),
                                    child: const Text('นิติบุคคล'))
                              ],
                            ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formkey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                color: Colors.grey.shade100,
                                child: SingleChildScrollView(
                                    child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...List.generate(label.length, (index) {
                                        final labelItem =
                                            label[index]; // ดึง label จาก index
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (index == 0)
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 4, left: 8, right: 8),
                                                child: Text(
                                                  'ข้อมูลเบื้องต้น',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            if (index == 1 && !isIndividual)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12.0,
                                                    left: 8,
                                                    right: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('สำนักงานใหญ่ :',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                        )),
                                                    switchWidget(
                                                      isHeadOffice,
                                                      (val) {
                                                        if (params.isNotEmpty &&
                                                            params.last
                                                                    .runtimeType ==
                                                                String &&
                                                            params.last ==
                                                                'first') {
                                                          alertAddress(
                                                              'ที่อยู่ที่คุณเพิ่มมาเป็นอันดับแรกจะถูกตั้งเป็น \n[ค่าเริ่มต้น]');
                                                        } else if (params
                                                                .isNotEmpty &&
                                                            params.first ==
                                                                'edit' &&
                                                            editData!
                                                                .isDeliveryAddress) {
                                                          alertAddress(
                                                              'คุณไม่สามรถลบที่อยู่ตั้งต้นได้ แต่สามารถเลือกที่อยู่อื่นแทนได้');
                                                        } else {
                                                          setState(() {
                                                            isHeadOffice = val;
                                                          });
                                                        }
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            //? textfield
                                            TextFormField(
                                              maxLength: labelItem.control ==
                                                      addressTextCtr
                                                  ? 100
                                                  : null,
                                              buildCounter: (context,
                                                      {required currentLength,
                                                      maxLength,
                                                      required isFocused}) =>
                                                  null,
                                              style:
                                                  GoogleFonts.ibmPlexSansThai(
                                                      fontSize: 13,
                                                      color: Colors.black),
                                              inputFormatters: [
                                                labelItem.control == telTextCtr
                                                    ? maskFormatterPhone
                                                    : labelItem.control ==
                                                            taxNumberCtr
                                                        ? maskFormatterTax
                                                        : LengthLimitingTextInputFormatter(
                                                            150),
                                              ],
                                              keyboardType: labelItem.control ==
                                                          telTextCtr ||
                                                      labelItem.control ==
                                                          taxNumberCtr
                                                  ? TextInputType.phone
                                                  : TextInputType.text,
                                              validator:
                                                  validatorTextField(labelItem),
                                              controller: labelItem.control,
                                              readOnly:
                                                  index == 5 ? true : false,
                                              decoration: textFieldstyle(
                                                  labelItem.labelDetail),
                                              onTap: () async {
                                                if (index == 5) {
                                                  loadingProductStock(context);
                                                  var res =
                                                      await searchAddressB2cService();
                                                  Get.back();
                                                  var responseAddress =
                                                      await Get.to(() =>
                                                          B2cSearchAddress(
                                                              dataAddress:
                                                                  res));
                                                  if (responseAddress != null) {
                                                    allAddressCtr.text =
                                                        responseAddress[
                                                            'display_text'];
                                                    provinceId =
                                                        responseAddress[
                                                            "province_id"];
                                                    amphurId = responseAddress[
                                                        "amphur_id"];
                                                    tambonId = responseAddress[
                                                        "tambon_id"];
                                                    postCode = responseAddress[
                                                            "post_code"]
                                                        .toString();
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ))),
                            Container(
                                color: Colors.grey.shade100,
                                child: SingleChildScrollView(
                                    child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...List.generate(label2.length, (index) {
                                        final labelItem = label2[index];
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (index == 0)
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8, top: 12),
                                                child: Text(
                                                  'ที่อยู่สำหรับออกใบกำกับภาษี',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),

                                            //? textfield
                                            TextFormField(
                                              maxLength: labelItem.control ==
                                                      addressTextCtr
                                                  ? 100
                                                  : null,
                                              buildCounter: (context,
                                                      {required currentLength,
                                                      maxLength,
                                                      required isFocused}) =>
                                                  null,
                                              style:
                                                  GoogleFonts.ibmPlexSansThai(
                                                      fontSize: 13,
                                                      color: Colors.black),
                                              inputFormatters: [
                                                labelItem.control == telTextCtr
                                                    ? maskFormatterPhone
                                                    : labelItem.control ==
                                                            taxNumberCtr
                                                        ? maskFormatterTax
                                                        : LengthLimitingTextInputFormatter(
                                                            150),
                                              ],
                                              keyboardType: labelItem.control ==
                                                          telTextCtr ||
                                                      labelItem.control ==
                                                          taxNumberCtr
                                                  ? TextInputType.phone
                                                  : TextInputType.text,
                                              validator:
                                                  validatorTextField(labelItem),
                                              controller: labelItem.control,
                                              readOnly:
                                                  index == 1 ? true : false,
                                              decoration: textFieldstyle(
                                                  labelItem.labelDetail),
                                              onTap: () async {
                                                if (index == 1) {
                                                  loadingProductStock(context);
                                                  var res =
                                                      await searchAddressB2cService();
                                                  Get.back();
                                                  var responseAddress =
                                                      await Get.to(() =>
                                                          B2cSearchAddress(
                                                              dataAddress:
                                                                  res));
                                                  if (responseAddress != null) {
                                                    allAddressCtr.text =
                                                        responseAddress[
                                                            'display_text'];
                                                    provinceId =
                                                        responseAddress[
                                                            "province_id"];
                                                    amphurId = responseAddress[
                                                        "amphur_id"];
                                                    tambonId = responseAddress[
                                                        "tambon_id"];
                                                    postCode = responseAddress[
                                                            "post_code"]
                                                        .toString();
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      }),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'ตั้งเป็นข้อมูลตั้งต้นในการออกใบกำกับภาษี :',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                            switchWidget(
                                              isDefault,
                                              (val) {
                                                if (params.isNotEmpty &&
                                                    params.last.runtimeType ==
                                                        String &&
                                                    params.last == 'first') {
                                                  alertAddress(
                                                      'ที่อยู่ที่คุณเพิ่มมาเป็นอันดับแรกจะถูกตั้งเป็น \n[ค่าเริ่มต้น]');
                                                } else if (params.isNotEmpty &&
                                                    params.first == 'edit' &&
                                                    editData!
                                                        .isDeliveryAddress) {
                                                  alertAddress(
                                                      'คุณไม่สามรถลบที่อยู่ตั้งต้นได้ แต่สามารถเลือกที่อยู่อื่นแทนได้');
                                                } else {
                                                  setState(() {
                                                    isDefault = val;
                                                  });
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ))),
                          ]),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                color: Colors.white,
                child: SafeArea(
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
                                      side:
                                          BorderSide(color: themeColorDefault),
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
                )),
              )),
        ),
      ),
    );
  }

  validatorTextField(TextFieldAddress labelItem) {
    if (labelItem.control == telTextCtr) {
      return Validators.minLength(12, 'ระบุเบอร์โทรศัพท์ให้ถูกต้อง');
    } else if (labelItem.control == taxNumberCtr) {
      return Validators.minLength(16, 'ระบุหมายเลขผู้เสียภาษีให้ถูกต้อง');
    } else if (labelItem.control == emailCtr) {
      return Validators.email('รูปแบบอีเมลไม่ถูกต้อง');
    }
    return Validators.required('กรุณาระบุ ${labelItem.textValidate}');
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
                  style: GoogleFonts.ibmPlexSansThai(fontSize: 13),
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
                      style: GoogleFonts.ibmPlexSansThai(
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
                  style: GoogleFonts.ibmPlexSansThai(
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
                            style: GoogleFonts.ibmPlexSansThai(fontSize: 14),
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
                                  style: GoogleFonts.ibmPlexSansThai(
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
                            "last_name": taxNumberCtr.text,
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
                            style: GoogleFonts.ibmPlexSansThai(
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
          // SetData data = SetData();
          if (_formkey.currentState!.validate()) {
            print('ok ผ่าน');
            return;
            // loadingProductStock(context);
            // var payload = jsonEncode({
            //   "action": params.isNotEmpty && params.first == 'edit'
            //       ? 'update'
            //       : "insert",
            //   "cust_id": await data.b2cCustID,
            //   "addr_id": addrssId,
            //   "default_flag": isDefault ? 1 : 0,
            //   "first_name": fnameTextCtr.text,
            //   "last_name": taxNumberCtr.text,
            //   "address_1": addressTextCtr.text,
            //   "address_2": "",
            //   "tambon_id": tambonId,
            //   "amphur_id": amphurId,
            //   "province_id": provinceId,
            //   "post_code": postCode,
            //   "mobile": telTextCtr.text.replaceAll('-', ''),
            //   "label": labelAddress
            // });
            // // printWhite(payload);
            // // return;
            // await setAddressService(payload).then((res) {
            //   Get.back();
            //   if (res!.code == '100') {
            //     dialogAlert([
            //       const Icon(
            //         Icons.check_rounded,
            //         color: Colors.white,
            //         size: 35,
            //       ),
            //       const Text(
            //         'บันทึกข้อมูลเรียบร้อย',
            //         style: TextStyle(color: Colors.white, fontSize: 14),
            //       )
            //     ]);
            //     Future.delayed(const Duration(milliseconds: 1500), () {
            //       Get.back();
            //       Get.back(result: true);
            //     });
            //   } else {
            //     if (!Get.isSnackbarOpen) {
            //       Get.snackbar(
            //           'แจ้งเตือน', 'เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้งค่ะ',
            //           backgroundColor: Colors.red.withOpacity(0.8),
            //           colorText: Colors.white);
            //     }
            //     return;
            //   }
            // });
          }
        },
        child: const Text('บันทึก'));
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
