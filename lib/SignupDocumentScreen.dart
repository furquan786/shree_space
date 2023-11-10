import 'dart:io';
import 'dart:math' as math;
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dio/dio.dart' as dio;
import 'package:field_validation/Source_Code/FlutterValidation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'Backend/api_request.dart';
import 'Backend/share_manager.dart';
import 'HomeScreen.dart';
import 'SignupCreateIDScreen.dart';

class SignupDocumentScreen extends StatefulWidget {
  var gender,
      name,
      //   second_name,
      nikname,
      mobile,
      altmobile,
      dob,
      home_address,
      state,
      city,
      //   area,
      village,
      pincode,
      email,
      actype,
      acno,
      ifsc;

  SignupDocumentScreen({
    @required this.gender,
    @required this.name,
    // @required this.second_name,
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
    @required this.actype,
    @required this.acno,
    @required this.ifsc,
  });

  @override
  _SignupDocumentScreenState createState() => _SignupDocumentScreenState();
}

class _SignupDocumentScreenState extends State<SignupDocumentScreen> {
  bool isLoding = false;
  final picker = ImagePicker();
  FlutterValidation validator = FlutterValidation();
  File? _image1, _image2;
  PickedFile? image1;
  PickedFile? image2;
  TextEditingController aadharCntroller = TextEditingController();
  TextEditingController panCntroller = TextEditingController();
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();

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
            const Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                'Documents',
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
                "Addharcard No *",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            aadharFormFiled(),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "Addharcard *",
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
            upLoadAddharData(),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "Pancard No *",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat-Bold',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            pancardFormFiled(),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                "Pancard *",
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
            upLoadPancard(),
            const SizedBox(height: 20),
            //   buttonLogindata(lblbutton: "NEXT"),
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
                                  const Size(double.infinity, 50)),
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF131416),
                              ),
                              // elevation: MaterialStateProperty.all(3),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupCreateIDScreen(
                                        gender: widget.gender,
                                        name: widget.name,
                                        //second_name: widget.second_name,
                                        nikname: widget.nikname,
                                        mobile: widget.mobile,
                                        altmobile: widget.altmobile,
                                        dob: widget.dob,
                                        home_address: widget.home_address,
                                        state: widget.state,
                                        city: widget.city,
                                        village: widget.village,
                                        pincode: widget.pincode,
                                        email: widget.email,
                                        actype: widget.actype,
                                        acno: widget.acno,
                                        ifsc: widget.ifsc)),
                              );
                            },
                            child: const Text(
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
                                  const Size(double.infinity, 50)),
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF131416),
                              ),
                              // elevation: MaterialStateProperty.all(3),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (await DataConnectionChecker().hasConnection) {
                                if (_fbKey.currentState!.validate()) {
                                  if (_image1 != null && _image2 != null) {
                                    setLoding();
                                    List addharlist = [];
                                    List panlist = [];
                                    if (_image1 != null) {
                                      addharlist.add(
                                          await dio.MultipartFile.fromFile(
                                              _image1!.path));
                                    }
                                    if (_image2 != null) {
                                      panlist.add(
                                          await dio.MultipartFile.fromFile(
                                              _image2!.path));
                                    }

                                    // final token = await getToken();
                                    Map<String, dynamic> map = Map();
                                    String user_id = await ShareManager.getID();
                                    map["user_id"] = user_id;
                                    map["adhar_no"] =
                                        aadharCntroller.text.trim();
                                    map["adhar"] = addharlist;
                                    map["pan_no"] = panCntroller.text.trim();
                                    map["pan"] = panlist;
                                    map["mobile"] = widget.mobile;
                                    final data = await API.addharpanAPI(map);
                                    if (data.status == 1) {
                                      setLoding();
                                      Fluttertoast.showToast(msg: data.msg);
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignupCreateIDScreen(
                                                    gender: widget.gender,
                                                    name: widget.name,
                                                    //second_name: widget.second_name,
                                                    nikname: widget.nikname,
                                                    mobile: widget.mobile,
                                                    altmobile: widget.altmobile,
                                                    dob: widget.dob,
                                                    home_address:
                                                        widget.home_address,
                                                    state: widget.state,
                                                    city: widget.city,
                                                    village: widget.village,
                                                    pincode: widget.pincode,
                                                    email: widget.email,
                                                    actype: widget.actype,
                                                    acno: widget.acno,
                                                    ifsc: widget.ifsc)),
                                      );
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Please Select Images");
                                  }
                                  return;
                                } else {
                                  print("Unsuccessful");
                                }
                              } else {
                                setLoding();
                                Fluttertoast.showToast(
                                    msg:
                                        "Please check your internet connection");
                              }
                            },
                            child: const Text(
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

  Widget aadharFormFiled() {
    return SizedBox(
      //  height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: aadharCntroller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter Aadharcard Detail";
          }

          bool isAadharNum = validator.aadhaarValidate(content: value);
          if (isAadharNum == false) {
            return "Please Enter Valid Aadharcard Detail";
          }

          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget pancardFormFiled() {
    return SizedBox(
      // height: 40,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: panCntroller,
        onChanged: (value) {
          panCntroller.value = TextEditingValue(
              text: value.toUpperCase(), selection: panCntroller.selection);
        },
        keyboardType: TextInputType.text,
        validator: (value) {
          Pattern pattern = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
          RegExp regex = RegExp(pattern.toString());
          if (value!.isEmpty) {
            return "Please Enter PANCard Detail";
          }
          if (!regex.hasMatch(value)) return "please Enter Valid PANCard No";
          return null;
        },
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "",
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

  Widget upLoadAddharData() {
    return SizedBox(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () {
          _showPicker(context);
        },
        child: _image1 != null
            ? Container(
                height: 140,
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                child: Image.file(
                  File(_image1!.path),
                  width: 100.0,
                  height: 140.0,
                  fit: BoxFit.fitHeight,
                ))
            : Container(
                height: 140,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Icon(Icons.add_circle,
                            size: 60, color: Colors.white)),
                    Center(
                      child: SizedBox(
                        width: 100,
                        child: Text("Upload Photo",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    )
                  ],
                )),
      ),
    ]));
  }

  Widget upLoadPancard() {
    return SizedBox(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () {
          _showPicker2(context);
        },
        child: _image2 != null
            ? Container(
                height: 140,
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                child: Image.file(
                  File(_image2!.path),
                  width: 100.0,
                  height: 140.0,
                  fit: BoxFit.fitHeight,
                ))
            : Container(
                height: 140,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Icon(Icons.add_circle,
                            size: 60, color: Colors.white)),
                    Center(
                      child: SizedBox(
                        width: 100,
                        child: Text("Upload Photo",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    )
                  ],
                )),
      ),
    ]));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showPicker2(context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery2();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera2();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    cropImage(image!);
  }

  _imgFromGallery2() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    cropImage2(image!);
  }

  Future<File> cropImage(XFile file) async {
    final File? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: androidUiSettings,
      iosUiSettings: iosUiSettings,
    );

    if (croppedImage != null) {
      _image1 = croppedImage;
      setState(() {});
    } else {
      print("Image is not cropped.");
    }

    return croppedImage!;
  }

  Future<File> cropImage2(XFile file) async {
    final File? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: androidUiSettings,
      iosUiSettings: iosUiSettings,
    );

    if (croppedImage != null) {
      _image2 = croppedImage;
      setState(() {});
    } else {
      print("Image is not cropped.");
    }

    return croppedImage!;
  }

  static AndroidUiSettings androidUiSettings = const AndroidUiSettings(
    toolbarTitle: "Cropper",
    toolbarColor: Colors.deepOrange,
    toolbarWidgetColor: Colors.white,
    initAspectRatio: CropAspectRatioPreset.original,
    lockAspectRatio: false,
  );

  static IOSUiSettings iosUiSettings = const IOSUiSettings(
    minimumAspectRatio: 1.0,
  );

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;

    cropImage(image);
  }

  _imgFromCamera2() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;

    cropImage2(image);
  }

  Widget buttonLogindata({String lblbutton = ""}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.white,
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
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 50)),
            backgroundColor: MaterialStateProperty.all(
              const Color(0xFF131416),
            ),
            // elevation: MaterialStateProperty.all(3),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            if (await DataConnectionChecker().hasConnection) {
              if (_fbKey.currentState!.validate()) {
                if (_image1 != null && _image2 != null) {
                  setLoding();
                  List addharlist = [];
                  List panlist = [];
                  if (_image1 != null) {
                    addharlist
                        .add(await dio.MultipartFile.fromFile(_image1!.path));
                  }
                  if (_image2 != null) {
                    panlist
                        .add(await dio.MultipartFile.fromFile(_image2!.path));
                  }

                  // final token = await getToken();
                  Map<String, dynamic> map = Map();
                  String user_id = await ShareManager.getID();
                  map["user_id"] = user_id;
                  map["adhar_no"] = aadharCntroller.text.trim();
                  map["adhar"] = addharlist;
                  map["pan_no"] = panCntroller.text.trim();
                  map["pan"] = panlist;
                  map["mobile"] = widget.mobile;
                  final data = await API.addharpanAPI(map);
                  if (data.status == 1) {
                    setLoding();
                    Fluttertoast.showToast(msg: data.msg);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignupCreateIDScreen(
                              gender: widget.gender,
                              name: widget.name,
                              //second_name: widget.second_name,
                              nikname: widget.nikname,
                              mobile: widget.mobile,
                              altmobile: widget.altmobile,
                              dob: widget.dob,
                              home_address: widget.home_address,
                              state: widget.state,
                              city: widget.city,
                              village: widget.village,
                              pincode: widget.pincode,
                              email: widget.email,
                              actype: widget.actype,
                              acno: widget.acno,
                              ifsc: widget.ifsc)),
                    );
                  }
                } else {
                  Fluttertoast.showToast(msg: "Please Select Images");
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
            style: const TextStyle(
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
