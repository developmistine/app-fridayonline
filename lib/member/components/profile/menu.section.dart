import 'package:fridayonline/member/components/webview/webview.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:fridayonline/member/views/(chat)/chat.platform.dart';
import 'package:fridayonline/member/views/(coupon)/conpon.me.dart';
import 'package:fridayonline/member/views/(coupon)/coupon.all.dart';
import 'package:fridayonline/member/views/(other)/about.friday.dart';
import 'package:fridayonline/member/views/(other)/deleteAcount.dart';
import 'package:fridayonline/member/views/(other)/help.dart';
import 'package:fridayonline/member/views/(profile)/edit.profile.dart';
import 'package:fridayonline/member/views/(profile)/friday.coin.dart';
import 'package:fridayonline/member/views/(profile)/myaddress.dart';
import 'package:fridayonline/member/views/(profile)/myorder.dart';
import 'package:fridayonline/member/views/(profile)/varsion.dart';
import 'package:fridayonline/member/widgets/dialog.confirm.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../views/(other)/instructions.dart';

final ProfileCtl profileCtl = Get.put(ProfileCtl());

Widget buildMenuSection(
    String sectionTitle, List<Map<String, Object?>> menuItems) {
  return ListView.builder(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    primary: false,
    itemCount: menuItems.length,
    itemBuilder: (context, index) {
      var category = menuItems[index];
      var title = category["title"] as String;
      var subtitles = category["subtitle"] as List<Map<String, Object?>>;

      return Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 4.0, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ).marginOnly(bottom: 8),
                  if (title == 'ข้อมูลการสั่งซื้อ')
                    InkWell(
                      onTap: () async {
                        orderCtr.fetchOrderList(3, 0);
                        await Get.to(() => const MyOrderHistory(),
                            arguments: 3);
                        orderCtr.fetchOrderHeader();
                      },
                      child: Row(
                        children: [
                          Text(
                            "ประวัติการซื้อ",
                            style: GoogleFonts.ibmPlexSansThai(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: themeColorDefault),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircleAvatar(
                                backgroundColor: themeColorDefault,
                                foregroundColor: Colors.white,
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 13,
                                )),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),

            // Subtitle Items
            if (title != "ช่วยเหลือ")
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subtitles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 4,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, subIndex) {
                  final subtitle = subtitles[subIndex];
                  final name = subtitle["name"] as String;
                  final icon = subtitle["icon"] as Widget?;

                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => handleMenuTap(name),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (icon != null)
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topRight,
                            children: [
                              icon,
                              if (title == 'ข้อมูลการสั่งซื้อ')
                                Positioned(
                                  top: -8,
                                  right: -8,
                                  child: Obx(() {
                                    if (orderCtr.isLoading.value) {
                                      return const SizedBox.shrink();
                                    }
                                    if (orderCtr.header == null) {
                                      return const SizedBox.shrink();
                                    }

                                    final countData = orderCtr.header!.data
                                        .firstWhereOrNull(
                                            (e) => e.description == name);

                                    if (countData != null &&
                                        countData.count != 0) {
                                      return Container(
                                        width: 18,
                                        height: 18,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          countData.count.toString(),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            inherit: false,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }

                                    final cancelReturn = orderCtr.header!.data
                                        .where((e) =>
                                            e.description == 'ยกเลิก' ||
                                            e.description == 'คืนสินค้า')
                                        .toList();

                                    if (cancelReturn.isNotEmpty) {
                                      final countLast = cancelReturn.fold(
                                          0, (p, e) => p + e.count);
                                      if (name == 'ยกเลิก/คืนเงิน' &&
                                          countLast > 0) {
                                        return Container(
                                          width: 18,
                                          height: 18,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            countLast.toString(),
                                            style: const TextStyle(
                                              fontSize: 11,
                                              inherit: false,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    return const SizedBox();
                                  }),
                                ),
                            ],
                          ),
                        Text(
                          name,
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ).marginOnly(top: 8),
                      ],
                    ),
                  );
                },
              ),

            if (title == "ช่วยเหลือ")
              ...List.generate(subtitles.length, (index) {
                return InkWell(
                  onTap: () {
                    handleMenuTap(subtitles[index]['name'] as String);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                subtitles[index]['icon'] as Widget,
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  subtitles[index]['name'] as String,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: Colors.grey.shade600,
                            )
                          ],
                        ),
                        if (index != subtitles.length - 1)
                          const Divider(
                            height: 14,
                          )
                      ],
                    ),
                  ),
                );
              })
          ],
        ),
      );
    },
  );
}

Color setColor(title) {
  switch (title) {
    case 'คูปองของฉัน':
      return Colors.teal;
    case 'รวมคูปอง':
      return Colors.deepOrange;
    default:
      return Colors.black;
  }
}

Future<void> handleMenuTap(String title) async {
  final profile = profileCtl.profileData.value;
  SetData data = SetData();
  int custId = await data.b2cCustID;
  String device = await data.device;
  String sessionId = await data.sessionId;
  String tokenApp = await data.tokenId;

  switch (title) {
    case "โครงการพิเศษ":
      Get.to(() => WebViewApp(
            mparamurl:
                'https://www.friday.co.th:8443/fridayonline/special-projects?cust_id=$custId&device=$device&session_id=$sessionId&token_app$tokenApp',
            mparamTitleName: 'โครงการพิเศษ',
          ));
      // Get.to(() => const SpecialProjects());
      break;
    case "คูปองของฉัน":
      Get.to(() => const CouponMe());
      break;
    case "บัญชี":
      await Get.to(() => const EditProfile(), arguments: {
        "displayName": profile?.displayName,
        "mobile": profile?.mobile,
        "image": profile?.image
      })?.then((result) {
        profileCtl.fetchProfile();
      });
      break;
    case "รวมคูปอง":
      {
        Get.to(() => const CouponAll());
        break;
      }
    case "ฟรายเดย์ Coin":
      {
        Get.to(() => FridayCoin());
        break;
      }
    case "ที่ต้องชำระ":
      orderCtr.fetchOrderList(0, 0);
      await Get.to(() => const MyOrderHistory(), arguments: 0);
      orderCtr.fetchOrderHeader();
      // Get.to(() => SpinPage(), routeName: 'SpinPage', arguments: 0);
      break;
    case "ที่ต้องจัดส่ง":
      orderCtr.fetchOrderList(1, 0);
      await Get.to(() => const MyOrderHistory(), arguments: 1);
      orderCtr.fetchOrderHeader();
      break;
    case "ที่ต้องได้รับ":
      orderCtr.fetchOrderList(2, 0);
      await Get.to(() => const MyOrderHistory(), arguments: 2);
      orderCtr.fetchOrderHeader();
      break;
    case "ยกเลิก/คืนเงิน":
      orderCtr.fetchOrderList(4, 0);
      await Get.to(() => const MyOrderHistory(), arguments: 4);
      orderCtr.fetchOrderHeader();
      break;
    case "ที่อยู่จัดส่ง":
      Get.find<EndUserCartCtr>().fetchAddressList();
      Get.to(() => const MyAddress());
      break;
    case "เกี่ยวกับ Friday":
      Get.to(() => const AboutFridayV2());
      break;
    case "คำแนะนำการใช้งาน":
      Get.to(() => const HelpFriday());
      break;
    case "chat กับเรา":
      {
        await Get.to(() => const ChatAppWithPlatform());
        break;
      }

    case "นโยบายความเป็นส่วนตัว":
      Get.to(() => const Instructions());
      break;
    case "เวอร์ชั่น":
      Get.to(() => const VersionApp());
      break;
    case "คำขอลบบัญชี":
      {
        dialogConfirm(
                'เราเสียใจที่คุณจะไม่ได้ใช้งานบริการของเราอีกแต่หากคุณได้ทำการลบบัญชีผู้ใช้แล้วจะไม่สามารถทำการกู้กลับมาได้',
                'ยกเลิก',
                'ตกลง')
            .then((res) {
          if (res == 1) {
            Get.to(() => const DeleteAccount());
          }
        });

        break;
      }

    default:
      break;
  }
}
