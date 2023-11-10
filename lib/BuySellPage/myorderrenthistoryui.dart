import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

import '../Backend/api_request.dart';
import '../Backend/share_manager.dart';
import '../Config/enums.dart';
import '../HomeScreen.dart';
import '../Model/myorder_list_model.dart';
import 'homecon.dart';
import 'myorderRenthistoryDetailui.dart';

final gradiColor = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Colors.black.withOpacity(1),
      Colors.black.withOpacity(1),
      Colors.black.withOpacity(0.9),
      Colors.black.withOpacity(0.6),
      Colors.black.withOpacity(0.5),
      Colors.black.withOpacity(0.3),
      Colors.black.withOpacity(0.2),
      Colors.black.withOpacity(0.1)
    ]);

class MyorderRenthistoryui extends StatefulWidget {
  //const MyorderRenthistoryui({Key key}) : super(key: key);
  final UserType type;

  MyorderRenthistoryui({required this.type, Key? key}) : super(key: key);
  @override
  State<MyorderRenthistoryui> createState() => _MyorderRenthistoryuiState();
}

class _MyorderRenthistoryuiState extends State<MyorderRenthistoryui> {
  List _children = [];
  bool _isDrawerOpen = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  int currentIndex = 2;
  bool isLoding = false;
  final HomeCon controller = Get.put(HomeCon());
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
      HomePlaceholderWidget(widget.type),
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
          heroTag: "btn1",
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
            /*Image.asset(
              'Assets/desh1.png',
              fit: BoxFit.fitHeight,
              height: 50,
              //width: 150,
            ),*/
            Container(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Buy Order Rent History"))
          ],
        ),
      ),
      body: _children[currentIndex],
    );
  }
}

class HomePlaceholderWidget extends StatefulWidget {
  //HomePlaceholderWidget({Key key}) : super(key: key);
  UserType? type;

  HomePlaceholderWidget(UserType type, {Key? key}) : super(key: key) {
    this.type = type;
  }
  @override
  State<HomePlaceholderWidget> createState() => _HomeholderWidgetState();
}

class _HomeholderWidgetState extends State<HomePlaceholderWidget> {
  bool isLoding = false;
  List<MyOrderListModel> myorderList = [];

  getOrderList() async {
    String buy_id = await ShareManager.getID();
    myorderList = [];
    setLoding();
    final requestData = await API.myorderRentHistoryList(buy_id);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        myorderList.add(MyOrderListModel.fromJson(i));
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
    getOrderList();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
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
          // color: Colors.black87,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  myorderList == null
                      ? Center()
                      : myorderList.isEmpty
                          ? Center(
                              child: Text(
                              "No Data Found",
                              style: TextStyle(color: Colors.white),
                            ))
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext context, int i) {
                                    return const SizedBox(
                                      height: 8,
                                    );
                                  },
                                  itemCount: myorderList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(MyorderRentDetailhistoryui(
                                            index: myorderList[i].id.toString(),
                                            type: widget.type!));
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
                                            boxShadow: boxShadow,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 4),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Order Id",
                                                        _parseHtmlString(
                                                            myorderList[i]
                                                                .id))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Product Name",
                                                        _parseHtmlString(
                                                            myorderList[i]
                                                                .product_name))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Total Amount",
                                                        _parseHtmlString(
                                                            myorderList[i]
                                                                .total))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Status",
                                                        _parseHtmlString(
                                                            myorderList[i]
                                                                .status))),
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

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}
