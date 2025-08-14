import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

buildAnimatedProduct(Animation<Offset> animation, BuildContext context,
    Animation<double> opacityAnimation, String url) {
  OverlayState? overlay = Navigator.of(context, rootNavigator: true).overlay;
  // เช็คว่ามี overlay และมันยัง mounted อยู่
  if (!overlay!.mounted) {
    debugPrint('Overlay is not available or not mounted.');
    return;
  }
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // สร้าง OverlayEntry
    final overlayEntry = OverlayEntry(builder: (context) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return AnimatedBuilder(
            animation: opacityAnimation,
            builder: (context, child) {
              return Positioned(
                top: animation.value.dy,
                left: animation.value.dx,
                child: Opacity(
                  opacity: opacityAnimation.value,
                  child: Transform.scale(
                    scale: opacityAnimation.value + 0.4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      child: url.isEmpty
                          ? const Icon(
                              Icons.shopping_bag_rounded,
                              size: 50,
                            )
                          : CachedNetworkImage(
                              width: 60,
                              // height: 50,
                              imageUrl: url,
                            ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    });

    try {
      // Insert OverlayEntry
      overlay.insert(overlayEntry);
      // Remove Overlay Entry เมื่อ Animation เสร็จ
      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          if (overlayEntry.mounted) {
            // ตรวจสอบว่า overlayEntry ยังไม่ถูกลบ
            overlayEntry.remove();
          }
        }
      });
    } catch (e, stackTrace) {
      debugPrint('Error inserting overlay: $e\n$stackTrace');
    }
  });
}
