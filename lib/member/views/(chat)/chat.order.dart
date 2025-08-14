import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/components/showproduct/nodata.dart';
import 'package:fridayonline/member/models/orders/orderlist.model.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatOrders extends StatelessWidget {
  final List<Datum> orders;
  const ChatOrders({super.key, required this.orders});

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
              appBar: appBarMasterEndUser('รายการสั่งซื้อ'),
              body: orders.isEmpty
                  ? nodataTitle(context, 'ไม่พบออร์เดอร์สินค้า')
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        var order = orders[index];

                        return Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                            // border: Border(
                            //     bottom: BorderSide(color: Colors.grey.shade300)

                            //     )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          imageUrl: order.shopInfo.icon,
                                          width: 24,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(order.shopInfo.shopName,
                                          style: GoogleFonts.notoSansThaiLooped(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Text(order.orderStatus.description,
                                      style: GoogleFonts.notoSansThaiLooped(
                                          color: _getStatusColor(order
                                              .orderStatus.colorCode
                                              .toLowerCase()),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: order.itemGroups.length,
                                  itemBuilder: (context, subIndex) {
                                    var items = order.itemGroups[subIndex];
                                    return Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color:
                                                      Colors.grey.shade300))),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: CachedNetworkImage(
                                                imageUrl: items.image,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                items.productName,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts
                                                    .notoSansThaiLooped(
                                                        fontSize: 14),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Builder(
                                                    builder: (context) {
                                                      if (!items.haveDisCount) {
                                                        return Text(
                                                          "฿${myFormat.format(items.priceBeforeDiscount)}",
                                                          style: GoogleFonts
                                                              .notoSansThaiLooped(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .deepOrange
                                                                      .shade700),
                                                        );
                                                      } else {
                                                        return Row(
                                                          children: [
                                                            Text(
                                                              "฿${myFormat.format(items.price)}",
                                                              style: GoogleFonts
                                                                  .notoSansThaiLooped(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .deepOrange
                                                                          .shade700),
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              "฿${myFormat.format(items.priceBeforeDiscount)}",
                                                              style: GoogleFonts.notoSansThaiLooped(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade500),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    );
                                  }),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('รวม',
                                      style: GoogleFonts.notoSansThaiLooped()),
                                  Row(
                                    children: [
                                      Text(
                                          'สินค้า ${order.summary.productCount} ชิ้น | ',
                                          style: GoogleFonts.notoSansThaiLooped(
                                              fontSize: 14)),
                                      Text(
                                          '฿${myFormat.format(order.summary.finalTotal)}',
                                          style: GoogleFonts.notoSansThaiLooped(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.deepOrange.shade700)),
                                    ],
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  height: 30,
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: themeColorDefault),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4))),
                                      onPressed: () {
                                        Get.back(result: order);
                                      },
                                      child: Text(
                                        "ส่ง",
                                        style: GoogleFonts.notoSansThaiLooped(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: themeColorDefault),
                                      )),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
            )));
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'b':
      return themeColorDefault;
    case 'y':
      return Colors.amber;
    case 'g':
      return Colors.teal.shade400;
    case 'r':
      return const Color.fromARGB(255, 221, 60, 32);
    default:
      return themeColorDefault;
  }
}
