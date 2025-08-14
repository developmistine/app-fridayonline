import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

var maskFormatterRepcode = MaskTextInputFormatter(
    mask: "####-#####-#", type: MaskAutoCompletionType.lazy);

var maskFormatterRepcodeLead =
    MaskTextInputFormatter(mask: "####", type: MaskAutoCompletionType.lazy);

var maskFormatterPhone = MaskTextInputFormatter(
    mask: "###-###-####", type: MaskAutoCompletionType.lazy);

var maskFormatterTax = MaskTextInputFormatter(
    mask: "#-####-#####-##-#", type: MaskAutoCompletionType.lazy);

String formatPhoneNumber(String phoneNumber) {
  final formattedNumber = StringBuffer();
  for (var i = 0; i < phoneNumber.length; i++) {
    if (i == 3 || i == 6) {
      formattedNumber.write('-');
    }
    formattedNumber.write(phoneNumber[i]);
  }
  return formattedNumber.toString();
}

String formatTaxNumber(String taxNumber) {
  final formattedNumber = StringBuffer();
  for (var i = 0; i < taxNumber.length; i++) {
    if (i == 1 || i == 6 || i == 12 || i == 15) {
      formattedNumber.write('-');
    }
    formattedNumber.write(taxNumber[i]);
  }
  return formattedNumber.toString();
}

String formatTelHidden(String phoneNumber) {
  if (phoneNumber.length < 10) {
    return phoneNumber; // Handle short input gracefully
  }

  final maskedPart = '*' * 6;
  final visiblePart = phoneNumber.substring(phoneNumber.length - 4);

  return '$maskedPart$visiblePart';
}

String formatBirthdayHidden(String date) {
  date = date.replaceRange(10, null, "");
  var formatedDate =
      "${date.split('-').last}-${date.split('-')[1]}-${date.split('-').first}";

  formatedDate = formatedDate.replaceAll('-', '/');
  final maskedPart = '*' * 2;
  final visiblePart = formatedDate.substring(2, 8);

  return '$maskedPart$visiblePart$maskedPart';
}

String formatEmailHidden(String date) {
  if (date.length < 7) {
    return date;
  }
  final maskedPart = '*' * 6;
  final visiblePart = date.substring(date.length - 7);

  return '$maskedPart$visiblePart';
}

String formatCamp(String input) {
  if (input.length == 6) {
    String firstPart = input.substring(0, 2);
    String secondPart = input.substring(2);
    return "$firstPart/$secondPart";
  } else {
    return input;
  }
}

String formatCampYear(String input) {
  if (input.length == 6) {
    String firstPart = input.substring(4);
    String secondPart = input.substring(0, 4);
    return "$firstPart/$secondPart";
  } else {
    return input;
  }
}

String formatYearCamp(String input) {
  if (input.length == 6) {
    String firstPart = input.substring(2, 6);
    String secondPart = input.substring(0, 2);
    return "$firstPart$secondPart";
  } else {
    return input;
  }
}
