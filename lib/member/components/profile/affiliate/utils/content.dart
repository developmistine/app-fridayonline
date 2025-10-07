import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop/shop.category.add.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop/shop.category.show.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop/shop.content.add.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop/shop.product.add.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/product.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/videoplayer.dart';
import 'package:fridayonline/member/components/utils/confirm.dialog.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.product.ctr.dart';
import 'package:fridayonline/member/controller/category.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart';
import 'package:fridayonline/member/utils/cached_image.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:video_player/video_player.dart';
import '../../myreview/myrating.card.dart';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart'
    as content;

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
            fontSize: 12,
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
Widget buildContentSection(content.ContentData data) {
  final String contentType = data.contentType;
  final List<content.Item> details = data.items;

  final List<content.Item> visible =
      details.where((e) => e.status != 'hide').toList();

  if (visible.isEmpty) {
    return const SizedBox.shrink();
  }

  if (details.isEmpty) {
    return SizedBox();
  }

  switch (contentType) {
    case "Image":
      return _buildType1(details);
    case 'Carousel':
      return _buildType2(details);
    case 'Product':
      return _buildType3(details);
    case 'Category':
      return SizedBox();
    // _buildType4(details);
    case 'Video':
      return _buildType5(details);
    case 'Text':
      if (details.isEmpty ||
          details[0].status == 'hide' ||
          (details.length == 1 && (details[0].description.trim().isEmpty))) {
        return SizedBox();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.map((item) {
          if ((item.name).contains('<') && (item.name).contains('>')) {
            return Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: HtmlWidget(
                item.description,
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(
                item.description,
                style: GoogleFonts.ibmPlexSansThai(fontSize: 14),
              ),
            );
          }
        }).toList(),
      );
    default:
      return SizedBox();
  }
}

Widget buildProductSection(List<AffiliateProduct> items) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final w = constraints.maxWidth;
      final count = math.min(6, math.max(2, (w / 180).floor()));
      if (items.isEmpty) {
        return const SizedBox.shrink(); // หรือ widget เปล่าตามต้องการ
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 0.62,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final p = items[index];
          return productItem(
            product: p,
            onTap: () {
              Get.find<ShowProductSkuCtr>()
                  .fetchB2cProductDetail(p.productId, 'shop_content');
              // setPauseVideo();
              Get.toNamed(
                '/ShowProductSku/${p.productId}',
              );
            },
          );
        },
      );
    },
  );
}

Widget buildCategorySection(content.ContentData data) {
  final List<content.Item> details = data.items;

  if (details.isEmpty) {
    return const SizedBox();
  }

  final content.Item cat = details.first;

  final List<content.AffiliateProduct> products = cat.attachedProduct;

  final String catName = cat.name.trim();

  final String? image1 = products.isNotEmpty ? products[0].image : null;
  final String? image2 = products.length > 1 ? products[1].image : null;
  final String? image3 = products.length > 2 ? products[2].image : null;

  final int total = products.length;
  final isHide = cat.status == 'hide';

  return InkWell(
    onTap: () {
      Get.to(() => ShopShowCategory(
            cat.id,
            catName.isEmpty ? 'ไม่ระบุหมวดหมู่' : catName,
            products,
          ));
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
            child: Stack(
              children: [
                Row(
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
                if (isHide) ...[
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100.withValues(alpha: .5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: Text(
                            'ซ่อน',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )),
                ],
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
  if (url == null || url.isEmpty) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
          child: Icon(
        Icons.image_not_supported,
        color: Colors.grey.shade500,
      )),
    );
  }
  return Image.network(
    url,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => Container(
      color: Colors.grey.shade200,
      child: Center(
          child: Icon(Icons.image_not_supported, color: Colors.grey.shade500)),
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
                  onTap: () => affProductCtl.setSortTab(index),
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
                                  ? Icons.arrow_downward_outlined
                                  : Icons.arrow_upward_outlined,
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

// ช่วยฟังก์ชันทำ key
Key _itemKey(
    {required int index, required String? id, required String fallback}) {
  return ValueKey(id?.isNotEmpty == true ? id : '$fallback-$index');
}

// --- content_type == 1 : Banner
Widget _buildType1(List<content.Item> details) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(details.length, (idx) {
      final content.Item d = details[idx];
      final String image = d.images;
      final String name = d.name;
      final bool showName = d.displayName;
      final bool isHide = d.status == 'hide';

      if (image.isEmpty || isHide) return SizedBox();

      return KeyedSubtree(
        key: _itemKey(index: idx, id: image, fallback: 'type1'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
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
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CacheImageContentShop(
                    url: image,
                  ),
                ],
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
  List<content.Item> details, {
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
            final content.Item data = details[index];

            final String url = data.images;

            return InkWell(
              onTap: () {},
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
Widget _buildType3(List<content.Item> details) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(details.length, (idx) {
      final content.Item d = details[idx];

      final bool showName = d.displayName;
      final String name = d.name;

      final List<AffiliateProduct> products = d.attachedProduct;
      final visibleItems = products
          .where((p) => (p.status).trim().toLowerCase() != 'hide')
          .toList(growable: false);

      if (visibleItems.isEmpty) return const SizedBox.shrink();

      return KeyedSubtree(
          key: _itemKey(index: idx, id: name, fallback: 'type3'),
          child: Column(
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.62,
                ),
                itemCount: visibleItems.length,
                itemBuilder: (context, index) {
                  final p = visibleItems[index];
                  return productItem(
                    product: p,
                    onTap: () {
                      Get.find<ShowProductSkuCtr>()
                          .fetchB2cProductDetail(p.productId, 'shop_content');
                      // setPauseVideo();
                      Get.toNamed(
                        '/ShowProductSku/${p.productId}',
                      );
                    },
                  );
                },
              )
            ],
          ));
    }),
  );
}

// --- content_type == 4 : Category List
Widget _buildType4(
  List<content.Item> details, {
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
            final content.Item item = details[index];

            final String url = item.images;

            return Padding(
              padding: EdgeInsets.only(right: spacing),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {},
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
Widget _buildType5(List<content.Item> details) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: List.generate(details.length, (idx) {
      final content.Item d = details[idx];

      final String name = d.name;
      final String videoUrl = d.images;
      final showName = d.displayName;
      final bool isHide = d.status == 'hide';

      if (isHide) return SizedBox();

      return KeyedSubtree(
          key: _itemKey(index: idx, id: name, fallback: 'type5'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showName && name.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'name',
                    style: GoogleFonts.ibmPlexSansThai(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FutureBuilder<VideoPlayerController>(
                  future: setVideoContent(
                    videoUrl,
                    // fallbackForHuawei720: 'videoUrl720', // ถ้ามี
                    autoPlay: true,
                    initialVolume: 0.0,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 200,
                      );
                    }
                    if (snapshot.hasError) {
                      return const SizedBox();
                    }
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }

                    final controller = snapshot.data!;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  constraints:
                                      const BoxConstraints(maxWidth: 28),
                                  icon: const Icon(Icons.fullscreen),
                                  color: Colors.white,
                                  onPressed: () {
                                    Get.to(() => FullScreenVideoPlayer(
                                        videoUrl: videoUrl));
                                  },
                                ),
                                Obx(() {
                                  return IconButton(
                                    icon: Icon(
                                      affContentCtl.volume.value == 0
                                          ? Icons.volume_off
                                          : Icons.volume_down,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      // เปลี่ยนค่าของ volume ตามที่กด
                                      controller.setVolume(
                                          controller.value.volume != 0 ? 0 : 1);
                                      affContentCtl.volume.value =
                                          controller.value.volume;
                                    },
                                  );
                                })
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ));
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

Widget _typeChip(String type, isHide) {
  final text = switch (type) {
    "Image" => 'รูปภาพ',
    "Text" => 'ข้อความ',
    "Product" => 'สินค้า',
    "Category" => 'หมวดหมู่',
    "Video" => 'วิดีโอ',
    _ => '',
  };
  final color = switch (type) {
    "Image" => const Color(0xFF5856D6),
    "Text" => const Color(0xFF30B0C7),
    "Product" => const Color(0xFFFB9600),
    "Category" => Colors.purple,
    "Video" => const Color(0xFFF44336),
    _ => Colors.grey,
  };
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: isHide ? Colors.white70 : color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    ),
  );
}

Widget cardBottom({
  VoidCallback? onEdit,
  VoidCallback? onDelete,
  VoidCallback? onMoveUp,
  VoidCallback? onHide,
  required String hideStatus,
}) {
  final isHide = hideStatus == 'hide';
  final btnStyle = OutlinedButton.styleFrom(
    side: BorderSide(color: const Color(0xFFD9D8DC)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    padding: const EdgeInsets.all(5),
    foregroundColor: Colors.black87,
    backgroundColor: Colors.white,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.compact,
  );

  Widget ob(
      String icon, String tooltip, VoidCallback? onPressed, bool showText) {
    return Tooltip(
        message: tooltip,
        padding: EdgeInsets.zero,
        child: OutlinedButton(
          onPressed: onPressed,
          style: btnStyle,
          child: Center(
              child: Row(
            spacing: 2,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: 18,
                color: Color(0xFF5A5A5A),
              ),
              if (showText)
                SizedBox(
                  height: 17,
                  child: Text(
                    tooltip,
                    style: GoogleFonts.ibmPlexSansThai(
                      color: const Color(0xFF5A5A5A),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
            ],
          )),
        ));
  }

  return Align(
    alignment: Alignment.centerRight,
    child: SizedBox(
      height: 32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          if (onDelete != null)
            ob('assets/images/affiliate/cardmenu/trash.svg', 'ลบ', onDelete,
                false),
          if (onHide != null)
            ob(
                isHide
                    ? 'assets/images/affiliate/cardmenu/eye.svg'
                    : 'assets/images/affiliate/cardmenu/eye_off.svg',
                'ซ่อน',
                onHide,
                false),
          if (onEdit != null)
            ob('assets/images/affiliate/cardmenu/edit.svg', 'แก้ไข', onEdit,
                false),
          if (onMoveUp != null)
            ob('assets/images/affiliate/cardmenu/moveup.svg', 'เลื่อนขึ้น',
                onMoveUp, true),
        ],
      ),
    ),
  );
}

Widget _cardHeader({
  required String contentType,
  required Item item,
}) {
  final title = item.name == "" ? contentType : item.name;
  final isHide = item.status == 'hide';

  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: 8,
    children: [
      Expanded(
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              overflow: TextOverflow.ellipsis),
        ),
      ),
      Row(
        spacing: 4,
        children: [
          if (isHide)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFF5A5A5A)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 2,
                children: [
                  Text('ซ่อนอยู่',
                      style: TextStyle(
                          color: const Color(0xFF5A5A5A),
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                  SvgPicture.asset(
                    'assets/images/affiliate/cardmenu/eye_off.svg',
                    width: 16,
                  )
                ],
              ),
            ),
          _typeChip(contentType, isHide),
        ],
      ),
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

Widget _productGrid(List<AffiliateProduct> products, bool isHide) {
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
        final p = products[i];
        final imageUrl = p.image;

        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _smartImage(imageUrl),
            ),
            if (isHide)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .28),
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
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

Widget buildEditCategory(content.ContentData data, int i,
    {VoidCallback? onScrollTop}) {
  final String contentType = data.contentType;
  final List<content.Item> details = data.items;
  final isHide = details.first.status == 'hide';

  if (details.isEmpty) return const SizedBox.shrink();

  final int totalProduct =
      details.fold<int>(0, (sum, item) => sum + item.attachedProduct.length);

  String title;
  {
    final d = details.first;
    title = (d.name.isNotEmpty == true) ? d.name : 'ไม่ระบุหมวดหมู่';
  }

  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          color: isHide ? const Color(0x331F1F1F) : Colors.white,
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
          spacing: 6,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.isNotEmpty ? title : 'ไม่ระบุชื่อ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'สินค้า $totalProduct รายการ',
                        style: TextStyle(
                          color:
                              isHide ? Colors.black87 : const Color(0xFF8C8A94),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isHide)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFF5A5A5A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 2,
                      children: [
                        Text('ซ่อนอยู่',
                            style: TextStyle(
                                color: const Color(0xFF5A5A5A),
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                        SvgPicture.asset(
                          'assets/images/affiliate/cardmenu/eye_off.svg',
                          width: 16,
                        )
                      ],
                    ),
                  ),
              ],
            ),

            // รายการในหมวด
            ...details.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Stack(children: [
                    _buildEditContentType(contentType, item, isHide),
                  ]),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isHide
                              ? Colors.black.withValues(alpha: .1)
                              : Color(0xFFF3F3F4),
                          width: 0.7,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        cardBottom(
                          hideStatus: item.status,
                          onEdit: () {
                            Get.to(() => ShopAddCategory(contentId: item.id));
                          },
                          onDelete: () {
                            showConfirmDialog(
                              title: "ลบข้อมูล?",
                              desc: "คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลนี้",
                              onConfirm: () async {
                                await affContentCtl.deleteContent(
                                    'category', item.id);
                              },
                            );
                          },
                          onMoveUp: i == 0
                              ? null
                              : () async {
                                  await affContentCtl.sortContent(
                                      'category', item.id);
                                  onScrollTop?.call();
                                },
                          onHide: () async {
                            await affContentCtl.hideContent('category', item.id,
                                item.status == 'hide' ? 'published' : 'hide');
                          },
                        ),
                      ],
                    ),
                  ),
                  if (index != details.length - 1)
                    const Divider(height: 16, thickness: .6),
                ],
              );
            }),
          ],
        ),
      ),
      if (isHide) ...[
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .62),
                  borderRadius: BorderRadius.circular(999),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: .18)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/affiliate/cardmenu/eye_off.svg',
                      width: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ซ่อนอยู่',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]
    ],
  );
}

Widget buildEditContent(content.ContentData data, int i,
    {VoidCallback? onScrollTop}) {
  final String contentType = data.contentType;
  final List<content.Item> details = data.items;
  final isHide = details.first.status == 'hide';

  if (details.isEmpty) return const SizedBox.shrink();

  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          color: isHide ? const Color(0x331F1F1F) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .03),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: details.asMap().entries.map((entry) {
            final item = entry.value;
            final int totalProduct = details.fold<int>(
                0, (sum, item) => sum + item.attachedProduct.length);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _cardHeader(
                          contentType: contentType,
                          item: item,
                        ),
                        if (contentType == 'Product')
                          Text(
                            'สินค้า $totalProduct รายการ',
                            style: TextStyle(
                              color: isHide
                                  ? Colors.black87
                                  : const Color(0xFF8C8A94),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                    Stack(
                      children: [
                        _buildEditContentType(contentType, item, isHide),
                        if (isHide &&
                            (contentType != 'Text' && contentType != 'Product'))
                          Positioned.fill(
                            child: IgnorePointer(
                              ignoring: true,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: .28),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isHide
                            ? Colors.black.withValues(alpha: .1)
                            : Color(0xFFF3F3F4),
                        width: 0.7,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      cardBottom(
                        hideStatus: item.status,
                        onEdit: () {
                          Get.to(() => ShopAddContent(contentId: item.id));
                        },
                        onDelete: () {
                          showConfirmDialog(
                            title: "ลบข้อมูล?",
                            desc: "คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลนี้",
                            onConfirm: () async {
                              await affContentCtl.deleteContent(
                                  'content', item.id);
                            },
                          );
                        },
                        onMoveUp: i == 0
                            ? null
                            : () async {
                                await affContentCtl.sortContent(
                                    'content', item.id);
                                onScrollTop?.call();
                              },
                        onHide: () async {
                          await affContentCtl.hideContent('content', item.id,
                              item.status == 'hide' ? 'published' : 'hide');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      if (isHide) ...[
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .62),
                  borderRadius: BorderRadius.circular(999),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: .18)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/affiliate/cardmenu/eye_off.svg',
                      width: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ซ่อนอยู่',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]
    ],
  );
}

Widget _buildEditContentType(String contentType, Item items, bool isHide) {
  switch (contentType) {
    case 'Image':
      {
        final image = items.images;
        return SizedBox(
            height: 150, child: _smartImage(aspectRatio: (16 / 6), image));
      }

    case "Product":
      {
        final productList = items.attachedProduct;
        return _productGrid(productList, isHide);
      }

    case "Category":
      {
        final productList = items.attachedProduct;

        return _productGrid(productList, isHide);
      }

    case "Video":
      {
        final image = items.images;
        return Stack(
          children: [
            FutureBuilder<VideoPlayerController>(
              future: setVideoContent(image),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: const SizedBox.shrink(),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return _smartImage(image);
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
                      alignment: Alignment.center,
                      children: [
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
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                constraints: const BoxConstraints(maxWidth: 28),
                                icon: const Icon(Icons.fullscreen),
                                color: Colors.white,
                                onPressed: () {
                                  // ❗ ใช้ videoUrl จาก d ของ item ปัจจุบัน
                                  Get.to(() =>
                                      FullScreenVideoPlayer(videoUrl: image));
                                },
                              ),
                              // ถ้าใช้ GetX สำหรับเก็บ volume เหมือนเดิม
                              Obx(() {
                                final isMuted = affContentCtl.volume.value == 0;
                                return IconButton(
                                  icon: Icon(
                                    isMuted
                                        ? Icons.volume_off
                                        : Icons.volume_down,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    final nowMuted =
                                        controller.value.volume != 0;
                                    controller.setVolume(nowMuted ? 0 : 1);
                                    affContentCtl.volume.value =
                                        controller.value.volume;
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Positioned.fill(
            //   child: Center(
            //     child: Container(
            //       padding: const EdgeInsets.all(10),
            //       decoration: BoxDecoration(
            //         color: Colors.black.withValues(alpha: .35),
            //         shape: BoxShape.circle,
            //       ),
            //       child: const Icon(Icons.play_arrow_rounded,
            //           color: Colors.white, size: 40),
            //     ),
            //   ),
            // ),
          ],
        );
      }
    case 'Text':
      {
        if ((items.name).contains('<') && (items.name).contains('>')) {
          return HtmlWidget(
            items.description,
          );
        } else {
          return Text(
            items.description,
            style: GoogleFonts.ibmPlexSansThai(fontSize: 14),
          );
        }
      }

    default:
      return SizedBox();
  }
}

Widget buildEditProduct(List<AffiliateProduct> products) {
  return ListView.separated(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: products.length,
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder: (context, index) {
      final p = products[index];
      final isHide = p.status == 'hide';

      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isHide ? const Color(0x331F1F1F) : Colors.white,
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
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: productItemList(product: p),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isHide
                            ? Colors.black.withValues(alpha: .1)
                            : Color(0xFFF3F3F4),
                        width: 0.7,
                      ),
                    ),
                  ),
                  child: cardBottom(
                    hideStatus: p.status,
                    onDelete: () async {
                      await affProductCtl.deleteProduct(p.productId);
                    },
                    onHide: () async {
                      await affProductCtl.hideProduct(
                          p.status == 'hide' ? 'published' : 'hide',
                          p.productId,
                          false);
                    },
                  ),
                ),
              ],
            ),
            if (isHide)
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .5),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFF5A5A5A)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 2,
                    children: [
                      Text('ซ่อนอยู่',
                          style: TextStyle(
                              color: const Color(0xFF5A5A5A),
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                      SvgPicture.asset(
                        'assets/images/affiliate/cardmenu/eye_off.svg',
                        width: 16,
                      )
                    ],
                  ),
                ),
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
      affContentCtl.clearAddContentData();
      break;
    case 1:
      await addProductDrawer(target: 'product', single: true);
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

// Map<String, VideoPlayerController> videoControllers = {};

// Future<VideoPlayerController> setVideoContent(String content) async {
//   if (videoControllers.containsKey(content)) {
//     return videoControllers[content]!;
//   }

//   VideoPlayerController videoCtr = VideoPlayerController.networkUrl(
//     Uri.parse(content),
//   );

//   await videoCtr.initialize().then((value) {
//     videoCtr.setVolume(0);
//     videoCtr.play();
//   });

//   videoControllers[content] = videoCtr;

//   return videoCtr;
// }

Widget renderValidateFileText(int contentType) {
  final textStyle = GoogleFonts.ibmPlexSansThai(
    color: const Color(0xFF5A5A5A),
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  switch (contentType) {
    case 1: // image
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ขนาดไฟล์: ไม่เกิน 2 MB',
            style: textStyle,
          ),
          Text(
            'นามสกุลไฟล์ที่รองรับ: JPG, JPEG, PNG, GIF,WEBP',
            style: textStyle,
          )
        ],
      );
    case 2: // product
      return Text(
        'กรุณาเพิ่มสินค้า สูงสุดไม่เกิน 20 ชิ้น',
        style: textStyle,
      );
    case 3: // video
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ขนาดไฟล์: ไม่เกิน 30 MB',
            style: textStyle,
          ),
          Text(
            'นามสกุลไฟล์ที่รองรับ: MP4',
            style: textStyle,
          )
        ],
      );
    case 4: // text
      return Text(
        'แชร์เรื่องราวที่น่าสนใจเกี่ยวกับร้านของคุณ',
        style: textStyle,
      );
    default:
      return SizedBox();
  }
}
