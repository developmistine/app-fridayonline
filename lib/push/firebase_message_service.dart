// lib/services/firebase_message_service.dart
import 'package:fridayonline/push/local_notification_service.dart';
import 'package:fridayonline/push/push.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FirebaseMessageService {
  static bool _isInitialized = false;
  static GlobalKey<NavigatorState>? navigatorKey;
  static RemoteMessage? _pendingMessage;

  // เพิ่ม method สำหรับ set navigator key
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    navigatorKey = key;
  }

  static Future<void> initialize() async {
    if (_isInitialized) return;

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // เก็บ initial message ไว้ handle หลังจาก app ready
      _pendingMessage = initialMessage;
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("=onMessage foreground=");
      LocalNotificationService.createDisplayNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    _isInitialized = true;
  }

  // เรียกใช้เมื่อ app พร้อมแล้ว
  static Future<void> handlePendingMessage() async {
    if (_pendingMessage != null) {
      await _handleMessage(_pendingMessage!);
      _pendingMessage = null;
    }
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    BuildContext? context;

    // ลองหา context จากหลายแหล่ง
    if (Get.isRegistered<GetMaterialController>()) {
      context = Get.context;
    } else if (navigatorKey?.currentContext != null) {
      context = navigatorKey!.currentContext;
    }

    if (context != null) {
      await managePushMain(message, context, "push_notify");
    } else {
      // ถ้าไม่มี context ให้เก็บไว้ handle ทีหลัง
      _pendingMessage = message;
      print("Context not available, message saved for later");
    }
  }
}
