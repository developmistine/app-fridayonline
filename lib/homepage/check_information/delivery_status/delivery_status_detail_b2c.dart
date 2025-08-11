import 'package:fridayonline/controller/cancel_order/cancel_ctr.dart';
import 'package:fridayonline/homepage/check_information/delivery_status/delivery_dowload_flag_y.dart';
import 'package:fridayonline/homepage/webview/webview_app.dart';
import 'package:fridayonline/model/set_data/set_data.dart';
import 'package:fridayonline/service/pathapi.dart';

import '../../../../controller/check_information/check_information_controller.dart';
import '../../../../homepage/pageactivity/widget_appbar_title_only.dart';
import '../../../../homepage/theme/theme_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//คลาสสำหรับแสดงรายการสั่งซื้อที่ต้องการแก้ไขจำนวนสินค้าของ end user
class CheckInformationDeliveryStatusDetailB2C extends StatefulWidget {
  final String shopType;
  const CheckInformationDeliveryStatusDetailB2C(
      {super.key, required this.shopType});

  @override
  State<CheckInformationDeliveryStatusDetailB2C> createState() =>
      _CheckInformationDeliveryStatusDetailB2CState();
}

class _CheckInformationDeliveryStatusDetailB2CState
    extends State<CheckInformationDeliveryStatusDetailB2C> {
  CheckInformationDeliveryStatusController dataController = Get.put(
      CheckInformationDeliveryStatusController()); //ทำการ get จาก CheckInformationOrderOrderAllController
  TextEditingController textController =
      TextEditingController(); //เก็บค่า TextField

  final ScrollController _firstController = ScrollController();
  final canCtr = Get.put(CancelProductController());

  @override
  void initState() {
    super.initState();
    canCtr.fetchCancelReason(int.parse(widget.shopType));
  }

  @override
  void dispose() {
    canCtr.isCheck.value = false;
    canCtr.isOther.value = false;
    canCtr.otherNoteCtr.value.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: PopScope(
        canPop: false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: header_title_only(context, 'title_order_detail_view'),
            body: Obx(
              () => dataController.isDataLoading.value
                  ? Center(child: theme_loading_df)
                  // : dataController.downloadflag == 'Y'
                  : DeliveryMslDownloadFlagYB2C(
                      dataController: dataController,
                      width: width,
                      height: height,
                      firstController: _firstController,
                    ),
            ),
            bottomNavigationBar: Obx(() {
              return dataController.isDataLoading.value
                  ? const SizedBox()
                  : dataController.delivery_orderdetail_b2c!.returnFlag
                      ? SafeArea(
                          child: Container(
                              width: Get.width,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: OutlinedButton(
                                onPressed: () async {
                                  SetData data = SetData();
                                  var device = await data.device;
                                  // base_url_web_fridayth
                                  // print(
                                  //     'http://localhost:3000/history/msl/return_product_webview?repSeq=${dataController.delivery_orderdetail_b2c!.repSeq}&repCode=${dataController.delivery_orderdetail_b2c!.repCode}&orderNo=${dataController.delivery_orderdetail_b2c!.orderNo}&orderId=${dataController.delivery_orderdetail_b2c!.orderId}&shopType=2&device=$device}');
                                  await Get.to(() => webview_app(
                                          mparamTitleName: "แจ้งคืนสินค้า",
                                          mparamurl:
                                              '${base_url_web_fridayth}history/msl/return_product_webview?repSeq=${dataController.delivery_orderdetail_b2c!.repSeq}&repCode=${dataController.delivery_orderdetail_b2c!.repCode}&orderNo=${dataController.delivery_orderdetail_b2c!.orderNo}&orderId=${dataController.delivery_orderdetail_b2c!.orderId}&shopType=2&device=$device}'))!
                                      // 'http://localhost:3000/history/msl/return_product_webview?repSeq=${dataController.delivery_orderdetail_b2c!.repSeq}&repCode=${dataController.delivery_orderdetail_b2c!.repCode}&orderNo=${dataController.delivery_orderdetail_b2c!.orderNo}&orderId=${dataController.delivery_orderdetail_b2c!.orderId}&shopType=2&device=$device}'))!
                                      .then((_) {
                                    Get.find<
                                            CheckInformationDeliveryStatusController>()
                                        .fetch_information_delivery_orderdetail_b2c(
                                            dataController
                                                .delivery_orderdetail_b2c!
                                                .orderNo,
                                            dataController
                                                .delivery_orderdetail_b2c!
                                                .orderId
                                                .toString(),
                                            widget.shopType);
                                  });
                                  // 'https://555e-83-118-76-254.ngrok-free.app/history/msl/return_product_webview?repSeq=${dataController.delivery_orderdetail_b2c!.repSeq}&repCode=${dataController.delivery_orderdetail_b2c!.repCode}&orderNo=${dataController.delivery_orderdetail_b2c!.orderNo}&orderId=${dataController.delivery_orderdetail_b2c!.orderId}&shopType=2&device=$device}'));
                                },
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        width: 2, color: Colors.grey.shade700),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)))),
                                child: Text(
                                  'แจ้งคืนสินค้า',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600),
                                  textAlign: TextAlign.center,
                                ),
                              )))
                      : const SizedBox();
            })),
      ),
    );
  }
}
