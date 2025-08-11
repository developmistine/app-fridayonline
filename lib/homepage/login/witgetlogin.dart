  
  import 'package:flutter/material.dart';

Text disabletextxxxx(bool buttonshow) {
    if (buttonshow) {
      return Text(
        'ยอมรับเงื่อนไข',
        style:
            TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'notoreg'),
      );
    } else {
      return Text(
        "เลื่อนอ่านข้อมูล",
        style: TextStyle(
            color: Color(0xffc4c4c4), fontSize: 15, fontFamily: 'notoreg'),
      );
    }
  }