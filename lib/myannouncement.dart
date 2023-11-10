import 'dart:math' as math;

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

import '../Backend/api_request.dart';
import '../HomeScreen.dart';
import 'Backend/share_manager.dart';
import 'BuySellPage/homecon.dart';
import 'Config/enums.dart';
import 'Model/announcement_model.dart';
import 'addAnnuoncement.dart';
import 'annuonacementDetailui.dart';
import 'myannuonacementDetailui.dart';

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

class MyAnnouncement extends StatefulWidget {
  final UserType type;

  MyAnnouncement({required this.type, Key? key}) : super(key: key);

  @override
  State<MyAnnouncement> createState() => _MyAnnouncementuiState();
}

class _MyAnnouncementuiState extends State<MyAnnouncement>
    with SingleTickerProviderStateMixin {
  bool _isDrawerOpen = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List _children = [];
  int tabindex = 0;
  TabController? tabController;
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
    tabController = TabController(vsync: this, length: 3);
    tabController!.addListener(_handleTabSelection);
    _children = [
      Profileui(widget.type),
      Homeui(widget.type),
      HomePlaceholderWidget(widget.type),
      Homeui(widget.type),
      Homeui(widget.type),
    ];
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _key,
          drawer: DrawerData(context, widget.type),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
                    child: const Text("Announcement"))
              ],
            ),
          ),
          body: Stack(children: [
            Container(
                color: Colors.black,
                width: screen.width,
                height: screen.height,
                child: ContainedTabBarView(
                  tabs: const [
                    Text(
                      'All Announcement',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'City Announcement',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'My Announcement',
                      textAlign: TextAlign.center,
                    ),
                  ],
                  tabBarProperties: TabBarProperties(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 8.0,
                    ),
                    indicator: ContainerTabIndicator(
                      radius: BorderRadius.circular(16.0),
                      color: Colors.black,
                      borderWidth: 2.0,
                      borderColor: Colors.black,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[400],
                  ),
                  views: [
                    AllAnnouncementWidget(type: widget.type),
                    CityAnnouncementWidget(type: widget.type),
                    MYAnnouncementWidget(type: widget.type),
                  ],
                  onChange: (index) => tabindex = index,
                )),
            _children[currentIndex],
          ]),
        ));
  }
}

class HomePlaceholderWidget extends StatefulWidget {
  UserType? type;

  HomePlaceholderWidget(UserType type, {Key? key}) : super(key: key) {
    this.type = type;
  }
  @override
  State<HomePlaceholderWidget> createState() => _HomeholderWidgetState();
}

class _HomeholderWidgetState extends State<HomePlaceholderWidget> {
  bool isLoding = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(),
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
}

class AllAnnouncementWidget extends StatefulWidget {
  UserType type;

  AllAnnouncementWidget({required this.type, Key? key}) : super(key: key);

  @override
  State<AllAnnouncementWidget> createState() => _AllAnnouncementWidgetState();
}

class _AllAnnouncementWidgetState extends State<AllAnnouncementWidget> {
  bool isLoding = false;
  List<AnnouncementModel> annoList = [];
  var formatedDate, startdate, enddate;

  getAnnoList() async {
    annoList = [];
    String work_profile = await ShareManager.getWorkProfile();
    setLoding();
    final requestData = await API.announcementList(work_profile);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        annoList.add(AnnouncementModel.fromJson(i));
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
    getAnnoList();
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
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: addReferralButton(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 10),
                  annoList == null
                      ? Center()
                      : annoList.isEmpty
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
                                  itemCount: annoList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    /*   var stringList = annoList[i]
                                          .anno_date_new
                                          .toIso8601String()
                                          .split(new RegExp(r"[T\.]"));*/ /*
                                      formatedDate =
                                          "${stringList[0]} ${stringList[1]}";*/

                                    if (annoList[i].anno_date_new != "") {
                                      DateFormat dateFormat =
                                          DateFormat("dd-MM-yyyy HH:mm:ss");
                                      DateTime dateTime = dateFormat
                                          .parse(annoList[i].anno_date_new);
                                      formatedDate =
                                          DateFormat('dd-MM-yyyy – kk:mm:a')
                                              .format(dateTime);
                                    }

                                    var stringList1 = annoList[i]
                                        .start_date
                                        .toIso8601String()
                                        .split(new RegExp(r"[T\.]"));
                                    startdate =
                                        "${stringList1[0]} ${stringList1[1]}";

                                    DateFormat dateFormat1 =
                                        DateFormat("yyyy-MM-dd");
                                    DateTime dateTime1 =
                                        dateFormat1.parse(startdate);
                                    startdate = DateFormat('dd-MM-yyyy')
                                        .format(dateTime1);

                                    var stringList2 = annoList[i]
                                        .end_date
                                        .toIso8601String()
                                        .split(new RegExp(r"[T\.]"));
                                    enddate =
                                        "${stringList2[0]} ${stringList2[1]}";

                                    DateFormat dateFormat2 =
                                        DateFormat("yyyy-MM-dd");
                                    DateTime dateTime2 =
                                        dateFormat2.parse(enddate);
                                    enddate = DateFormat('dd-MM-yyyy')
                                        .format(dateTime2);
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(AnnuonacementDetailhistoryui(
                                            index: annoList[i].id.toString(),
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
                                              vertical: 8, horizontal: 4),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: Text(
                                                          "     ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 19,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      annoList[i].anno_date_new !=
                                                              ""
                                                          ? Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.8,
                                                                  vertical:
                                                                      5.8),
                                                              child: Text(
                                                                formatedDate,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                    ])),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Announcement By",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .anno_by))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Mobile No",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .anno_by_mo))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Description",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .anno_desc))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Occasion",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .occasion))),
                                                annoList[i].side != null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: _rowData(
                                                            "Side",
                                                            _parseHtmlString(
                                                                annoList[i]
                                                                    .side)))
                                                    : SizedBox(),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Camera",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .camera))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Work Profile",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .work_profile))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "State",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .state))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "City",
                                                        _parseHtmlString(
                                                            annoList[i].city))),
                                                /*Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.8,
                                                          vertical: 5.8),
                                                      child: _rowData(
                                                          "Area",
                                                          _parseHtmlString(
                                                              annoList[i]
                                                                  .area))),*/
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "TIME",
                                                        _parseHtmlString(
                                                            annoList[i].time))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Start Date",
                                                        startdate)),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "End Date", enddate)),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Book Days",
                                                        _parseHtmlString(
                                                            annoList[i].days))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Occasion Location",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .occ_loc))),
                                                annoList[i].custom_location !=
                                                        null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: _rowData(
                                                            "Custom Location",
                                                            _parseHtmlString(
                                                                annoList[i]
                                                                    .custom_location)))
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

  Widget addReferralButton() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: MaterialButton(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent)),
          color: Colors.white,
          height: 50,
          // minWidth: double.infinity,
          child: const Text(
            "Add Announcement",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddAnnuoncementui(type: widget.type)),
            );
          }),
    );
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

class CityAnnouncementWidget extends StatefulWidget {
  UserType type;

  CityAnnouncementWidget({required this.type, Key? key}) : super(key: key);
  @override
  State<CityAnnouncementWidget> createState() => _CityAnnouncementWidgetState();
}

class _CityAnnouncementWidgetState extends State<CityAnnouncementWidget> {
  bool isLoding = false;
  List<AnnouncementModel> annoList = [];
  var formatedDate, startdate, enddate;

  getCityAnnounceList() async {
    annoList = [];
    setLoding();
    String city = await ShareManager.getCity();
    String work_profile = await ShareManager.getWorkProfile();
    print(city);
    //final requestData = await API.announcementList();
    final requestData = await API.annnoListAPI(city, work_profile);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        annoList.add(AnnouncementModel.fromJson(i));
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
    getCityAnnounceList();
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
                  annoList == null
                      ? Center()
                      : annoList.isEmpty
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
                                  itemCount: annoList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    /*   var stringList = annoList[i]
                              .anno_date_new

                              .split(new RegExp(r"[T\.]"));
                          formatedDate =
                          "${stringList[0]} ${stringList[1]}";*/

                                    if (annoList[i].anno_date_new != "") {
                                      DateFormat dateFormat =
                                          DateFormat("dd-MM-yyyy HH:mm:ss");
                                      DateTime dateTime = dateFormat
                                          .parse(annoList[i].anno_date_new);
                                      formatedDate =
                                          DateFormat('dd-MM-yyyy – kk:mm:a')
                                              .format(dateTime);
                                    }

                                    var stringList1 = annoList[i]
                                        .start_date
                                        .toIso8601String()
                                        .split(new RegExp(r"[T\.]"));
                                    startdate =
                                        "${stringList1[0]} ${stringList1[1]}";

                                    DateFormat dateFormat1 =
                                        DateFormat("yyyy-MM-dd");
                                    DateTime dateTime1 =
                                        dateFormat1.parse(startdate);
                                    startdate = DateFormat('dd-MM-yyyy')
                                        .format(dateTime1);

                                    var stringList2 = annoList[i]
                                        .end_date
                                        .toIso8601String()
                                        .split(new RegExp(r"[T\.]"));
                                    enddate =
                                        "${stringList2[0]} ${stringList2[1]}";

                                    DateFormat dateFormat2 =
                                        DateFormat("yyyy-MM-dd");
                                    DateTime dateTime2 =
                                        dateFormat2.parse(enddate);
                                    enddate = DateFormat('dd-MM-yyyy')
                                        .format(dateTime2);
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(AnnuonacementDetailhistoryui(
                                            index: annoList[i].id.toString(),
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
                                              vertical: 8, horizontal: 4),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: Text(
                                                          "     ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 19,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      annoList[i].anno_date_new !=
                                                              ""
                                                          ? Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.8,
                                                                  vertical:
                                                                      5.8),
                                                              child: Text(
                                                                formatedDate,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                    ])),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Announcement By",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .anno_by))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Mobile No",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .anno_by_mo))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Description",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .anno_desc))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Occasion",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .occasion))),
                                                annoList[i].side != null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: _rowData(
                                                            "Side",
                                                            _parseHtmlString(
                                                                annoList[i]
                                                                    .side)))
                                                    : SizedBox(),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Camera",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .camera))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Work Profile",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .work_profile))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "State",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .state))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "City",
                                                        _parseHtmlString(
                                                            annoList[i].city))),
                                                /*  Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 16.8,
                                              vertical: 5.8),
                                          child: _rowData(
                                              "Area",
                                              _parseHtmlString(
                                                  annoList[i]
                                                      .area))),*/
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "TIME",
                                                        _parseHtmlString(
                                                            annoList[i].time))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Start Date",
                                                        startdate)),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "End Date", enddate)),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Book Days",
                                                        _parseHtmlString(
                                                            annoList[i].days))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Occasion Location",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .occ_loc))),
                                                annoList[i].custom_location !=
                                                        null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: _rowData(
                                                            "Custom Location",
                                                            _parseHtmlString(
                                                                annoList[i]
                                                                    .custom_location)))
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

class MYAnnouncementWidget extends StatefulWidget {
  UserType type;

  MYAnnouncementWidget({required this.type, Key? key}) : super(key: key);
  @override
  State<MYAnnouncementWidget> createState() => _MYAnnouncementWidgetState();
}

class _MYAnnouncementWidgetState extends State<MYAnnouncementWidget> {
  bool isLoding = false;
  List<AnnouncementModel> annoList = [];
  var formatedDate, startdate, enddate;

  getMyAnnounceList() async {
    annoList = [];
    setLoding();
    String mobile = await ShareManager.getMobile();
    //final requestData = await API.announcementList();
    final requestData = await API.myannoListAPI(mobile);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        annoList.add(AnnouncementModel.fromJson(i));
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
    getMyAnnounceList();
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
                  annoList == null
                      ? Center()
                      : annoList.isEmpty
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
                                  itemCount: annoList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    /*  var stringList = annoList[i]
                              .anno_date_new
                              .toIso8601String()
                              .split(new RegExp(r"[T\.]"));
                          formatedDate =
                          "${stringList[0]} ${stringList[1]}";*/
                                    if (annoList[i].anno_date_new != "") {
                                      DateFormat dateFormat =
                                          DateFormat("dd-MM-yyyy HH:mm:ss");
                                      DateTime dateTime = dateFormat
                                          .parse(annoList[i].anno_date_new);
                                      formatedDate =
                                          DateFormat('dd-MM-yyyy – kk:mm:a')
                                              .format(dateTime);
                                    }

                                    var stringList1 = annoList[i]
                                        .start_date
                                        .toIso8601String()
                                        .split(new RegExp(r"[T\.]"));
                                    startdate =
                                        "${stringList1[0]} ${stringList1[1]}";

                                    DateFormat dateFormat1 =
                                        DateFormat("yyyy-MM-dd");
                                    DateTime dateTime1 =
                                        dateFormat1.parse(startdate);
                                    startdate = DateFormat('dd-MM-yyyy')
                                        .format(dateTime1);

                                    var stringList2 = annoList[i]
                                        .end_date
                                        .toIso8601String()
                                        .split(new RegExp(r"[T\.]"));
                                    enddate =
                                        "${stringList2[0]} ${stringList2[1]}";

                                    DateFormat dateFormat2 =
                                        DateFormat("yyyy-MM-dd");
                                    DateTime dateTime2 =
                                        dateFormat2.parse(enddate);
                                    enddate = DateFormat('dd-MM-yyyy')
                                        .format(dateTime2);
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(MyAnnuonacementDetailhistoryui(
                                            index: annoList[i].id.toString(),
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
                                              vertical: 8, horizontal: 4),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: Text(
                                                          "     ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 19,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      annoList[i].anno_date_new !=
                                                              ""
                                                          ? Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.8,
                                                                  vertical:
                                                                      5.8),
                                                              child: Text(
                                                                formatedDate,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                    ])),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Description",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .anno_desc))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Occasion",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .occasion))),
                                                annoList[i].side != null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: _rowData(
                                                            "Side",
                                                            _parseHtmlString(
                                                                annoList[i]
                                                                    .side)))
                                                    : SizedBox(),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Camera",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .camera))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Work Profile",
                                                        annoList[i]
                                                            .work_profile)),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "State",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .state))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "City",
                                                        _parseHtmlString(
                                                            annoList[i].city))),
                                                /* Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 16.8,
                                              vertical: 5.8),
                                          child: _rowData(
                                              "Area",
                                              _parseHtmlString(
                                                  annoList[i]
                                                      .area))),*/
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "TIME",
                                                        _parseHtmlString(
                                                            annoList[i].time))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Start Date",
                                                        startdate)),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "End Date", enddate)),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Book Days",
                                                        _parseHtmlString(
                                                            annoList[i].days))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Occasion Location",
                                                        _parseHtmlString(
                                                            annoList[i]
                                                                .occ_loc))),
                                                annoList[i].custom_location !=
                                                        null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: _rowData(
                                                            "Custom Location",
                                                            _parseHtmlString(
                                                                annoList[i]
                                                                    .custom_location)))
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
