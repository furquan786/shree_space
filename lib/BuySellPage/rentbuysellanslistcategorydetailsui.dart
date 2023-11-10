import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:shreegraphic/BuySellPage/rentbuysell_searchscreenui.dart';
import 'package:shreegraphic/BuySellPage/rentbuyselldetailsui.dart';

import '../Backend/api_request.dart';
import '../Config/enums.dart';
import '../HomeScreen.dart';
import '../Model/buysell_list_model.dart';
import 'buysellcontroller.dart';

final gradiColor = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Colors.black.withOpacity(1),
      Colors.black.withOpacity(1),
      Colors.black.withOpacity(0.9),
      Colors.black.withOpacity(0.3),
      Colors.black.withOpacity(0.4),
      Colors.black.withOpacity(0.3),
      Colors.black.withOpacity(0.2),
      Colors.black.withOpacity(0.1)
    ]);

class RentBuySelllistcategorydetailsui extends StatefulWidget {
  String index, title;
  final UserType type;
  RentBuySelllistcategorydetailsui(
      {this.index = "", this.title = "", required this.type, Key? key})
      : super(key: key);

  @override
  State<RentBuySelllistcategorydetailsui> createState() =>
      _RentBuySelllistcategorydetailsuiState();
}

class _RentBuySelllistcategorydetailsuiState
    extends State<RentBuySelllistcategorydetailsui> {
  List _children = [];
  int currentIndex = 2;
  bool isLoding = false;

  bool _isDrawerOpen = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
      print(currentIndex);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _children = [
      Profileui(widget.type),
      Homeui(widget.type),
      HomePlaceholderWidget(
        widget.index,
        widget.title,
        widget.type,
      ),
      Homeui(widget.type),
      Homeui(widget.type),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawer: DrawerData(context, widget.type),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(type: widget.type)));
            },
            backgroundColor: Color(0xFF131416),
            child: Image.asset(
              "Assets/rectangle.png",
              fit: BoxFit.fitHeight,
            )),
        bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.antiAlias,
          shape: const CircularNotchedRectangle(),
          notchMargin: 4,
          child: BottomNavigationBar(
            backgroundColor: Color(0xFF131416),
            selectedItemColor: Color(0xFF131416),
            type: BottomNavigationBarType.fixed,
            //unselectedItemColor: Colors.white,
            onTap: onTabTapped,
            // new
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'Assets/profile.png',
                    height: 50,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Stack(children: <Widget>[
                    Image.asset(
                      "Assets/file.png",
                      height: 50,
                    ),
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                            //width: screen.width,
                            child: Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Center(
                            child: Image.asset(
                              "Assets/menu_file.png",
                              height: 50,
                            ),
                          ),
                        ))),
                  ]),
                  label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'Assets/rupess.png',
                    height: 50,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: InkWell(
                    child: Image.asset(
                      'Assets/menu.png',
                      height: 50,
                    ),
                    onTap: () async {
                      if (!_isDrawerOpen) {
                        this._key.currentState!.openDrawer();
                        // Drawerdata(context);
                      } else {
                        if (_isDrawerOpen) {
                          setState(() {
                            _isDrawerOpen = false;
                          });
                        }
                        Navigator.pop(context);
                      }
                    },
                  ),
                  label: ""),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFF131416),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /*  Image.asset(
                'Assets/desh1.png',
                fit: BoxFit.scaleDown,
                height: 50,
              ),*/
              Flexible(
                  child: Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(widget.title)))
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Get.to(RentBuySellSearchscreenui(type: widget.type));
              },
            ),
          ],
        ),
        body: _children[currentIndex]);
  }
}

class HomePlaceholderWidget extends StatefulWidget {
  String index = "", title = '';
  UserType? type;
  HomePlaceholderWidget(String index, String title, UserType type, {Key? key})
      : super(key: key) {
    this.index = index;
    this.title = title;
    this.type = type;
  }

  @override
  State<HomePlaceholderWidget> createState() => _HomeholderWidgetState();
}

class _HomeholderWidgetState extends State<HomePlaceholderWidget> {
  final Buysellcontroller controller = Get.put(Buysellcontroller());
  List<String> productImages = [];
  bool isLoding = false;
  List<BuysellListModel> buysellCategoryDetailList = [];

  getQueAnsList() async {
    buysellCategoryDetailList = [];
    setLoding();
    final requestData = await API.rentbuysellCategoryDetailList(widget.index);
    print(requestData);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        buysellCategoryDetailList.add(BuysellListModel.fromJson(i));
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getQueAnsList();
    controller.getHomeAdvertiseImage("buysell", "buysell");
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    final node = FocusScope.of(context);
    return Stack(children: [
      Container(
          width: screen.width,
          height: screen.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
          ),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  buysellCategoryDetailList == null
                      ? Center()
                      : buysellCategoryDetailList.isEmpty
                          ? Center(
                              child: Text(
                              "No Data Found",
                              style: TextStyle(color: Colors.white),
                            ))
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext context, int i) {
                                    return const SizedBox(
                                      height: 8,
                                    );
                                  },
                                  itemCount: buysellCategoryDetailList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    final splitNames =
                                        buysellCategoryDetailList[i]
                                            .photos
                                            .split(',');
                                    productImages.add(splitNames[0]);
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(RentBuyselldetailsui(
                                            index: buysellCategoryDetailList[i]
                                                .id
                                                .toString(),
                                            type: widget.type!));
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
                                                    width: screen.width * 0.365,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              "http://mmhomes.in/ShreeGraphic1/upload/buysell/" +
                                                                  productImages[
                                                                      i],
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
                                                    width: screen.width * 0.5,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            buysellCategoryDetailList[
                                                                    i]
                                                                .seller_name
                                                                .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white)),
                                                        Text(
                                                            buysellCategoryDetailList[
                                                                    i]
                                                                .prod_name
                                                                .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white)),
                                                        Text(
                                                            "Rs. " +
                                                                buysellCategoryDetailList[
                                                                        i]
                                                                    .price
                                                                    .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                        Text(
                                                            _parseHtmlString(
                                                                buysellCategoryDetailList[
                                                                        i]
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
                  const SizedBox(height: 30),
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
    ]);
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}
