import 'package:fridayonline/member/components/shimmer/shimmer.card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShimmerProductItem extends StatelessWidget {
  const ShimmerProductItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: SizedBox(
                    width: 100,
                    height: 140,
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 50,
                    color: Colors.grey.shade100,
                  ),
                ),
              ],
            )),
            const SizedBox(height: 12),
            ShimmerCard(
              width: Get.width,
              height: 8,
              radius: 8,
              color: Colors.grey.shade100,
            ),
            const SizedBox(height: 4),
            ShimmerCard(
              width: Get.width,
              height: 8,
              radius: 8,
              color: Colors.grey.shade100,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerCard(
                        width: 40,
                        height: 16,
                        radius: 0,
                        color: Colors.grey.shade100,
                      ),
                      const SizedBox(height: 8),
                      ShimmerCard(
                        width: 70,
                        height: 10,
                        radius: 8,
                        color: Colors.grey.shade100,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: ShimmerCard(
                  width: 50,
                  height: 10,
                  radius: 8,
                  color: Colors.grey.shade100,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
