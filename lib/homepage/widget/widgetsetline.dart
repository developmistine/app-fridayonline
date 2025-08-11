import 'package:flutter/material.dart';

Row controlline() {
  return Row(children: <Widget>[
    Expanded(
      child: Container(
          margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 2.0),
          child: const Divider(
            thickness: 0.5,
            color: Color.fromARGB(255, 219, 218, 218),
            height: 10,
          )),
    ),
  ]);
}
