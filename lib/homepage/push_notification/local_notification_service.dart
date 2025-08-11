// import 'package:fridayonline/controller/category/category_controller.dart';
import 'package:fridayonline/controller/badger/badger_controller.dart';
import 'package:fridayonline/controller/catelog/catelog_controller.dart';
import 'package:fridayonline/controller/home/home_controller.dart';
import 'package:fridayonline/controller/notification/notification_controller.dart';
import 'package:fridayonline/controller/pro_filecontroller.dart';
import 'package:fridayonline/homepage/myhomepage.dart';
import 'package:fridayonline/model/push/notify.dart';
import 'package:fridayonline/push/push.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

BuildContext? context1;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSetting for android and iOS
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    //On select message push when the app is open
    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        print("===onSelectNotification=== $payload");
        print("click from local noti");
        PushNotify pushNotify = pushNotifyFromJson(payload.payload.toString());
        await managePushMain(
            pushNotify, context1 ?? Get.context!, "push_notify");
        // await managePushLocalNotification(pushNotify, context1 ?? Get.context!);
      },
    );
  }

  static void fetchMslCallData() {
    Get.find<NotificationController>().get_notification_data();
    Get.find<ProfileController>().get_profile_data();
    Get.find<ProfileSpecialProjectController>().get_special_project_data();
    Get.find<DraggableFabController>().draggable_Fab();
    Get.find<BadgerController>().get_badger();
    Get.find<BadgerProfileController>().get_badger_profile();
    Get.find<BadgerController>().getBadgerMarket();
    Get.find<BannerController>().get_banner_data();
    Get.find<FavoriteController>().get_favorite_data();
    Get.find<SpecialPromotionController>().get_promotion_data();
    Get.find<ProductHotItemHomeController>().get_product_hotitem_data();
    Get.find<CatelogController>().get_catelog();
    Get.find<KeyIconController>().get_keyIcon_data();
    Get.find<HomePointController>().get_home_point_data(false);
    Get.find<HomeContentSpecialListController>().get_home_content_data("");
    Get.find<KeyIconController>().get_keyIcon_data();
    Get.find<HomePointController>().get_home_point_data(false);
    Get.to(() => MyHomePage());
  }

  static void createDisplayNotification(RemoteMessage message) async {
    String? imageUrl = message.notification?.android?.imageUrl ??
        message.notification?.apple?.imageUrl;

    // Initialize BigPictureStyleInformation with null
    BigPictureStyleInformation? bigPictureStyleInformation;

    if (imageUrl != null) {
      try {
        // Fetch and convert image to bitmap
        final ByteArrayAndroidBitmap largeIcon =
            await _getBitmapFromUrl(imageUrl);

        // Create BigPictureStyleInformation with the bitmap
        bigPictureStyleInformation = BigPictureStyleInformation(largeIcon,
            contentTitle: message.notification?.title,
            summaryText: message.notification?.body,
            htmlFormatContentTitle: true,
            htmlFormatSummaryText: true);
      } catch (e) {
        debugPrint('Error fetching image for notification: $e');
      }
    }

    // Android-specific notification details
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "friday",
      "push_notification_channel",
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation:
          bigPictureStyleInformation, // Use Big Picture style if image is available
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 0,
    );

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 2000;

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['notification_type'],
      );
    } on Exception catch (_) {
      if (kDebugMode) {
        // Handle exception
      }
    }
  }

  static Future<ByteArrayAndroidBitmap> _getBitmapFromUrl(
      String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      return ByteArrayAndroidBitmap.fromBase64String(
          base64Encode(bytes)); // Use base64Encode from dart:convert
    } else {
      throw Exception('Failed to load image');
    }
  }
}
