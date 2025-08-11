import 'package:flutter/material.dart';

Padding setProfileEnduserHeader(String lsheader) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 20,
      alignment: Alignment.topLeft,
      child: Text(
        lsheader,
        style: const TextStyle(
            fontFamily: 'notoreg', fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Padding setprofilerheader(String lsheader) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 20,
      alignment: Alignment.topLeft,
      child: Text(
        lsheader,
        style: TextStyle(
            fontFamily: 'notoreg', fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Padding settextheader(String lsheader) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
      alignment: Alignment.topLeft,
      child: Text(
        lsheader,
        style: TextStyle(
            fontFamily: 'notoreg', fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Padding settext(String lsheader) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Container(
      alignment: Alignment.topLeft,
      child: Text(
        lsheader,
        style: TextStyle(fontFamily: 'notoreg', fontSize: 18),
      ),
    ),
  );
}
