import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shreegraphic/Model/bookingModel.dart';

import '../Backend/api_request.dart';

class BookingEquipmentField extends StatefulWidget {
  final BookingModel booking;
  final int index;

  BookingEquipmentField({required this.booking, required this.index, Key? key})
      : super(key: key);

  @override
  _BookingEquipmentFieldState createState() => _BookingEquipmentFieldState();
}

class _BookingEquipmentFieldState extends State<BookingEquipmentField> {
  bool isLoding = false;
  TextEditingController mnoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    mnoController.addListener(() {
      print("mno is = ${mnoController.text}");
      setState(() {
        widget.booking.setMobile = mnoController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    "Mobile No. *",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                mnoFormFiled(),
                const SizedBox(height: 20),
                const Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    "Name *",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                nameFormFiled(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Visibility(
              visible: isLoding,
              child: Container(
                height: 250,
                color: Colors.transparent,
                child: Center(
                  child: Platform.isIOS
                      ? const CupertinoActivityIndicator(
                          radius: 25,
                        )
                      : CircularProgressIndicator(),
                ),
              ))
        ],
      ),
    );
  }

  Widget mnoFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: mnoController,
        validator: (value) {
          if (value!.isEmpty || value.length != 10) {
            return "Enter Mobile No.";
          }
          return null;
        },
        onChanged: (value) async {
          print("mobile no. is = $value");
          if (value.length == 10) {
            setLoding();
            var requestData = await API.getMemberbyMobileAPI(value);

            if (requestData.status == 1) {
              nameController.text = requestData.result[0]['name'];
              setLoding();
            } else {
              setLoding();
              Fluttertoast.showToast(msg: requestData.msg);
              mnoController.clear();
              nameController.clear();
            }
          }
        },
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Montserrat-Bold',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Mobile No.",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'Montserrat-Bold',
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
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

  Widget nameFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: nameController,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Montserrat-Bold',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        keyboardType: TextInputType.multiline,
        minLines: 3,
        maxLines: null,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Member Name",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'Montserrat-Bold',
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
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

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }
}
