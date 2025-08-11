// To parse this JSON data, do
//
//     final specialProductLoadMore = specialProductLoadMoreFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

SpecialProductLoadMore specialProductLoadMoreFromJson(String str) =>
    SpecialProductLoadMore.fromJson(json.decode(str));

String specialProductLoadMoreToJson(SpecialProductLoadMore data) =>
    json.encode(data.toJson());

class SpecialProductLoadMore {
  SpecialProductLoadMore({
    required this.repCode,
    required this.repType,
    required this.repSeq,
    required this.listProductDetail,
  });

  String repCode;
  String repType;
  String repSeq;
  List<ListProductDetail> listProductDetail;

  factory SpecialProductLoadMore.fromJson(Map<String, dynamic> json) =>
      SpecialProductLoadMore(
        repCode: json["RepCode"] ?? "",
        repType: json["RepType"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        listProductDetail: json["ListProductDetail"] == null
            ? []
            : List<ListProductDetail>.from(json["ListProductDetail"]
                .map((x) => ListProductDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepType": repType,
        "RepSeq": repSeq,
        "ListProductDetail":
            List<dynamic>.from(listProductDetail.map((x) => x.toJson())),
      };
}

class ListProductDetail {
  ListProductDetail({
    required this.id,
    required this.contentName,
    required this.typePages,
    required this.typeContent,
    required this.contentIndcx,
    required this.keyindex,
    required this.contentImg,
    required this.contentImgondestop,
    required this.status,
    required this.campaign,
    required this.band,
    required this.meberCode,
    required this.showBy,
    required this.startdate,
    required this.enddate,
    required this.startCampaign,
    required this.endCampaign,
    required this.showtype,
    required this.fsCode,
    required this.fsCodetemp,
  });

  String id;
  String contentName;
  String typePages;
  String typeContent;
  String contentIndcx;
  String keyindex;
  String contentImg;
  String contentImgondestop;
  String status;
  String campaign;
  String band;
  String meberCode;
  String showBy;
  String startdate;
  String enddate;
  String startCampaign;
  String endCampaign;
  String showtype;
  String fsCode;
  String fsCodetemp;

  factory ListProductDetail.fromJson(Map<String, dynamic> json) =>
      ListProductDetail(
        id: json["id"] ?? "",
        contentName: json["content_name"] ?? "",
        typePages: json["type_pages"] ?? "",
        typeContent: json["type_content"] ?? "",
        contentIndcx: json["content_indcx"] ?? "",
        keyindex: json["keyindex"] ?? "",
        contentImg: json["content_img"] ?? "",
        contentImgondestop: json["content_imgondestop"] ?? "",
        status: json["status"] ?? "",
        campaign: json["campaign"] ?? "",
        band: json["band"] ?? "",
        meberCode: json["meber_code"] ?? "",
        showBy: json["show_by"] ?? "",
        startdate: json["startdate"] ?? "",
        enddate: json["enddate"] ?? "",
        startCampaign: json["start_campaign"] ?? "",
        endCampaign: json["end_campaign"] ?? "",
        showtype: json["showtype"] ?? "",
        fsCode: json["fs_code"] ?? "",
        fsCodetemp: json["fs_codetemp"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content_name": contentName,
        "type_pages": typePages,
        "type_content": typeContent,
        "content_indcx": contentIndcx,
        "keyindex": keyindex,
        "content_img": contentImg,
        "content_imgondestop": contentImgondestop,
        "status": status,
        "campaign": campaign,
        "band": band,
        "meber_code": meberCode,
        "show_by": showBy,
        "startdate": startdate,
        "enddate": enddate,
        "start_campaign": startCampaign,
        "end_campaign": endCampaign,
        "showtype": showtype,
        "fs_code": fsCode,
        "fs_codetemp": fsCodetemp,
      };
}
