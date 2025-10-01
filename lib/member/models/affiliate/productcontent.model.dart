import 'dart:convert';
import 'package:fridayonline/member/models/affiliate/shopcontent.model.dart'
    as content; // ใช้ content.AffiliateProduct เดิม

// Helpers
AffiliateProductList affiliateProductListFromJson(String str) =>
    AffiliateProductList.fromJson(json.decode(str));

String affiliateProductListToJson(AffiliateProductList data) =>
    json.encode(data.toJson());

class AffiliateProductList {
  final String code;
  final ProductListData data;
  final String message;

  AffiliateProductList({
    required this.code,
    required this.data,
    required this.message,
  });

  factory AffiliateProductList.fromJson(Map<String, dynamic> json) {
    return AffiliateProductList(
      code: json['code'] ?? '',
      data: ProductListData.fromJson(
          (json['data'] ?? {}) as Map<String, dynamic>),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'data': data.toJson(),
        'message': message,
      };
}

class ProductListData {
  final int total;
  final List<content.AffiliateProduct> products;

  ProductListData({
    required this.total,
    required this.products,
  });

  factory ProductListData.fromJson(Map<String, dynamic> json) {
    final list = (json['products'] as List<dynamic>? ?? []);
    return ProductListData(
      total: json['total'] ?? 0,
      products: list
          .map((e) => content.AffiliateProduct.fromJson(
                e as Map<String, dynamic>,
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'products': products.map((e) => e.toJson()).toList(),
      };

  bool get isEmpty => products.isEmpty;
}
