// import 'package:fridayonline/enduser/components/shimmer/shimmer.card.dart';
// import 'package:fridayonline/enduser/controller/enduser.home.ctr.dart';
// import 'package:fridayonline/enduser/widgets/gap.dart';
// // import 'package:fridayonline/theme.dart';// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// final EndUserHomeCtr endUserHomeCtr = Get.find();

// class LiveEndUser extends StatelessWidget {
//   const LiveEndUser({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List<Color> colos = [
//       Colors.red,
//       Colors.blue,
//       Colors.green,
//       Colors.yellow,
//       Colors.purple
//     ];
//     return Obx(() {
//       return !endUserHomeCtr.isLoadingLive.value
//           ? Column(
//               children: [
//                 const Gap(
//                   height: 8,
//                 ),
//                 Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Friday Online Live',
//                               style: TextStyle(
//                                   color: themeRed,
//                                   fontWeight: FontWeight.bold)),
//                           ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: themeColorDefault),
//                               onPressed: () {},
//                               child: const Row(
//                                 children: [
//                                   Icon(Icons.notifications_active),
//                                   Text(
//                                     'แจ้งเตือนฉัน',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ))
//                         ],
//                       ),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         physics: const ClampingScrollPhysics(),
//                         child: Row(
//                           children: List.generate(colos.length,
//                               (index) => LiveItem(color: colos[index])),
//                         ),
//                       ),
//                     ])),
//               ],
//             )
//           : Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 physics: const ClampingScrollPhysics(),
//                 child: Row(
//                   children: [
//                     Row(
//                         children: List.generate(
//                             colos.length,
//                             (index) => Padding(
//                                   padding: const EdgeInsets.only(right: 8.0),
//                                   child: Stack(
//                                     alignment: Alignment.center,
//                                     children: [
//                                       const ShimmerCard(
//                                           width: 240, height: 180, radius: 8),
//                                       Icon(
//                                         Icons.live_tv_rounded,
//                                         size: 40,
//                                         color: themeColorDefault.withOpacity(0.2),
//                                       ),
//                                       Positioned(
//                                         top: 4,
//                                         left: 4,
//                                         child: Icon(
//                                           Icons.bar_chart_rounded,
//                                           size: 40,
//                                           color: themeColorDefault.withOpacity(0.2),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ))),
//                   ],
//                 ),
//               ),
//             );
//     });
//   }
// }

// class LiveItem extends StatelessWidget {
//   const LiveItem({super.key, required this.color});
//   final Color color;
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.bottomLeft,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           margin: const EdgeInsets.all(3),
//           width: 240,
//           height: 180,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.5),
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         Positioned(
//           top: 4,
//           left: 4,
//           // right: 0,
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 margin: const EdgeInsets.all(3),
//                 decoration: BoxDecoration(
//                   color: themeColorDefault,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: const Center(
//                     child: Text(
//                   'Live',
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                 )),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: const Center(
//                     child: Row(
//                   children: [
//                     Icon(
//                       Icons.remove_red_eye_outlined,
//                       size: 13,
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       '1,000',
//                       style:
//                           TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 )),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'Live Name ${color.value.toString()}',
//             style: const TextStyle(
//                 color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }
