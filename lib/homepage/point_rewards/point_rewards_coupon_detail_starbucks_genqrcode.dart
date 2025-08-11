import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../service/languages/multi_languages.dart';

import '../theme/theme_color.dart';

class point_rewards_coupon_detail_starbucks_genqrcode extends StatefulWidget {
  const point_rewards_coupon_detail_starbucks_genqrcode({
    super.key,
    required this.mparamCouponCode,
    required this.mparamCouponName,
    required this.mparamImgCoupon,
    required this.mparamExpDate,
    required this.mparamCouponType,
    required this.mparamUseCoupon,
  });
  final String mparamCouponCode;
  final String mparamCouponName;
  final String mparamImgCoupon;
  final String mparamExpDate;
  final String mparamCouponType;
  final String mparamUseCoupon;
  final String mde =
      '** Can be used to purchase any product at Starbucks Coffee stores in Thailand. \n สามารถซื้อสินค้าประเภทใดได้ที่ร้านสตาร์บัคส์ทุกสาขาในประเทศไทยเท่านั้น \n *** Cannot be used to reload or activate Starbucks Card and customers will not get Starbucks® Rewards benefits. No refund. No cash exchange. Cannot be copied or duplicated. Starbucks Coffee (Thailand) Co.,Ltd. reserves the right to make any change to the terms and conditions without prior notice. \n ไม่สามารถใช้เติมเงินใส่บัตรสตาร์บัคส์การ์ดและลูกค้าจะไม่ได้รับสิทธิประโยชน์ของ Starbucks Rewards/ ไม่สามารถแลกเป็นเงินสดได้ / ไม่สามารถใช้สิทธิ์ได้หากเป็นการทำสำเนา / บริษัทสตาร์บัคส์ คอฟฟี่ (ประเทศไทย) จำกัด สงวนสิทธิ์ในการเปลี่ยนแปลงเงื่อนไขโดยไม่ต้องแจ้งให้ ทราบล่วงหน้า \n **** e-Coupon must be presented at the time of purchase and not valid if captured or copied. \n ไม่สามารถใช้สิทธิ์จากคูปองรูปภาพที่ถูกคัดลอกในทุกกรณี';

  @override
  State<point_rewards_coupon_detail_starbucks_genqrcode> createState() =>
      _point_rewards_coupon_detai_starbucks_genqrcodeState(
          mparamCouponCode,
          mparamCouponName,
          mparamImgCoupon,
          mparamExpDate,
          mparamCouponType,
          mparamUseCoupon,
          mde);
}

class _point_rewards_coupon_detai_starbucks_genqrcodeState
    extends State<point_rewards_coupon_detail_starbucks_genqrcode> {
  var mparamCouponCode;
  var mparamCouponName;
  var mparamImgCoupon;
  var mparamExpDate;
  var mparamCouponType;
  var mparamUseCoupon;
  var mde;

  get lsRepSeq => null;

  _point_rewards_coupon_detai_starbucks_genqrcodeState(
      this.mparamCouponCode,
      this.mparamCouponName,
      this.mparamImgCoupon,
      this.mparamExpDate,
      this.mparamCouponType,
      this.mparamUseCoupon,
      this.mde);

  @override
  void initState() {
    super.initState();
    print('mparamUseCoupon ' + mparamUseCoupon);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              if (mparamUseCoupon == 'N') {
                Navigator.pop(context, true);
              } else {
                Navigator.pop(context, false);
              }
            },
          ),
          centerTitle: true,
          backgroundColor: theme_color_df,
          title: Text(
            MultiLanguages.of(context)!.translate('coupon_me'),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'notoreg',
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30, left: 30, right: 30, bottom: 10),
                    child: QrImageView(
                      data: mparamCouponCode,
                    ),
                  ),
                  Text(
                    mparamCouponCode,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "รายละเอียดเงื่อนไข",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      mde,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
