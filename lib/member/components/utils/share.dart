import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fridayonline/member/components/utils/status.dialog.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// เรียกใช้งาน:
// await shareDialog(shareUrl: 'https://yourshop.com/mystore', shareText: 'ดูร้านของฉันสิ');

Future<void> shareDialog({
  required String shareTitle,
  required String shareUrl,
  String? shareText,
  AffiliateProduct? product,
}) async {
  final encodedUrl = Uri.encodeComponent(shareUrl);
  final encodedText = Uri.encodeComponent(shareText ?? '');

  return Get.bottomSheet<void>(
    Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 280,
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.4, color: Colors.grey.shade300),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        shareTitle,
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F1F1F),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'ปิด',
                      onPressed: () => Get.back(result: null),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // SOCIAL GRID
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: .85,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: [
                      _SocialTile(
                        label: 'LINE',
                        color: const Color(0xFF06C755),
                        icon: 'assets/images/affiliate/share_line.svg',
                        onTap: () => _tryLaunch([
                          'line://msg/text/${encodedText.isNotEmpty ? '$encodedText%20' : ''}$encodedUrl',
                          'https://line.me/R/msg/text/?${encodedText.isNotEmpty ? '$encodedText%20' : ''}$encodedUrl',
                        ]),
                      ),
                      _SocialTile(
                        label: 'Facebook',
                        color: const Color(0xFF1877F2),
                        icon: 'assets/images/affiliate/share_facebook.svg',
                        onTap: () => _tryLaunch([
                          'fb://facewebmodal/f?href=https://www.facebook.com/sharer/sharer.php?u=$encodedUrl',
                          'https://www.facebook.com/sharer/sharer.php?u=$encodedUrl',
                        ]),
                      ),
                      _SocialTile(
                        label: 'Messenger',
                        color: const Color(0xFF00B2FF),
                        icon: 'assets/images/affiliate/share_messenger.svg',
                        onTap: () => _tryLaunch([
                          'fb-messenger://share?link=$encodedUrl',
                          'https://www.facebook.com/dialog/send?link=$encodedUrl',
                        ]),
                      ),
                      _SocialTile(
                        label: 'X',
                        color: Colors.black,
                        icon: 'assets/images/affiliate/share_x.svg',
                        onTap: () => _tryLaunch([
                          'twitter://post?message=${encodedText.isNotEmpty ? '$encodedText%20' : ''}$encodedUrl',
                          'https://twitter.com/intent/tweet?text=${encodedText.isNotEmpty ? '$encodedText%20' : ''}$encodedUrl',
                        ]),
                      ),
                      _SocialTile(
                        label: 'คัดลอกลิงก์',
                        color: const Color(0xFF6B7280),
                        icon: 'assets/images/affiliate/share_link.svg',
                        onTap: () async {
                          await Clipboard.setData(
                              ClipboardData(text: shareUrl));
                          await showAffDialog(true, 'คัดลอกลิงก์สำเร็จ', '',
                              timeout: Duration(milliseconds: 500));
                        },
                      ),
                      _SocialTile(
                        label: 'อื่นๆ',
                        color: const Color(0xFF1F1F1F),
                        icon: 'assets/images/affiliate/share_more.svg',
                        onTap: () {
                          final text = (shareText ?? '').isEmpty
                              ? shareUrl
                              : '${shareText!}\n$shareUrl';
                          SharePlus.instance.share(ShareParams(text: text));
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .35),
    enableDrag: true,
  );
}

// ---------- helpers ----------

Future<void> _tryLaunch(List<String> urls) async {
  for (final u in urls) {
    final uri = Uri.parse(u);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
  }
  Get.snackbar('เปิดไม่สำเร็จ', 'อาจยังไม่ได้ติดตั้งแอปปลายทาง',
      snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
}

class _SocialTile extends StatelessWidget {
  final String label;
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 45,
            height: 45,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.ibmPlexSansThai(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1F1F1F),
            ),
          ),
        ],
      ),
    );
  }
}
