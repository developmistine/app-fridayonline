import 'dart:convert';

AffiliateContent affiliateContentFromJson(String str) =>
    AffiliateContent.fromJson(json.decode(str));

String affiliateContentToJson(AffiliateContent data) =>
    json.encode(data.toJson());

class AffiliateContent {
  final String code;
  final List<ContentData> data;
  final String message;

  AffiliateContent({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AffiliateContent.fromJson(Map<String, dynamic> json) {
    return AffiliateContent(
      code: json['code'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ContentData.fromJson(e))
              .toList() ??
          [],
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class ContentData {
  final String scope; // "content" | "category"
  final String contentType; // "", "Image", "Text", "Video", "Category", ...
  final List<Item> items;

  ContentData({
    required this.scope,
    required this.contentType,
    required this.items,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    return ContentData(
      scope: json['scope'] ?? '',
      contentType: (json['content_type'] ?? '') as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => Item.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scope': scope,
      'content_type': contentType,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  // helper
  bool get isCategory => contentType == 'Category' || scope == 'category';
}

class Item {
  final int id;
  final bool displayName;
  final String name;
  final bool displayImage;
  final String images;
  final int totalProduct;
  final String status;
  final String description;

  final List<AffiliateProduct> attachedProduct;

  Item({
    required this.id,
    required this.displayName,
    required this.name,
    required this.displayImage,
    required this.images,
    required this.totalProduct,
    required this.status,
    required this.attachedProduct,
    required this.description,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    final ap = json['attached_product'];
    List<AffiliateProduct> parseAttached(dynamic v) {
      if (v is List) {
        return v
            .map((e) => AffiliateProduct.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <AffiliateProduct>[];
    }

    return Item(
      id: json['id'] ?? 0,
      displayName: json['display_name'] ?? false,
      name: json['name'] ?? '',
      displayImage: json['display_image'] ?? false,
      images: json['images'] ?? '',
      totalProduct: json['total_product'] ?? 0,
      status: json['status'] ?? '',
      attachedProduct: parseAttached(ap),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'name': name,
      'display_image': displayImage,
      'images': images,
      'total_product': totalProduct,
      'status': status,
      'attached_product': attachedProduct.map((e) => e.toJson()).toList(),
      'description': description
    };
  }

  bool get hasProducts => attachedProduct.isNotEmpty;
}

class AffiliateProduct {
  final String icon;
  final int productId;
  final String title;
  final num discount;
  final num price;
  final num priceBeforeDiscount;
  final List<dynamic> labels;
  final num ratingStar;
  final bool haveVideo;
  final String unitSales;
  final String image;
  final String currency;
  final bool isImageOverlayed;
  final String imageOverlay;
  final bool isOutOfStock;
  final String status;
  final String commission;

  AffiliateProduct({
    required this.icon,
    required this.productId,
    required this.title,
    required this.discount,
    required this.price,
    required this.priceBeforeDiscount,
    required this.labels,
    required this.ratingStar,
    required this.haveVideo,
    required this.unitSales,
    required this.image,
    required this.currency,
    required this.isImageOverlayed,
    required this.imageOverlay,
    required this.isOutOfStock,
    required this.status,
    required this.commission,
  });

  factory AffiliateProduct.fromJson(Map<String, dynamic> json) {
    return AffiliateProduct(
      icon: json['icon'] ?? '',
      productId: json['product_id'] ?? 0,
      title: json['title'] ?? '',
      discount: json['discount'] ?? 0,
      price: json['price'] ?? 0,
      priceBeforeDiscount: json['price_before_discount'] ?? 0,
      labels: (json['labels'] as List<dynamic>?) ?? const [],
      ratingStar: json['rating_star'] ?? 0,
      haveVideo: json['have_video'] ?? false,
      unitSales: json['unit_sales'] ?? '',
      image: json['image'] ?? '',
      currency: json['currency'] ?? '',
      isImageOverlayed: json['is_image_overlayed'] ?? false,
      imageOverlay: json['image_overlay'] ?? '',
      isOutOfStock: json['is_out_of_stock'] ?? false,
      status: json['status'] ?? '',
      commission: json['commission'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'product_id': productId,
      'title': title,
      'discount': discount,
      'price': price,
      'price_before_discount': priceBeforeDiscount,
      'labels': labels,
      'rating_star': ratingStar,
      'have_video': haveVideo,
      'unit_sales': unitSales,
      'image': image,
      'currency': currency,
      'is_image_overlayed': isImageOverlayed,
      'image_overlay': imageOverlay,
      'is_out_of_stock': isOutOfStock,
      'status': status,
      'commission': commission,
    };
  }
}

extension AffiliateProductX on AffiliateProduct {
  AffiliateProduct copyWith({
    String? icon,
    int? productId,
    String? title,
    num? discount,
    num? price,
    num? priceBeforeDiscount,
    List<dynamic>? labels,
    num? ratingStar,
    bool? haveVideo,
    String? unitSales,
    String? image,
    String? currency,
    bool? isImageOverlayed,
    String? imageOverlay,
    bool? isOutOfStock,
    String? status,
    String? commission,
  }) {
    return AffiliateProduct(
      icon: icon ?? this.icon,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      discount: discount ?? this.discount,
      price: price ?? this.price,
      priceBeforeDiscount: priceBeforeDiscount ?? this.priceBeforeDiscount,
      labels: labels ?? this.labels,
      ratingStar: ratingStar ?? this.ratingStar,
      haveVideo: haveVideo ?? this.haveVideo,
      unitSales: unitSales ?? this.unitSales,
      image: image ?? this.image,
      currency: currency ?? this.currency,
      isImageOverlayed: isImageOverlayed ?? this.isImageOverlayed,
      imageOverlay: imageOverlay ?? this.imageOverlay,
      isOutOfStock: isOutOfStock ?? this.isOutOfStock,
      status: status ?? this.status,
      commission: commission ?? this.commission,
    );
  }
}

extension ItemX on Item {
  Item copyWith({
    int? id,
    bool? displayName,
    String? name,
    bool? displayImage,
    String? images,
    int? totalProduct,
    String? status,
    String? description,
    List<AffiliateProduct>? attachedProduct,
  }) {
    return Item(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      name: name ?? this.name,
      displayImage: displayImage ?? this.displayImage,
      images: images ?? this.images,
      totalProduct: totalProduct ?? this.totalProduct,
      status: status ?? this.status,
      description: description ?? this.description,
      attachedProduct: attachedProduct ?? this.attachedProduct,
    );
  }
}

extension ContentDataX on ContentData {
  ContentData copyWith({
    String? scope,
    String? contentType,
    List<Item>? items,
  }) {
    return ContentData(
      scope: scope ?? this.scope,
      contentType: contentType ?? this.contentType,
      items: items ?? this.items,
    );
  }
}
