import 'dart:io';

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../Backend/api_request.dart';
import '../Backend/share_manager.dart';
import '../Config/enums.dart';
import '../ELearningCategory.dart';
import '../HomePage.dart';
import '../HomeScreen.dart';
import '../Model/Category.dart';
import '../Model/buysell_whatsappmsg_model.dart';
import '../Model/request_data.dart';
import '../myannouncement.dart';
import '../myimagesui.dart';
import 'buysellMainPage.dart';

class Adddetailsui extends StatefulWidget {
  //const Adddetailsui({Key key}) : super(key: key);
  UserType type;

  Adddetailsui({required this.type, Key? key}) : super(key: key);

  @override
  State<Adddetailsui> createState() => _AdddetailsuiState();
}

class _AdddetailsuiState extends State<Adddetailsui> {
  List _children = [];
  int currentIndex = 2;
  bool isLoding = false;
  bool _isDrawerOpen = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _children = [
      Profileui(widget.type),
      Homeui(widget.type),
      HomePlaceholderWidget(type: widget.type),
      Homeui(widget.type),
      Homeui(widget.type),
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
      print(currentIndex);
    });
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
                    "Assets/rectangle.png",
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
                    child: Text("Add Details"))
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
  //HomePlaceholderWidget({Key key}) : super(key: key);
  UserType type;

  HomePlaceholderWidget({required this.type, Key? key}) : super(key: key) {
    this.type = type;
  }
  @override
  State<HomePlaceholderWidget> createState() => _HomeholderWidgetState();
}

class _HomeholderWidgetState extends State<HomePlaceholderWidget> {
  bool isLoding = false;
  String selectedCategory = "",
      selectedType = "",
      selectedAddress = "",
      address = "";
  final picker = ImagePicker();
  PickedFile? image1;
  PickedFile? image2;
  PickedFile? image3;
  File? _image1, _image2, _image3;
  List<Category> categoryList = [];

  String message = "";

  List<String> addressList = [
    "Home Address",
    "Office Address",
  ];
  List<String> typeList = [
    "Sell",
    "Rent",
  ];
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController prodctnameController = TextEditingController();
  TextEditingController prodDesController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController availStockController = TextEditingController();
  TextEditingController rentpriceController = TextEditingController();

  List imagelist = [];
  List<BuysellWhatsappMsgModel> popupmsgList = [];

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Stack(children: [
      Container(
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
                            "Your Name *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        usernameFormFiled(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Mobile Number *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        mobileFormFiled(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Category *",
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
                        categoryDropDownMenu("Select Category", categoryList,
                            (newVal) {
                          if (newVal != selectedCategory) {
                            selectedCategory = newVal!;
                            setState(() {});
                          }
                        }, selectedCategory),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Name of product *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        productNameFormFiled(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Product Description *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        productDescFormFiled(),
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
                            selectedType = newVal!;
                            setState(() {});
                          }
                        }, selectedType),
                        const SizedBox(height: 20),
                        Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: selectedType == "Rent"
                              ? Text(
                                  "Rent Cost (Daily based)",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat-Bold',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                )
                              : Text(
                                  "Product Cost *",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat-Bold',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                        ),
                        productpriceFormFiled(),
                        const SizedBox(height: 20),
                        /*const Align(
                                        alignment: AlignmentDirectional.bottomStart,
                                        child: Text(
                                          "Rent Cost (Daily based)",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: 'Montserrat-Bold',
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                      rentpriceFormFiled(),*/
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Total Stock (In Number) *",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        availSotckFormFiled(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Address *",
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
                        addressDropDownMenu("Select Address", addressList,
                            (newVal) {
                          if (newVal != selectedAddress) {
                            selectedAddress = newVal!;
                            getAddress(selectedAddress);
                            setState(() {});
                          }
                        }, selectedAddress),
                        const SizedBox(height: 10),
                        address != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Container(
                                  width: screen.width,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      address,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'Montserrat-Bold',
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 2),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Upload Photos *",
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
                        upLoadData(),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "The information which I provided in Buy-Sell Section is true, if any information is wrong then I will accept any type of legal procedure against me.",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
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

  void getCategory() async {
    if (await DataConnectionChecker().hasConnection) {
      String user_name = await ShareManager.getName();
      String mobile = await ShareManager.getMobile();
      usernameController.text = user_name;
      mobileController.text = mobile;
      setLoding();
      RequestData requestData = await API.categorySelectListAPI();
      setLoding();
      if (requestData.status == 1) {
        for (var i in requestData.result) {
          categoryList.add(Category.fromJSON(i));
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  void getAddress(String selectaddress) async {
    if (selectaddress == "Home Address") {
      address = await ShareManager.getHomeAddress();
    }
    if (selectaddress == "Office Address") {
      // address = await ShareManager.getOfficeAddress();
    }
  }

  Future getImage() async {
    PickedFile? _pickedFile =
        await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (_pickedFile != null) {
        image1 = _pickedFile;
      }
    });
  }

  Future getImage2() async {
    PickedFile? _pickedFile =
        await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (_pickedFile != null) {
        image2 = _pickedFile;
      }
    });
  }

  Future getImage3() async {
    PickedFile? _pickedFile =
        await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (_pickedFile != null) {
        image3 = _pickedFile;
      }
    });
  }

  Widget upLoadData() {
    return SizedBox(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      InkWell(
        onTap: () {
          // getImage();
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
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
      InkWell(
        onTap: () {
          //getImage2();
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
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
      InkWell(
        onTap: () {
          //getImage3();
          _showPicker3(context);
        },
        child: _image3 != null
            ? Container(
                height: 140,
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                child: Image.file(
                  File(_image3!.path),
                  width: 100.0,
                  height: 140.0,
                  fit: BoxFit.fitHeight,
                ))
            : Container(
                height: 140,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
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
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
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
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery2();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
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

  void _showPicker3(context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery3();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera3();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;

    cropImage(image);
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

  static AndroidUiSettings androidUiSettings = AndroidUiSettings(
    toolbarTitle: "Cropper",
    toolbarColor: Colors.deepOrange,
    toolbarWidgetColor: Colors.white,
    initAspectRatio: CropAspectRatioPreset.original,
    lockAspectRatio: false,
  );

  static IOSUiSettings iosUiSettings = IOSUiSettings(
    minimumAspectRatio: 1.0,
  );

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    cropImage(image!);
    /*setState(() {
      _image1 = File(image.path);
    });*/
  }

  _imgFromCamera2() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;

    cropImage2(image);
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

  _imgFromGallery2() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    cropImage2(image!);
  }

  _imgFromCamera3() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;
    cropImage3(image);
  }

  Future<File> cropImage3(XFile file) async {
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
      _image3 = croppedImage;
      setState(() {});
    } else {
      print("Image is not cropped.");
    }
    return croppedImage!;
  }

  _imgFromGallery3() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    cropImage3(image!);
  }

  Widget usernameFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: usernameController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Your Name";
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
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Enter Your Name",
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

  Widget mobileFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: mobileController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Mobile Number";
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
          hintText: "Enter Mobile Number",
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

  Widget productNameFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: prodctnameController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Name of product";
          }
          return null;
        },
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Montserrat-Bold',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Enter Name of product",
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

  Widget productDescFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: prodDesController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Product Description";
          }
          return null;
        },
        maxLines: null,
        keyboardType: TextInputType.multiline,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Montserrat-Bold',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Enter Product Description",
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

  Widget productpriceFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: priceController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Product Cost";
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
          hintText: "Enter Product Cost",
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

  Widget rentpriceFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: rentpriceController,
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
          hintText: "Enter Rent Cost",
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

  Widget availSotckFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: availStockController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Total Stock (In Number)";
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
          hintText: "Enter Total Stock (In Number)",
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

  Widget categoryDropDownMenu(String hint, List<Category> list,
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
            items: list.map((Category val) {
              return new DropdownMenuItem<String>(
                value: val.id,
                child: new Text(
                  val.name,
                  style: TextStyle(
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

  Widget addressDropDownMenu(String hint, List<String> list,
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
          //  color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          /*  boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
          ],*/
          boxShadow: boxShadow,
        ),
        child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
              backgroundColor: MaterialStateProperty.all(Color(0xFF131416)),
              // elevation: MaterialStateProperty.all(3),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              if (await DataConnectionChecker().hasConnection) {
                if (_fbKey.currentState!.validate()) {
                  if (selectedCategory != null &&
                      selectedAddress != null &&
                      selectedType != null) {
                    if (_image1 != null || _image2 != null || _image3 != null) {
                      String user_id = await ShareManager.getUserID();
                      String id = await ShareManager.getID();
                      setLoding();
                      if (_image1 != null) {
                        imagelist.add(
                            await dio.MultipartFile.fromFile(_image1!.path));
                      }
                      if (_image2 != null) {
                        imagelist.add(
                            await dio.MultipartFile.fromFile(_image2!.path));
                      }

                      if (_image3 != null) {
                        imagelist.add(
                            await dio.MultipartFile.fromFile(_image3!.path));
                      }

                      // final token = await getToken();
                      Map<String, dynamic> map = Map();
                      map["token"] = "1234";
                      map["user_id"] = user_id;
                      map["user_name"] = usernameController.text.trim();
                      map["seller_name"] = usernameController.text.trim();
                      map["seller_id"] = id;
                      map["mobile"] = mobileController.text.trim();
                      map["cat_id"] = selectedCategory;
                      map["product_name"] = prodctnameController.text.trim();
                      map["description"] = prodDesController.text.trim();
                      map["type"] = selectedType;
                      map["price"] = priceController.text.trim();
                      map["stock"] = availStockController.text.trim();
                      map["address"] = address;
                      // map["rent_price"] = rentpriceController.text.trim();
                      map["image[]"] = imagelist;
                      final data = await API.addSellAPI(map);
                      if (data.status == 1) {
                        setLoding();
                        Fluttertoast.showToast(msg: data.msg);
                        Get.to(BuySellMainPage(type: widget.type));
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Please Select Images");
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Please Select All Details");
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
