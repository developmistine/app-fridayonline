import 'package:fridayonline/enduser/components/shimmer/shimmer.card.dart';
import 'package:fridayonline/enduser/components/shimmer/shimmer.product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class LoadingProductDetail extends StatelessWidget {
  const LoadingProductDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: Get.width,
                height: Get.height * 0.45,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200))),
              ),
              Image.asset(
                'assets/images/b2c/logo/logo_bg.png',
                width: 100,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ShimmerCard(
              width: 150,
              height: 20,
              radius: 0,
              color: Colors.grey.shade200,
            ),
          ),
          const Divider(
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerCard(
                  width: 150,
                  height: 10,
                  radius: 2,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(
                  height: 4,
                ),
                ShimmerCard(
                  width: 250,
                  height: 10,
                  radius: 2,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerCard(
                  width: 30,
                  height: 10,
                  radius: 2,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(
                  height: 4,
                ),
                ShimmerCard(
                  width: 50,
                  height: 10,
                  radius: 2,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ShimmerCard(
                  width: Get.width,
                  height: Get.height / 6,
                  radius: 2,
                  color: Colors.grey.shade100,
                ),
                Image.asset(
                  'assets/images/b2c/logo/logo_bg.png',
                  width: 40,
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerCard(
                  width: 150,
                  height: 10,
                  radius: 2,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(
                  height: 4,
                ),
                ShimmerCard(
                  width: 250,
                  height: 10,
                  radius: 2,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          MasonryGridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              shrinkWrap: true,
              primary: false,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (Get.width >= 768.0) ? 4 : 2,
              ),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return const ShimmerProductItem();
              })
        ],
      ),
    );
  }
}
