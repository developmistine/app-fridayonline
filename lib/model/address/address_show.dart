import 'dart:convert';

AddressShow addressShowFromJson(String str) => AddressShow.fromJson(json.decode(str));

String addressShowToJson(AddressShow data) => json.encode(data.toJson());

class AddressShow {
    int showList;

    AddressShow({
        required this.showList,
    });

    factory AddressShow.fromJson(Map<String, dynamic> json) => AddressShow(
        showList: json["ShowList"],
    );

    Map<String, dynamic> toJson() => {
        "ShowList": showList,
    };
}
