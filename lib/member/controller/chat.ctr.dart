import 'dart:async';
import 'dart:convert';

import 'package:fridayonline/member/models/chat/history.model.dart';
import 'package:fridayonline/member/models/chat/recieve.message.model.dart';
import 'package:fridayonline/member/models/chat/seller.list.model.dart';
import 'package:fridayonline/member/services/chat/chat.service.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/print.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class ChatController extends GetxController {
  var isLoading = false.obs;
  var isLoadingConversation = false.obs;
  var isLoadingMore = false.obs;
  var isLoadingMoreSeller = false.obs;
  Rx<SellerChatList>? conversations;
  RxInt countChat = 0.obs;
  final RxList<ReciveMessage> messages = <ReciveMessage>[].obs;
  RxBool emojiShowing = true.obs;
  RxBool optionShowing = true.obs;
  RxInt openChatRoom = 0.obs;
  RxBool openPlatformChatRoom = false.obs;
  final Set<int> _seenMessageIds = <int>{};

  // gallery
  int page = 0;
  final RxInt selectedCount = 0.obs;
  bool isLoadingGallery = false;
  bool isLoadingMoreGallery = false;
  bool hasMoreToLoad = true;
  RxList<AssetEntity> selectedEntities = <AssetEntity>[].obs;

  void sortConversationsByLastSend() {
    conversations!.value.data.sort((a, b) {
      final dateA = DateTime.tryParse(a.lastSend) ?? DateTime(1970);
      final dateB = DateTime.tryParse(b.lastSend) ?? DateTime(1970);
      return dateB.compareTo(dateA); // มากไปน้อย = ใหม่สุดก่อน
    });
    conversations!.refresh();
  }

  void addMessage(ReciveMessage message) {
    final id = message.messageData.messageId;
    if (_seenMessageIds.contains(id)) return;
    _seenMessageIds.add(id);
    messages.add(message);
  }

  void clearMessages() {
    messages.clear();
  }

  Future<void> fetchSellerChat(int offset) async {
    try {
      isLoadingConversation(true);
      var items = await fetchSellerChatService(offset);
      conversations = items.obs;
      countChat.value = conversations!.value.data
          .where((element) => element.unRead > 0)
          .length;
    } finally {
      isLoadingConversation(false);
    }
  }

  Future<ChatHistory> fetchHistoryChat(int roomId, offset) async {
    try {
      isLoading(true);
      var chatHistoryItems = await fetchHistoryChatService(roomId, offset);
      for (var historyItem in chatHistoryItems.data) {
        messages.add(ReciveMessage(
            event: '',
            messageData: historyItem,
            isMe: historyItem.senderRole == "customer" ||
                historyItem.senderRole == "system"));
      }
      return chatHistoryItems;
    } finally {
      isLoading(false);
    }
  }

  //? loadmore recommend
  Future<ChatHistory>? fetchMoreChat(int roomId, int offset) async {
    // printWhite(messages.length);
    return await fetchHistoryChatService(roomId, offset);
  }

  Future<SellerChatList>? fetchMoreSeller(int offset) async {
    return await fetchSellerChatService(offset);
  }

  // ? reset recommend
  void resetRecommend() {
    messages.clear();
  }

  void resetSeller() {
    conversations = null;
  }
}

class WebSocketController extends GetxController {
  WebSocketChannel? channel;
  StreamSubscription? subscription;

  final chatController = Get.put(ChatController());
  final RxBool isConnected = false.obs;

  Timer? _reconnectTimer;
  int _reconnectAttempt = 0;
  final int _maxReconnectAttempts = 5;

  @override
  void onClose() {
    _reconnectTimer?.cancel();
    subscription?.cancel();
    subscription = null;
    channel?.sink.close();
    channel = null;
    isConnected.value = false;
    super.onClose();
  }

  Future<void> connectWebSocket() async {
    if (channel != null && isConnected.value && subscription != null) {
      return;
    }

    await subscription?.cancel();
    subscription = null;
    await channel?.sink.close();
    channel = null;
    final SharedPreferences prefs = await _prefs;

    var tokenChat = await chatLoginService();
    if (tokenChat.code != '100') {
      return;
    }
    await prefs.setString("tokenChat", tokenChat.accessToken);

    printWhite('เริ่ม connect');
    if (_reconnectAttempt > 0) {
      printWhite('Reconnect attempt #$_reconnectAttempt');
    }
    try {
      SetData data = SetData();

      final userId = await data.b2cCustID;
      printWhite("socket connct with cust id : $userId");
      // final uri = Uri.parse('wss://app.friday.co.th/ws/chat?userId=CU$userId');
      final uri = Uri.parse(
          'wss://api.friday.co.th/ws/v1/chat?token=${tokenChat.accessToken}');

      channel = WebSocketChannel.connect(uri);

      isConnected.value = true;
      _reconnectAttempt = 0; // reset counter เมื่อ connect สำเร็จ
      await subscription?.cancel();
      subscription = channel!.stream.listen(
        (message) => _handleMessage(message),
        onDone: () {
          printWhite('WebSocket closed');
          isConnected.value = false;
          _startReconnect();
        },
        onError: (error) {
          printWhite('WebSocket error: $error');
          isConnected.value = false;
          _startReconnect();
        },
        cancelOnError: true,
      );
    } catch (e) {
      printWhite('WebSocket connection failed: $e');
      isConnected.value = false;
      _startReconnect();
    }
  }

  void _startReconnect() {
    printWhite('เริ่ม reconnect');
    if (_reconnectAttempt >= _maxReconnectAttempts) {
      print('Max reconnect attempts reached');
      return;
    }
    _reconnectAttempt++;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: 2 * _reconnectAttempt), () {
      print('Trying to reconnect...');
      connectWebSocket();
    });
  }

  void _handleMessage(dynamic message) async {
    SetData data = SetData();
    final socketMessage = receieveMessageFromJson(message);

    if (socketMessage.event == "message") {
      // var updateChat = chatController.conversations!.value.data
      //     .firstWhereOrNull((element) =>
      //         element.chatRoomId == socketMessage.messageData.chatRoomId);

      // if (updateChat == null) {
      //   var newMsg = ReciveMessage(
      //     messageData: socketMessage.messageData,
      //     event: socketMessage.event,
      //     isMe: socketMessage.messageData.senderRole == "customer" ||
      //         socketMessage.messageData.senderRole == "system",
      //   );

      //   chatController.addMessage(newMsg);
      //   return;
      // }

      // updateChat.messageText = socketMessage.messageData.messageText;
      // updateChat.lastSend = socketMessage.messageData.sendDate;
      // updateChat.unRead = socketMessage.messageData.isRead == 0
      //     ? (socketMessage.messageData.senderRole == "customer"
      //         ? updateChat.unRead
      //         : updateChat.unRead + 1)
      //     : updateChat.unRead;

      if (socketMessage.messageData.senderRole != "customer" &&
          !chatController.openPlatformChatRoom.value) {
        chatController.countChat.value += 1;
      }

      chatController.sortConversationsByLastSend();

      var newMsg = ReciveMessage(
        messageData: socketMessage.messageData,
        event: socketMessage.event,
        isMe: socketMessage.messageData.senderRole == "customer" ||
            socketMessage.messageData.senderRole == "system",
      );

      chatController.addMessage(newMsg);

      if (socketMessage.messageData.senderRole == "customer") return;

      if (Get.currentRoute == '/ChatAppWithSeller' &&
          chatController.openChatRoom.value ==
              socketMessage.messageData.chatRoomId) {
        var payload = {
          "event": "customer_read_message",
          "receiver_id": socketMessage.messageData.senderId,
          "message_data": {
            "chat_room_id": socketMessage.messageData.chatRoomId,
            "message_id": socketMessage.messageData.messageId,
            "sender_role": "customer",
            "sender_id": await data.b2cCustID
          }
        };
        channel!.sink.add(jsonEncode(payload));
      }
    } else if (socketMessage.event == "read_message") {
      if (chatController.openChatRoom.value ==
          socketMessage.messageData.chatRoomId) {
        var isSellerRead = chatController.messages.firstWhereOrNull((e) =>
            e.messageData.messageId == socketMessage.messageData.messageId);
        if (isSellerRead == null) return;

        isSellerRead.messageData.isRead = 1;
        chatController.messages.refresh();
      }
    } else if (socketMessage.event == "readall_message") {
      if (chatController.openChatRoom.value ==
          socketMessage.messageData.chatRoomId) {
        for (var chat in chatController.messages) {
          if (chat.messageData.chatRoomId ==
              chatController.openChatRoom.value) {
            chat.messageData.isRead = 1;
          }
        }
        chatController.messages.refresh();
      }
    } else if (socketMessage.event == "readall_device_message" ||
        socketMessage.event == "read_device_message") {
      var updateChat = chatController.conversations!.value.data
          .firstWhereOrNull((element) =>
              element.chatRoomId == socketMessage.messageData.chatRoomId);

      if (updateChat == null) return;
      // updateChat.messageText = socketMessage.messageData.messageText;
      // updateChat.lastSend = socketMessage.messageData.sendDate;
      updateChat.unRead = 0;
      chatController.sortConversationsByLastSend();
    }
  }
}
