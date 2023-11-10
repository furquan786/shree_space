import 'dart:convert';

import 'package:flutter/cupertino.dart';

class QuotationModel {
  String id;
  String qot_id;
  String requirement;
  String amount;
  String remark;
  String name;
  bool selec;

  QuotationModel(
      {required this.id,
      required this.qot_id,
      required this.requirement,
      required this.amount,
      required this.remark,
      required this.name,
      required this.selec});

  factory QuotationModel.fromJson(Map<String, dynamic> json) {
    return QuotationModel(
        id: json['id'],
        qot_id: json['qot_id'],
        requirement: json['requirement'] ?? "",
        amount: json['amount'] ?? "",
        remark: json['remark'] ?? "",
        name: json['name'] ?? "",
        selec: json['selec'] ?? false);
  }

  @override
  String toString() {
    return toJson().toString();
  }
  /* factory QuotationModel.fromJson(Map<String, dynamic> addjson) {
    return QuotationModel(
        category: addjson["category"],
        brand : addjson['brand'],
        equipment : addjson['equipment']
    );
  }
   QuotationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qot_id = json['qot_id'];
    requirement = json['requirement'];
    amount = json['amount'] ??"";
    remark = json['remark'];
    name = json['name'];
    selec = json['selec'];
  }
  */
  /*QuotationModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    brand = json['brand'];
    equipment = json['equipment'];
  }*/

  /* List<QuotationModel> fromList(var list) {
    print("Hello $list");

    List<QuotationModel> li = [];
    for (var i in list) {
      li.add(QuotationModel.fromJson(i));
    }
    return li;
  }*/

  static List<QuotationModel> fromList(var list) {
    //list = json.decode(list);
    /*Future<List<QuotationModel>> futureData = Future.value(list
        .map((data) => QuotationModel.fromJson(data))
        .toList());*/
    /* List<QuotationModel> users = (json.decode(list))
        .map((data) => QuotationModel.fromJson(data))
        .toList();*/

    print("Hello $list");

    List<QuotationModel> li = [];
    for (var i in list) {
      li.add(QuotationModel.fromJson(i));
    }
    return li;
  }

  static List<Map<String, dynamic>> fromListToJson(List<QuotationModel> list) {
    List<Map<String, dynamic>> mapList = [];
    for (var i in list) {
      mapList.add(i.toJson());
    }
    return mapList;
  }

  set setRequirement(String cat) {
    this.requirement = cat;
  }

  set setAmount(String brd) {
    this.amount = brd;
  }

  set setRemark(String equ) {
    this.remark = equ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requirement'] = this.requirement;
    data['amount'] = this.amount;
    data['remark'] = this.remark;

    return data;
  }
}
