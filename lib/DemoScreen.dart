import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;
import 'Backend/api_request.dart';
import 'Config/enums.dart';
import 'DemoVerifyOTPScreen.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';
import 'Model/area_list.dart';
import 'Model/city_list.dart';
import 'Model/request_data.dart';
import 'Model/state_list.dart';
import 'SignupBankScreen.dart';
import 'VerifyOTPScreen.dart';

class DemoScreen extends StatefulWidget {
  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  TextEditingController nameCntroller = TextEditingController();
  // TextEditingController fathernameCntroller = TextEditingController();
  TextEditingController mobileCntroller = TextEditingController();
  TextEditingController firmnameCntroller = TextEditingController();
  TextEditingController pincodeCntroller = TextEditingController();
  TextEditingController villageCntroller = TextEditingController();
  TextEditingController passCntroller = TextEditingController();
  TextEditingController cnfpassCntroller = TextEditingController();
  bool _passwordVisible = false;
  bool _cnfpasswordVisible = false;
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  bool isLoding = false;
  var selectedstate, selectedcity, /*selectedarea,*/ selectedgender;
  List<CityListModel> cityList = [];
  List<StateListModel> stateList = [];
  // List<AreaListModel> areaList = [];
  List<String> genderList = [
    "Male",
    "Female",
  ];
  int index = 0;
  bool isToggled = false;

  @override
  void initState() {
    getState();
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

  /*void getArea() async {
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
  }*/

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
                'Apply For Demo ',
                style: TextStyle(
                    fontSize: 22,
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
                "NAME + SURNAME *",
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
                "PASSWORD *",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            passFormFiled(),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "CONFIRM PASSWORD *",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            cnfpassFormFiled(),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "FIRM NAME ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            firmnameFormFiled(),
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
                selectedstate = newVal;
                getCity();
                setState(() {});
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
                // areaList.clear();
                // selectedarea = null;
                selectedcity = newVal;

                //  getArea();
                setState(() {});
              }
            }, selectedcity),
            const SizedBox(height: 20),
            /*const Align(
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
                selectedarea = newVal;
                setState(() {});
              }
            }, selectedarea),
            const SizedBox(height: 20),*/
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "VILLAGE",
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
                "PINCODE *",
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
            buttonLogindata(lblbutton: "SUBMIT"),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "Note : Password must be at least 8 characters long. A combination of at least 1 number, at least 1 special character, at least 1 uppercase, and at least 1 lower case is best.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
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

  /*Widget areaDropDownMenu(
      String hint, List<AreaListModel> list, Function onChange, String value) {
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
*/
  Widget nameFormFiled() {
    return SizedBox(
      // height: 40,
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

  /*Widget fathernameFormFiled() {
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
*/
  Widget villageFormFiled() {
    return SizedBox(
      // height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: villageCntroller,
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
      //  height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
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

  Widget passFormFiled() {
    return SizedBox(
      //  height: 35,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: passCntroller,
        autofocus: false,
        obscureText: !_passwordVisible,
        validator: (value) {
          Pattern pattern =
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
          RegExp regex = RegExp(pattern.toString());
          if (value!.isEmpty) {
            return "Please Enter Password";
          }
          if (!regex.hasMatch(value)) return 'Enter valid password';
          return null;
        },
        decoration: InputDecoration(
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
            suffixIcon: IconButton(
              icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            )),
      ),
    );
  }

  Widget cnfpassFormFiled() {
    return SizedBox(
      // height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: cnfpassCntroller,
        autofocus: false,
        obscureText: !_cnfpasswordVisible,
        validator: (value) {
          if (value!.isEmpty) return 'Please Enter Confirm Password';
          if (value != passCntroller.text) return 'Password Do Not Match';
          return null;
        },
        decoration: InputDecoration(
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
            suffixIcon: IconButton(
              icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _cnfpasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  _cnfpasswordVisible = !_cnfpasswordVisible;
                });
              },
            )),
      ),
    );
  }

  Widget firmnameFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: firmnameCntroller,
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
                setLoding();
                if (selectedgender != null &&
                    selectedstate != null &&
                    selectedcity != null) {
                  final requestData = await API.demoApi(
                    selectedgender,
                    nameCntroller.text,
                    //fathernameCntroller.text,
                    mobileCntroller.text,
                    cnfpassCntroller.text,
                    firmnameCntroller.text,
                    selectedstate,
                    selectedcity,
                    //selectedarea,
                    villageCntroller.text,
                    pincodeCntroller.text,
                  );
                  if (requestData.status == 1) {
                    setLoding();
                    Fluttertoast.showToast(msg: requestData.msg);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DemoVerifyOTPScreen(
                                  gender: selectedgender,
                                  name: nameCntroller.text,
                                  // fname: fathernameCntroller.text,
                                  mobile: mobileCntroller.text,
                                  password: cnfpassCntroller.text,
                                  firmname: firmnameCntroller.text,
                                  state: selectedstate,
                                  city: selectedcity,
                                  //area: selectedarea,
                                  village: villageCntroller.text,
                                  pincode: pincodeCntroller.text,
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
                } else {
                  Fluttertoast.showToast(msg: "Please Select Detail");
                }
                return;
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
