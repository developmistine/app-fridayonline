import 'dart:convert';

MarketCartBadger marketCartBadgerFromJson(String str) =>
    MarketCartBadger.fromJson(json.decode(str));

String marketCartBadgerToJson(MarketCartBadger data) =>
    json.encode(data.toJson());

class MarketCartBadger {
  MarketCartBadger({
    required this.badger,
  });

  String badger;

  factory MarketCartBadger.fromJson(Map<String, dynamic> json) =>
      MarketCartBadger(
        badger: json["Badger"] ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "Badger": badger,
      };
}
