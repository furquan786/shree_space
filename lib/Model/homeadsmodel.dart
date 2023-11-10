// To parse this JSON data, do
//
//     final homevideomodel = homevideomodelFromJson(jsonString);

import 'dart:convert';

Homeadsmodel homeadsmodelFromJson(String str) =>
    Homeadsmodel.fromJson(json.decode(str));

String homeadsmodelToJson(Homeadsmodel data) => json.encode(data.toJson());

class Homeadsmodel {
  Homeadsmodel({
    this.status = 0,
    this.result = const [],
    this.msg = "",
  });

  int status = 0;
  List<Result> result = [];
  String msg = "";

  factory Homeadsmodel.fromJson(Map<String, dynamic> json) => Homeadsmodel(
        status: json["status"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "msg": msg,
      };
}

class Result {
  Result({
    required this.id,
    required this.category,
    required this.image,
    required this.type,
    required this.link,
    required this.mobile,
  });

  String id;
  String category;
  String image;
  String type;
  String link;
  String mobile;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        category: json["category"],
        image: json["image"],
        type: json["type"],
        link: json["link"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "image": image,
        "type": type,
        "link": link,
        "mobile": mobile,
      };
}
