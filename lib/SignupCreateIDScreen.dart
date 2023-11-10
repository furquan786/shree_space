import 'dart:math' as math;

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Backend/api_request.dart';
import 'HomeScreen.dart';
import 'SignupPlanScreen.dart';

class SignupCreateIDScreen extends StatefulWidget {
  var gender,
      name,
      //   second_name,
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

  SignupCreateIDScreen({
    @required this.gender,
    @required this.name,
    //  @required this.second_name,
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
  _SignupCreateIDScreenState createState() => _SignupCreateIDScreenState();
}

class _SignupCreateIDScreenState extends State<SignupCreateIDScreen> {
  bool isLoding = false;
  TextEditingController mobileCntroller = TextEditingController();
  TextEditingController passCntroller = TextEditingController();
  TextEditingController cnfpassCntroller = TextEditingController();
  bool _passwordVisible = false;
  bool _cnfpasswordVisible = false;
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    mobileCntroller.text = widget.mobile;
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
                'CREATE ID-PASSWORD',
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
                "ID *",
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
            buttonLogindata(lblbutton: "NEXT"),
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
          RegExp regex = new RegExp(pattern.toString());
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

  Widget buttonLogindata({String lblbutton = ""}) {
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
                setLoding();
                final requestData = await API.addpasswordApi(
                  widget.mobile,
                  cnfpassCntroller.text,
                );
                if (requestData.status == 1) {
                  setLoding();
                  Fluttertoast.showToast(msg: requestData.msg);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignupPlanScreen(
                            gender: widget.gender,
                            name: widget.name,
                            //  second_name: widget.second_name,
                            nikname: widget.nikname,
                            mobile: widget.mobile,
                            altmobile: widget.altmobile,
                            dob: widget.dob,
                            home_address: widget.home_address,
                            state: widget.state,
                            city: widget.city,
                            village: widget.village,
                            pincode: widget.pincode,
                            email: widget.email,
                            actype: widget.actype,
                            acno: widget.acno,
                            ifsc: widget.ifsc)),
                  );
                  /*  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) => LoginScreen(type:UserType.Customer,)));*/
                } else {
                  setLoding();
                  Fluttertoast.showToast(msg: requestData.msg);
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
