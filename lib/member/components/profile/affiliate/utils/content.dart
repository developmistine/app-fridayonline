import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.category.add.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.category.show.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.content.add.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.product.add.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/product.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.product.ctr.dart';
import 'package:fridayonline/member/controller/category.ctr.dart';
import 'package:fridayonline/member/models/home/home.content.model.dart';
import 'package:fridayonline/member/utils/cached_image.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:video_player/video_player.dart';
import '../../myreview/myrating.card.dart';

final affContentCtl = Get.find<AffiliateContentCtr>();
final affProductCtl = Get.find<AffiliateProductCtr>();

final CategoryCtr categoryCtr = Get.find();

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

Widget buildEmptyBox(String title, String desc, String textBtn, int tabIndex) {
  return Container(
    width: double.infinity,
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
        buildEmptyBoxButton(textBtn, tabIndex)
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

          final product = ProductContent.fromJson(pMap);

          return productItem(
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

Widget buildCategorySection(Map<String, dynamic> items) {
  final List<dynamic> details =
      (items['content_detail'] ?? []) as List<dynamic>;
  if (details.isEmpty) {
    return const SizedBox(); // หรือ Empty state เล็ก ๆ
  }

  final pMap = (details[0] as Map).cast<String, dynamic>();
  final List<dynamic> products =
      (pMap['product_content'] as List<dynamic>?) ?? [];
  final String catName = (pMap['content_name'] as String?)?.trim() ?? '';
  final String? image1 = products.isNotEmpty ? products[0]['image'] : null;
  final String? image2 = products.length > 1 ? products[1]['image'] : null;
  final String? image3 = products.length > 2 ? products[2]['image'] : null;
  final int total = products.length;

  return InkWell(
    onTap: () {
      Get.to(() => ShopShowCategory(catName, products));
    },
    child: Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          width: 0.2,
          color: Color.fromARGB(255, 179, 179, 179),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Row(
              children: [
                Expanded(flex: 2, child: _thumb(image1)),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: _thumb(image2)),
                      Expanded(child: _thumb(image3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  catName.isEmpty ? 'ไม่ระบุหมวดหมู่' : catName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                Text(
                  'สินค้า $total รายการ',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
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

Widget _thumb(String? url) {
  final String? u = url?.trim();
  if (u == null || u.isEmpty) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
      ),
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined,
            size: 20, color: Color(0xFF9CA3AF)),
      ),
    );
  }

  return DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFB),
      border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
    ),
    child: Image.network(
      u,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.broken_image_outlined,
            size: 20, color: Color(0xFF9CA3AF)),
      ),
    ),
  );
}

Widget buildProductSort() {
  return Obx(() {
    final isLoading = categoryCtr.isLoadingSort.value;
    final currentTab = affProductCtl.tabSort.value;
    final isPriceUp = affProductCtl.isPriceUp.value;

    if (isLoading) return const SizedBox();

    return Container(
      color: Colors.white,
      width: Get.width,
      child: Row(
        children: List.generate(categoryCtr.sortData!.data.length, (index) {
          final sort = categoryCtr.sortData!.data[index];
          final bool isActive = currentTab == index;

          return Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                InkWell(
                  onTap: () => affProductCtl.setSortTab(
                    index,
                    categoryCtr.sortData!.data.length - 1, // priceIndex
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isActive
                              ? themeColorDefault
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sort.text,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 14,
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.normal,
                            color: isActive
                                ? themeColorDefault
                                : Colors.grey.shade700,
                          ),
                        ),
                        if (index == categoryCtr.sortData!.data.length - 1 &&
                            isActive)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              isPriceUp
                                  ? Icons.arrow_upward_outlined
                                  : Icons.arrow_downward_outlined,
                              size: 12,
                              color: themeColorDefault,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (index != categoryCtr.sortData!.data.length - 1)
                  IgnorePointer(
                    child: Text("|",
                        style: TextStyle(color: Colors.grey.shade300)),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  });
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

              return productItem(
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
                          final isMuted = affContentCtl.volume.value == 0;
                          return IconButton(
                            icon: Icon(
                              isMuted ? Icons.volume_off : Icons.volume_down,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              final nowMuted = controller.value.volume != 0;
                              controller.setVolume(nowMuted ? 0 : 1);
                              affContentCtl.volume.value =
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

Widget buildEmptyBoxButton(String text, int tabIndex) {
  return AnimatedPadding(
    duration: const Duration(milliseconds: 150),
    curve: Curves.easeOut,
    padding: EdgeInsets.only(bottom: 4),
    child: SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: InkWell(
        onTap: () {
          buildAddSection(tabIndex);
        },
        borderRadius: BorderRadius.circular(6),
        child: CustomPaint(
          painter: DashedRRectPainter(),
          child: Container(
            width: 175,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: themeColorDefault),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: GoogleFonts.ibmPlexSansThai(
                    color: themeColorDefault,
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

Widget buildBottomButton(String text, VoidCallback onPressed) {
  return AnimatedPadding(
    duration: const Duration(milliseconds: 150),
    curve: Curves.easeOut,
    padding: EdgeInsets.only(bottom: 8),
    child: SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: InkWell(
        onTap: onPressed,
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

// edit
String _renderContentType(int contentType) {
  switch (contentType) {
    case 1:
      return 'Banner';
    case 2:
      return 'Carousel';
    case 3:
      return 'Product';
    case 4:
      return 'Gallery';
    case 5:
      return 'Video';
    default: // Text
      return '';
  }
}

Widget _typeChip(int type) {
  final label = _renderContentType(type);
  final color = switch (type) {
    1 => Colors.indigo,
    2 => Colors.teal,
    3 => Colors.orange,
    4 => Colors.purple,
    5 => Colors.red,
    _ => Colors.grey,
  };
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withValues(alpha: .25)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    ),
  );
}

Widget cardBottom({
  required List<dynamic> details,
  VoidCallback? onEdit,
  VoidCallback? onDelete,
  VoidCallback? onMoveUp,
  VoidCallback? onHide,
}) {
  final btnStyle = OutlinedButton.styleFrom(
    side: BorderSide(color: Colors.grey.shade300),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    padding: const EdgeInsets.all(4),
    foregroundColor: Colors.black87,
    backgroundColor: Colors.white,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.compact,
  );

  Widget ob(IconData icon, String tooltip, VoidCallback? onPressed) {
    return Tooltip(
      message: tooltip,
      padding: EdgeInsets.zero,
      child: OutlinedButton(
        onPressed: onPressed,
        style: btnStyle,
        child: Icon(
          icon,
          size: 18,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  return Align(
    alignment: Alignment.centerRight,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        if (onDelete != null) ob(Icons.delete_outline_rounded, 'ลบ', onDelete),
        if (onHide != null) ob(Icons.remove_red_eye_outlined, 'ซ่อน', onHide),
        if (onEdit != null) ob(Icons.edit_rounded, 'แก้ไข', onEdit),
        if (onMoveUp != null)
          ob(Icons.arrow_upward_rounded, 'เลื่อนขึ้น', onMoveUp),
      ],
    ),
  );
}

Widget _cardHeader({
  required int contentType,
  required List<dynamic> details,
}) {
  String? title;
  if (details.isNotEmpty) {
    final d = (details.first as Map<String, dynamic>);
    title = (d['content_name'] as String?)?.trim();
    title = (title == null || title.isEmpty) ? null : title;
  }

  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: 8,
    children: [
      Expanded(
        child: Text(
          title ?? _renderContentType(contentType),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              overflow: TextOverflow.ellipsis),
        ),
      ),
      _typeChip(contentType),
    ],
  );
}

Widget _smartImage(String url, {double aspectRatio = 1, double radius = 8}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: AspectRatio(
      aspectRatio: aspectRatio,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    ),
  );
}

Widget _productGrid(List<dynamic> products) {
  if (products.isEmpty) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(child: Text('ยังไม่มีสินค้า')),
    );
  }

  return SizedBox(
    height: 80, // fix ความสูงการ์ดแนวนอน
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      separatorBuilder: (_, __) => const SizedBox(width: 6),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final p = products[i] as Map<String, dynamic>;
        final imageUrl = p['image'] as String? ?? '';

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _smartImage(imageUrl),
        );
      },
    ),
  );
}

Widget _horizontalPreview(List<String> images) {
  return SizedBox(
    height: 80,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      separatorBuilder: (_, __) => const SizedBox(width: 6),
      itemBuilder: (_, i) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _smartImage(images[i]),
      ),
    ),
  );
}

Widget buildEditCategory(Map<String, dynamic> items) {
  final int contentType = (items['content_type'] ?? 0) as int;
  final List<dynamic> details =
      (items['content_detail'] ?? []) as List<dynamic>;
  if (details.isEmpty) return const SizedBox.shrink();
  String? title;
  if (details.isNotEmpty) {
    final d = (details.first as Map<String, dynamic>);
    title = (d['content_name'] as String?)?.trim();
    title = (title == null || title.isEmpty) ? null : title;
  }

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .03),
          blurRadius: 16,
          offset: const Offset(0, 6),
        )
      ],
    ),
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          title ?? 'ไม่ระบุชื่อ',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              overflow: TextOverflow.ellipsis),
        ),
        _buildEditContentType(contentType, details),
        cardBottom(
          details: details,
          onEdit: () {
            // TODO: เปิด modal แก้ไขคอนเทนต์
          },
          onDelete: () {
            // TODO: ลบคอนเทนต์
          },
          onMoveUp: () {
            // TODO: ย้ายตำแหน่งขึ้น
          },
          onHide: () {
            // TODO: ย้ายตำแหน่งลง
          },
        ),
      ],
    ),
  );
}

Widget buildEditContent(Map<String, dynamic> items) {
  final int contentType = (items['content_type'] ?? 0) as int;
  final List<dynamic> details =
      (items['content_detail'] ?? []) as List<dynamic>;
  if (details.isEmpty) return const SizedBox.shrink();

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .03),
          blurRadius: 16,
          offset: const Offset(0, 6),
        )
      ],
    ),
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        _cardHeader(
          contentType: contentType,
          details: details,
        ),
        _buildEditContentType(contentType, details),
        cardBottom(
          details: details,
          onEdit: () {
            // TODO: เปิด modal แก้ไขคอนเทนต์
          },
          onDelete: () {
            // TODO: ลบคอนเทนต์
          },
          onMoveUp: () {
            // TODO: ย้ายตำแหน่งขึ้น
          },
          onHide: () {
            // TODO: ย้ายตำแหน่งลง
          },
        ),
      ],
    ),
  );
}

Widget _buildEditContentType(int contentType, List<dynamic> details) {
  final first = (details.first as Map<String, dynamic>);

  switch (contentType) {
    case 1:
      {
        final image =
            (first['image'] ?? first['image_desktop'] ?? '') as String;
        return SizedBox(
            height: 130, child: _smartImage(aspectRatio: (16 / 6), image));
      }

    case 2:
      {
        final images = details
            .map((e) => (e as Map<String, dynamic>)['image'] as String? ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
        return _horizontalPreview(images);
      }

    case 3:
      {
        final productList = (first['product_content'] ?? []) as List<dynamic>;
        return _productGrid(productList);
      }

    case 4:
      {
        final images = details
            .map((e) => (e as Map<String, dynamic>)['image'] as String? ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
        return _horizontalPreview(images);
      }

    case 5:
      {
        final image =
            (first['image'] ?? first['image_desktop'] ?? '') as String;
        return Stack(
          children: [
            _smartImage(image),
            Positioned.fill(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 40),
                ),
              ),
            ),
          ],
        );
      }

    default:
      return SizedBox();
  }
}

Widget buildEditProduct(List<Map<String, dynamic>> products) {
  final items =
      products.map((e) => Map<String, dynamic>.from(e)).toList(growable: false);

  return ListView.separated(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: items.length,
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder: (context, index) {
      final pMap = items[index];
      final product = ProductContent.fromJson(pMap);

      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .03),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          children: [
            productItemList(product: product),
            cardBottom(
              details: const [],
              onDelete: () {/* TODO */},
              onHide: () {/* TODO */},
            ),
          ],
        ),
      );
    },
  );
}

Future<void> buildAddSection(int tabIndex) async {
  switch (tabIndex) {
    case 0:
      await Get.to(() => ShopAddContent());
      break;
    case 1:
      final product = await addProductDrawer(single: true);
      if (product != null && product.isNotEmpty) {
        print(product);
      }
      break;
    case 2:
      await Get.to(() => ShopAddCategory());
      break;
    default:
      break;
  }
}

class DashedRRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(6),
    );

    final paint = Paint()
      ..color = themeColorDefault
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final dashedPath = dashPath(
      Path()..addRRect(rrect),
      dashArray: CircularIntervalList<double>([6, 4]),
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
