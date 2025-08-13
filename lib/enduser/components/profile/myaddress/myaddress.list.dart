import 'package:fridayonline/enduser/controller/cart.ctr.dart';
import 'package:fridayonline/enduser/models/address/address.model.dart';
import 'package:fridayonline/enduser/utils/format.dart';
import 'package:fridayonline/enduser/views/(cart)/cart.set.address.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget myAddressList({required List<Datum> listAddress}) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    itemCount: listAddress.length,
    itemBuilder: (context, index) => InkWell(
      onTap: () async {
        var res = await Get.to(() => const EndUserSetAddress(),
            arguments: ["edit", listAddress[index]]);
        if (res != null) {
          Get.find<EndUserCartCtr>().fetchAddressList();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_sharp,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "${listAddress[index].firstName} ${listAddress[index].lastName} ",
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "| ${formatPhoneNumber(listAddress[index].phone)}",
                      style: TextStyle(color: Colors.grey[700]!, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                              "${listAddress[index].address1}\n${listAddress[index].address}",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700]!)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            if (listAddress[index].isDeliveryAddress)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 1,
                  ),
                ),
                child: Text(
                  'ค่าตั้งต้น',
                  style: TextStyle(fontSize: 12, color: themeColorDefault),
                ),
              )
          ],
        ),
      ),
    ),
  );
}
