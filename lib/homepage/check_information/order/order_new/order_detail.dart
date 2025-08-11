import 'package:fridayonline/controller/cancel_order/cancel_ctr.dart';
import 'package:fridayonline/homepage/check_information/order/order_new/dowload_flag_y.dart';

import '../../../../controller/check_information/check_information_controller.dart';
import '../../../../homepage/pageactivity/widget_appbar_title_only.dart';
import '../../../../homepage/theme/theme_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//คลาสสำหรับแสดงรายการสั่งซื้อที่ต้องการแก้ไขจำนวนสินค้าของ end user
class OrderDetailMsl extends StatefulWidget {
  final String shopType;
  const OrderDetailMsl({super.key, required this.shopType});

  @override
  State<OrderDetailMsl> createState() => _OrderDetailMslState();
}

class _OrderDetailMslState extends State<OrderDetailMsl> {
  CheckInformationOrderOrderAllController dataController = Get.put(
      CheckInformationOrderOrderAllController()); //ทำการ get จาก CheckInformationOrderOrderAllController
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
          body: Obx(() => dataController.isDataLoading.value
              ? Center(child: theme_loading_df)
              // : dataController.downloadflag == 'Y'
              : MslDownloadFlagYB2C(
                  dataController: dataController,
                  width: width,
                  height: height,
                  firstController: _firstController,
                  shopType: widget.shopType)),
        ),
      ),
    );
  }
}
