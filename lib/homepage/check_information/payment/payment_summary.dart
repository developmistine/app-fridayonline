import 'package:fridayonline/controller/check_information/check_information_controller.dart';
import 'package:fridayonline/homepage/check_information/payment/payment_cutomer.dart';
import 'package:fridayonline/homepage/check_information/payment/payment_order/order_enduser.dart';
import 'package:fridayonline/homepage/check_information/payment/payment_order/order_msl.dart';
import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/webview/webview_full_screen.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:fridayonline/model/check_information/payment/main_payment.dart';
import 'package:fridayonline/service/paymentsystem/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSummary extends StatelessWidget {
  final String arBal;
  const PaymentSummary(this.arBal, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarTitleMaster('ยอดเงินที่ต้องชำระ'),
        body: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Stack(
            children: [
              const Background(),
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: FutureBuilder(
                      future: paymentMainpage(),
                      builder: (BuildContext context,
                          AsyncSnapshot<MainPayment?> snapshot) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CardPayment(arBal: arBal, data: snapshot),
                            const SizedBox(
                              height: 12,
                            ),
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              Column(
                                children: [
                                  loadingContainer(),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  loadingContainer(),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  MslPayment(snapshot.data!.mslPayment),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  EndUserPayment(snapshot.data!.enduserPayment),
                                ],
                              ),
                          ],
                        );
                      }),
                ),
              ),
            ],
          ),
        ));
  }

  Card loadingContainer() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      elevation: 4,
      child: SizedBox(
        width: Get.width,
        height: 125,
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.38,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.00, -1.00),
          end: const Alignment(0, 1),
          colors: [theme_color_df, const Color.fromARGB(255, 77, 219, 219)],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(72),
            bottomRight: Radius.circular(72),
          ),
        ),
      ),
    );
  }
}

class EndUserPayment extends StatelessWidget {
  const EndUserPayment(
    this.enduserPayment, {
    super.key,
  });
  final Payment enduserPayment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Get.find<PayMentController>().call_get_payment_endUser();
        Get.to(() => const OrderPayMentEndUsers());
      },
      child: Card(
        color: const Color(0xFFFFFAF2),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              width: 3, color: Color.fromRGBO(252, 182, 53, 1)),
          borderRadius: BorderRadius.circular(14.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/images/chart.png'),
                      width: 24,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ยอดคำสั่งซื้อลูกค้า',
                          style: TextStyle(
                              color: theme_color_df,
                              fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => const OrderPayMentEndUsers());
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: theme_color_df,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Text(
                        enduserPayment.textDetail,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${double.parse(enduserPayment.totAmount) != 0 ? myFormat2Digits.format(double.parse(enduserPayment.totAmount)) : double.parse(enduserPayment.totAmount).toStringAsFixed(2)} บาท',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Text(
                                'ยอดสั่งซื้อ',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${myFormat.format(enduserPayment.orderQty)} รายการ',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'ลูกค้าสั่งซื้อ',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MslPayment extends StatelessWidget {
  const MslPayment(
    this.mslPayment, {
    super.key,
  });
  final Payment mslPayment;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<PayMentController>().call_get_payment_msl();
        Get.to(() => const OrderPayMentMsl());
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 3, color: theme_color_df),
          borderRadius: BorderRadius.circular(14.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/images/chart.png'),
                      width: 24,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ยอดคำสั่งซื้อในนามสมาชิก',
                          style: TextStyle(
                              color: theme_color_df,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: theme_color_df,
                          size: 14,
                        ),
                      ],
                    ),
                    Text(
                      mslPayment.textDetail,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${double.parse(mslPayment.totAmount) != 0 ? myFormat2Digits.format(double.parse(mslPayment.totAmount)) : double.parse(mslPayment.totAmount).toStringAsFixed(2)} บาท',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Text(
                                'ยอดสั่งซื้อรวม',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${myFormat.format(mslPayment.orderQty)} คำสั่งซื้อ',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'จำนวน',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardPayment extends StatelessWidget {
  const CardPayment({
    super.key,
    required this.arBal,
    required this.data,
  });

  final String arBal;
  final AsyncSnapshot<MainPayment?> data;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24),
          child: Column(
            children: [
              data.connectionState == ConnectionState.waiting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: CircleAvatar(
                            backgroundColor: theme_red,
                            radius: 30,
                            child: const Icon(
                              Icons.question_mark,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'เรียนรู้เพิ่มเติม',
                          style: TextStyle(color: theme_red),
                        )
                      ],
                    )
                  : InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Get.to(() => WebViewFullScreen(
                            mparamurl: data.data!.paymentUrl));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: CircleAvatar(
                              backgroundColor: theme_red,
                              radius: 30,
                              child: const Icon(
                                Icons.question_mark,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            'เรียนรู้เพิ่มเติม',
                            style: TextStyle(color: theme_red),
                          )
                        ],
                      ),
                    ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/images/money.png'),
                    width: 28,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'ยอดค้างชำระทั้งหมด',
                    style: TextStyle(
                        color: theme_color_df,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
              Text(
                '${double.parse(arBal) > 0 ? myFormat2Digits.format(double.parse(arBal)) : 0.toStringAsFixed(2)} บาท',
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                'กระเป๋าเงินของฉัน  ${double.parse(arBal) >= 0 ? 0.toStringAsFixed(2) : myFormat2Digits.format(-(double.parse(arBal)))}  ฿',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      backgroundColor: theme_color_df),
                  onPressed: () {
                    Get.to(() => payment_cutomer(double.parse(arBal) > 0
                        ? arBal
                        : "0.0")); // ทำการส่ง ยอดเงินที่ค้่างชำระไปที่ระบบดังกล่าว
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'ชำระเงิน',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
