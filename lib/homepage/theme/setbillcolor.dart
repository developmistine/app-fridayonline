import 'package:flutter/material.dart';

setBillColor(String colorName) {
  colorName = colorName.toLowerCase();
  Map<String, Color> colorMap = {
    'red': Colors.red,
    'green': Colors.green,
    'blue': Colors.blue,
    'yellow': Colors.orange,
    'orange': Colors.orange,
    'purple': Colors.purple,
    'pink': Colors.pink,
    'brown': Colors.brown,
    'grey': Colors.grey,
    'black': Colors.black,
    'white': Colors.white,
    'teal': Colors.teal,
    'cyan': Colors.cyan,
    'lime': Colors.lime,
    'amber': Colors.amber,
    '0': Colors.black,
    '1': Colors.black,
    '2': Colors.black,
    '3': Colors.black,
  };
  Color color = colorMap[colorName]!;

  return color;
}
