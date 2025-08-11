import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../controller/cart/dropship_controller.dart';
import '../../../../model/cart/dropship/drop_ship_address.dart' as dropAddress;
import '../../../../model/cart/dropship/dropship_msg.dart';
import '../../../../service/address/address.dart';
import '../../../../service/address/addresssearch.dart';
import '../../../../service/cart/dropship/dropship_address_service.dart';
import '../../../../service/languages/multi_languages.dart';
import '../../../../service/validators.dart';
import '../../../theme/formatter_text.dart';

class DropshipEditAddress extends StatefulWidget {
  const DropshipEditAddress({super.key});

  @override
  State<DropshipEditAddress> createState() => _DropshipEditAddressState();
}

//? คลาสของเก็บ label และ textcontroll
class TextFieldAddress {
  String labelDetail; //? label
  TextEditingController control = TextEditingController(); //? textcontroller

  TextFieldAddress({required this.labelDetail, required this.control});
}

class _DropshipEditAddressState extends State<DropshipEditAddress> {
  List<dynamic> params = Get.arguments;
  final _formkey = GlobalKey<FormState>();
  bool useDefault = false;

  //?  ตัวแปรจัดการข้อความ
  static TextEditingController namecon = TextEditingController();
  static TextEditingController telTextCroller = TextEditingController();
  static TextEditingController addressTextCroller = TextEditingController();
  static TextEditingController subdistricTextCroller = TextEditingController();
  static TextEditingController districtTextCroller = TextEditingController();
  static TextEditingController provinTextCroller = TextEditingController();
  static TextEditingController provinCodeTextCroller = TextEditingController();

  //? สร้าง list จาก class TextFieldAddress
  List<TextFieldAddress> label = [
    TextFieldAddress(
      labelDetail: "ชื่อ-นามสกุล ผู้รับสินค้า",
      control: namecon,
    ),
    TextFieldAddress(
      labelDetail: "เบอร์โทรศัพท์",
      control: telTextCroller,
    ),
    TextFieldAddress(
      labelDetail: "บ้านเลขที่ / ชื่ออาคาร / หมู่บ้าน",
      control: addressTextCroller,
    ),
    TextFieldAddress(
      labelDetail: "แขวง / ตำบล",
      control: subdistricTextCroller,
    ),
    TextFieldAddress(
      labelDetail: "เขต / อำเภอ",
      control: districtTextCroller,
    ),
    TextFieldAddress(
      labelDetail: "จังหวัด",
      control: provinTextCroller,
    ),
    TextFieldAddress(
      labelDetail: "รหัสไปรษณีย์",
      control: provinCodeTextCroller,
    ),
  ];
  //? สไตล์ของ text label
  var textStyle = TextStyle(
      fontSize: 14,
      fontFamily: 'notoreg',
      fontWeight: FontWeight.bold,
      color: theme_color_df);

  String? tumbonID;
  String? amphurID;
  String? provinceID;

  @override
  void initState() {
    super.initState();

    if (params.last == "Edit") {
      //? ประกาศตัวแปรเพื่อรับค่าที่ส่งมาจากหน้าก่อนหน้า
      var par = params[1] as dropAddress.Address;
      //? เซ็ตค่าเริ่มต้นเมื่อกดแก้ไข
      namecon.text = par.nameReceive;
      telTextCroller.text = par.mobileNo;
      addressTextCroller.text = par.addressLine1;
      subdistricTextCroller.text = par.nameTumbon;
      districtTextCroller.text = par.nameAmphur;
      provinTextCroller.text = par.nameProvince;
      provinCodeTextCroller.text = par.postCode;

      //? ตรวจว่าเป็นที่อยู่หลักหรือไม่
      if (par.addressType == '1') {
        //? set ค่า switch ให้เป็นเปิด
        useDefault = true;
      }
    }
  }

  @override
  void dispose() {
    //? clear text เมื่อปิดหน้า
    namecon.clear();
    telTextCroller.clear();
    addressTextCroller.clear();
    subdistricTextCroller.clear();
    districtTextCroller.clear();
    provinTextCroller.clear();
    provinCodeTextCroller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: appBarTitleMaster(params[0]),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Form(
                key: _formkey,
                child: Column(children: [
                  //? สวิตช์ตั้งที่อยู่
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "ตั้งที่อยู่เป็นค่าเริ่มต้น   ",
                        style: TextStyle(
                            color: theme_color_df, fontWeight: FontWeight.bold),
                      ),
                      //? สวิตช์
                      FlutterSwitch(
                        inactiveColor: const Color.fromRGBO(196, 196, 196, 1),
                        activeColor: theme_color_df,
                        activeTextColor: Colors.white,
                        activeTextFontWeight: FontWeight.normal,
                        inactiveTextFontWeight: FontWeight.normal,
                        valueFontSize: 14.0,
                        // showOnOff: true,
                        inactiveTextColor: Colors.white,
                        value: useDefault,
                        onToggle: (val) {
                          setState(() {
                            useDefault = val;
                          });
                        },
                      ),
                    ],
                  ),

                  //? loop ข้อมูลจาก list ที่สร้างมาแสดง
                  ...label
                      .asMap()
                      .map(
                        (index, label) => MapEntry(
                            index,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //? label
                                  RichText(
                                    text: TextSpan(
                                        text: label.labelDetail,
                                        style: textStyle,
                                        children: [
                                          if (index == 1)
                                            TextSpan(
                                                text: "  ตัวเลข 10 หลัก",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: theme_color_df,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          const TextSpan(
                                              text: " *",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ]),
                                  ),
                                  //? textfield
                                  TextFormField(
                                    style: TextStyle(color: theme_grey_text),
                                    inputFormatters: [
                                      label.control == telTextCroller
                                          ? maskFormatterPhone
                                          : LengthLimitingTextInputFormatter(
                                              150),
                                    ],
                                    keyboardType:
                                        label.control == telTextCroller
                                            ? TextInputType.phone
                                            : TextInputType.text,
                                    validator: Validators.required(
                                        'กรุณาระบุ${label.labelDetail}'),
                                    controller: label.control,
                                    enableIMEPersonalizedLearning: false,
                                    readOnly: index <= 2 ? false : true,
                                    decoration:
                                        textFieldstyle(label.labelDetail),
                                    onTap: () async {
                                      //? call หาที่อยู่
                                      await fetchAddress(index, context);
                                    },
                                  )
                                ],
                              ),
                            )),
                      )
                      .values,

                  //? ปุ่มลบข้อมูล แสดงเฉพาะการแก้ไขที่อยู่
                  if (params.last == "Edit") btnDelete(context),
                  //? ปุ่มบันทึกข้อมูล
                  btnSave(context)
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  btnDelete(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 2, color: theme_grey_text),
          ),
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0)),
                  title: const Center(
                    child: Text(
                      'ต้องการลบที่อยู่จัดส่งนี้หรือไม่',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  actions: <Widget>[
                    MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    backgroundColor: theme_grey_text,
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                child: Text(
                                  MultiLanguages.of(context)!
                                      .translate('alert_cancel'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'notoreg'),
                                )),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    style: BorderStyle.solid, color: theme_red),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                              onPressed: () async {
                                var par = params[1] as dropAddress.Address;
                                DropshipMsg? statusEdit =
                                    await editDropshipAddress(
                                        'D',
                                        par.addressId,
                                        useDefault == true ? '1' : '2',
                                        par.nameReceive,
                                        par.mobileNo,
                                        par.addressLine1,
                                        par.nameTumbon,
                                        par.nameAmphur,
                                        par.nameProvince,
                                        par.postCode);
                                if (statusEdit!.code == '100') {
                                  await Get.put(
                                          FetchAddressDropshipController())
                                      .fetchDropshipAddress()
                                      .then((result) => Get.until((route) =>
                                          Get.currentRoute == '/EditAddress'));
                                } else {
                                  errorPopup(context, statusEdit.message1);
                                }
                              },
                              child: Text(
                                MultiLanguages.of(context)!
                                    .translate('txt_delete_item'),
                                style: TextStyle(color: theme_red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );

            // successPopup(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, color: theme_grey_text),
                Text(
                  'ลบที่อยู่นี้',
                  style: TextStyle(color: theme_grey_text),
                )
              ],
            ),
          )),
    );
  }

  //? ปุ่มบันทึกข้อมูล
  btnSave(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: theme_color_df),
            onPressed: () async {
              bool validate = _formkey.currentState!.validate();
              //? การกรอกข้อมูล และความถูกต้องของที่อยู่
              if (validate) {
                switch (params.last) {
                  case "Edit":
                    {
                      var par = params[1] as dropAddress.Address;
                      DropshipMsg? statusEdit = await editDropshipAddress(
                          'E',
                          par.addressId,
                          useDefault == true ? '1' : '2',
                          namecon.text,
                          telTextCroller.text.replaceAll('-', ''),
                          addressTextCroller.text,
                          subdistricTextCroller.text,
                          districtTextCroller.text,
                          provinTextCroller.text,
                          provinCodeTextCroller.text);
                      if (statusEdit!.code == '100') {
                        successPopup(context);
                      } else {
                        errorPopup(context, statusEdit.message1);
                      }
                      break;
                    }
                  case "Add":
                    {
                      DropshipMsg? statusEdit = await editDropshipAddress(
                          'I',
                          "",
                          useDefault == true ? '1' : '2',
                          namecon.text,
                          telTextCroller.text,
                          addressTextCroller.text,
                          subdistricTextCroller.text,
                          districtTextCroller.text,
                          provinTextCroller.text,
                          provinCodeTextCroller.text);
                      if (statusEdit!.code == '100') {
                        successPopup(context);
                      } else {
                        errorPopup(context, statusEdit.message1);
                      }
                      break;
                    }
                  default:
                    {
                      break;
                    }
                }
              }
              // namecon.text = "run";
            },
            child: const Text(
              "บันทึกข้อมูล",
              style: TextStyle(color: Colors.white),
            )));
  }

  //? popup แสดงบันทึกข้อมูลสำเร็จ
  Future<dynamic> successPopup(BuildContext context) {
    return showMaterialModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      builder: (builder) {
        return WillPopScope(
          onWillPop: () async => false,
          child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                        width: 230,
                        height: 230,
                        'assets/images/cart/success_lottie.json'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20),
                      child: Text(
                        "บันทึกที่อยู่ใหม่เรียบร้อยค่ะ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: boldText, fontSize: 19),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          width: 280,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: theme_color_df),
                              onPressed: () async {
                                namecon.clear();
                                telTextCroller.clear();
                                addressTextCroller.clear();
                                subdistricTextCroller.clear();
                                districtTextCroller.clear();
                                provinTextCroller.clear();
                                provinCodeTextCroller.clear();
                                // Get.off(()=>;
                                await Get.put(FetchAddressDropshipController())
                                    .fetchDropshipAddress();
                                Get.until((route) =>
                                    Get.currentRoute == '/EditAddress');
                              },
                              child: Text(
                                MultiLanguages.of(context)!
                                    .translate('alert_okay'),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ))),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )),
        );
      },
    );
  }

  //? popup กรอกข้อมูลผิดพลาด
  Future<dynamic> errorPopup(BuildContext context, String msg) {
    return showMaterialModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      builder: (builder) {
        return WillPopScope(
          onWillPop: () async => false,
          child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                        width: 230,
                        height: 230,
                        'assets/images/warning_red.json'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20),
                      child: Text(
                        msg,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: boldText, fontSize: 19),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          width: 280,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: theme_color_df),
                              onPressed: () async {
                                // Get.off(()=>;
                                Get.back();
                              },
                              child: Text(
                                MultiLanguages.of(context)!
                                    .translate('alert_okay'),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ))),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )),
        );
      },
    );
  }

  //? method หาที่อยู่
  Future fetchAddress(int i, BuildContext context) async {
    //? i คือ index ของ textfield
    if (i > 2) {
      //? call หาที่อยู่
      Address? addressValue = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Searchaddress()));
      if (addressValue != null) {
        //? รับข้อมูลที่ได้เข้า textfield
        subdistricTextCroller.text = addressValue.tumbon;
        districtTextCroller.text = addressValue.amphur;
        provinTextCroller.text = addressValue.province;
        provinCodeTextCroller.text = addressValue.postCode;

        tumbonID = addressValue.tumbonID;
        amphurID = addressValue.amphurID;
        provinceID = addressValue.provinceID;
      }
      // print(addressValue);
    }
  }

  //? สไตล์ของช่องข้อความ
  InputDecoration textFieldstyle(String e) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      hintText: "กรุณากรอก $e",
      hintStyle: const TextStyle(fontSize: 14, fontFamily: 'notoreg'),

      isDense: true, // Added this
    );
  }
}
