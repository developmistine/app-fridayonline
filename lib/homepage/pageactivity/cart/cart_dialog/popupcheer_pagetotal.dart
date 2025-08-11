//? popup up cheer
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../../../controller/cart/cart_controller.dart';
// import '../../../../model/cart/get_ms_cart_info..dart';
import '../../../../service/cart/popup_cart/insert_log_service.dart';
import '../../../theme/theme_color.dart';
import '../cart_theme/cart_all_theme.dart';
import 'total_confirm_dialog.dart';

showPopupCheerPageTotal(
    BuildContext ctx,
    deliveryData,
    totalItems,
    totalAmount,
    totalDiscount,
    couponDiscountID,
    popupData,
    controller,
    dropship,
    typeUser,
    infoAddress,
    endUserAddress) async {
  showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0)),
            titlePadding: const EdgeInsets.all(0),
            title: MediaQuery(
              data: MediaQuery.of(ctx)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Container(
                height: 80,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(41, 0, 0, 0),
                      offset: Offset(0.0, 4.0),
                      blurRadius: 1,
                      spreadRadius: 0.8,
                    ), //BoxShadow
                  ],
                  color: theme_color_df,
                ),
                child: Center(
                    child: Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                )),
              ),
            ),
            content: MediaQuery(
              data: MediaQuery.of(ctx)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    popupData.textMessage![0].textHeader,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: boldText, fontSize: 22),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    popupData.textMessage![0].textBody1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: boldText,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    popupData.textMessage![0].textFooter,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme_color_df),
                        onPressed: () async {
                          Get.back();
                          if (typeUser == '2') {
                            saveOrderTotal(
                                ctx,
                                controller,
                                dropship,
                                deliveryData,
                                totalItems,
                                totalDiscount,
                                couponDiscountID,
                                totalAmount,
                                typeUser,
                                infoAddress);
                          } else {
                            saveOrderTotalEndUser(
                                ctx,
                                controller,
                                dropship,
                                deliveryData,
                                totalItems,
                                totalDiscount,
                                couponDiscountID,
                                totalAmount,
                                typeUser,
                                infoAddress!,
                                endUserAddress);
                          }

                          await insertLogEventCovid(
                              popupData.projectCode, totalAmount, '102', '2');
                        },
                        child: Text(
                          popupData.action![0].action1,
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      Get.back(closeOverlays: true, result: false);
                      await insertLogEventCovid(
                          popupData.projectCode, totalAmount, '101', 2);
                      print(
                          'media ${controller.itemsCartList!.cardHeader.carddetail[0].media}');
                      print('กลับไปยังหน้าเลือกสินค้า');
                    },
                    child: Text(
                      popupData.action![0].action2,
                      style: TextStyle(color: theme_grey_text),
                    ),
                  ),
                ],
              ),
            ),
          ));
}
