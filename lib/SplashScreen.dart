import 'dart:async';

import 'package:flutter/material.dart';

import 'Backend/share_manager.dart';
import 'Config/enums.dart';
import 'HomePage.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer((Duration(seconds: 3)), () {
      getLoginDetails();
    });
    super.initState();
  }

  getLoginDetails() async {
    var type = await ShareManager.getLogintype();
    switch (type) {
      case UserType.Customer:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (ctx) =>
                    HomeScreen(type: type!))); // ignore: missing_required_param
        break;

      case UserType.Lab:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (ctx) =>
                    HomeScreen(type: type!))); // ignore: missing_required_param
        break;
      default:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (ctx) =>
                    HomePage())); // ignore: missing_required_param
        break;
    }
  }

  double screenHeight(BuildContext context, {double dividedBy = 1}) {
    return screenSize(context).height / dividedBy;
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
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
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF000000), Color(0xFF000000)]),*/
          ),
          child: Stack(children: <Widget>[
            Center(
              child: Image.asset(
                "Assets/logo.png",
                width: screen.width / 1.5,
                height: screen.height,
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 50,
                child: Container(
                    //width: screen.width,
                    child: Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    'SHREE SPACE',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Montserrat-Bold',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ))),
            Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Container(
                    //width: screen.width,
                    child: const Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    'Power By',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Montserrat-Bold',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ))),
            /*  Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  //width: screen.width,
                    child: Align(
                      alignment: AlignmentDirectional.center,
                      child: Center(
                        child: Image.asset(
                          "Assets/splash1.png",
                          width: screen.width,
                          height: screen.height / 1.6,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ))),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  //width: screen.width,
                    child: Align(
                      alignment: AlignmentDirectional.center,
                      child: Center(
                        child: Image.asset(
                          "Assets/splash2.png",
                          width: screen.width,
                          height: screen.height / 1.6,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ))),*/
            Column(children: <Widget>[
              /* Container(
                height: screenHeight(context, dividedBy: 2),
                child: Image.asset(
                  "Assets/splash1.png",
                  width: screen.width,
                  height: screen.height / 2,
                  fit: BoxFit.fitHeight,
                ),
              ),*/
              /*Container(
                  height: screenHeight(context, dividedBy: 2),
                  child: Image.asset(
                    "Assets/splash2.png",
                    width: screen.width,
                    height: screen.height / 2,
                    fit: BoxFit.fitHeight,
                  )),*/
            ]),
          ])

          /**/
          ),
    );
  }
}
