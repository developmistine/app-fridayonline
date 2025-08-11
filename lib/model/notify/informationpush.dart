// // // To parse this JSON data, do
// // //
// // //     final informationPushNotify = informationPushNotifyFromJson(jsonString);

// // import 'dart:convert';

// // InformationPushNotify informationPushNotifyFromJson(String str) =>
// //     InformationPushNotify.fromJson(json.decode(str));

// // String informationPushNotifyToJson(InformationPushNotify data) =>
// //     json.encode(data.toJson());

// // class InformationPushNotify {
// //   InformationPushNotify({
// //     required this.informationPushNotify,
// //   });

// //   List<InformationPushNotifyElement> informationPushNotify;

// //   factory InformationPushNotify.fromJson(Map<String, dynamic> json) =>
// //       InformationPushNotify(
// //         informationPushNotify: List<InformationPushNotifyElement>.from(
// //             json["InformationPushNotify"]
// //                 .map((x) => InformationPushNotifyElement.fromJson(x))),
// //       );

// //   Map<String, dynamic> toJson() => {
// //         "InformationPushNotify":
// //             List<dynamic>.from(informationPushNotify.map((x) => x.toJson())),
// //       };
// // }

// // class InformationPushNotifyElement {
// //   InformationPushNotifyElement({
// //     required this.status,
// //     required this.message,
// //     required this.countBadger,
// //     required this.notify,
// //     required this.orderList,
// //   });

// //   String status;
// //   String message;
// //   String countBadger;
// //   List<Notify> notify;
// //   dynamic orderList;

// //   factory InformationPushNotifyElement.fromJson(Map<String, dynamic> json) =>
// //       InformationPushNotifyElement(
// //         status: json["Status"],
// //         message: json["Message"],
// //         countBadger: json["CountBadger"],
// //         notify:
// //             List<Notify>.from(json["Notify"].map((x) => Notify.fromJson(x))),
// //         orderList: json["OrderList"],
// //       );

// //   Map<String, dynamic> toJson() => {
// //         "Status": status,
// //         "Message": message,
// //         "CountBadger": countBadger,
// //         "Notify": List<dynamic>.from(notify.map((x) => x.toJson())),
// //         "OrderList": orderList,
// //       };
// // }

// // class Notify {
// //   Notify({
// //     required this.id,
// //     required this.idgroup,
// //     required this.idindex,
// //     required this.title,
// //     required this.desc,
// //     required this.imgContent,
// //     required this.type,
// //     required this.numShow,
// //     required this.parameterContent,
// //     required this.parameterKey,
// //     required this.link,
// //     required this.badger,
// //     required this.date,
// //     required this.linkimg,
// //     required this.linkindex,
// //     required this.readStatus,
// //   });

// //   String id;
// //   String idgroup;
// //   String idindex;
// //   String title;
// //   String desc;
// //   String imgContent;
// //   String type;
// //   String numShow;
// //   String parameterContent;
// //   String parameterKey;
// //   String link;
// //   String badger;
// //   String date;
// //   String linkimg;
// //   String linkindex;
// //   String readStatus;

// //   factory Notify.fromJson(Map<String, dynamic> json) => Notify(
// //         id: json["Id"] ?? "",
// //         idgroup: json["Idgroup"] ?? "",
// //         idindex: json["Idindex"] ?? "",
// //         title: json["Title"] ?? "",
// //         desc: json["Desc"] ?? "",
// //         imgContent: json["ImgContent"] ?? "",
// //         type: json["Type"] ?? "",
// //         numShow: json["NumShow"] ?? "",
// //         parameterContent: json["ParameterContent"] ?? "",
// //         parameterKey: json["ParameterKey"] ?? "",
// //         link: json["Link"] ?? "",
// //         badger: json["Badger"] ?? "",
// //         date: json["Date"] ?? "",
// //         linkimg: json["Linkimg"] ?? "",
// //         linkindex: json["Linkindex"] ?? "",
// //         readStatus: json["ReadStatus"] ?? "",
// //       );

// //   Map<String, dynamic> toJson() => {
// //         "Id": id,
// //         "Idgroup": idgroup,
// //         "Idindex": idindex,
// //         "Title": title,
// //         "Desc": desc,
// //         "ImgContent": imgContent,
// //         "Type": type,
// //         "NumShow": numShow,
// //         "ParameterContent": parameterContent,
// //         "ParameterKey": parameterKey,
// //         "Link": link,
// //         "Badger": badger,
// //         "Date": date,
// //         "Linkimg": linkimg,
// //         "Linkindex": linkindex,
// //         "ReadStatus": readStatus,
// //       };
// // }

// // To parse this JSON data, do
// //
// //     final informationPushNotify = informationPushNotifyFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// InformationPushNotify informationPushNotifyFromJson(String str) =>
//     InformationPushNotify.fromJson(json.decode(str));

// String informationPushNotifyToJson(InformationPushNotify data) =>
//     json.encode(data.toJson());

// class InformationPushNotify {
//   InformationPushNotify({
//     required this.informationPushNotify,
//   });

//   List<InformationPushNotifyElement> informationPushNotify;

//   factory InformationPushNotify.fromJson(Map<String, dynamic> json) =>
//       InformationPushNotify(
//         informationPushNotify: List<InformationPushNotifyElement>.from(
//             json["InformationPushNotify"]
//                 .map((x) => InformationPushNotifyElement.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "InformationPushNotify":
//             List<dynamic>.from(informationPushNotify.map((x) => x.toJson())),
//       };
// }

// class InformationPushNotifyElement {
//   InformationPushNotifyElement({
//     required this.status,
//     required this.message,
//     required this.countBadger,
//     required this.notify,
//     required this.orderList,
//   });

//   String status;
//   String message;
//   String countBadger;
//   List<Notify> notify;
//   List<dynamic> orderList;

//   factory InformationPushNotifyElement.fromJson(Map<String, dynamic> json) =>
//       InformationPushNotifyElement(
//         status: json["Status"],
//         message: json["Message"],
//         countBadger: json["CountBadger"],
//         notify: json["Notify"] == null
//             ? []
//             : List<Notify>.from(json["Notify"].map((x) => Notify.fromJson(x))),
//         orderList: json["OrderList"] == null
//             ? []
//             : List<dynamic>.from(json["OrderList"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "Status": status,
//         "Message": message,
//         "CountBadger": countBadger,
//         "Notify": List<dynamic>.from(notify.map((x) => x.toJson())),
//         "OrderList": List<dynamic>.from(orderList.map((x) => x)),
//       };
// }

// class Notify {
//   Notify({
//     required this.id,
//     required this.idgroup,
//     required this.idindex,
//     required this.title,
//     required this.desc,
//     required this.imgContent,
//     required this.type,
//     required this.numShow,
//     required this.parameterContent,
//     required this.parameterKey,
//     required this.link,
//     required this.badger,
//     required this.date,
//     required this.linkimg,
//     required this.linkindex,
//     required this.readStatus,
//   });

//   String id;
//   String idgroup;
//   String idindex;
//   String title;
//   String desc;
//   String imgContent;
//   String type;
//   String numShow;
//   String parameterContent;
//   String parameterKey;
//   String link;
//   String badger;
//   DateTime date;
//   String linkimg;
//   String linkindex;
//   String readStatus;

//   factory Notify.fromJson(Map<String, dynamic> json) => Notify(
//         id: json["Id"],
//         idgroup: json["Idgroup"],
//         idindex: json["Idindex"],
//         title: json["Title"],
//         desc: json["Desc"],
//         imgContent: json["ImgContent"],
//         type: json["Type"],
//         numShow: json["NumShow"],
//         parameterContent: json["ParameterContent"],
//         parameterKey: json["ParameterKey"],
//         link: json["Link"],
//         badger: json["Badger"],
//         date: DateTime.parse(json["Date"]),
//         linkimg: json["Linkimg"],
//         linkindex: json["Linkindex"],
//         readStatus: json["ReadStatus"],
//       );

//   Map<String, dynamic> toJson() => {
//         "Id": id,
//         "Idgroup": idgroup,
//         "Idindex": idindex,
//         "Title": title,
//         "Desc": desc,
//         "ImgContent": imgContent,
//         "Type": type,
//         "NumShow": numShow,
//         "ParameterContent": parameterContent,
//         "ParameterKey": parameterKey,
//         "Link": link,
//         "Badger": badger,
//         "Date": date.toIso8601String(),
//         "Linkimg": linkimg,
//         "Linkindex": linkindex,
//         "ReadStatus": readStatus,
//       };
// }

// To parse this JSON data, do
//
//     final informationPushNotify = informationPushNotifyFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

InformationPushNotify informationPushNotifyFromJson(String str) =>
    InformationPushNotify.fromJson(json.decode(str));

String informationPushNotifyToJson(InformationPushNotify data) =>
    json.encode(data.toJson());

class InformationPushNotify {
  InformationPushNotify({
    required this.informationPushNotify,
  });

  List<InformationPushNotifyElement> informationPushNotify;

  factory InformationPushNotify.fromJson(Map<String, dynamic> json) =>
      InformationPushNotify(
        informationPushNotify: json["InformationPushNotify"] == null
            ? []
            : List<InformationPushNotifyElement>.from(
                json["InformationPushNotify"]
                    .map((x) => InformationPushNotifyElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "InformationPushNotify":
            List<dynamic>.from(informationPushNotify.map((x) => x.toJson())),
      };
}

class InformationPushNotifyElement {
  InformationPushNotifyElement({
    required this.status,
    required this.message,
    required this.countBadger,
    required this.notify,
    required this.orderList,
  });

  String status;
  String message;
  String countBadger;
  List<Notify> notify;
  List<dynamic> orderList;

  factory InformationPushNotifyElement.fromJson(Map<String, dynamic> json) =>
      InformationPushNotifyElement(
        status: json["Status"] ?? "",
        message: json["Message"] ?? "",
        countBadger: json["CountBadger"] ?? "",
        notify: json["Notify"] == null
            ? []
            : List<Notify>.from(json["Notify"].map((x) => Notify.fromJson(x))),
        orderList: json["OrderList"] == null
            ? []
            : List<dynamic>.from(json["OrderList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "CountBadger": countBadger,
        "Notify": List<dynamic>.from(notify.map((x) => x.toJson())),
        "OrderList": List<dynamic>.from(orderList.map((x) => x)),
      };
}

class Notify {
  Notify({
    required this.id,
    required this.idgroup,
    required this.idindex,
    required this.title,
    required this.desc,
    required this.imgContent,
    required this.type,
    required this.numShow,
    required this.parameterContent,
    required this.parameterKey,
    required this.link,
    required this.badger,
    required this.date,
    required this.linkimg,
    required this.linkindex,
    required this.readStatus,
  });

  String id;
  String idgroup;
  String idindex;
  String title;
  String desc;
  String imgContent;
  String type;
  String numShow;
  String parameterContent;
  String parameterKey;
  String link;
  String badger;
  String date;
  String linkimg;
  String linkindex;
  String readStatus;

  factory Notify.fromJson(Map<String, dynamic> json) => Notify(
        id: json["Id"] ?? "",
        idgroup: json["Idgroup"] ?? "",
        idindex: json["Idindex"] ?? "",
        title: json["Title"] ?? "",
        desc: json["Desc"] ?? "",
        imgContent: json["ImgContent"] ?? "",
        type: json["Type"] ?? "",
        numShow: json["NumShow"] ?? "",
        parameterContent: json["ParameterContent"] ?? "",
        parameterKey: json["ParameterKey"] ?? "",
        link: json["Link"] ?? "",
        badger: json["Badger"] ?? "",
        date: json["Date"] ?? "",
        linkimg: json["Linkimg"] ?? "",
        linkindex: json["Linkindex"] ?? "",
        readStatus: json["ReadStatus"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Idgroup": idgroup,
        "Idindex": idindex,
        "Title": title,
        "Desc": desc,
        "ImgContent": imgContent,
        "Type": type,
        "NumShow": numShow,
        "ParameterContent": parameterContent,
        "ParameterKey": parameterKey,
        "Link": link,
        "Badger": badger,
        "Date": date,
        "Linkimg": linkimg,
        "Linkindex": linkindex,
        "ReadStatus": readStatus,
      };
}
