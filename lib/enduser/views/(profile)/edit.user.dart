import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/profile.ctr.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditUser> {
  final ProfileCtl profileCtl = Get.put(ProfileCtl());
  late TextEditingController usernameController;
  String gender = "";
  String birthday = "";
  String email = "";
  String mobile = "";
  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    usernameController =
        TextEditingController(text: args["displayName"]?.toString() ?? "");

    gender = profileCtl.profileData.value?.gender ?? '';
    birthday = profileCtl.profileData.value?.birthDate.toString() ?? '';
    email = profileCtl.profileData.value?.email ?? '';
    mobile = profileCtl.profileData.value?.mobile ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.notoSansThaiLooped())),
          textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: appBarMasterEndUser('แก้ไขชื่อผู้ใช้งาน'),
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
                        text: const TextSpan(
                          text: "ชื่อผู้ใช้งาน",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                            color: Colors.blue,
                          ),
                          children: [
                            TextSpan(
                              text: " *",
                              style: TextStyle(
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
                        controller: usernameController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
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
                              WidgetStateProperty.all(theme_color_df),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 12)),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
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
    );
  }

  void _saveUser() {
    String displayName = usernameController.text;
    // String telNumber = profileCtl.profileData.value?.mobile ?? '';
    if (displayName.isNotEmpty) {
      profileCtl.fetchUpdateUserName(
          displayName, gender, birthday, mobile, email);
      Get.snackbar("Success", "แก้ไขข้อมูลสำเร็จ",
          icon: const Icon(
            Icons.check,
            color: Color.fromRGBO(255, 255, 255, 0),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } else {
      Get.snackbar("Error", "แก้ไขข้อมูลไม่สำเร็จ",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
