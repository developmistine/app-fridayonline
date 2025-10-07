import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fridayonline/member/components/utils/status.dialog.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:fridayonline/member/models/showproduct/product.sku.model.dart'
    hide Image;
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/member/views/(showproduct)/show.sku.view.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareProduct {
  final int productId;
  final String? title;
  final String? image;
  final num? discount;
  final num? price;
  final num? priceBfDiscount;
  final String? commission;

  ShareProduct({
    required this.productId,
    this.title,
    this.image,
    this.discount,
    this.price,
    this.priceBfDiscount,
    this.commission,
  });
}

Future<void> shareDialog({
  required String shareType,
  required String shareTitle,
  ShareProduct? product,
  int? categoryId,
  ProductPrice? productPrices,
}) async {
  final affiliateAccountCtr = Get.find<AffiliateAccountCtr>();
  String encodedUrl = '';
  String encodedText = '';

  Future<bool> prepareShare(String channel) async {
    try {
      affiliateAccountCtr.isLoadingShareData.value = true;

      final res = await affiliateAccountCtr.getShareData(
        shareType: shareType,
        productId: product?.productId ?? 0,
        channel: channel,
        categoryId: categoryId,
      );

      if (res == null) return false;

      encodedUrl = Uri.encodeComponent(res.shortUrl);
      encodedText = Uri.encodeComponent(res.shareMessage);

      return true;
    } catch (e) {
      Get.snackbar('เกิดข้อผิดพลาด', 'เตรียมข้อมูลแชร์ไม่สำเร็จ',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12));
      return false;
    } finally {
      affiliateAccountCtr.isLoadingShareData.value = false;
    }
  }

  return Get.bottomSheet<void>(
    Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height:
              product != null && product.image != null && product.title != null
                  ? 380
                  : 280,
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
              if (product != null &&
                  product.image != null &&
                  product.title != null)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(29, 0, 0, 0),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                alignment: Alignment.center,
                                child: Image.network(
                                  product.image!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.ibmPlexSansThai(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1F1F1F),
                                    ),
                                  ),
                                  if (productPrices != null)
                                    ...productPriceMain(
                                        productPrices: productPrices,
                                        showPercent: false,
                                        isShare: true)
                                  else if (product.discount != null &&
                                      product.discount! > 0)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '฿${myFormat.format(product.price)}',
                                          style: TextStyle(
                                            color: Colors.deepOrange.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          '฿${myFormat.format(product.priceBfDiscount)}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 11,
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          color: Colors.red.shade50,
                                          child: Text(
                                            '-${myFormat.format(product.discount)}%',
                                            style: GoogleFonts.ibmPlexSansThai(
                                              color: Colors.deepOrange,
                                              fontSize: 11,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  else
                                    Text(
                                      '฿${myFormat.format(product.priceBfDiscount)}',
                                      style: TextStyle(
                                        color: Colors.deepOrange.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (product.commission?.isNotEmpty ?? false)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: themeColorDefault,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                product.commission ?? '',
                                style: GoogleFonts.ibmPlexSansThai(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

              // SOCIAL GRID
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Obx(() {
                      final isLoading =
                          affiliateAccountCtr.isLoadingShareData.value;
                      return Stack(
                        children: [
                          GridView.count(
                            crossAxisCount: 4,
                            childAspectRatio: .85,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            children: [
                              _SocialTile(
                                label: 'LINE',
                                color: const Color(0xFF06C755),
                                icon: 'assets/images/affiliate/share_line.svg',
                                enabled: !isLoading,
                                onTap: () async {
                                  if (await prepareShare('line')) {
                                    await _tryLaunch([
                                      'line://msg/text/${encodedText.isNotEmpty ? '$encodedText%20' : ''}$encodedUrl',
                                      'https://line.me/R/msg/text/?${encodedText.isNotEmpty ? '$encodedText%20' : ''}$encodedUrl',
                                    ]);
                                  }
                                },
                              ),
                              _SocialTile(
                                label: 'Facebook',
                                color: const Color(0xFF1877F2),
                                icon:
                                    'assets/images/affiliate/share_facebook.svg',
                                enabled: !isLoading,
                                onTap: () async {
                                  if (await prepareShare('facebook')) {
                                    await _tryLaunch([
                                      'fb://facewebmodal/f?href=https://www.facebook.com/sharer/sharer.php?u=$encodedUrl',
                                      'https://www.facebook.com/sharer/sharer.php?u=$encodedUrl',
                                    ]);
                                  }
                                },
                              ),
                              _SocialTile(
                                label: 'Messenger',
                                color: const Color(0xFF00B2FF),
                                icon:
                                    'assets/images/affiliate/share_messenger.svg',
                                enabled: !isLoading,
                                onTap: () async {
                                  if (await prepareShare('messenger')) {
                                    await _tryLaunch([
                                      'fb-messenger://share?link=$encodedUrl',
                                      'https://www.facebook.com/dialog/send?link=$encodedUrl',
                                    ]);
                                  }
                                },
                              ),
                              _SocialTile(
                                label: 'X',
                                color: Colors.black,
                                icon: 'assets/images/affiliate/share_x.svg',
                                enabled: !isLoading,
                                onTap: () async {
                                  if (await prepareShare('twitter')) {
                                    await _tryLaunch([
                                      'twitter://post?message=${encodedText.isNotEmpty ? '$encodedText%20' : ''}$encodedUrl',
                                      'https://twitter.com/intent/tweet?text=${encodedText.isNotEmpty ? '$encodedText%20' : ''}$encodedUrl',
                                    ]);
                                  }
                                },
                              ),
                              _SocialTile(
                                label: 'คัดลอกลิงก์',
                                color: const Color(0xFF6B7280),
                                icon: 'assets/images/affiliate/share_link.svg',
                                enabled: !isLoading,
                                onTap: () async {
                                  if (await prepareShare('direct_link')) {
                                    final decoded =
                                        Uri.decodeComponent(encodedUrl);
                                    await Clipboard.setData(
                                        ClipboardData(text: decoded));
                                    await showAffDialog(
                                        true, 'คัดลอกลิงก์สำเร็จ', '',
                                        timeout:
                                            const Duration(milliseconds: 500));
                                  }
                                },
                              ),
                              _SocialTile(
                                label: 'อื่นๆ',
                                color: const Color(0xFF1F1F1F),
                                icon: 'assets/images/affiliate/share_more.svg',
                                enabled: !isLoading,
                                onTap: () async {
                                  if (await prepareShare('other')) {
                                    final text = encodedText.isEmpty
                                        ? Uri.decodeComponent(encodedUrl)
                                        : '${Uri.decodeComponent(encodedText)}\n${Uri.decodeComponent(encodedUrl)}';
                                    SharePlus.instance
                                        .share(ShareParams(text: text));
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    })),
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
  final bool enabled;

  const _SocialTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: enabled ? onTap : null,
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
