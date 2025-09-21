import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.content.add.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/edit.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import themeColorDefault จากไฟล์ theme ของคุณ

class ShopAddCategory extends StatefulWidget {
  const ShopAddCategory({super.key});

  @override
  State<ShopAddCategory> createState() => _ShopAddCategoryState();
}

class _ShopAddCategoryState extends State<ShopAddCategory> {
  final affContentCtl = Get.find<AffiliateContentCtr>();
  @override
  void initState() {
    super.initState();
    affContentCtl.contentTypeId.value = 2;
  }

  @override
  void dispose() {
    affContentCtl.clearAddContentData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: themeColorDefault, // สีปุ่ม back
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
        title: Text(
          'เพิ่มหมวดหมู่',
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF1F1F1F),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Obx(() {
            return ElevatedButton(
              onPressed: affContentCtl.isSubmitting.value
                  ? null // disable button while submitting
                  : () => affContentCtl.validateAndSubmitContent(),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColorDefault,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: affContentCtl.isSubmitting.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'บันทึก',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            );
          }),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                const FieldLabel(
                  title: 'ชื่อหมวดหมู่',
                  requiredMark: true,
                ),
                InputBox(
                  controller: affContentCtl.contentNameCtrl,
                  hint: 'ชื่อหมวดหมู่',
                  ctl: affContentCtl,
                  field: AddContentField.contentName,
                  onChanged: affContentCtl.onContentNameChanged,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FieldLabel(title: 'รายการสินค้า'),
                    Obx(() {
                      final items = affContentCtl.selectedProducts.length;
                      return FieldLabel(title: '$items รายการ');
                    }),
                  ],
                ),
                PreviewContent(),
                Obx(() {
                  final err = affContentCtl.vUploadRequired();
                  final show =
                      affContentCtl.submittedAddContent.value && err != null;
                  if (!show) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      err,
                      style: const TextStyle(
                          color: Color(0xFFF44336), fontSize: 12),
                    ),
                  );
                }),
              ],
            ),
            addButton(
                contentTypeId: 2,
                currentCount: affContentCtl.selectedProducts.length,
                max: 20)
          ],
        ),
      ),
    );
  }
}
