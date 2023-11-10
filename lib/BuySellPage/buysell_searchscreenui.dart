import 'dart:async';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Backend/api_request.dart';
import '../Config/enums.dart';
import '../HomeScreen.dart';
import '../Model/buysell_list_model.dart';
import 'buyselldetailsui.dart';
import 'package:html/parser.dart';

class BuySellSearchscreenui extends StatefulWidget {
  final UserType type;

  BuySellSearchscreenui({required this.type, Key? key}) : super(key: key);
  //BuySellSearchscreenui({Key key}) : super(key: key);

  @override
  State<BuySellSearchscreenui> createState() =>
      _BuySellSearchscreenWidgetState();
}

class _BuySellSearchscreenWidgetState extends State<BuySellSearchscreenui> {
  TextEditingController searchTxt = TextEditingController();
  String message = "";
  String langDropdownValue = "";
  List<BuysellListModel> buysellList = [];
  List<String> productImages = [];
  final _debouncer = Debouncer(milliseconds: 700);
  @override
  void dispose() {
    super.dispose();
    /* if(_debouncer != null){
      _debouncer.dispose();
      super.dispose();
    }*/
  }

  void onTextChange(String text) {
    _debouncer.run(() {
      getQueanList(text);
      setState(() {});
    });
  }

  getQueanList(String text) async {
    buysellList = [];
    final requestData = await API.buysellSearchList(text);
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        buysellList.add(BuysellListModel.fromJson(i));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    Size size = MediaQuery.of(context).size;
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
              /*  gradient: linearGradient(
                  160, ['#262626 0%', "#000000 100%"]),*/
              /* gradient: LinearGradient(
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  //transform: GradientRotation(math.pi / 4),
                  //stops: [0.4, 1],
                  colors: [Color(0xFF00444B), Color(0xFF00444B)]),*/
            ),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  SizedBox(height: size.height * 0.04),
                  Flexible(
                      child: SizedBox(
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    Get.to(BuySellSearchscreenui(
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
                                    final splitNames =
                                        buysellList[i].photos.split(',');
                                    productImages.add(splitNames[0]);
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(Buyselldetailsui(
                                            index: buysellList[i].id.toString(),
                                            type: widget.type));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: boxShadow,
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
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: Container(
                                                    height: 100,
                                                    width: size.width * 0.365,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              "http://mmhomes.in/ShreeGraphic1/upload/buysell/" +
                                                                  productImages[
                                                                      0],
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit:
                                                                    BoxFit.fill,
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
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: Container(
                                                    height: 100,
                                                    width: size.width * 0.5,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            buysellList[i]
                                                                .seller_name
                                                                .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white)),
                                                        Text(
                                                            buysellList[i]
                                                                .prod_name
                                                                .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white)),
                                                        Text(
                                                            "Rs. " +
                                                                buysellList[i]
                                                                    .price
                                                                    .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white)),
                                                        Text(
                                                            _parseHtmlString(
                                                                buysellList[i]
                                                                    .description
                                                                    .toString()),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
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

  Debouncer({this.milliseconds = 500});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() => _timer!.cancel();
}
