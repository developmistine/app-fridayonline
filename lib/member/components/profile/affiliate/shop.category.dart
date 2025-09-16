import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';

const cetegoryData = [
  // {
  //   "catid": 846,
  //   "catname": "โฟมล้างหน้าตัวดังมิสทิน ชิ้นละ 65.-",
  //   "sub_categories": []
  // }
];

class ShopCategory extends StatelessWidget {
  const ShopCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = cetegoryData.isEmpty;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            spacing: 8,
            children: [
              if (isEmpty)
                buildEmptyBox('ไม่พบหมวดหมู่', 'โปรดสร้างหมวดหมู่สินค้า',
                    'สร้างหมวดหมู่'),
              if (!isEmpty)
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cetegoryData.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> items =
                        cetegoryData[index] as Map<String, dynamic>;
                    return buildContentSection(items);
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          isEmpty ? const SizedBox() : buildBottomButton('จัดการหมวดหมู่'),
    );
  }
}
