import 'dart:math' as math;
import 'dart:io';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shreegraphic/view_image_videoui.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:math';
import '../Backend/api_request.dart';
import '../Backend/share_manager.dart';
import '../HomeScreen.dart';
import 'Config/enums.dart';
import 'Model/lab_list.dart';
import 'Model/member_list.dart';
import 'Model/my_cat_image_list.dart';
import 'Model/myfolder_list.dart';
import 'Model/request_data.dart';
import 'myCatimagesui.dart';
import 'myimagesui.dart';

final gradiColor = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Colors.black.withOpacity(1),
      Colors.black.withOpacity(1),
      Colors.black.withOpacity(0.9),
      Colors.black.withOpacity(0.6),
      Colors.black.withOpacity(0.5),
      Colors.black.withOpacity(0.3),
      Colors.black.withOpacity(0.2),
      Colors.black.withOpacity(0.1)
    ]);

class MyMoveImagesui extends StatefulWidget {
  String index, folderName;
  final UserType type;

  MyMoveImagesui(
      {this.index = "", this.folderName = "", required this.type, Key? key})
      : super(key: key);

  @override
  State<MyMoveImagesui> createState() => _MyMoveImagesuiState();
}

class _MyMoveImagesuiState extends State<MyMoveImagesui> {
  bool isLoding = false;
  List<MyCatIamgeListModel> myimageList = [];
  List<MyCatIamgeListModel> selectedList = [];
  List<MemberListModel> memberList = [];
  List<LABListModel> labList = [];
  var gridorlist;
  var _popupMenuItemIndex = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String codeDialog = "";
  String valueText = "";
  TextEditingController _textFieldController = TextEditingController();
  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  getImageList() async {
    myimageList = [];
    setLoding();
    String user_id = await ShareManager.getUserID();
    gridorlist = await ShareManager.getGridorList();
    final requestData = await API.mymoveimagesListAPI(user_id);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        myimageList.add(MyCatIamgeListModel.fromJson(i));
      }
      setState(() {});
    }
  }

  getMember() async {
    memberList = [];
    setLoding();
    String user_id = await ShareManager.getUserID();
    final requestData = await API.memberListAPI(user_id);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        memberList.add(MemberListModel.fromJson(i));
      }
      setState(() {});
    }
  }

  getLab() async {
    labList = [];
    setLoding();

    final requestData = await API.labListAPI();
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        labList.add(LABListModel.fromJson(i));
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageList();
    getMember();
    getLab();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          // Handle the back button press here
          // You can perform any logic or conditions before navigating back

          // For example, navigate to the next page if certain conditions are met
          if (shouldNavigateToNextPage()) {
            navigateToNextPage(context);
            return Future.value(false); // Prevent default back navigation
          }

          // Allow default back navigation
          return Future.value(true);
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF131416),
              title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Flexible(
                    child: Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text("Move")))
              ]),
              actions: <Widget>[
                gridorlist != null && gridorlist == "gridon"
                    ? InkWell(
                        onTap: () async {
                          await ShareManager.setGridorList("liston");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyImagesui(type: widget.type)),
                          );
                        },
                        child: Icon(
                          Icons.list_alt_sharp, //grid_on
                          color: Colors.white,
                        ))
                    : gridorlist != null && gridorlist == "liston"
                        ? InkWell(
                            onTap: () async {
                              await ShareManager.setGridorList("gridon");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyImagesui(type: widget.type)),
                              );
                            },
                            child: Icon(
                              Icons.grid_on, //grid_on
                              color: Colors.white,
                            ))
                        : InkWell(
                            onTap: () async {
                              await ShareManager.setGridorList("liston");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyImagesui(type: widget.type)),
                              );
                            },
                            child: Icon(
                              Icons.list_alt_sharp, //grid_on
                              color: Colors.white,
                            )),
                widget.type == UserType.Customer
                    ? PopupMenuButton(
                        // add icon, by default "3 dot" icon
                        // icon: Icon(Icons.book)
                        itemBuilder: (context) {
                        return [
                          PopupMenuItem<int>(
                            value: 0,
                            child: _buildPopupMenuItem('Share', Icons.share, 0),
                          ),
                          PopupMenuItem<int>(
                            value: 1,
                            child: _buildPopupMenuItem(
                                'Move', Icons.move_to_inbox, 1),
                          ),
                          PopupMenuItem<int>(
                            value: 2,
                            child:
                                _buildPopupMenuItem('Delete', Icons.delete, 2),
                          ),
                        ];
                      }, onSelected: (value) {
                        if (value == 0) {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: new Text('Member'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        memberList == null
                                            ? Center()
                                            : memberList.isEmpty
                                                ? Center()
                                                : showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title:
                                                            Text('Member List'),
                                                        content:
                                                            setupshreAlertDialoadContainer(),
                                                      );
                                                    });
                                      },
                                    ),
                                    ListTile(
                                      title: new Text('Customer'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _displayTextInputDialog(context);
                                      },
                                    ),
                                    ListTile(
                                      title: new Text('LAB'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        labList == null
                                            ? Center()
                                            : labList.isEmpty
                                                ? Center()
                                                : showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('LAB List'),
                                                        content:
                                                            labsetupshreAlertDialoadContainer(),
                                                      );
                                                    });
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else if (value == 1) {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: new Text('Member'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        memberList == null
                                            ? Center()
                                            : memberList.isEmpty
                                                ? Center()
                                                : showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title:
                                                            Text('Member List'),
                                                        content:
                                                            setupAlertDialoadContainer(),
                                                      );
                                                    });
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else if (value == 2) {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: new Text('Member'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        getMobileOtp();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      })
                    : PopupMenuButton(
                        // add icon, by default "3 dot" icon
                        // icon: Icon(Icons.book)
                        itemBuilder: (context) {
                          return [];
                        },
                        onSelected: (value) {}),
              ],
            ),
            body: Stack(children: [
              Container(
                  width: screen.width,
                  height: screen.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          myimageList == null
                              ? Center()
                              : myimageList.isEmpty
                                  ? Center()
                                  : const SizedBox(height: 10),
                          Flexible(
                            child: Padding(
                              //padding: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext context, int i) {
                                    return const SizedBox(
                                      height: 8,
                                    );
                                  },
                                  itemCount: myimageList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                        onTap: () {},
                                        child: GridItem(
                                          index: index,
                                          item: myimageList[index],
                                          memberList: memberList,
                                          labList: labList,
                                          catindex: widget.index,
                                          foldname: widget.folderName,
                                          isSelected: (bool value) {
                                            setState(() {
                                              if (value) {
                                                selectedList
                                                    .add(myimageList[index]);
                                              } else {
                                                selectedList
                                                    .remove(myimageList[index]);
                                              }
                                            });
                                            print("$index : $value");
                                          },
                                          type: widget.type,
                                          key: Key(
                                              myimageList[index].id.toString()),
                                        ));
                                  }),
                            ),
                          )
                        ]),
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
            ])));
  }

  bool shouldNavigateToNextPage() {
    // Implement your logic here to determine if the next page should be navigated to
    // Return true if conditions are met, false otherwise
    return true;
  }

  Future<void> navigateToNextPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyImagesui(type: widget.type)),
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          Text(title),
        ],
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Unique ID'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: "Enter Unique ID"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    print(codeDialog);
                    Navigator.pop(context);
                    List<String> sharelist = [];
                    for (int i = 0; i < selectedList.length; i++) {
                      sharelist.add(selectedList[i].id);
                    }
                    shareApi(codeDialog, sharelist);
                  });
                },
              ),
            ],
          );
        });
  }

  void getMobileOtp() async {
    if (await DataConnectionChecker().hasConnection) {
      setLoding();
      String mobile = await ShareManager.getMobile();
      RequestData requestData = await API.getdeleteotpdetailAPI(mobile);
      setLoding();
      if (requestData.status == 1) {
        Fluttertoast.showToast(msg: requestData.msg);
        _displaydeleteTextInputDialog(context);
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  Future<void> _displaydeleteTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter OTP'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter OTP"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    print(codeDialog);
                    Navigator.pop(context);

                    getData(codeDialog);
                  });
                },
              ),
            ],
          );
        });
  }

  void getData(String codeDialog) async {
    if (await DataConnectionChecker().hasConnection) {
      setLoding();
      String mobile = await ShareManager.getMobile();
      RequestData requestData =
          await API.getdeleteotpverifydetailAPI(mobile, codeDialog);
      setLoding();
      if (requestData.status == 1) {
        Fluttertoast.showToast(msg: requestData.msg);
        List<String> deletelist = [];
        for (int i = 0; i < selectedList.length; i++) {
          deletelist.add(selectedList[i].id);
        }
        deleteApi(deletelist);
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  Widget setupAlertDialoadContainer() {
    return SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: memberList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(memberList[index].name),
                onTap: () {
                  List<String> movelist = [];
                  for (int i = 0; i < selectedList.length; i++) {
                    movelist.add(selectedList[i].id);
                  }
                  moveApi(memberList[index].id, movelist);
                },
              );
            },
          ),
        ])));
  }

  Widget labsetupshreAlertDialoadContainer() {
    return SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: labList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(labList[index].name),
                onTap: () {
                  addlabshareApi(labList[index].lab_id, labList[index].name,
                      labList[index].mobile, selectedList.length.toString());
                },
              );
            },
          ),
        ])));
  }

  Widget setupshreAlertDialoadContainer() {
    return SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: memberList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(memberList[index].name),
                onTap: () {
                  List<String> sharelist = [];
                  for (int i = 0; i < selectedList.length; i++) {
                    sharelist.add(selectedList[i].id);
                  }
                  shareApi(memberList[index].id, sharelist);
                },
              );
            },
          ),
        ])));
  }

  Future<void> addlabshareApi(
      String lab_id, String lab_name, String lan_number, String count) async {
    setLoding();
    String member_id = await ShareManager.getUserID();
    String member_name = await ShareManager.getName();
    final requestData = await API.labaddworkAPI(
        lab_id, lab_name, lan_number, member_id, member_name, count);
    if (requestData.status == 1) {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
      List<String> sharelist = [];
      for (int i = 0; i < selectedList.length; i++) {
        sharelist.add(selectedList[i].id);
      }
      shareApi(lab_id, sharelist);
    } else {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
    }
  }

  Future<void> shareApi(String div_id, List<String> sharelist) async {
    setLoding();
    final requestData = await API.shareImageAPI(
      sharelist,
      div_id,
    );
    if (requestData.status == 1) {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen(type: widget.type)),
          (route) => false);
    } else {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
    }
  }

  Future<void> moveApi(String div_id, List<String> movelist) async {
    String cdiv_id = await ShareManager.getUserID();
    setLoding();
    final requestData = await API.moveImageAPI(movelist, div_id, cdiv_id);
    if (requestData.status == 1) {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen(type: widget.type)),
          (route) => false);
    } else {
      setLoding();
      Fluttertoast.showToast(msg: "Images Moved");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen(type: widget.type)),
          (route) => false);
    }
  }

  Future<void> deleteApi(List<String> deletelist) async {
    String device_id = await ShareManager.getUserID();
    setLoding();
    final requestData = await API.tempdeleteImageAPI(
      deletelist,
    );
    if (requestData.status == 1) {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen(type: widget.type)),
          (route) => false);
    } else {
      setLoding();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen(type: widget.type)),
          (route) => false);
    }
  }
}

/* setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }*/

class GridItem extends StatefulWidget {
  int index;
  final Key? key;
  final MyCatIamgeListModel item;
  final ValueChanged<bool> isSelected;
  List<MemberListModel> memberList;
  List<LABListModel> labList = [];
  String catindex, foldname;
  final UserType type;
  String codeDialog = "";

  GridItem(
      {required this.index,
      required this.item,
      required this.memberList,
      required this.labList,
      required this.catindex,
      required this.foldname,
      required this.isSelected,
      required this.type,
      this.key});

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isSelected = false;
  bool isLoding = false;
  String? uint8list;
  String codeDialog = "";
  String valueText = "";
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideo();
  }

  Future<void> getVideo() async {
    if (widget.item.nurl.contains("mp4")) {
      uint8list = await VideoThumbnail.thumbnailFile(
        video: /*"https://shreespace.com/shreegraphic1/upload/devise_image/" +*/
            widget.item.nurl,
        imageFormat: ImageFormat.WEBP,
      );
    }
    print(uint8list);
    setState(() {});
  }

  static String getFileSizeString(int bytes, {int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return InkWell(
      onTap: () async {
        String user_ID = await ShareManager.getUserID();
        if (isSelected == true) {
          setState(() {
            isSelected = !isSelected;
            widget.isSelected(!isSelected);
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewImageVideoui(
                    index: widget.index,
                    catindex: widget.catindex,
                    folderName: widget.foldname,
                    user_ID: user_ID,
                    image: widget.item.nurl,
                    type: "MOVE")),
          );
        }
      },
      onLongPress: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Stack(
        children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Container(
                                height: 50,
                                width: 50,
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
                                  //  boxShadow: boxShadow,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: widget.item.nurl.contains("mp4")
                                    ? uint8list == null
                                        ? Center(
                                            child:
                                                const CircularProgressIndicator())
                                        : Image.file(File(uint8list!))
                                    : Hero(
                                        tag: "image${widget.item.id}",
                                        child: FadeInImage.assetNetwork(
                                          placeholder: "Assets/picture.png",
                                          image:
                                              /*"https://shreespace.com/shreegraphic1/upload/devise_image/" +*/
                                              widget.item.nurl,
                                          // width: screen.width,
                                          fit: BoxFit.cover,
                                          //height: screen.height,
                                        ))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Container(
                              height: 50,
                              width: screen.width * 0.58,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Text(
                                              widget.item.image_name.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Montserrat-Bold',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)))),
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Text(
                                              getFileSizeString(int.parse(
                                                  widget.item.img_size)),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: 'Montserrat-Bold',
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white)))),
                                ],
                              ),
                            ),
                          ),
                          isSelected
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    widget.type == UserType.Customer
                                        ? showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    leading:
                                                        new Icon(Icons.share),
                                                    title: new Text('Share'),
                                                    onTap: () {
                                                      Navigator.pop(context);

                                                      if (widget.item.owner
                                                              .toString() ==
                                                          "1") {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            builder: (context) {
                                                              return Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <Widget>[
                                                                  ListTile(
                                                                    title: new Text(
                                                                        'Member'),
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      widget.memberList ==
                                                                              null
                                                                          ? Center()
                                                                          : widget.memberList.isEmpty
                                                                              ? Center()
                                                                              : showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      title: Text('Member List'),
                                                                                      content: setupshreAlertDialoadContainer(),
                                                                                    );
                                                                                  });
                                                                    },
                                                                  ),
                                                                  ListTile(
                                                                    title: new Text(
                                                                        'Customer'),
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      _displayTextInputDialog(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  ListTile(
                                                                    title: new Text(
                                                                        'LAB'),
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      widget.labList ==
                                                                              null
                                                                          ? Center()
                                                                          : widget.labList.isEmpty
                                                                              ? Center()
                                                                              : showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      title: Text('LAB List'),
                                                                                      content: labsetupshreAlertDialoadContainer(),
                                                                                    );
                                                                                  });
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      }
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: new Icon(
                                                        Icons.move_to_inbox),
                                                    title: new Text('Move'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <Widget>[
                                                                ListTile(
                                                                  title: new Text(
                                                                      'Member'),
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    widget.memberList ==
                                                                            null
                                                                        ? Center()
                                                                        : widget.memberList.isEmpty
                                                                            ? Center()
                                                                            : showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    title: Text('Member List'),
                                                                                    content: setupAlertDialoadContainer(),
                                                                                  );
                                                                                });
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading:
                                                        new Icon(Icons.delete),
                                                    title: new Text('Delete'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <Widget>[
                                                                ListTile(
                                                                  title: new Text(
                                                                      'Member'),
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    getMobileOtp();
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    },
                                                  ),
                                                ],
                                              );
                                            })
                                        : SizedBox();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                        ]))),
            Padding(
                padding: const EdgeInsets.only(left: 65),
                child: Divider(
                  color: Colors.grey,
                )),
          ]),
        ],
      ),
    );
  }

  void getMobileOtp() async {
    if (await DataConnectionChecker().hasConnection) {
      setLoding();
      String mobile = await ShareManager.getMobile();
      RequestData requestData = await API.getdeleteotpdetailAPI(mobile);
      setLoding();
      if (requestData.status == 1) {
        Fluttertoast.showToast(msg: requestData.msg);
        _displaydeleteTextInputDialog(context);
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  Future<void> _displaydeleteTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter OTP'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter OTP"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    print(codeDialog);
                    Navigator.pop(context);

                    getData(codeDialog);
                  });
                },
              ),
            ],
          );
        });
  }

  void getData(String codeDialog) async {
    if (await DataConnectionChecker().hasConnection) {
      setLoding();
      String mobile = await ShareManager.getMobile();
      RequestData requestData =
          await API.getdeleteotpverifydetailAPI(mobile, codeDialog);
      setLoding();
      if (requestData.status == 1) {
        Fluttertoast.showToast(msg: requestData.msg);
        List<String> deletelist = [];
        deletelist.add(widget.item.id);
        deleteApi(deletelist);
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Unique ID'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: "Enter Unique ID"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    print(codeDialog);
                    Navigator.pop(context);
                    List<String> sharelist = [];
                    sharelist.add(widget.item.id);
                    shareApi(codeDialog, sharelist);
                  });
                },
              ),
            ],
          );
        });
  }

  Widget setupAlertDialoadContainer() {
    return SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.memberList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(widget.memberList[index].name),
                onTap: () {
                  List<String> movelist = [];
                  movelist.add(widget.item.id);
                  /*for (int i = 0; i < selectedList.length; i++) {
                    movelist.add(selectedList[i].id);
                  }*/
                  moveApi(widget.memberList[index].id, movelist);
                },
              );
            },
          ),
        ])));
  }

  Widget labsetupshreAlertDialoadContainer() {
    return SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.labList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(widget.labList[index].name),
                onTap: () {
                  addlabshareApi(
                      widget.labList[index].lab_id,
                      widget.labList[index].name,
                      widget.labList[index].mobile,
                      "1");
                },
              );
            },
          ),
        ])));
  }

  Widget setupshreAlertDialoadContainer() {
    return SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.memberList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(widget.memberList[index].name),
                onTap: () {
                  List<String> sharelist = [];
                  sharelist.add(widget.item.id);
                  shareApi(widget.memberList[index].id, sharelist);
                },
              );
            },
          ),
        ])));
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  Future<void> addlabshareApi(
      String lab_id, String lab_name, String lan_number, String count) async {
    setLoding();
    String member_id = await ShareManager.getUserID();
    String member_name = await ShareManager.getName();
    final requestData = await API.labaddworkAPI(
        lab_id, lab_name, lan_number, member_id, member_name, count);
    if (requestData.status == 1) {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
      List<String> sharelist = [];
      sharelist.add(widget.item.id);
      shareApi(lab_id, sharelist);
    } else {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
    }
  }

  Future<void> shareApi(String div_id, List<String> sharelist) async {
    setLoding();
    final requestData = await API.shareImageAPI(
      sharelist,
      div_id,
    );
    if (requestData.status == 1) {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen(type: widget.type)),
          (route) => false);
    } else {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
    }
  }

  Future<void> moveApi(String div_id, List<String> movelist) async {
    String cdiv_id = await ShareManager.getUserID();
    setLoding();
    final requestData = await API.moveImageAPI(movelist, div_id, cdiv_id);
    if (requestData.status == 1) {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen(type: widget.type)),
          (route) => false);
    } else {
      setLoding();
      Fluttertoast.showToast(msg: "Images Moved");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen(type: widget.type)),
          (route) => false);
    }
  }

  Future<void> deleteApi(List<String> deletelist) async {
    String device_id = await ShareManager.getUserID();
    setLoding();
    final requestData = await API.tempdeleteImageAPI(
      deletelist,
    );
    if (requestData.status == 1) {
      setLoding();
      Fluttertoast.showToast(msg: requestData.msg);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen(type: widget.type)),
          (route) => false);
    } else {
      setLoding();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen(type: widget.type)),
          (route) => false);
    }
  }
}
