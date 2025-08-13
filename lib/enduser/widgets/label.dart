import 'package:appfridayecommerce/theme.dart';
import 'package:flutter/material.dart';

class BadgePainter extends CustomPainter {
  final String color; // Add a String parameter

  // Constructor to accept the String
  BadgePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Gradient ไล่สีจากบนลงล่าง
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: setColor,
    );

    paint.shader = gradient.createShader(rect);

    final Path path = Path();
    path.moveTo(0, 0); // มุมซ้ายบน
    path.lineTo(size.width, 0); // มุมขวาบน
    path.lineTo(size.width, size.height * 0.80); // ด้านขวาล่างก่อนมุม
    path.lineTo(size.width / 2, size.height); // จุดแหลมด้านล่าง
    path.lineTo(0, size.height * 0.80); // ด้านซ้ายล่างก่อนมุม
    path.close(); // ปิด path

    canvas.drawPath(path, paint);
  }

  List<Color> get setColor {
    switch (color) {
      case "blue":
        {
          return [themeColorDefault.withOpacity(0.4), themeColorDefault];
        }
      case "gold":
        {
          return [
            const Color.fromARGB(255, 228, 194, 0),
            const Color.fromARGB(255, 159, 135, 0)
          ];
        }
      case "silver":
        {
          return [
            const Color(0xFFC0C0C0),
            const Color.fromARGB(255, 134, 133, 133)
          ];
        }
      case "copper":
        {
          return [
            const Color.fromARGB(255, 199, 113, 55),
            const Color.fromARGB(255, 128, 80, 35)
          ];
        }

      default:
        {
          return [themeColorDefault.withOpacity(0.4), themeColorDefault];
        }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
