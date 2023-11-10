import 'dart:io';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../Backend/api_request.dart';
import '../Config/enums.dart';
import '../HomeScreen.dart';
import '../Model/buysell_list_model.dart';
import '../Model/buysell_whatsappmsg_model.dart';
import 'buysellupdatestockui.dart';
import 'editadddetails.dart';

class Buysellmypostdetailsui extends StatefulWidget {
  String index;
  final UserType type;
  Buysellmypostdetailsui({this.index = "", required this.type, Key? key})
      : super(key: key);

  @override
  State<Buysellmypostdetailsui> createState() => _BuysellmypostdetailsuiState();
}

class _BuysellmypostdetailsuiState extends State<Buysellmypostdetailsui> {
  List<String> productImages = [];
  var formatedDate;
  bool isLoding = false;
  List<BuysellListModel> buysellDetail = [];
  List<BuysellWhatsappMsgModel> instrucmsgList = [];
  SwiperController _controller = SwiperController();
  bool soldbuttonvisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBuysellDetails();
    getinstrumsg();
  }

  getBuysellDetails() async {
    buysellDetail = [];
    setLoding();
    final requestData = await API.buysellDetail(widget.index);
    print(requestData);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        buysellDetail.add(BuysellListModel.fromJson(i));
      }
      setState(() {});
    }
  }

  void getinstrumsg() async {
    instrucmsgList = [];
    final requestData = await API.buysellinstructmsgList("english");
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        //  var msg = requestData.result[i]
        instrucmsgList.add(BuysellWhatsappMsgModel.fromJson(i));
      }
      setState(() {});
    }
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  @override
  void didChangeDependencies() {
    // Theme.of(context)
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF131416),
          centerTitle: true,
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            /* Image.asset(
              'Assets/desh1.png',
              fit: BoxFit.scaleDown,
              height: 50,
            ),*/
            buysellDetail == null
                ? Center()
                : buysellDetail.isEmpty
                    ? const Center(
                        child: Text(
                        "",
                        style: TextStyle(color: Colors.white),
                      ))
                    : Flexible(
                        child: Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(buysellDetail[0].cat_name)))
          ]),
        ),
        body: Stack(children: [
          Container(
              width: screen.width,
              height: screen.height,
              //   color: Color(0xFF00444B),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // tileMode: TileMode.clamp,
                    //transform: GradientRotation(math.pi / 4), Color(0xFF353A3F)
                    //  stops: [0.4, 1],
                    //0d0c22
                    colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
                /*   gradient: linearGradient(
                    160, ['#262626 0%', "#000000 100%"]),*/
              ),
              child: SingleChildScrollView(
                child: buysellDetail == null
                    ? Center()
                    : buysellDetail.isEmpty
                        ? Center(
                            child: Text(
                            "",
                            style: TextStyle(color: Colors.white),
                          ))
                        : instrucmsgList == null
                            ? Center()
                            : instrucmsgList.isEmpty
                                ? Center(
                                    child: Text(
                                    "",
                                    style: TextStyle(color: Colors.white),
                                  ))
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                        imagescroll(),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: SizedBox(
                                              width: screen.width,
                                              child: Text("Details:",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0),
                                            child: _rowData(
                                                "Name of product",
                                                _parseHtmlString(
                                                    buysellDetail[0]
                                                        .prod_name))),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0),
                                            child: _rowData(
                                                "Product Description",
                                                _parseHtmlString(
                                                    buysellDetail[0]
                                                        .description))),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0),
                                            child: _rowData(
                                                "Type", buysellDetail[0].type)),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0),
                                            child: _rowData(
                                                buysellDetail[0].type == "Sell"
                                                    ? "Product Cost"
                                                    : "Rent Cost",
                                                buysellDetail[0].price)),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                            thickness: 1,
                                          ),
                                        ),
                                        /* Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 15.0, right: 15.0),
                                                  child: _rowData(
                                                      "Rent Cost",
                                                      buysellDetail[0].rent_price)),
                                              Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Divider(
                                                  color: Colors.grey,
                                                  height: 1,
                                                  thickness: 1,
                                                ),
                                              ),*/
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0),
                                            child: _rowData(
                                                "Total Stock (In Number)",
                                                buysellDetail[0].avl_stock)),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0),
                                            child: _rowData(
                                                "Home / Office Address",
                                                buysellDetail[0].address)),
                                        const Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0),
                                            child: _rowData("Name of person",
                                                buysellDetail[0].seller_name)),
                                        const Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0),
                                            child: _rowData("Mobile Number",
                                                buysellDetail[0].mobile)),
                                        const Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0),
                                            child: _rowData(
                                                "Upload Date", formatedDate)),
                                        const Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Divider(
                                            color: Colors.grey,
                                            height: 1,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black45,
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                instrucmsgList[0].message,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                            child: Wrap(
                                              direction: Axis
                                                  .horizontal, //Vertical || Horizontal
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: Container(
                                                    width: screen.width * 0.430,
                                                    height: 43,
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                              begin:
                                                                  FractionalOffset
                                                                      .bottomLeft,
                                                              end: FractionalOffset
                                                                  .bottomRight,
                                                              transform:
                                                                  GradientRotation(
                                                                      math.pi /
                                                                          4),
                                                              //stops: [0.4, 1],
                                                              colors: [
                                                            Color(0xFF131416),
                                                            Color(0xFF151619),
                                                          ]),
                                                      boxShadow: boxShadow,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                          ),
                                                          minimumSize:
                                                              MaterialStateProperty
                                                                  .all(Size(
                                                                      double
                                                                          .infinity,
                                                                      50)),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(
                                                            Color(0xFF131416),
                                                          ),
                                                          // elevation: MaterialStateProperty.all(3),
                                                          shadowColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .transparent),
                                                        ),
                                                        onPressed: () async {
                                                          Get.to(
                                                              EditAdddetailsui(
                                                            index: widget.index,
                                                            type: widget.type,
                                                          ));
                                                        },
                                                        child: Text(
                                                          "Edit Post",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Montserrat-Bold',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.white,
                                                              letterSpacing:
                                                                  1.33),
                                                        )),
                                                  ),
                                                ),
                                                Visibility(
                                                    visible: soldbuttonvisible,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      child: Container(
                                                        width: screen.width *
                                                            0.430,
                                                        height: 43,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          gradient:
                                                              const LinearGradient(
                                                                  begin: FractionalOffset
                                                                      .bottomLeft,
                                                                  end: FractionalOffset
                                                                      .bottomRight,
                                                                  transform:
                                                                      GradientRotation(
                                                                          math.pi /
                                                                              4),
                                                                  //stops: [0.4, 1],
                                                                  colors: [
                                                                Color(
                                                                    0xFF131416),
                                                                Color(
                                                                    0xFF151619),
                                                              ]),
                                                          boxShadow: boxShadow,
                                                        ),
                                                        child: ElevatedButton(
                                                            style: ButtonStyle(
                                                              shape: MaterialStateProperty
                                                                  .all<
                                                                      RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                              minimumSize:
                                                                  MaterialStateProperty
                                                                      .all(Size(
                                                                          double
                                                                              .infinity,
                                                                          50)),
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                Color(
                                                                    0xFF131416),
                                                              ),
                                                              // elevation: MaterialStateProperty.all(3),
                                                              shadowColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .transparent),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              Get.to(Buysellupdatestockui(
                                                                  index: widget
                                                                      .index,
                                                                  title: buysellDetail[
                                                                          0]
                                                                      .cat_name,
                                                                  type: widget
                                                                      .type));
                                                            },
                                                            child: Text(
                                                              "Sold Out",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Montserrat-Bold',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white,
                                                                  letterSpacing:
                                                                      1.33),
                                                            )),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ]),
              )),
          Visibility(
              visible: isLoding,
              child: Opacity(
                opacity: 0.7,
                child: Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ))
        ]));
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  Widget _rowData(String title, String value) {
    return value == null || value == ""
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  ":",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          );
  }

  Widget imagescroll() {
    Size screen = MediaQuery.of(context).size;
    final splitNames = buysellDetail[0].photos.split(',');
    for (int i = 0; i < splitNames.length; i++) {
      productImages.add(splitNames[i]);
    }

    var stringList =
        buysellDetail[0].crDate.toIso8601String().split(new RegExp(r"[T\.]"));
    formatedDate = "${stringList[0]} ${stringList[1]}";

    if (buysellDetail[0].status.toString() == "0") {
      soldbuttonvisible = false;
    } else if (buysellDetail[0].status.toString() == "1") {
      soldbuttonvisible = true;
    } else if (buysellDetail[0].status.toString() == "2") {
      soldbuttonvisible = false;
    } else if (buysellDetail[0].status.toString() == "3") {
      soldbuttonvisible = false;
    } else {
      soldbuttonvisible = true;
    }
    return Stack(children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: SizedBox(
            height: screen.height * 0.4,
            width: screen.width,
            child: Swiper(
              //  physics: const NeverScrollableScrollPhysics(),
              autoplay: true,
              key: UniqueKey(),
              scrollDirection: Axis.horizontal,
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                return CachedNetworkImage(
                  imageUrl: "http://mmhomes.in/ShreeGraphic1/upload/buysell/" +
                      productImages[index],
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const CircleAvatar(
                    backgroundColor: Colors.black,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              },
              itemCount: productImages.length,
              itemWidth: 300.0,
            ),
          ),
        )
      ]),
      Positioned(
        right: 0,
        top: 0,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final imageurl =
                      "http://mmhomes.in/ShreeGraphic1/upload/buysell/" +
                          productImages[0];
                  final uri = Uri.parse(imageurl);
                  final response = await http.get(uri);
                  final bytes = response.bodyBytes;
                  final temp = await getTemporaryDirectory();
                  final path = '${temp.path}/image.jpg';
                  File(path).writeAsBytesSync(bytes);
                  await Share.shareFiles([path],
                      text: buysellDetail[0].prod_name.toString());
                },
                child: Icon(Icons.share),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(CircleBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  // <-- Button color
                  overlayColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.red; // <-- Splash color
                    else
                      return Colors.white;
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    ]);
  }

  callBack() {
    setState(() {
      _controller.next();
    });
  }
}
