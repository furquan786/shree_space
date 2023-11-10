import 'package:flutter/material.dart';
import 'package:spring/spring.dart';

class AnimetedLoginTypeButton3 extends StatelessWidget {
  final String image;
  final String name;
  final Function() onTap;

  AnimetedLoginTypeButton3({
    required this.image,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
        height: 230,
        width: screen.width,
        child: Spring.bubbleButton(
          animDuration: Duration(milliseconds: 400),
          bubbleStart: .0,
          bubbleEnd: .9,
          curve: Curves.easeOut,
          child: GestureDetector(
            onTap: onTap,
            child: Card(
              elevation: 5,
              color: Colors.cyan,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Container(
                      height: 180,
                      //width: screen.width / 2.25,
                      child: Image.asset(
                        image,
                      ),
                    ),
                    /* SizedBox(
                  height: 20,
                ),*/
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
