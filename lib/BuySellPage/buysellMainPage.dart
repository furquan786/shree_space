import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:html/parser.dart';

import 'package:intl/intl.dart';
import 'package:shreegraphic/BuySellPage/selectbusellcategoryui.dart';

import '../Backend/api_request.dart';
import '../Backend/share_manager.dart';
import '../Config/enums.dart';
import '../HomeScreen.dart';
import '../Model/announcement_model.dart';
import '../Model/buysell_list_model.dart';
import '../Model/myorder_list_model.dart';
import '../Model/news_category_model.dart';
import '../Model/photoslist_model.dart';
import '../addAnnuoncement.dart';
import '../annuonacementDetailui.dart';
import '../myannuonacementDetailui.dart';
import 'adddetails.dart';
import 'buysellRentPage.dart';
import 'buysellanslistcategorydetailsui.dart';
import 'buyselldetailsui.dart';
import 'buysellmypostdetailsui.dart';
import 'myorderbuyhistoryDetailui.dart';
import 'myordersellhistoryDetailui.dart';

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

class BuySellMainPage extends StatefulWidget {
  final UserType type;

  BuySellMainPage({required this.type, Key? key}) : super(key: key);

  @override
  State<BuySellMainPage> createState() => _BuySellMainPageuiState();
}

class _BuySellMainPageuiState extends State<BuySellMainPage>
    with SingleTickerProviderStateMixin {
  bool _isDrawerOpen = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List _children = [];
  int tabindex = 0;
  TabController? tabController;
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
    tabController = TabController(vsync: this, length: 4);
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
        length: 4,
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
                Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: const Text("E-Commerce"))
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
                      'Buy-Sell List',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'My Post',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Buy History',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Sell History',
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
                    BuySellListWidget(type: widget.type),
                    MyPostWidget(type: widget.type),
                    BuyHistoryWidget(type: widget.type),
                    SellHistoryWidget(type: widget.type),
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
  List<String> typeList = [
    "Sell",
    "Rent",
  ];
  String selectedType = "";
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _displayTextInputDialog(context));
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Category'),
            content: typeDropDownMenu("Select Type", typeList, (newVal) {
              if (newVal != selectedType) {
                selectedType = newVal!;
                setState(() {});
              }
            }, selectedType),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    if (selectedType != null) {
                      if (selectedType == "Sell") {
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        Get.to(BuySellRentPage(type: widget.type!));
                      }
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  Widget typeDropDownMenu(String hint, List<String> list,
      Function(String? val) onChange, String value) {
    return SizedBox(
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              filled: true,
              fillColor: Colors.white,
            ),
            items: list.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(
                  val,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              );
            }).toList(),
            value: value,
            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onChanged: onChange),
      ),
    );
  }

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

class BuySellListWidget extends StatefulWidget {
  UserType type;

  BuySellListWidget({required this.type, Key? key}) : super(key: key);

  @override
  State<BuySellListWidget> createState() => _BuySellListWidgetState();
}

class _BuySellListWidgetState extends State<BuySellListWidget> {
  bool isLoding = false;
  List<BuysellListModel> buysellList = [];
  List<String> productImages = [];
  getBuysellList() async {
    buysellList = [];
    setLoding();
    final requestData = await API.buysellList();
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        buysellList.add(BuysellListModel.fromJson(i));
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
    getBuysellList();
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screen.width * 0.445,
                          height: 43,
                          decoration: BoxDecoration(
                            //color: Colors.white,
                            gradient: const LinearGradient(
                                begin: FractionalOffset.bottomLeft,
                                end: FractionalOffset.bottomRight,
                                transform: GradientRotation(math.pi / 4),
                                //stops: [0.4, 1],
                                colors: [
                                  Color(0xFF131416),
                                  Color(0xFF151619),
                                ]),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: boxShadow,
                          ),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all(
                                    Size(double.infinity, 50)),
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFF131416)),
                                // elevation: MaterialStateProperty.all(3),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              onPressed: () async {
                                Get.to(Adddetailsui(type: widget.type));
                              },
                              child: Text(
                                "Sell",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Montserrat-Bold',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 1.33),
                              )),
                        ),
                        Container(
                          width: screen.width * 0.445,
                          height: 43,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: FractionalOffset.bottomLeft,
                                end: FractionalOffset.bottomRight,
                                transform: GradientRotation(math.pi / 4),
                                //stops: [0.4, 1],
                                colors: [
                                  Color(0xFF131416),
                                  Color(0xFF151619),
                                ]),
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: boxShadow,
                          ),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all(
                                    Size(double.infinity, 50)),
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFF131416)),
                                // elevation: MaterialStateProperty.all(3),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              onPressed: () async {
                                Get.to(
                                    Selectbusellcategoryui(type: widget.type));
                              },
                              child: Text(
                                "Select Category",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Montserrat-Bold',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 1.33),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 10),
                  buysellList == null
                      ? Center()
                      : buysellList.isEmpty
                          ? Center(
                              child: Text(
                              "No Data Found",
                              style: TextStyle(color: Colors.white),
                            ))
                          : Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 0),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                              index:
                                                  buysellList[i].id.toString(),
                                              type: widget.type));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                  begin: FractionalOffset
                                                      .bottomLeft,
                                                  end: FractionalOffset
                                                      .bottomRight,
                                                  transform: GradientRotation(
                                                      math.pi / 4),
                                                  //stops: [0.4, 1],
                                                  colors: [
                                                    Color(0xFF131416),
                                                    Color(0xFF151619),
                                                  ]),
                                              //color: Colors.black45,
                                              boxShadow: boxShadow,
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
                                                            .symmetric(
                                                        horizontal: 4),
                                                    child: Container(
                                                      height: 100,
                                                      width:
                                                          screen.width * 0.365,
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
                                                                  fit: BoxFit
                                                                      .fill,
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
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          )),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 4),
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
                                                              buysellList[i]
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
                                                              buysellList[i]
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
                                                                  buysellList[i]
                                                                      .price
                                                                      .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                          Text(
                                                              _parseHtmlString(
                                                                  buysellList[i]
                                                                      .description
                                                                      .toString()),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  fontSize: 12,
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
    Size screen = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: Container(
        width: screen.width * 0.445,
        height: 43,
        decoration: BoxDecoration(
          //color: Colors.white,
          gradient: const LinearGradient(
              begin: FractionalOffset.bottomLeft,
              end: FractionalOffset.bottomRight,
              transform: GradientRotation(math.pi / 4),
              //stops: [0.4, 1],
              colors: [
                Color(0xFF131416),
                Color(0xFF151619),
              ]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: boxShadow,
        ),
        child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
              backgroundColor: MaterialStateProperty.all(Color(0xFF131416)),
              // elevation: MaterialStateProperty.all(3),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () async {
              Get.to(Adddetailsui(type: widget.type));
            },
            child: Text(
              "Sell",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.33),
            )),
      ), /*MaterialButton(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent)),
          color: Colors.white,
          height: 50,
          // minWidth: double.infinity,
          child: const Text(
            "Sell",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: () async {
            Get.to(Adddetailsui());
          }),*/
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

/*
class SelectCategoryWidget extends StatefulWidget {
  UserType type;

  SelectCategoryWidget({this.type, Key key}) : super(key: key);
  @override
  State<SelectCategoryWidget> createState() => _SelectCategoryWidgetState();
}

class _SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  bool isLoding = false;
  List<NewsCategoryModel> buysellList = [];
  var formatedDate,startdate,enddate;

  getNewList() async {

    buysellList = [];
    setLoding();
    final requestData = await API.buysellCategoryList();
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        buysellList.add(NewsCategoryModel.fromJson(i));
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
    getNewList();
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
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
          ),
          // color: Colors.black87,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  buysellList == null
                      ? Center()
                      : buysellList.isEmpty
                      ? Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(color: Colors.white),
                      ))
                      : Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
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
                                    index:
                                    buysellList[i].id.toString(),
                                    title: buysellList[i]
                                        .name
                                        .toString(),
                                    type: widget.type));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  //  color: Colors.black45,
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
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(2.0),
                                        child: Container(
                                          height: 105,
                                          width: screen.width * 0.35,
                                          child: ClipRRect(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(8.0),
                                              child:
                                              CachedNetworkImage(
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
                                        padding:
                                        const EdgeInsets.only(
                                            top: 8, left: 12),
                                        child: Container(
                                          height: 105,
                                          width: screen.width * 0.5,
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
                                                                    buysellList[i].name,
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    textAlign: TextAlign.start,
                                                                    style: const TextStyle(fontSize: 14, color: Colors.white))),
                                                            Text(
                                                                buysellList[i].count +
                                                                    " Post",
                                                                textAlign: TextAlign
                                                                    .start,
                                                                style: const TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors.grey))
                                                          ]),
                                                      Flexible(
                                                          child: Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 4),
                                                              child: Text(_parseHtmlString(buysellList[i].description.toString()),
                                                                  maxLines: 4,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w400,
                                                                  )))),
                                                    ]),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            );

                          }),
                    ),
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
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

}
*/

class MyPostWidget extends StatefulWidget {
  UserType type;

  MyPostWidget({required this.type, Key? key}) : super(key: key);
  @override
  State<MyPostWidget> createState() => _MyPostWidgetState();
}

class _MyPostWidgetState extends State<MyPostWidget> {
  bool isLoding = false;
  List<BuysellListModel> buysellList = [];
  List<String> productImages = [];

  getBuysellList() async {
    String user_id = await ShareManager.getUserID();
    buysellList = [];
    setLoding();
    final requestData = await API.mybuysellList(user_id);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        buysellList.add(BuysellListModel.fromJson(i));
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
    getBuysellList();
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
                  buysellList == null
                      ? Center()
                      : buysellList.isEmpty
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
                                  itemCount: buysellList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    final splitNames =
                                        buysellList[i].photos.split(',');
                                    productImages.add(splitNames[0]);
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(Buysellmypostdetailsui(
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
                                                            buysellList[i]
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
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            )),
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
                                                                        .white)),
                                                        Text(
                                                            buysellList[i]
                                                                        .status
                                                                        .toString() ==
                                                                    "0"
                                                                ? "Status : In approval"
                                                                : buysellList[i]
                                                                            .status
                                                                            .toString() ==
                                                                        "1"
                                                                    ? "Status : Approved "
                                                                    : buysellList[i].status.toString() ==
                                                                            "2"
                                                                        ? "Status : Rejected "
                                                                        : buysellList[i].status.toString() ==
                                                                                "3"
                                                                            ? "Status : Sold out "
                                                                            : "Status : In approval",
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

class BuyHistoryWidget extends StatefulWidget {
  UserType type;

  BuyHistoryWidget({required this.type, Key? key}) : super(key: key);
  @override
  State<BuyHistoryWidget> createState() => _BuyHistoryWidgetState();
}

class _BuyHistoryWidgetState extends State<BuyHistoryWidget> {
  bool isLoding = false;
  List<MyOrderListModel> myorderList = [];

  getOrderList() async {
    String buy_id = await ShareManager.getID();
    myorderList = [];
    setLoding();
    final requestData = await API.myorderHistoryList(buy_id);
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
                                        Get.to(MyorderbuyDetailhistoryui(
                                            index: myorderList[i].id.toString(),
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

class SellHistoryWidget extends StatefulWidget {
  UserType type;

  SellHistoryWidget({required this.type, Key? key}) : super(key: key);
  @override
  State<SellHistoryWidget> createState() => _SellHistoryWidgetState();
}

class _SellHistoryWidgetState extends State<SellHistoryWidget> {
  bool isLoding = false;
  List<MyOrderListModel> myorderList = [];

  getOrderList() async {
    String sell_id = await ShareManager.getID();
    myorderList = [];
    setLoding();
    final requestData = await API.myordersellHistoryList(sell_id);
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
                                        Get.to(MyordersellDetailhistoryui(
                                            index: myorderList[i].id.toString(),
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
