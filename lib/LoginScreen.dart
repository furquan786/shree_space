import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:shreegraphic/Services/notification_services.dart';
import 'package:shreegraphic/forgotPasswordScreen.dart';

import 'Backend/api_request.dart';
import 'Backend/share_manager.dart';
import 'Config/enums.dart';
import 'DemoScreen.dart';
import 'HomeScreen.dart';
import 'SignupScreen.dart';

class LoginScreen extends StatefulWidget {
  final UserType type;

  LoginScreen({required this.type});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCntroller = TextEditingController();
  TextEditingController passCntroller = TextEditingController();
  bool _passwordVisible = true;
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  bool isLoding = false;
  int index = 0;
  Box? box1;
  bool isToggled = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    createOpenBox();
  }

  void createOpenBox() async {
    box1 = await Hive.openBox('logindata');
    getdata();
  }

  void getdata() async {
    print(box1!.get('mobile'));
    if (box1!.get('mobile') != null) {
      emailCntroller.text = box1!.get('mobile');
      isToggled = true;
      setState(() {});
    }
    if (box1!.get('pass') != null) {
      passCntroller.text = box1!.get('pass');
      isToggled = true;
      setState(() {});
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
              // tileMode: TileMode.clamp,
              //transform: GradientRotation(math.pi / 4), Color(0xFF353A3F)
              //  stops: [0.4, 1],
              //0d0c22
              colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
          /* gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              //transform: GradientRotation(math.pi / 4), //Color(0xFFF2AD3C)
              //stops: [0.4, 1],  //Color(0xFFD36221)
              colors: [Color(0xFFF2AD3C), Color(0xFF934C23)]),*/
        ),
        child: SingleChildScrollView(
            child: Form(
          key: _fbKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(height: 40),
            Stack(children: <Widget>[
              Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1),
                ),
              ),
            ]),
            const SizedBox(height: 30),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "Log In to your account \n& check your wealth.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
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
                "LOGIN ID",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            logidFormFiled(),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "PASSWORD",
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
            const SizedBox(height: 7),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => ForgotPassword(type: widget.type)));
                },
                child: const Text(
                  "Forgot Password ?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Inter-Regular',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            buttonLogindata(lblbutton: "Login"),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Remember me",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Switch(
                      value: isToggled,
                      onChanged: (value) {
                        setState(() {
                          isToggled = value;
                          print(isToggled);
                        });
                      },
                      activeTrackColor: Colors.green,
                      activeColor: Colors.green,
                    ),
                  ),
                ]),
            const SizedBox(height: 80),
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
                        "New User?",
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
                                    builder: (ctx) => SignupScreen()));
                          },
                          child: const Text(
                            "Sign up",
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
                      const Text(
                        " Or ",
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
                                    builder: (ctx) => DemoScreen()));
                          },
                          child: const Text(
                            "Apply For Demo",
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

            /* Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Customer as a ",
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
                                    builder: (ctx) => CusotmerLoginScreen(type: UserType.Custo,)));
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
                      const Text(
                        " Or ",
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
                                    builder: (ctx) => CustomerSignupScreen()));
                          },
                          child: const Text(
                            "Sign up",
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
                    ])),*/
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

  Widget logidFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
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

  Widget passFormFiled() {
    return SizedBox(
      //  height: 35,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: passCntroller,
        autofocus: false,
        obscureText: !_passwordVisible,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Password";
          }
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

  Widget buttonLogindata({String lblbutton = ""}) {
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
            if (await DataConnectionChecker().hasConnection) {
              if (_fbKey.currentState!.validate()) {
                setLoding();

                final requestData = await API.loginApi(
                  emailCntroller.text,
                  passCntroller.text,
                );
                if (requestData.status == 1) {
                  setLoding();
                  if (isToggled) {
                    box1!.put('mobile', emailCntroller.value.text);
                    box1!.put('pass', passCntroller.value.text);
                  }
                  Fluttertoast.showToast(msg: requestData.msg);
                  await ShareManager.setLogintype(widget.type);

                  await ShareManager.setID(requestData.result[0]["id"]);
                  await ShareManager.setUserID(requestData.result[0]["id"]);
                  await ShareManager.setDeviceID(
                      /*requestData.result[0]["device_id"]*/ "12345");
                  await ShareManager.setName(requestData.result[0]["name"]);
                  await ShareManager.setFirmName(
                      requestData.result[0]["firm_name"]);
                  //await ShareManager.setNickName(requestData.result[0]["nick_name"]);
                  await ShareManager.setMobile(requestData.result[0]["mobile"]);
                  await ShareManager.setHomeAddress(
                      requestData.result[0]["address"]);
                  await ShareManager.setWorkProfile(
                      requestData.result[0]["work_profile"]);
                  await ShareManager.setState(requestData.result[0]["state"]);
                  await ShareManager.setCity(requestData.result[0]["city"]);
                  //  await ShareManager.setArea(requestData.result[0]["area"]);
                  await ShareManager.setVillage(
                      requestData.result[0]["village"]);
                  await ShareManager.setCity_pin(
                      requestData.result[0]["city_pin"]);
                  await ShareManager.setEmail(requestData.result[0]["email"]);
                  await ShareManager.setAc_type(
                      requestData.result[0]["ac_type"]);
                  await ShareManager.setAc_no(requestData.result[0]["ac_no"]);
                  await ShareManager.setAc_no(requestData.result[0]["ifsc"]);
                  await ShareManager.setAdhar_no(
                      requestData.result[0]["adhar_no"]);
                  await ShareManager.setPan_no(requestData.result[0]["pan_no"]);
                  await ShareManager.setPlan(requestData.result[0]["plan"]);

                  getTokenupdate();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => HomeScreen(type: widget.type)));
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

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  Future<void> getTokenupdate() async {
    final token = await getToken();
    print(token);
    final requestData = await API.updateTokenApi(emailCntroller.text, token!);
    if (requestData.status == 1) {
      // setLoding();
    } else {
      //setLoding();
      // Fluttertoast.showToast(msg: requestData.msg);
    }
  }
}
