import 'package:fridayonline/member/controller/showproduct.category.ctr.dart';
import 'package:fridayonline/member/models/category/category.model.dart';
import 'package:fridayonline/member/views/(showproduct)/show.category.view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ShowProductCategoryCtr showCategoryCtr = Get.find();

Expanded categoryListItems(Datum subcategory) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5.0,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 5.0,
              mainAxisExtent: 150),
          itemCount: subcategory.categoryDetail.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                showCategoryCtr.fetchProductByCategoryId(
                    2,
                    subcategory.categoryDetail[index].subcategoryId.toString(),
                    0);
                Get.to(() => const ShowProductCategory());
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(14, 0, 0, 0),
                        offset: Offset(0.0, 4.0),
                        blurRadius: 0.2,
                        spreadRadius: 0.2,
                      ), //BoxShadow
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            return Icon(
                              Icons.image_not_supported_rounded,
                              color: Colors.grey.shade200,
                              size: 50,
                            );
                          },
                          imageUrl:
                              subcategory.categoryDetail[index].subcategoryImg,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                                subcategory.categoryDetail[index].subcategory,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    ),
  );
}
