import 'package:fridayonline/controller/check_information/check_information_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/formatter_text.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/theme/theme_loading.dart';
import 'package:fridayonline/homepage/webview/webview_app.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPayMentEndUsers extends StatefulWidget {
  const OrderPayMentEndUsers({super.key});

  @override
  State<OrderPayMentEndUsers> createState() => _OrderPayMentEndUsersState();
}

class _OrderPayMentEndUsersState extends State<OrderPayMentEndUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitleMaster('คำสั่งซื้อลูกค้า'),
        body: GetX<PayMentController>(builder: (paymentEndUser) {
          return paymentEndUser.isDataLoading.value
              ? Center(
                  child: theme_loading_df,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      if (paymentEndUser.getEnduserPayment!.endUserPayData
                          .any((element) => element.orderList.isNotEmpty))
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            color: const Color(0xFFD9D9D9),
                            width: Get.width,
                            child: Text(paymentEndUser.getEnduserPayment!.text,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                                textAlign: TextAlign.center)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8),
                        child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: paymentEndUser
                                .getEnduserPayment!.endUserPayData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return paymentEndUser.getEnduserPayment!
                                      .endUserPayData[index].orderList.isEmpty
                                  ? index == 0 &&
                                          paymentEndUser
                                              .getEnduserPayment!.endUserPayData
                                              .every((element) =>
                                                  element.orderList.isEmpty)
                                      ? SizedBox(
                                          height: Get.height * 0.8,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Image.asset(
                                                    'assets/images/logo/logofriday.png',
                                                    width: 70),
                                              ),
                                              const Center(
                                                  child: Text('ไม่พบข้อมูล')),
                                            ],
                                          ))
                                      : const SizedBox()
                                  : MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          textScaler:
                                              const TextScaler.linear(1.0)),
                                      child: Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14.0),
                                        ),
                                        elevation: 4,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                color: theme_color_df,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Center(
                                                child: Text(
                                                  'รอบการขาย ${formatCampYear(paymentEndUser.getEnduserPayment!.endUserPayData[index].campaign)}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            for (var list in paymentEndUser
                                                .getEnduserPayment!
                                                .endUserPayData[index]
                                                .orderList)
                                              InkWell(
                                                onTap: () async {
                                                  var reference = SetData();
                                                  var repseq =
                                                      await reference.repSeq;
                                                  var reptype =
                                                      await reference.repType;
                                                  var device =
                                                      await reference.device;
                                                  var campaign = formatCampYear(
                                                      list.campaign);
                                                  var saleCampagin =
                                                      formatCampYear(
                                                          list.saleCampaign);
                                                  Get.to(() => webview_app(
                                                        mparamTitleName:
                                                            'คำสั่งซื้อลูกค้า',
                                                        mparamType: '',
                                                        mparamValue: '',
                                                        type: '',
                                                        mparamurl:
                                                            '${shopMistine}st_history_enduser?repcode=${list.repCode}&repseq=$repseq&reptype=$reptype&orderno=${list.transNo}&enduser_id=${list.enduserId}&trans_camp=$campaign&salescamp=$saleCampagin&device=$device&app=1&status=${list.status}',
                                                      ));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: paymentEndUser
                                                                      .getEnduserPayment!
                                                                      .endUserPayData[
                                                                          index]
                                                                      .orderList
                                                                      .indexOf(
                                                                          list) %
                                                                  2 ==
                                                              0
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFFE9F7FF)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 12),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 4,
                                                          child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        list.repName,
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                        maxLines:
                                                                            2,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          const Text(
                                                                            'ยอดขาย',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                              '${double.parse(list.saleAmt) != 0 ? myFormat2Digits.format(double.parse(list.saleAmt)) : double.parse(list.saleAmt).toStringAsFixed(2)} บาท')
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 12,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const Text(
                                                                            'ใบส่งของ :',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.search,
                                                                                color: theme_color_df,
                                                                                size: 16,
                                                                              ),
                                                                              Text(
                                                                                list.transNo,
                                                                                style: TextStyle(decoration: TextDecoration.underline, decorationColor: theme_color_df, color: theme_color_df),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          const Text(
                                                                            'กำไร',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                              '${double.parse(list.profitAmt) != 0 ? myFormat2Digits.format(double.parse(list.profitAmt)) : double.parse(list.profitAmt).toStringAsFixed(2)} บาท')
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            list.isPay
                                                                ? 'ชำระเงินแล้ว\n(${list.paymentType})'
                                                                : 'ยังไม่ชำระเงิน',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: list
                                                                        .isPay
                                                                    ? const Color(
                                                                        0xFF20BE79)
                                                                    : Colors
                                                                        .yellow
                                                                        .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            Container(
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                color: theme_color_df,
                                                border: Border(
                                                  top: BorderSide(
                                                    color: theme_red,
                                                    width: 1.8,
                                                  ),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 24),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'รวม',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    'ยอดขาย\n${double.parse(paymentEndUser.getEnduserPayment!.endUserPayData[index].totalSaleAmt) != 0 ? myFormat2Digits.format(double.parse(paymentEndUser.getEnduserPayment!.endUserPayData[index].totalSaleAmt)) : double.parse(paymentEndUser.getEnduserPayment!.endUserPayData[index].totalSaleAmt).toStringAsFixed(2)} บาท',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    'กำไร\n${double.parse(paymentEndUser.getEnduserPayment!.endUserPayData[index].totalProfitAmt) != 0 ? myFormat2Digits.format(double.parse(paymentEndUser.getEnduserPayment!.endUserPayData[index].totalProfitAmt)) : double.parse(paymentEndUser.getEnduserPayment!.endUserPayData[index].totalProfitAmt).toStringAsFixed(2)} บาท',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            }),
                      ),
                    ],
                  ),
                );
        }));
  }
}
