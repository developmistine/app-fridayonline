import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/theme_color.dart';
import 'components/dialog.dart';

class ReturnHistoryDetails extends StatefulWidget {
  const ReturnHistoryDetails({super.key});

  @override
  State<ReturnHistoryDetails> createState() => _ReturnHistoryDetailsState();
}

class _ReturnHistoryDetailsState extends State<ReturnHistoryDetails> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showDialog();
      });
    }
  }

  _showDialog() {
    Get.dialog(barrierColor: Colors.black.withOpacity(0.2),
        StatefulBuilder(builder: (BuildContext context, setState) {
      return ReturnDialog(chilWidget: [
        Center(
          child: Text(
            'แจ้งเตือน',
            style: TextStyle(
                color: theme_color_df,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ),
        Image.asset('assets/images/return.png'),
        Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('การคืนสินค้าต้อง'),
              const Text(
                'บรรจุสินค้าคืนใส่กล่องเท่านั้น',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                      text: 'พร้อม',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'notoreg',
                          fontSize: 16),
                      children: [
                        TextSpan(
                          text:
                              ' แนบสำเนาใบส่งของขีดเส้นใต้\nรายการสินค้าที่คืน',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'notoreg',
                              fontSize: 16),
                        ),
                      ])),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('เขียนติดหน้ากล่องพัสดุบรรจุสินค้าคืน'),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. เขียนชื่อสกุล',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '2. เบอร์โทร',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '3. เลขที่ใบรับคืน',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        const Text('(ข้อมูลบางส่วน จะแสดงหลังเจ้าหน้าที่อนุมัติคำขอแล้ว)'),
        const SizedBox(
          height: 12,
        ),
        InkWell(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: () {
            setState(() {
              isChecked = !isChecked;
            });
          },
          child: Row(
            children: [
              Icon(
                Icons.check_box,
                size: 28,
                color: isChecked ? theme_color_df : theme_grey_text,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text('ฉันได้ดำเินการเรียบร้อยแล้ว'),
            ],
          ),
        ),
      ]);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleMaster('ประวัติแจ้งคืนสินค้า'),
      body: SingleChildScrollView(
        // controller: controller,
        child: Column(
          children: [
            const BlogStatus(),
            Divider(
              thickness: 10,
              color: theme_space_color,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ข้อมูลกล่องพัสดุ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme_color_df),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        backgroundColor: theme_color_df,
                      ),
                      onPressed: () {
                        _showDialog();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              child: const Icon(Icons.question_mark_rounded)),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'วิธีการ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogStatus extends StatelessWidget {
  const BlogStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: const BoxDecoration(color: Color(0xFFA4D6F1)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Image.asset(
            'assets/images/box2.png',
            fit: BoxFit.contain,
            height: 55,
          )),
          const SizedBox(
            width: 10,
          ),
          const Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'อนุมัติ/หักลดหนี้เรียบร้อย',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                    'หากไม่ส่งคืนสินค้าตามระยะเวลาที่กำหนดระบบจะทำการเพิ่มยอดกลับอัตโนมัติ')
              ],
            ),
          )
        ],
      ),
    );
  }
}
