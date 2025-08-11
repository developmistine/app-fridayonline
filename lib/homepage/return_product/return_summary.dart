import 'package:fridayonline/homepage/pageactivity/cart/cart_theme/cart_all_theme.dart';
import 'package:fridayonline/homepage/theme/theme_color.dart';
import 'package:fridayonline/homepage/widget/appbarmaster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/themeimage_menu.dart';
import 'components/dialog.dart';

class ReturnSummary extends StatelessWidget {
  ReturnSummary({super.key});
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleMaster('แจ้งคืนสินค้า'),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BlogInput(),
              Divider(
                color: theme_grey_bg,
                thickness: 1,
              ),
              const BlogAddredd(),
              Divider(
                color: theme_space_color,
                thickness: 18,
              ),
              const BlogHeaderAmonnt(),
              const BlogProduct(),
              Divider(
                color: theme_space_color,
                thickness: 18,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: const BoxDecoration(color: Colors.white),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สรุป',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('ยอดรวมสินค้าแจ้งคืน '),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        Text('xxx บาท')
                      ],
                    ),
                    Text(
                      '*ข้อมูลอาจมีการเปลี่ยนแปลง',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Bottom(),
    );
  }
}

class BlogHeaderAmonnt extends StatelessWidget {
  const BlogHeaderAmonnt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(color: Color(0xFFA4D6F1)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'รายการสินค้าแจ้งคืน',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text('(1 รายการ 8 ชิ้น)')
        ],
      ),
    );
  }
}

class BlogProduct extends StatelessWidget {
  const BlogProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(color: theme_grey_bg, width: 1),
                      ),
                      child: Image.asset(
                        imageError,
                        // width: 45,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 8,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'รหัส xxx',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'ราคา xxx ฿',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Text(
                            "สินค้า xxx",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('จำนวนส่งคืน: xxx',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0xFFFFDAD4),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFFD7F6B)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: theme_red,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: const EdgeInsets.all(2),
                      alignment: Alignment.center,
                      child: const Text(
                        'เหตุผล',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 7,
                            child: Text(
                              'ฉันสั่งซื้อสินค้าผิด',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: Icon(Icons.arrow_forward_ios_rounded,
                                size: 16, color: theme_red),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: theme_grey_bg,
            thickness: 1,
          );
        },
      ),
    );
  }
}

class BlogAddredd extends StatelessWidget {
  const BlogAddredd({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ที่อยู่รับคืน',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text(
              '363/22 ซอยคลองสามวา ถนนบางแวก เขตบางแวก แขวงบางแวก กรุงเทพฯ 19101'),
          const Row(
            children: [
              Text('เบอร์โทร',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(
                width: 10,
              ),
              Text('089-999-9999'),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Row(
            children: [
              Text('รายละเอียดเพิ่มเติม',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(width: 5),
              Text('(ไม่บังคับ)',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red)),
            ],
          ),
          SizedBox(
            width: Get.width,
            child: TextField(
              textInputAction: TextInputAction.done,
              // showCursor: false,
              textAlignVertical: TextAlignVertical.center,
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'กรอกรายละเอียด',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme_color_df,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme_color_df,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme_color_df,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class BlogInput extends StatelessWidget {
  const BlogInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(),
          const SizedBox(
            height: 10,
          ),
          RichText(
            text: const TextSpan(
                text: 'ระบุจำนวนกล่องที่ต้องการคืน',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'notoreg',
                    color: Colors.black,
                    fontSize: 16),
                children: [
                  TextSpan(
                    text: ' (จำเป็น)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'notoreg',
                        color: Colors.red,
                        fontSize: 16),
                  )
                ]),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text('จำนวนกล่องที่ใ่ส่สินค้าคืน'),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        // showCursor: false,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'ระบุจำนวน',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: theme_color_df,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: theme_color_df,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: theme_color_df,
                            ),
                          ),
                        ),
                      ))),
              const Text(
                'กล่อง',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Bottom extends StatelessWidget {
  const Bottom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      decoration: BoxDecoration(color: theme_grey_text),
      child: const Text(
        'เพิ่มรายละเอียดเพิ่มเติม',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'รายละเอียดเพิ่มเติม',
          style: TextStyle(
              color: theme_color_df, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              backgroundColor: theme_color_df,
            ),
            onPressed: () {
              alertInfo();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white, width: 2)),
                    child: const Icon(Icons.question_mark_rounded)),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'วิธีการ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ))
      ],
    );
  }

  void alertInfo() {
    Get.dialog(
        barrierColor: Colors.black.withOpacity(0.2),
        ReturnDialog(chilWidget: [
          Center(
            child: Text(
              'แจ้งเตือน',
              style: TextStyle(
                  color: theme_color_df,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          Image.asset('assets/images/box.png'),
          const Text(
            'ข้อแนะนำ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const ListTile(
            minLeadingWidth: 0,
            contentPadding: EdgeInsets.only(left: 8),
            leading: Icon(
              Icons.circle,
              size: 6,
              color: Colors.black,
            ),
            title: Text('ตรวจสอบจำนวนกล่องในการบรรจุสินค้าทั้งหมด'),
          ),
          const ListTile(
            minLeadingWidth: 0,
            contentPadding: EdgeInsets.only(left: 8),
            leading: Icon(
              Icons.circle,
              size: 6,
              color: Colors.black,
            ),
            title: Text(
                'ที่อยู่รับคืนสินค้า เป็นที่อยู่ที่ขนส่งได้ทำการส่งสินค้าให้'),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'หมายเหตุ',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
          ),
          const Text(
              'ข้อมูลสินค้าที่ท่านแจ้งคืนอาจมีการเปลี่ยนแปลง โปรดตรวจสอบทุกครั้งเมื่อมีการแจ้งเตือนเกี่ยวกับการแจ้งคืนของท่าน'),
        ]));

    // Get.dialog(
    //     barrierColor: Colors.black.withOpacity(0.2),
    //     AlertDialog(
    //       actionsPadding: EdgeInsets.zero,
    //       shape:
    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //       content: SingleChildScrollView(
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             ],
    //         ),
    //       ),
    //       actions: [
    //         InkWell(
    //           // overlayColor: MaterialStateProperty.all(Colors.transparent),
    //           borderRadius: const BorderRadius.only(
    //               bottomLeft: Radius.circular(12),
    //               bottomRight: Radius.circular(12)),
    //           onTap: () {
    //             Get.back();
    //           },
    //           child: Container(
    //             alignment: Alignment.center,
    //             // margin: const EdgeInsets.symmetric(vertical: 10),
    //             decoration: BoxDecoration(
    //                 border: Border(
    //                     top: BorderSide(color: theme_grey_bg, width: 1))),
    //             width: Get.width,
    //             height: 55,
    //             child: Text(
    //               'ปิด',
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                   color: theme_color_df,
    //                   fontWeight: FontWeight.bold,
    //                   fontSize: 16),
    //             ),
    //           ),
    //         )
    //       ],
    //     ));
  }
}
