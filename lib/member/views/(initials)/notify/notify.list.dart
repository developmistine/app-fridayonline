import 'package:fridayonline/member/components/appbar/appbar.nosearch.dart';
import 'package:fridayonline/member/components/webview/webview.dart';
import 'package:fridayonline/member/controller/brand.ctr.dart';
import 'package:fridayonline/member/controller/notify.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.category.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/controller/track.ctr.dart';
import 'package:fridayonline/member/services/notify/order.notify.service.dart';
import 'package:fridayonline/member/utils/event.dart';
import 'package:fridayonline/member/views/(cart)/cart.main.dart';
import 'package:fridayonline/member/views/(category)/subcategory.view.dart';
import 'package:fridayonline/member/views/(coupon)/conpon.me.dart';
import 'package:fridayonline/member/views/(coupon)/coupon.all.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotifyList extends StatefulWidget {
  final String title;
  const NotifyList({super.key, required this.title});

  @override
  State<NotifyList> createState() => _NotifyListState();
}

class _NotifyListState extends State<NotifyList> {
  final notifyCtr = Get.find<NotifyController>();
  final scrollCtr = ScrollController();
  int offset = 20;
  @override
  void initState() {
    super.initState();
    scrollCtr.addListener(() {
      if (scrollCtr.position.maxScrollExtent == scrollCtr.position.pixels) {
        fetchMoreNotify();
      }
    });
  }

  @override
  void dispose() {
    offset = 20;
    super.dispose();
  }

  fetchMoreNotify() async {
    try {
      notifyCtr.isLoadingMoreNotify.value = true;
      var res = await notifyCtr.fetchMoreNotify(notifyCtr.groupIdVal, offset);
      if (res.data.isNotEmpty) {
        notifyCtr.notify!.data.addAll(res.data);
        offset += 20;
      }
    } finally {
      notifyCtr.isLoadingMoreNotify.value = false;
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
              outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                      textStyle: GoogleFonts.notoSansThaiLooped())),
              textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: appBarNoSearchEndUser(widget.title),
              body: Obx(() {
                if (notifyCtr.isLoadingNotify.value) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (notifyCtr.notify!.data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/home/zero_noti.png',
                            width: 150),
                        const Text(
                          "ไม่พบข้อมูลการแจ้งเตือน",
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  controller: scrollCtr,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: notifyCtr.notify!.data.length +
                      (notifyCtr.isLoadingMoreNotify.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == notifyCtr.notify!.data.length &&
                        notifyCtr.isLoadingMoreNotify.value) {
                      return const SizedBox.shrink();
                    }
                    var items = notifyCtr.notify!.data[index];
                    return InkWell(
                      onTap: () async {
                        if (items.isRead == false) {
                          await fetchNotifyReadService(
                                  items.idInfo.orderId, false)
                              .then((_) {
                            loadingProductStock(context);
                            Get.back();
                          });
                        }
                        if (items.isContent) {
                          eventNotify(items, "notify");
                        } else {
                          int actionValue =
                              int.tryParse(items.actionValue) ?? 0;
                          switch (items.actionType) {
                            case 'url':
                              {
                                Get.to(() => WebViewApp(
                                    mparamurl: items.actionValue,
                                    mparamTitleName: 'Friday Online'));
                                break;
                              }
                            case 'my_coupon':
                              {
                                Get.find<TrackCtr>().setDataTrack(
                                    items.notifyId, items.title, "notify");
                                Get.to(() => const CouponMe());
                                break;
                              }
                            case 'coupon':
                              {
                                Get.find<TrackCtr>().setDataTrack(
                                    items.notifyId, items.title, "notify");
                                Get.to(() => const CouponAll());
                                break;
                              }
                            case 'seller':
                              {
                                Get.find<TrackCtr>().setLogContentAddToCart(
                                    items.notifyId, 'notify');
                                Get.find<TrackCtr>().setDataTrack(
                                    items.notifyId, items.title, "notify");
                                Get.find<BrandCtr>().fetchShopData(actionValue);
                                await Get.toNamed(
                                  '/BrandStore/$actionValue',
                                )!
                                    .then((value) {
                                  Get.find<TrackCtr>().clearLogContent();
                                });
                                break;
                              }
                            case 'category':
                              {
                                Get.find<TrackCtr>().setLogContentAddToCart(
                                    items.notifyId, 'notify');
                                Get.find<TrackCtr>().setDataTrack(
                                    items.notifyId, items.title, "notify");
                                categoryCtr.fetchSubCategory(actionValue);
                                Get.find<ShowProductCategoryCtr>()
                                    .fetchProductByCategoryIdWithSort(
                                        actionValue, 0, "ctime", "", 40, 0);
                                await Get.to(() => const SubCategory())!
                                    .then((value) {
                                  Get.find<TrackCtr>().clearLogContent();
                                });
                                break;
                              }
                            case 'cart':
                              {
                                Get.to(() => const EndUserCart());
                                break;
                              }
                            case 'content':
                              {
                                eventNotify(items, "notify");
                                break;
                              }
                            case 'notify':
                              {
                                Get.offAllNamed('/EndUserHome',
                                    parameters: {'changeView': "2"});
                                break;
                              }
                            case 'product':
                              {
                                Get.find<TrackCtr>().setLogContentAddToCart(
                                    items.notifyId, 'notify');
                                Get.find<ShowProductSkuCtr>()
                                    .fetchB2cProductDetail(
                                        actionValue, 'notify');
                                await Get.toNamed(
                                  '/ShowProductSku/$actionValue',
                                )!
                                    .then((value) {
                                  Get.find<TrackCtr>().clearLogContent();
                                });
                                break;
                              }

                            default:
                              break;
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: items.isRead
                                ? Colors.white
                                : Colors.blue.shade50.withOpacity(0.50),
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.shade300, width: 0.5))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                width: 50,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                        imageUrl: items.image))),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    items.title,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    items.subTitle,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(children: [
                                      ...List.generate(
                                          items.richContents.length,
                                          (imgIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: CachedNetworkImage(
                                              width: 50,
                                              imageUrl: items
                                                  .richContents[imgIndex]
                                                  .image),
                                        );
                                      })
                                    ]),
                                  ),
                                  Text(
                                    items.dateTime,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade700),
                                  ).marginSymmetric(vertical: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            )));
  }
}
