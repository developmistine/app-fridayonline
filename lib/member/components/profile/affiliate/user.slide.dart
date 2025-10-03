import 'package:flutter/material.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:get/get.dart';

class UserSlides extends StatefulWidget {
  const UserSlides({super.key});

  @override
  State<UserSlides> createState() => _SlidesState();
}

class _SlidesState extends State<UserSlides> {
  final _page = PageController(viewportFraction: 0.88); // โชว์การ์ดถัดไปนิด ๆ
  int _index = 0;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final affAccountCtl = Get.find<AffiliateAccountCtr>();
      final slides = affAccountCtl.tipsSlideData;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 14,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Container(
                      width: 4,
                      height: 21,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1C9AD6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                    Text(
                      'ทำไมต้องสมัคร ฟรายเดย์ Affiliate ?',
                      style: TextStyle(
                        color: const Color(0xFF1F1F1F),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 110,
                child: PageView.builder(
                  controller: _page,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  pageSnapping: true, // (default = true)
                  physics: const PageScrollPhysics(),
                  itemBuilder: (context, i) {
                    final v = slides[i];
                    return Padding(
                      padding: EdgeInsets.only(
                          right: i == slides.length - 1 ? 0 : 16),
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFECECED)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x1EA3A3A3),
                              blurRadius: 24,
                              offset: Offset(0, 3.57),
                            )
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(v.icon, width: 38, height: 38),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    v.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    v.description,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(slides.length, (i) {
                    final bool active = i == _index;
                    return GestureDetector(
                      onTap: () => _page.animateToPage(
                        i,
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOut,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: EdgeInsets.only(
                            right: i == slides.length - 1 ? 0 : 4),
                        width: active ? 32 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFF1C9AD6)
                              : const Color(0xFFC6C5C9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }),
                ),
              )
            ]),
      );
    });
  }
}
