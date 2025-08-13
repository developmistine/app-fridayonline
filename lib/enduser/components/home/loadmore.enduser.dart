import 'package:appfridayecommerce/enduser/components/shimmer/shimmer.product.dart';
import 'package:appfridayecommerce/enduser/controller/enduser.home.ctr.dart';
import 'package:appfridayecommerce/enduser/controller/showproduct.sku.ctr.dart';
import 'package:appfridayecommerce/enduser/utils/cached_image.dart';
import 'package:appfridayecommerce/enduser/utils/format.dart';
import 'package:appfridayecommerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final EndUserHomeCtr endUserHomeCtr = Get.find();
final _scrollController = ScrollController();

class LoadmoreEndUser extends StatelessWidget {
  const LoadmoreEndUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return !endUserHomeCtr.isLoadingLoadmore.value
          ? buildOptimizedGrid()
          : MasonryGridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              shrinkWrap: true,
              primary: false,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (Get.width >= 768.0) ? 4 : 2,
              ),
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) {
                return const ShimmerProductItem();
              });
    });
  }
}

// ปรับปรุง MasonryGridView ให้มี Memory Management
Widget buildOptimizedGrid() {
  return Container(
    color: Colors.grey[100],
    child: Column(
      children: [
        MasonryGridView.builder(
          addAutomaticKeepAlives: false,
          key: const PageStorageKey('recommend-grid'),
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          shrinkWrap: true,
          primary: false,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          cacheExtent: 500, // จำกัดการ cache widgets
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (Get.width >= 768.0) ? 4 : 2,
          ),
          itemCount: endUserHomeCtr.recommend!.data.length +
              (endUserHomeCtr.isFetchingLoadmore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < endUserHomeCtr.recommend!.data.length) {
              var recommend = endUserHomeCtr.recommend!.data[index];
              return ProductCard(
                recommend: recommend,
                onTap: () {
                  Get.find<ShowProductSkuCtr>().fetchB2cProductDetail(
                      recommend.productId, 'home_recommend');
                  Get.toNamed('/ShowProductSku/${recommend.productId}');
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        Obx(() {
          if (endUserHomeCtr.isFetchingLoadmore.value) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Text(
                'กำลังโหลด...',
                style: TextStyle(color: themeColorDefault),
              ),
            );
          } else {
            return const SizedBox();
          }
        })
      ],
    ),
  );
}

class ProductCard extends StatelessWidget {
  final dynamic recommend;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.recommend,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 2, right: 2, bottom: 2, top: 0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSection(),
                      _buildContentSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (recommend.discount > 0) _buildDiscountBadge(),
      ],
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          CacheImageProducts(url: recommend.image),
          if (recommend.isOutOfStock) _buildOutOfStockOverlay(),
          if (recommend.isImageOverlayed)
            CacheImageOverlay(url: recommend.imageOverlay),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 4),
          if (recommend.ratingStar > 0) _buildRating(),
          const SizedBox(height: 4),
          _buildPriceSection(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    if (recommend.icon == "") {
      return Text(
        recommend.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.notoSansThaiLooped(
          fontSize: 14,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
      );
    } else {
      return Stack(
        children: [
          Container(
            height: 20,
            width: 20,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(2),
            child: CacheImageLogoShop(url: recommend.icon),
          ),
          Text(
            "      ${recommend.title}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSansThaiLooped(
              fontSize: 14,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildRating() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        border: Border.all(color: Colors.yellow, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBarIndicator(
            itemSize: 8,
            rating: 1,
            direction: Axis.horizontal,
            itemCount: 1,
            itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
            itemBuilder: (context, index) => Image.asset(
              'assets/images/review/fullStar.png',
              color: Colors.amber,
            ),
          ),
          Text(
            '${recommend.ratingStar}',
            style: GoogleFonts.notoSansThaiLooped(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        recommend.discount > 0 ? _buildDiscountPrice() : _buildRegularPrice(),
        Text(
          recommend.unitSales,
          style: GoogleFonts.notoSansThaiLooped(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildDiscountPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "฿${myFormat.format(recommend.price)}",
          style: GoogleFonts.notoSansThaiLooped(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange.shade700,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          "฿${myFormat.format(recommend.priceBeforeDiscount)}",
          style: GoogleFonts.notoSansThaiLooped(
            fontSize: 11,
            decoration: TextDecoration.lineThrough,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildRegularPrice() {
    return Text(
      "฿${myFormat.format(recommend.priceBeforeDiscount)}",
      style: GoogleFonts.notoSansThaiLooped(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.deepOrange.shade700,
      ),
    );
  }

  Widget _buildDiscountBadge() {
    return Container(
      margin: const EdgeInsets.only(right: 3, top: 3.2),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
      ),
      child: Text(
        "- ${myFormat.format(recommend.discount)}%",
        style: GoogleFonts.notoSansThaiLooped(
          color: Colors.deepOrange,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildOutOfStockOverlay() {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircleAvatar(
          backgroundColor: Colors.black54,
          child: Center(
            child: Text(
              'สินค้าหมด',
              style: GoogleFonts.notoSansThaiLooped(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
