import 'dart:async';

import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/components/profile/myorder/order.history.dart';
import 'package:fridayonline/member/controller/order.ctr.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final orderCtr = Get.find<OrderController>();

class MyOrderHistory extends StatefulWidget {
  const MyOrderHistory({super.key});

  @override
  State<MyOrderHistory> createState() => _MyOrderHistoryState();
}

class _MyOrderHistoryState extends State<MyOrderHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  var inialIndex = Get.arguments ?? 0;

  int savedTabIndex = 0;

  int count = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    if (orderCtr.header == null) {
      orderCtr.fetchOrderHeader().then((res) {
        _tabController = TabController(
            length: res!.data.length, vsync: this, initialIndex: inialIndex);
      });
    } else {
      savedTabIndex = inialIndex;
      setTabController(savedTabIndex);
    }
  }

  setTabController(index) {
    _tabController = TabController(
        length: orderCtr.header!.data.length, vsync: this, initialIndex: index);
    setState(() {});
  }

  @override
  void dispose() {
    // orderCtr.header = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (orderCtr.isLoading.value) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: appBarMasterEndUser('ข้อมูลการสั่งซื้อ'),
          body: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      }

      return DefaultTabController(
        initialIndex: 0,
        length: orderCtr.header!.data.length,
        child: MediaQuery(
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
              backgroundColor: Colors.grey[100],
              appBar: appBarMasterEndUser('ข้อมูลการสั่งซื้อ'),
              body: Column(
                children: [
                  Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        indicatorColor: themeColorDefault,
                        indicatorWeight: 2,
                        splashFactory: NoSplash.splashFactory,
                        unselectedLabelStyle: GoogleFonts.notoSansThaiLooped(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        labelStyle: GoogleFonts.notoSansThaiLooped(
                          color: themeColorDefault,
                          fontSize: 14,
                        ),
                        onTap: (value) {
                          orderCtr.fetchOrderList(
                              orderCtr.header!.data[value].orderType, 0);
                        },
                        tabs: List.generate(
                            orderCtr.header!.data.length,
                            (index) => Tab(
                                text:
                                    orderCtr.header!.data[index].description))),
                  ),
                  Expanded(
                    child: TabBarView(
                        controller:
                            _tabController, // ใช้ controller ที่เราสร้าง

                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(orderCtr.header!.data.length,
                            (index) {
                          return Obx(() {
                            if (orderCtr.isLoadingList.value) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            } else {
                              if (orderCtr.header!.data[_tabController.index]
                                      .orderType ==
                                  0) {
                                return OrderHistoryCheckOutCard(
                                    data: orderCtr.orderListCheckOut!.data,
                                    setTab: setTabController,
                                    indexTab: orderCtr.header!
                                        .data[_tabController.index].orderType);
                              }
                              return OrderHistoryCard(
                                  data: orderCtr.orderList!.data,
                                  setTab: setTabController,
                                  indexTab: orderCtr.header!
                                      .data[_tabController.index].orderType);
                            }
                          });
                        })),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
