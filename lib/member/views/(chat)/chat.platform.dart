import 'dart:async';
import 'dart:convert';
import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/components/viewer/fullscreen.image.dart';
import 'package:fridayonline/member/components/viewer/video.chat.dart';
import 'package:fridayonline/member/controller/chat.ctr.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:fridayonline/member/models/chat/recieve.message.model.dart';
import 'package:fridayonline/member/models/chat/seller.list.model.dart';
import 'package:fridayonline/member/models/chat/sticker_model.dart';
import 'package:fridayonline/member/services/chat/chat.service.dart';
import 'package:fridayonline/member/utils/function.dart';
import 'package:fridayonline/member/views/(chat)/chat.camera.dart';
import 'package:fridayonline/member/views/(chat)/chat.gallery.dart';
import 'package:fridayonline/member/views/(chat)/chat_sticker.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image_picker/image_picker.dart' as img_picker;

class ChatRenderItem {
  final Widget widget;
  ChatRenderItem(this.widget);
}

class ChatAppWithPlatform extends StatefulWidget {
  const ChatAppWithPlatform({
    super.key,
  });

  @override
  State<ChatAppWithPlatform> createState() => _ChatAppWithPlatformState();
}

class _ChatAppWithPlatformState extends State<ChatAppWithPlatform>
    with WidgetsBindingObserver {
  final ChatController chatController = Get.put(ChatController());
  final ProfileCtl profileController = Get.put(ProfileCtl());
  final TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();
  List<SellerChat> listShop = [];

  FocusNode textFocus = FocusNode();
  List<XFile>? imageFile = [];
  final chatScrollController = ScrollController();
  WebSocketChannel? channel;
  int chatRoomId = 0;
  int sellerId = 0;
  // final ImagePicker _pickerImage = ImagePicker();

  int offset = 40;
  bool isLoading = false;

  Future<void> sendItem(payload) async {
    sendMessageSocket(payload);
  }

  @override
  void initState() {
    super.initState();

    addChatRoom();
    offset = 40;
  }

  @override
  void dispose() {
    if (!mounted) return;
    offset = 0;
    _controller.dispose();
    _scrollController.dispose();
    chatController.resetRecommend();
    chatScrollController.dispose();
    // channel!.sink.close(status.goingAway);
    super.dispose();
  }

  void fetchProfile() {
    if (profileController.profileData.value == null) {
      profileController.fetchProfile();
    }
  }

  Future<void> addChatRoom() async {
    chatController.isLoading.value = true;
    await addChatRoomService(1).then((res) async {
      chatController.openChatRoom.value = res.data.chatRoomId;

      setState(() {
        chatRoomId = res.data.chatRoomId;
        sellerId = res.data.sellerId;
      });

      chatController.fetchHistoryChat(chatRoomId, 0).then((res) {
        chatScrollController.addListener(() {
          if (chatScrollController.position.pixels ==
              chatScrollController.position.maxScrollExtent) {
            if (chatController.isLoadingMore.value) {
              return;
            }
            fetchMoreHistoryChat();
          }
        });
      });
      fetchProfile();
      // connectWebSocket();
    });
  }

  // connectWebSocket() async {
  //   SetData data = SetData();
  //   // สร้าง channel ใหม่
  //   channel = WebSocketChannel.connect(
  //     Uri.parse(
  //         'wss://app.friday.co.th/ws/chat?userId=CU${await data.b2cCustID}'),
  //   );
  //   final message = {
  //     "event": "customer_readall_message",
  //     "receiver_id": sellerId,
  //     "is_me": true,
  //     "message_data": {
  //       "chat_room_id": chatRoomId,
  //       "sender_role": "customer",
  //       "sender_id": await data.b2cCustID
  //     }
  //   };
  //   channel!.sink.add(jsonEncode(message));
  //   // ตั้ง listener
  //   receieveMessage();
  // }

  StreamSubscription<dynamic> receieveMessage() {
    return channel!.stream.listen(
      (message) {
        final socketMessage = receieveMessageFromJson(message);
        if (socketMessage.event == "message") {
          if (!mounted) return;
          setState(() {
            var newMsg = ReciveMessage(
              messageData: MessageData(
                messageText: socketMessage.messageData.messageText,
                messageType: socketMessage.messageData.messageType,
                messageId: socketMessage.messageData.messageId,
                chatRoomId: socketMessage.messageData.chatRoomId,
                senderId: socketMessage.messageData.senderId,
                senderRole: socketMessage.messageData.senderRole,
                imgPath: socketMessage.messageData.imgPath,
                imgFilename: socketMessage.messageData.imgFilename,
                isRead: socketMessage.messageData.isRead,
                sendDate: socketMessage.messageData.sendDate,
                attachment: socketMessage.messageData.attachment,
                productId: socketMessage.messageData.productId,
                title: socketMessage.messageData.title,
                discount: socketMessage.messageData.discount,
                price: socketMessage.messageData.price,
                priceBeforeDiscount:
                    socketMessage.messageData.priceBeforeDiscount,
                image: socketMessage.messageData.image,
                orderId: socketMessage.messageData.orderId,
                orderNo: socketMessage.messageData.orderNo,
                orderStatus: socketMessage.messageData.orderStatus,
                orderColorCode: socketMessage.messageData.orderColorCode,
                orderStatusDesc: socketMessage.messageData.orderStatusDesc,
                orderTotalQty: socketMessage.messageData.orderTotalQty,
                orderTotalAmount: socketMessage.messageData.orderTotalAmount,
              ),
              event: socketMessage.event,
              isMe: socketMessage.messageData.senderRole == "customer" ||
                      socketMessage.messageData.senderRole == "system"
                  ? true
                  : false,
            );
            chatController.addMessage(newMsg);
            // chatController.messages.insert(0, newMsg);
            if (socketMessage.messageData.senderRole == "customer") return;
            if (chatController.openChatRoom.value ==
                socketMessage.messageData.chatRoomId) {
              var payload = {
                "event": "customer_read_message",
                "receiver_id": socketMessage.messageData.senderId,
                "message_data": {
                  "chat_room_id": socketMessage.messageData.chatRoomId,
                  "message_id": socketMessage.messageData.messageId,
                  "sender_role": "customer"
                }
              };
              channel!.sink.add(jsonEncode(payload));
            }
          });
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
        }
      },
      onDone: () {
        print('WebSocket closed');
        // startReconnect();
      },
      onError: (error) {
        print('WebSocket error: $error');
        // startReconnect();
      },
      cancelOnError: true,
    );
  }

  Future<void> sendMessage(int type, String path, String fileName) async {
    SetData data = SetData();
    if (type == 3 || type == 4) {
      final message = {
        "event": "customer_send_message",
        "receiver_id": sellerId,
        "is_me": true,
        "message_data": {
          "chat_room_id": chatRoomId,
          "sender_id": await data.b2cCustID,
          "sender_role": "customer",
          "message_type": type, //message_type  1 text 2 file 3 image 4 video
          "message_text": "",
          "img_path": path,
          "img_filename": fileName
        },
        "contact_data": {
          "customer_id": await data.b2cCustID,
          "customer_image": profileController.profileData.value!.image,
          "customer_name": profileController.profileData.value!.displayName,
          "seller_id": sellerId,
          "seller_image": "",
          "seller_name": "",
        },
      };
      sendMessageSocket(message);
    } else if (_controller.text.isNotEmpty && _controller.text.trim() != "") {
      var text = _controller.text;

      final message = {
        "event": "customer_send_message",
        "receiver_id": sellerId,
        "is_me": true,
        "message_data": {
          "chat_room_id": chatRoomId,
          "sender_id": await data.b2cCustID,
          "sender_role": "customer",
          "message_type": type, //message_type  1 text 2 file 3 image 4 video
          "message_text": text,
          "img_path": "",
          "img_filename": ""
        }
      };

      sendMessageSocket(message);
    } else {
      _controller.text = "";
    }
  }

  void sendMessageSocket(Map<String, Object> message) {
    channel!.sink.add(jsonEncode(message));

    _controller.clear();
  }

  void fetchMoreHistoryChat() async {
    chatController.isLoadingMore.value = true;

    try {
      final loadMoreData = await chatController.fetchMoreChat(0, offset);

      if (loadMoreData!.data.isNotEmpty) {
        final newItems = loadMoreData.data.reversed.toList();
        // เพิ่มข้อมูลใหม่ที่โหลดมาไปข้างหน้า
        for (var historyItem in newItems) {
          chatController.messages.insert(
              0,
              ReciveMessage(
                  event: '',
                  messageData: historyItem,
                  isMe: historyItem.senderRole == "customer"));
        }
        offset += 40; // เพิ่ม offset
      }
    } finally {
      chatController.isLoadingMore.value = false;
    }
  }

  Widget buildSticker(ReciveMessage msg, bool isMe) {
    if (msg.messageData.image == "") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8)),
                width: 50,
                height: 50,
                child: Text(
                  "!",
                  style: TextStyle(color: Colors.grey.shade500),
                )),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  isMe ? themeColorDefault.withOpacity(0.3) : Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "ขออภัยไม่สามารถเปิดสติกเกอร์นี้ได้",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Align(
        alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (msg.isMe) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    msg.messageData.isRead == 1 ? "อ่านแล้ว" : "",
                    style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 11, color: Colors.grey.shade700),
                  ),
                  Text(
                    formatChatTime(msg),
                    style: GoogleFonts.ibmPlexSansThai(fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: Get.width / 2, maxHeight: 200),
              child: Container(
                width: 160,
                // height: 160,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(msg.messageData.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            if (!msg.isMe) ...[
              const SizedBox(width: 8),
              Text(
                formatChatTime(msg),
                style: GoogleFonts.ibmPlexSansThai(fontSize: 11),
              ),
            ],
          ],
        ),
      );
    }
  }

  Widget buildSingleImage(ReciveMessage msg, bool isMe) {
    if (msg.messageData.attachment == "") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8)),
                width: 50,
                height: 50,
                child: Text(
                  "!",
                  style: TextStyle(color: Colors.grey.shade500),
                )),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  isMe ? themeColorDefault.withOpacity(0.3) : Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "ขออภัยไม่สามารถดูรูปภาพนี้ได้",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (msg.isMe) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  msg.messageData.isRead == 1 ? "อ่านแล้ว" : "",
                  style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 11, color: Colors.grey.shade700),
                ),
                Text(
                  formatChatTime(msg),
                  style: GoogleFonts.ibmPlexSansThai(fontSize: 11),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onTap: () {
              Get.to(() => FullScreenImageViewer(
                    imageUrls: [msg.messageData.attachment],
                    initialIndex: 0,
                  ));
            },
            child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: Get.width / 2, maxHeight: 200),
                child: Container(
                  width: 160,
                  // height: 160,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          msg.messageData.attachment),
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
          ),
          if (!msg.isMe) ...[
            const SizedBox(width: 8),
            Text(
              formatChatTime(msg),
              style: GoogleFonts.ibmPlexSansThai(fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  List<ChatRenderItem> buildChatRenderItems(List<ReciveMessage> msgs) {
    final List<ChatRenderItem> items = [];
    final Set<String> displayedDates = {};

    for (int i = 0; i < msgs.length; i++) {
      final msg = msgs[i];

      final msgDateKey = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(msg.messageData.sendDate));

      /// ✅ แทรกหัววันที่ “ก่อน” แสดงข้อความแรกของวันนั้น
      if (!displayedDates.contains(msgDateKey)) {
        displayedDates.add(msgDateKey);

        items.insert(
            0,
            ChatRenderItem(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      formatChatDateHeader(msg.messageData.sendDate),
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ),
              ),
            ));
      }

      // ✅ ค่อยแสดงข้อความตามปกติ
      final widget = msg.messageData.messageType == 3
          ? buildSingleImage(msg, msg.isMe)
          : msg.messageData.messageType == 7
              ? buildSticker(msg, msg.isMe)
              : buildMessageItem(msg);

      items.insert(
          0,
          ChatRenderItem(
            Align(
              alignment:
                  msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: widget,
            ),
          ));
    }

    // ✅ ใส่ “กำลังโหลด...” ไว้ท้าย list (เพราะ reverse แล้วจะขึ้นบน)
    items.add(ChatRenderItem(Obx(() {
      if (chatController.isLoadingMore.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 18, bottom: 8),
            child: Text('กำลังโหลด...', style: TextStyle(fontSize: 11)),
          ),
        );
      }
      return const SizedBox();
    })));

    return items;
  }

  Widget buildMessageItem(ReciveMessage msg) {
    if (msg.messageData.messageType == 1) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: msg.isMe ? Alignment.bottomLeft : Alignment.bottomRight,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300.withOpacity(0.5),
                  offset: const Offset(0, 6),
                  blurRadius: 4,
                  // spreadRadius: 1,
                )
              ],
              color: msg.isMe
                  ? msg.messageData.senderRole == "system"
                      ? Colors.red.withOpacity(0.1)
                      : themeColorDefault
                  : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: msg.isMe
                    ? const Radius.circular(12)
                    : const Radius.circular(0),
                bottomRight: msg.isMe
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
              ),
            ),
            child: buildMessageType(msg),
          ),
          if (msg.isMe && msg.messageData.senderRole != "system")
            Positioned(
                left: -35,
                bottom: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      msg.messageData.isRead == 1 ? "อ่านแล้ว" : "",
                      style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 11, color: Colors.grey.shade700),
                    ),
                    Text(
                      formatChatTime(msg),
                      style: GoogleFonts.ibmPlexSansThai(fontSize: 11),
                    ),
                  ],
                ))
          else
            Positioned(
                right: -28,
                bottom: 8,
                child: Text(
                  formatChatTime(msg),
                  style: GoogleFonts.ibmPlexSansThai(fontSize: 11),
                ))
        ],
      );
    }
    return Container(
      constraints: msg.messageData.messageType == 4
          ? const BoxConstraints(maxWidth: 200)
          : const BoxConstraints(maxWidth: 250),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: msg.messageData.messageType == 1
          ? const EdgeInsets.symmetric(vertical: 10, horizontal: 14)
          : null,
      decoration: msg.messageData.messageType == 1
          ? BoxDecoration(
              color: msg.isMe ? themeColorDefault : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: msg.isMe
                    ? const Radius.circular(12)
                    : const Radius.circular(0),
                bottomRight: msg.isMe
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
              ),
            )
          : null,
      child: buildMessageType(msg),
    );
  }

  Widget buildMessageType(ReciveMessage msg) {
    switch (msg.messageData.messageType) {
      case 1:
        {
          if (msg.messageData.senderRole == "system") {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.red,
                  size: 18,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  msg.messageData.messageText,
                  style: GoogleFonts.ibmPlexSansThai(
                    color: msg.isMe ? Colors.red : Colors.black,
                    fontSize: 12,
                  ),
                ),
              ],
            );
          }
          return Text(
            msg.messageData.messageText,
            style: GoogleFonts.ibmPlexSansThai(
              color: msg.isMe ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          );
        }

      case 4:
        {
          return Stack(
            clipBehavior: Clip.none,
            alignment: msg.isMe ? Alignment.bottomLeft : Alignment.bottomRight,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      VideoMessageWidget(videoUrl: msg.messageData.attachment)),
              if (msg.isMe)
                Positioned(
                    right: 210,
                    bottom: 0,
                    child: Text(
                      formatChatTime(msg),
                      style: GoogleFonts.ibmPlexSansThai(fontSize: 11),
                    ))
              else
                Positioned(
                    left: 210,
                    bottom: 0,
                    child: Text(
                      formatChatTime(msg),
                      style: GoogleFonts.ibmPlexSansThai(fontSize: 11),
                    ))
            ],
          );
        }
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.ibmPlexSansThai())),
          textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBarMasterEndUser('แชทกับFriday Online'),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();

                if (!chatController.emojiShowing.value) {
                  chatController.emojiShowing.value = true;
                }
              },
              child: Container(
                color: Colors.grey.shade100,
                child: Obx(() {
                  if (chatController.isLoading.value) {
                    return Center(
                      child: Text(
                        "รอสักครู่...",
                        style: GoogleFonts.ibmPlexSansThai(fontSize: 11),
                      ),
                    );
                  }
                  if (chatController.messages.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 80),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "เริ่มบทสนทนา",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ),
                      ),
                    );
                  }

                  final reversedMessages = chatController.messages
                      .where((e) => e.messageData.chatRoomId == chatRoomId)
                      .toList();

                  final items = buildChatRenderItems(reversedMessages);

                  return Scrollbar(
                    controller: chatScrollController,
                    thumbVisibility: true,
                    thickness: 4.0,
                    radius: const Radius.circular(8),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: chatScrollController,
                      reverse: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) => items[index].widget,
                    ),
                  );
                }),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          constraints: const BoxConstraints(minWidth: 24),
                          splashRadius: 1,
                          icon: const Icon(Icons.camera_alt_outlined),
                          color: Colors.grey.shade600,
                          onPressed: () async {
                            SetData data = SetData();
                            var result = await Get.to(() => CameraPage(
                                  roomId: chatRoomId,
                                  senderId: sellerId,
                                ));
                            if (result != null && result is img_picker.XFile) {
                              var payload = {
                                "chat_room_id": chatRoomId,
                                "role": "seller",
                                "sender_id": await data.b2cCustID
                              };
                              final imgType = ["jpg", "jpeg", "png", "webp"];
                              final type = result.name.split(".").last;
                              if (imgType.contains(type)) {
                                var res = await chatUploadService(
                                  images: result,
                                  video: null,
                                  json: payload,
                                );
                                if (res!.code == "100") {
                                  sendMessage(3, res.data.imgPath,
                                      res.data.imgFilename);
                                }
                              } else {
                                var res = await chatUploadService(
                                  images: null,
                                  video: result,
                                  json: payload,
                                );
                                if (res!.code == "100") {
                                  sendMessage(4, res.data.imgPath,
                                      res.data.imgFilename);
                                }
                              }
                            }
                          },
                        ),
                        IconButton(
                          constraints: const BoxConstraints(minWidth: 24),
                          splashRadius: 1,
                          icon: const Icon(Icons.image_outlined),
                          color: Colors.grey.shade600,
                          onPressed: () async {
                            SetData data = SetData();
                            var result =
                                await Get.to(() => const ChatGallary());
                            if (result != null &&
                                result is List<img_picker.XFile>) {
                              for (var file in result) {
                                var payload = {
                                  "chat_room_id": chatRoomId,
                                  "role": "seller",
                                  "sender_id": await data.b2cCustID
                                };
                                final imgType = ["jpg", "jpeg", "png", "webp"];
                                final type = file.name.split(".").last;

                                if (imgType.contains(type)) {
                                  var res = await chatUploadService(
                                    images: file,
                                    video: null,
                                    json: payload,
                                  );
                                  if (res!.code == "100") {
                                    sendMessage(3, res.data.imgPath,
                                        res.data.imgFilename);
                                  }
                                } else {
                                  var res = await chatUploadService(
                                    images: null,
                                    video: file,
                                    json: payload,
                                  );
                                  if (res!.code == "100") {
                                    sendMessage(4, res.data.imgPath,
                                        res.data.imgFilename);
                                  }
                                }
                              }
                            }
                          },
                        ),

                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              focusNode: textFocus,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: GoogleFonts.ibmPlexSansThai(fontSize: 14),
                              controller: _controller,
                              onChanged: (val) {
                                setState(() {});
                              },
                              onTap: () {
                                chatController.emojiShowing.value = true;
                              },
                              decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                    onTap: () async {
                                      chatController.emojiShowing.value =
                                          !chatController.emojiShowing.value;

                                      if (chatController.emojiShowing.value) {
                                        textFocus.requestFocus();
                                      } else {
                                        SetData data = SetData();
                                        loadingProductStock(context);
                                        var res = await fetchChatSticker();
                                        Get.back();
                                        Sticker? sticker = await Get.to(() =>
                                            ChatSticker(sticker: res.data));
                                        if (sticker == null) return;
                                        textFocus.unfocus();
                                        FocusScope.of(context).unfocus();
                                        chatController.emojiShowing.value =
                                            true;
                                        chatController.optionShowing.value =
                                            true;
                                        var payload = {
                                          "event": "customer_send_message",
                                          "receiver_id": 1,
                                          "message_data": {
                                            "chat_room_id": chatRoomId,
                                            "sender_id": await data.b2cCustID,
                                            "sender_role": "customer",
                                            "message_type": 7,
                                            "sticker_id": sticker.stickerId,
                                            "image": sticker.stickerImage
                                          },
                                          "contact_data": {
                                            "customer_id": await data.b2cCustID,
                                            "customer_image": profileController
                                                .profileData.value!.image,
                                            "customer_name": profileController
                                                .profileData.value!.displayName,
                                            "seller_id": sellerId,
                                            "seller_image": "",
                                            "seller_name": "",
                                          },
                                        };
                                        sendItem(payload);
                                      }
                                    },
                                    child: Obx(() {
                                      return Icon(
                                        !chatController.emojiShowing.value
                                            ? Icons.keyboard_outlined
                                            : Icons.emoji_emotions_outlined,
                                        color: Colors.grey.shade600,
                                      );
                                    }),
                                  ),
                                  hintText: 'พิมพ์ข้อความ...',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8)),
                            ),
                          ),
                        ),
                        // if (_controller.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.send),
                          color: _controller.text.isEmpty
                              ? Colors.grey.shade600
                              : themeColorDefault,
                          onPressed: () {
                            sendMessage(1, '', '');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  return Offstage(
                    offstage: chatController.emojiShowing.value,
                    child: EmojiPicker(
                      textEditingController: _controller,
                      scrollController: _scrollController,
                      config: Config(
                        height: 306,
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 28 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.2
                                  : 1.0),
                        ),
                        // swapCategoryAndBottomBar: false,
                        skinToneConfig: const SkinToneConfig(),
                        categoryViewConfig: CategoryViewConfig(
                            backgroundColor: Colors.white,
                            iconColorSelected: themeColorDefault,
                            dividerColor: themeColorDefault,
                            indicatorColor: themeColorDefault),
                        // bottomActionBarConfig: const BottomActionBarConfig(),
                        searchViewConfig: const SearchViewConfig(),
                        bottomActionBarConfig:
                            const BottomActionBarConfig(enabled: false),
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: Get.mediaQuery.viewInsets.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
