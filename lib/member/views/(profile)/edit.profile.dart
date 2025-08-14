import 'dart:io';

import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/utils/format.dart';
// import 'package:fridayonline/enduser/views/(profile)/edit.birthday.dart';
import 'package:fridayonline/member/views/(profile)/edit.email.dart';
import 'package:fridayonline/member/views/(profile)/edit.gender.dart';
import 'package:fridayonline/member/views/(profile)/edit.telphoneNum.dart';
import 'package:fridayonline/member/views/(profile)/edit.user.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/profile.ctr.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileCtl profileCtl = Get.put(ProfileCtl());
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  var urlImage = '';
  var sex = '';

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // Upload the new profile image to the server
      await profileCtl.updateProfileImage(_selectedImage!);
    }
  }

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    urlImage = args["image"]?.toString() ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    profileCtl.selectedDay = (DateTime.now().day).obs; // วันที่ปัจจุบัน
    profileCtl.selectedMonth = (DateTime.now().month).obs; // เดือนปัจจุบัน
    profileCtl.selectedYear =
        (DateTime.now().year + 543).obs; // เริ่มต้นด้วย พ.ศ.
  }

  // ฟังก์ชั่นเปิด Dialog สำหรับเลือกวัน เดือน ปี
  openDatePicker(BuildContext context) {
    int tempDay = profileCtl.selectedDay.value;
    int tempMonth = profileCtl.selectedMonth.value;
    int tempYear = profileCtl.selectedYear.value;
    return Get.bottomSheet(
      StatefulBuilder(builder: (context, StateSetter setState) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1)),
          child: Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => Get.back(result: null),
                            icon: const Icon(Icons.close_sharp)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: themeColorDefault,
                                elevation: 0,
                                shape: const BeveledRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)))),
                            onPressed: () {
                              var dateValid = profileCtl.isDateValid();
                              if (!dateValid) {
                                dialogAlert([
                                  const Icon(
                                    Icons.notification_important,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  Text(
                                    'ข้อมูลวันเกิดไม่ถูกต้อง!',
                                    style: GoogleFonts.notoSansThaiLooped(
                                        color: Colors.white, fontSize: 14),
                                  )
                                ]);
                                Future.delayed(const Duration(seconds: 2), () {
                                  Get.back();
                                });
                                return;
                              }
                              var day = profileCtl.selectedDay.value;
                              var month = profileCtl.selectedMonth.value;
                              var year = profileCtl.selectedYear.value -
                                  543; // ปี พ.ศ.

                              var gender =
                                  profileCtl.profileData.value?.gender ?? '';
                              var displayName =
                                  profileCtl.profileData.value?.displayName ??
                                      '';
                              var mobile =
                                  profileCtl.profileData.value?.mobile ?? '';
                              var email =
                                  profileCtl.profileData.value?.email ?? '';
                              var birthDay =
                                  "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
                              profileCtl
                                  .fetchUpdateUserName(displayName, gender,
                                      birthDay, mobile, email)
                                  .then((value) {
                                profileCtl.fetchProfile();
                              });
                              Get.back();
                            },
                            child: Text(
                              'บันทึก',
                              style: GoogleFonts.notoSansThaiLooped(),
                            ))
                      ],
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 200,
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem: tempDay - 1),
                            itemExtent: 40,
                            looping: true,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                tempDay = profileCtl.days[index];
                                profileCtl.selectedDay.value = tempDay;
                                profileCtl.updateDays();
                              });
                            },
                            children: profileCtl.days
                                .map((d) => Center(child: Text('$d')))
                                .toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 200,
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem: tempMonth - 1),
                            itemExtent: 40,
                            looping: true,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                tempMonth = profileCtl.months.indexWhere(
                                    (element) =>
                                        element == profileCtl.months[index]);
                                profileCtl.selectedMonth.value = tempMonth + 1;
                                profileCtl.updateDays();
                              });
                            },
                            children: profileCtl.months
                                .map((m) => Center(child: Text(m)))
                                .toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 200,
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem:
                                    profileCtl.years.indexOf(tempYear)),
                            itemExtent: 40,
                            looping: true,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                tempYear = profileCtl.years[index];
                                profileCtl.selectedYear.value = tempYear;
                                profileCtl.updateDays();
                              });
                            },
                            children: profileCtl.years
                                .map((y) => Center(child: Text('$y')))
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
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
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: appBarMasterEndUser('รายละเอียดผู้ใช้งาน'),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Obx(() {
              if (profileCtl.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              final userName = profileCtl.profileData.value?.displayName ?? '';
              final mobile =
                  profileCtl.profileData.value?.mobile.isEmpty == true
                      ? 'เพิ่ม'
                      : (profileCtl.profileData.value?.mobile ?? 'เพิ่ม');

              final gender =
                  profileCtl.profileData.value?.gender.isEmpty == true
                      ? 'เพิ่ม'
                      : (profileCtl.profileData.value?.gender ?? 'เพิ่ม');

              final genderMap = {
                'M': 'ชาย',
                'F': 'หญิง',
                'O': 'อื่นๆ',
              };
              sex = genderMap[gender] ?? '';

              final email = profileCtl.profileData.value?.email == ""
                  ? 'เพิ่ม'
                  : formatEmailHidden(profileCtl.profileData.value!.email);
              String formattedEmail = email;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: themeColorDefault, width: 1),
                        ),
                        child: ClipOval(
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: _pickImage, // Open image picker on tap
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: _selectedImage != null
                                      ? Image.file(
                                          _selectedImage!,
                                          width: 94,
                                          height: 94,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          profileCtl.profileData.value?.image
                                                      .isNotEmpty ==
                                                  true
                                              ? profileCtl
                                                  .profileData.value!.image
                                              : 'assets/images/profileimg/user.png',
                                          width: 94,
                                          height: 94,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                                'assets/images/profileimg/user.png',
                                                width: 94,
                                                height: 94);
                                          },
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(181, 90, 90, 90),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(70),
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: const Center(
                                    child: Text(
                                      'แก้ไข',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.black12,
                            width: 0,
                          ),
                          bottom: BorderSide(
                            color: Colors.black12,
                            width: 0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: const Text(
                          "ชื่อผู้ใช้งาน",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14.0,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        onTap: () async {
                          var profile = profileCtl.profileData.value;
                          var result =
                              await Get.to(() => const EditUser(), arguments: {
                            "displayName": profile?.displayName,
                            "mobile": profile?.mobile,
                            "gender": profile?.gender,
                            "birthday": profile?.birthDate,
                            "email": profile?.email
                          })?.then((result) {
                            profileCtl.fetchProfile();
                          });

                          // If result is returned, refresh profile data
                          if (result == true) {
                            profileCtl.fetchProfile();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.black12,
                            width: 0,
                          ),
                          bottom: BorderSide(
                            color: Colors.black12,
                            width: 0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: const Text(
                          "เพศ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              sex,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              size: 14.0,
                              Icons.arrow_forward_ios,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                        onTap: () async {
                          var profile = profileCtl.profileData.value;
                          var result = await Get.to(() => const EditGender(),
                              arguments: {
                                "displayName": profile?.displayName,
                                "mobile": profile?.mobile,
                                "gender": profile?.gender,
                                "birthday": profile?.birthDate.toString(),
                                "email": profile?.email
                              })?.then((result) {
                            profileCtl.fetchProfile();
                          });

                          // If result is returned, refresh profile data
                          if (result == true) {
                            profileCtl.fetchProfile();
                          }
                        },
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.black12,
                            width: 0,
                          ),
                          bottom: BorderSide(
                            color: Colors.black12,
                            width: 0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: const Text(
                          "วันเกิด",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              profileCtl.profileData.value!.birthDate == ""
                                  ? "เพิ่ม"
                                  : formatBirthdayHidden(
                                      profileCtl.profileData.value!.birthDate),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              size: 14.0,
                              Icons.arrow_forward_ios,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                        onTap: () async {
                          await openDatePicker(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                            width: 0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: const Text(
                          "เบอร์โทรศัพท์",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formatTelHidden(mobile),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              size: 14.0,
                              Icons.arrow_forward_ios,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                        onTap: () async {
                          var profile = profileCtl.profileData.value;
                          var result = await Get.to(
                              () => const EditTelphoneNumber(),
                              arguments: {
                                "mobile": profile?.mobile,
                                "displayName": profile?.displayName,
                              })?.then((result) {
                            profileCtl.fetchProfile();
                          });

                          // If result is returned, refresh profile data
                          if (result == true) {
                            profileCtl.fetchProfile();
                          }
                        },
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                            width: 0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: const Text(
                          "อีเมล",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formattedEmail,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14.0,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                        onTap: () async {
                          var profile = profileCtl.profileData.value;
                          var result =
                              await Get.to(() => const EditEmail(), arguments: {
                            "email": profile?.email,
                          })?.then((result) {
                            profileCtl.fetchProfile();
                          });

                          // If result is returned, refresh profile data
                          if (result == true) {
                            profileCtl.fetchProfile();
                          }
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
