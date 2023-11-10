import 'dart:async';

import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:html/parser.dart';
import 'package:shreegraphic/Backend/api_request.dart';

import '../Config/enums.dart';
import '../HomeScreen.dart';
import '../Model/news_category_model.dart';
import 'buysellanslistcategorydetailsui.dart';

class BuySellCatSearchscreenui extends StatefulWidget {
  // BuySellCatSearchscreenui({Key key}) : super(key: key);
  final UserType type;

  BuySellCatSearchscreenui({required this.type, Key? key}) : super(key: key);

  @override
  State<BuySellCatSearchscreenui> createState() =>
      _BuySellCatSearchscreenWidgetState();
}

class _BuySellCatSearchscreenWidgetState
    extends State<BuySellCatSearchscreenui> {
  TextEditingController searchTxt = TextEditingController();
  List<NewsCategoryModel> buysellList = [];
  bool isLoding = false;

  /*@override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }*/

  getBuysellList(String text) async {
    buysellList = [];
    final requestData = await API.buysellCategorySearchList(text);
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        buysellList.add(NewsCategoryModel.fromJson(i));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 700);
    final node = FocusScope.of(context);
    Size size = MediaQuery.of(context).size;
    void onTextChange(String text) {
      _debouncer.run(() {
        getBuysellList(text);
        setState(() {});
      });
    }

    return Scaffold(
        body: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  // tileMode: TileMode.clamp,
                  //transform: GradientRotation(math.pi / 4), Color(0xFF353A3F)
                  //  stops: [0.4, 1],
                  //0d0c22
                  colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
              /*gradient: linearGradient(
                  160, ['#262626 0%', "#000000 100%"]),*/
              /*  gradient: LinearGradient(
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  //transform: GradientRotation(math.pi / 4),
                  //stops: [0.4, 1],
                  colors: [Color(0xFF00444B), Color(0xFF00444B)]),*/
            ),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  SizedBox(height: size.height * 0.04),
                  Flexible(
                      child: SizedBox(
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: SizedBox(
                                width: size.width * 0.9,
                                child: TextField(
                                  onChanged: onTextChange,
                                  autofocus: true,
                                  onTap: () {
                                    node.unfocus();
                                    Get.to(BuySellCatSearchscreenui(
                                        type: widget.type));
                                  },
                                  controller: searchTxt,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  decoration: InputDecoration(
                                      hintText: "Search",
                                      hintStyle: const TextStyle(
                                          color: Colors.white70),
                                      prefixIcon: const Icon(Icons.search,
                                          color: Colors.white),
                                      fillColor: Colors.black54,
                                      filled: true,
                                      contentPadding: const EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  )),
                  buysellList == null
                      ? Center()
                      : buysellList.isEmpty
                          ? Center(
                              child: Text(
                              "No Data Found",
                              style: TextStyle(color: Colors.white),
                            ))
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext context, int i) {
                                    return const SizedBox(
                                      height: 8,
                                    );
                                  },
                                  itemCount: buysellList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(BuySelllistcategorydetailsui(
                                            index: buysellList[i].id.toString(),
                                            title:
                                                buysellList[i].name.toString(),
                                            type: widget.type));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                                begin:
                                                    FractionalOffset.bottomLeft,
                                                end: FractionalOffset
                                                    .bottomRight,
                                                transform: GradientRotation(
                                                    math.pi / 4),
                                                //stops: [0.4, 1],
                                                colors: [
                                                  Color(0xFF131416),
                                                  Color(0xFF151619),
                                                ]),
                                            //  color: Colors.black45,
                                            /* boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.3),
                                                // unit is some relative part of the canvas width
                                                offset: Offset(-0, -2),
                                                blurRadius: 7,
                                              ),
                                              BoxShadow(
                                                color: Colors.black45,
                                                offset: Offset(0, 2),
                                                blurRadius: 7,
                                              ),
                                            ],*/
                                            boxShadow: boxShadow,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Container(
                                                  height: 105,
                                                  width: size.width * 0.35,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "http://mmhomes.in/ShreeGraphic1/upload/buysell/" +
                                                                buysellList[i]
                                                                    .image,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircleAvatar(
                                                          backgroundColor:
                                                              Colors.black,
                                                          radius: 150,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      )),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, left: 12),
                                                child: Container(
                                                  height: 105,
                                                  width: size.width * 0.5,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Flexible(
                                                                        child: Text(
                                                                            buysellList[i]
                                                                                .name,
                                                                            textAlign: TextAlign
                                                                                .start,
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: const TextStyle(fontSize: 14, color: Colors.white))),
                                                                    Text(
                                                                        buysellList[i].count +
                                                                            " Post",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.grey))
                                                                  ]),
                                                              Flexible(
                                                                  child: Padding(
                                                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                                                      child: Text(_parseHtmlString(buysellList[i].description.toString()),
                                                                          maxLines: 4,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ))))
                                                            ]),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    );
                                  })),
                  const SizedBox(height: 20),
                ]))));
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
