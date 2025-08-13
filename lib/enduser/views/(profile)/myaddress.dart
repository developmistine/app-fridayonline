import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/components/profile/myaddress/myaddress.list.dart';
import 'package:fridayonline/enduser/controller/cart.ctr.dart';
import 'package:fridayonline/enduser/views/(cart)/cart.set.address.dart';
import 'package:fridayonline/enduser/widgets/empty.address.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({super.key});

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  final address = Get.find<EndUserCartCtr>();
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
          backgroundColor: Colors.grey[50],
          appBar: appBarMasterEndUser('ที่อยู่ของฉัน'),
          body: Obx(() {
            if (address.isLoadingAddress.value) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (address.addressList!.data.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: emptyAddress(),
                    )
                  else
                    Container(
                        color: Colors.white,
                        child: myAddressList(
                            listAddress: address.addressList!.data)),
                  if (address.addressList!.data.isNotEmpty)
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      splashColor: Colors.transparent,
                      onTap: () async {
                        var res = await Get.to(() => const EndUserSetAddress(),
                            arguments: []);
                        if (res == null) {
                        } else {
                          Get.find<EndUserCartCtr>().fetchAddressList();
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          width: Get.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  color: themeColorDefault,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'เพิ่มที่อยู่',
                                  style: TextStyle(
                                      fontSize: 13, color: themeColorDefault),
                                ),
                              ],
                            ),
                          )),
                    )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
