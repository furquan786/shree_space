import 'dart:convert';
import 'dart:math' as math;

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:otpless_flutter/otpless_flutter.dart';

import 'Backend/api_request.dart';
import 'Config/enums.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

class DemoVerifyOTPScreen extends StatefulWidget {
  var gender,
      name,
      //fname,
      mobile,
      password,
      firmname,
      state,
      city,
      //   area,
      village,
      pincode;

  DemoVerifyOTPScreen({
    @required this.gender,
    @required this.name,
    //  @required this.fname,
    @required this.mobile,
    @required this.password,
    @required this.firmname,
    @required this.state,
    @required this.city,
    //  @required this.area,
    @required this.village,
    @required this.pincode,
  });

  @override
  _DemoVerifyOTPScreenState createState() => _DemoVerifyOTPScreenState();
}

class _DemoVerifyOTPScreenState extends State<DemoVerifyOTPScreen> {
  TextEditingController textEditingController1 = TextEditingController();
  bool isLoding = false;
  String _waId = 'Unknown';
  final _otplessFlutterPlugin = Otpless();
  var waNumber;
  @override
  void initState() {
    super.initState();
    // initPlatformState();
    _otplessFlutterPlugin.hideFabButton();
    textEditingController1 = TextEditingController();
  }

  Future<void> initPlatformState() async {
    print("Heelooosaffsf");
    //_otplessFlutterPlugin.hideFabButton();
    _otplessFlutterPlugin.start((result) {
      print("Heelooo");
      var message = "";
      if (result['data'] != null) {
        final token = result['data']['token'];
        message = "token: $token";
        print(message);
      } else {
        print("Nullllllllllllllllllllllllllllll");
      }
      setState(() {
        _otplessFlutterPlugin.hideFabButton();
        _waId = message ?? "Unknown";
        print("Hiii");
        print(_waId);
        getToken(_waId);
        // getToken(_waId);
      });
    });
  }

  Future<void> startOtpless() async {
    _otplessFlutterPlugin.start((result) {
      var message = "";
      if (result['data'] != null) {
        final token = result['data']['token'];
        message = "token: $token";
        print(message);
      } else {
        print("Nullllllllllllllllllllllllllllll");
      }
      setState(() {
        _waId = message ?? "Unknown";
        getToken(_waId);
      });
    });
  }

  /*Future<void> initPlatformState() async {
    _otplessFlutterPlugin.authStream.listen((token) {
      setState(() {
        _waId = token ?? "Unknown";
        print(_waId);
        getToken(_waId);
// Send the waId to your server and pass the waId in getUserDetail API to retrieve the user detail.
// Handle the signup/signin process here
      });
    });
  }
*/
  Future<void> getToken(String waId) async {
    final url = Uri.parse("https://shreespace.authlink.me");
    var body = json.encode({
      "token": waId,
    });
    final header = {
      'clientId': "3zgkx0o4",
      'clientSecret': "cgcmg9sgmsfi9y7i",
      'Content-Type': "application/json"
    };

    try {
      final response = await http.post(
        url,
        body: body,
        headers: header,
      );
      String res = response.body;
      print(res);
      var ab = json.decode(res);
      var user = ab["waName"];
      waNumber = user["waNumber"];
      var token = ab["token"];
      print(waNumber);
      print(token);
      _otplessFlutterPlugin.signInCompleted();
      if (await DataConnectionChecker().hasConnection) {
        if (waNumber != null) {
          setLoding();
          final requestData = await API.demoverifyApi(widget.mobile);
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
          //Fluttertoast.showToast(msg: "Please enter OTP");
        }
      } else {
        Fluttertoast.showToast(msg: "Please check your internet connection");
      }
    } catch (e) {
      print(e);
    }
    //final response = await
  }

  /*void initiateWhatsappLogin(String intentUrl) async {
    var result =
    await _otplessFlutterPlugin.loginUsingWhatsapp(intentUrl: intentUrl);
    switch (result['code']) {
      case "581":
        print(result['message']);
//TODO: handle whatsapp not found
        break;
      default:
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
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(height: 30),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    'Verify Number ',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat-Bold',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    "Assets/logo.png",
                    width: 200,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "Phone Number Verification",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1),
                ),
                const SizedBox(height: 30),
                buttonSubmitdata(lblbutton: "Continue With WhatsApp"),
                const SizedBox(height: 60),
              ]),
            )),
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
          ))
    ]);
  }

  Widget buttonSubmitdata({String lblbutton = ""}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        //color: Colors.white,
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
            /*initiateWhatsappLogin(
                "https://step2websoft.authlink.me?redirectUri=step2websoftotpless://otpless");*/
            _otplessFlutterPlugin.hideFabButton();
            initPlatformState();
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
