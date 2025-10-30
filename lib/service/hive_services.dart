import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class HiveServices {
  /// 🔹 Initial Hive (เรียกตอน main)
  static Box? _box;
  static const String _boxName = "appBox";

  // static String token = getData("token");

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  /// เก็บข้อมูล (encode JSON ถ้าเป็น Map หรือ List)
  static Future<void> saveData(String key, dynamic value) async {
    _box = Hive.box(_boxName);

    if (value is Map || value is List) {
      await _box?.put(key, json.encode(value));
    } else {
      await _box?.put(key, value);
    }
  }

  // เก็บข้อมูล List<String> สำหรับประวัติการค้นหา
  static Future<void> saveSearchHistory(String key, String value) async {
    _box = Hive.box(_boxName);

    // ดึง list เดิม ถ้าไม่มีให้สร้างเป็น list ว่าง
    List<String> history = List<String>.from(
      _box?.get(key, defaultValue: []) ?? [],
    );

    // ป้องกันไม่ให้มีค่าซ้ำ
    if (!history.contains(value)) {
      history.add(value);
    }

    // บันทึกกลับลง Hive
    await _box?.put(key, history);
  }

  //ดึง List<String> ประวัติการค้นหา
  static List<String> getSearchHistory(String key) {
    _box = Hive.box(_boxName);
    return List<String>.from(_box?.get(key, defaultValue: []) ?? []);
  }

  /// ดึงข้อมูลแบบ synchronous (ไม่ต้อง await)
  static T? getData<T>(
    String key, {
    T Function(Map<String, dynamic> json)? fromJson,
  }) {
    _box = Hive.box(_boxName);
    final data = _box?.get(key);

    if (data == null) return null;

    if (fromJson != null && data is String) {
      return fromJson(json.decode(data));
    }

    return data as T?;
  }

  /// ลบข้อมูล
  static Future<void> deleteData(String key) async {
    _box = Hive.box(_boxName);
    await _box?.delete(key);
  }

  /// ล้างกล่อง
  static Future<void> clearBox(String boxName) async {
    _box = Hive.box(boxName);
    await _box?.clear();
  }
}
