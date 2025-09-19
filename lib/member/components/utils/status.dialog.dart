import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Future<void> showAffDialog(
  bool success,
  String title,
  String desc, {
  Duration timeout = const Duration(milliseconds: 1500),
  String? lottieAssetSuccess,
  String? lottieAssetError,
  bool barrierDismissible = true,
}) async {
  final successAsset = lottieAssetSuccess ?? 'assets/lottie/checked.json';
  final errorAsset = lottieAssetError ?? 'assets/lottie/error.json';

  Get.dialog(
    Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.transparent,
      child: _AffPrettyDialog(
        title: title,
        message: desc,
        success: success,
        successAsset: successAsset,
        errorAsset: errorAsset,
      ),
    ),
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: .40),
  );

  unawaited(Future.delayed(timeout, () {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }));
}

class _AffPrettyDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool success;
  final String successAsset;
  final String errorAsset;

  const _AffPrettyDialog({
    required this.title,
    required this.message,
    required this.success,
    required this.successAsset,
    required this.errorAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        spacing: 12,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor:
                success ? const Color(0xFFA5DC86) : const Color(0xFFE53935),
            child: _LottieOrAnimatedIcon(
              asset: success ? successAsset : errorAsset,
              fallbackIcon: success ? Icons.check_rounded : Icons.close_rounded,
            ),
          ),
          Column(
            spacing: 0,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LottieOrAnimatedIcon extends StatefulWidget {
  final String asset;
  final IconData fallbackIcon;

  const _LottieOrAnimatedIcon({
    required this.asset,
    required this.fallbackIcon,
  });

  @override
  State<_LottieOrAnimatedIcon> createState() => _LottieOrAnimatedIconState();
}

class _LottieOrAnimatedIconState extends State<_LottieOrAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400))
      ..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _canLoadLottie(widget.asset),
      builder: (context, snap) {
        final canLoad = snap.data == true;
        if (canLoad) {
          return Lottie.asset(widget.asset,
              width: 48, height: 48, repeat: false);
        }
        return ScaleTransition(
          scale: CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
          child: Icon(widget.fallbackIcon, color: Colors.white, size: 32),
        );
      },
    );
  }

  Future<bool> _canLoadLottie(String asset) async {
    try {
      await AssetLottie(asset).load();
      return true;
    } catch (_) {
      return false;
    }
  }
}
