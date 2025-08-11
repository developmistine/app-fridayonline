// // To parse this JSON data, do
// //
// //     final enduserregister = enduserregisterFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// Enduserregister enduserregisterFromJson(String str) =>
//     Enduserregister.fromJson(json.decode(str));

// String enduserregisterToJson(Enduserregister data) =>
//     json.encode(data.toJson());

// class Enduserregister {
//   Enduserregister({
//     required this.xml,
//     required this.value,
//   });

//   Xml xml;
//   Value value;

//   factory Enduserregister.fromJson(Map<String, dynamic> json) =>
//       Enduserregister(
//         xml: Xml.fromJson(json["?xml"]),
//         value: Value.fromJson(json["Value"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "?xml": xml.toJson(),
//         "Value": value.toJson(),
//       };
// }

// class Value {
//   Value({
//     required this.success,
//     required this.endUserid,
//     required this.enduserName,
//     required this.endusersurname,
//     required this.msl,
//     required this.description,
//   });

//   String success;
//   String endUserid;
//   String enduserName;
//   String endusersurname;
//   Msl msl;
//   Description description;

//   factory Value.fromJson(Map<String, dynamic> json) => Value(
//         success: json["success"] ?? "",
//         endUserid: json["EndUserid"] ?? "",
//         enduserName: json["EnduserName"] ?? "",
//         endusersurname: json["Endusersurname"] ?? "",
//         msl: Msl.fromJson(json["MSL"]),
//         description: Description.fromJson(json["Description"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "EndUserid": endUserid,
//         "EnduserName": enduserName,
//         "Endusersurname": endusersurname,
//         "MSL": msl.toJson(),
//         "Description": description.toJson(),
//       };
// }

// class Description {
//   Description({
//     required this.msg,
//   });

//   Msg msg;

//   factory Description.fromJson(Map<String, dynamic> json) => Description(
//         msg: Msg.fromJson(json["Msg"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "Msg": msg.toJson(),
//       };
// }

// class Msg {
//   Msg({
//     required this.msgAlert1,
//     required this.msgAlert2,
//     required this.msgAlert3,
//   });

//   String msgAlert1;
//   dynamic msgAlert2;
//   dynamic msgAlert3;

//   factory Msg.fromJson(Map<String, dynamic> json) => Msg(
//         msgAlert1: json["MsgAlert1"] ?? "",
//         msgAlert2: json["MsgAlert2"],
//         msgAlert3: json["MsgAlert3"],
//       );

//   Map<String, dynamic> toJson() => {
//         "MsgAlert1": msgAlert1,
//         "MsgAlert2": msgAlert2,
//         "MsgAlert3": msgAlert3,
//       };
// }

// class Msl {
//   Msl({
//     required this.repCode,
//     required this.repSeq,
//     required this.repName,
//     required this.repTel,
//   });

//   String repCode;
//   String repSeq;
//   String repName;
//   String repTel;

//   factory Msl.fromJson(Map<String, dynamic> json) => Msl(
//         repCode: json["RepCode"] ?? "",
//         repSeq: json["RepSeq"] ?? "",
//         repName: json["RepName"] ?? "",
//         repTel: json["RepTel"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "RepCode": repCode,
//         "RepSeq": repSeq,
//         "RepName": repName,
//         "RepTel": repTel,
//       };
// }

// class Xml {
//   Xml({
//     required this.version,
//     required this.encoding,
//   });

//   String version;
//   String encoding;

//   factory Xml.fromJson(Map<String, dynamic> json) => Xml(
//         version: json["@version"] ?? "",
//         encoding: json["@encoding"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "@version": version,
//         "@encoding": encoding,
//       };
// }

// To parse this JSON data, do
//
//     final enduserregister = enduserregisterFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

Enduserregister enduserregisterFromJson(String str) =>
    Enduserregister.fromJson(json.decode(str));

String enduserregisterToJson(Enduserregister data) =>
    json.encode(data.toJson());

class Enduserregister {
  Enduserregister({
    required this.value,
  });

  Value value;

  factory Enduserregister.fromJson(Map<String, dynamic> json) =>
      Enduserregister(
        value: Value.fromJson(json["Value"]),
      );

  Map<String, dynamic> toJson() => {
        "Value": value.toJson(),
      };
}

class Value {
  Value({
    required this.success,
    required this.endUserid,
    required this.enduserName,
    required this.endusersurname,
    required this.msl,
    required this.description,
    required this.studentData,
  });

  String success;
  String endUserid;
  String enduserName;
  String endusersurname;
  Msl msl;
  Description description;
  StudentData studentData;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        success: json["success"] ?? "",
        endUserid: json["EndUserid"] ?? "",
        enduserName: json["EnduserName"] ?? "",
        endusersurname: json["Endusersurname"] ?? "",
        msl: Msl.fromJson(json["MSL"]),
        description: Description.fromJson(json["Description"]),
        studentData: StudentData.fromJson(json["StudentData"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "EndUserid": endUserid,
        "EnduserName": enduserName,
        "Endusersurname": endusersurname,
        "MSL": msl.toJson(),
        "Description": description.toJson(),
        "StudentData": studentData.toJson(),
      };
}

class Description {
  Description({
    required this.msg,
  });

  Msg msg;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        msg: Msg.fromJson(json["Msg"]),
      );

  Map<String, dynamic> toJson() => {
        "Msg": msg.toJson(),
      };
}

class Msg {
  Msg({
    required this.msgAlert1,
    required this.msgAlert2,
    required this.msgAlert3,
  });

  String msgAlert1;
  String msgAlert2;
  String msgAlert3;

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(
        msgAlert1: json["MsgAlert1"] ?? "",
        msgAlert2: json["MsgAlert2"] ?? "",
        msgAlert3: json["MsgAlert3"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "MsgAlert1": msgAlert1,
        "MsgAlert2": msgAlert2,
        "MsgAlert3": msgAlert3,
      };
}

class Msl {
  Msl({
    required this.repCode,
    required this.repSeq,
    required this.repName,
    required this.repTel,
    required this.telnumber,
  });

  String repCode;
  String repSeq;
  String repName;
  String repTel;
  String telnumber;

  factory Msl.fromJson(Map<String, dynamic> json) => Msl(
        repCode: json["RepCode"] ?? "",
        repSeq: json["RepSeq"] ?? "",
        repName: json["RepName"] ?? "",
        repTel: json["RepTel"] ?? "",
        telnumber: json["Telnumber"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "RepCode": repCode,
        "RepSeq": repSeq,
        "RepName": repName,
        "RepTel": repTel,
        "Telnumber": telnumber,
      };
}

class StudentData {
  StudentData({
    required this.typeUser,
    required this.gmsl,
    required this.gEndUser,
    required this.gRefEndUser,
    required this.groupMsl,
    required this.groupEndUser,
    required this.groupRefEndUser,
  });

  String typeUser;
  String gmsl;
  String gEndUser;
  String gRefEndUser;
  Msl groupMsl;
  Msl groupEndUser;
  Msl groupRefEndUser;

  factory StudentData.fromJson(Map<String, dynamic> json) => StudentData(
        typeUser: json["TypeUser"] ?? "",
        gmsl: json["GMSL"] ?? "",
        gEndUser: json["GEndUser"] ?? "",
        gRefEndUser: json["GRefEndUser"] ?? "",
        groupMsl: Msl.fromJson(json["GroupMSL"]),
        groupEndUser: Msl.fromJson(json["GroupEndUser"]),
        groupRefEndUser: Msl.fromJson(json["GroupRefEndUser"]),
      );

  Map<String, dynamic> toJson() => {
        "TypeUser": typeUser,
        "GMSL": gmsl,
        "GEndUser": gEndUser,
        "GRefEndUser": gRefEndUser,
        "GroupMSL": groupMsl.toJson(),
        "GroupEndUser": groupEndUser.toJson(),
        "GroupRefEndUser": groupRefEndUser.toJson(),
      };
}
