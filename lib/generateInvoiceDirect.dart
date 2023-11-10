import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shreegraphic/quotationDetailui.dart';
import '../Backend/api_request.dart';
import '../Backend/share_manager.dart';
import '../HomeScreen.dart';
import '../Model/request_data.dart';
import 'Backend/urls.dart';
import 'Config/enums.dart';
import 'Equipment.dart';
import 'Model/QuotationModel.dart';
import 'Model/area_list.dart';
import 'Model/city_list.dart';
import 'Model/state_list.dart';
import 'Model/workprofileModel.dart';
import 'UpdateQuationItem.dart';

class GenerateInvoiceDirectui extends StatefulWidget {
  //const AddAnnuoncementui({Key key}) : super(key: key);
  final UserType type;
  String id;

  GenerateInvoiceDirectui({required this.type, this.id = "", Key? key})
      : super(key: key);

  @override
  State<GenerateInvoiceDirectui> createState() =>
      _GenerateInvoiceDirectuiState();
}

class _GenerateInvoiceDirectuiState extends State<GenerateInvoiceDirectui> {
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
        child: Stack(
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
                        child: Text("GENERATE INVOICE"))
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
          builder: (context) =>
              QuotationDetailhistoryui(index: widget.id, type: widget.type)),
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
  TextEditingController brandnameController = TextEditingController();
  TextEditingController customernameController = TextEditingController();
  TextEditingController customeruniquecodeController = TextEditingController();
  TextEditingController citypinController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController occasionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController requirmentController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();
  DateTime stratdate = DateTime.now(), enddate = DateTime.now();

  File? _image1;
  var selectedstate = "", selectedcity = "", daysbetweeen;
  List<StateListModel> stateList = [];
  List<CityListModel> cityList = [];
  List<QuotationModel> quotationList = [];
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
  int totalQuotation = 1;
  List<WorkProfileModel> workprofileList = [];
  List<QuotationModel> quotationitemList = [];
  int index = 0, index1 = 0;
  bool unchecked = false;
  bool checked = true;
  var cust_name,
      cust_uniq_code,
      start_date,
      end_date,
      ocation,
      state,
      city,
      state_n,
      city_n,
      city_pin,
      address,
      logo,
      b_name,
      qot_no,
      qot_id;

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getState();
    getWorkProfile();
  }

  void getWorkProfile() async {
    if (await DataConnectionChecker().hasConnection) {
      workprofileList = [];
      // setLoding();
      RequestData requestData = await API.workprofileListAPI();
      print("workprofile list is = ${requestData.result}");
      //  setLoding();
      if (requestData.status == 1) {
        for (var i in requestData.result) {
          workprofileList.add(WorkProfileModel.fromJSON(i));
        }

        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  void getState() async {
    if (await DataConnectionChecker().hasConnection) {
      stateList = [];
      //  setLoding();
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

  void getCity() async {
    if (await DataConnectionChecker().hasConnection) {
      cityList = [];
      setLoding();
      RequestData requestData = await API.cityListAPI(selectedstate);
      setLoding();
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
                            "Customer Unique code *",
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
                            "Customer Name *",
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
                        _pickDate(
                            "Select Date", "Start Date *", dateController),
                        const SizedBox(height: 20),
                        _pickDate2(
                            "Select Date", "END Date *", enddateController),
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
                        occasionFormFiled(),
                        const SizedBox(height: 20),
                        const Align(
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
                        ),
                        const SizedBox(height: 5),
                        stateDropDownMenu("Select State", stateList, (newVal) {
                          if (newVal != selectedstate) {
                            cityList.clear();
                            selectedcity = "";
                            selectedstate = newVal!;
                            getCity();
                            setState(() {});
                          }
                        }, selectedstate),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "City *",
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
                        cityDropDownMenu("Select City", cityList, (newVal) {
                          if (newVal != selectedcity) {
                            //areaList.clear();
                            selectedcity = newVal!;
                            //getArea();
                            setState(() {});
                          }
                        }, selectedcity),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "City Pin *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        cityPinFormFiled(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Address *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        addressFormFiled(),
                        const SizedBox(height: 20),
                        Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Your Logo *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        upLoadProfileData(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Brand Name *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        brandnameFormFiled(),
                        const SizedBox(height: 20),
                        _addButton(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Uncheck The item Which You Don't Want to add in Invoice",
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
                        quotationitemList == null
                            ? Center()
                            : quotationitemList.isEmpty
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
                                        itemCount: quotationitemList.length,
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
                                                              "Requirement",
                                                              _parseHtmlString(
                                                                  quotationitemList[
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
                                                              "Amount",
                                                              _parseHtmlString(
                                                                  quotationitemList[
                                                                          i]
                                                                      .amount))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData(
                                                              "Remark",
                                                              _parseHtmlString(
                                                                  quotationitemList[
                                                                          i]
                                                                      .remark))),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.8,
                                                                  vertical:
                                                                      5.8),
                                                          child: _rowData1(
                                                              "Select", i)),
                                                    ]),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                        const SizedBox(height: 20),
                        buttondata(lblbutton: "Generate"),
                        const SizedBox(height: 30),
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

  Widget _rowData1(String title, int i) {
    return Container(
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
          const Text(
            ":",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
              child: Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  side: MaterialStateBorderSide.resolveWith(
                    (states) =>
                        const BorderSide(width: 1.0, color: Colors.white),
                  ),
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                  value:
                      quotationitemList[i].selec == false ? unchecked : checked,
                  onChanged: (bool? value) {
                    setState(() {
                      quotationitemList[i].selec = value!;
                    });
                  })),
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
                  value: quotationList.length == 0
                      ? totalQuotation
                      : quotationList.length,
                  hint: const Text(
                    "",
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (int? value) {
                    setState(() {
                      totalQuotation = value!;
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
              "Quoatation Item",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => EquipmentUi(
                    setQuaList: (list) {
                      setState(() {
                        quotationList = list;
                      });
                    },
                    count: totalQuotation,
                    workprofileList: workprofileList,
                    quotationList: quotationList,
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
        enddate = picked;
        end_date = DateFormat('yyyy-MM-dd').format(picked);
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        selectedDate.value = TextEditingValue(text: formattedDate);
      });
    }
    if (stratdate != null && enddate != null) {
      daysbetweeen = daysBetween(stratdate, enddate);
      print(daysbetweeen);
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

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
        start_date = DateFormat('yyyy-MM-dd').format(picked);
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        selectedDate.value = TextEditingValue(text: formattedDate);
      });
    }
    if (stratdate != null && enddate != null) {
      daysbetweeen = daysBetween(stratdate, enddate);
      print(daysbetweeen);
    }
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
            value: value,
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
            value: value,
            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onChanged: onChange),
      ),
    );
  }

  Widget camreaDropDownMenu(String hint, List<String> list,
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
              style: TextStyle(color: Colors.grey, fontSize: 12),
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
                  style: TextStyle(
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
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onChanged: onChange),
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
            : logo != null && logo != ""
                ? Container(
                    height: 140,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: IMG_PATHLocation + logo,
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
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                        Center(
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

  Widget brandnameFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: brandnameController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Brand Name";
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
          hintText: "Brand Name",
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

  Widget customernameFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: customernameController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Customer Name";
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

  Widget occasionFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: occasionController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Occasion";
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
          hintText: "Occasion",
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
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Customer Unique code";
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

  Widget cityPinFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: citypinController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter City Pin";
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
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "City Pin",
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
              FocusScope.of(context).requestFocus(FocusNode());
              if (await DataConnectionChecker().hasConnection) {
                if (_fbKey.currentState!.validate()) {
                  if (selectedstate != null && selectedcity != null) {
                    setLoding();
                    String member_id = await ShareManager.getUserID();
                    List profilelist = [];
                    if (_image1 != null) {
                      profilelist
                          .add(await dio.MultipartFile.fromFile(_image1!.path));
                    }
                    List<QuotationModel> item_idlist = [];
                    for (var i = 0; i < quotationitemList.length; i++) {
                      if (quotationitemList[i].selec == true) {
                        // print(orderHistoryList[i].item_id);
                        item_idlist.add(
                          QuotationModel(
                              requirement: quotationitemList[i].name,
                              amount: quotationitemList[i].amount,
                              remark: quotationitemList[i].remark,
                              id: quotationitemList[i].id,
                              name: quotationitemList[i].name,
                              qot_id: quotationitemList[i].qot_id,
                              selec: quotationitemList[i].selec),
                        );
                      }
                    }

                    Map<String, dynamic> map = Map();

                    map["mem_id"] = member_id;
                    map["cust_name"] = customernameController.text;
                    map["cust_uniq"] = customeruniquecodeController.text;
                    map["start"] = start_date;
                    map["end"] = end_date;
                    map["occasion"] = occasionController.text;
                    map["state"] = selectedstate;
                    map["city"] = selectedcity;
                    map["city_pin"] = citypinController.text;
                    map["address"] = addressController.text;
                    map["logo"] = _image1 != null ? profilelist : "";
                    map["b_name"] = brandnameController.text;
                    map["new_items"] = quotationList.isNotEmpty
                        ? QuotationModel.fromListToJson(quotationList)
                        : "";
                    final data = await API.addInvoiceDirectAPI(map);
                    print("map data is = $map");
                    if (data.status == 1) {
                      setLoding();
                      Fluttertoast.showToast(msg: data.msg);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen(type: widget.type!)),
                          (route) => false);
                    } else {
                      setLoding();
                      Fluttertoast.showToast(msg: data.msg);
                    }
                    /*final requestData = await API.addQuatationApi(
                      member_id,
                      customernameController.text,
                      customeruniquecodeController.text,
                      dateController.text,
                      enddateController.text,
                      selectedOccasion,
                      selectedSide,
                      selectedstate,
                      selectedcity,
                      selectedarea,
                      citypinController.text,
                      addressController.text,
                      amountController.text,
                      requirmentController.text,
                      remarkController.text,
                    );
                    if (requestData.status == 1) {
                      setLoding();
                      Fluttertoast.showToast(msg: requestData.msg);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen(type: widget.type)),
                          (route) => false);
                    } else {
                      setLoding();
                      Fluttertoast.showToast(msg: requestData.msg);
                    }*/
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

  Widget addressFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: addressController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Address";
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
          hintText: "Address",
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

  Widget amountFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: amountController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Amount";
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
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Amount",
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

  Widget requirmentFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: requirmentController,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Montserrat-Bold',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        keyboardType: TextInputType.multiline,
        minLines: 3,
        maxLines: null,
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

  Widget remarkFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: remarkController,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Montserrat-Bold',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        keyboardType: TextInputType.multiline,
        minLines: 3,
        maxLines: null,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Remark",
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
