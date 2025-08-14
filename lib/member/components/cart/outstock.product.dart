import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/models/cart/getcart.model.dart';
import 'package:fridayonline/member/services/cart/cart.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

final EndUserCartCtr cartCtr = Get.find();

class OutStockProduct extends StatefulWidget {
  final List<Item> outstockItems;
  final List<SlidableController> outstockController;
  const OutStockProduct(
      {super.key,
      required this.outstockItems,
      required this.outstockController});

  @override
  State<OutStockProduct> createState() =>
      _OutStockProductState(outstockItems, outstockController);
}

class _OutStockProductState extends State<OutStockProduct> {
  bool isShowMore = false;
  bool slideOpenOutStock = false;

  List<Item> outstockItems;
  List<SlidableController> outstockController;
  _OutStockProductState(this.outstockItems, this.outstockController);
  @override
  Widget build(BuildContext context) {
    if (outstockItems.isEmpty) {
      return const SizedBox();
    }
    return Container(
        margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'สินค้าหมด (${outstockItems.length})',
                        style: const TextStyle(
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ]),
          ),
          const Divider(
            height: 0,
          ),
          ...List.generate(isShowMore ? outstockItems.length : 1, (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Slidable(
                // controller: outstockController[index],
                endActionPane: ActionPane(
                  extentRatio: 0.20,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      flex: 1,
                      onPressed: (s) async {
                        loadingProductStock(context);
                        var indexData = cartCtr.cartItems!.value.data
                            .indexWhere(
                                (e) => e.items.contains(outstockItems[index]));
                        var indexItem = cartCtr
                            .cartItems!.value.data[indexData].items
                            .indexWhere(
                                (e) => e.cartId == outstockItems[index].cartId);

                        var res = await deleteCartService(
                            [outstockItems[index].cartId]);
                        Get.back();
                        if (res!.code == "100") {
                          outstockItems.removeAt(index);
                          cartCtr.cartItems!.value.data[indexData].items
                              .removeAt(indexItem);
                          if (cartCtr
                              .cartItems!.value.data[indexData].items.isEmpty) {
                            cartCtr.cartItems!.value.data.removeAt(index);
                          }
                        }
                        cartCtr.cartItems!.refresh();
                        // setState(() {});
                      },
                      backgroundColor: themeRed,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.antiAlias,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 0.2, color: Colors.grey)),
                              child: Image(
                                height: 80,
                                width: 100,
                                errorBuilder: (context, url, error) {
                                  return SizedBox(
                                    height: 80,
                                    width: Get.width,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 35,
                                      color: Colors.grey.shade200,
                                    ),
                                  );
                                },
                                image: CachedNetworkImageProvider(
                                    outstockItems[index].productImage),
                              ),
                            ),
                            Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black45,
                                ),
                                child: const Center(
                                  child: Text(
                                    'สินค้าหมด',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              outstockItems[index].productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 13),
                            ),
                            Text(
                              "฿${myFormat.format(outstockItems[index].price)}",
                              style: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            );
          }),
          const Divider(
            height: 0,
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              isShowMore = !isShowMore;
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isShowMore ? 'ดูน้อยลง' : 'ดูทั้งหมด',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Icon(
                    isShowMore
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade600,
                    size: 18,
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}
