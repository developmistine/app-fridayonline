import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Future<void> showAffDialog(
  bool success,
  String title,
  String desc, {
  Duration timeout = const Duration(milliseconds: 1000),
  String? lottieAssetSuccess,
  String? lottieAssetError,
  bool barrierDismissible = true,
}) async {
  final successAsset = lottieAssetSuccess ?? 'assets/lottie/checked.json';
  final errorAsset = lottieAssetError ?? 'assets/lottie/error.json';
  final completer = Completer<void>();

  Get.dialog(
    Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
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
  ).then((_) {
    if (!completer.isCompleted) completer.complete();
  });

  // ตั้งเวลา auto close
  Timer(timeout, () {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    if (!completer.isCompleted) completer.complete();
  });

  return completer.future;
}

Future<void> showSmallDialog(
  String title, {
  Duration timeout = const Duration(milliseconds: 800),
  bool barrierDismissible = true,
}) async {
  final completer = Completer<void>();

  Get.dialog(
    Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Material(
          color: Colors.black.withValues(alpha: .65),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: .10), // พื้นหลังดำโปร่ง
    transitionDuration: const Duration(milliseconds: 180),
    transitionCurve: Curves.easeOutCubic,
  ).then((_) {
    if (!completer.isCompleted) completer.complete();
  });

  // ตั้งเวลา auto close
  Timer(timeout, () {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    if (!completer.isCompleted) completer.complete();
  });

  return completer.future;
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
      padding: const EdgeInsets.all(36),
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
          CircleAvatar(
            radius: 28,
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
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              if (message.isNotEmpty)
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
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
