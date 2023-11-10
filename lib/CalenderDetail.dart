import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:html/parser.dart';
import '../Backend/api_request.dart';
import '../Backend/share_manager.dart';
import '../HomeScreen.dart';
import 'Config/enums.dart';
import 'Model/announcement_model.dart';
import 'addSchedule.dart';
import 'myannuonacementDetailui.dart';

class CalenderDetailui extends StatefulWidget {
  final UserType type;
  String selecteddate;

  CalenderDetailui({required this.type, this.selecteddate = "", Key? key})
      : super(key: key);

  @override
  State<CalenderDetailui> createState() => _CalenderDetailuiState();
}

class _CalenderDetailuiState extends State<CalenderDetailui> {
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
      HomePlaceholderWidget(widget.type, widget.selecteddate),
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
                    child: Text("Schedule"))
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
  var selecteddate;

  HomePlaceholderWidget(UserType type, var selecteddate, {Key? key})
      : super(key: key) {
    this.type = type;
    this.selecteddate = selecteddate;
  }

  @override
  State<HomePlaceholderWidget> createState() => _HomeholderWidgetState();
}

class _HomeholderWidgetState extends State<HomePlaceholderWidget> {
  bool isLoding = false;

  var selecteddate;
  List<AnnouncementModel> scheduleList = [];
  List<AnnouncementModel> annoList = [];
  List<AnnouncementModel> bookingList = [];
  var formatedDate, startdate, enddate;
  int end = 0, today = 0;
  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getAnnoList();
    getBookingList();
  }

  getData() async {
    scheduleList = [];
    String user_id = await ShareManager.getUserID();
    setLoding();
    final requestData =
        await API.dateScheduleList(user_id, widget.selecteddate);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        scheduleList.add(AnnouncementModel.fromJson(i));
      }
      setState(() {});
    }
  }

  getAnnoList() async {
    annoList = [];
    String user_id = await ShareManager.getUserID();
    setLoding();
    final requestData = await API.dateannoList(user_id, widget.selecteddate);
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
    final requestData = await API.datebookingList(user_id, widget.selecteddate);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        bookingList.add(AnnouncementModel.fromJson(i));
      }
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                            height: 420,
                            // color: Colors.white,
                            margin: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 0.0, bottom: 0.0),
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
                                CalendarElement element = details.targetElement;
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

                              headerStyle: CalendarHeaderStyle(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Myriad',
                                ),
                              ),
                              viewHeaderStyle: ViewHeaderStyle(
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
                              monthViewSettings: MonthViewSettings(
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
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: addReferralButton(),
                        ),
                        const SizedBox(height: 15),
                        scheduleList == null
                            ? Center()
                            : scheduleList.isEmpty
                                ? Center()
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
                                        itemCount: scheduleList.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          var stringList1 = scheduleList[i]
                                              .anno_date
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

                                          var stringList2 = scheduleList[i]
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
                                                        Color(0xFF40C4FF),
                                                        Color(0xFF40C4FF),
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
                                                              "Title",
                                                              _parseHtmlString(
                                                                  scheduleList[
                                                                          i]
                                                                      .title))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Description",
                                                              _parseHtmlString(
                                                                  scheduleList[
                                                                          i]
                                                                      .anno_desc))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Start At",
                                                              startdate)),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "End At",
                                                              enddate)),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Location",
                                                              _parseHtmlString(
                                                                  scheduleList[
                                                                          i]
                                                                      .location))),
                                                    ]),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                        annoList == null
                            ? Center()
                            : annoList.isEmpty
                                ? Center()
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
                                        itemCount: annoList.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          if (annoList[i].anno_date_new != "") {
                                            DateFormat dateFormat = DateFormat(
                                                "dd-MM-yyyy HH:mm:ss");
                                            DateTime dateTime =
                                                dateFormat.parse(
                                                    annoList[i].anno_date_new);
                                            formatedDate = DateFormat(
                                                    'dd-MM-yyyy – kk:mm:a')
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
                                              Get.to(
                                                  MyAnnuonacementDetailhistoryui(
                                                      index: annoList[i]
                                                          .id
                                                          .toString(),
                                                      type: widget.type!));
                                            },
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
                                                        Color(0xFFFF0000),
                                                        Color(0xFFFF0000),
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
                                                              "Occasion",
                                                              _parseHtmlString(
                                                                  annoList[i]
                                                                      .occasion))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Description",
                                                              _parseHtmlString(
                                                                  annoList[i]
                                                                      .anno_desc))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Start At",
                                                              startdate)),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "End At",
                                                              enddate)),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Book Days",
                                                              _parseHtmlString(
                                                                  annoList[i]
                                                                      .days))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Occasion Location",
                                                              _parseHtmlString(
                                                                  annoList[i]
                                                                      .occ_loc))),
                                                    ]),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                        bookingList == null
                            ? Center()
                            : bookingList.isEmpty
                                ? Center()
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
                                        itemCount: bookingList.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          if (bookingList[i].cr_date != "") {
                                            DateFormat dateFormat = DateFormat(
                                                "dd-MM-yyyy HH:mm:ss");
                                            DateTime dateTime = dateFormat
                                                .parse(bookingList[i].cr_date);
                                            formatedDate = DateFormat(
                                                    'dd-MM-yyyy – kk:mm:a')
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

                                          var enddate1 = DateFormat('dd')
                                              .format(dateTime2);

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
                                                        Color(0xFFFFA500),
                                                        Color(0xFFFFA500),
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
                                                      bookingList[i].cust_name != null
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16.8,
                                                                      vertical:
                                                                          5.8),
                                                              child: _rowData(
                                                                  "Occasion",
                                                                  _parseHtmlString(bookingList[i]
                                                                          .ocasion +
                                                                      " at " +
                                                                      bookingList[i]
                                                                          .cust_name)))
                                                          : Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                              child: _rowData(
                                                                  "Occasion",
                                                                  _parseHtmlString(
                                                                      bookingList[i]
                                                                          .ocasion))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Requirement",
                                                              _parseHtmlString(
                                                                  bookingList[i]
                                                                      .requirement))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Start At",
                                                              startdate)),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "End At",
                                                              enddate)),
                                                      bookingList[i]
                                                                  .shoot_location !=
                                                              null
                                                          ? Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                              child: _rowData(
                                                                  "Location",
                                                                  _parseHtmlString(
                                                                      bookingList[
                                                                              i]
                                                                          .shoot_location)))
                                                          : SizedBox(),
                                                    ]),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                        const SizedBox(height: 30),
                      ]),
                ),
              ))),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MaterialButton(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent)),
          color: Colors.white,
          height: 50,
          // minWidth: double.infinity,
          child: const Text(
            "Add Schedule",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddScheduleui(type: widget.type!)),
            );
          }),
    );
  }
}
