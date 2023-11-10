import 'dart:math' as math;
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shreegraphic/bookingEquipment.dart';
import 'package:html/parser.dart';
import 'package:shreegraphic/updateBookingMember.dart';

import '../Backend/api_request.dart';
import '../Backend/share_manager.dart';
import '../HomeScreen.dart';
import '../Model/request_data.dart';

import 'BuySellPage/myorderhistoryui.dart';
import 'BuySellPage/myorderrenthistoryui.dart';
import 'BuySellPage/myordersellhistoryui.dart';
import 'BuySellPage/myordersellrenthistoryui.dart';
import 'Config/enums.dart';

import 'ELearningCategory.dart';
import 'HomePage.dart';
import 'LoginScreen.dart';
import 'Model/area_list.dart';
import 'Model/bookingModel.dart';
import 'Model/city_list.dart';
import 'Model/state_list.dart';

import 'Model/workprofileModel.dart';
import 'myannouncement.dart';
import 'myimagesui.dart';

class EditBookingui extends StatefulWidget {
  //const AddAnnuoncementui({Key key}) : super(key: key);
  final UserType type;
  String id;

  EditBookingui({required this.type, this.id = "", Key? key}) : super(key: key);
  @override
  State<EditBookingui> createState() => _EditBookinguiState();
}

class _EditBookinguiState extends State<EditBookingui> {
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
      HomePlaceholderWidget(widget.type, widget.id),
      Homeui(widget.type),
      Homeui(widget.type),
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Stack(
      children: [
        Scaffold(
          key: _key,
          drawer: DrawerData(context, widget.type),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Visibility(
              visible: !keyboardIsOpen,
              child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(type: widget.type)));
                  },
                  backgroundColor: Color(0xFF131416),
                  child: Image.asset(
                    "Assets/home.png",
                    fit: BoxFit.fitHeight,
                  ))),
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
                /* Image.asset(
                  'Assets/desh1.png',
                  fit: BoxFit.scaleDown,
                  height: 50,
                ),*/
                Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Add Booking"))
              ],
            ),
          ),
          body: _children[currentIndex],
        ),
        Visibility(
            visible: isLoding,
            child: Opacity(
              opacity: 0.7,
              child: Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ))
      ],
    );
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }
}

class HomePlaceholderWidget extends StatefulWidget {
  UserType? type;
  String id = "";
  HomePlaceholderWidget(UserType type, String id, {Key? key})
      : super(key: key) {
    this.type = type;
    this.id = id;
  }

  @override
  State<HomePlaceholderWidget> createState() => _HomeholderWidgetState();
}

class _HomeholderWidgetState extends State<HomePlaceholderWidget> {
  bool isLoding = false;

  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  TextEditingController customernameController = TextEditingController();
  TextEditingController customeruniquecodeController = TextEditingController();
  TextEditingController annodescController = TextEditingController();
  TextEditingController customlocationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();

  DateTime stratdate = DateTime.now(), enddate = DateTime.now();
  var selectedOccasion = "", selectedSide = "";
  List<BookingModel> bookingList = [];
  int totalBooking = 1;
  List<int> totalQuotationList = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20
  ];

  List<String> occasionList = [
    "BirthDay",
    "Wedding",
    "Engagement",
    "Other",
  ];
  List<String> sideList = [
    "Boy",
    "Girl",
  ];

  List<BookingModel> bookingItemList = [];
  var start_date, end_date, requirement, shoot_location, cust_name, cust_uniq;
  int index = 0, index1 = 0;
  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookingDetail();
    getbookingMemb();
  }

  getbookingMemb() async {
    setLoding();
    var requestData = await API.getBookingMemberAPI(widget.id);
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        bookingItemList.add(BookingModel.fromJson(i));
      }
      setLoding();
    } else {
      setLoding();
    }
  }

  getBookingDetail() async {
    setLoding();
    final requestData = await API.bookingdetailList(widget.id);
    setLoding();
    if (requestData.status == 1) {
      selectedOccasion = requestData.result[0]["ocasion"];
      start_date = requestData.result[0]["start_date"];
      end_date = requestData.result[0]["end_date"];
      requirement = requestData.result[0]["requirement"];
      shoot_location = requestData.result[0]["shoot_location"];
      cust_name = requestData.result[0]["cust_name"];
      cust_uniq = requestData.result[0]["cust_uniq"];
      selectedSide = requestData.result[0]["side"];
      if (start_date != "0000-00-00") {
        String formattedDate =
            DateFormat('dd-MM-yyyy').format(DateTime.parse(start_date));
        dateController.text = formattedDate;
      }
      if (end_date != "0000-00-00") {
        String formattedDate =
            DateFormat('dd-MM-yyyy').format(DateTime.parse(end_date));
        enddateController.text = formattedDate;
      }
      annodescController.text = requirement;
      customlocationController.text = shoot_location;
      customernameController.text = cust_name;
      customeruniquecodeController.text = cust_uniq;
      setState(() {
        for (int i = 0; i < occasionList.length; i++) {
          if (selectedOccasion == occasionList[i]) {
            index = i;
          }
        }
      });
      try {
        setState(() {
          for (int i = 0; i < sideList.length; i++) {
            if (selectedSide == sideList[i]) {
              index1 = i;
            }
          }
        });
      } catch (e) {}
      setState(() {});
    }
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
          child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
              ),
              child: SingleChildScrollView(
                  child: Form(
                key: _fbKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Occasion *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        occasionDropDownMenu("Select Occasion", occasionList,
                            (newVal) {
                          if (newVal != selectedOccasion) {
                            selectedOccasion = newVal!;
                            setState(() {});
                          }
                        }, selectedOccasion),
                        const SizedBox(height: 20),
                        Visibility(
                            visible: selectedOccasion != "BirthDay",
                            child: const Align(
                              alignment: AlignmentDirectional.bottomStart,
                              child: Text(
                                "Side *",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Montserrat-Bold',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                ),
                              ),
                            )),
                        const SizedBox(height: 5),
                        Visibility(
                            visible: selectedOccasion != "BirthDay",
                            child: sideDropDownMenu("Select Side", sideList,
                                (newVal) {
                              if (newVal != selectedSide) {
                                selectedSide = newVal!;
                                setState(() {});
                              }
                            }, selectedSide)),
                        Visibility(
                            visible: selectedOccasion != "BirthDay",
                            child: const SizedBox(height: 20)),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Customer Name",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        customernameFormFiled(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Customer Unique code",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        customeruniqueFormFiled(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Requirement *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        requirementFormFiled(),
                        const SizedBox(height: 20),
                        _pickDate(
                            "Select Date", "Start Date *", dateController),
                        const SizedBox(height: 20),
                        _pickDate2(
                            "Select Date", "END Date *", enddateController),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Location For Shoot",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        customlocationFormFiled(),
                        const SizedBox(height: 20),
                        _addButton(),
                        const SizedBox(height: 20),
                        buttondata(lblbutton: "Update"),
                        const SizedBox(height: 30),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Members",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        bookingItemList == null
                            ? Center()
                            : bookingItemList.isEmpty
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        separatorBuilder:
                                            (BuildContext context, int i) {
                                          return const SizedBox(
                                            height: 8,
                                          );
                                        },
                                        itemCount: bookingItemList.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  boxShadow: boxShadow,
                                                  gradient:
                                                      const LinearGradient(
                                                          begin:
                                                              FractionalOffset
                                                                  .bottomLeft,
                                                          end: FractionalOffset
                                                              .bottomRight,
                                                          transform:
                                                              GradientRotation(
                                                                  math.pi / 4),
                                                          //stops: [0.4, 1],
                                                          colors: [
                                                        Color(0xFF131416),
                                                        Color(0xFF151619),
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 4),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Mobile No.",
                                                              _parseHtmlString(
                                                                  bookingItemList[
                                                                          i]
                                                                      .mobile))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Name",
                                                              _parseHtmlString(
                                                                  bookingItemList[
                                                                          i]
                                                                      .name))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Status",
                                                              bookingItemList[i]
                                                                          .status ==
                                                                      "0"
                                                                  ? "Pending"
                                                                  : bookingItemList[i]
                                                                              .status ==
                                                                          "1"
                                                                      ? "Accept"
                                                                      : "Reject")),
                                                      Align(
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .center,
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 16,
                                                                      right:
                                                                          16),
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
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => UpdateBookingMemberui(
                                                                                    oldmobile: bookingItemList[i].mobile,
                                                                                    name: bookingItemList[i].name,
                                                                                    type: widget.type!,
                                                                                    bkid: bookingItemList[i].bkId,
                                                                                    id: bookingItemList[i].id,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                            child: Text(
                                                                              "Edit",
                                                                              style: TextStyle(fontSize: 14, fontFamily: 'Montserrat-Bold', fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1.33),
                                                                            )),
                                                                      ),
                                                                    ),
                                                                    Padding(
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

                                                                              final requestData = await API.deleteBookingMemberAPI(bookingItemList[i].id, bookingItemList[i].bkId);
                                                                              if (requestData.status == 1) {
                                                                                setLoding();
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => EditBookingui(
                                                                                            type: widget.type!,
                                                                                            id: widget.id,
                                                                                          )),
                                                                                );
                                                                              } else {
                                                                                setLoding();
                                                                                Fluttertoast.showToast(msg: requestData.msg);
                                                                              }
                                                                            },
                                                                            child: Text(
                                                                              "Delete",
                                                                              style: TextStyle(fontSize: 14, fontFamily: 'Montserrat-Bold', fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1.33),
                                                                            )),
                                                                      ),
                                                                    ),
                                                                  ]))),
                                                    ]),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                        const SizedBox(height: 30)
                      ]),
                ),
              )))),
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

  Widget _addButton() {
    return Padding(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width * 0.02,
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField(
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  items: totalQuotationList.map((int val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(val.toString()),
                    );
                  }).toList(),
                  value: bookingList.length == 0
                      ? totalBooking
                      : bookingList.length,
                  hint: const Text(
                    "",
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (int? value) {
                    setState(() {
                      totalBooking = value!;
                    });
                  }),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          MaterialButton(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent)),
            color: Colors.white,
            child: Text(
              "Booking Item",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            onPressed: () {
              print("Booking list is = ${bookingList}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => BookingEquipmentui(
                    setBookList: (list) {
                      setState(() {
                        bookingList = list;
                      });
                    },
                    count: totalBooking,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _pickDate(
      String hint, String value, TextEditingController controller) {
    return SizedBox(
      //padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$value ",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              )),
          GestureDetector(
            onTap: () {
              _selectDate(controller);
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Select Date";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: hint,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickDate2(
      String hint, String value, TextEditingController controller) {
    return SizedBox(
      //padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$value ",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              )),
          GestureDetector(
            onTap: () {
              _selectDate2(controller);
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Select Date";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: hint,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _selectDate2(TextEditingController selectedDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(stratdate.year, stratdate.month, stratdate.day),
      initialDate: DateTime(stratdate.year, stratdate.month, stratdate.day),
      lastDate: DateTime(stratdate.year, stratdate.month, stratdate.day + 15),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        enddate = picked;
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        end_date = TextEditingValue(text: formattedDate);
        String formattedDate1 = DateFormat('dd-MM-yyyy').format(picked);
        selectedDate.value = TextEditingValue(text: formattedDate1);
      });
    }
    /*if (stratdate != null && enddate != null) {
      daysbetweeen = daysBetween(stratdate, enddate);
      daysbetweeen = daysbetweeen + 1;
      print(daysbetweeen);
    }*/
  }

  /* int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
*/
  Future<Null> _selectDate(TextEditingController selectedDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        stratdate = picked;
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        start_date = TextEditingValue(text: formattedDate);
        String formattedDate1 = DateFormat('dd-MM-yyyy').format(picked);
        selectedDate.value = TextEditingValue(text: formattedDate1);
      });
    }
    /*if (stratdate != null && enddate != null) {
      daysbetweeen = daysBetween(stratdate, enddate);
      daysbetweeen = daysbetweeen + 1;
      print(daysbetweeen);
    }*/
  }

  Widget occasionDropDownMenu(String hint, List<String> list,
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
            value: index != null ? occasionList[index] : value,
            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onChanged: onChange),
      ),
    );
  }

  Widget sideDropDownMenu(String hint, List<String> list,
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
            value: index1 != null ? sideList[index1] : value,
            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onChanged: onChange),
      ),
    );
  }

  Widget customernameFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: customernameController,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Montserrat-Bold',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Customer Name",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'Montserrat-Bold',
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in unfocused
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in focused
          ),
        ),
      ),
    );
  }

  Widget customeruniqueFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: customeruniquecodeController,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Montserrat-Bold',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Customer Unique Code",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'Montserrat-Bold',
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in unfocused
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in focused
          ),
        ),
      ),
    );
  }

  Widget requirementFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: annodescController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Requirement";
          }
          return null;
        },
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Montserrat-Bold',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Requirement",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'Montserrat-Bold',
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in unfocused
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in focused
          ),
        ),
      ),
    );
  }

  Widget buttondata({String lblbutton = ""}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          boxShadow: boxShadow,
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
              List<String> mnolist = [];

              if (bookingList.isNotEmpty) {
                for (var i in bookingList) {
                  mnolist.add(i.mobile);
                }
              }
              FocusScope.of(context).requestFocus(FocusNode());
              if (await DataConnectionChecker().hasConnection) {
                if (_fbKey.currentState!.validate()) {
                  if (selectedOccasion != null &&
                      start_date != null &&
                      end_date != null) {
                    String user_id = await ShareManager.getUserID();
                    final requestData = await API.editBookingApi(
                      widget.id,
                      user_id,
                      selectedOccasion,
                      selectedSide,
                      annodescController.text,
                      start_date,
                      end_date,
                      customlocationController.text,
                      customernameController.text,
                      customeruniquecodeController.text,
                      mnolist,
                    );
                    if (requestData.status == 1) {
                      setLoding();
                      Fluttertoast.showToast(msg: requestData.msg);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen(type: widget.type!)),
                          (route) => false);
                    } else {
                      setLoding();
                      Fluttertoast.showToast(msg: requestData.msg);
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Please Select Detail");
                  }
                  return;
                } else {
                  print("Unsuccessful");
                }
              } else {
                setLoding();
                Fluttertoast.showToast(
                    msg: "Please check your internet connection");
              }
            },
            child: Text(
              lblbutton,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.33),
            )),
      ),
    );
  }

  Widget customlocationFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: customlocationController,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Montserrat-Bold',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Location",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'Montserrat-Bold',
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in unfocused
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in focused
          ),
        ),
      ),
    );
  }
}
