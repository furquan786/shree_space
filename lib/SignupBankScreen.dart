import 'dart:math' as math;

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Backend/api_request.dart';
import 'HomeScreen.dart';
import 'SignupDocumentScreen.dart';

class SignupBankScreen extends StatefulWidget {
  var gender,
      name,
      //  second_name,
      nikname,
      mobile,
      altmobile,
      dob,
      home_address,
      state,
      city,
      //  area,
      village,
      pincode,
      email;

  SignupBankScreen({
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
    //  @required this.area,
    @required this.village,
    @required this.pincode,
    @required this.email,
  });

  @override
  _SignupBankScreenState createState() => _SignupBankScreenState();
}

class _SignupBankScreenState extends State<SignupBankScreen> {
  TextEditingController actypeCntroller = TextEditingController();
  TextEditingController acnoCntroller = TextEditingController();
  TextEditingController ifsccodeCntroller = TextEditingController();
  bool isLoding = false;
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  List<String> accountTypeList = [
    "Current",
    "Saving",
  ];
  var selectedType;

  @override
  void initState() {
    super.initState();
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
                'Bank Details',
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
                "Ac Type *",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 5),
            typeDropDownMenu("Select Type", accountTypeList, (newVal) {
              if (newVal != selectedType) {
                selectedType = newVal;
                setState(() {});
              }
            }, selectedType),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "A/C No. *",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            accountnoFormFiled(),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "IFSC CODE *",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            ifsccodeFormFiled(),
            const SizedBox(height: 20),
            //buttonLogindata(lblbutton: "NEXT"),
            Align(
              alignment: AlignmentDirectional.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Wrap(
                  direction: Axis.horizontal, //Vertical || Horizontal
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: screen.width * 0.330,
                        height: 43,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: FractionalOffset.bottomLeft,
                              end: FractionalOffset.bottomRight,
                              transform: GradientRotation(math.pi / 4),
                              //stops: [0.4, 1],
                              colors: [
                                Color(0xFF131416),
                                Color(0xFF151619),
                              ]),
                          boxShadow: boxShadow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all(
                                  Size(double.infinity, 50)),
                              backgroundColor: MaterialStateProperty.all(
                                Color(0xFF131416),
                              ),
                              // elevation: MaterialStateProperty.all(3),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupDocumentScreen(
                                        gender: widget.gender,
                                        name: widget.name,
                                        // second_name: widget.second_name,
                                        nikname: widget.nikname,
                                        mobile: widget.mobile,
                                        altmobile: widget.altmobile,
                                        dob: widget.dob,
                                        home_address: widget.home_address,
                                        state: widget.state,
                                        city: widget.city,
                                        //  area: widget.area,
                                        village: widget.village,
                                        pincode: widget.pincode,
                                        email: widget.email,
                                        actype: actypeCntroller.text,
                                        acno: acnoCntroller.text,
                                        ifsc: ifsccodeCntroller.text)),
                              );
                            },
                            child: Text(
                              "SKIP",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat-Bold',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 1.33),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        width: screen.width * 0.330,
                        height: 43,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                              begin: FractionalOffset.bottomLeft,
                              end: FractionalOffset.bottomRight,
                              transform: GradientRotation(math.pi / 4),
                              //stops: [0.4, 1],
                              colors: [
                                Color(0xFF131416),
                                Color(0xFF151619),
                              ]),
                          boxShadow: boxShadow,
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all(
                                  Size(double.infinity, 50)),
                              backgroundColor: MaterialStateProperty.all(
                                Color(0xFF131416),
                              ),
                              // elevation: MaterialStateProperty.all(3),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (await DataConnectionChecker().hasConnection) {
                                if (_fbKey.currentState!.validate()) {
                                  if (selectedType != null) {
                                    setLoding();
                                    final requestData = await API.bankdetailApi(
                                      selectedType,
                                      acnoCntroller.text,
                                      ifsccodeCntroller.text,
                                      widget.mobile,
                                    );
                                    if (requestData.status == 1) {
                                      setLoding();
                                      Fluttertoast.showToast(
                                          msg: requestData.msg);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignupDocumentScreen(
                                                    gender: widget.gender,
                                                    name: widget.name,
                                                    //   second_name: widget.second_name,
                                                    nikname: widget.nikname,
                                                    mobile: widget.mobile,
                                                    altmobile: widget.altmobile,
                                                    dob: widget.dob,
                                                    home_address:
                                                        widget.home_address,
                                                    state: widget.state,
                                                    city: widget.city,
                                                    //  area: widget.area,
                                                    village: widget.village,
                                                    pincode: widget.pincode,
                                                    email: widget.email,
                                                    actype:
                                                        actypeCntroller.text,
                                                    acno: acnoCntroller.text,
                                                    ifsc: ifsccodeCntroller
                                                        .text)),
                                      );
                                    } else {
                                      setLoding();
                                      Fluttertoast.showToast(
                                          msg: requestData.msg);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Please Select Detail");
                                  }
                                  return;
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "Please check your internet connection");
                              }
                            },
                            child: Text(
                              "NEXT",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat-Bold',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 1.33),
                            )),
                      ),
                    )
                  ],
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

  Widget typeDropDownMenu(String hint, List<String> list,
      Function(String? val) onChange, String value) {
    return SizedBox(
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              filled: true,
              fillColor: Colors.white,
            ),
            items: list.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(
                  val,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              );
            }).toList(),
            value: value,
            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onChanged: onChange),
      ),
    );
  }

  Widget buttonLogindata({String lblbutton = ""}) {
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
            FocusScope.of(context).requestFocus(FocusNode());
            if (await DataConnectionChecker().hasConnection) {
              if (_fbKey.currentState!.validate()) {
                if (selectedType != null) {
                  setLoding();
                  final requestData = await API.bankdetailApi(
                    selectedType,
                    acnoCntroller.text,
                    ifsccodeCntroller.text,
                    widget.mobile,
                  );
                  if (requestData.status == 1) {
                    setLoding();
                    Fluttertoast.showToast(msg: requestData.msg);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignupDocumentScreen(
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
                              // area: widget.area,
                              village: widget.village,
                              pincode: widget.pincode,
                              email: widget.email,
                              actype: actypeCntroller.text,
                              acno: acnoCntroller.text,
                              ifsc: ifsccodeCntroller.text)),
                    );
                  } else {
                    setLoding();
                    Fluttertoast.showToast(msg: requestData.msg);
                  }
                } else {
                  Fluttertoast.showToast(msg: "Please Select Detail");
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
                color: Colors.white,
                letterSpacing: 1.33),
          )),
    );
  }

  Widget accounttypeFormFiled() {
    return SizedBox(
      // height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: actypeCntroller,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Account Type";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
          hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
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

  Widget accountnoFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: acnoCntroller,
        keyboardType: TextInputType.number,
        maxLength: 12,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,

        /* onChanged: (String newVal) {
            if(newVal.length <= maxLength){
              text = newVal;
            }else{
              acnoCntroller.text = text;
            }

          },
*/
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Account No";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
          hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
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

  Widget ifsccodeFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: ifsccodeCntroller,
        onChanged: (value) {
          ifsccodeCntroller.value = TextEditingValue(
              text: value.toUpperCase(),
              selection: ifsccodeCntroller.selection);
        },
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter IFSC CODE";
          }
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
          hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
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
