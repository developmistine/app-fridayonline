import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:fridayonline/member/models/orders/orderdetail.model.dart'
    as shipping;

class ShippingDetail extends StatelessWidget {
  final shipping.Data shippingInfo;
  final int shippingIndex;
  const ShippingDetail(
      {super.key, required this.shippingInfo, required this.shippingIndex});

  @override
  Widget build(BuildContext context) {
    Color getStatusColor(String status) {
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

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.ibmPlexSansThai(),
            ),
          ),
          textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: appBarMasterEndUser('จัดส่งสำเร็จ'),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Text(
                          shippingInfo.orderStatus.description,
                          style: TextStyle(
                              color: getStatusColor(shippingInfo
                                  .orderStatus.colorCode
                                  .toLowerCase()),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        child: SizedBox(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: shippingInfo
                                  .shippingInfo[shippingIndex].step.length,
                              itemBuilder: (context, index) {
                                final step = shippingInfo
                                    .shippingInfo[shippingIndex].step[index];
                                return TimelineTile(
                                  isFirst: index == 0,
                                  isLast: index == 2,
                                  axis: TimelineAxis.horizontal,
                                  alignment: TimelineAlign.manual,
                                  lineXY: 0.3,
                                  indicatorStyle: step.isCurrent == true
                                      ? IndicatorStyle(
                                          indicator: ClipOval(
                                            child: Container(
                                              color: themeColorDefault,
                                              child: CachedNetworkImage(
                                                imageUrl: step.image,
                                              ),
                                            ),
                                          ),
                                          width: 32,
                                          height: 32,
                                          color: themeColorDefault,
                                        )
                                      : IndicatorStyle(
                                          width: 8,
                                          height: 8,
                                          color: themeColorDefault,
                                        ),
                                  beforeLineStyle: const LineStyle(
                                    thickness: 2,
                                    color: Color.fromARGB(255, 228, 248, 255),
                                  ),
                                  endChild: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      step.text,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.grey[100],
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                shippingInfo
                                    .shippingInfo[shippingIndex].deliveryBy,
                                style: const TextStyle(fontSize: 14),
                              ),
                              Row(
                                children: [
                                  Text(
                                    shippingInfo
                                        .shippingInfo[shippingIndex].trackingNo,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  if (shippingInfo.shippingInfo[shippingIndex]
                                          .trackingNo !=
                                      "")
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: shippingInfo
                                                .shippingInfo[shippingIndex]
                                                .trackingNo));
                                        dialogAlert([
                                          Text(
                                            'คัดลอกเลขที่พัสดุแล้ว',
                                            style: GoogleFonts.ibmPlexSansThai(
                                                color: Colors.white,
                                                fontSize: 13),
                                          )
                                        ]);
                                        Future.delayed(
                                          const Duration(seconds: 1),
                                          () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                      child: const Icon(
                                        Icons.copy_sharp,
                                        size: 14,
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12),
                            shrinkWrap: true,
                            itemCount: shippingInfo.shippingInfo[shippingIndex]
                                .trackingInfo.length,
                            itemBuilder: (context, index) => TimelineTile(
                              isFirst: index == 0,
                              isLast: index ==
                                  shippingInfo.shippingInfo[shippingIndex]
                                          .trackingInfo.length -
                                      1,
                              indicatorStyle: IndicatorStyle(
                                  width: 8,
                                  color: index == 0
                                      ? themeColorDefault
                                      : Colors.grey[400]!),
                              beforeLineStyle: LineStyle(
                                  thickness: 2, color: Colors.grey[300]!),
                              alignment: TimelineAlign.manual,
                              lineXY: 0.2,
                              endChild: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  shippingInfo.shippingInfo[shippingIndex]
                                      .trackingInfo[index].description,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: index == 0
                                          ? themeColorDefault
                                          : Colors.grey[400]!),
                                ),
                              ),
                              startChild: Text(
                                shippingInfo.shippingInfo[shippingIndex]
                                    .trackingInfo[index].dateTime,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: index == 0
                                        ? Colors.black
                                        : Colors.grey[400]!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
