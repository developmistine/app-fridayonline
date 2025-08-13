import 'dart:convert';
import 'package:appfridayecommerce/enduser/components/appbar/appbar.master.dart';
import 'package:appfridayecommerce/enduser/controller/chat.ctr.dart';
import 'package:appfridayecommerce/enduser/models/chat/recieve.message.model.dart';
import 'package:appfridayecommerce/enduser/utils/function.dart';
import 'package:appfridayecommerce/enduser/views/(chat)/chat.seller.dart';
import 'package:appfridayecommerce/preferrence.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final webSocketController = Get.put(WebSocketController());
  final ChatController chatController = Get.put(ChatController());
  final ScrollController scrollCtr = ScrollController();

  List<ReciveMessage> messages = [];

  var isLoading = false;
  int offset = 40;

  @override
  void initState() {
    super.initState();
    scrollCtr.addListener(() {
      if (scrollCtr.position.pixels == scrollCtr.position.maxScrollExtent) {
        if (chatController.isLoadingMore.value) {
          return;
        }
        fetchMoreSeller();
      }
    });
  }

  @override
  void dispose() {
    chatController.clearMessages();

    offset = 40;
    super.dispose();
  }

  void fetchMoreSeller() async {
    chatController.isLoadingMoreSeller.value = true;
    try {
      final loadMoreData = await chatController.fetchMoreSeller(offset);

      if (loadMoreData!.data.isNotEmpty) {
        final newItems = loadMoreData.data;
        chatController.conversations!.value.data.addAll(newItems);
        offset += 40;
      }
    } finally {
      chatController.isLoadingMoreSeller.value = false;
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
                  textStyle: GoogleFonts.notoSansThaiLooped())),
          textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBarMasterEndUser('แชท'),
          body: Obx(() {
            if (chatController.isLoadingConversation.value) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return chatController.conversations!.value.data.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/b2c/chat/no-chat.png',
                          width: 150,
                        ),
                      ),
                      Text(
                        'ยังไม่มีประวัติการสนทนา',
                        style: GoogleFonts.notoSansThaiLooped(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 80,
                      )
                    ],
                  )
                : Container(
                    constraints: BoxConstraints(minHeight: Get.height),
                    child: ListView.builder(
                      controller: scrollCtr,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 8),
                      shrinkWrap: true,
                      primary: false,
                      // itemCount: listShop.length,
                      itemCount: chatController
                              .conversations!.value.data.length +
                          (chatController.isLoadingMoreSeller.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index <
                            chatController.conversations!.value.data.length) {
                          var shop =
                              chatController.conversations!.value.data[index];
                          return InkWell(
                            onTap: () async {
                              SetData data = SetData();
                              if (shop.unRead > 0) {
                                chatController.countChat.value -= 1;
                              }
                              final message = {
                                "event": "customer_readall_message",
                                "receiver_id": shop.sellerId,
                                "is_me": true,
                                "message_data": {
                                  "chat_room_id": shop.chatRoomId,
                                  "sender_role": "customer",
                                  "sender_id": await data.b2cCustID
                                }
                              };
                              webSocketController.channel!.sink
                                  .add(jsonEncode(message));
                              chatController.messages.removeWhere((element) =>
                                  element.messageData.chatRoomId ==
                                  shop.chatRoomId);
                              chatController.openChatRoom.value =
                                  shop.chatRoomId;
                              await Get.to(() => ChatAppWithSeller(
                                      shop: shop,
                                      channel: webSocketController.channel))!
                                  .then((value) {
                                shop.unRead = 0;
                                chatController.conversations!.refresh();
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Container(
                                            width: 55,
                                            height: 55,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                width: 55,
                                                height: 55,
                                                imageUrl: shop.sellerImage,
                                                errorWidget:
                                                    (context, url, error) {
                                                  return const Icon(
                                                      Icons.shopify);
                                                },
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color:
                                                    Colors.deepOrange.shade700),
                                            child: const Text(
                                              'Mall',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 9,
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        shop.sellerName,
                                                        style: GoogleFonts
                                                            .notoSansThaiLooped(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 13),
                                                      ),
                                                      Text(
                                                        shop.messageText == ""
                                                            ? "เริ่มบทสนทนา"
                                                            : shop.messageText,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts
                                                            .notoSansThaiLooped(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      formatContactChatTime(
                                                          shop.lastSend),
                                                      style: GoogleFonts
                                                          .notoSansThaiLooped(
                                                              fontSize: 11,
                                                              color: Colors.grey
                                                                  .shade500),
                                                    ),
                                                    if (shop.unRead > 0)
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6),
                                                        decoration:
                                                            const BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Text(
                                                          shop.unRead
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .notoSansThaiLooped(
                                                                  height: 1,
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 0,
                                )
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
