import 'package:fridayonline/member/components/home/loadmore.enduser.dart';
import 'package:fridayonline/member/components/profile/enduser.profile.dart';
import 'package:fridayonline/member/components/profile/menu.section.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/controller/chat.ctr.dart';
import 'package:fridayonline/member/controller/enduser.home.ctr.dart';
import 'package:fridayonline/member/controller/enduser.signin.ctr.dart';
import 'package:fridayonline/member/controller/order.ctr.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:fridayonline/member/views/(chat)/chat.platform.dart';
import 'package:fridayonline/member/views/(profile)/settings.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;

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
          "icon": Image.asset('assets/images/icon/paying2.png', width: 28),
        },
        {
          "name": "ที่ต้องจัดส่ง",
          "icon": Image.asset('assets/images/icon/delivering2.png', width: 28),
        },
        {
          "name": "ที่ต้องได้รับ",
          "icon": Image.asset('assets/images/icon/recieving2.png', width: 28),
        },
        {
          "name": "ยกเลิก/คืนเงิน",
          "icon": Image.asset('assets/images/icon/cancel2.png', width: 28),
        },
      ]
    },
  ];

  List<Map<String, Object>> couponMenu = [
    {
      "title": "อื่นๆ",
      "subtitle": [
        {
          "name": "โครงการพิเศษ",
          "icon": Image.asset('assets/images/icon/projects2.png', width: 32),
        },
        {
          "name": "คูปองของฉัน",
          "icon": Image.asset('assets/images/icon/coupon_me2.png', width: 32),
        },
        {
          "name": "รวมคูปอง",
          "icon": Image.asset('assets/images/icon/coupon_all2.png', width: 32),
        },
        {
          "name": "ฟรายเดย์ Coin",
          "icon": Image.asset('assets/images/icon/friday_coin2.png', width: 32),
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
  void setShowActivity() {
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
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            color: const Color(0xFFF3F3F4),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/profileimg/background.png',
                  fit: BoxFit.cover,
                  height: 220,
                ),
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SafeArea(
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(),
                                    Obx(() {
                                      if (profileCtl.isLoading.value) {
                                        return const SizedBox();
                                      }
                                      return Row(
                                        children: [
                                          InkWell(
                                              highlightColor:
                                                  Colors.transparent,
                                              splashFactory:
                                                  NoSplash.splashFactory,
                                              onTap: () async {
                                                await Get.to(
                                                    () => const Settings(),
                                                    arguments: {
                                                      "displayName": profileCtl
                                                          .profileData
                                                          .value!
                                                          .displayName,
                                                      "mobile": profileCtl
                                                          .profileData
                                                          .value!
                                                          .mobile,
                                                      "image": profileCtl
                                                          .profileData
                                                          .value!
                                                          .image
                                                    })?.then((result) {
                                                  profileCtl.fetchProfile();
                                                });
                                              },
                                              child: Image.asset(
                                                "assets/images/profileimg/setting.png",
                                                width: 28,
                                              )),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          SizedBox(
                                            width: 45,
                                            child: badges.Badge(
                                                position:
                                                    badges.BadgePosition.topEnd(
                                                        top: 2, end: 0),
                                                badgeAnimation: const badges
                                                    .BadgeAnimation.slide(
                                                    loopAnimation: false),
                                                badgeContent: Obx(() {
                                                  return cartCtr.isLoadingCart
                                                              .value &&
                                                          cartCtr.cartItems ==
                                                              null
                                                      ? Text(
                                                          '0',
                                                          style: GoogleFonts
                                                              .ibmPlexSansThai(
                                                                  height: 1,
                                                                  color:
                                                                      themeColorDefault,
                                                                  fontSize: 10),
                                                        )
                                                      : Text(
                                                          '${cartCtr.cartItems!.value.data.map((e) => e.items.length).fold(0, (previousValue, element) => previousValue + element)}',
                                                          style: GoogleFonts
                                                              .ibmPlexSansThai(
                                                                  height: 1,
                                                                  color:
                                                                      themeColorDefault,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 10),
                                                        );
                                                }),
                                                badgeStyle: badges.BadgeStyle(
                                                    badgeColor: Colors.white,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5)),
                                                child: IconButton(
                                                  highlightColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  onPressed: () async {
                                                    Get.find<EndUserCartCtr>()
                                                        .fetchCartItems();
                                                    Get.to(() =>
                                                        const EndUserCart());
                                                  },
                                                  icon: Image.asset(
                                                    "assets/images/profileimg/cart.png",
                                                    width: 26,
                                                  ),
                                                )),
                                          ),
                                          Obx(() {
                                            if (endUserSignInCtr
                                                .isLoading.value) {
                                              return const SizedBox();
                                            } else if (endUserSignInCtr
                                                    .custId ==
                                                0) {
                                              return const SizedBox();
                                            }
                                            return Container(
                                              // width: 40,
                                              // color: Colors.amber,
                                              margin: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: badges.Badge(
                                                  position: badges.BadgePosition
                                                      .topEnd(top: 2, end: 6),
                                                  badgeAnimation: const badges
                                                      .BadgeAnimation.slide(
                                                      loopAnimation: false),
                                                  badgeContent: Obx(() {
                                                    return Text(
                                                      chatCtr.countChat.value
                                                          .toString(),
                                                      style: GoogleFonts
                                                          .ibmPlexSansThai(
                                                              height: 1,
                                                              color:
                                                                  themeColorDefault,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 10),
                                                    );
                                                  }),
                                                  badgeStyle: badges.BadgeStyle(
                                                      badgeColor: Colors.white,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5)),
                                                  child: IconButton(
                                                    highlightColor:
                                                        Colors.transparent,
                                                    splashColor:
                                                        Colors.transparent,
                                                    onPressed: () async {
                                                      chatCtr
                                                          .fetchSellerChat(0);
                                                      Get.to(() =>
                                                          const ChatAppWithPlatform());
                                                    },
                                                    icon: Image.asset(
                                                      "assets/images/profileimg/chat.png",
                                                      width: 28,
                                                    ),
                                                  )),
                                            );
                                          }),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                              textScaler: const TextScaler.linear(1.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const DataProfiles(),
                              buildMenuSection("ข้อมูลคำสั่งซื้อ", ordermMenu),
                              buildMenuSection("คูปองส่วนลด", couponMenu),
                              buildMenuSection("คำแนะนำการใช่้งาน", helpMenu),
                              // const B2cSpecialProject(),
                              const LoadmoreEndUser(),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
