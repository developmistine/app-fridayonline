// import 'package:fridayonline/homepage/theme/theme_color.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../model/check_information/enduser/enduser_check_information.dart';
// import '../../../service/languages/multi_languages.dart';
// // import '../../widget/appbarmaster.dart';

// class EndUserCheckInformationDetail extends StatelessWidget {
//   const EndUserCheckInformationDetail({Key? key, required this.dataHeader})
//       : super(key: key);
//   final Header dataHeader;
//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           iconTheme: const IconThemeData(color: Colors.white),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//           backgroundColor: theme_color_df,
//           centerTitle: true,
//           title: Text(MultiLanguages.of(context)!.translate('title_order_info'),
//               style: const TextStyle(color: Colors.white, fontSize: 15)),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
//           child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: dataHeader.listdetail.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.only(top: 10.0),
//                 child: Container(
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade200),
//                     // boxShadow: [
//                     //   BoxShadow(
//                     //     color: Colors.grey.withOpacity(0.2),
//                     //     spreadRadius: 0.5,
//                     //     // blurRadius: 7,
//                     //     offset:
//                     //         const Offset(0, 3), // changes position of shadow
//                     //   ),
//                     // ],
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(22),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 flex: 3,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     // !v16
//                                     Text(
//                                       'รหัสสินค้า ${dataHeader.listdetail[index].billCode} (รอบการขาย ${dataHeader.listdetail[index].billCamp})',
//                                     ),
//                                     // Text(
//                                     //   'รหัสสินค้า ${dataHeader.listdetail[index].billCode} (รอบการ ${dataHeader.listdetail[index].billCamp})',
//                                     // ),
//                                     Text(dataHeader.listdetail[index].billDesc,
//                                         style: const TextStyle(
//                                             color: Colors.grey)),
//                                     Text(
//                                       'จำนวน ${dataHeader.listdetail[index].qty} ชิ้น ราคารวม ${NumberFormat.decimalPattern().format(double.parse(dataHeader.listdetail[index].amount))} บาท',
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 1,
//                                 child: CachedNetworkImage(
//                                   imageUrl:
//                                       dataHeader.listdetail[index].pathImg,
//                                   fit: BoxFit.fill,
//                                   alignment: Alignment.center,
//                                   height: 100,
//                                   width: 100,
//                                 ),
//                               )
//                             ]),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         bottomNavigationBar: SizedBox(
//           height: 160,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 height: 60,
//                 color: const Color.fromARGB(255, 244, 243, 243),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('จำนวน ${dataHeader.footer[0].items} รายการ',
//                               style: const TextStyle(fontSize: 16)),
//                           Text(
//                               'รวมเป็นเงิน ${NumberFormat.decimalPattern().format(double.parse(dataHeader.footer[0].totalall))} บาท',
//                               style: const TextStyle(fontSize: 16))
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                               'ใช้สตาร์รีวอร์ด ${dataHeader.footer[0].stradiscount} ดวง',
//                               style: const TextStyle(fontSize: 16)),
//                           Text(
//                               '${NumberFormat.decimalPattern().format(double.parse(dataHeader.footer[0].couponDiscount))} บาท',
//                               style: const TextStyle(fontSize: 16))
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 color: const Color.fromARGB(255, 108, 205, 251),
//                 height: 100,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             'ยอดชำระหลังหักส่วนลด ${NumberFormat.decimalPattern().format(double.parse(dataHeader.footer[0].totalbalance))} บาท',
//                             style: const TextStyle(fontSize: 18),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             'ดาวที่จะได้ในรอบนี้ ${dataHeader.footer[0].straRecive} ดวง',
//                             style: const TextStyle(fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
