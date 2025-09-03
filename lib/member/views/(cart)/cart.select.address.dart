import 'package:fridayonline/member/components/appbar/appbar.master.dart';
import 'package:fridayonline/member/controller/cart.ctr.dart';
import 'package:fridayonline/member/controller/coupon.ctr.dart';
import 'package:fridayonline/member/services/address/adress.service.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(cart)/cart.set.address.dart';
import 'package:fridayonline/member/views/(cart)/cart.sumary.dart';
import 'package:fridayonline/member/widgets/empty.address.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fridayonline/member/models/cart/cart.checkout.input.dart'
    as checkout_model;

class EndUserSelectAddress extends StatelessWidget {
  const EndUserSelectAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final EndUserCartCtr cartCtr = Get.find();
    final cartCouponCtr = Get.find<EndUserCouponCartCtr>();
    SetData data = SetData();

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.ibmPlexSansThai())),
          textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: appBarMasterEndUser('เลือกที่อยู่'),
            body: Obx(() {
              if (cartCtr.isLoadingAddress.value) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              return SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cartCtr.addressList!.data.isEmpty) emptyAddress(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ที่อยู่',
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.zero,
                    itemCount: cartCtr.addressList!.data.length,
                    itemBuilder: (context, index) {
                      var addrss = cartCtr.addressList!.data[index];
                      return InkWell(
                        onTap: () async {
                          var res = await setAddressDefalutService(addrss.id);
                          cartCouponCtr
                                  .promotionDataCheckOut.unusedPlatformVoucher =
                              cartCouponCtr.promotionData.unusedPlatformVoucher;
                          cartCouponCtr.promotionDataCheckOut.platformVouchers =
                              cartCouponCtr.promotionData.platformVouchers;

                          var payload = checkout_model.CartCheckOutInput(
                            custId: await data.b2cCustID,
                            checkoutShopOrders: itemsUpdate(),
                            promotionData: checkout_model.PromotionData(
                                freeShipping: [],
                                unusedPlatformVoucher: cartCouponCtr
                                    .promotionData.unusedPlatformVoucher,
                                platformVouchers: cartCouponCtr
                                    .promotionData.platformVouchers,
                                shopVouchers: cartCouponCtr.promotionShop),
                          );
                          if (res!.code == '100') {
                            Get.find<EndUserCartCtr>().fetchAddressList();
                            cartCtr.fetchCartCheckOut(payload);
                            Get.back(result: addrss.id);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          width: Get.width,
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.5, color: Colors.grey.shade200)),
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (addrss.isDeliveryAddress)
                                Expanded(
                                    child: Icon(
                                  Icons.radio_button_checked,
                                  color: themeColorDefault,
                                  size: 18,
                                ))
                              else
                                Expanded(
                                    child: Icon(
                                  Icons.radio_button_off_rounded,
                                  color: Colors.grey.shade700,
                                  size: 18,
                                )),
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${addrss.firstName} ${addrss.lastName} ",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "| ${formatPhoneNumber(addrss.phone)} ",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${addrss.address1}\n${addrss.address}",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (addrss.isDeliveryAddress)
                                      Container(
                                          margin: const EdgeInsets.only(top: 4),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: themeColorDefault)),
                                          child: Text(
                                            'ค่าตั้งต้น',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: themeColorDefault),
                                          ))
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  var res = await Get.to(
                                      () => const EndUserSetAddress(),
                                      arguments: ["edit", addrss]);
                                  if (res != null) {
                                    Get.find<EndUserCartCtr>()
                                        .fetchAddressList();
                                  }
                                },
                                child: Text(
                                  'แก้ไข',
                                  style: TextStyle(
                                      color: themeColorDefault, fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      var res = await Get.to(() => const EndUserSetAddress(),
                          arguments: []);
                      if (res != null) {
                        Get.find<EndUserCartCtr>().fetchAddressList();
                      }
                    },
                    child: Container(
                        color: Colors.white,
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: EdgeInsets.zero,
                                    width: 20,
                                    height: 20,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: themeColorDefault),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Text(
                                      '+',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          height: 1.1,
                                          color: themeColorDefault),
                                    )),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'เพิ่มที่อยู่ใหม่',
                                  style: TextStyle(
                                      fontSize: 13, color: themeColorDefault),
                                ),
                              ],
                            ),
                          ],
                        )),
                  )
                ],
              ));
            })),
      ),
    );
  }
}
