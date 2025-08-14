import 'package:fridayonline/member/models/chat/recieve.message.model.dart';
import 'package:intl/intl.dart';

String getCurrentTime() {
  final now = DateTime.now();
  final hours = now.hour.toString().padLeft(2, '0');
  final minutes = now.minute.toString().padLeft(2, '0');
  return '$hours:$minutes';
}

String getFullCurrentTime() {
  final now = DateTime.now();
  final year = now.year.toString().padLeft(2, '0');
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  final hours = now.hour.toString().padLeft(2, '0');
  final minutes = now.minute.toString().padLeft(2, '0');
  final second = now.second.toString().padLeft(2, '0');
  return '$year-$month-$day $hours:$minutes:$second';
}

String formatChatTime(ReciveMessage msg) {
  var date = DateTime.parse(msg.messageData.sendDate);
  var hours = date.hour.toString().padLeft(2, '0');
  var minutes = date.minute.toString().padLeft(2, '0');
  return "$hours:$minutes";
}

String formatContactChatTime(String dateTimeString) {
  if (dateTimeString == "") {
    return "";
  }
  final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ssZ');
  final dateTime = inputFormat.parse(dateTimeString);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (dateOnly == today) {
    // เป็นวันปัจจุบัน แสดงแค่เวลา HH:mm
    return DateFormat('HH:mm').format(dateTime);
  } else if (dateOnly == yesterday) {
    // เป็นวันก่อนหน้า แสดง "เมื่อวาน"
    return 'เมื่อวาน';
  } else {
    // วันอื่น ๆ แสดงเป็น dd/MM
    return DateFormat('dd/MM').format(dateTime);
  }
}

String formatChatDateHeader(String rawDate) {
  final msgDate = DateTime.parse(rawDate);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateOnly = DateTime(msgDate.year, msgDate.month, msgDate.day);

  if (dateOnly == today) {
    return 'วันนี้';
  } else if (dateOnly == yesterday) {
    return 'เมื่อวาน';
  } else {
    // return DateFormat('d MMM yyyy', 'th_TH')
    //     .format(msgDate); // เช่น 21 พ.ค. 2025
    return DateFormat('d MMM', 'th_TH').format(msgDate); // เช่น 21 พ.ค. 2025
  }
}
