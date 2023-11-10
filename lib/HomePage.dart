import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Config/enums.dart';

import 'LABLoginScreen.dart';
import 'LoginScreen.dart';
import 'Widget/animated_login_type_button3.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Flexible(
                  child: GestureDetector(
                child: AnimetedLoginTypeButton3(
                    image: "Assets/supervisor.png",
                    name: "MEMBER",
                    onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (ctx) => LoginScreen(
                              type: UserType.Customer,
                            ),
                          ),
                        )),
              )),
            ]),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Flexible(
                  child: GestureDetector(
                    child: AnimetedLoginTypeButton3(
                        image: "Assets/manager.png",
                        name: "LAB",
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (ctx) => LABLoginScreen(
                              type: UserType.Lab,
                            ),
                          ),
                        )),
                  )),
            ]),
          ],
        ),
      ),
    ));
  }
}
