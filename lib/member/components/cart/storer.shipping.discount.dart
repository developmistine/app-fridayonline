import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fridayonline/member/models/cart/getcart.model.dart';

void storeShippingDiscount(
    BuildContext context, List<Datum> cartShop, int index) {
  Get.bottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      )),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      Theme(
          data: Theme.of(context).copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    textStyle: GoogleFonts.notoSansThaiLooped())),
            textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          child: SafeArea(
              child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'ส่วนลดค่าจัดส่ง - ${cartShop[index].shopName}',
                                style: GoogleFonts.notoSansThaiLooped(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              color: Colors.grey.shade100,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'ขั้นต่ำ',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            fontSize: 12),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'ส่วนลด',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            fontSize: 12),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'ตัวเลือกการจัดส่ง',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ...List.generate(
                                cartShop[index].drawerEntries.length,
                                (childIndex) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "฿${myFormat.format(cartShop[index].drawerEntries[childIndex].minSpend)}",
                                              style: GoogleFonts
                                                  .notoSansThaiLooped(
                                                      fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "฿${myFormat.format(cartShop[index].drawerEntries[childIndex].shippingDiscount)}",
                                              style: GoogleFonts
                                                  .notoSansThaiLooped(
                                                      fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ...List.generate(
                                                    cartShop[index]
                                                        .drawerEntries[
                                                            childIndex]
                                                        .shippingOptions
                                                        .length,
                                                    (shipIndex) => Text(
                                                          cartShop[index]
                                                                  .drawerEntries[
                                                                      childIndex]
                                                                  .shippingOptions[
                                                              shipIndex],
                                                          style: GoogleFonts
                                                              .notoSansThaiLooped(
                                                                  fontSize: 12),
                                                        ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                            const SizedBox(
                              height: 80,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                width: Get.width,
                                height: 40,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: themeColorDefault),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('ตกลง')),
                              ),
                            )
                          ],
                        ),
                      ))))));
}
