// import 'package:fridayonline/homepage/pageactivity/cart/cart_page/cart_change_address.dart';
import 'package:fridayonline/controller/cart/cart_address_enduser_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_page/cart_endusers_change_address.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/model/cart/enduser/enduser_address.dart';
import 'package:fridayonline/model/cart/enduser/success_response.dart';
import 'package:fridayonline/service/cart/enduser/enduser_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// import '../../../../controller/cart/dropship_controller.dart';
// import '../../../../model/cart/dropship/drop_ship_address.dart' as dropAddress;
// import '../../../../model/cart/dropship/dropship_msg.dart';
import '../../../../model/cart/enduser/enduser_add_data.dart';
import '../../../../service/address/address.dart';
import '../../../../service/address/addresssearch.dart';
// import '../../../../service/cart/dropship/dropship_address_service.dart';
import '../../../../service/languages/multi_languages.dart';
import '../../../../service/validators.dart';
import '../../../theme/formatter_text.dart';

class EndUserAddAddress extends StatefulWidget {
  const EndUserAddAddress({super.key});

  @override
  State<EndUserAddAddress> createState() => _EndUserAddAddress2State();
}

//? คลาสของเก็บ label และ textcontroll
class TextFieldAddress {
  Widget labelDetail;
  String textValidate;
  TextEditingController control = TextEditingController(); //? textcontroller

  TextFieldAddress(
      {required this.labelDetail,
      required this.control,
      required this.textValidate});
}

class _EndUserAddAddress2State extends State<EndUserAddAddress> {
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
  static TextEditingController noteTextCroller = TextEditingController();
  static TextEditingController allAddressCroller = TextEditingController();
  //? สไตล์ของ text label
  static TextStyle labelTextStyle =
      TextStyle(color: theme_grey_text, fontSize: 14, fontFamily: 'notoreg');
  //? สร้าง list จาก class TextFieldAddress
  List<TextFieldAddress> label = [
    TextFieldAddress(
      labelDetail: RichText(
        text: TextSpan(
            text: "ชื่อ-นามสกุล ผู้รับสินค้า",
            style: labelTextStyle,
            children: const [
              TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red, fontSize: 20)),
            ]),
      ),
      control: namecon,
      textValidate: 'ชื่อ-นามสกุล ผู้รับสินค้า',
    ),
    TextFieldAddress(
      labelDetail: RichText(
        text: TextSpan(
            text: "เบอร์โทรศัพท์",
            style: labelTextStyle,
            children: const [
              TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red, fontSize: 20)),
            ]),
      ),
      control: telTextCroller,
      textValidate: 'เบอร์โทรศัพท์',
    ),
    TextFieldAddress(
      labelDetail: RichText(
        text: TextSpan(
            text: "บ้านเลขที่,ซอย,หมู่บ้าน,ถนน",
            style: labelTextStyle,
            children: const [
              TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red, fontSize: 20)),
            ]),
      ),
      control: addressTextCroller,
      textValidate: 'บ้านเลขที่,ซอย,หมู่บ้าน,ถนน',
    ),
    TextFieldAddress(
      labelDetail: RichText(
        text: TextSpan(
            text: "จังหวัด,เขต/อำเภอ,แขวง/ตำบล,รหัสไปรษณีย์",
            style: labelTextStyle,
            children: const [
              TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red, fontSize: 20)),
            ]),
      ),
      textValidate: 'จังหวัด,เขต/อำเภอ,แขวง/ตำบล,รหัสไปรษณีย์',
      control: allAddressCroller,
    ),
    TextFieldAddress(
      labelDetail: RichText(
        text: TextSpan(
            text: "รายละเอียดเพิ่มเติม เช่น หลังคาสีแดง",
            style: labelTextStyle),
      ),
      textValidate: 'รายละเอียดเพิ่มเติม เช่น หลังคาสีแดง',
      control: noteTextCroller,
    ),
  ];

  String? tumbonID;
  String? amphurID;
  String? provinceID;
  AryAddress? addressEndUser;
  @override
  void initState() {
    super.initState();

    if (params[2] == "Edit") {
      //? ประกาศตัวแปรเพื่อรับค่าที่ส่งมาจากหน้าก่อนหน้า
      addressEndUser = params[1] as AryAddress;
      var mainAddress = params[3];
      //? เซ็ตค่าเริ่มต้นเมื่อกดแก้ไข
      namecon.text = addressEndUser!.name;
      telTextCroller.text = formatPhoneNumber(addressEndUser!.telnumber);
      addressTextCroller.text = addressEndUser!.address1;
      subdistricTextCroller.text = addressEndUser!.tumbonName;
      districtTextCroller.text = addressEndUser!.amphurName;
      provinTextCroller.text = addressEndUser!.provinceName;
      provinCodeTextCroller.text = addressEndUser!.postalcode;
      noteTextCroller.text = addressEndUser!.note;
      allAddressCroller.text =
          "${addressEndUser!.provinceName} ${addressEndUser!.amphurName} ${addressEndUser!.tumbonName} ${addressEndUser!.postalcode}";
      provinceID = addressEndUser!.provinceId;
      amphurID = addressEndUser!.amphurId;
      tumbonID = addressEndUser!.tumbonId;
      //? ตรวจว่าเป็นที่อยู่หลักหรือไม่
      if (mainAddress == 'main') {
        //? set ค่า switch ให้เป็นเปิด
        useDefault = true;
      }
    } else {
      addressEndUser = AryAddress(
          id: '',
          enduserId: '',
          name: '',
          telnumber: '',
          type: '',
          address1: '',
          address2: '',
          provinceId: '',
          amphurId: '',
          tumbonId: '',
          provinceName: '',
          amphurName: '',
          tumbonName: '',
          postalcode: '',
          note: '');
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
    noteTextCroller.clear();
    allAddressCroller.clear();
    super.dispose();
  }

  var textLableStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: appBarTitleMaster(params[0]),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: Form(
                key: _formkey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //? loop ข้อมูลจาก list ที่สร้างมาแสดง
                      ...label
                          .asMap()
                          .map(
                            (index, label) => MapEntry(
                                index,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (index == 0)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8, left: 12, right: 12),
                                        child: Text(
                                          'ช่องทางติดต่อ',
                                          style: textLableStyle,
                                        ),
                                      ),
                                    if (index == 2)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16,
                                            bottom: 8,
                                            left: 12,
                                            right: 12),
                                        child: Text(
                                          'ที่อยู่จัดส่ง',
                                          style: textLableStyle,
                                        ),
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
                                      validator: label.control !=
                                              noteTextCroller
                                          ? Validators.required(
                                              'กรุณาระบุ ${label.textValidate}')
                                          : null,
                                      controller: label.control,
                                      readOnly: index == 3 ? true : false,
                                      decoration:
                                          textFieldstyle(label.labelDetail),
                                      onTap: () async {
                                        //? call หาที่อยู่
                                        await fetchAddress(index, context);
                                      },
                                    )
                                  ],
                                )),
                          )
                          .values,
                      //? ตั้งค่าเพิ่มเติม
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16, bottom: 8, left: 12, right: 12),
                        child: Text(
                          'ตั้งค่าเพิ่มเติม',
                          style: textLableStyle,
                        ),
                      ),
                      //? ติดป้าย
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 0.5, color: Colors.grey),
                            ),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('ติดป้ายเป็น', style: labelTextStyle),
                                Row(
                                  children: [
                                    OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (addressEndUser!.type == "1") {
                                              addressEndUser!.type = "";
                                            } else {
                                              addressEndUser!.type = "1";
                                            }
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              addressEndUser!.type == "1"
                                                  ? theme_color_df
                                                  : Colors.transparent,
                                          side: BorderSide(
                                              width: 2,
                                              color: theme_color_df
                                                  .withOpacity(0.5)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        child: Text('บ้าน',
                                            style: TextStyle(
                                              color: addressEndUser!.type == "1"
                                                  ? Colors.white
                                                  : theme_color_df,
                                            ))),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (addressEndUser!.type == "2") {
                                              addressEndUser!.type = "";
                                            } else {
                                              addressEndUser!.type = "2";
                                            }
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              addressEndUser!.type == "2"
                                                  ? theme_color_df
                                                  : Colors.transparent,
                                          side: BorderSide(
                                              width: 2,
                                              color: theme_color_df
                                                  .withOpacity(0.5)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        child: Text('ที่ทำงาน',
                                            style: TextStyle(
                                              color: addressEndUser!.type == "2"
                                                  ? Colors.white
                                                  : theme_color_df,
                                            )))
                                  ],
                                )
                              ]),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 0.5, color: Colors.grey),
                            ),
                            color: Colors.white),
                        child: //? สวิตช์ตั้งที่อยู่
                            Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ตั้งที่อยู่เป็นค่าเริ่มต้น   ",
                                style: labelTextStyle,
                              ),
                              //? สวิตช์
                              FlutterSwitch(
                                inactiveColor:
                                    const Color.fromRGBO(196, 196, 196, 1),
                                activeColor: theme_color_df,
                                activeTextColor: Colors.white,
                                activeTextFontWeight: FontWeight.normal,
                                inactiveTextFontWeight: FontWeight.normal,
                                valueFontSize: 14.0,
                                activeText: "เปิด",
                                inactiveText: "ปิด",
                                showOnOff: true,
                                inactiveTextColor: Colors.black,
                                value: useDefault,
                                onToggle: (val) {
                                  setState(() {
                                    useDefault = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      //? ปุ่มลบข้อมูล แสดงเฉพาะการแก้ไขที่อยู่
                      if (params[2] == "Edit") btnDelete(context),
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

  //? ปุ่มลบข้อมูล
  btnDelete(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 20),
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 2, color: theme_color_df.withOpacity(0.5)),
            backgroundColor: Colors.white,
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
                                child: const Text(
                                  'ยกเลิก',
                                  style: TextStyle(
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
                                var par = params[1] as AryAddress;
                                SuccessResponse? statusEdit =
                                    await deleteEnduserAddress(par.id);
                                if (statusEdit!.code == '100') {
                                  await Get.find<FetchCartEndUsersAddress>()
                                      .fetchEnduserAddress();
                                  Get.until((route) =>
                                      Get.currentRoute ==
                                      '/EndUserChangeAddress');
                                } else {
                                  errorPopup(context, statusEdit.message1);
                                }
                              },
                              child: Text(
                                'ลบ',
                                style: TextStyle(
                                  color: theme_red,
                                  fontSize: 16,
                                ),
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
                // Icon(Icons.delete, color: theme_grey_text),
                Text(
                  'ลบที่อยู่จัดส่ง',
                  style: TextStyle(
                    color: theme_color_df,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          )),
    );
  }

  //? ปุ่มบันทึกข้อมูล
  btnSave(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: theme_color_df),
            onPressed: () async {
              bool validate = _formkey.currentState!.validate();
              //? การกรอกข้อมูล และความถูกต้องของที่อยู่
              if (validate) {
                if (telTextCroller.text.length < 10) {
                  validate = false;
                  errorPopup(context, 'กรุณาระบุเบอร์โทรศัพท์ให้ครบ 10 หลัก');
                  return;
                }

                switch (params[2]) {
                  case "Edit":
                    {
                      var par = params[1] as AryAddress;
                      var json = EndUserAddressData(
                        address1: addressTextCroller.text,
                        id: par.id,
                        enduserId: par.enduserId,
                        name: namecon.text,
                        telnumber: telTextCroller.text.replaceAll('-', ''),
                        type: addressEndUser!.type,
                        address2: "",
                        provinceName: provinTextCroller.text,
                        amphurName: districtTextCroller.text,
                        tumbonName: subdistricTextCroller.text,
                        postalcode: provinCodeTextCroller.text,
                        note: noteTextCroller.text,
                        status: useDefault == true ? '1' : '0',
                        provinceCode: provinceID!,
                        channel: 'app',
                        amphurCode: amphurID!,
                        tumbonCode: tumbonID!,
                      );
                      SuccessResponse? statusEdit =
                          await manageEnduserAddress(json);
                      if (statusEdit!.code == '100') {
                        successPopup(context);
                      } else {
                        errorPopup(context, statusEdit.message1);
                      }
                      break;
                    }
                  case "Add":
                    {
                      var json = EndUserAddressData(
                        address1: addressTextCroller.text,
                        id: "",
                        enduserId: "",
                        name: namecon.text,
                        telnumber: telTextCroller.text.replaceAll('-', ''),
                        type: addressEndUser!.type,
                        address2: "",
                        provinceName: provinTextCroller.text,
                        amphurName: districtTextCroller.text,
                        tumbonName: subdistricTextCroller.text,
                        postalcode: provinCodeTextCroller.text,
                        note: noteTextCroller.text,
                        status: useDefault == true ? '1' : '0',
                        provinceCode: provinceID!,
                        channel: 'app',
                        amphurCode: amphurID!,
                        tumbonCode: tumbonID!,
                      );
                      SuccessResponse? statusEdit =
                          await manageEnduserAddress(json);
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
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
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
                                // await Get.put(FetchAddressDropshipController())
                                //     .fetchDropshipAddress();
                                // Get.until((route) =>
                                Get.back();
                                Get.find<FetchCartEndUsersAddress>()
                                    .fetchEnduserAddress();
                                if (params[2] == "Edit") {
                                  Get.until((route) =>
                                      Get.currentRoute ==
                                      '/EndUserChangeAddress');
                                } else {
                                  Get.off(() => const EndUserChangeAddress());
                                }
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
    if (i == 3) {
      //? call หาที่อยู่
      Address? addressValue = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Searchaddress()));
      if (addressValue != null) {
        //? รับข้อมูลที่ได้เข้า textfield
        subdistricTextCroller.text = addressValue.tumbon;
        districtTextCroller.text = addressValue.amphur;
        provinTextCroller.text = addressValue.province;
        provinCodeTextCroller.text = addressValue.postCode;
        allAddressCroller.text =
            "${addressValue.province} ${addressValue.amphur} ${addressValue.tumbon} ${addressValue.postCode}";
        tumbonID = addressValue.tumbonID;
        amphurID = addressValue.amphurID;
        provinceID = addressValue.provinceID;
      }
      // print(addressValue);
    }
  }

  //? สไตล์ของช่องข้อความ
  InputDecoration textFieldstyle(Widget e) {
    return InputDecoration(
      // floatingLabelBehavior: FloatingLabelBehavior.never,
      label: e,
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
}
