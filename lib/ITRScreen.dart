import 'dart:io';
import 'dart:math' as math;
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'Backend/api_request.dart';
import 'Backend/share_manager.dart';
import 'Config/enums.dart';
import 'HomeScreen.dart';
import 'package:dio/dio.dart' as dio;

class ITRScreen extends StatefulWidget {
  final UserType type;

  ITRScreen({required this.type, Key? key}) : super(key: key);

  @override
  State<ITRScreen> createState() => _ITRScreenuiState();
}

class _ITRScreenuiState extends State<ITRScreen> {
  bool _isDrawerOpen = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List _children = [];

  int currentIndex = 2;
  bool isLoding = false;

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
      HomePlaceholderWidget(widget.type),
      Homeui(widget.type),
      Homeui(widget.type),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: DrawerData(context, widget.type),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          heroTag: "btn1",
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(type: widget.type)));
          },
          backgroundColor: Color(0xFF131416),
          child: Image.asset(
            "Assets/home.png",
            fit: BoxFit.fitHeight,
          )),
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
            /*Image.asset(
              'Assets/desh1.png',
              fit: BoxFit.fitHeight,
              height: 50,
              //width: 150,
            ),*/
            Container(
                padding: const EdgeInsets.only(left: 20.0),
                child: const Text("Add ITR"))
          ],
        ),
      ),
      body: _children[currentIndex],
    );
  }
}

class HomePlaceholderWidget extends StatefulWidget {
  UserType? type;

  HomePlaceholderWidget(UserType type, {Key? key}) : super(key: key) {
    this.type = type;
  }

  @override
  State<HomePlaceholderWidget> createState() => _HomeholderWidgetState();
}

class _HomeholderWidgetState extends State<HomePlaceholderWidget> {
  bool isLoding = false;
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  TextEditingController startyearController = TextEditingController();
  TextEditingController endyearController = TextEditingController();
  List _document = [];
  List imagelist2 = [];
  DateTime stratdate = DateTime.now(), enddate = DateTime.now();
  int _selectedYear = 0;
  int _startYear = 2023;
  int _endYear = 2100;

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
          // color: Colors.black87,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              _pickDate("Select Year", "Start Year",
                                  startyearController),
                              _pickDate2(
                                  "Select Year", "End Year", endyearController),
                              const SizedBox(height: 20),
                              const Align(
                                alignment: AlignmentDirectional.bottomStart,
                                child: Text(
                                  "Documents",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat-Bold',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          _showPicker(context);
                                        },
                                        child: _document.isEmpty
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                height: 140,
                                                width: 100,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: const [
                                                    Icon(
                                                      Icons.add_circle,
                                                      size: 60,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      "Browse",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : _document.isNotEmpty
                                                ? Container(
                                                    height: 140,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Center(
                                                        child: Text(
                                                      _document.length
                                                              .toString() +
                                                          " Selected",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    )))
                                                : SizedBox())
                                  ],
                                ),
                              ),
                              buttondata(lblbutton: "Ok"),
                              const SizedBox(height: 30),
                            ]),
                      ))))),
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

  Widget _pickDate(
      String hint, String value, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$value :",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              )),
          GestureDetector(
            onTap: () {
              _selectDate(controller);
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Select Year";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: hint,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickDate2(
      String hint, String value, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$value :",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              )),
          GestureDetector(
            onTap: () {
              _selectDate2(controller);
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Select Year";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: hint,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectYear(
      BuildContext context, TextEditingController selectedDate) async {
    final int? selected = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedYear = _startYear + index;
                print(_selectedYear);
              });
            },
            children:
                List<Widget>.generate(_endYear - _startYear + 1, (int index) {
              return Text("${_startYear + index}");
            }),
          ),
        );
      },
    );
    if (selected != null) {
      setState(() {
        // stratdate = selected;
        print(selected);
        selectedDate.value = TextEditingValue(text: "${selected.toString()}");
      });
    }
  }

  Future<Null> _selectDate(TextEditingController selectedDate) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showMonthYearPicker(
      context: context,
      firstDate: DateTime(2019),
      initialDate: DateTime.now(),
      lastDate: DateTime(2101),
      /* builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },*/
    );

    if (picked != null) {
      setState(() {
        stratdate = picked;
        String formattedDate = DateFormat('yyyy').format(picked);
        selectedDate.value = TextEditingValue(text: formattedDate);
      });
    }
  }

  Future<Null> _selectDate2(TextEditingController selectedDate) async {
    try {
      final DateTime? picked = await showMonthYearPicker(
        context: context,
        firstDate: DateTime(stratdate.year),
        initialDate: DateTime(stratdate.year, stratdate.month, stratdate.day),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (picked != null) {
        setState(() {
          enddate = picked;
          String formattedDate = DateFormat('yyyy').format(picked);
          selectedDate.value = TextEditingValue(text: formattedDate);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
              ),
              child: SafeArea(
                child: Container(
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                          leading: new Icon(Icons.photo_library),
                          title: new Text('Photo Library'),
                          onTap: () {
                            // _imgFromGallery();
                            _imgFromDocument();
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                ),
              ));
        });
  }

  _imgFromDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf'], allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      if (files.isNotEmpty) {
        // imageFileList.addAll(files);
        print(files.length);
        List file = result.files;
        print(file.length);
        _document = file;
        print(_document.length);
      }
    }

    setState(() {});
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
                  String user_id = await ShareManager.getUserID();
                  String member_name = await ShareManager.getName();
                  String member_mobile = await ShareManager.getMobile();
                  if (_document != null) {
                    for (var i = 0; i < _document.length; i++) {
                      imagelist2.add(
                          await dio.MultipartFile.fromFile(_document[i].path));
                    }
                  }
                  Map<String, dynamic> map = Map();
                  map["mem_id"] = user_id;
                  map["mem_name"] = member_name;
                  map["mem_phone"] = member_mobile;
                  map["start_year"] = startyearController.text;
                  map["end_year"] = endyearController.text;
                  map["doc[]"] = imagelist2;
                  final data = await API.itraddAPI(map);
                  if (data.status == 1) {
                    setLoding();
                    Fluttertoast.showToast(msg: data.msg);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(type: widget.type!)),
                        (route) => false);
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
}
