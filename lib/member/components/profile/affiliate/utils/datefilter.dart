import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/datepicker.dart';
import 'package:fridayonline/theme.dart';

typedef OnDateRangeSelected = void Function(String str, String end);

Widget dateFilter({
  required OnDateRangeSelected onSelected,
  String? selectedPeriod,
  DateTime? initialRangeStart,
  DateTime? initialRangeEnd,
  ValueChanged<String>? onPeriodChanged, // <-- เพิ่ม
}) {
  final formatter = DateFormat('yyyy-MM-dd');
  final now = DateTime.now();
  DateTime today(DateTime d) => DateTime(d.year, d.month, d.day);

  final filters = const [
    {'text': 'เมื่อวานนี้', 'period': 'yesterday'},
    {'text': '7 วันล่าสุด', 'period': 'lastweek'},
    {'text': '30 วันล่าสุด', 'period': 'lastmonth'},
    {'text': 'กำหนดเอง', 'period': 'range'},
  ];

  Future<void> handleTap(String period) async {
    final base = today(now);
    onPeriodChanged?.call(period); // <-- แจ้ง period ที่เลือกก่อน

    if (period == 'yesterday') {
      final s = base.subtract(const Duration(days: 1));
      onSelected(formatter.format(s), formatter.format(s));
      return;
    }
    if (period == 'lastweek') {
      final s = base.subtract(const Duration(days: 6));
      onSelected(formatter.format(s), formatter.format(base));
      return;
    }
    if (period == 'lastmonth') {
      final s = base.subtract(const Duration(days: 29));
      onSelected(formatter.format(s), formatter.format(base));
      return;
    }

    // range
    final range = await showRangePickerBottomSheet(
        initialStart:
            initialRangeStart ?? base.subtract(const Duration(days: 30)),
        initialEnd: initialRangeEnd ?? base,
        lastDate: base, // กันอนาคต
        period: period);
    if (range != null) {
      onSelected(range['start']!, range['end']!);
    }
  }

  return Container(
    color: Colors.white,
    child: GridView.count(
      crossAxisCount: 4,
      childAspectRatio: 2.3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: filters.map((f) {
        final text = f['text'] as String;
        final period = f['period'] as String;
        final isSelected = selectedPeriod == period;

        return InkWell(
          onTap: () => handleTap(period),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? themeColorDefault : const Color(0xFFF3F3F4),
                width: 1,
              ),
            ),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.ibmPlexSansThai(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? themeColorDefault : const Color(0xFF1F1F1F),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
