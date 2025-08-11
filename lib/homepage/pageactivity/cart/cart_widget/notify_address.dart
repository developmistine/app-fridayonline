// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import '../cart_theme/cart_all_theme.dart';

Flex notify_address(BuildContext context) {
  return Flex(direction: Axis.vertical, children: [
    Image.asset(
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
        "assets/images/cart/divider1.png"),
    Container(
      color: Color.fromRGBO(255, 237, 237, 1),
      // height: 30,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Icon(Icons.campaign, size: 40, color: theme_red),
            ),
            Expanded(
              flex: 4,
              child: Text(
                'รบกวนตรวจสอบที่อยู่จัดส่งก่อนการยืนยันคำสั่งซื้อหากยืนยันแล้วจะไม่สามารถแก้ไขได้อีกสินค้าจะถูกส่งตามที่อยู่พร้อมบิลชำระเงินและแจ้งส่วนลด',
                style: TextStyle(color: theme_red),
              ),
            )
          ],
        ),
      ),
    ),
  ]);
}
