import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.apply.dart';
import 'package:fridayonline/member/components/utils/showlink.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:fridayonline/member/models/affiliate/profile.model.dart';
import 'package:fridayonline/service/pathapi.dart';

import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingAffAccount extends StatefulWidget {
  const SettingAffAccount({super.key});

  @override
  State<SettingAffAccount> createState() => _SettingAffAccountState();
}

class _SettingAffAccountState extends State<SettingAffAccount> {
  final affAccountCtl = Get.find<AffiliateAccountCtr>();
  bool _prefilled = false;

  void _prefillFrom(Data d) {
    if (_prefilled) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      affAccountCtl.shopNameCtrl.text = d.storeName;
      affAccountCtl.usernameCtrl.text = d.account.userName;
      affAccountCtl.emailCtrl.text = d.account.email;
      affAccountCtl.phoneCtrl.text = d.account.moblie;
      affAccountCtl.cover.value = d.cover;
      affAccountCtl.image.value = d.account.image;

      affAccountCtl.onShopChanged(affAccountCtl.shopNameCtrl.text);
      affAccountCtl.onUsernameChanged(affAccountCtl.usernameCtrl.text);
      affAccountCtl.onEmailChanged(affAccountCtl.emailCtrl.text);
      affAccountCtl.onPhoneChanged(affAccountCtl.phoneCtrl.text);

      _prefilled = true;
    });
  }

  @override
  void dispose() {
    affAccountCtl.clearForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: .4), // แก้จาก withValues
        backgroundColor: Colors.white,
        foregroundColor: themeColorDefault,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
        title: Text(
          'บัญชี',
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF1F1F1F),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          width: double.infinity,
          child: Obx(
            () {
              final _ = (
                affAccountCtl.shop.value,
                affAccountCtl.email.value,
                affAccountCtl.phone.value,
              );
              final ok = affAccountCtl.isValidForUpdate; // ข้าม agreed

              return ElevatedButton(
                onPressed:
                    ok ? () => affAccountCtl.submit(isUpdate: true) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColorDefault,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ).copyWith(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.disabled)) {
                      return themeColorDefault.withValues(alpha: 0.5);
                    }
                    return themeColorDefault;
                  }),
                ),
                child: const Text(
                  'บันทึก',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ),
      body: Obx(() {
        final d = affAccountCtl.profileData.value;
        final c = affAccountCtl.cover.value;
        final i = affAccountCtl.image.value;

        final coverFile = affAccountCtl.coverFile.value;
        final avatarFile = affAccountCtl.avatarFile.value;

        if (d == null) {
          return const Center(child: CircularProgressIndicator());
        }
        _prefillFrom(d);

        return Container(
          color: Colors.grey.shade100,
          child: ListView(
            children: [
              Container(
                color: Colors.white,
                height: 200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Material(
                      color: Colors.white,
                      child: Ink.image(
                        image: (coverFile != null
                                ? FileImage(coverFile)
                                : (c.isNotEmpty
                                    ? NetworkImage(c)
                                    : const AssetImage(
                                        'assets/placeholder/cover.jpg')))
                            as ImageProvider,
                        fit: BoxFit.cover,
                        child: InkWell(
                          onTap: affAccountCtl.pickCover,
                          child: Stack(
                            children: [
                              Container(
                                color: Colors.black.withValues(alpha: .30),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: const Color(0x7F1F1F1F)),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      'แตะเพื่อเปลี่ยนรูปภาพปก',
                                      style: GoogleFonts.ibmPlexSansThai(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: affAccountCtl.pickAvatar,
                        customBorder: const CircleBorder(),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: .30),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: const Color(0xFFF3F4F6),
                              backgroundImage: avatarFile != null
                                  ? FileImage(avatarFile)
                                  : (i.isNotEmpty ? NetworkImage(i) : null)
                                      as ImageProvider<Object>?,
                              child: (avatarFile != null || i.isNotEmpty)
                                  ? null
                                  : const Icon(Icons.person,
                                      size: 48, color: Color(0xFF9CA3AF)),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Material(
                                color: Colors.white,
                                shape: const CircleBorder(),
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(Icons.edit,
                                      size: 22, color: themeColorDefault),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      Column(
                        spacing: 4,
                        children: [
                          ApplyFieldLabel(
                            title: 'ชื่อร้านค้า',
                            requiredMark: true,
                            counterController: affAccountCtl.shopNameCtrl,
                            maxLength: 50,
                          ),
                          ApplyInputBox(
                            controller: affAccountCtl.shopNameCtrl,
                            hint: 'ระบุชื่อร้านค้า',
                            ctl: affAccountCtl,
                            field: ApplyField.shop,
                            onChanged: affAccountCtl.onShopChanged,
                          ),
                        ],
                      ),
                      Column(
                        spacing: 4,
                        children: [
                          ApplyFieldLabel(title: 'อีเมล', requiredMark: true),
                          ApplyInputBox(
                            controller: affAccountCtl.emailCtrl,
                            hint: 'ระบุอีเมล',
                            keyboardType: TextInputType.emailAddress,
                            ctl: affAccountCtl,
                            field: ApplyField.email,
                            onChanged: affAccountCtl.onEmailChanged,
                          ),
                        ],
                      ),
                      Column(
                        spacing: 4,
                        children: [
                          ApplyFieldLabel(
                              title: 'หมายเลขโทรศัพท์', requiredMark: true),
                          ApplyInputBox(
                            controller: affAccountCtl.phoneCtrl,
                            hint: '0XX-XXX-XXXX',
                            keyboardType: TextInputType.phone,
                            ctl: affAccountCtl,
                            field: ApplyField.phone,
                            onChanged: affAccountCtl.onPhoneChanged,
                          ),
                        ],
                      ),
                      Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ApplyFieldLabel(
                            title: 'ชื่อผู้ใช้ (username)',
                            requiredMark: true,
                            counterController: affAccountCtl.usernameCtrl,
                            maxLength: 24,
                          ),
                          ApplyInputBox(
                            controller: affAccountCtl.usernameCtrl,
                            hint: 'ชื่อผู้ใช้งาน',
                            ctl: affAccountCtl,
                            field: ApplyField.username,
                            onChanged: affAccountCtl.onUsernameChanged,
                            originalUsername: d.account.userName,
                          ),
                          Text(
                            'กรุณาตรวจสอบข้อมูลให้ถูกต้องก่อนแก้ไข เนื่องจากชื่อผู้ใช้สามารถแก้ไขได้อีกครั้งภายใน 14 วันถัดไป',
                            style: TextStyle(
                              color: const Color(0xFFB3B1B8),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      // PrettyLinkField(
                      //   url: '$web_path${d.account.userName}',
                      //   label: 'ลิงก์ตัวอย่าง',
                      // )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
