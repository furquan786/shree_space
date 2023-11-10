import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shreegraphic/Backend/share_manager.dart';
import 'package:shreegraphic/Config/enums.dart';
import 'package:shreegraphic/Model/bookingModel.dart';
import 'package:shreegraphic/editBooking.dart';

import '../Backend/api_request.dart';

class UpdateBookingMemberui extends StatefulWidget {
  UserType type;

  String oldmobile, name, id, bkid;

  UpdateBookingMemberui(
      {required this.oldmobile,
      required this.name,
      required this.type,
      required this.bkid,
      required this.id,
      Key? key})
      : super(key: key);

  @override
  _UpdateBookingMemberuiState createState() => _UpdateBookingMemberuiState();
}

class _UpdateBookingMemberuiState extends State<UpdateBookingMemberui> {
  bool isLoding = false;
  TextEditingController mnoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    mnoController.text = widget.oldmobile;
    nameController.text = widget.name;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF131416),
            centerTitle: true,
            title: const Text("Booking Item"),
          ),
          body: Container(
            width: screen.width,
            height: screen.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.02,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        Material(
                            borderRadius: BorderRadius.circular(10.0),
                            child: MaterialButton(
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent)),
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.5,
                                height: 50,
                                child: const Text(
                                  "Update",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                color: Colors.white,
                                onPressed: () async {
                                  var userId = await ShareManager.getUserID();
                                  setLoding();

                                  final requestData =
                                      await API.editBookingMemberAPI(
                                    widget.oldmobile,
                                    mnoController.text,
                                    widget.bkid,
                                    userId,
                                    widget.id,
                                  );
                                  if (requestData.status == 1) {
                                    setLoding();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditBookingui(
                                                type: widget.type,
                                                id: widget.id,
                                              )),
                                    );
                                  } else {
                                    setLoding();
                                    Fluttertoast.showToast(
                                        msg: requestData.msg);
                                  }
                                }))
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
