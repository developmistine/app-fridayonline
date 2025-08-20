import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/services/authen/b2cauthen.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(other)/otp.verify.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/profile.ctr.dart';

class EditTelphoneNumber extends StatefulWidget {
  const EditTelphoneNumber({super.key});

  @override
  State<EditTelphoneNumber> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditTelphoneNumber> {
  final ProfileCtl profileCtl = Get.put(ProfileCtl());
  final ProfileOtpCtr otpCtl = Get.put(ProfileOtpCtr());
  late TextEditingController telNumController, telNumNotMaskedController;
  String displayName = "";
  String gender = "";
  String birthday = "";
  String email = "";
  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    telNumController =
        TextEditingController(text: args["mobile"]?.toString() ?? "");
    displayName = args["displayName"]?.toString() ?? "";

    gender = profileCtl.profileData.value?.gender ?? '';
    birthday = profileCtl.profileData.value?.birthDate.toString() ?? '';
    email = profileCtl.profileData.value?.email ?? '';
  }

  // String formatPhoneNumber(String phoneNumber) {
  //   if (phoneNumber.length < 10) return phoneNumber;
  //   return '*' * 6 + phoneNumber.substring(phoneNumber.length - 4);
  // }

  @override
  void dispose() {
    telNumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Theme(
          data: Theme.of(context).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle: GoogleFonts.ibmPlexSansThai())),
            textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: SafeArea(
            top: false,
            left: false,
            right: false,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: appBarMasterEndUser('แก้ไขเบอร์โทรศัพท์'),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Obx(() {
                  if (profileCtl.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        RichText(
                          text: TextSpan(
                            text: "เบอร์โทรศัพท์",
                            style: GoogleFonts.ibmPlexSansThai(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: themeColorDefault,
                            ),
                            children: [
                              TextSpan(
                                text: " *",
                                style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: telNumController,
                          style: const TextStyle(fontSize: 14),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10)
                          ],
                          decoration: const InputDecoration(
                            isCollapsed: true,
                            isDense: true,
                            hintText: 'xxx-xxx-xxxx',
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.length == 10) {
                              telNumController.text = formatPhoneNumber(value);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(themeColorDefault),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 12)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                          ),
                          onPressed: () {
                            _saveUser();
                          },
                          child: const Text(
                            'บันทึก',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveUser() async {
    String telNumber = telNumController.text.replaceAll('-', '');

    if (telNumber.isNotEmpty && isValidatePhoneNumbers(telNumber)) {
      if (otpCtl.remainingSeconds.value == 0 ||
          otpCtl.remainingSeconds.value == 60) {
        otpCtl.resetTimer();
        loadingProductStock(context);
        await b2cSentOtpService("edit_profile", telNumber).then((value) async {
          Get.back();
          if (value!.code == "100") {
            otpCtl.startTimer();
            await Get.to(
                    () => OtpVerify(phone: telNumber, type: 'edit_profile'))!
                .then((value) async {
              if (value == true) {
                profileCtl.fetchUpdateUserName(
                    displayName, gender, birthday, telNumber, email);
                dialogAlert([
                  Text(
                    'บันทึกข้อมูลสำเร็จ',
                    style: GoogleFonts.ibmPlexSansThai(
                        color: Colors.white, fontSize: 13),
                  )
                ]);
                await Future.delayed(const Duration(seconds: 1), () {
                  Get.back();
                });
                Get.back();
              }
            });
          } else {
            Get.snackbar('แจ้งเตือน', 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
                backgroundColor: Colors.red.withOpacity(0.8),
                colorText: Colors.white);
          }
        });
      } else {
        await Get.to(() => OtpVerify(phone: telNumber, type: 'edit_profile'))!
            .then((value) async {
          if (value == true) {
            profileCtl.fetchUpdateUserName(
                displayName, gender, birthday, telNumber, email);
            dialogAlert([
              Text(
                'บันทึกข้อมูลสำเร็จ',
                style: GoogleFonts.ibmPlexSansThai(
                    color: Colors.white, fontSize: 13),
              )
            ]);
            await Future.delayed(const Duration(seconds: 1), () {
              Get.back();
            });
            Get.back();
          }
        });
      }

      // profileCtl.fetchUpdateUserName(displayName, telNumber);
    } else {
      Get.snackbar("Error", "เบอร์โทรศัพท์ไม่ถูกต้อง",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}

bool isValidatePhoneNumbers(String phoneNumber) {
  final regex = RegExp(r'^\d{10}$');
  return regex.hasMatch(phoneNumber);
}
