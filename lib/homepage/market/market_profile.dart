import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../../model/market/market_get_favorite_product.dart';
import '../../model/market/market_get_tracking_status.dart';
import '../../model/set_data/set_data.dart';
import '../../service/market/market_service.dart';
import '../../service/pathapi.dart';
import '../theme/theme_color.dart';
import '../theme/theme_loading.dart';
import '../webview/webview_full_screen.dart';

class MarketProfile extends StatefulWidget {
  const MarketProfile({Key? key}) : super(key: key);

  @override
  State<MarketProfile> createState() => _MarketProfileState();
}

class _MarketProfileState extends State<MarketProfile> {
  var mImgprofi;
  var mName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startDfdata();
  }

  void startDfdata() async {
    SetData data = SetData();
    mImgprofi = await data.profileImg;
    mName = await data.displayname;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

        //future: GetMslInfoSevice(),
        future: Future.wait([
          GetTrackingStatusCall(),
          GetMarketFavoriteProductCall(),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var result = snapshot.data;
            MarketGetTracking mGetTracking = result![0];
            MarketGetFavoriteProduct mGetMarketFavoriteProduct = result[1];

            var mPayMent = mGetTracking.trackingStatus.payMent;
            var mShipping = mGetTracking.trackingStatus.shipping;
            var mReciveOrder = mGetTracking.trackingStatus.reciveOrder;
            var mReview = mGetTracking.trackingStatus.review;
            bool bPayMent = false;
            bool bShipping = false;
            bool bReciveOrder = false;
            bool bReview = false;

            if (mPayMent.toString() != "0") {
              bPayMent = true;
            }
            if (mShipping.toString() != "0") {
              bShipping = true;
            }
            if (mReciveOrder.toString() != "0") {
              bReciveOrder = true;
            }
            if (mReview.toString() != "0") {
              bReview = true;
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if ((mImgprofi == 'profile_null') || (mImgprofi == ''))
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10000.0),
                            child: Image.asset(
                              'assets/images/error/image_error_profile_market.png',
                              fit: BoxFit.fill,
                              width: 80,
                            ))
                      else
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10000.0),
                            child: CachedNetworkImage(
                              imageUrl: mImgprofi,
                              fit: BoxFit.fill,
                              width: 80,
                              height: 80,
                            )),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(
                            '/market_supplier_login',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme_color_df,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            textStyle: const TextStyle(
                                fontSize: 15, fontFamily: 'notoreg')),
                        child: Text(
                          'ร้านค้าของฉัน',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(mName.toString(),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color(0xFF2EA9E1),
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            onClickTab(mType: "view_order_tab1", mVal: "1");
                          },
                          child: Column(children: [
                            Center(
                              child: badges.Badge(
                                  showBadge: bPayMent,
                                  badgeContent: Text(
                                    mPayMent,
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.white),
                                  ),
                                  child: Image.asset(
                                    "assets/images/menu/market/mar_menutab_1.png",
                                    width: 30,
                                    height: 30,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "ที่ต้องชำระ",
                                style: TextStyle(
                                    color: Color(0xFF2EA9E1), fontSize: 14),
                              ),
                            )
                          ]),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            onClickTab(mType: "view_order_tab2", mVal: "2");
                          },
                          child: Column(children: [
                            Center(
                              child: badges.Badge(
                                showBadge: bShipping,
                                badgeContent: Text(
                                  mShipping,
                                  style: TextStyle(
                                      fontSize: 9, color: Colors.white),
                                ),
                                child: Image.asset(
                                  "assets/images/menu/market/mar_menutab2.png",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "ที่ต้องจัดส่ง",
                                style: TextStyle(
                                    color: Color(0xFF2EA9E1), fontSize: 14),
                              ),
                            )
                          ]),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            onClickTab(mType: "view_order_tab3", mVal: "3");
                          },
                          child: Column(children: [
                            Center(
                              child: badges.Badge(
                                showBadge: bReciveOrder,
                                badgeContent: Text(
                                  mReciveOrder,
                                  style: TextStyle(
                                      fontSize: 9, color: Colors.white),
                                ),
                                child: Image.asset(
                                  "assets/images/menu/market/mar_menutab3.png",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "ที่ต้องได้รับ",
                                style: TextStyle(
                                    color: Color(0xFF2EA9E1), fontSize: 14),
                              ),
                            )
                          ]),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            onClickTab(mType: "view_order_tab4", mVal: "4");
                          },
                          child: Column(children: [
                            Center(
                              child: badges.Badge(
                                showBadge: bReview,
                                badgeContent: Text(
                                  mReview,
                                  style: TextStyle(
                                      fontSize: 9, color: Colors.white),
                                ),
                                child: Image.asset(
                                  "assets/images/menu/market/mar_menutab4.png",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "รอการรีวิว",
                                style: TextStyle(
                                    color: Color(0xFF2EA9E1), fontSize: 14),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  onClickTab(mType: "menu_tab1", mVal: "1");
                                },
                                leading: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/menu/market/mar_menu_order.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                title: const Text('ออเดอร์ของฉัน'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "ดูออเดอร์ทั้งหมด",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      child: Divider(
                                        color: Colors.cyan,
                                      ),
                                    ),
                                  ],
                                ),
                                iconColor: Color(0xFF2EA9E1),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 1, left: 10, right: 10),
                                child: Divider(
                                  height: 1,
                                  color: Colors.cyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  onClickTab(mType: "menu_tab2", mVal: "2");
                                },
                                leading: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/menu/market/mar_menu_jus.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                title: const Text('สินค้าที่ถูกใจ'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${mGetMarketFavoriteProduct.countBadge.toString()} รายการ",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      child: Divider(
                                        color: Colors.cyan,
                                      ),
                                    ),
                                  ],
                                ),
                                iconColor: Color(0xFF2EA9E1),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 1, left: 10, right: 10),
                                child: Divider(
                                  height: 1,
                                  color: Colors.cyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  onClickTab(mType: "menu_tab3", mVal: "3");
                                },
                                leading: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/menu/market/mar_menu_time.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                title: const Text('ดูลาสุด'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      child: Divider(
                                        color: Colors.cyan,
                                      ),
                                    ),
                                  ],
                                ),
                                iconColor: Color(0xFF2EA9E1),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 1, left: 10, right: 10),
                                child: Divider(
                                  height: 1,
                                  color: Colors.cyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  onClickTab(mType: "menu_tab4", mVal: "4");
                                },
                                leading: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/menu/market/mar_menu_info.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                title: const Text('ช่วยเหลือ'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 1, left: 10, right: 10),
                                child: Divider(
                                  height: 1,
                                  color: Colors.cyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          elevation: 0,
                                          backgroundColor: Color(0xffffffff),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "ออกจากระบบ",
                                                    style: TextStyle(
                                                        color: theme_color_df,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text(
                                                  "คุณต้องการออกจากระบบ ใช่หรือไม่",
                                                  style: TextStyle(
                                                      fontFamily: 'notoreg'),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Divider(
                                                height: 1,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 50,
                                                      child: InkWell(
                                                        highlightColor:
                                                            Colors.grey[200],
                                                        onTap: () {
                                                          //do somethig

                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            "ยกเลิก",
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'notoreg'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 50,
                                                      child: InkWell(
                                                        highlightColor:
                                                            Colors.grey[200],
                                                        onTap: () {
                                                          //do somethig

                                                          onClickTab(
                                                              mType:
                                                                  "logoutmarket",
                                                              mVal: "1");
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            "ตกลง",
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'notoreg'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      context: context);
                                },
                                leading: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/menu/market/mar_menu_logout.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                title: const Text('ออกจากระบบ'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 1, left: 10, right: 10),
                                child: Divider(
                                  height: 1,
                                  color: Colors.cyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              heightFactor: 15,
              child: theme_loading_df,
            );
          }
        });
  }
}

void onClickTab({required String mType, required String mVal}) async {
  SetData data = SetData();
  var mdevice = await data.device;
  var mCustId = await data.customerId;
  switch (mType) {
    case "view_order_tab1":
      var param_view = "&orders=2";
      var paramUrl =
          "${baseurl_web_view}view_all_order?app=1&TagID=&TagCode=&CustId=$mCustId&CustType=EUS&typeapp=$mdevice&version=1$param_view";
      Get.to(() =>
          WebViewFullScreen(mparamurl: Uri.encodeFull(paramUrl.toString())));

      break;
    case "view_order_tab2":
      var paramUrl =
          "${baseurl_web_view}view_all_order?app=1&TagID=&TagCode=&CustId=$mCustId&CustType=EUS&typeapp=$mdevice&version=1";
      Get.to(() =>
          WebViewFullScreen(mparamurl: Uri.encodeFull(paramUrl.toString())));
      break;
    case "view_order_tab3":
      var param_view = "&orders=3";
      var paramUrl =
          "${baseurl_web_view}view_all_order?app=1&TagID=&TagCode=&CustId=$mCustId&CustType=EUS&typeapp=$mdevice&version=1$param_view";
      Get.to(() =>
          WebViewFullScreen(mparamurl: Uri.encodeFull(paramUrl.toString())));
      break;
    case "view_order_tab4":
      var param_view = "&orders_review=4";
      var paramUrl =
          "${baseurl_web_view}my_orders_review?app=1&TagID=&TagCode=&CustId=$mCustId&CustType=EUS&typeapp=$mdevice&version=1$param_view";
      Get.to(() =>
          WebViewFullScreen(mparamurl: Uri.encodeFull(paramUrl.toString())));

      break;
    case "menu_tab1":
      var paramUrl =
          "${baseurl_web_view}view_all_order?app=1&TagID=&TagCode=&CustId=$mCustId&CustType=EUS&typeapp=$mdevice&version=1";
      Get.to(() =>
          WebViewFullScreen(mparamurl: Uri.encodeFull(paramUrl.toString())));

      break;
    case "menu_tab2":
      var paramUrl =
          "${baseurl_web_view}favorite-product?app=1&TagID=&TagCode=&CustId=$mCustId&CustType=EUS&typeapp=$mdevice&version=1";
      Get.to(() =>
          WebViewFullScreen(mparamurl: Uri.encodeFull(paramUrl.toString())));

      break;
    case "menu_tab3":
      var paramUrl =
          "${baseurl_web_view}last-product?app=1&TagID=&TagCode=&CustId=$mCustId&CustType=EUS&typeapp=$mdevice&version=1";
      Get.to(() =>
          WebViewFullScreen(mparamurl: Uri.encodeFull(paramUrl.toString())));

      break;
    case "menu_tab4":
      var paramUrl =
          "${baseurl_web_view}help_center?app=1&TagID=&TagCode=&CustId=$mCustId&CustType=EUS&typeapp=$mdevice&version=1";
      Get.to(() =>
          WebViewFullScreen(mparamurl: Uri.encodeFull(paramUrl.toString())));

      break;
    case "logoutmarket":
      var paramUrl =
          "${baseurl_web_view}logout-app?app=1&TagID=&TagCode=&CustId=$mCustId&CustType=EUS&typeapp=$mdevice&version=1";
      Get.to(() =>
          WebViewFullScreen(mparamurl: Uri.encodeFull(paramUrl.toString())));

      break;
  }
}
