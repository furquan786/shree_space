import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Backend/Request.dart';
import '../Backend/urls.dart';
import '../Model/homeadsmodel.dart';

class Buysellcontroller extends GetxController {
  Rx<TextEditingController> searchbar = TextEditingController().obs;

  Rx<Homeadsmodel> homeadsModel = Homeadsmodel().obs;

  void getHomeAdvertiseImage(String catname, String pcat) {
    print(urlBase + urlads);
    Request request = Request(
        url: urlBase + urlads,
        body: jsonEncode(<String, dynamic>{"catname": catname,"pcat": pcat}));
    request.post().then((value) {
      print(value.body);
      if (value.statusCode == 200) {
        homeadsModel.value =
            homeadsmodelFromJson(value.body);
      }
    });
  }
}
