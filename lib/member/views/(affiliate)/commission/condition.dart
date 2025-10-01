import 'package:flutter/material.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.commission.ctr.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Conditions extends StatefulWidget {
  const Conditions({super.key});

  @override
  State<Conditions> createState() => _ConditionsState();
}

class _ConditionsState extends State<Conditions> {
  final affCommissionCtl = Get.find<AffiliateCommissionCtr>();

  @override
  void initState() {
    super.initState();
    affCommissionCtl.getCommissionCondition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: themeColorDefault,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: Get.back,
          ),
          shadowColor: Colors.black.withValues(alpha: 0.4),
          title: Text(
            'รายละเอียดกฎและเงื่อนไข',
            style: GoogleFonts.ibmPlexSansThai(
              color: const Color(0xFF1F1F1F),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        body: Obx(() {
          if (affCommissionCtl.isAffiliateConditionLoading.value) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Text(
                      'กฎและเงื่อนไขการจ่ายค่านายหน้า',
                      style: GoogleFonts.ibmPlexSansThai(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildConditionList(),
                ],
              ),
            ),
          );
        }));
  }
}

Widget _buildConditionList() {
  final affCommissionCtl = Get.find<AffiliateCommissionCtr>();
  final condition = affCommissionCtl.affiliateConditionData;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: Column(
      children: List.generate(condition.length, (index) {
        final item = condition[index];
        final title = item?.key ?? '';
        final values = item?.value ?? [];

        return Padding(
          padding:
              EdgeInsets.only(bottom: index == condition.length - 1 ? 0 : 12),
          child: _ConditionCard(title: title, bullets: values),
        );
      }),
    ),
  );
}

class _ConditionCard extends StatelessWidget {
  final String title;
  final List<String> bullets;

  const _ConditionCard({required this.title, required this.bullets});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            title,
            style: GoogleFonts.ibmPlexSansThai(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5A5A5A)),
          ),
          ...bullets.map((text) => _BulletLine(text: text)),
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  final String text;
  const _BulletLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2, left: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: SizedBox(
              width: 4,
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFF5A5A5A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              // strip leading bullet if present in data
              text.replaceFirst(RegExp(r'^[•\-\u2022]\s*'), ''),
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5A5A5A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
