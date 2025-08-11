import 'dart:async';

import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/models/address/b2caddrss.model.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class B2cSearchAddress extends StatefulWidget {
  final B2CAddress? dataAddress;
  const B2cSearchAddress({super.key, this.dataAddress});

  @override
  State<B2cSearchAddress> createState() => _B2cSearchAddressState();
}

class _B2cSearchAddressState extends State<B2cSearchAddress> {
  final TextEditingController? controller = TextEditingController();
  List<Map<String, dynamic>> searchResult = [];
  Timer? debounce;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> searchAddress(String query) {
      List<Map<String, dynamic>> results = [];

      for (var province in widget.dataAddress!.data) {
        for (var amphur in province.amphur) {
          for (var tambon in amphur.tambon) {
            if (province.provinceName.contains(query) ||
                amphur.amphurName.contains(query) ||
                tambon.tambonName.contains(query) ||
                tambon.postCode.contains(query)) {
              results.add({
                "province_id": province.provinceId,
                "province_name": province.provinceName,
                "amphur_id": amphur.amphurId,
                "amphur_name": amphur.amphurName,
                "tambon_id": tambon.tambonId,
                "tambon_name": tambon.tambonName,
                "post_code": tambon.postCode,
                "display_text":
                    "${province.provinceName} ${amphur.amphurName} ${tambon.tambonName} ${tambon.postCode}"
              });
            }
          }
        }
      }

      return results;
    }

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
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
                appBar: appBarMasterEndUser('ที่อยู่จัดส่ง'),
                body: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: controller,
                        onChanged: (value) {
                          if (value == '') {
                            return;
                          }
                          if (debounce?.isActive ?? false) {
                            debounce!.cancel();
                          }

                          debounce =
                              Timer(const Duration(milliseconds: 1000), () {
                            setState(() {
                              searchResult = searchAddress(
                                  value); // อัปเดตค่า searchResult โดยตรง
                            });
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 2),
                          hintText: "ค้นหา จังหวัด อำเภอ ตำบล หรือรหัสไปรษณีย์",
                          hintStyle: const TextStyle(fontSize: 13),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme_color_df),
                          ),
                        ),
                      ),
                    ),
                    if (controller!.text != "" && searchResult.isEmpty)
                      const Center(
                          heightFactor: 20, child: Text('ไม่พบข้อมูลที่อยู่'))
                    else
                      Expanded(
                          child: ListView.builder(
                        // cacheExtent: 100,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: searchResult.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.back(result: searchResult[index]);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.pin_drop_outlined,
                                    color: Colors.deepOrange.shade700,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                      child: Text(
                                          searchResult[index]['display_text'],
                                          style:
                                              const TextStyle(fontSize: 13))),
                                ],
                              ),
                            ),
                          );
                        },
                      ))
                  ],
                ),
              ),
            )));
  }
}
