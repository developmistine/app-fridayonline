import 'dart:async';
import 'dart:convert';
import 'package:fridayonline/push/push.dart';
import 'package:fridayonline/service/logapp/logapp_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BranchManager {
  static const String _branchProcessedKey = 'branch_first_processed';
  static const String _lastProcessedTimestampKey =
      'last_processed_click_timestamp';

  StreamSubscription<Map>? streamSubscription;
  StreamController<String>? controllerData;
  StreamController<String>? controllerInitSession;

  BranchManager() {
    // Initialize controllers if needed
    controllerData = StreamController<String>.broadcast();
    controllerInitSession = StreamController<String>.broadcast();
  }

  void getBranchData(BuildContext context) async {
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
    print('Branch Data: $branchData');

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

  Future<void> handleBranchLink(Map data, BuildContext context) async {
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
    // PushNotify? pushNotify = pushNotifyFromJson(data);
    var reffer = data['Ref'] ?? '';
    await prefs.setString("refferSrisawad", reffer);

    await managePushMain(jsonEncode(data), context, 'deeplink');
  }

  void listenDynamicLinks(BuildContext context) async {
    streamSubscription = FlutterBranchSdk.listSession().listen((data) async {
      // print('listenDynamicLinks - DeepLink Data: $data');
      controllerData?.sink.add((data.toString()));

      // ประมวลผลเฉพาะ session ใหม่ที่มีการคลิก branch link
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        // ตรวจสอบว่าเป็น click ใหม่หรือไม่ (ใช้ timestamp)
        if (await _isNewBranchClick(data)) {
          await handleBranchLink(data, context);
        } else {
          print('Branch link already processed (same timestamp)');
        }
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
      controllerInitSession?.add(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  // ตรวจสอบว่าเป็น Branch click ใหม่หรือไม่
  Future<bool> _isNewBranchClick(Map data) async {
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

  // Method สำหรับ reset (ใช้เมื่อ user logout หรือต้องการ reset)
  Future<void> resetBranchProcessing() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_branchProcessedKey);
    await prefs.remove(_lastProcessedTimestampKey);
    await prefs.remove(_branchProcessedKey);
    await prefs.remove(_lastProcessedTimestampKey);
    await prefs.remove('is_first_launch');
    await prefs.remove('deepLinkSource');
    await prefs.remove('deepLinkId');
    print('Branch processing reset');
  }

  // Dispose resources
  void dispose() {
    streamSubscription?.cancel();
    controllerData?.close();
    controllerInitSession?.close();
  }
}
