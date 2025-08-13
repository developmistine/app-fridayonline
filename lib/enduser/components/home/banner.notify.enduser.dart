// import 'package:appfridayecommerce/enduser/components/shimmer/shimmer.card.dart';
// import 'package:appfridayecommerce/enduser/controller/enduser.home.ctr.dart';
// // import 'package:appfridayecommerce/enduser/views/(anonymous)/signin.dart';
// import 'package:appfridayecommerce/enduser/widgets/gap.dart';
// import 'package:appfridayecommerce/theme.dart';// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// final EndUserHomeCtr endUserHomeCtr = Get.find();

// class BannerNotify extends StatelessWidget {
//   const BannerNotify({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.grey[100],
//       child: Obx(() {
//         return !endUserHomeCtr.isLoadingBannerNotify.value
//             ? Column(
//                 children: [
//                   const Gap(height: 8),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: InkWell(
//                       onTap: () {
//                         // Get.find<ReviewEndUserCtr>()
//                         //     .fetchEndUserReivew(1015, 0, 6, 0);
//                         // Get.to(() => const ShowReviewProductSku());
//                       },
//                       child: Container(
//                           clipBehavior: Clip.antiAlias,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8)),
//                           width: Get.width,
//                           // child: Icon(Icons.abc)
//                           child: CachedNetworkImage(
//                               imageUrl:
//                                   endUserHomeCtr.bannerNoti!.data.contentImg)),
//                     ),
//                   ),
//                 ],
//               )
//             : Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   ShimmerCard(
//                     width: Get.width,
//                     height: 140,
//                     radius: 8,
//                   ),
//                   Icon(
//                     Icons.image,
//                     size: 48,
//                     color: themeColorDefault.withOpacity(0.2),
//                   )
//                 ],
//               );
//       }),
//     );
//   }
// }
