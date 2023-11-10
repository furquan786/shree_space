import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'Backend/api_request.dart';
import 'Backend/share_manager.dart';
import 'Config/enums.dart';
import 'HomeScreen.dart';
import 'package:dio/dio.dart' as dio;
import 'package:html/parser.dart';
import 'ITRScreen.dart';
import 'ITRVIewAttachmentui.dart';
import 'Model/announcement_model.dart';
import 'Model/itr_model.dart';
import 'addBooking.dart';
import 'editBooking.dart';

class BookingListScreen extends StatefulWidget {
  final UserType type;

  BookingListScreen({required this.type, Key? key}) : super(key: key);

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  bool _isDrawerOpen = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List _children = [];

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
                child: const Text("Bookings"))
          ],
        ),
      ),
      body: _children[currentIndex],
    );
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
  List<AnnouncementModel> bookingList = [];
  var formatedDate, startdate, enddate;
  int end = 0, today = 0;
  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  getBookingList() async {
    bookingList = [];
    String user_id = await ShareManager.getUserID();
    setLoding();
    final requestData = await API.bookingsList(user_id);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        bookingList.add(AnnouncementModel.fromJson(i));
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookingList();
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
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: addReferralButton(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  bookingList == null
                      ? Center()
                      : bookingList.isEmpty
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
                                  itemCount: bookingList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    if (bookingList[i].cr_date != "") {
                                      DateFormat dateFormat =
                                          DateFormat("dd-MM-yyyy HH:mm:ss");
                                      DateTime dateTime = dateFormat
                                          .parse(bookingList[i].cr_date);
                                      formatedDate =
                                          DateFormat('dd-MM-yyyy – kk:mm:a')
                                              .format(dateTime);
                                    }

                                    var stringList1 = bookingList[i]
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

                                    var stringList2 = bookingList[i]
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

                                    var enddate1 =
                                        DateFormat('dd').format(dateTime2);

                                    end = int.parse(enddate1);
                                    var now = new DateTime.now();
                                    var formatter = new DateFormat('dd');
                                    String formattedDate =
                                        formatter.format(now);
                                    print(formattedDate); // 2016-01-25
                                    today = int.parse(formattedDate);

                                    return GestureDetector(
                                      onTap: () {
                                        /*  Get.to(AnnuonacementDetailhistoryui(
                                  index: annoList[i].id.toString(),
                                  type: widget.type));*/
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
                                                      bookingList[i].cr_date !=
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
                                                        "Occasion",
                                                        _parseHtmlString(
                                                            bookingList[i]
                                                                .ocasion))),
                                                bookingList[i].side != null
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
                                                                bookingList[i]
                                                                    .side)))
                                                    : SizedBox(),
                                                bookingList[i].cust_name != ""
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: _rowData(
                                                            "Customer Name",
                                                            _parseHtmlString(
                                                                bookingList[i]
                                                                    .cust_name)))
                                                    : SizedBox(),
                                                bookingList[i].cust_uniq != ""
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: _rowData(
                                                            "Customer Unique Code",
                                                            _parseHtmlString(
                                                                bookingList[i]
                                                                    .cust_uniq)))
                                                    : SizedBox(),
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
                                                bookingList[i].shoot_location !=
                                                        null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: _rowData(
                                                            "Location",
                                                            _parseHtmlString(
                                                                bookingList[i]
                                                                    .shoot_location)))
                                                    : SizedBox(),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Requirement",
                                                        _parseHtmlString(
                                                            bookingList[i]
                                                                .requirement))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Status",
                                                        _parseHtmlString(
                                                            bookingList[i]
                                                                .status))),
                                                Align(
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
                                                            direction:
                                                                Axis.horizontal,
                                                            //Vertical || Horizontal
                                                            children: <Widget>[
                                                              bookingList[i].status !=
                                                                          "Cancel" &&
                                                                      end >=
                                                                          today
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              8),
                                                                      child:
                                                                          Container(
                                                                        width: screen.width *
                                                                            0.235,
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
                                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                                ),
                                                                              ),
                                                                              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                                                                              backgroundColor: MaterialStateProperty.all(
                                                                                Color(0xFF131416),
                                                                              ),
                                                                              // elevation: MaterialStateProperty.all(3),
                                                                              shadowColor: MaterialStateProperty.all(Colors.transparent),
                                                                            ),
                                                                            onPressed: () async {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) => EditBookingui(type: widget.type!, id: bookingList[i].id)),
                                                                              );
                                                                            },
                                                                            child: Text(
                                                                              "Edit",
                                                                              style: TextStyle(fontSize: 14, fontFamily: 'Montserrat-Bold', fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1.33),
                                                                            )),
                                                                      ),
                                                                    )
                                                                  : SizedBox(),
                                                              bookingList[i].status !=
                                                                          "Cancel" &&
                                                                      end >
                                                                          today
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              8),
                                                                      child:
                                                                          Container(
                                                                        width: screen.width *
                                                                            0.235,
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
                                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                                ),
                                                                              ),
                                                                              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                                                                              backgroundColor: MaterialStateProperty.all(
                                                                                Color(0xFF131416),
                                                                              ),
                                                                              // elevation: MaterialStateProperty.all(3),
                                                                              shadowColor: MaterialStateProperty.all(Colors.transparent),
                                                                            ),
                                                                            onPressed: () async {
                                                                              setLoding();

                                                                              final requestData = await API.canclebookingAPI(
                                                                                bookingList[i].id,
                                                                              );
                                                                              if (requestData.status == 1) {
                                                                                setLoding();
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(builder: (context) => BookingListScreen(type: widget.type!)),
                                                                                );
                                                                              } else {
                                                                                setLoding();
                                                                                Fluttertoast.showToast(msg: requestData.msg);
                                                                              }
                                                                            },
                                                                            child: Text(
                                                                              "Cancel",
                                                                              style: TextStyle(fontSize: 14, fontFamily: 'Montserrat-Bold', fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1.33),
                                                                            )),
                                                                      ),
                                                                    )
                                                                  : SizedBox(),
                                                            ]))),
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
            "Add Booking",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddBookingui(type: widget.type!)),
            );
          }),
    );
  }
}
