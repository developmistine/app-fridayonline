import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/components/profile/myreview/edit.review.card.dart';
import 'package:fridayonline/enduser/controller/order.ctr.dart';
import 'package:fridayonline/enduser/controller/review.ctr.dart';
import 'package:fridayonline/enduser/services/review%20/review.service.dart';
import 'package:fridayonline/enduser/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:fridayonline/preferrence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class EditRating extends StatefulWidget {
  const EditRating({super.key});

  @override
  State<EditRating> createState() => _EditRatingState();
}

class _EditRatingState extends State<EditRating> {
  final pendingCtr = Get.find<MyReviewCtr>();
  int deliveryRating = 5;
  bool isDefault = true;
  @override
  void dispose() {
    pendingCtr.imageFile.clear();
    pendingCtr.videoFile.clear();
    pendingCtr.productRatings.clear();
    pendingCtr.textReview.clear();
    super.dispose();
  }

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
            backgroundColor: Colors.grey[100],
            appBar: appBarMasterEndUser('ให้คะแนนสินค้า'),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Obx(() {
                if (pendingCtr.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (pendingCtr.pendingReviews!.data.isEmpty) {
                  return const Center(
                    child: Text('ไม่พบข้อมูล'),
                  );
                }
                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Column(
                    children: [
                      editReviewCard(),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shadowColor: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ผู้ให้บริการขนส่ง',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade700),
                              ),
                              RatingBar(
                                itemSize: 32,
                                initialRating: 5,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding: const EdgeInsets.only(right: 4),
                                onRatingUpdate: (rating) {
                                  deliveryRating = rating.toInt();
                                },
                                ratingWidget: RatingWidget(
                                  full: Image.asset(
                                      'assets/images/review/new-fullstar.png'),
                                  half: Image.asset(
                                      'assets/images/review/new-halfstar.png'),
                                  empty: Image.asset(
                                      'assets/images/review/new-empstar.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shadowColor: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'แสดงชื่อผู้ใช้ในรีวิว',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade700),
                              ),
                              FlutterSwitch(
                                inactiveColor:
                                    const Color.fromRGBO(196, 196, 196, 1),
                                activeColor: themeColorDefault,
                                activeTextColor: Colors.white,
                                activeTextFontWeight: FontWeight.normal,
                                inactiveTextFontWeight: FontWeight.normal,
                                height: 30,
                                width: 55,
                                activeText: "",
                                inactiveText: "",
                                showOnOff: true,
                                inactiveTextColor: Colors.black,
                                value: isDefault,
                                onToggle: (val) {
                                  setState(() {
                                    isDefault = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(themeColorDefault),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 12)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                        ),
                        onPressed: () async {
                          SetData data = SetData();
                          var product = [];
                          for (var data in pendingCtr.pendingReviews!.data) {
                            product.add({
                              "product_id": data.productId,
                              "item_id": data.itemId,
                              "orddtl_id": data.orddtlId,
                              "qty": data.amount,
                              "product_ratings":
                                  pendingCtr.productRatings[data.itemId],
                              "delivery_ratings": deliveryRating,
                              "comment":
                                  pendingCtr.textReview[data.itemId]?.text ??
                                      "",
                            });
                          }
                          Map<String, dynamic> payload = {
                            "cust_id": await data.b2cCustID,
                            "hide_display_name": isDefault,
                            "ordshop_id":
                                pendingCtr.pendingReviews!.data[0].ordshopId,
                            "products": product
                          };

                          Get.dialog(
                              barrierDismissible: false,
                              barrierColor: Colors.transparent,
                              AlertDialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                content: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          // height: 150,
                                          child: Lottie.asset(
                                            'assets/images/loading_line.json',
                                            height: 110,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                          await submitReview(
                                  json: payload,
                                  images: pendingCtr.imageFile,
                                  video: pendingCtr.videoFile)
                              .then((res) {
                            Get.back();
                            if (res!.code == "100") {
                              dialogAlert([
                                const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                const Text(
                                  'บันทึกข้อมูลเรียบร้อย',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                )
                              ]);
                              Future.delayed(const Duration(milliseconds: 1500),
                                  () {
                                Get.back();
                                Get.back();
                                Get.find<OrderController>()
                                    .fetchOrderList(3, 0);
                              });
                            } else {
                              if (!Get.isSnackbarOpen) {
                                Get.snackbar('', '',
                                    titleText: Text('แจ้งเตือน',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            color: Colors.white)),
                                    messageText: Text(
                                        'เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้ง',
                                        style: GoogleFonts.notoSansThaiLooped(
                                            color: Colors.white)),
                                    backgroundColor:
                                        Colors.red.withOpacity(0.8),
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 2));
                              }
                              return;
                            }
                          });
                        },
                        child: const Text(
                          'ยืนยัน',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
