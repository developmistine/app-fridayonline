// To parse this JSON data, do
//
//     final endUserProductOptions = endUserProductOptionsFromJson(jsonString);

import 'dart:convert';

EndUserProductOptions endUserProductOptionsFromJson(String str) =>
    EndUserProductOptions.fromJson(json.decode(str));

String endUserProductOptionsToJson(EndUserProductOptions data) =>
    json.encode(data.toJson());

class EndUserProductOptions {
  int custId;
  int productId;
  int shopId;
  int quantity;
  List<SelectedTier> selectedTiers;

  EndUserProductOptions({
    required this.productId,
    required this.custId,
    required this.shopId,
    required this.quantity,
    required this.selectedTiers,
  });

  factory EndUserProductOptions.fromJson(Map<String, dynamic> json) =>
      EndUserProductOptions(
        productId: json["product_id"],
        custId: json["cust_id"],
        shopId: json["shop_id"],
        quantity: json["quantity"],
        selectedTiers: List<SelectedTier>.from(
            json["selected_tiers"].map((x) => SelectedTier.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cust_id": custId,
        "product_id": productId,
        "shop_id": shopId,
        "quantity": quantity,
        "selected_tiers":
            List<dynamic>.from(selectedTiers.map((x) => x.toJson())),
      };
}

class SelectedTier {
  int key;
  int value;

  SelectedTier({
    required this.key,
    required this.value,
  });

  factory SelectedTier.fromJson(Map<String, dynamic> json) => SelectedTier(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
