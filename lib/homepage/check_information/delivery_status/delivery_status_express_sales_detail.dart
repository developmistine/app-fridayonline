import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/check_information/check_information_controller.dart';
import '../../theme/theme_color.dart';
// import '../../widget/appbarmaster.dart';

//คลาสสำหรับแสดงสถานะการจัดส่ง
class DeliveryStatusExpressSalesDetail extends StatefulWidget {
  const DeliveryStatusExpressSalesDetail({super.key});

  @override
  State<DeliveryStatusExpressSalesDetail> createState() =>
      _DeliveryStatusExpressSalesDetailState();
}

class _DeliveryStatusExpressSalesDetailState
    extends State<DeliveryStatusExpressSalesDetail> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: true,
          backgroundColor: theme_color_df,
          title: const Text(
            'สถานะการจัดส่ง',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'notoreg',
                fontWeight: FontWeight.bold),
          ),
        ),
        body: GetBuilder<CheckInformationDeliveryStatusController>(
            builder: (dropshipStatus) {
          if (!dropshipStatus.isDataLoading.value) {
            if (dropshipStatus.response!.tracking.isNotEmpty) {
              return ListView(children: [
                Container(
                  height: 60,
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: IntrinsicHeight(
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text('ส่งด่วน 3 วัน',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFFFD7F6B),
                                  fontSize: 15)),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: VerticalDivider(
                              color: Color(0XFFFD7F6B),
                              thickness: 1,
                            ),
                          ),
                          Text('เก็บเงินปลายทาง',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFFFD7F6B),
                                  fontSize: 15))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(color: theme_color_df),
                  ),
                ),
                Container(
                  color: const Color(0XFFE5E5E5),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: SizedBox(
                        width: 220,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('หมายเลขพัสดุ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16)),
                                const Text(':',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16)),
                                Text(dropshipStatus.response!.trackingNo,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(dropshipStatus.response!.supProvince,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16)),
                                Icon(
                                  Icons.arrow_right_alt_outlined,
                                  color: theme_color_df,
                                ),
                                Text(dropshipStatus.response!.shipProvince,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: const Color(0XFFA4D6F1),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 3, color: Colors.white),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            'assets/images/icon/headphone.png',
                            width: 40,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text(dropshipStatus.response!.description,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16)),
                            Text('โทร. ${dropshipStatus.response!.desTel}',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16)),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dropshipStatus.response!.tracking.length,
                          itemBuilder: (context, index) {
                            return index !=
                                    dropshipStatus.response!.tracking.length - 1
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 3,
                                                  color:
                                                      const Color(0XFF7B7B7B)),
                                              color: const Color(0XFF7B7B7B),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: const Icon(
                                              Icons.circle,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                              height: 70,
                                              child: VerticalDivider(
                                                  color: Color(0XFFC4C4C4),
                                                  thickness: 4))
                                        ],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Text(
                                                  dropshipStatus
                                                      .response!
                                                      .tracking[index]
                                                      .trackingDate,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15)),
                                              Text(
                                                  dropshipStatus
                                                      .response!
                                                      .tracking[index]
                                                      .trackingNote,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 3,
                                                  color: theme_color_df),
                                              color: theme_color_df,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: const Icon(
                                              Icons.circle,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                              height: 20,
                                              child: VerticalDivider(
                                                  color: Color(0XFFA4D6F1),
                                                  thickness: 4))
                                        ],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Text(
                                                  dropshipStatus
                                                      .response!
                                                      .tracking[index]
                                                      .trackingDate,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15)),
                                              Text(
                                                  dropshipStatus
                                                      .response!
                                                      .tracking[index]
                                                      .trackingNote,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          }),
                    ],
                  ),
                ),
              ]);
            } else {
              return const Center(
                child: Text('ไม่พบข้อมูล'),
              );
            }
          } else {
            return Center(
              child: theme_loading_df,
            );
          }
        }),
      ),
    );
  }
}
