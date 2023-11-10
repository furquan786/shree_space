import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:shreegraphic/generatePaymentReceipt.dart';
import 'package:shreegraphic/quotationItemDetailui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Backend/api_request.dart';
import '../HomeScreen.dart';
import 'Config/enums.dart';
import 'Model/QuotationModel.dart';
import 'Model/announcement_model.dart';
import 'Model/invoiceList_model.dart';
import 'Model/quotation_model.dart';
import 'QuotationListScreen.dart';
import 'editQuotationBook.dart';
import 'invoiceUpdateQuotationBook.dart';

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

class InvoiceDetailsui extends StatefulWidget {
  String index;
  final UserType type;

  InvoiceDetailsui({this.index = "", required this.type, Key? key})
      : super(key: key);

  @override
  State<InvoiceDetailsui> createState() => _InvoiceDetailsuiState();
}

class _InvoiceDetailsuiState extends State<InvoiceDetailsui> {
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
    return WillPopScope(
        onWillPop: () async {
          // Handle the back button press here
          // You can perform any logic or conditions before navigating back

          // For example, navigate to the next page if certain conditions are met
          if (shouldNavigateToNextPage()) {
            navigateToNextPage(context);
            return Future.value(false); // Prevent default back navigation
          }

          // Allow default back navigation
          return Future.value(true);
        },
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
              backgroundColor: const Color(0xFF131416),
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
              selectedItemColor: const Color(0xFF131416),
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
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: ""),
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
            backgroundColor: const Color(0xFF131416),
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
                    child: const Text("Invoice Detail"))
              ],
            ),
          ),
          body: _children[currentIndex],
        ));
  }

  bool shouldNavigateToNextPage() {
    // Implement your logic here to determine if the next page should be navigated to
    // Return true if conditions are met, false otherwise
    return true;
  }

  Future<void> navigateToNextPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QuotationListScreen(type: widget.type)),
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
  List<InvoiceListModel> invoiceList = [];

  var startdate, enddate;
  String valueText = "";
  String codeDialog = "";
  TextEditingController _textFieldController = TextEditingController();

  getQuotationList() async {
    invoiceList = [];
    setLoding();
    final requestData = await API.invoiceDetailApi(widget.index);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        invoiceList.add(InvoiceListModel.fromJson(i));
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
    getQuotationList();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Stack(children: [
      Container(
          width: screen.width,
          height: screen.height,
          decoration: const BoxDecoration(
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
                  invoiceList == null
                      ? const Center()
                      : invoiceList.isEmpty
                          ? const Center(
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
                                  itemCount: invoiceList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    var stringList1 = invoiceList[i]
                                        .startDate
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

                                    var stringList2 = invoiceList[i]
                                        .endDate
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
                                                        "Quotation No.",
                                                        _parseHtmlString(
                                                            invoiceList[i]
                                                                .qotNo))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Customer Name",
                                                        _parseHtmlString(
                                                            invoiceList[i]
                                                                .custName))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Customer Unique Code",
                                                        _parseHtmlString(
                                                            invoiceList[i]
                                                                .custUniqCode))),
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
                                                        "Occation",
                                                        _parseHtmlString(
                                                            invoiceList[i]
                                                                .ocation))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "State",
                                                        _parseHtmlString(
                                                            invoiceList[i]
                                                                .stateN))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "City",
                                                        _parseHtmlString(
                                                            invoiceList[i]
                                                                .cityN))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "City Pin",
                                                        _parseHtmlString(
                                                            invoiceList[i]
                                                                .cityPin))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Address",
                                                        _parseHtmlString(
                                                            invoiceList[i]
                                                                .address))),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData2(
                                                        "Quotation Item")),
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        "Status",
                                                        _parseHtmlString(
                                                            invoiceList[i]
                                                                .status))),
                                                invoiceList[i]
                                                                .whyCancel !=
                                                            "" &&
                                                        invoiceList[i]
                                                                .whyCancel !=
                                                            null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: _rowData(
                                                            "Cancel Reason",
                                                            _parseHtmlString(
                                                                invoiceList[i]
                                                                    .whyCancel)))
                                                    : const SizedBox(),
                                                invoiceList[i].cancelBy != "" &&
                                                        invoiceList[i]
                                                                .cancelBy !=
                                                            null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: _rowData(
                                                            "Cancel By",
                                                            _parseHtmlString(
                                                                invoiceList[i]
                                                                    .cancelBy)))
                                                    : const SizedBox(),
                                                invoiceList[i].status !=
                                                        "cancel"
                                                    ? Align(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: Wrap(
                                                            direction:
                                                                Axis.horizontal,
                                                            //Vertical || Horizontal
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8),
                                                                child:
                                                                    Container(
                                                                  width: screen
                                                                          .width *
                                                                      0.340,
                                                                  height: 43,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    boxShadow:
                                                                        boxShadow,
                                                                    gradient: const LinearGradient(
                                                                        begin: FractionalOffset.bottomLeft,
                                                                        end: FractionalOffset.bottomRight,
                                                                        transform: GradientRotation(math.pi / 4),
                                                                        //stops: [0.4, 1],
                                                                        colors: [
                                                                          Color(
                                                                              0xFF131416),
                                                                          Color(
                                                                              0xFF151619),
                                                                        ]),
                                                                  ),
                                                                  child:
                                                                      ElevatedButton(
                                                                          style:
                                                                              ButtonStyle(
                                                                            shape:
                                                                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                              RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                              ),
                                                                            ),
                                                                            minimumSize:
                                                                                MaterialStateProperty.all(const Size(double.infinity, 50)),
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(
                                                                              const Color(0xFF131416),
                                                                            ),
                                                                            // elevation: MaterialStateProperty.all(3),
                                                                            shadowColor:
                                                                                MaterialStateProperty.all(Colors.transparent),
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            print("index is = ${widget.index}");
                                                                            _displayDeleteDialog(context,
                                                                                widget.index);
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            "Delete",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontFamily: 'Montserrat-Bold',
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.white,
                                                                                letterSpacing: 1.33),
                                                                          )),
                                                                ),
                                                              ),
                                                              // invoiceList[i]
                                                              //             .paid !=
                                                              //         "1"
                                                              //     ? Padding(
                                                              //         padding: const EdgeInsets
                                                              //                 .only(
                                                              //             right:
                                                              //                 8),
                                                              //         child:
                                                              //             Container(
                                                              //           width: screen.width *
                                                              //               0.340,
                                                              //           height:
                                                              //               43,
                                                              //           decoration:
                                                              //               BoxDecoration(
                                                              //             borderRadius:
                                                              //                 BorderRadius.circular(10),
                                                              //             boxShadow:
                                                              //                 boxShadow,
                                                              //             gradient: const LinearGradient(
                                                              //                 begin: FractionalOffset.bottomLeft,
                                                              //                 end: FractionalOffset.bottomRight,
                                                              //                 transform: GradientRotation(math.pi / 4),
                                                              //                 //stops: [0.4, 1],
                                                              //                 colors: [
                                                              //                   Color(0xFF131416),
                                                              //                   Color(0xFF151619),
                                                              //                 ]),
                                                              //           ),
                                                              //           child: ElevatedButton(
                                                              //               style: ButtonStyle(
                                                              //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                              //                   RoundedRectangleBorder(
                                                              //                     borderRadius: BorderRadius.circular(5.0),
                                                              //                   ),
                                                              //                 ),
                                                              //                 minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                                                              //                 backgroundColor: MaterialStateProperty.all(
                                                              //                   Color(0xFF131416),
                                                              //                 ),
                                                              //                 // elevation: MaterialStateProperty.all(3),
                                                              //                 shadowColor: MaterialStateProperty.all(Colors.transparent),
                                                              //               ),
                                                              //               onPressed: () async {
                                                              //                 // Navigator.push(
                                                              //                 //   context,
                                                              //                 //   MaterialPageRoute(builder: (context) => EditQuotationBookui(type: widget.type, id: invoiceList[i].id)),
                                                              //                 // );
                                                              //               },
                                                              //               child: Text(
                                                              //                 "Edit",
                                                              //                 style: TextStyle(fontSize: 14, fontFamily: 'Montserrat-Bold', fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1.33),
                                                              //               )),
                                                              //         ),
                                                              //       )
                                                              //     : SizedBox(),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                Align(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .center,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.8,
                                                                vertical: 5.8),
                                                        child: Wrap(
                                                            direction:
                                                                Axis.horizontal,
                                                            //Vertical || Horizontal
                                                            children: <Widget>[
                                                              invoiceList[i]
                                                                          .paid !=
                                                                      "1"
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              8),
                                                                      child:
                                                                          Container(
                                                                        width: screen.width *
                                                                            0.340,
                                                                        height:
                                                                            53,
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
                                                                              minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
                                                                              backgroundColor: MaterialStateProperty.all(
                                                                                const Color(0xFF131416),
                                                                              ),
                                                                              // elevation: MaterialStateProperty.all(3),
                                                                              shadowColor: MaterialStateProperty.all(Colors.transparent),
                                                                            ),
                                                                            onPressed: () async {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) => GeneratePaymentReceiptui(type: widget.type!, id: invoiceList[i].id)),
                                                                              );
                                                                            },
                                                                            child: const Text(
                                                                              "Generate Payment Receipt",
                                                                              style: TextStyle(fontSize: 14, fontFamily: 'Montserrat-Bold', fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1.33),
                                                                            )),
                                                                      ),
                                                                    )
                                                                  : const SizedBox(),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8),
                                                                child:
                                                                    Container(
                                                                  width: screen
                                                                          .width *
                                                                      0.340,
                                                                  height: 43,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    boxShadow:
                                                                        boxShadow,
                                                                    gradient: const LinearGradient(
                                                                        begin: FractionalOffset.bottomLeft,
                                                                        end: FractionalOffset.bottomRight,
                                                                        transform: GradientRotation(math.pi / 4),
                                                                        //stops: [0.4, 1],
                                                                        colors: [
                                                                          Color(
                                                                              0xFF131416),
                                                                          Color(
                                                                              0xFF151619),
                                                                        ]),
                                                                  ),
                                                                  child:
                                                                      ElevatedButton(
                                                                          style:
                                                                              ButtonStyle(
                                                                            shape:
                                                                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                              RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                              ),
                                                                            ),
                                                                            minimumSize:
                                                                                MaterialStateProperty.all(const Size(double.infinity, 50)),
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(
                                                                              const Color(0xFF131416),
                                                                            ),
                                                                            // elevation: MaterialStateProperty.all(3),
                                                                            shadowColor:
                                                                                MaterialStateProperty.all(Colors.transparent),
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            print("index is = ${widget.index}");
                                                                            _launchURL(widget.index);
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            "Receipt Download",
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

  _launchURL(String id) async {
    final Uri url = Uri.parse('https://shreespace.com/Home/view_quot/$id');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch');
    }
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  Future<void> _displayDeleteDialog(BuildContext context, String id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure want to delete ?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    print(codeDialog);
                    Navigator.pop(context);
                    deleteAPi(id);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> deleteAPi(String id) async {
    setLoding();
    final requestData = await API.deleteInvoiceAPI(id);
    if (requestData.status == 1) {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen(type: widget.type!)),
          (route) => false);
    } else {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
    }
  }

  Widget _rowData(String title, String value) {
    return value == null || value == ""
        ? Container()
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Text(
                  ":",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _rowData2(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            ":",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.440,
              height: 43,
              decoration: BoxDecoration(
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
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 50)),
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xFF131416),
                    ),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () async {
                    Get.to(QuotationItemDetailhistoryui(
                        index: widget.index, type: widget.type!));
                  },
                  child: const Text(
                    "View",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat-Bold',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1.33),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
