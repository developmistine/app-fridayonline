import 'dart:convert';
import 'dart:developer';

void printWhite(msg) {
  log('\x1B[37m$msg\x1B[0m');
}

void printJSON(Object msg) {
  final jsonString = const JsonEncoder.withIndent('  ').convert(msg);

  const resetColor = '\x1B[0m';
  const keyColor = '\x1B[33m'; // สีเหลืองสำหรับ key
  const valueColor = '\x1B[32m'; // สีเขียวสำหรับ value

  final coloredJson = jsonString.replaceAllMapped(
    RegExp(r'("(.*?)")(\s*:\s*)(.*?)(,?)$',
        multiLine: true), // จับ key, separator (:), และ value
    (match) {
      final key = match.group(1); // Key เช่น "shop_id"
      final separator = match.group(3); // Separator เช่น ":"
      final value = match.group(4); // Value เช่น 23001
      final trailingComma = match.group(5) ?? ''; // Trailing comma เช่น ','

      return '$keyColor$key$resetColor'
          '$separator'
          '$valueColor$value$resetColor'
          '$trailingComma';
    },
  );

  log(coloredJson);
}
