import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../Backend/api_request.dart';
import '../HomeScreen.dart';
import 'Config/enums.dart';
import 'Model/locationforshoot_model.dart';
import 'VIewAttachmentui.dart';

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

class LocationAllDetailhistoryui extends StatefulWidget {
  String index;
  final UserType type;

  LocationAllDetailhistoryui({this.index = "", required this.type, Key? key})
      : super(key: key);

  @override
  State<LocationAllDetailhistoryui> createState() =>
      _LocationAllDetailhistoryuiState();
}

class _LocationAllDetailhistoryuiState
    extends State<LocationAllDetailhistoryui> {
  List _children = [];
  bool _isDrawerOpen = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  int currentIndex = 2;
  bool isLoding = false;

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
      HomePlaceholderWidget(widget.type, widget.index),
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
            "Assets/home.png",
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
                child: Text("Location Detail"))
          ],
        ),
      ),
      body: _children[currentIndex],
    );
  }
}

class HomePlaceholderWidget extends StatefulWidget {
  String index = "";
  UserType? type;

  HomePlaceholderWidget(UserType type, String index, {Key? key})
      : super(key: key) {
    this.type = type;
    this.index = index;
  }

  @override
  State<HomePlaceholderWidget> createState() => _HomeholderWidgetState();
}

class _HomeholderWidgetState extends State<HomePlaceholderWidget> {
  bool isLoding = false;
  List<LocforShootModel> locforshootList = [];

  getLocationList() async {
    locforshootList = [];
    setLoding();
    final requestData = await API.locationDetailList(widget.index);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        locforshootList.add(LocforShootModel.fromJson(i));
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
    getLocationList();
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
                  locforshootList == null
                      ? Center()
                      : locforshootList.isEmpty
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
                                  itemCount: locforshootList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return GestureDetector(
                                      onTap: () {},
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
                                                        "Location Name",
                                                        _parseHtmlString(
                                                            locforshootList[i]
                                                                .name))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "State",
                                                        _parseHtmlString(
                                                            locforshootList[i]
                                                                .state))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "City",
                                                        _parseHtmlString(
                                                            locforshootList[i]
                                                                .city))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "City Pin",
                                                        _parseHtmlString(
                                                            locforshootList[i]
                                                                .city_pin))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Address",
                                                        _parseHtmlString(
                                                            locforshootList[i]
                                                                .address))),
                                                locforshootList[i].image != null
                                                    ? Align(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .center,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 16,
                                                                    right: 16),
                                                            child: Wrap(
                                                                direction: Axis
                                                                    .horizontal,
                                                                //Vertical || Horizontal
                                                                children: <Widget>[
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8),
                                                                    child:
                                                                        Container(
                                                                      width: screen
                                                                              .width *
                                                                          0.440,
                                                                      height:
                                                                          43,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        boxShadow:
                                                                            boxShadow,
                                                                        gradient: const LinearGradient(
                                                                            begin: FractionalOffset.bottomLeft,
                                                                            end: FractionalOffset.bottomRight,
                                                                            transform: GradientRotation(math.pi / 4),
                                                                            //stops: [0.4, 1],
                                                                            colors: [
                                                                              Color(0xFF131416),
                                                                              Color(0xFF151619),
                                                                            ]),
                                                                      ),
                                                                      child: ElevatedButton(
                                                                          style: ButtonStyle(
                                                                            shape:
                                                                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                              RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                              ),
                                                                            ),
                                                                            minimumSize:
                                                                                MaterialStateProperty.all(Size(double.infinity, 50)),
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(
                                                                              Color(0xFF131416),
                                                                            ),
                                                                            // elevation: MaterialStateProperty.all(3),
                                                                            shadowColor:
                                                                                MaterialStateProperty.all(Colors.transparent),
                                                                          ),
                                                                          onPressed: () async {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => VIewAttachmentui(type: widget.type!, image: locforshootList[i].image)),
                                                                            );
                                                                          },
                                                                          child: Text(
                                                                            "View Attachment",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontFamily: 'Montserrat-Bold',
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.white,
                                                                                letterSpacing: 1.33),
                                                                          )),
                                                                    ),
                                                                  ),
                                                                ])))
                                                    : SizedBox(),
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
}
