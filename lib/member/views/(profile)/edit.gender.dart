import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditGender extends StatefulWidget {
  const EditGender({super.key});

  @override
  State<EditGender> createState() => _EditGenderState();
}

class _EditGenderState extends State<EditGender> {
  final ProfileCtl profileCtl = Get.put(ProfileCtl());
  String selectedGender = '';
  String mobile = '';
  String disName = '';
  String email = '';
  String birthday = '';

  Map<String, dynamic> args = {};

  @override
  void initState() {
    super.initState();

    // Get arguments passed to this page
    args = Get.arguments as Map<String, dynamic>? ?? {};

    // Initailize gender from arguments if available
    if (args["gender"] != null && args["gender"].toString().isNotEmpty) {
      selectedGender = args["gender"];
    } else if (profileCtl.profileData.value?.gender != null &&
        profileCtl.profileData.value!.gender.isNotEmpty) {
      selectedGender = profileCtl.profileData.value!.gender;
    }
    mobile = args['mobile'];
    disName = args['displayName'];
    birthday = args['birthday'];
    email = args['email'];
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
                      borderRadius: BorderRadius.circular(8.0)),
                  textStyle: GoogleFonts.ibmPlexSansThai())),
          textTheme:
              GoogleFonts.ibmPlexSansThaiTextTheme(Theme.of(context).textTheme),
        ),
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: appBarMasterEndUser('แก้ไขเพศ'),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: RadioListTile(
                    title: const Text('ชาย', style: TextStyle(fontSize: 16)),
                    value: 'M',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                    activeColor: Colors.blue,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: RadioListTile<String>(
                    title: const Text('หญิง', style: TextStyle(fontSize: 16)),
                    value: 'F',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                    activeColor: Colors.blue,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
                // Other option
                Container(
                  margin: const EdgeInsets.only(top: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: RadioListTile<String>(
                    title: const Text('อื่น ๆ', style: TextStyle(fontSize: 16)),
                    value: 'O',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                    activeColor: Colors.blue,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                ),
                // Submit button
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle submission
                        _saveUser();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                      child: const Text(
                        'บันทึก',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveUser() {
    profileCtl
        .fetchUpdateUserName(disName, selectedGender, birthday, mobile, email)
        .then((success) {
      Get.snackbar("Success", "แก้ไขข้อมูลสำเร็จ",
          icon:
              const Icon(Icons.check, color: Color.fromRGBO(255, 255, 255, 0)),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    });
    // Get.back();
  }
}
