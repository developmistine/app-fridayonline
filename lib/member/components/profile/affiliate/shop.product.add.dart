import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> addProductDrawer() async {
  final ids = await Get.bottomSheet(
    _buildAddProductSection(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .3),
    enableDrag: true,
  );

  if (ids != null) {
    // TODO: นำ ids ไปเพิ่มใน content ของคุณ
    // debugPrint('เลือกสินค้า: $ids');
  }
}

Widget _buildAddProductSection() {
  final mock = List.generate(
      30, (i) => {'id': 1000 + i, 'title': 'สินค้า #${1000 + i}'});
  final selected = <int>{}.obs;

  return SafeArea(
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
            const Text('เลือกสินค้า',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Flexible(
              child: Obx(() => ListView.separated(
                    shrinkWrap: true,
                    itemCount: mock.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final m = mock[i];
                      final id = m['id'] as int;
                      final checked = selected.contains(id);
                      return ListTile(
                        title: Text(m['title'] as String),
                        trailing: Checkbox(
                          value: checked,
                          onChanged: (v) {
                            if (v == true) {
                              selected.add(id);
                            } else {
                              selected.remove(id);
                            }
                          },
                        ),
                        onTap: () {
                          if (checked) {
                            selected.remove(id);
                          } else {
                            selected.add(id);
                          }
                        },
                      );
                    },
                  )),
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
                  child: Obx(() {
                    final ok = selected.isNotEmpty;
                    return ElevatedButton(
                      onPressed:
                          ok ? () => Get.back(result: selected.toList()) : null,
                      child: const Text('เพิ่มสินค้า'),
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
  );
}
