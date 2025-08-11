// ignore_for_file: use_key_in_widget_constructors

import 'package:fridayonline/homepage/point_rewards/point_otp_confirm.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/profileuser/getprofile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../controller/cart/function_add_to_cart.dart';
import '../../controller/point_rewards/point_rewards_controller.dart';
// import '../../model/point_rewards/point_return_confirm_point.dart';
import '../../model/point_rewards/point_rewards_category_detail_by_fscode.dart';
import '../../model/point_rewards/point_rewards_confrim_cupon.dart';
import '../../model/point_rewards/point_rewards_get_msl_info.dart';
import '../../service/languages/multi_languages.dart';
import '../../service/point_rewards/point_rewards_sevice.dart';
import '../../service/profileuser/mslinfo.dart';
import '../home/home_special_promotion_bwpoint.dart';
import '../pageactivity/cart/cart_theme/cart_loading_theme.dart';
import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';
import '../widget/appbar_cart.dart';

class point_rewards_category_list_confirm extends StatefulWidget {
  final String? mparamurl;
  final String? type;

  const point_rewards_category_list_confirm(
      {super.key, required this.mparamurl, this.type});

  @override
  State<point_rewards_category_list_confirm> createState() =>
      _point_rewards_category_list_confirmState();
}

class _point_rewards_category_list_confirmState
    extends State<point_rewards_category_list_confirm> {
  @override
  void initState() {
    super.initState();
    Get.find<PointRewardsCategoryListConfirm>()
        .get_point_category_confirm(widget.mparamurl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitleCart(
            MultiLanguages.of(context)!.translate('me_bw_point'), ""),
        body: GetX<PointRewardsCategoryListConfirm>(
          builder: ((data) {
            var checkTap = 0;

            // print(data.productFscode!.toJson());

            if (!data.isDataLoading.value) {
              if (data.productFscode!.point.isNotEmpty) {
                checkTap++;
              }
              if (data.productFscode!.pointandmoney.isNotEmpty) {
                checkTap++;
              }
              return DefaultTabController(
                length: checkTap,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, top: 0, right: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CachedNetworkImage(
                            imageUrl: data.menuPoint!.datamenu[0].img,
                            width: 40,
                            height: 40,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    data.menuPoint!.datamenu[0].nameMenu,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'คุณมี ${NumberFormat.decimalPattern().format(data.mslInfo!.bprBalance)} ${MultiLanguages.of(context)!.translate('order_point')} ',
                                    style: TextStyle(color: theme_color_df),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black12,
                        thickness: 0.9,
                      ),
                      if (data.productFscode!.point.isNotEmpty &&
                          data.productFscode!.pointandmoney.isNotEmpty)
                        TabBar(
                            labelColor: theme_color_df,
                            indicatorColor: theme_color_df,
                            unselectedLabelColor: Colors.black,
                            indicatorWeight: 2.0,
                            tabs: [
                              Tab(
                                child: Text(
                                    MultiLanguages.of(context)!
                                        .translate('order_point'),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Tab(
                                child: Text(
                                    MultiLanguages.of(context)!
                                        .translate('reward_info_tab2'),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ])
                      else if (data.productFscode!.point.isNotEmpty)
                        TabBar(
                            labelColor: theme_color_df,
                            indicatorColor: theme_color_df,
                            unselectedLabelColor: Colors.black,
                            indicatorWeight: 2.0,
                            tabs: [
                              Tab(
                                child: Text(
                                    MultiLanguages.of(context)!
                                        .translate('order_point'),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ])
                      else
                        TabBar(
                            labelColor: theme_color_df,
                            indicatorColor: theme_color_df,
                            unselectedLabelColor: Colors.black,
                            indicatorWeight: 2.0,
                            tabs: [
                              Tab(
                                child: Text(
                                    MultiLanguages.of(context)!
                                        .translate('reward_info_tab2'),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ]),
                      if (data.productFscode!.point.isNotEmpty &&
                          data.productFscode!.pointandmoney.isNotEmpty)
                        Expanded(
                          child: TabBarView(children: [
                            TabViewPoint(data.productFscode!, data.mslInfo!,
                                widget.type, widget.mparamurl),
                            TabViewPointMoney(
                                data.productFscode!, data.mslInfo!)
                          ]),
                        )
                      else if (data.productFscode!.point.isNotEmpty)
                        Expanded(
                          child: TabBarView(children: [
                            TabViewPoint(data.productFscode!, data.mslInfo!,
                                widget.type, widget.mparamurl)
                          ]),
                        )
                      else
                        Expanded(
                          child: TabBarView(children: [
                            TabViewPointMoney(
                                data.productFscode!, data.mslInfo!)
                          ]),
                        ),
                    ],
                  ),
                ),
              );
            }
            return Center(child: theme_loading_df);
          }),
        ));
  }
}

class TabViewPoint extends StatefulWidget {
  const TabViewPoint(
      this.productFscode, this.mslInfo, this.type, this.mparamurl);
  final GetMslinfo mslInfo;
  final ProductByFscode productFscode;
  final type;
  final mparamurl;
  @override
  State<TabViewPoint> createState() => _TabViewPointState();
}

class _TabViewPointState extends State<TabViewPoint> {
  int point = 0;
  int pointTotal = 0;
  bool showError = false;
  updatePoint(value, pointPrice) {
    if (value == 'add') {
      point = point + 1;
      pointTotal = pointPrice * point;
      if (pointTotal > widget.mslInfo.bprBalance) {
        setState(() {
          showError = true;
        });
      } else {
        setState(() {
          showError = false;
          pointTotal;
        });
      }
    } else {
      if ((point - 1) < 1) {
        setState(() {
          point = 0;
          pointTotal = pointPrice * point;
        });
      } else {
        point = point - 1;
        pointTotal = pointPrice * point;

        if (pointTotal > widget.mslInfo.bprBalance) {
          setState(() {
            showError = true;
          });
        } else {
          setState(() {
            showError = false;
            pointTotal;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mslInfo.bprBalance < widget.productFscode.point[0].pointPrice) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x2B202529),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(widget.productFscode.point[0].nameTh),
                        ),
                        Image.network(
                          widget.productFscode.point[0].imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    const Divider(
                      height: 4,
                      thickness: 2,
                      color: Color(0xFFF1F4F8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('จำนวน'),
                        Row(
                          children: [
                            const Icon(
                              Icons.remove_circle_outline_sharp,
                              size: 30,
                              color: Colors.grey,
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 80,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color.fromARGB(
                                              255, 195, 196, 197),
                                          width: 1.5),
                                    ),
                                  ),
                                  child: Text(
                                    point.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                const Text('คะแนนไม่พอ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                            const Icon(
                              Icons.add_circle_outline_sharp,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      height: 4,
                      thickness: 2,
                      color: Color(0xFFF1F4F8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ใช้คะแนนรวม'),
                        Text(
                            '${NumberFormat.decimalPattern().format(pointTotal)} คะแนน'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                            '${NumberFormat.decimalPattern().format(widget.productFscode.point[0].pointPrice)} x $point'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            // <-- Use Expanded with SizedBox.expand
            child: SizedBox.expand(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    color: Colors.grey,
                    child: InkWell(
                      onTap: () async {
                        print("object+Ton");
                      },
                      child: Center(
                        child: Text(
                          MultiLanguages.of(context)!
                              .translate('rewards_member_menu'),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x2B202529),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(widget.productFscode.point[0].nameTh),
                        ),
                        Image.network(
                          widget.productFscode.point[0].imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    const Divider(
                      height: 4,
                      thickness: 2,
                      color: Color(0xFFF1F4F8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('จำนวน'),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                updatePoint('remove',
                                    widget.productFscode.point[0].pointPrice);
                              },
                              icon: const Icon(
                                Icons.remove_circle_outline_sharp,
                                size: 30,
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 80,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color.fromARGB(
                                              255, 195, 196, 197),
                                          width: 1.5),
                                    ),
                                  ),
                                  child: Text(
                                    point.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                if (showError == true)
                                  const Text('คะแนนไม่พอ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red))
                                else
                                  const Text(''),
                              ],
                            ),
                            if (showError == true)
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add_circle_outline_sharp,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              )
                            else
                              IconButton(
                                onPressed: () {
                                  updatePoint('add',
                                      widget.productFscode.point[0].pointPrice);
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline_sharp,
                                  size: 30,
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      height: 4,
                      thickness: 2,
                      color: Color(0xFFF1F4F8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ใช้คะแนนรวม'),
                        Text(
                            '${NumberFormat.decimalPattern().format(pointTotal)} คะแนน'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                            '${NumberFormat.decimalPattern().format(widget.productFscode.point[0].pointPrice)} x $point'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            // <-- Use Expanded with SizedBox.expand
            child: SizedBox(
              width: Get.width,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    color:
                        showError || point == 0 ? Colors.grey : theme_color_df,
                    child: InkWell(
                      onTap: () async {
                        if (showError) {
                          return;
                        }
                        var mproductType =
                            widget.productFscode.point[0].productType;
                        var usePoint = widget.productFscode.point[0].pointPrice;
                        var productCode =
                            widget.productFscode.point[0].productCode;
                        var mrepSeq = widget.mslInfo.repSeq;
                        var mbprPointMsl = widget.mslInfo.bprBalance;
                        var mqtyConfirm = point;

                        var mproductList = Productlist(
                          imageUrl: widget.productFscode.point[0].imageUrl,
                          productCode:
                              widget.productFscode.point[0].productCode,
                          cateCamp: widget.productFscode.point[0].cateCamp,
                          mediaCode: widget.productFscode.point[0].mediaCode,
                          nameTh: widget.productFscode.point[0].nameTh,
                          nameEn: widget.productFscode.point[0].nameEn,
                          shortNameTh:
                              widget.productFscode.point[0].shortNameTh,
                          pointPrice: widget.productFscode.point[0].pointPrice
                              .toString(),
                          price: widget.productFscode.point[0].price.toString(),
                          productType:
                              widget.productFscode.point[0].productType,
                          qtyConfirm: mqtyConfirm,
                        );

                        var mjson = PointConfrimCupon(
                            repSeq: mrepSeq,
                            proint: mbprPointMsl.toString(),
                            productlist: [mproductList]);

                        if (point > 0) {
                          if (mproductType.toLowerCase() == "c") {
                            loadingCart(context);
                            Mslinfo enduserotp = await getProfileMSL();
                            // ! dev
                            // enduserotp.mslInfo.telnumber = '0826742302';
                            if (enduserotp.mslInfo.telnumber != '') {
                              Get.back();
                              await Get.to(() => PorintOtpConfirm(
                                      enduserotp.mslInfo.telnumber, ''))!
                                  .then((res) async {
                                if (res == true) {
                                  Get.dialog(
                                      barrierDismissible: false,
                                      const AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          content: Center(
                                            child: CircularProgressIndicator(),
                                          )));

                                  await UseProinQtyCall(mjson.toJson())
                                      .then((datajson) async {
                                    Get.back();
                                    if (datajson!.code == "100") {
                                      var mMessage1 = datajson.message1;
                                      var mMessage2 = datajson.message2;
                                      var mPointUse = datajson.pointUse;
                                      var mPointBalance = datajson.pointBalance;

                                      await call_alert(mMessage1, mMessage2,
                                          mPointUse, mPointBalance);
                                    } else {
                                      print("No Data");
                                    }
                                  });
                                }
                              });
                            } else {
                              Get.back();
                              Get.snackbar(
                                  'แจ้งเตือน', 'ขออภัยค่ะไม่พบข้อมูลเบอร์โทร');
                            }
                          } else if (mproductType.toLowerCase() == 'v') {
                            loadingCart(context);
                            Mslinfo enduserotp = await getProfileMSL();
                            // ! dev
                            // enduserotp.mslInfo.telnumber = '0826742302';
                            if (enduserotp.mslInfo.telnumber != '') {
                              Get.back();
                              await Get.to(() => PorintOtpConfirm(
                                      enduserotp.mslInfo.telnumber,
                                      'point_exchange'))!
                                  .then((res) async {
                                if (res == true) {
                                  SetData data = SetData();
                                  Get.dialog(
                                      barrierDismissible: false,
                                      const AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          content: Center(
                                            child: CircularProgressIndicator(),
                                          )));
                                  var payload = {
                                    "id": "",
                                    "rep_seq": mrepSeq,
                                    "rep_code": await data.repCode,
                                    "bill_code": productCode.toString(),
                                    "qty": mqtyConfirm,
                                    "cost_unit": usePoint,
                                    "total_cost": usePoint * point,
                                    "bpr_redeem": usePoint * point,
                                    "channel": "app"
                                  };
                                  await confirmRedeemCash(payload)
                                      .then((datajson) async {
                                    Get.back();
                                    if (datajson!.code == "100") {
                                      var mMessage1 = datajson.message1;
                                      var mMessage2 = datajson.message2;

                                      return Get.bottomSheet(
                                          isDismissible: false,
                                          Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20)),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Lottie.asset(
                                                      width: 230,
                                                      height: 230,
                                                      'assets/images/cart/success_lottie.json'),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 24.0,
                                                        vertical: 10),
                                                    child: Text(mMessage1,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 24.0),
                                                    child: HtmlWidget(
                                                      mMessage2,
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 12),
                                                    child: SizedBox(
                                                        width: Get.width,
                                                        height: 50,
                                                        child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        theme_color_df),
                                                            onPressed: () {
                                                              Get.back();
                                                              Get.back();
                                                              Get.back();
                                                              Get.back();
                                                              Get.back();
                                                            },
                                                            child: const Text(
                                                                'ตกลง',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)))),
                                                  ),
                                                  const SizedBox(height: 12),
                                                ],
                                              )));
                                    } else {
                                      return Get.bottomSheet(
                                          isDismissible: false,
                                          Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20)),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Lottie.asset(
                                                      width: 230,
                                                      height: 230,
                                                      'assets/images/cart/error_confirm.json'),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 24.0,
                                                            vertical: 10),
                                                    child: Text(
                                                        'เกิดข้อผิดพลาด',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20)),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 24.0),
                                                    child: Text(
                                                        'เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้งค่ะ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14)),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 12),
                                                    child: SizedBox(
                                                        width: Get.width,
                                                        height: 50,
                                                        child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        theme_color_df),
                                                            onPressed: () {
                                                              Get.back();
                                                              Get.back();
                                                              Get.back();
                                                              Get.back();
                                                              Get.back();
                                                            },
                                                            child: const Text(
                                                                'ตกลง',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)))),
                                                  ),
                                                  const SizedBox(height: 12),
                                                ],
                                              )));
                                    }
                                  });
                                }
                              });
                            } else {
                              Get.back();
                              Get.snackbar(
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 5),
                                  'แจ้งเตือน',
                                  'ขออภัยค่ะไม่พบข้อมูลเบอร์โทร');
                            }
                          } else {
                            fnEditCartRewardPoint(
                                context, widget.productFscode, point, 'point');
                          }
                        } else {
                          print("object+point น้อยกว่า 0 + point");
                        }
                      },
                      child: Center(
                        child: Text(
                          MultiLanguages.of(context)!
                              .translate('rewards_member_menu'),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  call_alert(String mMessage1, String mMessage2, int mPointUse,
      int mPointBalance) async {
    await Get.dialog(
        barrierDismissible: false,
        WillPopScope(
          onWillPop: () => Future.value(false),
          child: Dialog(
            elevation: 0,
            backgroundColor: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    mMessage1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: 'notoreg'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'คะแนนคงเหลือ ',
                        style: TextStyle(fontFamily: 'notoreg'),
                      ),
                      Text(
                        '${NumberFormat.decimalPattern().format(mPointBalance)} ',
                        style: const TextStyle(fontFamily: 'notoreg'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        width: 100,
                        height: 50,
                        child: InkWell(
                          highlightColor: Colors.grey[200],
                          onTap: () {
                            //do somethig
                            if (widget.type == 'home') {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Get.off(() => const SpecialPromotionBwpoint());
                            } else if (widget.type == 'deepLink') {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Get.off(() => const SpecialPromotionBwpoint());
                            } else {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              // Navigator.pop(context);
                              // Navigator.pop(context);
                            }
                          },
                          child: Center(
                            child: Text(
                              MultiLanguages.of(context)!
                                  .translate('alert_close'),
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: theme_color_df,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'notoreg'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 1,
                ),
              ],
            ),
          ),
        ));
  }
}

class TabViewPointMoney extends StatefulWidget {
  const TabViewPointMoney(this.productFscode, this.mslInfo);
  final GetMslinfo mslInfo;
  final ProductByFscode productFscode;

  @override
  State<TabViewPointMoney> createState() => _TabViewPointMoneyState();
}

class _TabViewPointMoneyState extends State<TabViewPointMoney> {
  int point = 0;
  int pointTotal = 0;
  double priceTotal = 0.00;
  bool showError = false;
  updatePoint(value, pointPrice, price) {
    if (value == 'add') {
      point = point + 1;
      pointTotal = pointPrice * point;
      priceTotal = price * point;
      if (pointTotal > widget.mslInfo.bprBalance) {
        setState(() {
          showError = true;
        });
      } else {
        setState(() {
          showError = false;
          pointTotal;
          priceTotal;
        });
      }
    } else {
      if ((point - 1) < 1) {
        setState(() {
          point = 0;
          pointTotal = pointPrice * point;
          priceTotal = price * point;
        });
      } else {
        point = point - 1;
        pointTotal = pointPrice * point;
        priceTotal = price * point;
        if (pointTotal > widget.mslInfo.bprBalance) {
          setState(() {
            showError = true;
          });
        } else {
          setState(() {
            showError = false;
            pointTotal;
            priceTotal;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mslInfo.bprBalance < widget.productFscode.pointandmoney.length) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x2B202529),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                              widget.productFscode.pointandmoney[0].nameTh),
                        ),
                        Image.network(
                          widget.productFscode.pointandmoney[0].imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    const Divider(
                      height: 4,
                      thickness: 2,
                      color: Color(0xFFF1F4F8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('จำนวน'),
                        Row(
                          children: [
                            const Icon(
                              Icons.remove_circle_outline_sharp,
                              size: 30,
                              color: Colors.grey,
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 80,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color.fromARGB(
                                              255, 195, 196, 197),
                                          width: 1.5),
                                    ),
                                  ),
                                  child: Text(
                                    point.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                const Text('คะแนนไม่พอ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                            const Icon(
                              Icons.add_circle_outline_sharp,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      height: 4,
                      thickness: 2,
                      color: Color(0xFFF1F4F8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ใช้คะแนนรวม'),
                        Text(
                            '${NumberFormat.decimalPattern().format(pointTotal)} คะแนน'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                            '${NumberFormat.decimalPattern().format(widget.productFscode.pointandmoney[0].pointPrice)} x $point'),
                      ],
                    ),
                    const Divider(
                      height: 4,
                      thickness: 2,
                      color: Color(0xFFF1F4F8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ใช้จำนวนเงินรวมรวม'),
                        Text(
                            '${NumberFormat.decimalPattern().format(priceTotal)} ${MultiLanguages.of(context)!.translate('order_baht')}'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                            '${NumberFormat.decimalPattern().format(widget.productFscode.pointandmoney[0].price)} x $point'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            // <-- Use Expanded with SizedBox.expand
            child: SizedBox.expand(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    color: Colors.grey,
                    child: InkWell(
                      onTap: () async {},
                      child: Center(
                        child: Text(
                          MultiLanguages.of(context)!
                              .translate('rewards_member_menu'),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x2B202529),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                              widget.productFscode.pointandmoney[0].nameTh),
                        ),
                        Image.network(
                          widget.productFscode.pointandmoney[0].imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    const Divider(
                      height: 4,
                      thickness: 2,
                      color: Color(0xFFF1F4F8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('จำนวน'),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                updatePoint(
                                    'remove',
                                    widget.productFscode.pointandmoney[0]
                                        .pointPrice,
                                    widget
                                        .productFscode.pointandmoney[0].price);
                              },
                              icon: const Icon(
                                Icons.remove_circle_outline_sharp,
                                size: 30,
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 80,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color.fromARGB(
                                              255, 195, 196, 197),
                                          width: 1.5),
                                    ),
                                  ),
                                  child: Text(
                                    point.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                if (showError == true)
                                  const Text('คะแนนไม่พอ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red))
                                else
                                  const Text(''),
                              ],
                            ),
                            if (showError == true)
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add_circle_outline_sharp,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              )
                            else
                              IconButton(
                                onPressed: () {
                                  updatePoint(
                                      'add',
                                      widget.productFscode.pointandmoney[0]
                                          .pointPrice,
                                      widget.productFscode.pointandmoney[0]
                                          .price);
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline_sharp,
                                  size: 30,
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      height: 4,
                      thickness: 2,
                      color: Color(0xFFF1F4F8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ใช้คะแนนรวม'),
                        Text(
                            '${NumberFormat.decimalPattern().format(pointTotal)} ${MultiLanguages.of(context)!.translate('point_text')}'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                            '${NumberFormat.decimalPattern().format(widget.productFscode.pointandmoney[0].pointPrice)} x $point'),
                      ],
                    ),
                    const Divider(
                      height: 4,
                      thickness: 2,
                      color: Color(0xFFF1F4F8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ใช้จำนวนเงินรวมรวม'),
                        Text(
                            '${NumberFormat.decimalPattern().format(priceTotal)} ${MultiLanguages.of(context)!.translate('order_baht')}'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                            '${NumberFormat.decimalPattern().format(widget.productFscode.pointandmoney[0].price)} x $point'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            // <-- Use Expanded with SizedBox.expand
            child: SizedBox.expand(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    color:
                        showError || point == 0 ? Colors.grey : theme_color_df,
                    child: InkWell(
                      onTap: () async {
                        if (!showError && point > 0) {
                          fnEditCartRewardPoint(context, widget.productFscode,
                              point, 'pointandmoney');
                        } else {
                          print("object+point น้อยกว่า 0 + pointandmoney");
                        }
                      },
                      child: Center(
                        child: Text(
                          MultiLanguages.of(context)!
                              .translate('rewards_member_menu'),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
