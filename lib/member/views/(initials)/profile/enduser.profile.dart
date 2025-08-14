import 'package:fridayonline/member/components/home/loadmore.enduser.dart';
import 'package:fridayonline/member/components/profile/banner.special.project.dart';
import 'package:fridayonline/member/components/profile/enduser.profile.dart';
import 'package:fridayonline/member/components/profile/menu.section.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/controller/chat.ctr.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/member/controller/order.ctr.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:fridayonline/member/views/(chat)/chat.dart';
import 'package:fridayonline/member/views/(profile)/settings.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
final ProfileCtl profileCtl = Get.put(ProfileCtl());
final EndUserCartCtr cartCtr = Get.find();
final OrderController orderCtr = Get.find<OrderController>();

class EndUserProfile extends StatefulWidget {
  const EndUserProfile({super.key});

  @override
  State<EndUserProfile> createState() => _EndUserProfileState();
}

class _EndUserProfileState extends State<EndUserProfile> {
  final List<Map<String, Object?>> ordermMenu = [
    {
      "title": "ข้อมูลการสั่งซื้อ",
      "subtitle": [
        {
          "name": "ที่ต้องชำระ",
          "icon": Image.asset('assets/images/icon/paying.png', width: 28),
        },
        {
          "name": "ที่ต้องจัดส่ง",
          "icon": Image.asset('assets/images/icon/delivering.png', width: 28),
        },
        {
          "name": "ที่ต้องได้รับ",
          "icon": Image.asset('assets/images/icon/recieving.png', width: 28),
        },
        {
          "name": "ยกเลิก/คืนเงิน",
          "icon": Image.asset('assets/images/icon/cancel.png', width: 28),
        },
      ]
    },
  ];

  List<Map<String, Object>> couponMenu = [
    {
      "title": "อื่นๆ",
      "subtitle": [
        {
          "name": "คูปองของฉัน",
          "icon": Image.asset('assets/images/icon/coupon_me.png', width: 32),
        },
        {
          "name": "รวมคูปอง",
          "icon": Image.asset('assets/images/icon/coupon_all.png', width: 32),
        },
        {
          "name": "Friday Online Coin",
          "icon":
              Image.asset('assets/images/b2c/icon/friday_coin.png', width: 32),
        },
        {
          "name": "",
          "icon": null,
        },
      ]
    },
  ];

  List<Map<String, Object>> helpMenu = [
    {
      "title": "ช่วยเหลือ",
      "subtitle": [
        {
          "name": "คำแนะนำการใช้งาน",
          "icon": Image.asset('assets/images/b2c/icon/help.png', width: 24),
        },
        {
          "name": "chat กับเรา",
          "icon": Image.asset('assets/images/b2c/icon/chat.png', width: 20),
          // "icon": Image.asset('assets/images/icon/help.png', width: 32),
        },
      ]
    },
  ];
  bool showActivity = true;
  setShowActivity() {
    setState(() {
      showActivity = !showActivity;
    });
  }

  final EndUserHomeCtr homeCtr = Get.find();
  final ScrollController _scrollController = ScrollController();
  int offset = 20;

  @override
  void initState() {
    super.initState();
    orderCtr.fetchOrderHeader();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchMoreRecommend();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    offset = 20;
    _scrollController.dispose();
    homeCtr.resetRecommend();
  }

  void fetchMoreRecommend() async {
    homeCtr.isFetchingLoadmore.value = true;

    try {
      // ดึงข้อมูลใหม่จาก API
      final newRecommend = await homeCtr.fetchMoreRecommend(offset);

      if (newRecommend!.data.isNotEmpty) {
        homeCtr.recommend!.data.addAll(newRecommend.data);
        offset += 20;
      }
    } finally {
      homeCtr.isFetchingLoadmore.value = false;
    }
  }

  final EndUserSignInCtr endUserSignInCtr = Get.put(EndUserSignInCtr());
  final chatCtr = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
              clipBehavior: Clip.none,
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: 0,
              floating: true,
              snap: true,
              pinned: false, // ถ้าต้องการให้หายไปจริงๆ ตอน scroll
              toolbarHeight: 40,
              title: Padding(
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      if (endUserSignInCtr.isLoading.value) {
                        return const SizedBox();
                      }
                      if (endUserSignInCtr.repSeq != "") {
                        return Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.blue,
                                  themeColorDefault.withOpacity(1),
                                  themeColorDefault.withOpacity(1),
                                  themeColorDefault.withOpacity(0.8),
                                ]),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: GestureDetector(
                              onTap: () async {
                                var socketCtr = Get.find<WebSocketController>();
                                SetData data = SetData();
                                if (await data.repSeq == "" ||
                                    await data.repSeq == "null") {
                                  return;
                                }
                                socketCtr.onClose();

                                endUserSignInCtr.settingPreference(
                                    '1', '', '2', await data.b2cCustID);
                                // Get.offAll(
                                //     () => const SplashScreen());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.shopping_bag,
                                      size: 20, color: Colors.white),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    'ไปยังสมาชิกFriday Online',
                                    style: GoogleFonts.notoSansThaiLooped(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded,
                                      size: 12, color: Colors.white)
                                ],
                              ),
                            ));
                      } else {
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Get.offAllNamed('/EndUserHome',
                                parameters: {'changeView': "0"});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.blue,
                                    themeColorDefault.withOpacity(1),
                                    themeColorDefault.withOpacity(1),
                                    themeColorDefault.withOpacity(0.8),
                                  ]),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  )),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.home_outlined,
                                      size: 24, color: Colors.white),
                                  SizedBox(
                                    width: 4,
                                  )
                                ],
                              )),
                        );
                      }
                    }),
                    Obx(() {
                      if (profileCtl.isLoading.value) {
                        return const SizedBox();
                      }
                      return Row(
                        children: [
                          InkWell(
                            highlightColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            onTap: () async {
                              await Get.to(() => const Settings(), arguments: {
                                "displayName":
                                    profileCtl.profileData.value!.displayName,
                                "mobile": profileCtl.profileData.value!.mobile,
                                "image": profileCtl.profileData.value!.image
                              })?.then((result) {
                                profileCtl.fetchProfile();
                              });
                            },
                            child: Icon(
                              Icons.settings_outlined,
                              color: Colors.grey.shade700,
                              size: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          SizedBox(
                            width: 45,
                            child: badges.Badge(
                                position:
                                    badges.BadgePosition.topEnd(top: 2, end: 0),
                                badgeAnimation:
                                    const badges.BadgeAnimation.slide(
                                        loopAnimation: false),
                                badgeContent: Obx(() {
                                  return cartCtr.isLoadingCart.value &&
                                          cartCtr.cartItems == null
                                      ? Text(
                                          '0',
                                          style: GoogleFonts.notoSansThaiLooped(
                                              height: 1,
                                              color: Colors.white,
                                              fontSize: 10),
                                        )
                                      : Text(
                                          '${cartCtr.cartItems!.value.data.map((e) => e.items.length).fold(0, (previousValue, element) => previousValue + element)}',
                                          style: GoogleFonts.notoSansThaiLooped(
                                              height: 1,
                                              color: Colors.white,
                                              fontSize: 10),
                                        );
                                }),
                                badgeStyle: badges.BadgeStyle(
                                    badgeColor: themeColorDefault,
                                    padding: const EdgeInsets.all(5)),
                                child: IconButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: () async {
                                    Get.find<EndUserCartCtr>().fetchCartItems();
                                    Get.to(() => const EndUserCart());
                                  },
                                  icon: Image.asset(
                                    'assets/images/icon/cart-grey.png',
                                  ),
                                )),
                          ),
                          Obx(() {
                            if (endUserSignInCtr.isLoading.value) {
                              return const SizedBox();
                            } else if (endUserSignInCtr.custId == 0) {
                              return const SizedBox();
                            }
                            return Container(
                              // width: 40,
                              // color: Colors.amber,
                              margin: const EdgeInsets.only(right: 5.0),
                              child: badges.Badge(
                                  position: badges.BadgePosition.topEnd(
                                      top: 2, end: 6),
                                  badgeAnimation:
                                      const badges.BadgeAnimation.slide(
                                          loopAnimation: false),
                                  badgeContent: Obx(() {
                                    return Text(
                                      chatCtr.countChat.value.toString(),
                                      style: GoogleFonts.notoSansThaiLooped(
                                          height: 1,
                                          color: Colors.white,
                                          fontSize: 10),
                                    );
                                  }),
                                  badgeStyle: badges.BadgeStyle(
                                      badgeColor: themeColorDefault,
                                      padding: const EdgeInsets.all(5)),
                                  child: IconButton(
                                    padding: const EdgeInsets.only(
                                        bottom: 12, top: 5),
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onPressed: () async {
                                      chatCtr.fetchSellerChat(0);
                                      Get.to(() => const ChatApp());
                                    },
                                    icon: Image.asset(
                                        "assets/images/b2c/chat/chat-grey.png"),
                                  )),
                            );
                          }),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            // ส่วน Body ที่จะ scroll ได้
            SliverToBoxAdapter(
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DataProfiles(),
                    buildMenuSection("ข้อมูลคำสั่งซื้อ", ordermMenu),
                    buildMenuSection("คูปองส่วนลด", couponMenu),
                    buildMenuSection("คำแนะนำการใช่้งาน", helpMenu),
                    const B2cSpecialProject(),
                    const LoadmoreEndUser(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
