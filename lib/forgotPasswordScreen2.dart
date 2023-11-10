import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shreegraphic/LoginScreen.dart';

import 'Config/enums.dart';

class NextScreen extends StatelessWidget {
  UserType type;
  var email;
  NextScreen({required this.type, Key? key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screen.width,
        height: screen.height,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2C3137), Color(0xFF1B1C20)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Stack(children: <Widget>[
              const Center(
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
            const SizedBox(
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
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "Please Check ${this.email} for Password Reset Link Mail.",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'PlayfairDisplay-Regular',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 80),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 7,
                    spreadRadius: 5,
                    offset: const Offset(0, 3),
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
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                  type: this.type,
                                )),
                        (route) => false);
                  },
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Montserrat-Bold',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE58B29),
                        letterSpacing: 1.33),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
