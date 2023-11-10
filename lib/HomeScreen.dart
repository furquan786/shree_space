import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dio/dio.dart' as dio;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shreegraphic/exposing_request_screen.dart';
import 'package:shreegraphic/invoiceListScreen.dart';
import 'package:shreegraphic/packageScreen.dart';
import 'package:shreegraphic/paymentreceiptList.dart';
import 'package:shreegraphic/terms&condition.dart';
import 'package:shreegraphic/workprofile.dart';
import 'package:shreegraphic/workprofile_webview_screen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'Backend/api_request.dart';
import 'Backend/share_manager.dart';
import 'Backend/urls.dart';
import 'BookingListScreen.dart';
import 'BuySellPage/buysellMainPage.dart';
import 'CalenderDetail.dart';
import 'Config/enums.dart';

import 'ELearningCategory.dart';
import 'HomePage.dart';
import 'ITRListScreen.dart';
import 'LABOrderHistoryScreen.dart';
import 'MemBilling.dart';
import 'Model/announcement_model.dart';
import 'Model/area_list.dart';
import 'Model/city_list.dart';
import 'Model/request_data.dart';
import 'Model/state_list.dart';
import 'Model/workprofileModel.dart';
import 'QuotationListScreen.dart';
import 'addInstrutment.dart';
import 'addSchedule.dart';
import 'generatePaymentReceipt.dart';
import 'invoiceUpdateQuotationBook.dart';
import 'location_for_shoot.dart';
import 'myannouncement.dart';
import 'myimagesui.dart';
import 'notificaitonpageui.dart';

final List<BoxShadow> boxShadow = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.2), //0.3
    // unit is some relative part of the canvas width
    offset: const Offset(-0, -2),
    blurRadius: 1, //7
  ),
  const BoxShadow(
    color: Color(0xFF131416),
    offset: Offset(0, 2),
    blurRadius: 1, //7
  ),
];

class HomeScreen extends StatefulWidget {
  final UserType type;

  HomeScreen({required this.type, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 1;
  bool isLoding = false;

  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool _isDrawerOpen = false;

  List _children = [];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _children = [
      Profileui(widget.type),
      Homeui(widget.type),
      Homeui(widget.type),
      Homeui(widget.type),
      Homeui(widget.type),
    ];
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
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
              //backgroundColor: Colors.red[400],
              backgroundColor: Colors.black,
              child: Image.asset(
                "Assets/home.png",
                fit: BoxFit.fitHeight,
              )),
          bottomNavigationBar: BottomAppBar(
            clipBehavior: Clip.antiAlias,
            shape: const CircularNotchedRectangle(),
            notchMargin: 4,
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFF131416),
              selectedItemColor: const Color(0xFF85A3BB),
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: const Color(0xFF85A3BB),
              onTap: onTabTapped,
              // new
              currentIndex: currentIndex,
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(Icons.perm_identity,
                        color: Color(0xFF85A3BB), size: 25),
                    label: "Your Profile"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.folder_copy_outlined,
                        color: Color(0xFF85A3BB), size: 25),
                    label: "Your Data"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: ""),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.currency_rupee,
                        color: Color(0xFF85A3BB), size: 25),
                    label: "Pay Request"),
                BottomNavigationBarItem(
                    icon: InkWell(
                      child: const Icon(Icons.menu,
                          color: Color(0xFF85A3BB), size: 25),
                      onTap: () async {
                        if (!_isDrawerOpen) {
                          this._key.currentState!.openDrawer();
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
                    label: "Menu"),
              ],
            ),
          ),
          body: _children[currentIndex],
        ));
  }
}

class Homeui extends StatefulWidget {
  UserType? type;

  Homeui(UserType type, {Key? key}) : super(key: key) {
    this.type = type;
  }

  @override
  State<Homeui> createState() => _HomeuiState();
}

class _HomeuiState extends State<Homeui> {
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  bool isLoding = false;
  bool isShowingMainData = false;
  var user_name, storage = null, totalstorage = null, percentage;
  List<AnnouncementModel> scheduleList = [];
  List<AnnouncementModel> annoList = [];
  List<AnnouncementModel> bookingList = [];
  var userstorage, firm_name, selecteddate;
  double tstorage = 0,
      tstorageMB = 0,
      ustorage = 0,
      ustorageMB = 0,
      percentUsed = 0;
  String remaining_days = "", paymentTotal = "", invoiceTotal = "";
  DateTime user_sub_end_date = DateTime.now();

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    getData();
    getStorage();
    getAnnoList();
    getBookingList();
    getUserSubscriptionEndDate();
  }

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

  getBookingList() async {
    bookingList = [];
    String user_id = await ShareManager.getUserID();
    setLoding();
    final requestData = await API.bookingsHomeList(user_id);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        bookingList.add(AnnouncementModel.fromJson(i));
      }
      setState(() {});
    }
  }

  Future<void> getStorage() async {
    String user_id = await ShareManager.getUserID();

    print("user_id is = $user_id");

    firm_name = await ShareManager.getFirmName();

    totalstorage = await ShareManager.getPlan();

    print("totalstorage is = $totalstorage");

    totalstorage = totalstorage.replaceAll("Space", "");

    if (totalstorage.contains("TB")) {
      print("The string contains 'TB'");

      totalstorage = totalstorage.replaceAll(RegExp(r'[^\d\.]+'), '');

      tstorage = double.parse(totalstorage);

      print(tstorage);

      tstorageMB = tstorage * 1024 * 1024;

      print(tstorageMB);
    } else if (totalstorage.contains("GB")) {
      print("The string contains 'GB'");

      totalstorage = totalstorage.replaceAll(RegExp(r'[^\d\.]+'), '');

      tstorage = double.parse(totalstorage);

      tstorageMB = tstorage * 1024;

      print(tstorageMB);
    } else if (totalstorage.contains("MB")) {
      print("The string contains MB");

      totalstorage = totalstorage.replaceAll(RegExp(r'[^\d\.]+'), '');

      tstorageMB = double.parse(totalstorage);

      print(tstorageMB);
    }

    setLoding();
    final requestData = await API.storageCount(user_id);
    setLoding();
    if (requestData.status == 1) {
      storage = requestData.result.toString();

      userstorage = (storage);

      if (userstorage.contains("TB")) {
        print("The string contains 'TB'");

        userstorage = userstorage.replaceAll(RegExp(r'[^\d\.]+'), '');
        print(userstorage);

        ustorage = double.parse(userstorage);
        print(ustorage);

        ustorageMB = ustorage * 1024 * 1024;
        print(ustorageMB);
      } else if (userstorage.contains("GB")) {
        print("The string contains 'GB'");

        userstorage = userstorage.replaceAll(RegExp(r'[^\d\.]+'), '');
        ustorage = double.parse(userstorage);
        ustorageMB = ustorage * 1024;
        print(ustorageMB);
      } else if (userstorage.contains("Mb")) {
        print("The string contains 'Mb'");
        userstorage = userstorage.replaceAll(RegExp(r'[^\d\.]+'), '');
        ustorageMB = double.parse(userstorage);
        print(ustorageMB);
      } else {
        percentUsed = 0.001;
      }

      if (tstorageMB != null && ustorageMB != null) {
        percentUsed = (ustorageMB / tstorageMB) * 100;
        String fixThreeDigit = percentUsed.toStringAsFixed(3);
        percentUsed = double.parse(fixThreeDigit);

        if (percentUsed < 0.1) {
          percentUsed = 0.0001;
        }
      }

      print("storage is = $storage  total storage is = $totalstorage");
      print("percentage is - $percentUsed");

      setState(() {});
    }
  }

  Future<void> totalInvoice(String user_id) async {
    setLoding();

    final requestData = await API.getInoiceTotal(user_id);

    if (requestData.status == 1) {
      invoiceTotal = requestData.result.toString();
      setLoding();
    } else {
      setLoding();
    }
    totalPayment(user_id);
  }

  Future<void> totalPayment(String user_id) async {
    final requestData = await API.getPaymentTotal(user_id);
    setLoding();
    if (requestData.status == 1) {
      paymentTotal = requestData.result.toString();
      setLoding();
    } else {
      setLoding();
    }
  }

  Future<void> getUserSubscriptionEndDate() async {
    String user_id = await ShareManager.getUserID();

    DateTime now = DateTime.now();
    print("Current date is - $now");
    setLoding();
    final requestData = await API.getSubscriptionDateApi(user_id);

    setLoding();
    if (requestData.status == 1) {
      user_sub_end_date = DateTime.parse(requestData.result);

      print("User Subscription End Date is - $user_sub_end_date");

      Duration difference = user_sub_end_date.difference(now);

      remaining_days = difference.inDays.toString();
      print("Remaining Days is - $remaining_days");

      setState(() {});
    } else if (requestData.msg == "Subscription Ended.") {
      remaining_days = "0";
      subscriptionEndDialog(context);
    }
    totalInvoice(user_id);
  }

  Future<void> getData() async {
    user_name = await ShareManager.getName();
    String member_id = await ShareManager.getUserID();
    scheduleList = [];
    setLoding();
    final requestData = await API.scheduleHomeList(member_id);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        scheduleList.add(AnnouncementModel.fromJson(i));
      }
      setState(() {});
    }
  }

  Future<void> subscriptionEndDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Your Subscription is Expired'),
            content: const Text(
                'Please renew your Subscription to continue using the app'),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PackageScreenui(
                                type: widget.type!,
                              )),
                      (route) => false);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Stack(children: [
      Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // Add your onPressed code here!
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddScheduleui(type: widget.type!)),
              );
            },
            label: const Text('Add Schedule'),
            backgroundColor: Colors.black45,
          ),
          body: isLoding
              ? _loder()
              : Container(
                  //padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  width: screen.width,
                  height: screen.height,
                  //color: Color(0xFF00444B),

                  decoration: const BoxDecoration(
                    /*gradient: linearGradient(
                        160, ['#262626 0%', "#000000 100%"]),*/
                    /*  image: DecorationImage(
                      image: AssetImage("Assets/background.png"),
                      fit: BoxFit.fitHeight,
                    ),*/

                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        // tileMode: TileMode.clamp,
                        //transform: GradientRotation(math.pi / 4), Color(0xFF353A3F)
                        //  stops: [0.4, 1],
                        //0d0c22
                        colors: [
                          Color(0xFF170505),
                          Color(0xFF040915)
                        ]), //Color(0xFF2C3137), Color(0xFF1B1C20)
                  ),
                  child: SingleChildScrollView(
                      child: Form(
                    key: _fbKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 48),
                          Stack(children: <Widget>[
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 10, right: 10),
                                  child: Image.asset(
                                    "Assets/logo.png",
                                    width: 70,
                                    height: 50,
                                    fit: BoxFit.scaleDown,
                                  )),
                            ),
                            firm_name != null
                                ? Container(
                                    height: 50,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 0),
                                            child: Text(firm_name,
                                                style: const TextStyle(
                                                    fontFamily: 'Myriad',
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 18.0,
                                                    color: Colors.white)))))
                                : Container(
                                    height: 50,
                                    child: const Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                            padding: EdgeInsets.only(top: 0),
                                            child: Text("",
                                                style: TextStyle(
                                                    fontFamily: 'Myriad',
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 18.0,
                                                    color: Colors.white))))),
                          ]),
                          const SizedBox(height: 10),
                          const Divider(
                            color: Colors.grey,
                            height: 1,
                            thickness: 1,
                          ),
                          const SizedBox(height: 30),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Stack(children: <Widget>[
                                        storage == null
                                            ? const Center()
                                            : storage.isEmpty
                                                ? const Center(
                                                    child: Text(
                                                    "No Data Found",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))
                                                : Stack(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    children: [
                                                      Container(
                                                        height: 190,
                                                        width: 190,
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Color.fromRGBO(
                                                              38, 42, 47, 1),
                                                          // color: Colors.red
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        80,
                                                                        85,
                                                                        93,
                                                                        0.5),
                                                                spreadRadius: 0,
                                                                blurRadius: 15),
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        right: 0,
                                                        top: 0,
                                                        bottom: 0,
                                                        child:
                                                            CircularPercentIndicator(
                                                          linearGradient:
                                                              const LinearGradient(
                                                            colors: [
                                                              Colors.green,
                                                              Colors.green,
                                                              Colors.green,
                                                              Colors.orange,
                                                              Colors.orange,
                                                              Colors.orange,
                                                              Colors.red,
                                                              Colors.red,
                                                            ],
                                                          ),
                                                          rotateLinearGradient:
                                                              true,
                                                          circularStrokeCap:
                                                              CircularStrokeCap
                                                                  .round,
                                                          radius: screen.width /
                                                              4.3,
                                                          lineWidth: 17.0,
                                                          percent:
                                                              percentUsed ??
                                                                  0.0001,
                                                          // 0.8,
                                                          animation: true,
                                                          animationDuration:
                                                              3000,
                                                          backgroundColor: /*Color(0xFF131416)*/
                                                              const Color
                                                                      .fromRGBO(
                                                                  29,
                                                                  30,
                                                                  33,
                                                                  1),
                                                          center: Container(
                                                            height: 100,
                                                            width: 100,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            29,
                                                                            30,
                                                                            33,
                                                                            1),
                                                                    boxShadow: [
                                                                  BoxShadow(
                                                                      color: Color.fromRGBO(
                                                                          80,
                                                                          85,
                                                                          93,
                                                                          0.5),
                                                                      spreadRadius:
                                                                          0,
                                                                      blurRadius:
                                                                          15)
                                                                ]),
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(storage ?? "",
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'Myriad',
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          fontSize:
                                                                              14.0,
                                                                          color:
                                                                              Colors.white)),
                                                                  const SizedBox(
                                                                      height:
                                                                          3),
                                                                  const Text(
                                                                    "Space Used",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300,
                                                                        fontFamily:
                                                                            'Myriad',
                                                                        fontSize:
                                                                            11.0,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  buttonsubscription(),
                                                                ]),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                      ]),
                                    )),
                                /* Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: screen.width / 2.3,
                                          height: 65,
                                          margin: EdgeInsets.only(
                                              left: 10.0,
                                              right: 0.0,
                                              top: 0.0,
                                              bottom: 0.0),
                                          //color: Color(0xFF328188),
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
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 0.2,
                                              ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          padding: const EdgeInsets.all(0),
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: 25.0,
                                                      lineWidth: 4.0,
                                                      percent: 0.98,
                                                      animation: true,
                                                      animationDuration: 3000,
                                                      backgroundColor:
                                                          Colors.black45,
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .butt,
                                                      center: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "98%",
                                                              style: new TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontFamily:
                                                                      'Myriad',
                                                                  fontSize:
                                                                      13.0,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Image.asset(
                                                              'Assets/battery.png',
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                            )
                                                          ]),
                                                      progressColor:
                                                          Colors.white,
                                                    )),
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Flexible(
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                "Your Device",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: new TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontFamily:
                                                                        'Myriad',
                                                                    fontSize:
                                                                        12.0,
                                                                    color: Colors
                                                                        .white),
                                                              ))),
                                                      Flexible(
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      left: 10),
                                                              child: Text(
                                                                  "\$ 8,210.00",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          12.0,
                                                                      fontFamily:
                                                                          'Myriad',
                                                                      color: Colors
                                                                          .white)))),
                                                      Flexible(
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 7),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .arrow_drop_up_rounded,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            15),
                                                                    Text(
                                                                        "3.96%",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .w400,
                                                                            fontFamily:
                                                                                'Myriad',
                                                                            fontSize:
                                                                                10.0,
                                                                            color:
                                                                                Colors.white)),
                                                                  ])))
                                                    ])
                                              ])),
                                      const SizedBox(height: 5),
                                      Container(
                                          width: screen.width / 2.3,
                                          height: 65,
                                          margin: EdgeInsets.only(
                                              left: 10.0,
                                              right: 0.0,
                                              top: 0.0,
                                              bottom: 0.0),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                                begin:
                                                    FractionalOffset.bottomLeft,
                                                end: FractionalOffset
                                                    .bottomRight,
                                                transform: GradientRotation(
                                                    math.pi / 4),
                                                colors: [
                                                  Color(0xFF131416),
                                                  Color(0xFF151619),
                                                ]),
                                            boxShadow: boxShadow,
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 0.2,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(5.0),
                                          ),
                                          padding: const EdgeInsets.all(0),
                                          alignment: Alignment.center,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: 25.0,
                                                      animation: true,
                                                      animationDuration: 3000,
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .butt,
                                                      backgroundColor:
                                                          Colors.black45,
                                                      lineWidth: 4.0,
                                                      percent: 0.79,
                                                      center: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "79%",
                                                              style: new TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontFamily:
                                                                      'Myriad',
                                                                  fontSize:
                                                                      13.0,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Image.asset(
                                                              'Assets/cellular.png',
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                            )
                                                          ]),
                                                      progressColor:
                                                          Colors.white,
                                                    )),
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Flexible(
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                "Recharge Device",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: new TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontFamily:
                                                                        'Myriad',
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        12.0,
                                                                    color: Colors
                                                                        .white),
                                                              ))),
                                                      Flexible(
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  "100 GB / 79 GB",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontFamily:
                                                                          'Myriad',
                                                                      fontSize:
                                                                          12.0,
                                                                      color: Colors
                                                                          .white)))),
                                                      Flexible(
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 7),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .arrow_drop_up_rounded,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            15),
                                                                    Text(
                                                                        "3.96%",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .w400,
                                                                            fontFamily:
                                                                                'Myriad',
                                                                            fontSize:
                                                                                10.0,
                                                                            color:
                                                                                Colors.white)),
                                                                  ])))
                                                    ])
                                              ])),
                                      const SizedBox(height: 5),
                                      Container(
                                          width: screen.width / 2.3,
                                          height: 65,
                                          margin: EdgeInsets.only(
                                              left: 10.0,
                                              right: 0.0,
                                              top: 0.0,
                                              bottom: 0.0),
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
                                                  //  Colors.black45,
                                                  Color(0xFF131416),
                                                  Color(0xFF151619),
                                                ]),
                                            boxShadow: boxShadow,
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 0.2,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(5.0),
                                          ),
                                          padding: const EdgeInsets.all(0),
                                          alignment: Alignment.center,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: 25.0,
                                                      lineWidth: 4.0,
                                                      percent: 0.52,
                                                      animation: true,
                                                      animationDuration: 3000,
                                                      backgroundColor:
                                                          Colors.black45,
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .butt,
                                                      center: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Flexible(
                                                                child: Text(
                                                              "52%",
                                                              style: new TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontFamily:
                                                                      'Myriad',
                                                                  fontSize:
                                                                      13.0,
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                            Image.asset(
                                                              'Assets/member.png',
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                            )
                                                          ]),
                                                      progressColor:
                                                          Colors.white,
                                                    )),
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Flexible(
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                "Your Member",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: new TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontFamily:
                                                                        'Myriad',
                                                                    fontSize:
                                                                        12.0,
                                                                    color: Colors
                                                                        .white),
                                                              ))),
                                                      Flexible(
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  "100 / 52",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          12.0,
                                                                      fontFamily:
                                                                          'Myriad',
                                                                      color: Colors
                                                                          .white)))),
                                                      Flexible(
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 7),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .arrow_drop_up_rounded,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            15),
                                                                    Text(
                                                                        "3.96%",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .w400,
                                                                            fontFamily:
                                                                                'Myriad',
                                                                            fontSize:
                                                                                10.0,
                                                                            color:
                                                                                Colors.white)),
                                                                  ])))
                                                    ])
                                              ])),
                                    ]),*/
                                const SizedBox(width: 8),
                                Column(children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyImagesui(
                                              type: widget.type!,
                                            ),
                                          ),
                                        );
                                      },
                                      child: customContainer(
                                          Icons.folder, "File Manager")),
                                  const SizedBox(height: 8),
                                  customContainer(
                                      Icons.currency_rupee, "Invoice Total",
                                      text2: "  Rs. $invoiceTotal"),
                                  const SizedBox(height: 8),
                                  customContainer(Icons.currency_rupee,
                                      "Payment Reciept Total",
                                      text2: "Rs. $paymentTotal"),
                                  const SizedBox(height: 8),
                                  customContainer(
                                      Icons.watch_later, "Remaining Days",
                                      text2: "$remaining_days Days"),
                                ]),
                              ]),
                          const SizedBox(height: 20),
                          Container(
                            width: screen.width,
                            height: 150,
                            margin: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: FractionalOffset.bottomLeft,
                                  end: FractionalOffset.bottomRight,
                                  transform: GradientRotation(math.pi / 4),
                                  //stops: [0.4, 1], //Colors.white
                                  colors: [
                                    Color(0xFF131416),
                                    Color(0xFF151619),
                                  ]),
                              boxShadow: boxShadow,
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsets.all(0),
                            alignment: Alignment.center,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 10),
                                            child: Text(
                                              "Account",
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18.0,
                                                  fontFamily: 'Myriad',
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            right: 10,
                                            top: 0,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Pending",
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'Myriad',
                                                            fontSize: 12.0,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        "-12.4%",
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'Myriad',
                                                            fontSize: 8.0,
                                                            color: const Color(
                                                                0xFFFFB740)),
                                                      ),
                                                    ]))),
                                        const Positioned(
                                          right: 60,
                                          top: 0,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Icon(Icons.circle_rounded,
                                                color: Color(0xFFFFB740),
                                                size: 20),
                                          ),
                                        ),
                                        Positioned(
                                            right: 90,
                                            top: 0,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Expence",
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'Myriad',
                                                            fontSize: 12.0,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        "-12.4%",
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'Myriad',
                                                            fontSize: 8.0,
                                                            color: const Color(
                                                                0xFFFF5A5A)),
                                                      ),
                                                    ]))),
                                        const Positioned(
                                          right: 140,
                                          top: 0,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Icon(Icons.circle_rounded,
                                                color: Color(0xFFFF5A5A),
                                                size: 20),
                                          ),
                                        ),
                                        Positioned(
                                            right: 170,
                                            top: 0,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "income",
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'Myriad',
                                                            fontSize: 12.0,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        "-12.4%",
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'Myriad',
                                                            fontSize: 8.0,
                                                            color: const Color(
                                                                0xFF00A389)),
                                                      ),
                                                    ]))),
                                        const Positioned(
                                          right: 215,
                                          top: 0,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Icon(Icons.circle_rounded,
                                                color: Color(0xFF00A389),
                                                size: 20),
                                          ),
                                        ),
                                      ])),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 7, left: 0),
                                        child: _LineChart(
                                            isShowingMainData:
                                                isShowingMainData),
                                      ))),
                                ]),
                          ),
                          const SizedBox(height: 20),
                          Container(
                              height: 420,
                              // color: Colors.white,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 0.0,
                                  bottom: 0.0),
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
                                boxShadow: boxShadow,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: SfCalendar(
                                view: CalendarView.month,
                                onTap: (CalendarTapDetails details) {
                                  dynamic appointment = details.appointments;
                                  DateTime date = details.date!;
                                  CalendarElement element =
                                      details.targetElement;
                                  var stringList1 = date
                                      .toIso8601String()
                                      .split(new RegExp(r"[T\.]"));
                                  selecteddate = "${stringList1[0]}";
                                  print(selecteddate);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CalenderDetailui(
                                            type: widget.type!,
                                            selecteddate: selecteddate)),
                                  );
                                },

                                headerStyle: const CalendarHeaderStyle(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Myriad',
                                  ),
                                ),
                                viewHeaderStyle: const ViewHeaderStyle(
                                  dayTextStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontFamily: 'Myriad',
                                  ),
                                  dateTextStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontFamily: 'Myriad',
                                  ),
                                ),
                                //cellBorderColor: Colors.white,
                                //cellEndPadding: 50,

                                dataSource: MeetingDataSource(_getDataSource()),
                                monthViewSettings: const MonthViewSettings(
                                    dayFormat: 'EEE',
                                    showAgenda: true,
                                    /*appointmentDisplayMode:
                                        MonthAppointmentDisplayMode.appointment,*/
                                    agendaViewHeight: 120,
                                    //agendaItemHeight: 70,
                                    monthCellStyle: MonthCellStyle(
                                      textStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontFamily: 'Myriad',
                                      ),
                                      trailingDatesTextStyle: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontFamily: 'Myriad',
                                      ),
                                      leadingDatesTextStyle: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontFamily: 'Myriad',
                                      ),
                                    )),
                              )),
                          const SizedBox(height: 20),
                        ]),
                  )),
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

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    for (int i = 0; i < scheduleList.length; i++) {
      meetings.add(Meeting(scheduleList[i].title, scheduleList[i].anno_date,
          scheduleList[i].end_date, const Color(0xFF40C4FF), false));
    }
    for (int i = 0; i < annoList.length; i++) {
      meetings.add(Meeting(annoList[i].anno_desc, annoList[i].start_date,
          annoList[i].end_date, const Color(0xFFFF0000), false));
    }
    for (int i = 0; i < bookingList.length; i++) {
      if (bookingList[i].cust_name != null) {
        meetings.add(Meeting(
            bookingList[i].ocasion + " at " + bookingList[i].cust_name,
            bookingList[i].start_date,
            bookingList[i].end_date,
            const Color(0xFFFFA500),
            false));
      } else {
        meetings.add(Meeting(bookingList[i].ocasion, bookingList[i].start_date,
            bookingList[i].end_date, const Color(0xFFFFA500), false));
      }
    }
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    /* meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));*/
    return meetings;
  }

  Widget buttonsubscription() {
    return Builder(builder: (context) {
      return Container(
          height: 35,
          width: 65,
          //margin: const EdgeInsets.only(left: 5.0, right: 10.0),
          child: Align(
              alignment: AlignmentDirectional.center,
              child: Material(
                borderRadius: BorderRadius.circular(5.0),

                //color: Color(0xFF328188),
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                elevation: 7.0,
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.2, color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0)),
                    padding: const EdgeInsets.all(8.0),
                    /*color: const Color(0xFF328188),*/
                    color: const Color(0xFF151619),
                    child: const Text(
                      "Add \nSubscription",
                      style: TextStyle(
                          fontSize: 8,
                          fontFamily: 'Myriad',
                          fontWeight: FontWeight.w500,
                          color: /*Color(0xFF013133),*/ Colors.white,
                          letterSpacing: 0),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {}),
              )));
    });
  }

  Widget customContainer(IconData icon, String text, {String text2 = ""}) {
    return Container(
        height: 50,
        width: 140,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromRGBO(24, 27, 29, 1),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(80, 85, 93, 0.5),
                  spreadRadius: 0,
                  blurRadius: 2)
            ]),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 21,
            ),
            const SizedBox(
              width: 4,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  text2 ?? "",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Myriad',
                      height: 1.2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontFamily: 'Myriad',
                      height: 1.2),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ));
  }

  Widget _loder() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Platform.isIOS
            ? const CupertinoActivityIndicator(
                radius: 25,
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }
}

class Profileui extends StatefulWidget {
  UserType? type;

  Profileui(UserType type, {Key? key}) : super(key: key) {
    this.type = type;
  }

  // const Profileui({Key key}) : super(key: key);

  @override
  State<Profileui> createState() => _ProfileuiState();
}

class _ProfileuiState extends State<Profileui> {
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  bool isLoding = false;
  TextEditingController nameCntroller = TextEditingController();
  TextEditingController niknameCntroller = TextEditingController();
  TextEditingController firmnameCntroller = TextEditingController();
  TextEditingController mobileCntroller = TextEditingController();
  TextEditingController workprofileCntroller = TextEditingController();
  TextEditingController altmobileCntroller = TextEditingController();

  TextEditingController homeaddCntroller = TextEditingController();
  TextEditingController pincodeCntroller = TextEditingController();
  TextEditingController villageCntroller = TextEditingController();
  TextEditingController emailCntroller = TextEditingController();
  TextEditingController sinceCntroller = TextEditingController();
  TextEditingController yearexCntroller = TextEditingController();
  TextEditingController totalgereCntroller = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController acnoCntroller = TextEditingController();
  TextEditingController ifsccodeCntroller = TextEditingController();
  TextEditingController aadharCntroller = TextEditingController();
  TextEditingController panCntroller = TextEditingController();
  TextEditingController webaddressCntroller = TextEditingController();
  TextEditingController perdaychargeCntroller = TextEditingController();
  var selectedstate, selectedcity, selectedarea, daysbetweeen;
  List<CityListModel> cityList = [];
  List<String> accountTypeList = [
    "Current",
    "saving",
  ];
  String selectedType = "";
  List<StateListModel> stateList = [];
  List<WorkProfileModel> workprofileList = [];
  List<dynamic> _selectedWork = [];
  List<WorkProfileModel> list = [];
  List<String> choose = [];
  List selectwork = [];
  List<AreaListModel> areaList = [];
  DateTime stratdate = DateTime.now();
  File? _image1, _image2, _image3;
  PickedFile? image1;
  final picker = ImagePicker();
  int index = 0;
  var pro_pic,
      name,
      nick_name,
      dob,
      ac_type,
      email,
      ac_no,
      ifsc,
      adhar_no,
      pan_no,
      adhar_img,
      pan_img,
      firm_name,
      work_profile,
      since = "",
      experi,
      total_gare,
      web_add,
      per_day_charge,
      uniq_code,
      address,
      last_name;
  List<MultiSelectItem> _items = [];

  @override
  void initState() {
    super.initState();
    getState();
    if (widget.type == UserType.Customer) {
      getPropic();
      getProfieDetail();
      getWorkProfile();
    } else {
      getCustomerDetail();
    }

    _selectedWork = workprofileList;
  }

  void getCustomerDetail() async {
    if (await DataConnectionChecker().hasConnection) {
      String mobile = await ShareManager.getMobile();
      setLoding();
      RequestData requestData = await API.customerprofiledetailAPI(mobile);
      setLoding();
      if (requestData.status == 1) {
        name = requestData.result[0]["name"];
        last_name = requestData.result[0]["last_name"];
        email = requestData.result[0]["email"];
        uniq_code = requestData.result[0]["uniq_code"];
        address = requestData.result[0]["address"];

        nameCntroller.text = name;
        niknameCntroller.text = last_name;
        mobileCntroller.text = mobile;
        emailCntroller.text = email;
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  void getProfieDetail() async {
    if (await DataConnectionChecker().hasConnection) {
      String mobile = await ShareManager.getMobile();
      setLoding();
      RequestData requestData = await API.profiledetailAPI(mobile);
      setLoding();
      if (requestData.status == 1) {
        name = requestData.result[0]["name"];
        nick_name = requestData.result[0]["nick_name"];
        email = requestData.result[0]["email"];
        ac_type = requestData.result[0]["ac_type"];
        print(ac_type);
        ac_no = requestData.result[0]["ac_no"];
        ifsc = requestData.result[0]["ifsc"];
        adhar_no = requestData.result[0]["adhar_no"];
        pan_no = requestData.result[0]["pan_no"];
        adhar_img = requestData.result[0]["adhar_img"];
        pan_img = requestData.result[0]["pan_img"];
        dob = requestData.result[0]["dob"];
        firm_name = requestData.result[0]["firm_name"];
        work_profile = requestData.result[0]["work_profile"];
        selectedstate = requestData.result[0]["state_id"];
        print(selectedstate);
        selectedcity = requestData.result[0]["city_id"];
        since = requestData.result[0]["since"];
        experi = requestData.result[0]["experi"];
        total_gare = requestData.result[0]["total_gare"];
        web_add = requestData.result[0]["web_add"];
        per_day_charge = requestData.result[0]["per_day_charge"];

        nameCntroller.text = name;
        niknameCntroller.text = nick_name;
        if (dob != "0000-00-00") {
          dobController.text = dob;
        }
        firmnameCntroller.text = firm_name;
        emailCntroller.text = email;
        mobileCntroller.text = mobile;
        totalgereCntroller.text = total_gare;
        if (since != "0000-00-00") {
          sinceCntroller.text = since;
        }
        //actypeCntroller.text = ac_type;
        acnoCntroller.text = ac_no;
        ifsccodeCntroller.text = ifsc;
        aadharCntroller.text = adhar_no;
        panCntroller.text = pan_no;
        yearexCntroller.text = experi;
        webaddressCntroller.text = web_add;
        perdaychargeCntroller.text = per_day_charge;

        if (selectedstate != null) {
          getCity();
        }

        setState(() {
          for (int i = 0; i < accountTypeList.length; i++) {
            if (ac_type == accountTypeList[i]) {
              index = i;
            }
          }
        });
        // setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  void getPropic() async {
    if (await DataConnectionChecker().hasConnection) {
      String mobile = await ShareManager.getMobile();
      // setLoding();
      RequestData requestData = await API.propicdetailAPI(mobile);
      // setLoding();
      if (requestData.status == 1) {
        pro_pic = requestData.result[0]["pro_pic"];
        print(pro_pic);
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  void getState() async {
    if (await DataConnectionChecker().hasConnection) {
      stateList = [];
      // setLoding();
      RequestData requestData = await API.stateListAPI();
      //  setLoding();
      if (requestData.status == 1) {
        for (var i in requestData.result) {
          stateList.add(StateListModel.fromJSON(i));
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  void getWorkProfile() async {
    if (await DataConnectionChecker().hasConnection) {
      workprofileList = [];
      // setLoding();
      RequestData requestData = await API.workprofileListAPI();
      //  setLoding();
      if (requestData.status == 1) {
        for (var i in requestData.result) {
          workprofileList.add(WorkProfileModel.fromJSON(i));
        }
        _items = workprofileList
            .map(
                (value) => MultiSelectItem<WorkProfileModel>(value, value.name))
            .toList();

        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  void getCity() async {
    if (await DataConnectionChecker().hasConnection) {
      cityList = [];
      //setLoding();
      RequestData requestData = await API.cityListAPI(selectedstate);
      // setLoding();
      if (requestData.status == 1) {
        for (var i in requestData.result) {
          cityList.add(CityListModel.fromJSON(i));
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  void getArea() async {
    if (await DataConnectionChecker().hasConnection) {
      areaList = [];
      // setLoding();
      RequestData requestData = await API.areaListAPI(selectedcity);
      // setLoding();
      if (requestData.status == 1) {
        for (var i in requestData.result) {
          areaList.add(AreaListModel.fromJSON(i));
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    // print(screen.width / 4);
    // print(screen.width);

    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF131416),
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: const Text("Profile"))
              ],
            ),
          ),
          body: /*isLoding
              ? _loder()
              : */
              Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            width: screen.width,
            height: screen.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
            ),
            child: SingleChildScrollView(
                child: Form(
              key: _fbKey,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(height: 20),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "MEMBER WORK PROFILE ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? Align(
                        alignment: AlignmentDirectional.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20.0, left: 20.0, right: 20.0, top: 0.0),
                          child: Wrap(
                            direction: Axis.horizontal,
                            //Vertical || Horizontal
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 5.0, right: 10.0),
                                child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    color: const Color(0xFF131416),
                                    child: const Text(
                                      "View Profile",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () async {
                                      String user_id =
                                          await ShareManager.getUserID();
                                      print(user_id);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WorkProfileWebviewScreen(
                                                    type: widget.type!,
                                                    user_id: user_id)),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "PROFILE PHOTO ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 5)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? upLoadProfileData()
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? Align(
                        alignment: AlignmentDirectional.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20.0, left: 20.0, right: 20.0, top: 0.0),
                          child: Wrap(
                            direction: Axis.horizontal,
                            //Vertical || Horizontal
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 5.0, right: 10.0),
                                child: /*Material(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                             // color: Colors.black87,
                                              clipBehavior: Clip.antiAlias,
                                              child: */
                                    MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        color: const Color(0xFF131416),
                                        child: const Text(
                                          "Upload",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () async {
                                          String mobile =
                                              await ShareManager.getMobile();
                                          print(mobile);
                                          if (await DataConnectionChecker()
                                              .hasConnection) {
                                            if (_image1 != null) {
                                              setLoding();
                                              List profilelist = [];
                                              if (_image1 != null) {
                                                profilelist.add(await dio
                                                        .MultipartFile
                                                    .fromFile(_image1!.path));
                                              }
                                              // final token = await getToken();
                                              Map<String, dynamic> map = Map();
                                              map["propic"] = profilelist;
                                              map["mobile"] = mobile;
                                              final data =
                                                  await API.propicAPI(map);
                                              if (data.status == 1) {
                                                setLoding();
                                                Fluttertoast.showToast(
                                                    msg: data.msg);
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Please Select Images");
                                            }
                                          } else {
                                            setLoding();
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please check your internet connection");
                                          }
                                        }),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                const Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    "FULL NAME *",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                nameFormFiled(),
                const SizedBox(height: 20),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "NICK NAME",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "LAST NAME",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                widget.type == UserType.Customer
                    ? niknameFormFiled()
                    : niknameFormFiled(),
                const SizedBox(height: 20),
                widget.type == UserType.Customer
                    ? _pickDate("Select Date", "Date of Birth", dobController)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "FIRM NAME *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? firmnameFormFiled()
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                const Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    "BUSINESS MOBILE NO. *",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                mobileFormFiled(),
                const SizedBox(height: 20),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "WORK PROFILE *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 5)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? MultiSelectDialogField(
                        items: _items,
                        title: const Text("Select"),
                        selectedColor: Colors.blue,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            style: BorderStyle.none,
                            width: 0,
                          ),
                        ),
                        buttonIcon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        buttonText: const Text(
                          "WORK PROFILE",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        onConfirm: (results) {
                          _selectedWork = results;
                          list = _selectedWork.cast<WorkProfileModel>();
                        },
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                const Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    "EMAIL *",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                emailFormFiled(),
                const SizedBox(height: 20),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "State *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 5)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? stateDropDownMenu("Select State", stateList, (newVal) {
                        if (newVal != selectedstate) {
                          cityList.clear();
                          selectedcity = null;
                          selectedstate = newVal;
                          getCity();
                          setState(() {});
                        }
                      }, selectedstate)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "CITY *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 5)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? cityDropDownMenu("Select City", cityList, (newVal) {
                        if (newVal != selectedcity) {
                          selectedcity = newVal;
                          setState(() {});
                        }
                      }, selectedcity)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? _pickDate2(
                        "Select Date", "Established since in *", sinceCntroller)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "Year Of Experience *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? yearexpFormFiled()
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "Total Gere",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? totalgereFormFiled()
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "Registered In SHREE Payment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "Ac Type *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 5)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? typeDropDownMenu("Select Type", accountTypeList,
                        (newVal) {
                        if (newVal != selectedType) {
                          selectedType = newVal!;
                          setState(() {});
                        }
                      }, selectedType)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "A/C No. *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? accountnoFormFiled()
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "IFSC CODE *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? ifsccodeFormFiled()
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "Addharcard No *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? aadharFormFiled()
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "Addharcard *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 5)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? upLoadAddharData()
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "Pancard No *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? pancardFormFiled()
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "Pancard *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 5)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? upLoadPancard()
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "Web Address",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? webaddressFormFiled()
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "Per day Charge *",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? perdaychargeFormFiled()
                    : const SizedBox(),
                widget.type == UserType.Customer
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                buttonLogindata(lblbutton: "UPDATE"),
                const SizedBox(height: 20),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddInstrutment(type: widget.type!)),
                      );
                    },
                    child: const Align(
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        "Instrument Register ?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    )),
                const SizedBox(height: 40),
              ]),
            )),
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
            value: index != null ? accountTypeList[index] : value,
            hint: Text(
              hint,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onChanged: onChange),
      ),
    );
  }

  Widget buttonLogindata({String lblbutton = ""}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
      ),
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 50)),
            backgroundColor: MaterialStateProperty.all(
              const Color(0xFF131416),
            ),
            // elevation: MaterialStateProperty.all(3),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            if (await DataConnectionChecker().hasConnection) {
              if (_fbKey.currentState!.validate()) {
                setLoding();
                List addharlist = [];
                List panlist = [];
                if (_image2 != null) {
                  addharlist
                      .add(await dio.MultipartFile.fromFile(_image2!.path));
                }
                if (_image3 != null) {
                  panlist.add(await dio.MultipartFile.fromFile(_image3!.path));
                }

                List work = [];
                for (int i = 0; i < list.length; i++) {
                  print(list[i].name);
                  work.add(list[i].name);
                }
                String s1 = work.join(', ');
                print(s1);
                String mobile = await ShareManager.getMobile();
                String user_id = await ShareManager.getID();
                Map<String, dynamic> map = Map();
                if (_image2 != null) {
                  map["adhar"] = addharlist;
                }
                if (_image3 != null) {
                  map["pan"] = panlist;
                }
                map["user_id"] = user_id;
                map["adhar_no"] = aadharCntroller.text.trim();
                map["pan_no"] = panCntroller.text.trim();
                map["name"] = nameCntroller.text.trim();
                map["mobile"] = mobile;
                map["nick_name"] = niknameCntroller.text.trim();
                map["dob"] = dobController.text.trim();
                map["firm_name"] = firmnameCntroller.text.trim();
                map["work_profile"] = s1;
                map["state"] = selectedstate;
                map["city"] = selectedcity;
                map["since"] = sinceCntroller.text.trim();
                map["expire"] = yearexCntroller.text.trim();
                map["total_gare"] = totalgereCntroller.text.trim();
                map["web_add"] = webaddressCntroller.text.trim();
                map["per_day_charge"] = perdaychargeCntroller.text.trim();
                final data = await API.profileupdateAPI(map);
                if (data.status == 1) {
                  setLoding();
                  Fluttertoast.showToast(msg: data.msg);
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
            style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.33),
          )),
    );
  }

  Widget webaddressFormFiled() {
    return SizedBox(
      //   height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: webaddressCntroller,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget perdaychargeFormFiled() {
    return SizedBox(
      //   height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: perdaychargeCntroller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Per day Charge";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget aadharFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: aadharCntroller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Aadharcard Detail";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget pancardFormFiled() {
    return SizedBox(
      //   height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: panCntroller,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter PANCard Detail";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget accountnoFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: acnoCntroller,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Account No";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
          hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
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

  Widget ifsccodeFormFiled() {
    return SizedBox(
      //   height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: ifsccodeCntroller,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter IFSC CODE";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
          hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
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

  Widget upLoadProfileData() {
    return SizedBox(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () {
          _showPicker(context);
        },
        child: _image1 != null
            ? Container(
                height: 140,
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                child: Image.file(
                  File(_image1!.path),
                  width: 100.0,
                  height: 140.0,
                  fit: BoxFit.fitHeight,
                ))
            : pro_pic != null && pro_pic != ""
                ? Container(
                    height: 140,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: IMG_PATHAddhar + pro_pic,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => const CircleAvatar(
                        backgroundColor: Colors.black,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ))
                : Container(
                    height: 140,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Icon(Icons.add_circle,
                                size: 60, color: Colors.white)),
                        const Center(
                          child: SizedBox(
                            width: 100,
                            child: Text("Upload Photo",
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        )
                      ],
                    )),
      ),
    ]));
  }

  Widget upLoadAddharData() {
    return SizedBox(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () {
          _showPicker2(context);
        },
        child: _image2 != null
            ? Container(
                height: 140,
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                child: Image.file(
                  File(_image2!.path),
                  width: 100.0,
                  height: 140.0,
                  fit: BoxFit.fitHeight,
                ))
            : adhar_img != null
                ? Container(
                    height: 140,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: IMG_PATHAddhar + adhar_img,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => const CircleAvatar(
                        backgroundColor: Colors.black,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ))
                : Container(
                    height: 140,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Icon(Icons.add_circle,
                                size: 60, color: Colors.white)),
                        const Center(
                          child: SizedBox(
                            width: 100,
                            child: Text("Upload Photo",
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        )
                      ],
                    )),
      ),
    ]));
  }

  Widget upLoadPancard() {
    return SizedBox(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () {
          _showPicker3(context);
        },
        child: _image3 != null
            ? Container(
                height: 140,
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                child: Image.file(
                  File(_image3!.path),
                  width: 100.0,
                  height: 140.0,
                  fit: BoxFit.fitHeight,
                ))
            : pan_img != null
                ? Container(
                    height: 140,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: IMG_PATHAddhar + pan_img,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => const CircleAvatar(
                        backgroundColor: Colors.black,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ))
                : Container(
                    height: 140,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Icon(Icons.add_circle,
                                size: 60, color: Colors.white)),
                        const Center(
                          child: SizedBox(
                            width: 100,
                            child: Text("Upload Photo",
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        )
                      ],
                    )),
      ),
    ]));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showPicker2(context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery2();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera2();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showPicker3(context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery3();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera3();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    cropImage(image!);
  }

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;

    cropImage(image);
  }

  _imgFromGallery2() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    cropImage2(image!);
  }

  _imgFromCamera2() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;

    cropImage2(image);
  }

  _imgFromGallery3() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    cropImage3(image!);
  }

  _imgFromCamera3() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;

    cropImage3(image);
  }

  Future<File> cropImage(XFile file) async {
    final File? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: androidUiSettings,
      iosUiSettings: iosUiSettings,
    );

    if (croppedImage != null) {
      _image1 = croppedImage;
      setState(() {});
    } else {
      print("Image is not cropped.");
    }

    return croppedImage!;
  }

  Future<File> cropImage2(XFile file) async {
    final File? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: androidUiSettings,
      iosUiSettings: iosUiSettings,
    );

    if (croppedImage != null) {
      _image2 = croppedImage;
      setState(() {});
    } else {
      print("Image is not cropped.");
    }

    return croppedImage!;
  }

  Future<File> cropImage3(XFile file) async {
    final File? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: androidUiSettings,
      iosUiSettings: iosUiSettings,
    );

    if (croppedImage != null) {
      _image3 = croppedImage;
      setState(() {});
    } else {
      print("Image is not cropped.");
    }

    return croppedImage!;
  }

  static AndroidUiSettings androidUiSettings = const AndroidUiSettings(
    toolbarTitle: "Cropper",
    toolbarColor: Colors.deepOrange,
    toolbarWidgetColor: Colors.white,
    initAspectRatio: CropAspectRatioPreset.original,
    lockAspectRatio: false,
  );

  static IOSUiSettings iosUiSettings = const IOSUiSettings(
    minimumAspectRatio: 1.0,
  );

  Widget nameFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: nameCntroller,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Full Name";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget niknameFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: niknameCntroller,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget firmnameFormFiled() {
    return SizedBox(
      //   height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: firmnameCntroller,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter FIRM NAME";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget mobileFormFiled() {
    return SizedBox(
      //   height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: mobileCntroller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Mobile No.";
          }
          if (value.length != 10) return 'Mobile Number must be of 10 digit';
          /*  if (RegExp(r"^[a-z0-9][a-z0-9\- ]{0,10}[a-z0-9]$").hasMatch(value)) {
            return "please Enter Valid Mobile No";
          }*/
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget emailFormFiled() {
    return SizedBox(
      //   height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: emailCntroller,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Email Address";
          }
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return "please Enter Valid Email";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget stateDropDownMenu(String hint, List<StateListModel> list,
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
            items: list.map((StateListModel val) {
              return DropdownMenuItem<String>(
                value: val.id,
                child: Text(
                  val.name,
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
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onChanged: onChange),
      ),
    );
  }

  Widget cityDropDownMenu(String hint, List<CityListModel> list,
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
            items: list.map((CityListModel val) {
              return new DropdownMenuItem<String>(
                value: val.city_id,
                child: new Text(
                  val.city_name,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              );
            }).toList(),
            //value: index != null ? list[index] : value,
            value: value,
            hint: Text(
              hint,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onChanged: onChange),
      ),
    );
  }

  Widget sinceFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: sinceCntroller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Established since in ";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget yearexpFormFiled() {
    return SizedBox(
      //   height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: yearexCntroller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Year Of Experience ";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget totalgereFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: totalgereCntroller,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget _pickDate(
      String hint, String value, TextEditingController controller) {
    return SizedBox(
      //padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$value :",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              )),
          const SizedBox(height: 5),
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
          Text("$value :",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              )),
          const SizedBox(height: 5),
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

  Future<Null> _selectDate(TextEditingController selectedDate) async {
    final now = new DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1947, 8),
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
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        selectedDate.value = TextEditingValue(text: formattedDate);
      });
    }
  }

  Future<Null> _selectDate2(TextEditingController selectedDate) async {
    final now = new DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1947, 8),
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
        selectedDate.value = TextEditingValue(text: formattedDate);
      });
    }
    if (stratdate != null && now != null) {
      experi = daysBetween(stratdate, now);
      // print(daysbetweeen);
      yearexCntroller.text = experi.toString();
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inDays / 365).round();
  }

  Widget _loder() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Platform.isIOS
            ? const CupertinoActivityIndicator(
                radius: 25,
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({this.isShowingMainData = false});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData2 : sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0.9,
        maxX: 12.8,
        maxY: 6,
        minY: 0.5,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), //leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        lineChartBarData2_2,
        lineChartBarData2_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1m';
        break;
      case 2:
        text = '2m';
        break;
      case 3:
        text = '3m';
        break;
      case 4:
        text = '5m';
        break;
      case 5:
        text = '6m';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: false,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('', style: style);
        break;
      case 7:
        text = const Text('', style: style);
        break;
      case 12:
        text = const Text('', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: false,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: const Color(0xff4af699),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 1.5),
          FlSpot(5, 1.4),
          FlSpot(7, 3.4),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: const Color(0xffaa4cfc),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: const Color(0x00aa4cfc),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: const Color(0xff27b6fc),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(10, 1.3),
          FlSpot(13, 2.5),
        ],
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        color: const Color(0x444af699),
        barWidth: 4,
        isStrokeCapRound: true,
        isStrokeJoinRound: true,
        curveSmoothness: 0.35,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x224af699),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        color: const Color(0x99aa4cfc),
        barWidth: 4,
        isStrokeCapRound: true,
        isStrokeJoinRound: true,
        curveSmoothness: 0.35,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x33aa4cfc),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        color: const Color(0x4427b6fc),
        barWidth: 4,
        isStrokeCapRound: true,
        isStrokeJoinRound: true,
        curveSmoothness: 0.35,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x2227b6fc),
          //cutOffY: 10.0,
          //  applyCutOffY: true,
        ),
        /* aboveBarData: BarAreaData(
      show: true,
      color: const Color(0x2227b6fc),
      cutOffY:  5.0,
      applyCutOffY: true,
    ),*/
        spots: const [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
      );
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

class DrawerData extends StatelessWidget {
  final BuildContext context;
  final UserType type;

  DrawerData(this.context, this.type);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Color(0xFF353A3F),
              Color(0xFF17191C),
            ])),
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: getList(),
                )
              ]),
            )));
  }

  List<Widget> getList() {
    return [
      _listTiles2(
        title: "Home",
        onTap: () async {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen(type: type)),
              (route) => false);
        },
      ),

      /* _listTiles5(
        title: "E-Commerce",
        onTap: () async {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BuySellMainPage(type: type)),
          );
        },
      ),*/
      type == UserType.Customer
          ? _listTiles3(
              title: "My Announcement",
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyAnnouncement(type: type)),
                );
              },
            )
          : const SizedBox(),
      type == UserType.Customer
          ? _listTiles3(
              title: "Bookings",
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookingListScreen(type: type)),
                );
              },
            )
          : const SizedBox(),
      type == UserType.Customer
          ? _listTiles3(
              title: "Exposing Request",
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExposingRequestui(type: type)),
                );
              },
            )
          : const SizedBox(),
      _listTiles3(
        title: "File Manager",
        onTap: () async {
          print("i am going to file manager");
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyImagesui(type: type)),
          );
        },
      ),
      type == UserType.Lab
          ? _listTiles4(
              title: "Lab Order List",
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LABOrderHistoryScreen(type: type)),
                );
              },
            )
          : const SizedBox(),
      type == UserType.Customer
          ? _listTiles4(
              title: "Location For Shoot",
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LocationForshoot(type: type)),
                );
              },
            )
          : const SizedBox(),
      type == UserType.Customer
          ? _listTiles4(
              title: "E-Learning",
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ELearningCategory(type: type)),
                );
              },
            )
          : const SizedBox(),
      /*  type == UserType.Customer
          ? _listTiles4(
        title: "ITR",
        onTap: () async {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ITRListScreen(type: type)),
          );
        },
      )
          : SizedBox(),*/
      type == UserType.Customer
          ? _listTiles4(
              title: "Quotation Book",
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuotationListScreen(type: type)),
                );
              },
            )
          : const SizedBox(),
      type == UserType.Customer
          ? _listTiles4(
              title: "Bill Book",
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InvoiceList(type: type)));
              })
          : SizedBox(),
      type == UserType.Customer
          ? _listTiles4(
              title: "Payment Receipt",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentReceiptui(type: type)));
              })
          : SizedBox(),
      type == UserType.Customer
          ? _listTiles4(
              title: "Billing",
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MemBilling(type: type)),
                );
              },
            )
          : const SizedBox(),
      type == UserType.Customer
          ? _listTiles4(
              title: "Plans",
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PackageScreenui(type: type)),
                );
              },
            )
          : const SizedBox(),
      type == UserType.Customer
          ? _listTiles4(
              title: "Work Profile",
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WorkProfile(type: type)),
                );
              },
            )
          : const SizedBox(),
      type == UserType.Customer
          ? _listTiles6(
              title: "Remove Account",
              onTap: () async {
                Navigator.of(context).pop();
                _displayTextInputDialog(context);
              },
            )
          : const SizedBox(),
      type == UserType.Customer
          ? _listTiles3(
              title: "T&C",
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TermsAndConditionui(type: type)),
                );
              },
            )
          : const SizedBox(),
      _listTiles(
        title: "Logout",
        onTap: () async {
          print("i got pressed and type is = $type");
          if (type == UserType.Customer) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
            await ShareManager.logout(context);
          } else if (type == UserType.Lab) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
            await ShareManager.logout(context);
          }
        },
      ),
    ];
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure to remove your account?'),
            content: const Text(
                'Once you remove your account then your all data will be deleted from this application.'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  removememAPi();
                },
              ),
            ],
          );
        });
  }

  Future<void> _custdisplayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure to remove your account?'),
            content: const Text(
                'Once you remove your account then your all data will be deleted from this application.'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  removecustAPi();
                },
              ),
            ],
          );
        });
  }

  Widget _listTiles({String title = "", void Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      leading: const Icon(
        Icons.logout,
        color: Colors.white,
      ),
    );
  }

  Widget _listTiles1({String title = "", void Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      leading: const Icon(
        Icons.history,
        color: Colors.white,
      ),
    );
  }

  Widget _listTiles2({String title = "", void Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      leading: const Icon(
        Icons.home,
        color: Colors.white,
      ),
    );
  }

  Widget _listTiles3({String title = "", void Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      leading: const Icon(
        Icons.announcement,
        color: Colors.white,
      ),
    );
  }

  Widget _listTiles4({String title = "", void Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      leading: const Icon(
        Icons.location_city_outlined,
        color: Colors.white,
      ),
    );
  }

  Widget _listTiles6({String title = "", Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      leading: const Icon(
        Icons.person_remove,
        color: Colors.white,
      ),
    );
  }

  Widget _listTiles5({String title = "", Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      leading: const Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
    );
  }

  Future<void> removememAPi() async {
    String user_id = await ShareManager.getUserID();
    final requestData = await API.removeaccmemAPI(user_id);
    if (requestData.status == 1) {
      Fluttertoast.showToast(msg: requestData.msg);
      if (type == UserType.Customer) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
        await ShareManager.logout(context);
      } else if (type == UserType.Lab) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
        await ShareManager.logout(context);
      }
    } else {
      Fluttertoast.showToast(msg: requestData.msg);
    }
  }

  Future<void> removecustAPi() async {
    String user_id = await ShareManager.getUserID();
    final requestData = await API.removeacccustAPI(user_id);
    if (requestData.status == 1) {
      Fluttertoast.showToast(msg: requestData.msg);
      if (type == UserType.Customer) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
        await ShareManager.logout(context);
      } else if (type == UserType.Lab) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
        await ShareManager.logout(context);
      }
    } else {
      Fluttertoast.showToast(msg: requestData.msg);
    }
  }
}
