import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/shop.product.add.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/product.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/upload.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.content.ctr.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class PreviewContent extends StatelessWidget {
  const PreviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    final affContentCtl = Get.find<AffiliateContentCtr>();

    return Obx(() {
      final t = affContentCtl.contentTypeId.value;
      Widget child;

      switch (t) {
        case 1: // Banner
          child = _buildType1();
          break;
        case 2: // Product
          child = _buildType2();
          break;
        case 3: // Video
          child = _buildType3();
          break;
        case 4: // Text
          child = _buildType4();
          break;
        case 5: // Carousel
          child = _buildType5();
          break;
        default:
          child = const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('กรุณาเลือกประเภทเนื้อหา',
                style: TextStyle(color: Colors.grey)),
          );
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: child,
      );
    });
  }
}

// --- content_type == 1 : Banner
Widget _buildType1() {
  final files = affContentCtl.selectedImages;

  if (files.isEmpty) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Container(
        width: double.infinity,
        height: 180,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF3F3F4),
        ),
        child: const Icon(Icons.image_not_supported,
            size: 48, color: Color(0xFFC6C5C9)),
      ),
    );
  } else {
    final file = files.first;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              file,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: () => affContentCtl.removeImageAt(0),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .6),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- content_type == 2 : Product
Widget _buildType2() {
  final products = affContentCtl.selectedProducts;

  if (products.isEmpty) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF3F3F4),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/affiliate/loading_bag.png',
                    width: 58,
                    height: 58,
                    color: const Color(0xFFC6C5C9),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFF3F3F4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 12,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFF3F3F4),
              ),
            ),
          ],
        );
      },
    );
  }

  // ---- แสดงสินค้าที่เลือกแล้ว ----
  return ListView.separated(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: products.length,
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder: (context, index) {
      final pMap = products[index];

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
            productItemList(product: pMap),
            cardBottom(
              details: const [],
              onDelete: () => affContentCtl.removeSelectedProductAt(index),
              onMoveUp: () => affContentCtl.moveSelectedProductToTop(index),
            ),
          ],
        ),
      );
    },
  );
}

// --- content_type == 3 : Video
Widget _buildType3() {
  final file = affContentCtl.selectedVideo.value;
  if (file == null) {
    // ยังไม่มีไฟล์
    return Container(
      margin: const EdgeInsets.only(top: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF3F3F4),
        ),
        child: const Center(
          child: Icon(Icons.play_arrow, size: 48, color: Color(0xFFC6C5C9)),
        ),
      ),
    );
  }
  // มีไฟล์แล้ว
  return VideoPreviewFromFile(file: file);
}

// --- content_type == 4 : Text
Widget _buildType4() {
  final text = affContentCtl.selectedText.value;

  if (text.isEmpty) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFF3F3F4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 12,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFF3F3F4),
              ),
            ),
          ],
        ));
  } else {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    // เปิด editor แก้ไขใหม่
                    final updated = await openTextEditorDrawer(initial: text);
                    if (updated != null) {
                      affContentCtl.selectedText.value = updated;
                    }
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 22,
                  ),
                ),
                IconButton(
                  onPressed: () => affContentCtl.selectedText.value = '',
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 22,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

// --- content_type == 5 : Carousel
Widget _buildType5() {
  final files = affContentCtl.selectedImages;
  final ValueNotifier<int> current = ValueNotifier<int>(0);

  if (files.isEmpty) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CarouselSlider.builder(
            itemCount: 3,
            itemBuilder: (context, index, _) {
              return Container(
                width: double.infinity,
                height: 180,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF3F3F4),
                ),
                child: const Icon(Icons.image_not_supported,
                    size: 48, color: Color(0xFFC6C5C9)),
              );
            },
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: true,
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
                children: List.generate(3, (i) {
                  final active = value == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: (active ? Colors.white : Colors.grey.shade400)
                          .withValues(alpha: active ? 0.9 : 0.5),
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

  return Stack(
    children: [
      Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CarouselSlider.builder(
          itemCount: files.length,
          itemBuilder: (context, index, _) {
            final file = files[index];
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () => affContentCtl.removeImageAt(index),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .6),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: files.length > 1,
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
              children: List.generate(files.length, (i) {
                final active = value == i;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: (active ? Colors.white : Colors.grey.shade400)
                        .withValues(alpha: active ? 0.9 : 0.5),
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

Widget addButton({
  required int? contentTypeId,
  int currentCount = 0,
  required int max,
}) {
  String title() {
    switch (contentTypeId) {
      case 1:
        return "เพิ่มรูปภาพ $currentCount/$max";
      case 2:
        return "เพิ่มสินค้า ${affContentCtl.selectedProducts.length}/$max";
      case 3:
        return "เพิ่มวิดีโอ ${affContentCtl.selectedVideo.value != null ? 1 : 0}/$max";
      case 4:
        return "เพิ่มข้อความ ${affContentCtl.selectedText.value.isNotEmpty ? 1 : 0}/$max";
      case 5:
        return "เพิ่มรูปภาพ $currentCount/$max";
      default:
        return "";
    }
  }

  Future<void> onTap() async {
    if (contentTypeId == null || contentTypeId == 0) {
      Get.snackbar('แจ้งเตือน', 'กรุณาเลือกประเภทเนื้อหาก่อน');
      return;
    }
    switch (contentTypeId) {
      case 1: // Image
        final file = await openImagePickerSingle();
        if (file != null) {
          affContentCtl.addImages([file], max: 1);
        }
        break;
      case 2: // Product
        final products = await addProductDrawer(single: false);
        if (products != null) {
          final newIds = products.map((p) => p.productId).toSet();

          affContentCtl.selectedProducts
              .removeWhere((p) => !newIds.contains(p.productId));

          final existingIds =
              affContentCtl.selectedProducts.map((p) => p.productId).toSet();
          final newOnes = products
              .where((p) => !existingIds.contains(p.productId))
              .toList();

          affContentCtl.selectedProducts.insertAll(0, newOnes);
        }
        break;

      case 3: // Video
        final file = await openVideoPickerSingle();
        if (file != null) {
          affContentCtl.selectedVideo.value = file;
        }
        break;
      case 4: // Text
        final text = await openTextEditorDrawer(initial: '');
        if (text != null) {
          affContentCtl.selectedText.value = text;
        }
        break;
      case 5: // Carousel
        //  final files = await openImagePickerMultiple(max: 10); // return List<File>
        // if (files != null && files.isNotEmpty) {
        //   affiliateCtl.addImages(files, max: 10);
        // }
        break;
      default:
        break;
    }
  }

  final enabled = (contentTypeId != null && contentTypeId != 0);

  return AnimatedPadding(
    duration: const Duration(milliseconds: 150),
    curve: Curves.easeOut,
    padding: const EdgeInsets.only(bottom: 4),
    child: InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(6),
      child: CustomPaint(
        painter: DashedRRectPainter(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: enabled ? 0.6 : 0.3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: enabled ? themeColorDefault : Colors.grey),
              const SizedBox(width: 8),
              Text(
                title(),
                style: GoogleFonts.ibmPlexSansThai(
                  color: enabled ? themeColorDefault : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class VideoPreviewFromFile extends StatefulWidget {
  const VideoPreviewFromFile({super.key, required this.file});
  final File file;

  @override
  State<VideoPreviewFromFile> createState() => _VideoPreviewFromFileState();
}

class _VideoPreviewFromFileState extends State<VideoPreviewFromFile> {
  late Future<VideoPlayerController> _future;
  VideoPlayerController? _controller;

  Future<VideoPlayerController> _initController(File f) async {
    final c = VideoPlayerController.file(f);
    await c.initialize();
    c.setLooping(true);
    c.setVolume(affContentCtl.volume.value); // sync ค่า volume เดิมถ้ามี
    _controller = c;
    return c;
  }

  @override
  void initState() {
    super.initState();
    _future = _initController(widget.file);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget shell(Widget child) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFF3F3F4),
          ),
          child: child,
        ),
      );
    }

    return Stack(
      children: [
        FutureBuilder<VideoPlayerController>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return shell(const Center(child: CircularProgressIndicator()));
            }
            if (snap.hasError || !snap.hasData) {
              return shell(const Center(
                child: Icon(Icons.error_outline, color: Colors.grey),
              ));
            }

            final ctrl = snap.data!;
            final aspect =
                ctrl.value.isInitialized ? ctrl.value.aspectRatio : (16 / 9);

            return shell(
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  InkWell(
                    onTap: () {
                      if (ctrl.value.isPlaying) {
                        ctrl.pause();
                      } else {
                        ctrl.play();
                      }
                      setState(() {});
                    },
                    child: AspectRatio(
                      aspectRatio: aspect,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: _controller!.value.size.width,
                          height: _controller!.value.size.height,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.fullscreen, color: Colors.white),
                          onPressed: () {
                            // เปิดหน้า fullscreen ใหม่ โดยส่งไฟล์ไป
                            Get.to(() => _FullScreenVideo(file: widget.file));
                          },
                        ),
                        Obx(() {
                          final isMuted = affContentCtl.volume.value == 0;
                          return IconButton(
                            icon: Icon(
                              isMuted ? Icons.volume_off : Icons.volume_down,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              final nowMuted = _controller?.value.volume != 0;
                              _controller?.setVolume(nowMuted ? 0 : 1);
                              affContentCtl.volume.value =
                                  _controller?.value.volume ?? 0;
                              setState(() {});
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          top: 14,
          right: 8,
          child: InkWell(
            onTap: affContentCtl.clearSelectedMedia,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .6),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}

class _FullScreenVideo extends StatefulWidget {
  const _FullScreenVideo({required this.file});
  final File file;

  @override
  State<_FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<_FullScreenVideo> {
  VideoPlayerController? _c;
  Future<void>? _init;

  @override
  void initState() {
    super.initState();
    _c = VideoPlayerController.file(widget.file);
    _init = _c!.initialize().then((_) {
      _c!.setLooping(true);
      _c!.setVolume(affContentCtl.volume.value);
      setState(() {});
      _c!.play();
    });
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _init,
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final aspect =
              _c!.value.isInitialized ? _c!.value.aspectRatio : (16 / 9);
          return Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: aspect,
                  child: VideoPlayer(_c!),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
