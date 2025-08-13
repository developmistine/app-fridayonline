import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/controller/cart.ctr.dart';
import 'package:fridayonline/enduser/widgets/gap.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EndUserChangePayment extends StatefulWidget {
  const EndUserChangePayment({super.key});

  @override
  State<EndUserChangePayment> createState() => _EndUserChangePaymentState();
}

class _EndUserChangePaymentState extends State<EndUserChangePayment> {
  final checkoutCtr = Get.find<EndUserCartCtr>();

  final List<Map<String, String>> mock = [
    {
      "type": "QR Promtpay",
      "url": "assets/images/b2c/icon/prompay.png",
      "value": "qr"
    },
    {
      "type": "เก็บเงินปลายทาง (COD)",
      "url": "assets/images/b2c/icon/cod.png",
      "value": "cod"
    },
    {
      "type": "บัตรเครดิต",
      "url": "assets/images/b2c/icon/card.png",
      "value": "card"
    },
  ];

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
          backgroundColor: Colors.grey.shade100,
          appBar: appBarMasterEndUser('ช่องทางการชำระเงิน'),
          body: Container(
            color: Colors.white,
            child: SingleChildScrollView(
                child: Column(
              children: [
                const Gap(height: 12),
                Column(
                    children: List.generate(
                  mock.length,
                  (index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            checkoutCtr.setPaymentType(
                                mock[index]['type']!, mock[index]['value']!);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GetBuilder<EndUserCartCtr>(builder: (ctr) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        mock[index]['url']!,
                                        height: 24,
                                        width: 24,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        mock[index]['type']!,
                                        style: const TextStyle(fontSize: 13),
                                      )
                                    ],
                                  ),
                                  if (ctr.paymentType
                                      .containsValue(mock[index]['type']))
                                    Icon(Icons.check_circle,
                                        color: themeColorDefault),
                                ],
                              );
                            }),
                          ),
                        ),
                        const Divider(
                          height: 0,
                        )
                      ],
                    );
                  },
                )),
              ],
            )),
          ),
          bottomNavigationBar: SafeArea(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: Colors.grey, width: 0.2))),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: themeColorDefault,
                  shape: const RoundedRectangleBorder()),
              child: const Text(
                'ยืนยัน',
                style: TextStyle(fontSize: 13),
              ),
              onPressed: () {
                var payment = Get.find<EndUserCartCtr>().paymentType['value'];
                if (payment != null) {
                  Get.back(result: payment);
                } else {
                  Get.back();
                }
              },
            ),
          )),
        ),
      ),
    );
  }
}
