import 'package:appfridayecommerce/enduser/components/appbar/appbar.master.dart';
import 'package:appfridayecommerce/enduser/components/showproduct/nodata.dart';
import 'package:appfridayecommerce/enduser/controller/coint.ctr.dart';
import 'package:appfridayecommerce/enduser/utils/format.dart';
import 'package:appfridayecommerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FridayCoinMore extends StatefulWidget {
  const FridayCoinMore({super.key});

  @override
  State<FridayCoinMore> createState() => _FridayCoinMoreState();
}

class _FridayCoinMoreState extends State<FridayCoinMore> {
  final coinController = Get.find<CoinCtr>();
  final scrollController = ScrollController();
  int offset = 50;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchMore();
      }
    });
  }

  @override
  void dispose() {
    offset = 50;
    super.dispose();
  }

  void fetchMore() async {
    coinController.isLoadingMore.value = true;
    try {
      final newsData = await coinController.fetchMoreTransaction(offset);

      if (newsData!.data.items.isNotEmpty) {
        coinController.transaction!.data.items.addAll(newsData.data.items);
        offset += 50;
      }
    } finally {
      coinController.isLoadingMore.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: Scaffold(
          appBar: appBarMasterEndUser('ประวัติการทำรายการ'),
          body: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(children: [
              Obx(() {
                if (coinController.isLoadingTransaction.value) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (coinController.transaction!.data.items.isNotEmpty) {
                  var items = coinController.transaction!.data.items;
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: items.length +
                        (coinController.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == items.length &&
                          coinController.isLoadingMore.value) {
                        return const SizedBox.shrink();
                      }
                      var item = items[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.coinName),
                                  Text(
                                    item.cDate,
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                              Text(
                                _getCoinContent(item.coinAmount),
                                style: GoogleFonts.notoSansThaiLooped(
                                    color: _getCoinColor(item.coinAmount > 0)),
                              ),
                            ],
                          ),
                          const Divider()
                        ],
                      );
                    },
                  );
                } else {
                  return Center(
                      heightFactor: 3,
                      child: nodataTitle(context, 'ไม่พบประวัติการทำรายการ'));
                }
              }),
              Obx(() {
                return coinController.isLoadingMore.value
                    ? Center(
                        child: Text(
                          "กำลังโหลด",
                          style: TextStyle(color: themeColorDefault),
                        ),
                      )
                    : const SizedBox();
              })
            ]),
          ),
        ),
      ),
    );
  }
}

Color _getCoinColor(bool isCheckin) {
  if (isCheckin) {
    return Colors.orange;
  } else {
    return Colors.black;
  }
}

String _getCoinContent(int coin) {
  if (coin > 0) {
    return "+ ${myFormat.format(coin)}";
  } else {
    return myFormat.format(coin);
  }
}
