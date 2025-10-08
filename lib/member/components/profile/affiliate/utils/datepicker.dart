import 'package:flutter/material.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

/// Opens a month or date-range picker.
/// - period == 'range'  -> bottom sheet (day range) แบบเดิม
/// - period != 'range'  -> month picker (เลือก "เดือนเดียว"), คืนค่าช่วงทั้งเดือน
Future<Map<String, String>?> showRangePickerBottomSheet({
  DateTime? initialStart,
  DateTime? initialEnd,
  DateTime? firstDate,
  DateTime? lastDate,
  required String period,
}) async {
  final fmt = DateFormat('yyyy-MM-dd');
  final now = DateTime.now();

  final DateTime first = firstDate ?? DateTime(now.year - 5, 1, 1);
  final DateTime last = lastDate ?? DateTime(now.year, now.month, now.day);

  if (period == 'month') {
    final init = initialStart ?? DateTime(last.year, last.month, 1);

    final picked = await showMonthPicker(
      context: Get.context!,
      initialDate: init.isAfter(last) ? last : init,
      firstDate: first,
      lastDate: last,
      monthStylePredicate: (date) => null,
      monthPickerDialogSettings: MonthPickerDialogSettings(
        dialogSettings: const PickerDialogSettings(
          dialogRoundedCornersRadius: 16,
        ),
        headerSettings: PickerHeaderSettings(
          headerCurrentPageTextStyle: GoogleFonts.ibmPlexSansThai(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          headerSelectedIntervalTextStyle: GoogleFonts.ibmPlexSansThai(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        dateButtonsSettings: PickerDateButtonsSettings(
          selectedMonthBackgroundColor: themeColorDefault,
          selectedMonthTextColor: Colors.white,
          unselectedMonthsTextColor: const Color(0xFF17171B),
          monthTextStyle: GoogleFonts.ibmPlexSansThai(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          yearTextStyle: GoogleFonts.ibmPlexSansThai(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    if (picked == null) return null;

    final start = DateTime(picked.year, picked.month, 1);
    final endOfMonth = DateTime(picked.year, picked.month + 1, 0);
    final end = endOfMonth.isAfter(last) ? last : endOfMonth;

    return {
      "start": fmt.format(start),
      "end": fmt.format(end),
    };
  }

  final List<DateTime?> initial = [initialStart, initialEnd];

  return Get.bottomSheet<Map<String, String>?>(
    _RangePickerSheet(
      initialValues: initial,
      firstDate: first,
      lastDate: last,
      formatter: fmt,
      period: period,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}

class _RangePickerSheet extends StatefulWidget {
  const _RangePickerSheet({
    super.key,
    required this.initialValues,
    required this.firstDate,
    required this.lastDate,
    required this.formatter,
    required this.period,
  });

  final List<DateTime?> initialValues;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateFormat formatter;
  final String period;

  @override
  State<_RangePickerSheet> createState() => _RangePickerSheetState();
}

class _RangePickerSheetState extends State<_RangePickerSheet> {
  late List<DateTime?> _values;

  @override
  void initState() {
    super.initState();
    _values = [
      if (widget.initialValues.isNotEmpty) widget.initialValues[0] else null,
      if (widget.initialValues.length > 1) widget.initialValues[1] else null,
    ];
  }

  bool get _hasStart => _values.isNotEmpty && _values[0] != null;
  bool get _hasEnd =>
      _values.length > 1 && _values[1] != null && _values[0] != null;

  void _confirm() {
    final start = _values[0];
    final end = _hasEnd ? _values[1] : _values[0];
    if (start == null) return;
    Get.back(result: {
      "start": widget.formatter.format(start),
      "end": widget.formatter.format(end!),
    });
  }

  List<DateTime?> get initialValues =>
      _values.length > 2 ? _values.take(2).toList() : _values;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final lastSelectable = DateTime(today.year, today.month, today.day);

    final config = CalendarDatePicker2Config(
      calendarViewMode: CalendarDatePicker2Mode.day,
      calendarType: CalendarDatePicker2Type.range,
      firstDate: widget.firstDate,
      lastDate: lastSelectable,
      centerAlignModePicker: true,
      lastMonthIcon: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Icon(Icons.chevron_left)),
      ),
      nextMonthIcon: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Icon(Icons.chevron_right)),
      ),
      monthTextStyle: GoogleFonts.ibmPlexSansThai(
        color: const Color(0xFF17171B),
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      selectedMonthTextStyle: GoogleFonts.ibmPlexSansThai(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      yearTextStyle: GoogleFonts.ibmPlexSansThai(
        color: const Color(0xFF17171B),
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      selectedYearTextStyle: GoogleFonts.ibmPlexSansThai(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      selectedDayHighlightColor: themeColorDefault,
      weekdayLabelTextStyle: GoogleFonts.ibmPlexSansThai(
        color: const Color(0xFFA1A1AA),
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      selectedDayTextStyle: GoogleFonts.ibmPlexSansThai(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      dayTextStyle: GoogleFonts.ibmPlexSansThai(
        color: const Color(0xFF17171B),
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(color: Color(0xFFF3F3F4), width: 1)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'เลือกช่วงเวลา',
                      style: GoogleFonts.ibmPlexSansThai(
                        color: const Color(0xFF1F1F1F),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'ปิด',
                    onPressed: () => Get.back(result: null),
                    icon: const Icon(Icons.close_rounded,
                        size: 24, color: Colors.black87),
                  ),
                ],
              ),
            ),
            CalendarDatePicker2(
              config: config,
              value: initialValues,
              onValueChanged: (vals) => setState(() => _values = vals),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: null),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        side: const BorderSide(color: Color(0xFF5A5A5A)),
                        foregroundColor: themeColorDefault,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'ยกเลิก',
                        style: GoogleFonts.ibmPlexSansThai(
                          color: const Color(0xFF5A5A5A),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _hasStart ? _confirm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColorDefault,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4,
                        children: [
                          Text(
                            'ตกลง',
                            style: GoogleFonts.ibmPlexSansThai(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
