// // ignore_for_file: avoid_print

// import 'dart:async';
// import 'dart:convert';
// import 'dart:math' as math;

// import 'package:fridayonline/enduser/controller/chat.ctr.dart';
// import 'package:fridayonline/model/set_data/set_data.dart';
// import 'package:get/get.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class WebSocketController extends GetxController {
//   WebSocketChannel? channel;
//   StreamSubscription? _subscription;

//   final chatController = Get.put(ChatController());
//   final RxBool isConnected = false.obs;

//   Timer? _reconnectTimer;
//   Timer? _heartbeatTimer; // เพิ่ม heartbeat timer
//   int _reconnectAttempt = 0;
//   final int _maxReconnectAttempts = 5;

//   // เพิ่มตัวแปรสำหรับตรวจสอบ connection
//   DateTime? _lastMessageReceived;
//   static const Duration _heartbeatInterval = Duration(seconds: 30);
//   static const Duration _connectionTimeout = Duration(seconds: 60);

//   @override
//   void onClose() {
//     _reconnectTimer?.cancel();
//     _heartbeatTimer?.cancel(); // ยกเลิก heartbeat timer
//     _subscription?.cancel();
//     channel?.sink.close();
//     super.onClose();
//   }

//   Future<void> connectWebSocket() async {
//     if (_reconnectAttempt > 0) {
//       print('Reconnect attempt #$_reconnectAttempt');
//     }
//     try {
//       // ปิด connection เก่าก่อน (ถ้ามี)
//       await _closeExistingConnection();

//       SetData data = SetData();
//       final userId = await data.b2cCustID;
//       final uri = Uri.parse('wss://app.friday.co.th/ws/chat?userId=CU$userId');

//       channel = WebSocketChannel.connect(uri);

//       // รอให้ connection พร้อม
//       await _waitForConnection();

//       isConnected.value = true;
//       _reconnectAttempt = 0;
//       _lastMessageReceived = DateTime.now();

//       // เริ่ม heartbeat
//       _startHeartbeat();

//       _subscription = channel!.stream.listen(
//         (message) => _handleMessage(message),
//         onDone: () {
//           print('WebSocket closed - onDone');
//           _handleDisconnection();
//         },
//         onError: (error) {
//           print('WebSocket error: $error');
//           _handleDisconnection();
//         },
//         cancelOnError: true,
//       );
//     } catch (e) {
//       print('WebSocket connection failed: $e');
//       _handleDisconnection();
//     }
//   }

//   // เพิ่มฟังก์ชันรอ connection
//   Future<void> _waitForConnection() async {
//     final completer = Completer<void>();
//     Timer? timeoutTimer;

//     timeoutTimer = Timer(Duration(seconds: 10), () {
//       if (!completer.isCompleted) {
//         completer.completeError('Connection timeout');
//       }
//     });

//     // ส่ง ping message เพื่อทest connection
//     try {
//       channel?.sink.add(jsonEncode({'type': 'ping'}));
//       await Future.delayed(Duration(milliseconds: 500));
//       timeoutTimer.cancel();
//       if (!completer.isCompleted) {
//         completer.complete();
//       }
//     } catch (e) {
//       timeoutTimer.cancel();
//       if (!completer.isCompleted) {
//         completer.completeError(e);
//       }
//     }

//     return completer.future;
//   }

//   // ปิด connection เก่า
//   Future<void> _closeExistingConnection() async {
//     _heartbeatTimer?.cancel();
//     _subscription?.cancel();
//     if (channel != null) {
//       try {
//         await channel!.sink.close();
//       } catch (e) {
//         print('Error closing existing connection: $e');
//       }
//       channel = null;
//     }
//   }

//   // เริ่ม heartbeat เพื่อตรวจสอบ connection
//   void _startHeartbeat() {
//     _heartbeatTimer?.cancel();
//     _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
//       _checkConnectionHealth();
//     });
//   }

//   // ตรวจสอบสุขภาพของ connection
//   void _checkConnectionHealth() {
//     final now = DateTime.now();

//     // ถ้าไม่ได้รับ message มานานเกินไป
//     if (_lastMessageReceived != null &&
//         now.difference(_lastMessageReceived!) > _connectionTimeout) {
//       print('Connection seems dead, attempting reconnect...');
//       _handleDisconnection();
//       return;
//     }

//     // ส่ง ping เพื่อ keep connection alive
//     if (isConnected.value && channel != null) {
//       try {
//         channel!.sink.add(jsonEncode(
//             {'type': 'ping', 'timestamp': now.millisecondsSinceEpoch}));
//       } catch (e) {
//         print('Failed to send ping: $e');
//         _handleDisconnection();
//       }
//     }
//   }

//   void _handleMessage(dynamic message) {
//     _lastMessageReceived = DateTime.now();

//     try {
//       final data = jsonDecode(message);

//       // จัดการ pong message
//       if (data['type'] == 'pong') {
//         print('Received pong - connection alive');
//         return;
//       }

//       // จัดการ message ปกติ
//       // ... existing message handling logic
//     } catch (e) {
//       print('Error handling message: $e');
//     }
//   }

//   void _handleDisconnection() {
//     isConnected.value = false;
//     _heartbeatTimer?.cancel();
//     _startReconnect();
//   }

//   void _startReconnect() {
//     if (_reconnectAttempt >= _maxReconnectAttempts) {
//       print('Max reconnect attempts reached');
//       return;
//     }

//     _reconnectAttempt++;
//     _reconnectTimer?.cancel();

//     final delay = Duration(seconds: math.min(2 * _reconnectAttempt, 30));
//     _reconnectTimer = Timer(delay, () {
//       print('Trying to reconnect...');
//       connectWebSocket();
//     });
//   }

//   // เพิ่มฟังก์ชันสำหรับส่ง message พร้อมตรวจสอบ connection
//   void sendMessage(String message) {
//     if (isConnected.value && channel != null) {
//       try {
//         channel!.sink.add(message);
//       } catch (e) {
//         print('Failed to send message: $e');
//         _handleDisconnection();
//       }
//     } else {
//       print('WebSocket not connected, attempting to reconnect...');
//       connectWebSocket();
//     }
//   }
// }
