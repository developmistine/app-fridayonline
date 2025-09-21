import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/content.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

const _kMaxImageMB = 2;
const _kMaxVideoMB = 30;
const _kImageExts = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
const _kVideoExts = ['mp4'];

bool _validSize(File file, int maxMB) {
  final bytes = file.lengthSync();
  final limit = maxMB * 1024 * 1024;
  return bytes <= limit;
}

bool _validExt(String path, List<String> exts) {
  final ext = path.split('.').last.toLowerCase();
  return exts.contains(ext);
}

Widget _slotTile({
  required Widget child,
  VoidCallback? onRemove,
}) {
  return Stack(
    children: [
      Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(color: const Color(0xFFF5F5F7), child: child),
        ),
      ),
      if (onRemove != null)
        Positioned(
          right: 4,
          top: 4,
          child: InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
    ],
  );
}

Widget _addTile(VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: CustomPaint(
      painter: DashedRRectPainter(),
      child: Container(
        color: Colors.grey.shade300,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add, size: 28, color: Color(0xFF6B7280)),
              SizedBox(height: 4),
              Text('เพิ่ม', style: TextStyle(color: Color(0xFF6B7280))),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<File?> openImagePickerSingle() async {
  final ImagePicker picker = ImagePicker();
  final XFile? picked = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1920,
    maxHeight: 1920,
    imageQuality: 90,
  );

  if (picked == null) return null;

  final file = File(picked.path);

  final ext = picked.path.split('.').last.toLowerCase();
  if (!_kImageExts.contains(ext)) {
    Get.snackbar(
      'ไฟล์ไม่รองรับ',
      'รองรับ: ${_kImageExts.join(', ').toUpperCase()}',
    );
    return null;
  }

  final sizeInBytes = await file.length();
  final sizeInMB = sizeInBytes / (1024 * 1024);
  if (sizeInMB > _kMaxImageMB) {
    Get.snackbar('ไฟล์ใหญ่เกินไป', 'ขนาดต้องไม่เกิน $_kMaxImageMB MB');
    return null;
  }

  return file;
}

Future<List<PlatformFile>?> openImageUploaderDrawer({
  required int maxImages, // 1 สำหรับ Banner, 10 สำหรับ Carousel
  int minImages = 1,
  String title = 'อัปโหลดรูปภาพ',
}) async {
  final files = <PlatformFile>[].obs;

  Future<void> pickMore() async {
    final canPick = maxImages - files.length;
    if (canPick <= 0) return;

    final res = await FilePicker.platform.pickFiles(
      allowMultiple: canPick > 1,
      type: FileType.custom,
      allowedExtensions: _kImageExts,
      withData: false,
    );
    if (res == null) return;

    for (final f in res.files) {
      final path = f.path!;
      final file = File(path);
      if (!_validExt(path, _kImageExts)) {
        Get.snackbar(
            'ไฟล์ไม่รองรับ', 'รองรับ: ${_kImageExts.join(', ').toUpperCase()}');
        continue;
      }
      if (!_validSize(file, _kMaxImageMB)) {
        Get.snackbar('ไฟล์ใหญ่เกินไป', 'ขนาดต้องไม่เกิน $_kMaxImageMB MB');
        continue;
      }
      if (files.length < maxImages) files.add(f);
    }
  }

  final result = await Get.bottomSheet<List<PlatformFile>>(
    SafeArea(
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Obx(() => Text('${files.length}/$maxImages')),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                final itemCount =
                    files.length < maxImages ? files.length + 1 : files.length;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (_, i) {
                    if (i < files.length) {
                      final f = files[i];
                      return _slotTile(
                        child: Image.file(File(f.path!), fit: BoxFit.cover),
                        onRemove: () => files.removeAt(i),
                      );
                    }
                    // ปุ่มเพิ่ม
                    return _addTile(pickMore);
                  },
                );
              }),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: null),
                      child: const Text('ยกเลิก'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(() {
                      final ok = files.length >= minImages;
                      return ElevatedButton(
                        onPressed:
                            ok ? () => Get.back(result: files.toList()) : null,
                        child: const Text('ยืนยัน'),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );

  return result;
}

Future<File?> openVideoPickerSingle() async {
  final ImagePicker picker = ImagePicker();
  final XFile? picked = await picker.pickVideo(
    source: ImageSource.gallery,
    maxDuration: const Duration(minutes: 10),
  );

  if (picked == null) return null;

  final file = File(picked.path);

  final ext = picked.path.split('.').last.toLowerCase();
  if (!_kVideoExts.contains(ext)) {
    Get.snackbar(
      'ไฟล์ไม่รองรับ',
      'รองรับ: ${_kVideoExts.join(', ').toUpperCase()}',
    );
    return null;
  }

  final sizeInBytes = await file.length();
  final sizeInMB = sizeInBytes / (1024 * 1024);
  if (sizeInMB > _kMaxVideoMB) {
    Get.snackbar('ไฟล์ใหญ่เกินไป', 'ขนาดต้องไม่เกิน $_kMaxVideoMB MB');
    return null;
  }

  return file;
}

Future<String?> openTextEditorDrawer({String? initial}) async {
  final ctrl = TextEditingController(text: initial ?? '');
  final result = await Get.bottomSheet<String>(
    SafeArea(
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2))),
              Align(
                alignment: Alignment.topLeft,
                child: const Text('เพิ่มข้อความ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ctrl,
                minLines: 3,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'พิมพ์ข้อความของคุณที่นี่...',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blue.shade400, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(
                    fontSize: 14, color: Colors.black87, height: 1.4),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () => Get.back(result: null),
                          child: const Text('ยกเลิก'))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () => Get.back(result: ctrl.text.trim()),
                          child: const Text('บันทึก'))),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
  return result;
}
