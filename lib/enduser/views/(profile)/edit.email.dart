import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/widgets/dialog.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/service/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/profile.ctr.dart';

class EditEmail extends StatefulWidget {
  const EditEmail({super.key});

  @override
  State<EditEmail> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditEmail> {
  final ProfileCtl profileCtl = Get.put(ProfileCtl());
  late TextEditingController emailController;

  String gender = "";
  String birthday = "";
  String email = "";
  String mobile = "";
  String displayName = "";

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool isEmailValid(String email) {
    // Simple regex for email validation
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    emailController =
        TextEditingController(text: args["email"]?.toString() ?? "");

    gender = profileCtl.profileData.value?.gender ?? '';
    birthday = profileCtl.profileData.value?.birthDate.toString() ?? '';
    displayName = profileCtl.profileData.value?.displayName ?? '';
    mobile = profileCtl.profileData.value?.mobile ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                    textStyle: GoogleFonts.notoSansThaiLooped())),
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: appBarMasterEndUser('แก้ไขอีเมล'),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),
                        const SizedBox(height: 8),
                        TextFormField(
                            controller: emailController,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                                hintText: 'อีเมล',
                                prefixIcon: Icon(Icons.mail_outline),
                                prefixIconConstraints:
                                    BoxConstraints(minWidth: 35),
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide())),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[a-zA-Z0-9@._-]')),
                            ],
                            onChanged: (value) {
                              setState(() {});
                            },
                            validator:
                                Validators.email('รูปแบบอีเมลไม่ถูกต้อง')),
                      ],
                    ),
                  ),
                );
              }),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                width: Get.width,
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.grey.shade400,
                      elevation: 0,
                      backgroundColor: theme_color_df),
                  onPressed: emailController.text == ""
                      ? null
                      : () {
                          _saveUser(context);
                        },
                  child: const Text(
                    'บันทึก',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveUser(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      dialogAlert([
        const Icon(
          Icons.check,
          color: Colors.white,
          size: 40,
        ),
        Text(
          'บันทึกข้อมูลเรียบร้อย',
          style: GoogleFonts.notoSansThaiLooped(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ]);
      profileCtl.fetchUpdateUserName(
          displayName, gender, birthday, mobile, emailController.text);
      Future.delayed(const Duration(milliseconds: 1200), () {
        Get.back();
        Get.back();
      });
    } else {
      if (!Get.isDialogOpen!) {
        dialogAlert([
          const Icon(
            Icons.notification_important,
            color: Colors.white,
            size: 40,
          ),
          Text(
            'อีเมลไม่ถูกต้อง',
            style: GoogleFonts.notoSansThaiLooped(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ]);
        Future.delayed(const Duration(milliseconds: 1200), () {
          Get.back();
        });
      }
    }
  }
}
