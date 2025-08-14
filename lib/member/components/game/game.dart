import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'dart:math';

class MemoryCard {
  final String id; // รหัสที่คู่กัน เช่น 'cat1', 'cat2' มีค่าเหมือนกัน
  bool isFaceUp;
  bool isMatched;

  MemoryCard({required this.id, this.isFaceUp = false, this.isMatched = false});
}

class SpinController extends GetxController {
  final StreamController<int> selected = StreamController<int>();
  var prizes = [
    '100',
    '200',
    '300',
    '400',
    '500',
    'Jackpot',
    '50',
    'Try Again'
  ];

  var selectedIndex = 0; // เพิ่มตัวแปรเก็บ index ที่ได้

  void spinWheel() {
    final random = Random();
    selectedIndex = random.nextInt(prizes.length); // set selectedIndex
    selected.add(selectedIndex); // ส่งเข้าวงล้อ
  }

  @override
  void onClose() {
    selected.close();
    super.onClose();
  }
}

class SpinPage extends StatelessWidget {
  final SpinController controller = Get.put(SpinController());

  SpinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spin the Fortune Wheel')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 300,
              child: FortuneWheel(
                selected: controller.selected.stream,
                items: controller.prizes
                    .map((prize) => FortuneItem(
                          // style: FortuneItemStyle(),
                          child: Text(
                            prize,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
                onAnimationEnd: () {
                  final wonPrize = controller.prizes[controller.selectedIndex];
                  Get.defaultDialog(
                    title: '🎯 Result!',
                    middleText: 'You won: $wonPrize',
                    confirm: ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const Text('OK'),
                    ),
                  );
                },
              )),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => controller.spinWheel(),
            child: const Text('Spin Now!'),
          ),
        ],
      ),
    );
  }
}
