// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:async';
// import 'dart:convert';
import 'dart:math';

import 'package:fridayonline/controller/pro_filecontroller.dart';
import 'package:fridayonline/homepage/dialogalert/customalertdialogs.dart';
import 'package:fridayonline/homepage/login/anonymous_login.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:fridayonline/model/lead/lead_register_model.dart' as leadRegis;
import 'package:fridayonline/safearea.dart';
import 'package:fridayonline/service/address/address.dart';
import 'package:fridayonline/service/address/addresssearch.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:fridayonline/service/validators.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/app_controller.dart';
import '../../controller/cart/cart_controller.dart';
import '../../controller/cart/dropship_controller.dart';
import '../../controller/catelog/catelog_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../controller/lead/lead_controller.dart';
import '../../controller/notification/notification_controller.dart';
import '../../model/register/requestLeadData.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/lead/lead_project_service.dart';
import '../myhomepage.dart';
import '../pageactivity/cart/cart_theme/cart_all_theme.dart';
import '../theme/formatter_text.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:path/path.dart' as path;

// เป็นส่วนที่ระบบทำการ
class LeadRegister extends StatefulWidget {
  const LeadRegister(
      {super.key,
      this.urlCheckCustomer,
      this.urlCheckappmkt,
      required this.isB2c});
  final String? urlCheckCustomer;
  final String? urlCheckappmkt;
  final bool isB2c;
  @override
  State<LeadRegister> createState() => _LeadRegisterState();
}

class _LeadRegisterState extends State<LeadRegister> {
  final _formkey = GlobalKey<FormState>();
  bool isChecked = false;

// ประกกาศตัวแปรในการรับ Text ไว่ทั้งหมด 13 ตัว
  TextEditingController lmrepname = TextEditingController();
  TextEditingController lmsername = TextEditingController();
  TextEditingController lmnickname = TextEditingController();
  TextEditingController lmphonenumber = TextEditingController();
  TextEditingController lmhomenumber = TextEditingController();
  TextEditingController lmProjectCode = TextEditingController();
  TextEditingController lmaddress1 = TextEditingController();
  TextEditingController lmaddress2 = TextEditingController();
  TextEditingController lmtumbon = TextEditingController();
  TextEditingController lmamphur = TextEditingController();
  TextEditingController lmprovince = TextEditingController();
  TextEditingController lmpostcode = TextEditingController();
  TextEditingController lmdistice = TextEditingController();
  List<Body1> body = [];
  Address? newvalue;
  String? master;
  String? districtKey;
  ImageProvider? provider;
  io.File? imageFileList;
  String websiteId = "";
  int isChange = 0;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _myCallback() async {
    bool validate = _formkey.currentState!.validate();

    if (validate) {
      //? กรณีที่ไม่ระบุเขต
      if (isChecked) {
        setState(() {
          checkValidate(validate);
        });
      } else {
        const title = "ฟรายเดย์";
        const description = "กรุณาคลิกยอมรับเงื่อนไขค่ะ";
        alertCheckform(title, description);
      }
    }
  }

  Future<dynamic> alertCheckform(String titleFomrm, String descriptionForm) {
    return showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (context) {
        return alertText(titleFomrm, descriptionForm);
      },
    );
  }

  CustomAlertDialogs alertText(String title2, String description2) {
    return CustomAlertDialogs(title: title2, description: description2);
  }

  Future<bool> alertCheck() async {
    var alertCheck = await showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black26,
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          actionsPadding:
              const EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const SizedBox(
            width: 200,
            child: Text(
              'ฟรายเดย์',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          content: const Text('กรุณาระบุรหัสเจ้าหน้าที่ ที่แนะนำค่ะ'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(
                    'ระบุ',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    'ไม่ระบุ',
                    style: TextStyle(
                        color: Color(0xFFFD7F6B),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    return alertCheck;
  }

  openImagePicker() async {
    String? deleteOld;
    final ImagePicker pickerImage = ImagePicker();
    XFile? isPicker = await pickerImage.pickImage(
      source: ImageSource.gallery,
    );

    if (isPicker != null) {
      // printWhite(isPicker.path);
      String? filePath = isPicker.path;
      double limitSize =
          io.File(filePath.toString()).lengthSync() / (1024 * 1024);
      //? หาขนาดไฟล? MB
      // printWhite(limitSize);
      if (limitSize <= 5.00) {
        deleteOld = await getFileImage(filePath);
        final dir = await path_provider.getTemporaryDirectory();
        final file = io.File('${dir.absolute.path}/CacheImageUpload');
        final directory = io.Directory(file.path);

        if (await directory.exists()) {
          final files = directory.listSync();

          for (final file in files) {
            if (file is io.File && deleteOld != file.absolute.path) {
              // print(file.absolute.path);
              await file.delete();
            }
          }
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlertDialogs(
                title: 'ฟรายเดย์',
                description: 'ไฟล์ภาพที่มีขนาดเกิน 5 MB จะถูกคัดออก');
          },
        );
      }
    } else {
      final dir = await path_provider.getTemporaryDirectory();
      final file = io.File('${dir.absolute.path}/CacheImageUpload');
      final directory = io.Directory(file.path);
      if (await directory.exists()) {
        final files = directory.listSync();
        for (final file in files) {
          if (file is io.File) {
            // print(file.absolute.path);
            await file.delete();
          }
        }
      }
      setState(() {
        imageFileList = null;
      });
      // User canceled the picker
    }

    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['JPEG', 'JPG'],
    // );
    // String? deleteOld;
    // if (result != null) {
    //   List<String?> filePath = result.paths;
    //   int sizeInBytes = io.File(filePath[0].toString()).lengthSync();
    //   //? หาขนาดไฟล? MB
    //   var limitSize = sizeInBytes / (1024 * 1024);
    //   // for (var i = 0; i < limitSize.length; i++) {
    //   if (limitSize.toDouble() <= 5.00) {
    //     deleteOld = await getFileImage(filePath[0]!);
    //     final dir = await path_provider.getTemporaryDirectory();
    //     final file = io.File('${dir.absolute.path}/CacheImageUpload');
    //     final directory = io.Directory(file.path);
    //     if (await directory.exists()) {
    //       final files = directory.listSync();
    //       for (final file in files) {
    //         if (file is io.File && deleteOld != file.absolute.path) {
    //           // print(file.absolute.path);
    //           await file.delete();
    //         }
    //       }
    //     }
    //   } else {
    //     showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return const CustomAlertDialogs(
    //             title: 'ฟรายเดย์',
    //             description: 'ไฟล์ภาพที่มีขนาดเกิน 5 MB จะถูกคัดออก');
    //       },
    //     );
    //   }
    // } else {
    //   final dir = await path_provider.getTemporaryDirectory();
    //   final file = io.File('${dir.absolute.path}/CacheImageUpload');
    //   final directory = io.Directory(file.path);
    //   if (await directory.exists()) {
    //     final files = directory.listSync();
    //     for (final file in files) {
    //       if (file is io.File) {
    //         // print(file.absolute.path);
    //         await file.delete();
    //       }
    //     }
    //   }
    //   setState(() {
    //     imageFileList = null;
    //   });
    //   // User canceled the picker
    // }
  }

  Future<String> getFileImage(String filePick) async {
    final img = io.File(filePick);
    final dir = await path_provider.getTemporaryDirectory();
    var dateName = DateTime.now();
    var formatDate = DateFormat('mdy_HHmmss').format(dateName);
    final file = io.File('${dir.absolute.path}/CacheImageUpload');
    if (!file.existsSync()) {
      io.Directory('${dir.absolute.path}/CacheImageUpload').createSync();
    }
    final targetPath =
        '${dir.absolute.path}/CacheImageUpload/student-id_$formatDate.webp';
    // printWhite('target $targetPath');
    final imgFile = await testCompressAndGetFile(img, targetPath);
    // printWhite('file compress ${imgFile!.absolute.path}');
    if (imgFile == null) {
      return '';
    }
    safeSetState(() {
      provider = FileImage(imgFile);
      // printWhite('provider $provider');
    });
    return targetPath;
  }

  Future<io.File?> testCompressAndGetFile(
      io.File file, String targetPath) async {
    // printWhite('แปลงไฟล์ภาพเป็น webp');
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40,
      // minWidth: 1024,
      // minHeight: 1024,
      format: CompressFormat.webp,
    );
    setState(() {
      imageFileList = io.File(result!.path.toString());
      // printWhite(imageFileList!.path);
    });
    return null;
    // printWhite('covert image patch ${imageFileList!.path}');
    // return result;
  }

  static String getFileSizeString({required int bytes, int decimals = 1}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  LeadRegisterController ch = Get.find<LeadRegisterController>();

  @override
  void initState() {
    // print(widget.isB2c);
    super.initState();
    getDefault();
  }

  getDefault() async {
    await ch.lead_project();
    if (!ch.projectLoading.value) {
      setState(() {
        lmProjectCode.text = ch.leadProject!.leadProgram[0].text;
        websiteId = ch.leadProject!.leadProgram[0].id;
      });
    } else {
      lmProjectCode.text = '';
    }
  }

  bool isFormValid = false;

  void _checkFormValid() {
    final isValid = _formkey.currentState?.validate() ?? false;
    if (isFormValid != isValid) {
      setState(() {
        isFormValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    Get.find<LeadRegisterController>().show.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaProvider(
      child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: PreferredSize(
              preferredSize:
                  const Size.fromHeight(50.0), // here the desired height
              child: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (widget.isB2c == true) {
                      Get.back();
                      Get.back();
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Anonumouslogin()));
                    }
                  },
                ),
                backgroundColor: theme_color_df,
                title: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: const Text(
                    "สมัครสมาชิก",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'notoreg',
                    ),
                  ),
                ),
                centerTitle: true,
              )),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Form(
                  key: _formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: _checkFormValid,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // project(),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        introduce(),
                        const SizedBox(
                          height: 12,
                        ),
                        address(),
                        const SizedBox(
                          height: 10,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 18,
                                    margin: const EdgeInsets.only(
                                      right: 8,
                                    ),
                                    child: Checkbox(
                                        side: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade400),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isChecked = value!;
                                          });
                                        }),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          isChecked = !isChecked;
                                        });
                                      },
                                      child: Text("ยอมรับเงื่อนไขสมัครสมาชิก",
                                          style: GoogleFonts.notoSansThai(
                                              fontSize: 14,
                                              color: const Color(0xFF5A5A5A))),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        Get.to(
                                            transition: Transition.rightToLeft,
                                            () => WebViewFullScreen(
                                                mparamurl:
                                                    "$baseurl_yclub/yclub/policyandcondition/agreement.php"));
                                      },
                                      child: Text(
                                        'อ่านข้อตกลงการเป็นสมาชิก',
                                        style: GoogleFonts.notoSansThai(
                                          color: const Color(0xFF5A5A5A),
                                          fontSize: 13,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isFormValid ? _myCallback : null,
                    // onPressed:
                    //     _formkey.currentState != null ? _myCallback : null,
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: theme_color_df,
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    child: Text(
                      'ยืนยันข้อมูล',
                      style:
                          GoogleFonts.notoSansThai(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget project() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          lableText(title: 'โครงการ'),
          InkWell(
            onTap: () {
              popupChange();
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: Get.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300)),
                  child: Text(
                    lmProjectCode.text,
                  ),
                ),
                const Positioned(
                    top: 15,
                    right: 10,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget introduce() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ข้อมูลส่วนตัว',
              style: GoogleFonts.notoSansThai(
                  color: theme_color_df,
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          lableText(title: "ชื่อ"),
          TextFormField(
            controller: lmrepname,
            keyboardType: TextInputType.name,
            validator: Validators.required('กรุณาระบุชื่อผู้สมัคร'),
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('ชื่อ'),
          ),
          const SizedBox(
            height: 10,
          ),
          lableText(title: "นามสกุล"),
          TextFormField(
            controller: lmsername,
            keyboardType: TextInputType.name,
            validator: Validators.required('กรุณาระบุนามสกุลผู้สมัคร'),
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('นามสกุล'),
          ),
          const SizedBox(
            height: 10,
          ),
          lableText(title: "ชื่อเล่น"),
          TextFormField(
            controller: lmnickname,
            keyboardType: TextInputType.name,
            validator: Validators.required('กรุณาระบุชื่อเล่นผู้สมัคร'),
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('ชื่อเล่น'),
          ),
          const SizedBox(
            height: 10,
          ),
          lableText(title: "เบอร์โทรศัพท์มือถือ"),
          TextFormField(
            inputFormatters: [maskFormatterPhone],
            controller: lmphonenumber,
            keyboardType: TextInputType.phone,
            validator:
                Validators.required('กรุณาระบุเบอร์โทรศัพท์มือถือผู้สมัคร'),
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('เบอร์โทรศัพท์มือถือ'),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget address() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ที่อยู่สำหรับจัดส่งสินค้า',
              style: GoogleFonts.notoSansThai(
                  color: theme_color_df,
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            maxLines: 3,
            validator: Validators.required('กรุณาระบุที่อยู่ผู้สมัคร'),
            controller: lmaddress1,
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField(
                'กรอกที่อยู่ / เลขที่ห้อง / ตึก / หมู่บ้าน'),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: lmaddress2,
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('ถนน'),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    lableText(title: "ตำบล"),
                    TextFormField(
                      controller: lmtumbon,
                      readOnly: true,
                      onTap: () async {
                        // log('เพิ่มรายการที่อยู่');
                        newvalue = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const Searchaddress()));

                        setState(() {
                          if (newvalue != null) {
                            // log('Data :' + jsonEncode(Body));
                            lmtumbon.text = newvalue!.tumbon;
                            lmamphur.text = newvalue!.amphur;
                            lmprovince.text = newvalue!.province;
                            lmpostcode.text = newvalue!.postCode;
                          }
                        });
                      },
                      validator:
                          Validators.required('กรุณาระบุที่อยู่ผู้สมัคร'),
                      style:
                          const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
                      decoration: designTextFormField('ตำบล'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    lableText(title: "อำเภอ"),
                    TextFormField(
                      controller: lmamphur,
                      readOnly: true,
                      onTap: () async {
                        // log('เพิ่มรายการที่อยู่');
                        newvalue = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const Searchaddress()));

                        setState(() {
                          if (newvalue != null) {
                            // log('Data :' + jsonEncode(Body));
                            lmtumbon.text = newvalue!.tumbon;
                            lmamphur.text = newvalue!.amphur;
                            lmprovince.text = newvalue!.province;
                            lmpostcode.text = newvalue!.postCode;
                          }
                        });
                      },
                      validator:
                          Validators.required('กรุณาระบุที่อยู่ผู้สมัคร'),
                      style:
                          const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
                      decoration: designTextFormField('อำเภอ'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          lableText(title: "จังหวัด"),
          TextFormField(
            controller: lmprovince,
            readOnly: true,
            onTap: () async {
              // log('เพิ่มรายการที่อยู่');
              newvalue = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Searchaddress()));

              setState(() {
                if (newvalue != null) {
                  // log('Data :' + jsonEncode(Body));
                  lmtumbon.text = newvalue!.tumbon;
                  lmamphur.text = newvalue!.amphur;
                  lmprovince.text = newvalue!.province;
                  lmpostcode.text = newvalue!.postCode;
                }
              });
            },
            validator: Validators.required('กรุณาระบุที่อยู่ผู้สมัคร'),
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('จังหวัด'),
          ),
          const SizedBox(
            height: 8,
          ),
          lableText(title: "รหัสผู้แนะนำ"),
          TextFormField(
            keyboardType: TextInputType.number,
            maxLength: 4,
            controller: lmdistice,
            buildCounter: (context,
                    {required currentLength, maxLength, required isFocused}) =>
                null,
            style: const TextStyle(fontSize: 15, fontFamily: 'notoreg'),
            decoration: designTextFormField('รหัสผู้แนะนำ  (ไม่บังคับ)'),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Row lableText({required String title}) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.notoSansThai(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: const Color(0xFF5A5A5A)),
        ),
        const Text(
          ' *',
          style: TextStyle(fontSize: 14, color: Colors.red),
        ),
      ],
    );
  }

  popupChange() {
    // printWhite('show popup');
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        isDismissible: false,
        isScrollControlled: true,
        barrierColor: Colors.black87.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0))),
        context: context,
        builder: (builder) {
          return GetX<LeadRegisterController>(builder: (leadData) {
            if (!leadData.projectLoading.value) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 18.0, bottom: 18, left: 24, right: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 20),
                        child: Text('ตัวเลือกการสมัคร',
                            style:
                                TextStyle(fontWeight: boldText, fontSize: 24)),
                      ),
                      //? direcsale
                      StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Column(
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              itemCount:
                                  leadData.leadProject!.leadProgram.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isChange = index;
                                      // Get.find<LeadRegisterController>()
                                      //         .websiteID
                                      //         .value =
                                      websiteId = leadData
                                          .leadProject!.leadProgram[index].id;
                                      lmProjectCode.text = leadData
                                          .leadProject!.leadProgram[index].text;
                                    });
                                  },
                                  child: Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    surfaceTintColor: Colors.white,
                                    shadowColor: theme_grey_text,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: theme_color_df,
                                          width: 1.5,
                                        )),
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: isChange == index
                                            ? Icon(
                                                Icons.check_box,
                                                color: theme_color_df,
                                                size: 30,
                                              )
                                            : Icon(
                                                Icons.check_box_outline_blank,
                                                color: theme_color_df,
                                                size: 30,
                                              ),
                                        title: Text(
                                          leadData.leadProject!
                                              .leadProgram[index].text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: isChange == index
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: theme_color_df,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    fixedSize: const Size(
                                      200,
                                      50,
                                    ),
                                    backgroundColor: theme_color_df,
                                    side: BorderSide(color: theme_color_df)),
                                onPressed: () async {
                                  setState(() {
                                    // websiteId = leadData.websiteID.value;
                                    if (websiteId == '518') {
                                      Get.find<LeadRegisterController>()
                                          .show
                                          .value = true;
                                    } else {
                                      Get.find<LeadRegisterController>()
                                          .show
                                          .value = false;
                                    }
                                  });
                                  Get.back();
                                },
                                child: const Text(
                                  'เลือก ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ))
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 355,
                    child: Lottie.asset(
                        width: 180, 'assets/images/loading_line.json'),
                  ),
                ],
              );
            }
          });
        });
  }

  popupDetail() {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        // isDismissible: false,
        isScrollControlled: true,
        barrierColor: Colors.black87.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0))),
        context: context,
        builder: (builder) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 18.0, bottom: 18, left: 24, right: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0, top: 20),
                    child: Text(
                        'แนบรูปบัตรนักศึกษา\nเพื่อเป็นเอกสารในการเช้าร่วมโครงการ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18)),
                  ),
                  //? direcsale

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/lead/id-card.png',
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              elevation: 0,
                              fixedSize: Size(
                                Get.width / 1.2,
                                50,
                              ),
                              backgroundColor: theme_color_df,
                              side: BorderSide(color: theme_color_df)),
                          onPressed: () async {
                            Get.back();
                          },
                          child: const Text(
                            'ปิด',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  InputDecoration designTextFormField(String lstext) {
    return InputDecoration(
      suffixIcon: lstext == 'ชื่อโครงการ'
          ? Icon(
              Icons.arrow_drop_down,
              color: theme_color_df,
            )
          : null,
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
      hintStyle: TextStyle(color: Colors.grey.shade400),
      // isDense: true, // Added thisr
      enabled: lstext == 'ชื่อโครงการ' ? false : true,
      contentPadding: const EdgeInsets.only(top: 4, left: 12, bottom: 8),
    );
  }

  //? ทำการสมัคร
  checkValidate(validate) async {
    // log('55');
    String upload = '';
    if (validate) {
      body.clear();
      if (lmphonenumber.text.replaceAll(RegExp(r'[^0-9\.]'), '').length != 10) {
        alertCheckform('ฟรายเดย์', 'กรุณากรอกเบอร์โทรศัพท์ให้ครบ');
      } else {
        if (imageFileList != null) {
          upload = await uploadImage(imageFileList!);
        } else {
          upload = '';
        }
        leadRegis.Address leadAddress = leadRegis.Address(
          province: lmprovince.text,
          provinceCode: newvalue!.provinceID,
          amphur: lmamphur.text,
          amphurCode: newvalue!.amphurID,
          address: lmaddress1.text,
          road: lmaddress2.text,
          tambon: lmtumbon.text,
          tambonCode: newvalue!.tumbonID,
          postalCode: lmpostcode.text,
        );

        leadRegis.LeadRegisterModel body1 = leadRegis.LeadRegisterModel(
            name: lmrepname.text,
            surname: lmsername.text,
            nickname: lmnickname.text,
            phone1: lmphonenumber.text.replaceAll(RegExp(r'[^0-9\.]'), ''),
            phone2: lmhomenumber.text.replaceAll(RegExp(r'[^0-9\.]'), ''),
            address: leadAddress,
            typeRegister: '0',
            pdpaMkt: widget.urlCheckappmkt.toString(),
            pdpaCustomer: widget.urlCheckCustomer.toString(),
            pathImg: upload,
            tokenId: '',
            device: '',
            apptSourceId: 9647,
            linkId: lmdistice.text,
            webId: websiteId);
        // printWhite(upload);

        Get.find<LeadRegisterController>().lead_register_member(body1);
        //? สำเร็จแสดง popup
        showModalBottomSheet(
          enableDrag: false,
          isDismissible: false,
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0))),
          builder: (builder) {
            double width = MediaQuery.of(context).size.width;
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: PopScope(
                  onPopInvoked: (canpop) async => false,
                  child: GetBuilder<LeadRegisterController>(
                      builder: (dataResponse) {
                    if (dataResponse.isDataLoading.value) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 330,
                            child: Lottie.asset(
                                width: 180, 'assets/images/loading_line.json'),
                          ),
                        ],
                      );
                    } else {
                      if (dataResponse.leadRegis!.code == '100') {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Lottie.asset(
                                  width: 230,
                                  height: 230,
                                  'assets/images/cart/success_lottie.json'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  dataResponse.leadRegis!.message,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: width / 1.3,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: theme_color_df),
                                      onPressed: () async {
                                        if (widget.isB2c == true) {
                                          settingsPreferencesB2c(
                                            '1',
                                            dataResponse.leadRegis!.leadId,
                                            '',
                                            '',
                                            '',
                                            '5',
                                            dataResponse.leadRegis!.leadId,
                                            lmrepname.text,
                                            lmsername.text,
                                            lmphonenumber.text,
                                          );
                                          final dir = await path_provider
                                              .getTemporaryDirectory();
                                          final file = io.File(
                                              '${dir.absolute.path}/CacheImageUpload');
                                          final directory =
                                              io.Directory(file.path);
                                          if (await directory.exists()) {
                                            final files = directory.listSync();
                                            for (final file in files) {
                                              if (file is io.File) {
                                                // print(file.absolute.path);
                                                await file.delete();
                                              }
                                            }
                                          }
                                        } else {
                                          settingsPreferences(
                                            '1',
                                            dataResponse.leadRegis!.leadId,
                                            '',
                                            '',
                                            '',
                                            '3',
                                            dataResponse.leadRegis!.leadId,
                                            lmrepname.text,
                                            lmsername.text,
                                            lmphonenumber.text,
                                          );
                                          final dir = await path_provider
                                              .getTemporaryDirectory();
                                          final file = io.File(
                                              '${dir.absolute.path}/CacheImageUpload');
                                          final directory =
                                              io.Directory(file.path);
                                          if (await directory.exists()) {
                                            final files = directory.listSync();
                                            for (final file in files) {
                                              if (file is io.File) {
                                                // print(file.absolute.path);
                                                await file.delete();
                                              }
                                            }
                                          }
                                        }
                                      },
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        MultiLanguages.of(context)!
                                            .translate('alert_okay'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Lottie.asset(
                                  width: 160,
                                  height: 160,
                                  'assets/images/warning_red.json'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  dataResponse.leadRegis!.message,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: width / 1.3,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: theme_color_df),
                                      onPressed: () async {
                                        Get.back();
                                      },
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        MultiLanguages.of(context)!
                                            .translate('alert_okay'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }),
                ),
              );
            });
          },
        );
      }
    }
  }

  settingsPreferences(
      success,
      repSeq,
      repCode,
      repName,
      repTel,
      String typeUser,
      endUserID,
      enduserName,
      endusersurname,
      enduserTel) async {
    final SharedPreferences prefs = await _prefs;
    // ทำการ Get Data ออกมาทำการตรวจสอบก่อน
    // กรณีที่ทำการ Set Data
    prefs.setString("login", '1');
    prefs.setString("RepSeq", repSeq.toString());
    prefs.setString("RepCode", repCode);
    prefs.setString("RepName", repName);
    prefs.setString("RepTel", repTel);
    prefs.setString("UserType", typeUser);
    // กรณีที่ทำการจัดเก็บ EndUserID
    prefs.setString("EndUserID", endUserID.toString());
    prefs.setString("EnduserName", enduserName);
    prefs.setString("Endusersurname", endusersurname);
    prefs.setString("EnduserTel", enduserTel);
    // ระบบ Set กลับไปที่หน้า Page หลักก่อน  หรือจะให้ไปแสดงที่หน้าจอ Profile เลย
    Get.find<AppController>().setCurrentNavInget(4);
    Get.find<DraggableFabController>().draggable_Fab();
    Get.find<BannerController>().get_banner_data();
    Get.find<FavoriteController>().get_favorite_data();
    Get.find<SpecialPromotionController>().get_promotion_data();
    //  Get.find<SpecialDiscountController>().fetch_special_discount();
    Get.find<ProductHotItemHomeController>().get_product_hotitem_data();
    Get.find<ProductHotIutemLoadmoreController>().resetItem();
    Get.find<CatelogController>().get_catelog();
    Get.find<NotificationController>().get_notification_data();
    Get.find<FetchCartItemsController>().fetch_cart_items();
    Get.find<FetchCartDropshipController>().fetchCartDropship();
    Get.find<ProfileLeadController>().check_status_lead();
    Get.find<ProfileSpecialProjectController>().get_special_project_data();
    Get.find<KeyIconController>().get_keyIcon_data();
    Get.find<HomePointController>().get_home_point_data(false);
    Get.find<HomeContentSpecialListController>().get_home_content_data("");

    // ระบบ Set กลับไปที่หน้า Page หลักก่อน
    Get.offAll(() => MyHomePage(
          typeView: 'fromLead',
        ));
  }

  settingsPreferencesB2c(
      success,
      repSeq,
      repCode,
      repName,
      repTel,
      String typeUser,
      endUserID,
      enduserName,
      endusersurname,
      enduserTel) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("login", '1');
    prefs.setString("RepSeq", repSeq.toString());
    prefs.setString("RepCode", repCode);
    prefs.setString("RepName", repName);
    prefs.setString("RepTel", repTel);
    prefs.setString("UserType", typeUser);
    prefs.setString("EndUserID", endUserID.toString());
    prefs.setString("EnduserName", enduserName);
    prefs.setString("Endusersurname", endusersurname);
    prefs.setString("EnduserTel", enduserTel);

    Get.find<AppController>().setCurrentNavIngetB2c(3);
    Get.find<ProfileLeadController>().check_status_lead();
    // ระบบ Set กลับไปที่หน้า Page หลักก่อน
    Get.offAllNamed('/EndUserHome', parameters: {'changeView': "3"});
  }
}

extension _StateExtension on State {
  /// [setState] when it's not building, then wait until next frame built.
  FutureOr<void> safeSetState(FutureOr<dynamic> Function() fn) async {
    await fn();
    if (mounted &&
        !context.debugDoingBuild &&
        context.owner?.debugBuilding == false) {
      // ignore: invalid_use_of_protected_member
      setState(() {});
    }
    final Completer<void> completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      completer.complete();
    });
    return completer.future;
  }
}
