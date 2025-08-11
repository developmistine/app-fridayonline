// import 'package:fridayonline/enduser/controller/showproduct.category.ctr.dart';
// import 'package:fridayonline/enduser/views/(showproduct)/show.category.view.dart';
// import 'package:fridayonline/enduser/widgets/gap.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class B2cRelatedProduct extends StatefulWidget {
//   const B2cRelatedProduct({super.key});

//   @override
//   State<B2cRelatedProduct> createState() => _B2cRelatedProductState();
// }

// class _B2cRelatedProductState extends State<B2cRelatedProduct> {
//   List<String> product = [
//     "https://down-th.img.susercontent.com/file/th-11134258-7rasi-m7pzmfn4psd3f9_xhdpi@resize_w268_nl.webp",
//     "https://down-th.img.susercontent.com/file/th-11134258-7ras9-m803rauc40ll60_xhdpi@resize_w268_nl.webp",
//     "https://down-th.img.susercontent.com/file/th-11134258-7rasb-m81l20a7hts9bf_xhdpi@resize_w268_nl.webp",
//     "https://down-th.img.susercontent.com/file/th-11134258-7rasd-m5s9t528h1brbc_xhdpi@resize_w268_nl.webp",
//     "https://down-th.img.susercontent.com/file/a4cf659080a64d2e04d5ab80d94b5bb5_xhdpi@resize_w268_nl.webp"
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQuery.of(context)
//           .copyWith(textScaler: const TextScaler.linear(1)),
//       child: Column(
//         children: [
//           const Gap(
//             height: 8,
//           ),
//           Container(
//             padding: const EdgeInsets.all(
//               8,
//             ),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'สินค้าแนะนำสำหรับคุณ',
//                       style:
//                           TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Get.find<ShowProductCategoryCtr>()
//                             .fetchProductByCategoryId(2, "848".toString(), 0);
//                         Get.to(
//                             arguments: "สินค้าแนะนำสำหรับคุณ",
//                             () => const ShowProductCategory());
//                       },
//                       child: Row(
//                         children: [
//                           Text(
//                             'ดูเพิ่มเติม',
//                             style: TextStyle(
//                                 color: Colors.deepOrange.shade700,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w300),
//                           ),
//                           Icon(
//                             Icons.arrow_forward_ios_rounded,
//                             color: Colors.deepOrange.shade700,
//                             size: 10,
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: [
//                         ...product.map((e) {
//                           return Container(
//                             padding: const EdgeInsets.all(8),
//                             margin: const EdgeInsets.only(right: 4),
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: Colors.grey.shade300, width: 0.6)),
//                             width: 150,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Center(
//                                     child: CachedNetworkImage(
//                                         height: 150, imageUrl: e)),
//                                 Text(
//                                   e,
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(fontSize: 12),
//                                 ),
//                                 Text(
//                                   '฿800',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 13,
//                                       color: Colors.deepOrange.shade700),
//                                 )
//                               ],
//                             ),
//                           );
//                         })
//                       ],
//                     )),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
