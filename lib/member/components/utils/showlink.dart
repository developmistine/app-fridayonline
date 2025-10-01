import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fridayonline/member/components/utils/status.dialog.dart';

class PrettyLinkField extends StatelessWidget {
  final String url;
  final String label;
  final EdgeInsetsGeometry margin;
  final double height;

  const PrettyLinkField({
    super.key,
    required this.url,
    this.label = 'ลิงก์ตัวอย่าง',
    this.margin = const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
    this.height = 48,
  });

  Uri _asUri(String u) {
    final hasScheme = u.startsWith('http://') || u.startsWith('https://');
    return Uri.parse(hasScheme ? u : 'https://$u');
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: url));
    await showAffDialog(true, 'คัดลอกลิงก์สำเร็จ', '',
        timeout: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E2E4), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _copy(context),
          child: SizedBox(
            height: height,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w500,
                          )),
                      Text(
                        url,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Tooltip(
                  message: 'คัดลอก',
                  child: IconButton(
                    onPressed: () => _copy(context),
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
