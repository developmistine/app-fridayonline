import 'dart:async';
import 'dart:convert';
import 'package:fridayonline/push/push.dart';
import 'package:fridayonline/service/logapp/logapp_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BranchManagerMain {
  static const String _branchProcessedKey = 'branch_first_processed';
  static const String _lastProcessedTimestampKey =
      'last_processed_click_timestamp';

  static StreamSubscription<Map>? streamSubscriptionPending;
  static StreamController<String>? controllerDataPending;
  static StreamController<String>? controllerInitSessionPending;

  static Map? pendingData;

  static initializePending() {
    controllerDataPending = StreamController<String>.broadcast();
    controllerInitSessionPending = StreamController<String>.broadcast();
  }

  static void getBranchData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool alreadyProcessed = prefs.getBool(_branchProcessedKey) ?? false;

    // ถ้าประมวลผลแล้ว ไม่ต้องทำอีก
    if (alreadyProcessed) {
      print('Branch first params already processed, skipping...');
      return;
    }

    Map<dynamic, dynamic>? branchData;
    Map<dynamic, dynamic>? firstParams =
        await FlutterBranchSdk.getFirstReferringParams();
    Map<dynamic, dynamic>? latestParams =
        await FlutterBranchSdk.getLatestReferringParams();

    branchData = firstParams.isNotEmpty ? firstParams : latestParams;
    print('Branch Data Main: $branchData');

    if (branchData.isNotEmpty) {
      if (branchData.containsKey('+clicked_branch_link') &&
          branchData['+clicked_branch_link'] == true) {
        print('มาจาก Branch Link!');
        await handleBranchLink(branchData, context);

        // บันทึกว่าประมวลผลแล้ว
        await prefs.setBool(_branchProcessedKey, true);
      } else {
        print('ไม่ได้มาจาก Branch Link');
      }
    }
  }

  static Future<void> handleBranchLink(Map data, BuildContext context) async {
    print("data frome branch main : $data");
    final prefs = await SharedPreferences.getInstance();

    if (data.containsKey('+clicked_branch_link') &&
        data['+clicked_branch_link'] == true) {
      String lslogin = prefs.getString("login") ?? '0';
      String deviceId = prefs.getString("deviceId").toString();

      // เรียก API ของคุณ
      await insertClickLinkB2C(
          data['~referring_browser'] ?? "", data['~id'].toString(), deviceId);

      if (lslogin == '0') {
        String deepLinkSource = data['~referring_browser'] ?? "";
        String deepLinkId = data['~id'].toString();
        await prefs.setString("deepLinkSource", deepLinkSource);
        await prefs.setString("deepLinkId", deepLinkId);
      }
    }

    var reffer = data['Ref'] ?? '';
    await prefs.setString("refferSrisawad", reffer);
    if (context.mounted) {
      await managePushMain(jsonEncode(data), context, 'deeplink');
    }
  }

  // เรียกใช้เมื่อ app พร้อมแล้ว
  static Future<void> handlePendingData(BuildContext context) async {
    if (pendingData != null) {
      await handleBranchLink(pendingData!, context);
      pendingData = null;
    }
  }

  static bool havePendingData(BuildContext context) {
    return pendingData != null;
  }

  static listenDynamicLinksAndSetPendingData(BuildContext context) async {
    streamSubscriptionPending =
        FlutterBranchSdk.listSession().listen((data) async {
      controllerDataPending?.sink.add((data.toString()));

      // ประมวลผลเฉพาะ session ใหม่ที่มีการคลิก branch link
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        // ตรวจสอบว่าเป็น click ใหม่หรือไม่ (ใช้ timestamp)
        if (await _isNewBranchClick(data)) {
          pendingData = data;
        } else {
          print('Branch link already processed (same timestamp)');
        }
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
      controllerInitSessionPending?.add(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  // ตรวจสอบว่าเป็น Branch click ใหม่หรือไม่
  static Future<bool> _isNewBranchClick(Map data) async {
    final prefs = await SharedPreferences.getInstance();

    int? clickTimestamp = data['+click_timestamp'];
    if (clickTimestamp == null) return true;

    String? lastProcessedTimestamp =
        prefs.getString(_lastProcessedTimestampKey);
    String currentTimestamp = clickTimestamp.toString();

    if (lastProcessedTimestamp == currentTimestamp) {
      return false; // ประมวลผลแล้ว
    }

    // บันทึก timestamp ใหม่
    await prefs.setString(_lastProcessedTimestampKey, currentTimestamp);
    return true;
  }

  // Dispose resources
  static disposePending() {
    pendingData = null;
    streamSubscriptionPending?.cancel();
    controllerDataPending?.close();
    controllerInitSessionPending?.close();
    streamSubscriptionPending = null;
    controllerDataPending = null;
    controllerInitSessionPending = null;
  }
}
