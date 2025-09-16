import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/product.dart';
import 'package:fridayonline/member/controller/affiliate.ctr.dart';
import 'package:fridayonline/member/models/home/home.content.model.dart';
import 'package:fridayonline/member/utils/cached_image.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:video_player/video_player.dart';

import '../../myreview/myrating.card.dart';

Widget buildHeaderBox() {
  return Container(
    height: 90,
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 4,
      children: [
        SvgPicture.asset(
          'assets/images/affiliate/voucher.svg',
          width: 24,
          height: 24,
        ),
        Text(
          'โค้ดส่วนลด ส่วนประกอบนี้จะแสดงก็ต่อเมื่อมีสินค้าเท่านั้น',
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF8C8A94),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}

Widget buildEmptyBox(String title, String desc, String textBtn) {
  return Container(
    width: double.infinity,
    height: 400,
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
    decoration: BoxDecoration(
        color: Colors.transparent, borderRadius: BorderRadius.circular(12)),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        Column(
          children: [
            Image.asset(
              'assets/images/order/zero_order.png',
              width: 150,
            ),
            Text(title,
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                )),
            Text(
              desc,
              style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
        buildEmptyBoxButton(textBtn)
      ],
    ),
  );
}

/// map `content_type`
Widget buildContentSection(Map<String, dynamic> items) {
  final int contentType = (items['content_type'] ?? 0) as int;
  final List<dynamic> details =
      (items['content_detail'] ?? []) as List<dynamic>;
  if (details.isEmpty) {
    return SizedBox();
  }

  switch (contentType) {
    case 1:
      return _buildType1(details);
    case 2:
      return _buildType2(details);
    case 3:
      return _buildType3(details);
    case 4:
      return _buildType4(details);
    case 5:
      return _buildType5(details);
    default: // Text
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(details.length, (index) {
            var text = details[index];
            return HtmlWidget(
              text.contentName,
            );
          }),
        ],
      );
  }
}

Widget buildProductSection(List<Map<String, dynamic>> items) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final crossAxisCount = (constraints.maxWidth / 180).floor().clamp(2, 6);

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 0.72,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final pMap = items[index];

          // ถ้า ProductContent.fromJson รองรับ snake_case อยู่แล้ว ใช้ได้เลย
          // ถ้าไม่รองรับ ลองแมปคีย์เองก่อนค่อยส่งเข้า model
          final product = ProductContent.fromJson(pMap);

          return ProductItems(
            product: product,
            onTap: () {
              // TODO: เปิดหน้ารายละเอียด/เพิ่มลงตะกร้า ฯลฯ
            },
          );
        },
      );
    },
  );
}

// --- content_type == 1 : Banner
Widget _buildType1(List<dynamic> details) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(details.length, (idx) {
      final Map<String, dynamic> d = details[idx] as Map<String, dynamic>;
      final String image = (d['image'] ?? '') as String? ?? '';
      final String name = (d['content_name'] ?? '') as String? ?? '';
      final bool showName = (d['show_content_name'] ?? false) as bool;

      return Container(
        margin: const EdgeInsets.only(top: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (image.isNotEmpty)
              CacheImageContentShop(
                url: image,
              ),
            if (showName && name.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  name,
                  style: GoogleFonts.ibmPlexSansThai(
                      fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ),
          ],
        ),
      );
    }),
  );
}

// --- content_type == 2 : Carousel
Widget _buildType2(
  List<dynamic> details, {
  void Function(Map<String, dynamic> data)? onTap,
  void Function(Map<String, dynamic> data)? onBeforeTap,
  double aspectRatio = 1,
  BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
}) {
  final ValueNotifier<int> current = ValueNotifier<int>(0);

  return Stack(
    children: [
      Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        clipBehavior: Clip.antiAlias,
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: borderRadius),
        child: CarouselSlider.builder(
          itemCount: details.length,
          itemBuilder: (context, index, _) {
            final Map<String, dynamic> data =
                (details[index] as Map).cast<String, dynamic>();
            final int actionType = (data['action_type'] as int?) ??
                (data['actionType'] as int? ?? 0);
            final String url = data['image'];

            return InkWell(
              onTap: () {
                if (actionType != 1) onBeforeTap?.call(data);
                onTap?.call(data);
              },
              child: CacheImageContentShop(url: url),
            );
          },
          options: CarouselOptions(
            aspectRatio: aspectRatio,
            viewportFraction: 1,
            autoPlay: details.length > 1,
            onPageChanged: (index, reason) => current.value = index,
          ),
        ),
      ),
      Positioned(
        bottom: 16,
        left: 0,
        right: 0,
        child: ValueListenableBuilder<int>(
          valueListenable: current,
          builder: (_, value, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(details.length, (i) {
                final active = value == i;
                return GestureDetector(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: (active ? Colors.white : Colors.grey.shade400)
                          .withValues(alpha: active ? 0.9 : 0.5),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    ],
  );
}

// --- content_type == 3 : Product List
Widget _buildType3(List<dynamic> details) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(details.length, (idx) {
      final Map<String, dynamic> d = details[idx] as Map<String, dynamic>;
      final bool showName = (d['show_content_name'] ?? false) as bool;
      final String name = (d['content_name'] as String?) ?? '';
      final List<dynamic> products =
          (d['product_content'] as List<dynamic>?) ?? [];

      if (products.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showName && name.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                name,
                style: GoogleFonts.ibmPlexSansThai(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 0.72,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final pMap = products[index] as Map<String, dynamic>;
              final product = ProductContent.fromJson(pMap);

              return ProductItems(
                product: product,
                onTap: () {},
              );
            },
          ),
        ],
      );
    }),
  );
}

// --- content_type == 4 : Category List
Widget _buildType4(
  List<dynamic> details, {
  void Function(Map<String, dynamic> data)? onTap,
  void Function(Map<String, dynamic> data)? onBeforeTap,
  double tileSize = 100,
  double spacing = 8,
  BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8)),
  BoxFit fit = BoxFit.cover,
}) {
  if (details.isEmpty) return const SizedBox.shrink();

  return Builder(
    builder: (context) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(details.length, (index) {
            final Map<String, dynamic> item =
                (details[index] as Map).cast<String, dynamic>();
            final int actionType = (item['action_type'] as int?) ??
                (item['actionType'] as int? ?? 0);
            final String url = item['image'];

            return Padding(
              padding: EdgeInsets.only(right: spacing),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  if (actionType != 1) onBeforeTap?.call(item);
                  onTap?.call(item);
                },
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: SizedBox(
                    width: tileSize,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CacheImageContentShop(
                        url: url,
                        fit: fit,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    },
  );
}

// --- content_type == 5 : วิดีโอ
Widget _buildType5(List<dynamic> details) {
  final affiliateCtl = Get.find<AffiliateController>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: List.generate(details.length, (idx) {
      final Map<String, dynamic> d = details[idx] as Map<String, dynamic>;
      final String name = (d['content_name'] ?? '') as String? ?? '';
      final String videoUrl = (d['image'] ?? '') as String? ?? '';

      return Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: FutureBuilder<VideoPlayerController>(
          future: setVideoContent(videoUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: const SizedBox.shrink(),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const SizedBox.shrink();
            }

            final controller = snapshot.data!;
            final aspect = controller.value.isInitialized
                ? controller.value.aspectRatio
                : (16 / 9);

            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: aspect,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    // แตะเล่น/หยุด
                    InkWell(
                      onTap: () {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                      },
                      child: VideoPlayer(controller),
                    ),

                    // ปุ่มควบคุมมุมขวาล่าง
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          constraints: const BoxConstraints(maxWidth: 28),
                          icon: const Icon(Icons.fullscreen),
                          color: Colors.white,
                          onPressed: () {
                            // ❗ ใช้ videoUrl จาก d ของ item ปัจจุบัน
                            Get.to(() =>
                                FullScreenVideoPlayer(videoUrl: videoUrl));
                          },
                        ),
                        // ถ้าใช้ GetX สำหรับเก็บ volume เหมือนเดิม
                        Obx(() {
                          final isMuted = affiliateCtl.volume.value == 0;
                          return IconButton(
                            icon: Icon(
                              isMuted ? Icons.volume_off : Icons.volume_down,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              final nowMuted = controller.value.volume != 0;
                              controller.setVolume(nowMuted ? 0 : 1);
                              affiliateCtl.volume.value =
                                  controller.value.volume;
                            },
                          );
                        }),
                      ],
                    ),

                    // แสดงชื่อคลิป (ถ้ามี)
                    if (name.isNotEmpty)
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            name,
                            style: GoogleFonts.ibmPlexSansThai(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }),
  );
}

Widget buildEmptyBoxButton(String text) {
  return AnimatedPadding(
    duration: const Duration(milliseconds: 150),
    curve: Curves.easeOut,
    padding: EdgeInsets.only(bottom: 4),
    child: SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          painter: DashedRRectPainter(),
          child: Container(
            width: 175,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Color(0xFF5A5A5A)),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: GoogleFonts.ibmPlexSansThai(
                    color: const Color(0xFF5A5A5A),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buildBottomButton(String text) {
  return AnimatedPadding(
    duration: const Duration(milliseconds: 150),
    curve: Curves.easeOut,
    padding: EdgeInsets.only(bottom: 8),
    child: SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          painter: DashedRRectPainter(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 6),
                Text(
                  text,
                  style: GoogleFonts.ibmPlexSansThai(
                    color: const Color(0xFF5A5A5A),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class DashedRRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12), // 👈 กำหนด radius มุมโค้ง
    );

    final paint = Paint()
      ..color = themeColorDefault
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // ทำเส้นประด้วย dashPath
    final dashedPath = dashPath(
      Path()..addRRect(rrect),
      dashArray: CircularIntervalList<double>([6, 4]), // [เส้น, ช่องว่าง]
    );

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Map<String, VideoPlayerController> videoControllers = {};

Future<VideoPlayerController> setVideoContent(String videoUrl) async {
  if (videoControllers.containsKey(videoUrl)) {
    return videoControllers[videoUrl]!;
  }

  VideoPlayerController videoCtr = VideoPlayerController.networkUrl(
    Uri.parse(videoUrl),
  );

  await videoCtr.initialize();
  videoCtr.setVolume(0);
  videoCtr.play();

  videoControllers[videoUrl] = videoCtr;

  return videoCtr;
}
