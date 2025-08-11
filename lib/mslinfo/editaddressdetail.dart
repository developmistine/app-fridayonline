// import 'dart:developer';

import 'package:fridayonline/homepage/login/widgetsetprofilerheader.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/mslinfo/confirmotpeditaddress.dart';
import 'package:fridayonline/mslinfo/editaddress.dart';
import 'package:fridayonline/service/address/address.dart';
import 'package:fridayonline/service/address/addresssearch.dart';
// import 'package:fridayonline/service/address/serviceaddress.dart';
import 'package:fridayonline/service/validators.dart';
import 'package:flutter/material.dart';

class editaddressdetail extends StatefulWidget {
  final String? lsoption;

  const editaddressdetail(this.lsoption, {super.key});

  @override
  State<editaddressdetail> createState() => _editaddressdetailState();
}

// แก้ไขเพิ่มเติม
class _editaddressdetailState extends State<editaddressdetail> {
  _editaddressdetailState();

  final _formkey = GlobalKey<FormState>();
  String? option = '0';
  String? optiondetail = '';

  // ตัวดำเนินการในส่วนของ
  String? repCode = '';
  String? repSeq = '';
  String? address = '';
  String? tumbon = '';
  String? tumbonID = '0';
  String? amphur = '';
  String? amphurID = '0';
  String? province = '';
  String? provinceID = '0';
  String? postCode = '00000';

  // กรณีที่ทำการ SET Controller ของ Text
// ประกกาศตัวแปรในการรับ Text ไว่ทั้งหมด 13 ตัว
  TextEditingController lmaddress1 = TextEditingController();
  TextEditingController lmtumbon = TextEditingController();
  TextEditingController lmamphur = TextEditingController();
  TextEditingController lmprovince = TextEditingController();
  TextEditingController lmpostcode = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      option = widget.lsoption;
      //log(option!);
      if (option == "1") {
        optiondetail = " : (เฉพาะรอบนี้)";
      } else if (option == "2") {
        optiondetail = " : (ถาวร)";
      }
    });
  }

  void _myCallback() async {
    bool validate = _formkey.currentState!.validate();
    print(option.toString());
    if (validate) {
      // ส่วนที่ดำเนินการ
      // กรณีที่ทำการ POPUP ไปที่ส่วนการ
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmOTPAddress(
                  option.toString(),
                  lmaddress1.text,
                  tumbon,
                  tumbonID,
                  amphur,
                  amphurID,
                  province,
                  provinceID,
                  postCode)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const EditAddress())),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        centerTitle: true,
        backgroundColor: theme_color_df,
        title: const Text(
          'แก้ไขที่อยู่ในการจัดส่ง',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'notoreg',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
              child: Column(
                children: [
                  settext('แก้ไขที่อยู่จัดส่งสินค้า $optiondetail'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(
                          'ที่อยู่สำหรับจัดส่งสินค้า',
                          style: TextStyle(fontSize: 15, fontFamily: 'notoreg'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: TextFormField(
                          maxLines: 3,
                          validator:
                              Validators.required('กรุณาระบุที่อยู่ผู้สมัคร'),
                          controller: lmaddress1,
                          style: const TextStyle(
                              fontSize: 15, fontFamily: 'notoreg'),
                          decoration: designtexthint(
                              'บ้านเลขที่ / ชื่ออาคาร / หมู่บ้าน / ตรอก / ซอย / หมู่ที่ / ถนนเท่านั้น**'),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: lmtumbon,
                          readOnly: true,
                          onTap: () async {
                            // log('เพิ่มรายการที่อยู่');

                            Address? newvalue = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        const Searchaddress()));

                            setState(() {
                              if (newvalue != null) {
                                //log('Data :' + newvalue.name);
                                lmtumbon.text = newvalue.tumbon;
                                lmamphur.text = newvalue.amphur;
                                lmprovince.text = newvalue.province;
                                lmpostcode.text = newvalue.postCode;

                                // ส่วนที่ทำการ SET DATA เพื่อที่จะทำการ ก็บข้อมูลต่างๆ
                                tumbon = newvalue.tumbon;
                                tumbonID = newvalue.tumbonID;
                                amphur = newvalue.amphur;
                                amphurID = newvalue.amphurID;
                                province = newvalue.province;
                                provinceID = newvalue.provinceID;
                                postCode = newvalue.postCode;
                              }
                            });
                          },
                          validator: Validators.required('กรุณาระบุตำบล'),
                          style: const TextStyle(
                              fontSize: 15, fontFamily: 'notoreg'),
                          decoration: designTextFormField(
                              'ตำบล'), // designtexthint('ตำบล'),
                        )),
                        const Text(
                          ' * ',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: lmamphur,
                          readOnly: true,
                          onTap: () async {
                            // log('เพิ่มรายการที่อยู่');
                            Address? newvalue = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        const Searchaddress()));

                            setState(() {
                              if (newvalue != null) {
                                // log('Data :' + newvalue.name);
                                lmtumbon.text = newvalue.tumbon;
                                lmamphur.text = newvalue.amphur;
                                lmprovince.text = newvalue.province;
                                lmpostcode.text = newvalue.postCode;

                                // ส่วนที่ทำการ SET DATA เพื่อที่จะทำการ ก็บข้อมูลต่างๆ
                                tumbon = newvalue.tumbon;
                                tumbonID = newvalue.tumbonID;
                                amphur = newvalue.amphur;
                                amphurID = newvalue.amphurID;
                                province = newvalue.province;
                                provinceID = newvalue.provinceID;
                                postCode = newvalue.postCode;
                              }
                            });
                          },
                          validator: Validators.required('กรุณาระบุอำเภอ'),
                          style: const TextStyle(
                              fontSize: 15, fontFamily: 'notoreg'),
                          decoration: designTextFormField(
                              'อำเภอ'), // designtexthint('ตำบล'),
                        )),
                        const Text(
                          ' * ',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: lmprovince,
                          readOnly: true,
                          onTap: () async {
                            //log('เพิ่มรายการที่อยู่');
                            Address? newvalue = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        const Searchaddress()));

                            setState(() {
                              if (newvalue != null) {
                                // log('Data :' + newvalue.name);
                                lmtumbon.text = newvalue.tumbon;
                                lmamphur.text = newvalue.amphur;
                                lmprovince.text = newvalue.province;
                                lmpostcode.text = newvalue.postCode;

                                // ส่วนที่ทำการ SET DATA เพื่อที่จะทำการ ก็บข้อมูลต่างๆ
                                tumbon = newvalue.tumbon;
                                tumbonID = newvalue.tumbonID;
                                amphur = newvalue.amphur;
                                amphurID = newvalue.amphurID;
                                province = newvalue.province;
                                provinceID = newvalue.provinceID;
                                postCode = newvalue.postCode;
                              }
                            });
                          },
                          validator: Validators.required('กรุณาระบุจังหวัด'),
                          style: const TextStyle(
                              fontSize: 15, fontFamily: 'notoreg'),
                          decoration: designTextFormField(
                              'จังหวัด'), // designtexthint('ตำบล'),
                        )),
                        const Text(
                          ' * ',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: lmpostcode,
                          readOnly: true,
                          onTap: () async {
                            //log('เพิ่มรายการที่อยู่');
                            Address? newvalue = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        const Searchaddress()));

                            setState(() {
                              if (newvalue != null) {
                                // log('Data :' + newvalue.name);
                                lmtumbon.text = newvalue.tumbon;
                                lmamphur.text = newvalue.amphur;
                                lmprovince.text = newvalue.province;
                                lmpostcode.text = newvalue.postCode;

                                // ส่วนที่ทำการ SET DATA เพื่อที่จะทำการ ก็บข้อมูลต่างๆ
                                tumbon = newvalue.tumbon;
                                tumbonID = newvalue.tumbonID;
                                amphur = newvalue.amphur;
                                amphurID = newvalue.amphurID;
                                province = newvalue.province;
                                provinceID = newvalue.provinceID;
                                postCode = newvalue.postCode;
                              }
                            });
                          },
                          validator:
                              Validators.required('กรุณาระบุรหัสไปรษณีย์'),
                          style: const TextStyle(
                              fontSize: 15, fontFamily: 'notoreg'),
                          decoration: designTextFormField(
                              'รหัสไปรษณีย์'), // designtexthint('ตำบล'),
                        )),
                        const Text(
                          ' * ',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextButton(
          onPressed: _myCallback,
          style: ElevatedButton.styleFrom(
              backgroundColor: theme_color_df,
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              textStyle: const TextStyle(fontSize: 15, fontFamily: 'notoreg')),
          child: const Text(
            'ยืนยันข้อมูล',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontFamily: 'notoreg'),
          ),
        ),
      ),
    );
  }
}

InputDecoration designtexthint(String lstext) {
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
    hintText: lstext,
    hintStyle: const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
    isDense: true, // Added this
  );
}

InputDecoration designTextFormField(String lstext) {
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
    labelText: lstext,
    labelStyle: const TextStyle(fontSize: 14, fontFamily: 'notoreg'),
    isDense: true, // Added this
  );
}
