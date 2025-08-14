// Image Preloader Class
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePreloader {
  static final ImagePreloader _instance = ImagePreloader._internal();
  factory ImagePreloader() => _instance;
  ImagePreloader._internal();

  // เก็บรายการ image ที่โหลดแล้ว
  final Map<String, ui.Image> _loadedImages = {};
  final Map<String, bool> _loadingStatus = {};

  // Stream สำหรับติดตาม progress
  final StreamController<PreloadProgress> _progressController =
      StreamController<PreloadProgress>.broadcast();

  Stream<PreloadProgress> get progressStream => _progressController.stream;

  // โหลด image เดี่ยว
  Future<ui.Image?> loadSingleImage(String assetPath) async {
    try {
      if (_loadedImages.containsKey(assetPath)) {
        // print("✅ Image cached: $assetPath");
        return _loadedImages[assetPath];
      }

      // print("🔄 Loading image: $assetPath");
      _loadingStatus[assetPath] = true;

      // โหลด asset เป็น bytes
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // แปลงเป็น ui.Image
      final Completer<ui.Image> completer = Completer();
      ui.decodeImageFromList(bytes, (ui.Image img) {
        completer.complete(img);
      });

      final ui.Image image = await completer.future;

      // เก็บใน cache
      _loadedImages[assetPath] = image;
      _loadingStatus[assetPath] = false;

      // print(
      //     "✅ Image loaded successfully: $assetPath (${image.width}x${image.height})");
      return image;
    } catch (e) {
      // print("❌ Error loading image $assetPath: $e");
      _loadingStatus[assetPath] = false;
      return null;
    }
  }

  // โหลดหลาย images พร้อมกัน
  Future<Map<String, ui.Image?>> loadMultipleImages(
    List<String> assetPaths, {
    Function(int loaded, int total)? onProgress,
  }) async {
    final Map<String, ui.Image?> results = {};
    int loadedCount = 0;
    final int totalCount = assetPaths.length;

    // print("🚀 Starting to load $totalCount images...");

    // อัพเดท progress เริ่มต้น
    _progressController.add(PreloadProgress(
      loaded: 0,
      total: totalCount,
      percentage: 0.0,
      currentAsset: '',
      isComplete: false,
    ));

    for (String assetPath in assetPaths) {
      try {
        // อัพเดท progress ปัจจุบัน
        _progressController.add(PreloadProgress(
          loaded: loadedCount,
          total: totalCount,
          percentage: (loadedCount / totalCount) * 100,
          currentAsset: assetPath,
          isComplete: false,
        ));

        final ui.Image? image = await loadSingleImage(assetPath);
        results[assetPath] = image;

        loadedCount++;

        // เรียก callback ถ้ามี
        onProgress?.call(loadedCount, totalCount);

        // อัพเดท progress
        _progressController.add(PreloadProgress(
          loaded: loadedCount,
          total: totalCount,
          percentage: (loadedCount / totalCount) * 100,
          currentAsset: assetPath,
          isComplete: loadedCount == totalCount,
        ));
      } catch (e) {
        // print("❌ Failed to load: $assetPath - $e");
        results[assetPath] = null;
        loadedCount++;
      }
    }

    // print("🎉 Completed loading $loadedCount/$totalCount images");
    return results;
  }

  // ดูข้อมูล cache
  Map<String, dynamic> getCacheInfo() {
    return {
      'loadedImages': _loadedImages.length,
      'loadingStatus': _loadingStatus,
      'cacheSize': _loadedImages.length,
      'paths': _loadedImages.keys.toList(),
    };
  }

  // ล้าง cache
  void clearCache([String? specificPath]) {
    if (specificPath != null) {
      _loadedImages.remove(specificPath);
      _loadingStatus.remove(specificPath);
      print("🗑️ Cleared cache for: $specificPath");
    } else {
      _loadedImages.clear();
      _loadingStatus.clear();
      print("🗑️ Cleared all image cache");
    }
  }

  // ตรวจสอบว่า image โหลดแล้วหรือยัง
  bool isImageLoaded(String assetPath) {
    return _loadedImages.containsKey(assetPath);
  }

  // ตรวจสอบว่ากำลังโหลดอยู่หรือไม่
  bool isImageLoading(String assetPath) {
    return _loadingStatus[assetPath] ?? false;
  }

  // ดึง image ที่โหลดแล้วจาก cache
  ui.Image? getCachedImage(String assetPath) {
    return _loadedImages[assetPath];
  }

  // ปิด stream controller
  void dispose() {
    _progressController.close();
  }
}

// Class สำหรับติดตาม progress
class PreloadProgress {
  final int loaded;
  final int total;
  final double percentage;
  final String currentAsset;
  final bool isComplete;

  PreloadProgress({
    required this.loaded,
    required this.total,
    required this.percentage,
    required this.currentAsset,
    required this.isComplete,
  });

  @override
  String toString() {
    return 'PreloadProgress(loaded: $loaded/$total, ${percentage.toStringAsFixed(1)}%, current: $currentAsset, complete: $isComplete)';
  }
}

// ===== ตัวอย่างการใช้งานใน Widget อื่น =====

class PreloadedImageWidget extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const PreloadedImageWidget({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final ImagePreloader preloader = ImagePreloader();
    final ui.Image? cachedImage = preloader.getCachedImage(assetPath);

    if (cachedImage != null) {
      return SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: ImagePainter(cachedImage, fit),
        ),
      );
    } else {
      // ถ้าไม่มีใน cache ให้โหลดแบบปกติ
      return SizedBox(
        width: width,
        height: height,
        child: Image.asset(
          assetPath,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            );
          },
        ),
      );
    }
  }
}

// Custom Painter สำหรับวาด ui.Image
class ImagePainter extends CustomPainter {
  final ui.Image image;
  final BoxFit fit;

  ImagePainter(this.image, this.fit);

  @override
  void paint(Canvas canvas, Size size) {
    final double imageAspectRatio = image.width / image.height;
    final double canvasAspectRatio = size.width / size.height;

    double drawWidth, drawHeight;
    double offsetX = 0, offsetY = 0;

    if (fit == BoxFit.cover) {
      if (imageAspectRatio > canvasAspectRatio) {
        drawHeight = size.height;
        drawWidth = drawHeight * imageAspectRatio;
        offsetX = (size.width - drawWidth) / 2;
      } else {
        drawWidth = size.width;
        drawHeight = drawWidth / imageAspectRatio;
        offsetY = (size.height - drawHeight) / 2;
      }
    } else {
      drawWidth = size.width;
      drawHeight = size.height;
    }

    final Rect srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final Rect dstRect = Rect.fromLTWH(offsetX, offsetY, drawWidth, drawHeight);

    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ตัวอย่างการโหลดหลายรูปพร้อมกัน
Future<void> loadImageOnboarding() async {
  final List<String> imagePaths = [
    'assets/images/onboarding/boarding-1.png',
    'assets/images/onboarding/boarding-2.png',
    'assets/images/onboarding/boarding-3.png',
    'assets/images/onboarding/boarding-4.png',
  ];
  final ImagePreloader preloader = ImagePreloader();
  await preloader.loadMultipleImages(
    imagePaths,
    onProgress: (loaded, total) {
      // print("Progress: $loaded/$total");
    },
  );
}

Future<void> loadImageSignIn() async {
  final List<String> imagePaths = [
    'assets/images/login/login_bg.png',
    'assets/images/b2c/logo/friday_online_label_white.png',
    'assets/images/login/google-login.png',
    'assets/images/login/facebook-login.png',
    'assets/images/login/apple.png',
    'assets/images/login/line_icon.png',
  ];
  final ImagePreloader preloader = ImagePreloader();
  await preloader.loadMultipleImages(
    imagePaths,
    onProgress: (loaded, total) {
      // print("Progress: $loaded/$total");
    },
  );
}

Future<void> loadImageMenu() async {
  final List<String> imagePaths = [
    'assets/images/b2c/menu/home_active.png',
    'assets/images/b2c/menu/home_inactive.png',
    'assets/images/b2c/menu/brand_active.png',
    'assets/images/b2c/menu/brand_inactive.png',
    'assets/images/b2c/menu/noti_active.png',
    'assets/images/b2c/menu/noti_inactive.png',
    'assets/images/b2c/menu/profile_active.png',
    'assets/images/b2c/menu/profile_inactive.png',
  ];
  final ImagePreloader preloader = ImagePreloader();
  await preloader.loadMultipleImages(
    imagePaths,
    onProgress: (loaded, total) {
      // print("Progress: $loaded/$total");
    },
  );
}
