import 'dart:ui';

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'dart:math' as math;
import 'Backend/api_request.dart';
import 'Config/enums.dart';
import 'package:intl/intl.dart';
import 'HomeScreen.dart';
import 'package:html/parser.dart';
import 'LoginScreen.dart';
import 'Model/area_list.dart';
import 'Model/city_list.dart';
import 'Model/request_data.dart';
import 'Model/state_list.dart';
import 'Model/terms_list.dart';
import 'Model/workprofileModel.dart';
import 'SignupBankScreen.dart';
import 'SignupPlanScreen.dart';
import 'VerifyOTPScreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _textFieldController = TextEditingController();

  TextEditingController nameCntroller = TextEditingController();
  TextEditingController fathernameCntroller = TextEditingController();
  TextEditingController niknameCntroller = TextEditingController();
  TextEditingController mobileCntroller = TextEditingController();
  TextEditingController altmobileCntroller = TextEditingController();
  TextEditingController homeaddCntroller = TextEditingController();
  TextEditingController pincodeCntroller = TextEditingController();
  TextEditingController villageCntroller = TextEditingController();
  TextEditingController emailCntroller = TextEditingController();
  TextEditingController dobController = TextEditingController();
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  bool isLoding = false;
  var selectedstate, selectedcity, /*selectedarea, */ selectedgender;
  List<CityListModel> cityList = [];
  List<StateListModel> stateList = [];
  // List<AreaListModel> areaList = [];
  List<TermsListModel> termsList = [];
  bool agree = false;
  List<WorkProfileModel> workprofileList = [];
  var _items = null;
  List<dynamic> _selectedWork = [];
  List<WorkProfileModel> list = [];
  List<String> genderList = [
    "Male",
    "Female",
  ];
  int index = 0;
  bool isToggled = false;
  String codeDialog = "";
  String valueText = "";
  var content,
      name,
      gender,
      second_name,
      mobile,
      city_pin,
      state,
      city,
      area,
      village;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => showAlertDialog(context));
    getState();
    getWorkProfile();
    getTermsCondition();
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

  getTermsCondition() async {
    termsList = [];
    setLoding();
    final requestData = await API.termsList();
    setLoding();
    if (requestData.status == 1) {
      content = requestData.result[0]["content"];
      setState(() {});
    }
  }

  void getData(String codeDialog) async {
    if (await DataConnectionChecker().hasConnection) {
      setLoding();
      RequestData requestData = await API.getdemodetailAPI(codeDialog);
      setLoding();
      if (requestData.status == 1) {
        gender = requestData.result[0]["gender"];
        name = requestData.result[0]["name"];
        second_name = requestData.result[0]["second_name"];
        mobile = requestData.result[0]["mobile"];
        city_pin = requestData.result[0]["city_pin"];
        selectedstate = requestData.result[0]["state_id"];
        selectedcity = requestData.result[0]["city_id"];
        //selectedarea = requestData.result[0]["area_id"];
        village = requestData.result[0]["village"];

        nameCntroller.text = name;
        fathernameCntroller.text = second_name;
        mobileCntroller.text = mobile;
        pincodeCntroller.text = city_pin;
        villageCntroller.text = village;
        if (selectedstate != null) {
          getCity();
        }
        /* if (selectedcity != null) {
          getArea();
        }*/
        setState(() {
          for (int i = 0; i < genderList.length; i++) {
            if (gender == genderList[i]) {
              index = i;
              print(genderList[i]);
            }
          }
        });
        //setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Buisness Mobile No'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter Mobile No"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    print(codeDialog);
                    Navigator.pop(context);
                    getData(codeDialog);
                  });
                },
              ),
            ],
          );
        });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.of(context).pop();
        //  Navigator.of(context).pop();
        //Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("YES"),
      onPressed: () {
        Navigator.of(context).pop();
        _displayTextInputDialog(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text(""),
      content: Text("Are you already apply for demo ??"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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

  /* void getArea() async {
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
*/
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Stack(children: [
      Scaffold(
          body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
        width: screen.width,
        height: screen.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // tileMode: TileMode.clamp,
              //transform: GradientRotation(math.pi / 4), Color(0xFF353A3F)
              //  stops: [0.4, 1],
              //0d0c22
              colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
          /*  gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              //transform: GradientRotation(math.pi / 4),
              //stops: [0.4, 1],
              colors: [Color(0xFFF2AD3C), Color(0xFFD36221)]),*/
        ),
        child: SingleChildScrollView(
            child: Form(
          key: _fbKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(height: 30),
            Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                'New Registration ',
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Montserrat-Bold',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                'Personal Details',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Montserrat-Bold',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1),
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "GENDER *",
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
            genderDropDownMenu("Select Gender", genderList, (newVal) {
              if (newVal != selectedgender) {
                selectedgender = newVal;
                setState(() {});
              }
            }, selectedgender),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "NAME *",
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
            /*const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "FATHER/HUSBAND's NAME",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            fathernameFormFiled(),
            const SizedBox(height: 20),*/
            const Align(
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
            ),
            niknameFormFiled(),
            const SizedBox(height: 20),
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
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "Alt MOBILE NO. ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            altmobileFormFiled(),
            const SizedBox(height: 20),
            _pickDate("Select Date", "Date of Birth", dobController),
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
                "PERMANENT ADDRESS *",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            homeaddressFormFiled(),
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
                // areaList.clear();
                selectedcity = null;
                //selectedarea = null;
                setState(() {
                  selectedstate = newVal;
                  getCity();
                });
              }
            }, selectedstate),
            const SizedBox(height: 20),
            const Align(
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
            ),
            const SizedBox(height: 5),
            cityDropDownMenu("Select City", cityList, (newVal) {
              if (newVal != selectedcity) {
                //  areaList.clear();
                // selectedarea = null;

                setState(() {
                  selectedcity = newVal;
                  //getArea();
                });
              }
            }, selectedcity),
            const SizedBox(height: 20),
            /* const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "AREA",
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
                setState(() {
                  selectedarea = newVal;
                });
              }
            }, selectedarea),
            const SizedBox(height: 20),*/
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "VILLAGE *",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            villageFormFiled(),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "CITY PIN *",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            pincodeFormFiled(),
            const SizedBox(height: 20),
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
            content != null
                ? Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.grey,
                        value: agree,
                        onChanged: (value) {
                          setState(() {
                            agree = value ?? false;
                          });
                        },
                      ),
                      Flexible(
                          child: Text(
                        _parseHtmlString(content),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ))
                    ],
                  )
                : SizedBox(),
            buttonLogindata(lblbutton: "NEXT"),
            const SizedBox(height: 30),
            Divider(
              color: Colors.white,
              thickness: 1.0,
            ),
            Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Already signed?",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.95),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => LoginScreen(
                                          type: UserType.Customer,
                                        )));
                          },
                          child: const Text(
                            "Login",
                          ),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              textStyle: const TextStyle(
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                  fontFamily: 'Montserrat-Bold',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.95))),
                    ])),
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

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
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

  Widget genderDropDownMenu(String hint, List<String> list,
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
            value: index != null ? genderList[index] : value,
            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onChanged: onChange),
      ),
    );
  }

  Widget nameFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
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

  Widget fathernameFormFiled() {
    return SizedBox(
      // height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: fathernameCntroller,
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

  Widget niknameFormFiled() {
    return SizedBox(
      // height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
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

  Widget emailFormFiled() {
    return SizedBox(
      // height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: emailCntroller,
        keyboardType: TextInputType.emailAddress,
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

  Widget homeaddressFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: homeaddCntroller,
        keyboardType: TextInputType.streetAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Home Address";
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

  Widget villageFormFiled() {
    return SizedBox(
      // height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: villageCntroller,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Village";
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

  Widget pincodeFormFiled() {
    return SizedBox(
      // height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: pincodeCntroller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Pincode";
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
      // height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: mobileCntroller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Mobile No.";
          }
          if (value.length != 10) return 'Mobile Number must be of 10 digit';
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

  Widget _pickDate(
      String hint, String value, TextEditingController controller) {
    return SizedBox(
      //padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$value *",
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

  Future<Null> _selectDate(TextEditingController selectedDate) async {
    final now = new DateTime.now();
    DateTime? picked1;
    DateTime? picked;
    picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1947, 8),
      initialDate: picked1 != null
          ? DateTime(picked1.year, picked1.month, picked1.day)
          : DateTime.now(),
      lastDate: now,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      picked1 = picked;
      setState(() {
        picked1 = picked;
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked!);
        selectedDate.value = TextEditingValue(text: formattedDate);
      });
    }
  }

  Widget altmobileFormFiled() {
    return SizedBox(
      // height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: altmobileCntroller,
        keyboardType: TextInputType.number,
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

  Widget buttonLogindata({String lblbutton = ""}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        //color: Colors.white,
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
                if (agree == true) {
                  if (selectedgender != null &&
                      selectedstate != null &&
                      selectedcity != null &&
                      list.isNotEmpty) {
                    List work = [];
                    for (int i = 0; i < list.length; i++) {
                      print(list[i].name);
                      work.add(list[i].name);
                    }
                    String s1 = work.join(', ');
                    setLoding();
                    final requestData = await API.signUpApi(
                        selectedgender,
                        nameCntroller.text,
                        //.text,
                        niknameCntroller.text,
                        mobileCntroller.text,
                        altmobileCntroller.text,
                        dobController.text,
                        s1,
                        homeaddCntroller.text,
                        selectedstate,
                        selectedcity,
                        //selectedarea,
                        villageCntroller.text,
                        pincodeCntroller.text,
                        emailCntroller.text);
                    if (requestData.status == 1) {
                      setLoding();
                      Fluttertoast.showToast(msg: requestData.msg);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyOTPScreen(
                                    gender: selectedgender,
                                    name: nameCntroller.text,
                                    // second_name: fathernameCntroller.text,
                                    nikname: niknameCntroller.text,
                                    mobile: mobileCntroller.text,
                                    altmobile: altmobileCntroller.text,
                                    dob: dobController.text,
                                    home_address: homeaddCntroller.text,
                                    state: selectedstate,
                                    city: selectedcity,
                                    //   area: selectedarea,
                                    village: villageCntroller.text,
                                    pincode: pincodeCntroller.text,
                                    email: emailCntroller.text,
                                  )));
                    } else if (requestData.status == 2) {
                      setLoding();
                      Fluttertoast.showToast(msg: requestData.msg);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => LoginScreen(
                                    type: UserType.Customer,
                                  )));
                    } else {
                      setLoding();
                      Fluttertoast.showToast(msg: requestData.msg);
                    }
                    return;
                  } else {
                    Fluttertoast.showToast(msg: "Please Select Detail");
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Please Select Terms & Condition");
                }
              }
            } else {
              Fluttertoast.showToast(
                  msg: "Please check your internet connection");
            }
          },
          child: Text(
            lblbutton,
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.33),
          )),
    );
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }
}
