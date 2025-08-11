// ? ตัวเลือกจัดส่ง
// import 'dart:developer';

// import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/cart/delivery_controller.dart';
// import '../../../../service/languages/multi_languages.dart';
// import '../cart_page/cart_change_delivery.dart';
// import '../cart_theme/cart_all_theme.dart';

//page แสดงตัวเลือกจัดส่งในหน้าสรุปรายการสินค้า
deliveryChange(context, double totalAmount) => GetBuilder<FetchDeliveryChange>(
      builder: (delivery) {
        return delivery.isDataLoading.value
            ? const SizedBox()
            : const SizedBox();
        // : MediaQuery(
        //     data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
        //     child: InkWell(
        //       onTap: () {
        //         // changeDeliver
        //         Get.to(
        //             transition: Transition.rightToLeft,
        //             () => ChangeDelivery(delivery, totalAmount));
        //       },
        //       child: delivery.isChange!.flagDelivery == 'Y'
        //           ? Column(
        //               children: [
        //                 Container(
        //                   color: const Color.fromRGBO(228, 243, 251, 1),
        //                   child: Padding(
        //                     padding: const EdgeInsets.symmetric(
        //                         horizontal: 30.0, vertical: 8),
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Row(
        //                           mainAxisAlignment:
        //                               MainAxisAlignment.spaceBetween,
        //                           children: [
        //                             Row(
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.start,
        //                               children: [
        //                                 Image.asset(
        //                                   'assets/images/cart/car.png',
        //                                   width: 40,
        //                                   scale: 1.5,
        //                                 ),
        //                                 Text(
        //                                   MultiLanguages.of(context)!
        //                                       .translate('choice_delivery'),
        //                                   style: setTextColordf,
        //                                 ),
        //                               ],
        //                             ),
        //                             Row(
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.end,
        //                               children: [
        //                                 Text(
        //                                   '${delivery.isChange!.detailDelivery![delivery.indexChange.value].price} ${MultiLanguages.of(context)!.translate('order_baht')}',
        //                                   style: TextStyle(
        //                                       fontWeight: boldText),
        //                                 ),
        //                                 Icon(
        //                                   Icons.arrow_forward_ios,
        //                                   color: theme_color_df,
        //                                 ),
        //                               ],
        //                             ),
        //                           ],
        //                         ),
        //                         Row(
        //                           mainAxisAlignment:
        //                               MainAxisAlignment.spaceAround,
        //                           children: [
        //                             Expanded(
        //                                 flex: 2,
        //                                 child: Column(
        //                                   crossAxisAlignment:
        //                                       CrossAxisAlignment.start,
        //                                   children: [
        //                                     Text(
        //                                       delivery
        //                                           .isChange!
        //                                           .detailDelivery![delivery
        //                                               .indexChange.value]
        //                                           .titleDelivery,
        //                                       style: TextStyle(
        //                                           color: theme_grey_text),
        //                                     ),
        //                                     Text(
        //                                       delivery
        //                                           .isChange!
        //                                           .detailDelivery![delivery
        //                                               .indexChange.value]
        //                                           .desDelivery,
        //                                       style: TextStyle(
        //                                           color: theme_grey_text),
        //                                     ),
        //                                   ],
        //                                 )),
        //                           ],
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             )
        //           : const SizedBox(),
        //     ),
        //   );
      },
    );
