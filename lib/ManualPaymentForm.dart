import 'dart:math' as math;

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Backend/api_request.dart';
import '../HomeScreen.dart';
import 'Config/enums.dart';

class ManualPaymentForm extends StatefulWidget {
  String index;
  final UserType type;

  ManualPaymentForm({this.index = "", required this.type, Key? key})
      : super(key: key);

  @override
  State<ManualPaymentForm> createState() => _ManualPaymentFormState();
}

class _ManualPaymentFormState extends State<ManualPaymentForm> {
  List _children = [];
  int currentIndex = 2;
  bool isLoding = false;
  bool _isDrawerOpen = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
      print(currentIndex);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _children = [
      Profileui(widget.type),
      Homeui(widget.type),
      HomePlaceholderWidget(widget.type, widget.index),
      Homeui(widget.type),
      Homeui(widget.type),
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Stack(
      children: [
        Scaffold(
          key: _key,
          drawer: DrawerData(context, widget.type),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Visibility(
              visible: !keyboardIsOpen,
              child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(type: widget.type)));
                  },
                  backgroundColor: Color(0xFF131416),
                  child: Image.asset(
                    "Assets/home.png",
                    fit: BoxFit.fitHeight,
                  ))),
          bottomNavigationBar: BottomAppBar(
            clipBehavior: Clip.antiAlias,
            shape: const CircularNotchedRectangle(),
            notchMargin: 4,
            child: BottomNavigationBar(
              backgroundColor: Color(0xFF131416),
              selectedItemColor: Color(0xFF131416),
              type: BottomNavigationBarType.fixed,
              //unselectedItemColor: Colors.white,
              onTap: onTabTapped,
              // new
              currentIndex: currentIndex,
              items: [
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'Assets/profile.png',
                      height: 50,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Stack(children: <Widget>[
                      Image.asset(
                        "Assets/file.png",
                        height: 50,
                      ),
                      Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                              //width: screen.width,
                              child: Align(
                            alignment: AlignmentDirectional.bottomStart,
                            child: Center(
                              child: Image.asset(
                                "Assets/menu_file.png",
                                height: 50,
                              ),
                            ),
                          ))),
                    ]),
                    label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'Assets/rupess.png',
                      height: 50,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: InkWell(
                      child: Image.asset(
                        'Assets/menu.png',
                        height: 50,
                      ),
                      onTap: () async {
                        if (!_isDrawerOpen) {
                          this._key.currentState!.openDrawer();
                          // Drawerdata(context);
                        } else {
                          if (_isDrawerOpen) {
                            setState(() {
                              _isDrawerOpen = false;
                            });
                          }
                          Navigator.pop(context);
                        }
                      },
                    ),
                    label: ""),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Color(0xFF131416),
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /* Image.asset(
                  'Assets/desh1.png',
                  fit: BoxFit.scaleDown,
                  height: 50,
                ),*/
                Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Manual Payment"))
              ],
            ),
          ),
          body: _children[currentIndex],
        ),
        Visibility(
            visible: isLoding,
            child: Opacity(
              opacity: 0.7,
              child: Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ))
      ],
    );
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }
}

class HomePlaceholderWidget extends StatefulWidget {
  UserType? type;
  String index = "";
  HomePlaceholderWidget(UserType type, String index, {Key? key})
      : super(key: key) {
    this.type = type;
    this.index = index;
  }

  @override
  State<HomePlaceholderWidget> createState() => _HomeholderWidgetState();
}

class _HomeholderWidgetState extends State<HomePlaceholderWidget> {
  bool isLoding = false;
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  var selectedType;
  List<String> typeList = [
    "Cash",
    "Cheque",
  ];
  int index = 0, index1 = 0;

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Stack(children: [
      Container(
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
              child: SingleChildScrollView(
                  child: Form(
                key: _fbKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Amount *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        amountFormFiled(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Type *",
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
                        typeDropDownMenu("Select Type", typeList, (newVal) {
                          if (newVal != selectedType) {
                            selectedType = newVal;
                            setState(() {});
                          }
                        }, selectedType),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Note ",
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
                        noteFormFiled(),
                        const SizedBox(height: 20),
                        buttondata(lblbutton: "Ok"),
                        const SizedBox(height: 30)
                      ]),
                ),
              )))),
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

  Widget buttondata({String lblbutton = ""}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
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
          borderRadius: BorderRadius.circular(10),
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
                    final requestData = await API.manualPaymentApi(
                      widget.index,
                      selectedType,
                      amountController.text,
                      noteController.text,
                    );
                    if (requestData.status == 1) {
                      setLoding();
                      Fluttertoast.showToast(msg: requestData.msg);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen(type: widget.type!)),
                          (route) => false);
                    } else {
                      setLoding();
                      Fluttertoast.showToast(msg: requestData.msg);
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Please Select Detail");
                  }
                  return;
                } else {
                  print("Unsuccessful");
                }
              } else {
                setLoding();
                Fluttertoast.showToast(
                    msg: "Please check your internet connection");
              }
            },
            child: Text(
              lblbutton,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.33),
            )),
      ),
    );
  }

  Widget amountFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: amountController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Amount";
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
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Amount",
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

  Widget noteFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: noteController,
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
          hintText: "Note",
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
}
