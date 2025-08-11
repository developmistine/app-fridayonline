// ? point or start rewards
// ignore_for_file: prefer_const_constructors

import 'package:fridayonline/controller/cart/coupon_discount_controller.dart';
import 'package:fridayonline/controller/cart/star_controller.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_loading_theme.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:fridayonline/service/cart/point_service.dart';
import 'package:fridayonline/service/pathapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

import '../../../../controller/cart/point_controller.dart';
import '../../../../model/set_data/set_data.dart';
import '../../../../service/address/addresssearch.dart';
import '../../../../service/languages/multi_languages.dart';
import '../../../theme/theme_color.dart';
import '../cart_theme/cart_all_theme.dart';

var point = Get.find<FetchPointMember>();

class PointMethod extends StatefulWidget {
  const PointMethod(this.totalAmount, {super.key});
  final double totalAmount;

  @override
  State<PointMethod> createState() => _PointMethodState();
}

class _PointMethodState extends State<PointMethod> {
  bool usePoint = false;
  bool inputPoint = true;

  var bgTextfield = Colors.grey.shade300;

  var scrollController = ScrollController();

  TextEditingController pointTextfieldcontroller = TextEditingController();
  SetData data = SetData();
  var userType = '';
  setTypeUser() async {
    userType = await data.repType;
    //log(userType.toString());
    if (userType == '1') {
      Get.find<FetchStar>().fetchstar(); // get point
    } else if (userType == '2') {
      Get.find<FetchPointMember>().fetchPoint(); // get point
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Get.find<FetchPointMember>().countpoint(0, 0); //default delevery
    Get.find<FetchStar>().countpoint(0, 0); //default delevery
    setTypeUser();
  }

  @override
  Widget build(BuildContext context) {
    if (userType == '2') {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: GetBuilder<FetchPointMember>(builder: (point) {
          if (point.isDataLoading.value ||
              int.parse(point.pointMember!.pointAmount
                      .replaceAll(RegExp(','), '')) <
                  1) {
            return Container();
          } else {
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '${MultiLanguages.of(context)!.translate('have_point')} BW Point ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  GetX<FetchPointMember>(builder: (usePoint) {
                                    var pointStars = int.parse(point
                                            .pointMember!.pointAmount
                                            .replaceAll(RegExp(','), '')) -
                                        usePoint.usePoint.value;
                                    return Text(
                                        myFormat.format(pointStars).toString(),
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(46, 169, 225, 1),
                                            fontWeight: FontWeight.bold));
                                  }),
                                  Text(
                                      ' ${MultiLanguages.of(context)!.translate('order_point')}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Text(
                                  MultiLanguages.of(context)!
                                      .translate('order_used_5point'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: theme_grey_text, fontSize: 14)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FlutterSwitch(
                            inactiveColor: Color.fromRGBO(196, 196, 196, 1),
                            activeColor: Color.fromRGBO(46, 169, 225, 1),
                            activeText: MultiLanguages.of(context)!
                                .translate('order_point_used'),
                            activeTextColor: Colors.white,
                            activeTextFontWeight: FontWeight.normal,
                            inactiveText: MultiLanguages.of(context)!
                                .translate('order_not_used'),
                            inactiveTextFontWeight: FontWeight.normal,
                            valueFontSize: 14.0,
                            showOnOff: true,
                            inactiveTextColor: Colors.white,
                            value: usePoint,
                            onToggle: (val) {
                              setState(() {
                                usePoint = val;

                                if (usePoint) {
                                  point_reward(
                                      context,
                                      point.pointMember!.pointAmount,
                                      point.pointMember == null
                                          ? ""
                                          : point.pointMember!.idCardRequire);
                                } else {
                                  point.countpoint(0, 0);
                                  pointTextfieldcontroller.clear();
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      );
    } else if (userType == '1') {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: GetBuilder<FetchStar>(builder: (star) {
          if (star.isDataLoading.value || star.starMember!.starReword < 1) {
            return Container();
          } else {
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                    '${MultiLanguages.of(context)!.translate('have_starts')} ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                GetX<FetchPointMember>(builder: (useStar) {
                                  var pointStars = star.starMember!.starReword -
                                      useStar.usePoint.value;
                                  return Text(
                                      myFormat.format(pointStars).toString(),
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(46, 169, 225, 1),
                                          fontWeight: FontWeight.bold));
                                }),
                                Text(
                                    ' ${MultiLanguages.of(context)!.translate('order_stars')}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            Text(
                                '1 ${MultiLanguages.of(context)!.translate('order_stars')} ${MultiLanguages.of(context)!.translate('equal_to')} 1 ${MultiLanguages.of(context)!.translate('order_baht')}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: theme_grey_text, fontSize: 14)),
                          ],
                        ),
                        FlutterSwitch(
                          inactiveColor: Color.fromRGBO(196, 196, 196, 1),
                          activeColor: Color.fromRGBO(46, 169, 225, 1),
                          activeText: MultiLanguages.of(context)!
                              .translate('order_point_used'),
                          activeTextColor: Colors.white,
                          activeTextFontWeight: FontWeight.normal,
                          inactiveText: MultiLanguages.of(context)!
                              .translate('order_not_used'),
                          inactiveTextFontWeight: FontWeight.normal,
                          valueFontSize: 14.0,
                          showOnOff: true,
                          inactiveTextColor: Colors.white,
                          value: usePoint,
                          onToggle: (val) {
                            setState(() {
                              usePoint = val;

                              if (usePoint) {
                                point_reward(
                                    context,
                                    star.starMember!.starReword.toString(),
                                    point.pointMember == null
                                        ? ""
                                        : point.pointMember!.idCardRequire);
                              } else {
                                Get.find<FetchPointMember>().countpoint(0, 0);
                                pointTextfieldcontroller.clear();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      );
    }
    return SizedBox();
  }

  point_reward(BuildContext context, String pointAmount, String idCardRequire) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        //style textfield
        var inputDecoration = InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme_grey_bg,
              width: 0,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          filled: true,
          fillColor: bgTextfield,
          isDense: true,
          hintText: MultiLanguages.of(context)!.translate('fill_in_score'),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          // border: OutlineInputBorder(),
        );

        return WillPopScope(
          onWillPop: () async => false,
          child: SingleChildScrollView(
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: SafeArea(
                top: false,
                left: false,
                right: false,
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        10.0, 10.0, 10.0, 0.0), // content padding
                    child: GetBuilder<FetchCouponDiscount>(builder: (cDicout) {
                      return Column(
                        // alignment: WrapAlignment.center,
                        children: <Widget>[
                          //title
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 40.0,
                                right: 40.0,
                                top: 40.0,
                                bottom: 10.0),
                            child: Text(
                                MultiLanguages.of(context)!
                                    .translate('tittle_input_point'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: boldText, fontSize: 24)),
                          ),
                          //description point
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: userType.toString() == '2'
                                ? Text(
                                    MultiLanguages.of(context)!
                                        .translate('order_used_5point'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: theme_grey_text, fontSize: 14))
                                : Text(
                                    '1 ${MultiLanguages.of(context)!.translate('order_stars')} ${MultiLanguages.of(context)!.translate('equal_to')} 1 ${MultiLanguages.of(context)!.translate('order_baht')}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: theme_grey_text, fontSize: 16)),
                          ),
                          // text input point
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.2,
                                // height: 40,
                                child: TextField(
                                  onTap: () {
                                    setState(() {
                                      bgTextfield = Colors.white;
                                    });
                                  },
                                  onSubmitted: (text) => setState(() {
                                    bgTextfield = Colors.grey.shade300;
                                  }),
                                  controller: pointTextfieldcontroller,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                    FilteringTextInputFormatter.deny(
                                      RegExp(
                                          r'^0+'), //users can't type 0 at 1st position
                                    ),
                                  ],
                                  textAlign: TextAlign.center,
                                  // readOnly: inputPoint,
                                  decoration: inputDecoration,
                                )),
                          ),
                          // confirm button
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: theme_color_df,
                                  fixedSize: Size(
                                    270,
                                    50,
                                  ),
                                  side: BorderSide(color: theme_color_df)),
                              onPressed: () async {
                                if (widget.totalAmount < 0) {
                                  Navigator.of(context).pop();
                                  return;
                                }
                                int typeDiscount = 0;
                                if (userType == '2') {
                                  typeDiscount = 5;
                                } else if (userType == '1') {
                                  typeDiscount = 1;
                                }
                                String getPoint = '0';
                                // ตัด , comma
                                if (userType == '2') {
                                  getPoint = pointAmount.replaceAll(
                                      RegExp(','), ''); //point ที่มี
                                } else {
                                  getPoint = pointAmount;
                                }

                                if (pointTextfieldcontroller.text.isNotEmpty) {
                                  var pointUse =
                                      int.parse(pointTextfieldcontroller.text);
                                  if (pointUse > int.parse(getPoint)) {
                                    //log('กรณี point ไม่พอ');
                                    Get.snackbar('จำนวนคะแนนไม่เพียงพอ',
                                        'กรุณากรอกคะแนนตามจำนวนที่ใช้ได้');
                                    Navigator.of(context).pop();
                                    pointTextfieldcontroller.clear();
                                    setState(() {
                                      usePoint = false;
                                    });
                                  } else {
                                    if (idCardRequire == "Y") {
                                      var cpRepSeq = await data.repSeq;
                                      var cpRepCode = await data.repCode;
                                      Get.to(() => WebViewFullScreen(
                                              mparamurl: Uri.encodeFull(
                                                  "${baseurl_web_view}main-less/point_req_id.php?repseq=$cpRepSeq&repcode=$cpRepCode")))!
                                          .then((value) async {
                                        Get.find<FetchPointMember>()
                                            .fetchPoint();
                                        loadingProductStock(context);
                                        var res = await GetPoint();
                                        Get.back();
                                        idCardRequire = res!.idCardRequire;
                                      });
                                      return;
                                    }
                                    var discount = pointUse /
                                        typeDiscount; // ราคาส่วนลดของการกดใช้คะแนน
                                    // กรณีใส่คะแนนไม่เกินราคาสินค้า
                                    final disCountPrice = widget.totalAmount -
                                        cDicout.listCoupon.fold(
                                            0,
                                            (sum, item) =>
                                                sum + item.categroyCoupon == 1
                                                    ? item.price
                                                    : 0);

                                    if (discount <= disCountPrice) {
                                      var remaining = discount * typeDiscount;
                                      //?discount คือ  ส่วนลด  //? (remaining) - (remaining % 5) คือ คะเเนนที่ใช้ลบเศษให้หาร 5 ลงตัว
                                      point.countpoint(
                                          discount.toInt(),
                                          ((remaining) -
                                                  (remaining % typeDiscount))
                                              .toInt());
                                      Navigator.of(context).pop();
                                    } else {
                                      // กรณีใส่คะแนนเกินราคาสินค้า
                                      var morePoint =
                                          disCountPrice * typeDiscount;
                                      if (morePoint < 0) {
                                        point.countpoint(0, 0);
                                        pointTextfieldcontroller.text =
                                            point.usePoint.value.toString();
                                      } else {
                                        point.countpoint(disCountPrice.toInt(),
                                            morePoint.toInt());
                                        pointTextfieldcontroller.text =
                                            point.usePoint.value.toString();
                                      }
                                      Navigator.of(context).pop();
                                    }
                                  }
                                }
                              },
                              child: Text(
                                MultiLanguages.of(context)!
                                    .translate('alert_okay'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          // cancel button
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    elevation: 0,
                                    disabledBackgroundColor: theme_color_df,
                                    fixedSize: Size(
                                      270,
                                      50,
                                    ),
                                    backgroundColor: Colors.white,
                                    side: BorderSide(color: theme_color_df)),
                                onPressed: () async {
                                  point.countpoint(0, 0);
                                  pointTextfieldcontroller.clear();
                                  setState(() {
                                    usePoint = false;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  MultiLanguages.of(context)!
                                      .translate('alert_cancel'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: theme_color_df),
                                )),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
