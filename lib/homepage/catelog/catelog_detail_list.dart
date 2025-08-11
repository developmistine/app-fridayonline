import '../../controller/catelog/catelog_controller.dart';
import '../../homepage/catelog/catelog_detail_list_page.dart';
import '../../homepage/theme/theme_color.dart';
import '../../service/languages/multi_languages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//คลาสสำหรับแสดง catalog list
class CatelogDetailList extends StatefulWidget {
  const CatelogDetailList({super.key, this.channel});
  final channel;
  @override
  State<CatelogDetailList> createState() => _CatelogDetailListState();
}

class _CatelogDetailListState extends State<CatelogDetailList> {
  CatelogDetailController dataController = Get.put(
      CatelogDetailController()); //ทำการ get ข้อมูลจาก CatelogDetailController
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme_color_df,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(MultiLanguages.of(context)!.translate('menu_catalog'),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 10),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5),
              itemCount: dataController.catelog_detail!.ecatalogDetail.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    // When the child is tapped, show a snackbar.
                    onTap: () {
                      Get.find<CatelogSetFirstPageController>().set_first_page(
                          index,
                          dataController.catelog_detail!.ecatalogDetail[index]
                              .pageDetail); //ส่งค่าไปที่ CatelogSetFirstPageController และไปที่ฟังก์ชัน set_first_page
                      Get.find<CatelogDetailController>().set_text_bottom(
                          dataController.catelog_detail!.ecatalogDetail[index]
                              .flagViewProduct); //ส่งค่าไปที่ CatelogSetFirstPageController และไปที่ฟังก์ชัน set_text_bottom
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CatelogDetailListPage(
                                  channel:
                                      widget.channel)) //เปิดหน้า catelog detail
                          );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Stack(
                        children: [
                          //แสดงรูปภาพ
                          CachedNetworkImage(
                            imageUrl: dataController
                                .catelog_detail!.ecatalogDetail[index].pathImg,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                color: Colors.black.withOpacity(0.7),
                                child: Center(
                                  child: dataController
                                          .catelog_detail!
                                          .ecatalogDetail[index]
                                          .isShowPageNumber
                                      ? Padding(
                                          padding: const EdgeInsets.all(5),
                                          //แสดงเลขหน้า
                                          child: Text(
                                              '${MultiLanguages.of(context)!.translate('catalog_page_number')} ${index + 1}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11)),
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
