import 'dart:math' as math;

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Backend/api_request.dart';
import 'Config/enums.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';
import 'Model/plan_list.dart';
import 'Model/request_data.dart';

class SignupPlanScreen extends StatefulWidget {
  var gender,
      name,
      //  second_name,
      nikname,
      mobile,
      altmobile,
      dob,
      home_address,
      state,
      city,
      village,
      pincode,
      email,
      actype,
      acno,
      ifsc;

  SignupPlanScreen({
    @required this.gender,
    @required this.name,
    // @required this.second_name,
    @required this.nikname,
    @required this.mobile,
    @required this.altmobile,
    @required this.dob,
    @required this.home_address,
    @required this.state,
    @required this.city,
    @required this.village,
    @required this.pincode,
    @required this.email,
    @required this.actype,
    @required this.acno,
    @required this.ifsc,
  });

  @override
  _SignupPlanScreenState createState() => _SignupPlanScreenState();
}

class _SignupPlanScreenState extends State<SignupPlanScreen> {
  bool isLoding = false;
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  List<PlanListModel> planList = [];
  PlanListModel? selectedplan;
  int index = 0;
  bool selectplan = false;
  var price, validity;

  @override
  void initState() {
    super.initState();
    getPlan();
  }

  void getPlan() async {
    if (await DataConnectionChecker().hasConnection) {
      planList = [];
      setLoding();
      RequestData requestData = await API.planListAPI();
      setLoding();
      if (requestData.status == 1) {
        for (var i in requestData.result) {
          planList.add(PlanListModel.fromJSON(i));
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
      Scaffold(
          body: Container(
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
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(height: 30),
            Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                'Select PLAN',
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
                "Select Plan *",
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
            planDropDownMenu((newVal) {
              if (index != 0) {
                if (newVal != planList[index]) {
                  index = 0;
                  planList[index] = newVal!;
                  selectplan = true;
                  price = selectedplan!.price;
                  validity = selectedplan!.validity;
                  setState(() {});
                }
              } else {
                if (newVal != selectedplan) {
                  selectedplan = newVal;
                  selectplan = true;
                  price = selectedplan!.price;
                  validity = selectedplan!.validity;
                  setState(() {});
                }
              }
            }, "Select Plan", planList, index, selectedplan!),
            const SizedBox(height: 20),
            Visibility(
                visible: selectplan,
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    "Amount : ₹${price}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            Visibility(
                visible: selectplan,
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    "Validity : ${validity}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                )),
            const SizedBox(height: 5),
            /*planDropDownMenu("Select Plan", planList, (newVal) {
              if (newVal != selectedplan) {
                selectedplan = newVal;
                setState(() {});
              }
            }, selectedplan),
*/
            const SizedBox(height: 20),
            buttonLogindata(lblbutton: "NEXT"),
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

  Widget planDropDownMenu(Function(PlanListModel? val) onChange, String hint,
      List<PlanListModel> list, int index, PlanListModel value) {
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
            items: list.map((PlanListModel val) {
              return DropdownMenuItem<PlanListModel>(
                value: val,
                child: Text(
                  val.name,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              );
            }).toList(),
            value: index != null ? list[index] : value,
            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onChanged: onChange),
      ),
    );
  }

  Widget buttonLogindata({String lblbutton = ''}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        //  color: Colors.white,
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
                if (price != null) {
                  setLoding();
                  final requestData = await API.addplanApi(
                    widget.mobile,
                    selectedplan!.name,
                  );
                  if (requestData.status == 1) {
                    setLoding();
                    Fluttertoast.showToast(msg: requestData.msg);
                    Navigator.pushReplacement(
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
                  Fluttertoast.showToast(msg: "Please Select Plan");
                }
                return;
              }
            } else {
              Fluttertoast.showToast(
                  msg: "Please check your internet connection");
            }
            /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignupBankScreen(
                      name: widget.name,
                      nikname: widget.nikname,
                      mobile: widget.mobile,
                      altmobile: widget.altmobile,
                      home_address: widget.home_address,
                      state: widget.state,
                      city: widget.city,
                      village: widget.village,
                      pincode: widget.pincode,
                      email: widget.email,
                      actype: widget.actype,
                      acno: widget.acno,
                      ifsc: widget.ifsc)),
            );*/
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
