import 'dart:math' as math;

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

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
import 'Model/city_list.dart';
import 'Model/state_list.dart';

import 'Model/workprofileModel.dart';
import 'myannouncement.dart';
import 'myimagesui.dart';

class AddAnnuoncementui extends StatefulWidget {
  //const AddAnnuoncementui({Key key}) : super(key: key);
  final UserType type;

  AddAnnuoncementui({required this.type, Key? key}) : super(key: key);
  @override
  State<AddAnnuoncementui> createState() => _AddAnnuoncementuiState();
}

class _AddAnnuoncementuiState extends State<AddAnnuoncementui> {
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
      HomePlaceholderWidget(widget.type),
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
                    child: Text("Add Announcement"))
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

  HomePlaceholderWidget(UserType type, {Key? key}) : super(key: key) {
    this.type = type;
  }

  @override
  State<HomePlaceholderWidget> createState() => _HomeholderWidgetState();
}

class _HomeholderWidgetState extends State<HomePlaceholderWidget> {
  bool isLoding = false;

  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController annodescController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController customlocationController = TextEditingController();
  TextEditingController castController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();
  List<WorkProfileModel> workprofileList = [];
  var _items = null;
  List<dynamic> _selectedWork = [];
  List<WorkProfileModel> list = [];
  DateTime? stratdate, enddate;
  var selectedarea,
      selectedstate,
      selectedcity,
      selectedTime,
      selectedOccasion,
      selectedSide,
      selectedCamera,
      daysbetweeen;
  List<StateListModel> stateList = [];
  List<CityListModel> cityList = [];
  List<String> occasionList = [
    "BirthDay",
    "Wedding",
    "Engagement",
  ];
  List<String> sideList = [
    "Boy",
    "Girl",
  ];
  List<String> timeList = [
    "Half Day",
    "Full Day",
  ];
  List<String> cameraList = [
    "Full Frame",
    "APSC",
    "Camcorder",
  ];
  List<AreaListModel> areaList = [];
  int index = -1, index1 = -1;

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
    _selectedWork = workprofileList;
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

  void getState() async {
    if (await DataConnectionChecker().hasConnection) {
      stateList = [];
      setLoding();
      RequestData requestData = await API.stateListAPI();
      setLoding();
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

  void getArea() async {
    if (await DataConnectionChecker().hasConnection) {
      areaList = [];
      setLoding();
      RequestData requestData = await API.areaListAPI(selectedcity);
      setLoding();
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
                            selectedOccasion = newVal;
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
                                selectedSide = newVal;
                                setState(() {});
                              }
                            }, selectedSide)),
                        Visibility(
                            visible: selectedOccasion != "BirthDay",
                            child: const SizedBox(height: 20)),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Camera *",
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
                        camreaDropDownMenu("Select Camera", cameraList,
                            (newVal) {
                          if (newVal != selectedCamera) {
                            selectedCamera = newVal;
                            setState(() {});
                          }
                        }, selectedCamera),
                        const SizedBox(height: 20),
                        Align(
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
                        ),
                        MultiSelectDialogField(
                          items: _items,
                          title: Text("Select"),
                          selectedColor: Colors.blue,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              style: BorderStyle.none,
                              width: 0,
                            ),
                          ),
                          buttonIcon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                          buttonText: Text(
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
                        ),
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
                            areaList.clear();
                            selectedcity = null;
                            selectedarea = null;
                            selectedstate = newVal;
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
                            areaList.clear();
                            selectedarea = null;
                            selectedcity = newVal;
                            //getArea();
                            setState(() {});
                          }
                        }, selectedcity),
                        const SizedBox(height: 20),
                        /*const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "AREA *",
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
                        areaDropDownMenu("Select Area", areaList, (newVal) {
                          if (newVal != selectedarea) {
                            selectedarea = newVal;
                            setState(() {});
                          }
                        }, selectedarea),
                        const SizedBox(height: 20),*/
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Time *",
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
                        timeDropDownMenu("Select Time", timeList, (newVal) {
                          if (newVal != selectedTime) {
                            selectedTime = newVal;
                            setState(() {});
                          }
                        }, selectedTime),
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
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Occasion Location *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        locationFormFiled(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Custom Location",
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
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Cast",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        castFormFiled(),
                        const SizedBox(height: 20),
                        buttondata(lblbutton: "Ok"),
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
      firstDate: DateTime(stratdate!.year, stratdate!.month, stratdate!.day),
      initialDate: DateTime(stratdate!.year, stratdate!.month, stratdate!.day),
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
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        selectedDate.value = TextEditingValue(text: formattedDate);
      });
    }
    if (stratdate != null && enddate != null) {
      daysbetweeen = daysBetween(stratdate!, enddate!);
      daysbetweeen = daysbetweeen + 1;
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
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        selectedDate.value = TextEditingValue(text: formattedDate);
      });
    }
    if (stratdate != null && enddate != null) {
      daysbetweeen = daysBetween(stratdate!, enddate!);
      daysbetweeen = daysbetweeen + 1;
      print(daysbetweeen);
    }
  }

  Widget timeDropDownMenu(String hint, List<String> list,
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

  Widget areaDropDownMenu(String hint, List<AreaListModel> list,
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
            items: list.map((AreaListModel val) {
              return new DropdownMenuItem<String>(
                value: val.id,
                child: new Text(
                  val.area_name,
                  style: TextStyle(
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

  Widget titleFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: titleController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Title";
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
          hintText: "Title",
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
              FocusScope.of(context).requestFocus(FocusNode());
              if (await DataConnectionChecker().hasConnection) {
                if (_fbKey.currentState!.validate()) {
                  if (selectedOccasion != null &&
                      selectedCamera != null &&
                      selectedstate != null &&
                      selectedcity != null &&
                      selectedTime != null &&
                      list.isNotEmpty) {
                    String member_name = await ShareManager.getName();
                    String member_mobile = await ShareManager.getMobile();
                    String user_id = await ShareManager.getUserID();
                    List work = [];
                    for (int i = 0; i < list.length; i++) {
                      print(list[i].name);
                      work.add(list[i].name);
                    }
                    String s1 = work.join(', ');
                    final requestData = await API.addAnnouncementApi(
                      member_name,
                      member_mobile,
                      user_id,
                      "Member",
                      selectedOccasion,
                      selectedSide,
                      selectedCamera,
                      annodescController.text,
                      s1,
                      selectedstate,
                      selectedcity,
                      selectedTime,
                      dateController.text,
                      enddateController.text,
                      daysbetweeen.toString(),
                      locationController.text,
                      customlocationController.text,
                      castController.text,
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

  Widget locationFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: locationController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Occasion Location";
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
          hintText: "Occasion Location",
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
          hintText: "Custom Location",
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

  Widget castFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: castController,
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
          hintText: "Cast",
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
