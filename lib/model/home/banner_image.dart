import 'dart:convert';

HomeBanner homeBannerFromJson(String str) =>
    HomeBanner.fromJson(json.decode(str));

String homeBannerToJson(HomeBanner data) => json.encode(data.toJson());

class HomeBanner {
  HomeBanner({
    required this.repCode,
    required this.repType,
    required this.repSeq,
    required this.banner,
  });

  String repCode;
  String repType;
  String repSeq;
  List<Banner> banner;

  factory HomeBanner.fromJson(Map<String, dynamic> json) => HomeBanner(
        repCode: json["RepCode"] ?? "",
        repType: json["RepType"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        banner: json["Banner"] == null
            ? []
            : List<Banner>.from(json["Banner"].map((x) => Banner.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepType": repType,
        "RepSeq": repSeq,
        "Banner": List<dynamic>.from(banner.map((x) => x.toJson())),
      };
}

class Banner {
  Banner({
    required this.id,
    required this.contentName,
    required this.contentIndcx,
    required this.keyindex,
    required this.contentImg,
    required this.campaign,
    required this.band,
    required this.meberCode,
    required this.fsCode,
  });

  String id;
  String contentName;
  String contentIndcx;
  String keyindex;
  String contentImg;
  String campaign;
  String band;
  String meberCode;
  String fsCode;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        id: json["id"] ?? "",
        contentName: json["content_name"] ?? "",
        contentIndcx: json["content_indcx"] ?? "",
        keyindex: json["keyindex"] ?? "",
        contentImg: json["content_img"] ?? "",
        campaign: json["campaign"] ?? "",
        band: json["band"] ?? "",
        meberCode: json["meber_code"] ?? "",
        fsCode: json["fs_code"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content_name": contentName,
        "content_indcx": contentIndcx,
        "keyindex": keyindex,
        "content_img": contentImg,
        "campaign": campaign,
        "band": band,
        "meber_code": meberCode,
        "fs_code": fsCode,
      };
}
