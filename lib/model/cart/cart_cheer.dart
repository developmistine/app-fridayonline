// To parse this JSON data, do
//
//     final cheerCart = cheerCartFromJson(jsonString);

import 'dart:convert';

CheerCart cheerCartFromJson(String str) => CheerCart.fromJson(json.decode(str));

String cheerCartToJson(CheerCart data) => json.encode(data.toJson());

class CheerCart {
  String cheerMessage;
  String description;
  List<String> note;
  List<Detail> detail;
  PopUp popUp;

  CheerCart({
    required this.cheerMessage,
    required this.description,
    required this.note,
    required this.detail,
    required this.popUp,
  });

  factory CheerCart.fromJson(Map<String, dynamic> json) => CheerCart(
        cheerMessage: json["cheer_message"],
        description: json["description"],
        note: List<String>.from(json["note"].map((x) => x)),
        detail:
            List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
        popUp: PopUp.fromJson(json["pop_up"]),
      );

  Map<String, dynamic> toJson() => {
        "cheer_message": cheerMessage,
        "description": description,
        "note": List<dynamic>.from(note.map((x) => x)),
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
        "pop_up": popUp.toJson(),
      };
}

class Detail {
  String seqNo;
  String condition;
  String benefit;
  String percentage;
  String image;
  int price;
  bool show;

  Detail({
    required this.seqNo,
    required this.condition,
    required this.benefit,
    required this.percentage,
    required this.image,
    required this.price,
    required this.show,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        seqNo: json["seq_no"],
        condition: json["condition"],
        benefit: json["benefit"],
        percentage: json["percentage"],
        image: json["image"],
        price: json["price"],
        show: json["show"],
      );

  Map<String, dynamic> toJson() => {
        "seq_no": seqNo,
        "condition": condition,
        "benefit": benefit,
        "percentage": percentage,
        "image": image,
        "price": price,
        "show": show,
      };
}

class PopUp {
  String title;
  String subtitle;
  String description;

  PopUp({
    required this.title,
    required this.subtitle,
    required this.description,
  });

  factory PopUp.fromJson(Map<String, dynamic> json) => PopUp(
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "description": description,
      };
}
