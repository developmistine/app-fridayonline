import 'dart:typed_data';

import 'package:fridayonline/enduser/components/appbar/appbar.master.dart';
import 'package:fridayonline/enduser/components/viewer/fullscreen.image.dart';
import 'package:fridayonline/enduser/controller/chat.ctr.dart';
import 'package:fridayonline/enduser/widgets/dialog.dart';
import 'package:fridayonline/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class ChatGallary extends StatefulWidget {
  const ChatGallary({super.key});

  @override
  State<ChatGallary> createState() => _ChatGallaryState();
}

class _ChatGallaryState extends State<ChatGallary> {
  final ChatController chatController = Get.put(ChatController());

  final int _sizePerPage = 50;

  AssetPathEntity? _path;
  List<AssetEntity>? _entities;
  int _totalEntitiesCount = 0;

  List<Uint8List?> listImg = [];

  @override
  void initState() {
    super.initState();
    _requestAssets();
  }

  @override
  void dispose() {
    chatController.selectedEntities.clear();
    chatController.selectedCount.value = 0;
    super.dispose();
  }

  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxVideoSize = 30 * 1024 * 1024; // 30MB

  Future<void> _requestAssets() async {
    chatController.isLoadingGallery = true;

    // ขอ permission
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (!mounted) return;

    if (!ps.hasAccess) {
      chatController.isLoadingGallery = false;
      dialogAlert([
        const Icon(
          Icons.info,
          color: Colors.white,
          size: 40,
        ),
        Text(
          "กรุณาให้สิทธิ์ในการเข้าถึงข้อมูล",
          style: GoogleFonts.notoSansThaiLooped(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ]);
      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.back();
      });
      return;
    }

    // กำหนด filter ให้รองรับรูปและวิดีโอ
    final PMFilter filter = FilterOptionGroup(
      imageOption: const FilterOption(
        sizeConstraint: SizeConstraint(ignoreSize: true),
      ),
      videoOption: const FilterOption(
        sizeConstraint: SizeConstraint(ignoreSize: true),
      ),
      orders: [
        const OrderOption(type: OrderOptionType.createDate, asc: false),
      ],
    );

    // ดึง list path ของอัลบั้ม โดยดึงทุกประเภท
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      type: RequestType.all, // <-- เปลี่ยนจาก default image เป็น all
      onlyAll: true,
      filterOption: filter,
    );

    if (!mounted) return;

    if (paths.isEmpty) {
      chatController.isLoadingGallery = false;
      dialogAlert([
        const Icon(
          Icons.info,
          color: Colors.white,
          size: 40,
        ),
        Text(
          "ไม่พบรูปหรือวิดีโอในเครื่อง",
          style: GoogleFonts.notoSansThaiLooped(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ]);
      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.back();
      });
      return;
    }

    setState(() {
      _path = paths.first;
    });

    _totalEntitiesCount = await _path!.assetCountAsync;

    final List<AssetEntity> entities = await _path!.getAssetListPaged(
      page: 0,
      size: _sizePerPage,
    );

    if (!mounted) return;

    _entities = entities;
    chatController.isLoadingGallery = false;
    chatController.hasMoreToLoad = _entities!.length < _totalEntitiesCount;

    _loadAllThumbnails();
  }

  Future<void> _loadMoreAsset() async {
    if (chatController.isLoadingMoreGallery) return; // ป้องกัน duplicate calls

    chatController.isLoadingMoreGallery = true; // เพิ่มบรรทัดนี้
    final List<AssetEntity> entities = await _path!.getAssetListPaged(
      page: chatController.page + 1,
      size: _sizePerPage,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _entities!.addAll(entities);
      chatController.page++;
      chatController.hasMoreToLoad = _entities!.length < _totalEntitiesCount;
    });
    chatController.isLoadingMoreGallery = false;
  }

  Future<void> _loadAllThumbnails() async {
    listImg = await Future.wait(_entities!.map((entity) =>
        entity.thumbnailDataWithSize(const ThumbnailSize.square(1000))));
    setState(() {});
  }

  Future<List<XFile>> getSelectedXFiles() async {
    final List<XFile> xfiles = [];

    for (final entity in chatController.selectedEntities) {
      final file = await entity.file;
      if (file != null) {
        xfiles.add(XFile(file.path));
      }
    }

    return xfiles;
  }

// ฟังก์ชันตรวจสอบขนาดไฟล์
  Future<bool> _checkFileSize(AssetEntity entity) async {
    try {
      final file = await entity.file;
      if (file == null) return false;

      final fileSize = await file.length();

      if (entity.type == AssetType.image) {
        return fileSize <= maxImageSize;
      } else if (entity.type == AssetType.video) {
        return fileSize <= maxVideoSize;
      }

      return false; // ไม่รองรับประเภทอื่น
    } catch (e) {
      print('Error checking file size: $e');
      return false;
    }
  }

  Widget _buildBody(BuildContext context) {
    if (chatController.isLoadingGallery) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (_path == null) {
      return const Center(child: Text('Request paths first.'));
    }
    if (_entities?.isNotEmpty != true) {
      return const Center(child: Text('No assets found on this device.'));
    }
    return GridView.custom(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // ถ้าเป็น item สุดท้ายและยังโหลดได้
          if (index == _entities!.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          // เป็น
          if (index >= _entities!.length - 5 && // เปลี่ยนเป็น >= และลดจำนวน
              !chatController.isLoadingMoreGallery &&
              chatController.hasMoreToLoad) {
            _loadMoreAsset();
          }
          final AssetEntity entity = _entities![index];
          return FutureBuilder<Uint8List?>(
            future:
                entity.thumbnailDataWithSize(const ThumbnailSize.square(200)),
            builder: (context, snapshot) {
              final bytes = snapshot.data;

              if (bytes == null) {
                return Container(
                  color: Colors.grey[300],
                );
              }

              return Obx(() {
                return Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => FullScreenImageViewer(
                            imageUrls: listImg,
                            initialIndex: index,
                            imgType: 0));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Image.memory(
                          bytes,
                          fit: BoxFit.cover,
                          width: Get.width,
                          height: Get.height,
                        ),
                      ),
                    ),
                    if (chatController.selectedEntities.contains(entity))
                      InkWell(
                        onTap: () {
                          Get.to(() => FullScreenImageViewer(
                              imageUrls: listImg,
                              initialIndex: index,
                              imgType: 0));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(1.0),
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    if (chatController.selectedEntities.contains(entity))
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                            onTap: () async {
                              final isSelected = chatController.selectedEntities
                                  .contains(entity);

                              if (isSelected) {
                                chatController.selectedEntities.remove(entity);
                                chatController.selectedCount.value =
                                    chatController.selectedEntities.length;
                              } else {
                                if (chatController.selectedEntities.length >=
                                    9) {
                                  dialogAlert([
                                    const Icon(
                                      Icons.notification_important,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    Text(
                                      "เลือกรูปภาพหรือวิดีโอได้สูงสุด 9 ไฟล์",
                                      style: GoogleFonts.notoSansThaiLooped(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ]);
                                  Future.delayed(
                                      const Duration(milliseconds: 1500), () {
                                    Get.back();
                                  });
                                  return;
                                }
                                // ตรวจสอบขนาดไฟล์
                                await _checkFileSize(entity)
                                    .then((isValidSize) {
                                  if (!isValidSize) {
                                    final maxSize =
                                        entity.type == AssetType.image
                                            ? "5MB"
                                            : "30MB";
                                    final fileType =
                                        entity.type == AssetType.image
                                            ? "รูปภาพ"
                                            : "วิดีโอ";

                                    dialogAlert([
                                      const Icon(
                                        Icons.notification_important,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      Text(
                                        "$fileType นี้มีขนาดเกิน $maxSize",
                                        style: GoogleFonts.notoSansThaiLooped(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ]);
                                    Future.delayed(
                                        const Duration(milliseconds: 1500), () {
                                      Get.back();
                                    });
                                    return;
                                  }
                                  chatController.selectedEntities.add(entity);
                                  chatController.selectedCount.value =
                                      chatController.selectedEntities.length;
                                });
                              }
                            },
                            child: const Center(
                              child:
                                  Icon(Icons.check_circle, color: Colors.white),
                            )),
                      )
                    else
                      Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () async {
                              final isSelected = chatController.selectedEntities
                                  .contains(entity);

                              if (isSelected) {
                                chatController.selectedEntities.remove(entity);
                                chatController.selectedCount.value =
                                    chatController.selectedEntities.length;
                              } else {
                                if (chatController.selectedEntities.length >=
                                    9) {
                                  dialogAlert([
                                    const Icon(
                                      Icons.notification_important,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    Text(
                                      "เลือกรูปภาพหรือวิดีโอได้สูงสุด 9 ไฟล์",
                                      style: GoogleFonts.notoSansThaiLooped(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ]);
                                  Future.delayed(
                                      const Duration(milliseconds: 1200), () {
                                    Get.back();
                                  });
                                  return;
                                }
                                // ตรวจสอบขนาดไฟล์
                                await _checkFileSize(entity)
                                    .then((isValidSize) {
                                  if (!isValidSize) {
                                    final maxSize =
                                        entity.type == AssetType.image
                                            ? "5MB"
                                            : "30MB";
                                    final fileType =
                                        entity.type == AssetType.image
                                            ? "รูปภาพ"
                                            : "วิดีโอ";

                                    dialogAlert([
                                      const Icon(
                                        Icons.notification_important,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      Text(
                                        "$fileType นี้มีขนาดเกิน $maxSize",
                                        style: GoogleFonts.notoSansThaiLooped(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ]);
                                    Future.delayed(
                                        const Duration(milliseconds: 1200), () {
                                      Get.back();
                                    });
                                    return;
                                  }
                                  chatController.selectedEntities.add(entity);
                                  chatController.selectedCount.value =
                                      chatController.selectedEntities.length;
                                });
                              }
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white)),
                            ),
                          )),
                  ],
                );
              });
            },
          );
        },
        childCount: _entities!.length + (chatController.hasMoreToLoad ? 1 : 0),
        findChildIndexCallback: (Key key) {
          // Re-use elements.
          if (key is ValueKey<int>) {
            return key.value;
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Theme(
        data: Theme.of(context).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.notoSansThaiLooped())),
          textTheme: GoogleFonts.notoSansThaiLoopedTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        child: Scaffold(
          appBar: appBarMasterEndUser('คลังภาพ'),
          body: Column(
            children: <Widget>[
              Expanded(child: _buildBody(context)),
            ],
          ),
          bottomNavigationBar: SafeArea(
              child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Obx(() {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: themeColorDefault,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                  onPressed: chatController.selectedCount.value == 0
                      ? null
                      : () async {
                          var res = await getSelectedXFiles();

                          if (Get.arguments == 2) {
                            Get.back();
                            Get.back(result: res);
                          } else {
                            Get.back(result: res);
                          }
                        },
                  child: Text('ส่ง (${chatController.selectedCount.value})'));
            }),
          )),
        ),
      ),
    );
  }
}
