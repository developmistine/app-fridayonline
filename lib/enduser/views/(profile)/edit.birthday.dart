// import 'package:fridayonline/enduser/components/appbar/apbar.master.dart';
// import 'package:fridayonline/enduser/controller/profile.ctr.dart';
// import 'package:fridayonline/enduser/models/profile/profile_data.dart';
// import 'package:fridayonline/enduser/widgets/dialog.dart';
// import 'package:fridayonline/homepage/theme/theme_color.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EditBirthdayScreen extends StatefulWidget {
//   @override
//   _EditBirthdayScreenState createState() => _EditBirthdayScreenState();
// }

// class _EditBirthdayScreenState extends State<EditBirthdayScreen> {
//   final ProfileCtl profileCtl = Get.put(ProfileCtl());
//   String gender = "";
//   String birthday = "";
//   String email = "";
//   String mobile = "";
//   String displayName = "";
//   String? selectedDay;
//   String? selectedMonth;
//   String? selectedYear;
//   String formattedDate = '';

//   // Generate lists for dropdown options
//   final List<String> days =
//       List.generate(31, (index) => (index + 1).toString());
//   final List<String> months =
//       List.generate(12, (index) => (index + 1).toString());
//   final List<String> years =
//       List.generate(100, (index) => (DateTime.now().year - index).toString());

//   void concatenateDate() {
//     if (selectedDay != null && selectedMonth != null && selectedYear != null) {
//       formattedDate = "$selectedYear-$selectedMonth-$selectedDay";
//       _saveUser();
//     }
//     // Get.snackbar("เกิดข้อผิดพลาด", "กรุณาระบุข้อมูลให้ครบถ้วน",
//     //     snackPosition: SnackPosition.TOP,
//     //     backgroundColor: Colors.red,
//     //     colorText: Colors.white);
//   }

//   @override
//   void initState() {
//     super.initState();

//     gender = profileCtl.profileData.value?.gender ?? '';
//     displayName = profileCtl.profileData.value?.displayName ?? '';
//     mobile = profileCtl.profileData.value?.mobile ?? '';
//     email = profileCtl.profileData.value?.email ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQuery.of(context)
//           .copyWith(textScaler: const TextScaler.linear(1.0)),
//       child: Theme(
//         data: Theme.of(context).copyWith(
//           elevatedButtonTheme: ElevatedButtonThemeData(
//               style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                   textStyle: GoogleFonts.notoSansThaiLooped())),
//           textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
//             Theme.of(context).textTheme,
//           ),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: appBarMasterEndUser('แก้ไขวันเกิด'),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 ElevatedButton(
//                     onPressed: () {
//                       _openDatePicker(context);
//                     },
//                     child: const Text('test')),
//                 // Day dropdown
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(4.0),
//                   ),
//                   child: DropdownButtonFormField<String>(
//                     value: selectedDay,
//                     decoration: const InputDecoration(
//                       labelText: 'วัน',
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
//                     ),
//                     icon: const Icon(Icons.keyboard_arrow_down),
//                     isExpanded: true,
//                     onChanged: (String? value) {
//                       setState(() {
//                         selectedDay = value;
//                       });
//                     },
//                     items: days.map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                 ),

//                 // Month dropdown
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(4.0),
//                   ),
//                   child: DropdownButtonFormField<String>(
//                     value: selectedMonth,
//                     decoration: const InputDecoration(
//                       labelText: 'เดือน',
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
//                     ),
//                     icon: const Icon(Icons.keyboard_arrow_down),
//                     isExpanded: true,
//                     onChanged: (String? value) {
//                       setState(() {
//                         selectedMonth = value;
//                       });
//                     },
//                     items: months.map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                 ),

//                 // Year dropdown
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 24.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(4.0),
//                   ),
//                   child: DropdownButtonFormField<String>(
//                     value: selectedYear,
//                     decoration: const InputDecoration(
//                       labelText: 'ปี',
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
//                     ),
//                     icon: const Icon(Icons.keyboard_arrow_down),
//                     isExpanded: true,
//                     onChanged: (String? value) {
//                       setState(() {
//                         selectedYear = value;
//                       });
//                     },
//                     items: years.map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                 ),

//                 // Submit button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50.0,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         concatenateDate();
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: theme_color_df,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4.0),
//                       ),
//                     ),
//                     child: const Text(
//                       'บันทึก',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _saveUser() {
//     birthday = formattedDate;

//     if (birthday.isNotEmpty) {
//       profileCtl.fetchUpdateUserName(
//           displayName, gender, birthday, mobile, email);
//       Get.snackbar("Success", "แก้ไขข้อมูลสำเร็จ",
//           icon: const Icon(
//             Icons.check,
//             color: Color.fromRGBO(255, 255, 255, 0),
//           ),
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white);
//     } else {
//       Get.snackbar("Error", "แก้ไขข้อมูลไม่สำเร็จ",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     }
//   }
// }
