import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Future<void> showConfirmDialog({
  required String title,
  required String desc,
  required VoidCallback onConfirm,
  String confirmText = "ยืนยัน",
  String cancelText = "ยกเลิก",
  String? lottieAsset,
  bool barrierDismissible = true,
}) async {
  final completer = Completer<void>();

  Get.dialog(
    Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.transparent,
      child: _AffConfirmDialog(
        title: title,
        message: desc,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        lottieAsset: lottieAsset,
      ),
    ),
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: .40),
  ).then((_) {
    if (!completer.isCompleted) completer.complete();
  });

  return completer.future;
}

class _AffConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final String? lottieAsset;

  const _AffConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.lottieAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          if (lottieAsset != null)
            Lottie.asset(lottieAsset!, width: 72, height: 72, repeat: false),
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              if (message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: Text(cancelText),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    onConfirm();
                  },
                  child: Text(confirmText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
