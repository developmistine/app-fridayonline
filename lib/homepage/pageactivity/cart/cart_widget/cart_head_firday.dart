// ? widget ส่วนหัวตระกร้า friday
import 'package:fridayonline/controller/cart/cart_controller.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/model/cart/cart_getItems.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/cart/dropship_controller.dart';

//? check widget
class CheckBoxHead extends StatefulWidget {
  const CheckBoxHead({super.key});
  @override
  State<CheckBoxHead> createState() => _CheckBoxHeadState();
}

class _CheckBoxHeadState extends State<CheckBoxHead> {
  @override
  void dispose() {
    Get.find<FetchCartItemsController>().isChecked = true;
    super.dispose();
  }

  FetchCartDropshipController itemsDropship =
      Get.find<FetchCartDropshipController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FetchCartItemsController>(builder: (data) {
      return Checkbox(
          side: BorderSide(width: 1, color: theme_color_df),
          value: data.isChecked,
          onChanged: (bool? value) {
            data.updateCheckbox(value);
            data.allowMultiple = data.itemsCartList!.cardHeader.carddetail
                .every((element) => (data.isChecked && data.isCheckedDropship));
          });
    });
  }
}

MediaQuery headFriday(context, String? typeUser, String deliveryDate) {
  // String? routeName = ModalRoute.of(context)?.settings.name;
  // printWhite(routeName);
  return MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(1.0)),
    child: Container(
      height: 40,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 12,
          ),
          const Image(
              width: 60,
              image: AssetImage(
                'assets/images/home/friday_logo.png',
              )),
          // const Text(
          //   "FRIDAY",
          //   style: TextStyle(
          //       letterSpacing: 1.4, fontWeight: FontWeight.bold, fontSize: 12),
          // ),
          const SizedBox(
            width: 10,
          ),
          VerticalDivider(
            width: 1,
            thickness: 0.8,
            indent: 12,
            endIndent: 12,
            color: theme_color_df,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: typeUser == "1"
                ? const Text('')
                : Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    'คาดว่าจะได้รับภายใน $deliveryDate',
                    style: TextStyle(fontSize: 14, color: theme_color_df),
                  ),
          ),
        ],
      ),
    ),
  );
}

MediaQuery headSupplier(
    context, String? typeUser, String deliveryDate, CarddetailB2C supplier) {
  // String? routeName = ModalRoute.of(context)?.settings.name;
  return MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: const TextScaler.linear(1.0)),
    child: Container(
      height: 40,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 12,
          ),
          Text(
            supplier.supplierName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    ),
  );
}
