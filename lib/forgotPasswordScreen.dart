import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shreegraphic/Backend/api_request.dart';
import 'package:shreegraphic/LoginScreen.dart';
import 'package:shreegraphic/forgotPasswordScreen2.dart';

import 'Config/enums.dart';

class ForgotPassword extends StatefulWidget {
  UserType type;

  ForgotPassword({required this.type, Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  TextEditingController emailCntroller = TextEditingController();
  bool isLoding = false;

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          body: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            width: screen.width,
            height: screen.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2C3137), Color(0xFF1B1C20)],
              ),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _fbKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Stack(children: <Widget>[
                      Center(
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1),
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Image.asset(
                        "Assets/forgot.png",
                        scale: 9,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Text(
                        "Enter your registered Mobile No. to Get the link to your email for reseting Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'PlayfairDisplay-Regular',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                    const Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Text(
                        "Mobile No.",
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
                    const SizedBox(height: 30),
                    buttonSenddata(lblbutton: "Send"),
                    const SizedBox(height: 10),
                    buttonBack(lblbutton: "Back to Login"),
                  ],
                ),
              ),
            ),
          ),
        ),
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
          ),
        ),
      ],
    );
  }

  Widget mobileFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: emailCntroller,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Mobile No";
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

  Widget buttonSenddata({String lblbutton = ""}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
            spreadRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            // elevation: MaterialStateProperty.all(3),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            if (_fbKey.currentState!.validate()) {
              setLoding();

              final requestData =
                  await API.forgotPasswordApi(emailCntroller.text);

              if (requestData.status == 1) {
                setLoding();
                Fluttertoast.showToast(msg: requestData.msg);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NextScreen(
                      type: widget.type,
                      email: requestData.result,
                    ),
                  ),
                );
              } else {
                setLoding();
                Fluttertoast.showToast(msg: requestData.msg);
              }
            }
          },
          child: Text(
            lblbutton,
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.w600,
                color: Color(0xFFE58B29),
                letterSpacing: 1.33),
          )),
    );
  }

  Widget buttonBack({String lblbutton = ""}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
            spreadRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            // elevation: MaterialStateProperty.all(3),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pop(context);
          },
          child: Text(
            lblbutton,
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.w600,
                color: Color(0xFFE58B29),
                letterSpacing: 1.33),
          )),
    );
  }
}
