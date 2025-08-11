import 'package:fridayonline/enduser/controller/cart.ctr.dart';
import 'package:fridayonline/enduser/views/(cart)/cart.set.address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget emptyAddress() {
  return InkWell(
    onTap: () async {
      var res =
          await Get.to(() => const EndUserSetAddress(), arguments: ['first']);
      if (res == null) {
      } else {
        Get.find<EndUserCartCtr>().fetchAddressList();
      }
    },
    child: Container(
        padding: const EdgeInsets.all(8),
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: Colors.deepOrange.shade700,
                size: 18,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'เพิ่มที่อยู่',
                style:
                    TextStyle(fontSize: 13, color: Colors.deepOrange.shade700),
              ),
            ],
          ),
        )),
  );
}
