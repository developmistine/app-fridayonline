import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:video_player/video_player.dart';

/// แคช controller ตาม url
final Map<String, VideoPlayerController> _controllers = {};

/// กัน double-init: แคช Future ด้วย
final Map<String, Future<VideoPlayerController>> _pending = {};

/// จำกัดจำนวนแคชง่าย ๆ (LRU แบบคร่าว ๆ)
const int _maxEntries = 6;
final List<String> _lru = [];

/// เลือก URL ที่เล่นได้ (รองรับ fallback 720p บนบางเครื่อง)
Future<String> _pickPlayableUrl(String originalUrl,
    {String? huaweiFallback720}) async {
  if (Platform.isAndroid) {
    final info = await DeviceInfoPlugin().androidInfo;
    final manu = (info.manufacturer ?? '').toLowerCase();
    if (manu.contains('huawei') &&
        huaweiFallback720 != null &&
        huaweiFallback720.isNotEmpty) {
      return huaweiFallback720;
    }
  }
  return originalUrl;
}

Future<VideoPlayerController> setVideoContent(
  String url, {
  String? fallbackForHuawei720, // ใส่ลิงก์ 720p ถ้ามี
  bool autoPlay = true,
  double initialVolume = 0.0,
  Duration initTimeout = const Duration(seconds: 12),
}) async {
  // ถ้ามีตัวพร้อมใช้แล้ว
  final existed = _controllers[url];
  if (existed != null) return existed;

  // ถ้ามี Future อยู่แล้ว (มีคนเรียกพร้อมกัน)
  final pending = _pending[url];
  if (pending != null) return pending;

  // สร้าง Future ใหม่แล้วเก็บไว้ เพื่อกันเรียกซ้อน
  final future = _createController(url,
      fallbackForHuawei720: fallbackForHuawei720,
      autoPlay: autoPlay,
      initialVolume: initialVolume,
      initTimeout: initTimeout);

  _pending[url] = future;

  try {
    final ctr = await future;
    // แคช controller
    _controllers[url] = ctr;

    // อัปเดต LRU
    _lru.remove(url);
    _lru.insert(0, url);
    // ถ้าเกินจำนวน กำจัดตัวท้ายสุด
    if (_lru.length > _maxEntries) {
      final toRemove = _lru.removeLast();
      final old = _controllers.remove(toRemove);
      old?.dispose();
      _pending.remove(toRemove);
    }

    return ctr;
  } catch (e) {
    // ถ้าพัง ลบ pending ไว้ก่อน
    _pending.remove(url);
    rethrow;
  } finally {
    // ไม่ว่า success/fail ลบ pending ของ url นี้
    _pending.remove(url);
  }
}

Future<VideoPlayerController> _createController(
  String url, {
  String? fallbackForHuawei720,
  required bool autoPlay,
  required double initialVolume,
  required Duration initTimeout,
}) async {
  final pickedUrl =
      await _pickPlayableUrl(url, huaweiFallback720: fallbackForHuawei720);

  final ctr = VideoPlayerController.networkUrl(
    Uri.parse(pickedUrl),
    // เผื่อบาง CDN ต้องการ header ชัดเจน
    httpHeaders: const {
      'User-Agent': 'ExoPlayerFlutter/1.0',
      'Accept': '*/*',
    },
    videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
  );

  // log error ชัด ๆ
  ctr.addListener(() {
    final v = ctr.value;
    if (v.hasError) {
      // เปลี่ยนเป็น logger ของคุณ
      // debugPrint('VIDEO ERROR: ${v.errorDescription}');
    }
  });

  try {
    // Huawei บางรุ่นช้าตอนเปิดฮาร์ดแวร์ดีโคดเดอร์ → เพิ่ม timeout
    await ctr.initialize().timeout(initTimeout + const Duration(seconds: 8));

    await ctr.setLooping(false);
    await ctr.setVolume(initialVolume.clamp(0, 1));
    if (autoPlay) await ctr.play();
    return ctr;
  } catch (e) {
    await ctr.dispose();

    if (fallbackForHuawei720 != null && fallbackForHuawei720.isNotEmpty) {
      final ctr2 =
          VideoPlayerController.networkUrl(Uri.parse(fallbackForHuawei720));
      try {
        await ctr2
            .initialize()
            .timeout(initTimeout + const Duration(seconds: 8));
        await ctr2.setVolume(initialVolume.clamp(0, 1));
        if (autoPlay) await ctr2.play();
        return ctr2;
      } catch (e2) {
        await ctr2.dispose();
        rethrow;
      }
    }
    rethrow;
  }
}

/// เรียกตอนออกจากหน้า/เปลี่ยนจอ
Future<void> disposeAllVideos() async {
  for (final c in _controllers.values) {
    await c.dispose();
  }
  _controllers.clear();
  _pending.clear();
  _lru.clear();
}

/// ถ้าต้องการหยุดทุกตัวชั่วคราว (เช่นตอนเปิดหน้ารายละเอียด)
Future<void> pauseAllVideos() async {
  for (final c in _controllers.values) {
    if (c.value.isPlaying) {
      await c.pause();
    }
  }
}
