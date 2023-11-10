import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

import '../Backend/api_request.dart';
import '../Backend/share_manager.dart';
import '../HomeScreen.dart';
import 'Config/enums.dart';
import 'Model/myfolder_list.dart';
import 'myAllimagesui.dart';
import 'myCatimagesui.dart';
import 'myDeleteimagesui.dart';
import 'myMoveimagesui.dart';
import 'myShareimagesui.dart';

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

enum Options { name }

class MyImagesui extends StatefulWidget {
//  const MyImagesui({Key key}) : super(key: key);
  final UserType type;

  MyImagesui({required this.type, Key? key}) : super(key: key);

  @override
  State<MyImagesui> createState() => _MyImagesuiState();
}

class _MyImagesuiState extends State<MyImagesui> {
  bool isLoding = false;
  List<MyFolderListModel> myfolderList = [];

  List<MyFolderListModel> selectedList = [];
  var _popupMenuItemIndex = 0;
  var gridorlist;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  List<XFile> imageFileList = [];
  List _document2 = [];
  List imagelist = [];

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  getFolderList() async {
    myfolderList = [];
    setLoding();
    String user_id = await ShareManager.getUserID();
    gridorlist = await ShareManager.getGridorList();
    final requestData = await API.folderListAPI(user_id);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        myfolderList.add(MyFolderListModel.fromJson(i));
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFolderList();
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
                        child: Text("My Images")))
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
                selectedList.length < 1
                    ? PopupMenuButton(itemBuilder: (context) {
                        return [
                          PopupMenuItem<int>(
                            value: 0,
                            child: _buildPopupMenuItem('Create Folder',
                                Icons.folder, Options.name.index),
                          ),
                          PopupMenuItem<int>(
                            value: 1,
                            child: _buildPopupMenuItem(
                                'Upload Photos', Icons.add_circle, 1),
                          )
                        ];
                      }, onSelected: (value) {
                        if (value == 0) {
                          _onMenuItemSelected(value as int);
                        } else if (value == 1) {
                          _onMenuItemSelected3();
                        }
                      })
                    : PopupMenuButton(
                        onSelected: (value) {
                          _onMenuItemSelected2(value as int);
                        },
                        itemBuilder: (ctx) => [
                          _buildPopupMenuItem('Rename Folder', Icons.folder,
                              Options.name.index),
                        ],
                      ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          myfolderList == null
                              ? Center()
                              : myfolderList.isEmpty
                                  ? Container(
                                      width: 90,
                                      height: 90,
                                      margin: EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 0.0,
                                          bottom: 0.0),
                                      decoration: BoxDecoration(
                                        boxShadow: boxShadow,
                                        gradient: const LinearGradient(
                                            begin: FractionalOffset.bottomLeft,
                                            end: FractionalOffset.bottomRight,
                                            transform:
                                                GradientRotation(math.pi / 4),
                                            //stops: [0.4, 1],
                                            colors: [
                                              Color(0xFF131416),
                                              Color(0xFF151619),
                                            ]),
                                        //  boxShadow: boxShadow,
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      padding: const EdgeInsets.all(0),
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Image.asset(
                                                  "Assets/folder.png",
                                                  fit: BoxFit.fitWidth,
                                                )),
                                          ]),
                                    )
                                  : const SizedBox(height: 10),
                          gridorlist == "liston"
                              ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder:
                                        (BuildContext context, int i) {
                                      return const SizedBox(
                                        height: 8,
                                      );
                                    },
                                    itemCount: myfolderList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onLongPress: () {
                                          setState(() {
                                            if (myfolderList[index].id != "0") {
                                              myfolderList[index].selec = true;
                                              selectedList
                                                  .add(myfolderList[index]);
                                            }
                                          });
                                        },
                                        onTap: () {
                                          if (myfolderList[index].folder_name ==
                                              "all") {
                                            Get.to(MyAllImagesui(
                                                index: myfolderList[index]
                                                    .id
                                                    .toString(),
                                                folderName: myfolderList[index]
                                                    .folder_name,
                                                type: widget.type));
                                          } else if (myfolderList[index]
                                                  .folder_name ==
                                              "move") {
                                            Get.to(MyMoveImagesui(
                                                index: myfolderList[index]
                                                    .id
                                                    .toString(),
                                                folderName: myfolderList[index]
                                                    .folder_name,
                                                type: widget.type));
                                          } else if (myfolderList[index]
                                                  .folder_name ==
                                              "share") {
                                            Get.to(MyShareImagesui(
                                                index: myfolderList[index]
                                                    .id
                                                    .toString(),
                                                folderName: myfolderList[index]
                                                    .folder_name,
                                                type: widget.type));
                                          } else if (myfolderList[index]
                                                  .folder_name ==
                                              "delete") {
                                            Get.to(MyDeleteImagesui(
                                                index: myfolderList[index]
                                                    .id
                                                    .toString(),
                                                folderName: myfolderList[index]
                                                    .folder_name,
                                                type: widget.type));
                                          } else {
                                            if (myfolderList[index].selec ==
                                                true) {
                                              setState(() {
                                                myfolderList[index].selec =
                                                    false;
                                                selectedList.remove(
                                                  myfolderList[index],
                                                );
                                              });
                                            } else {
                                              print(
                                                  myfolderList[index].user_id);
                                              Get.to(MyCatImagesui(
                                                  index: myfolderList[index]
                                                      .id
                                                      .toString(),
                                                  folderName:
                                                      myfolderList[index]
                                                          .folder_name,
                                                  user_id: myfolderList[index]
                                                      .user_id,
                                                  type: widget.type));
                                            }
                                          }
                                        },
                                        child: Stack(children: <Widget>[
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 2),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          myfolderList[index]
                                                                      .folder_name ==
                                                                  "share"
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          4),
                                                                  child:
                                                                      Container(
                                                                    height: 80,
                                                                    width: 80,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      boxShadow:
                                                                          boxShadow,
                                                                      gradient: const LinearGradient(
                                                                          begin: FractionalOffset.bottomLeft,
                                                                          end: FractionalOffset.bottomRight,
                                                                          transform: GradientRotation(math.pi / 4),
                                                                          //stops: [0.4, 1],
                                                                          colors: [
                                                                            Color(0xFF131416),
                                                                            Color(0xFF151619),
                                                                          ]),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18.0),
                                                                    ),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Image
                                                                        .asset(
                                                                      "Assets/folder.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                )
                                                              : myfolderList[index]
                                                                          .folder_name ==
                                                                      "move"
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              4),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            80,
                                                                        width:
                                                                            80,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          boxShadow:
                                                                              boxShadow,
                                                                          gradient: const LinearGradient(
                                                                              begin: FractionalOffset.bottomLeft,
                                                                              end: FractionalOffset.bottomRight,
                                                                              transform: GradientRotation(math.pi / 4),
                                                                              //stops: [0.4, 1],
                                                                              colors: [
                                                                                Color(0xFF131416),
                                                                                Color(0xFF151619),
                                                                              ]),
                                                                          borderRadius:
                                                                              BorderRadius.circular(18.0),
                                                                        ),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child: Image
                                                                            .asset(
                                                                          "Assets/folder.png",
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : myfolderList[index]
                                                                              .folder_name ==
                                                                          "delete"
                                                                      ? Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 4),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                80,
                                                                            width:
                                                                                80,
                                                                            decoration:
                                                                                BoxDecoration(
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
                                                                              borderRadius: BorderRadius.circular(18.0),
                                                                            ),
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                Image.asset(
                                                                              "Assets/folder.png",
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : myfolderList[index].share_sel ==
                                                                              "1"
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                                                              child: Container(
                                                                                height: 80,
                                                                                width: 80,
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
                                                                                  borderRadius: BorderRadius.circular(18.0),
                                                                                ),
                                                                                alignment: Alignment.center,
                                                                                child: Image.asset(
                                                                                  "Assets/red_folder.png",
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                                                              child: Container(
                                                                                height: 80,
                                                                                width: 80,
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
                                                                                  borderRadius: BorderRadius.circular(18.0),
                                                                                ),
                                                                                alignment: Alignment.center,
                                                                                child: Image.asset(
                                                                                  "Assets/folder.png",
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ),
                                                          Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      4),
                                                              child: Container(
                                                                  height: 50,
                                                                  width: screen
                                                                          .width *
                                                                      0.58,
                                                                  child: Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Align(
                                                                            alignment:
                                                                                Alignment.bottomLeft,
                                                                            child: Flexible(
                                                                                child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                                                                    child: Text(myfolderList[index].folder_name,
                                                                                        style: const TextStyle(
                                                                                          color: Colors.white,
                                                                                          fontSize: 18,
                                                                                          fontFamily: 'Montserrat-Bold',
                                                                                          fontWeight: FontWeight.w300,
                                                                                          letterSpacing: 1,
                                                                                        )))))
                                                                      ]))),
                                                          myfolderList[index]
                                                                  .selec
                                                              ? Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomRight,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            4),
                                                                    child: Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container()
                                                        ])),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 85),
                                                    child: Divider(
                                                      color: Colors.grey,
                                                    )),
                                              ]),
                                        ]),
                                      );
                                    },
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GridView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: myfolderList.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0,
                                      //mainAxisExtent: 110,
                                      childAspectRatio: 1.0,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onLongPress: () {
                                          setState(() {
                                            if (myfolderList[index].id != "0") {
                                              myfolderList[index].selec = true;
                                              selectedList
                                                  .add(myfolderList[index]);
                                            }
                                          });
                                        },
                                        onTap: () {
                                          if (myfolderList[index].folder_name ==
                                              "all") {
                                            Get.to(MyAllImagesui(
                                                index: myfolderList[index]
                                                    .id
                                                    .toString(),
                                                folderName: myfolderList[index]
                                                    .folder_name,
                                                type: widget.type));
                                          } else if (myfolderList[index]
                                                  .folder_name ==
                                              "move") {
                                            Get.to(MyMoveImagesui(
                                                index: myfolderList[index]
                                                    .id
                                                    .toString(),
                                                folderName: myfolderList[index]
                                                    .folder_name,
                                                type: widget.type));
                                          } else if (myfolderList[index]
                                                  .folder_name ==
                                              "share") {
                                            Get.to(MyShareImagesui(
                                                index: myfolderList[index]
                                                    .id
                                                    .toString(),
                                                folderName: myfolderList[index]
                                                    .folder_name,
                                                type: widget.type));
                                          } else if (myfolderList[index]
                                                  .folder_name ==
                                              "delete") {
                                            Get.to(MyDeleteImagesui(
                                                index: myfolderList[index]
                                                    .id
                                                    .toString(),
                                                folderName: myfolderList[index]
                                                    .folder_name,
                                                type: widget.type));
                                          } else {
                                            if (myfolderList[index].selec ==
                                                true) {
                                              setState(() {
                                                myfolderList[index].selec =
                                                    false;
                                                selectedList.remove(
                                                  myfolderList[index],
                                                );
                                              });
                                            } else {
                                              print(
                                                  myfolderList[index].user_id);
                                              Get.to(MyCatImagesui(
                                                  index: myfolderList[index]
                                                      .id
                                                      .toString(),
                                                  folderName:
                                                      myfolderList[index]
                                                          .folder_name,
                                                  user_id: myfolderList[index]
                                                      .user_id,
                                                  type: widget.type));
                                            }
                                          }
                                        },
                                        child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    myfolderList[index]
                                                                .folder_name ==
                                                            "share"
                                                        ? Expanded(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow:
                                                                    boxShadow,
                                                                gradient:
                                                                    const LinearGradient(
                                                                        begin: FractionalOffset
                                                                            .bottomLeft,
                                                                        end: FractionalOffset
                                                                            .bottomRight,
                                                                        transform:
                                                                            GradientRotation(math.pi /
                                                                                4),
                                                                        //stops: [0.4, 1],
                                                                        colors: [
                                                                      Color(
                                                                          0xFF131416),
                                                                      Color(
                                                                          0xFF151619),
                                                                    ]),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18.0),
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  Image.asset(
                                                                "Assets/folder.png",
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                            ),
                                                          )
                                                        : myfolderList[index]
                                                                    .folder_name ==
                                                                "move"
                                                            ? Expanded(
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    boxShadow:
                                                                        boxShadow,
                                                                    gradient: const LinearGradient(
                                                                        begin: FractionalOffset.bottomLeft,
                                                                        end: FractionalOffset.bottomRight,
                                                                        transform: GradientRotation(math.pi / 4),
                                                                        //stops: [0.4, 1],
                                                                        colors: [
                                                                          Color(
                                                                              0xFF131416),
                                                                          Color(
                                                                              0xFF151619),
                                                                        ]),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18.0),
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Image
                                                                      .asset(
                                                                    "Assets/folder.png",
                                                                    fit: BoxFit
                                                                        .fitWidth,
                                                                  ),
                                                                ),
                                                              )
                                                            : myfolderList[index]
                                                                        .folder_name ==
                                                                    "delete"
                                                                ? Expanded(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        boxShadow:
                                                                            boxShadow,
                                                                        gradient: const LinearGradient(
                                                                            begin: FractionalOffset.bottomLeft,
                                                                            end: FractionalOffset.bottomRight,
                                                                            transform: GradientRotation(math.pi / 4),
                                                                            //stops: [0.4, 1],
                                                                            colors: [
                                                                              Color(0xFF131416),
                                                                              Color(0xFF151619),
                                                                            ]),
                                                                        borderRadius:
                                                                            BorderRadius.circular(18.0),
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Image
                                                                          .asset(
                                                                        "Assets/folder.png",
                                                                        fit: BoxFit
                                                                            .fitWidth,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : myfolderList[index]
                                                                            .share_sel ==
                                                                        "1"
                                                                    ? Expanded(
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            boxShadow:
                                                                                boxShadow,
                                                                            gradient: const LinearGradient(
                                                                                begin: FractionalOffset.bottomLeft,
                                                                                end: FractionalOffset.bottomRight,
                                                                                transform: GradientRotation(math.pi / 4),
                                                                                //stops: [0.4, 1],
                                                                                colors: [
                                                                                  Color(0xFF131416),
                                                                                  Color(0xFF151619),
                                                                                ]),
                                                                            borderRadius:
                                                                                BorderRadius.circular(18.0),
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Image.asset(
                                                                            "Assets/red_folder.png",
                                                                            fit:
                                                                                BoxFit.fitWidth,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Expanded(
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            boxShadow:
                                                                                boxShadow,
                                                                            gradient: const LinearGradient(
                                                                                begin: FractionalOffset.bottomLeft,
                                                                                end: FractionalOffset.bottomRight,
                                                                                transform: GradientRotation(math.pi / 4),
                                                                                //stops: [0.4, 1],
                                                                                colors: [
                                                                                  Color(0xFF131416),
                                                                                  Color(0xFF151619),
                                                                                ]),
                                                                            borderRadius:
                                                                                BorderRadius.circular(18.0),
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Image.asset(
                                                                            "Assets/folder.png",
                                                                            fit:
                                                                                BoxFit.fitWidth,
                                                                          ),
                                                                        ),
                                                                      ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 0),
                                                        child: Text(
                                                            myfolderList[index]
                                                                .folder_name,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Montserrat-Bold',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              letterSpacing: 1,
                                                            ))),
                                                  ]),
                                              myfolderList[index].selec
                                                  ? Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Icon(
                                                          Icons.check_circle,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    )
                                                  : Container()
                                            ]),
                                      );
                                    },
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
    Get.offAll(
      HomeScreen(type: widget.type),
      transition: Transition.rightToLeft,
    );
  }

  _onMenuItemSelected(int value) {
    setState(() {
      _popupMenuItemIndex = value;
    });
    if (value == Options.name.index) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Stack(
                //overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Folder Name";
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
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
                              hintText: "Folder Name *",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Text("Submit"),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                String user_id = await ShareManager.getUserID();
                                setLoding();
                                final requestData = await API.addfolderAPI(
                                    user_id, nameController.text, "0");
                                if (requestData.status == 1) {
                                  setLoding();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyImagesui(type: widget.type)),
                                  );
                                } else {
                                  setLoding();
                                  Fluttertoast.showToast(msg: requestData.msg);
                                }
                                return;
                              } else {
                                print("Unsuccessful");
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  _onMenuItemSelected3() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              //overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Folder Name";
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
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
                            hintText: "Folder Name *",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text("Submit"),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              String user_id = await ShareManager.getUserID();
                              setLoding();
                              final requestData = await API.addfolderAPI(
                                  user_id, nameController.text, "0");
                              if (requestData.status == 1) {
                                setLoding();
                                String id = requestData.result.toString();
                                getUploadPhotos(id);
                              } else {
                                setLoding();
                                Fluttertoast.showToast(msg: requestData.msg);
                              }
                              return;
                            } else {
                              print("Unsuccessful");
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  _onMenuItemSelected2(int value) {
    setState(() {
      _popupMenuItemIndex = value;
    });
    if (value == Options.name.index) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Stack(
                //overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Folder Name";
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
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
                              hintText: "Rename Folder Name *",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Text("Submit"),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                String user_id = await ShareManager.getUserID();
                                setLoding();
                                final requestData = await API.renamefolderAPI(
                                  user_id,
                                  selectedList[0].folder_name,
                                  selectedList[0].id,
                                  nameController.text,
                                );
                                if (requestData.status == 1) {
                                  setLoding();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyImagesui(type: widget.type)),
                                  );
                                } else {
                                  setLoding();
                                  Fluttertoast.showToast(msg: requestData.msg);
                                }
                                return;
                              } else {
                                print("Unsuccessful");
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }
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

  Future<void> getUploadPhotos(String id) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: Stack(
                //overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                          "Upload Photos",
                          style: TextStyle(
                            color: Colors.black,
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
                          children: <Widget>[
                            InkWell(
                                onTap: () {
                                  _showPickermultiple(context, setState);
                                },
                                child: imageFileList.isEmpty &&
                                        _document2.isEmpty
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
                                              MainAxisAlignment.spaceEvenly,
                                          children: const [
                                            Icon(
                                              Icons.add_circle,
                                              size: 60,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "Browse",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    : imageFileList.isNotEmpty &&
                                            _document2.isEmpty
                                        ? Container(
                                            height: 140,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: Text(
                                              "${imageFileList.length.toString()} Selected",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            )))
                                        : imageFileList.isEmpty &&
                                                _document2.isNotEmpty
                                            ? Container(
                                                height: 140,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                    child: Text(
                                                  "${_document2.length.toString()} Selected",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                )))
                                            : SizedBox())
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text("Submit"),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              if (imageFileList.length == 0 &&
                                  _document2.length == 0) {
                                Fluttertoast.showToast(
                                    msg: "Please Upload Image");
                              } else {
                                String user_id = await ShareManager.getUserID();
                                setLoding();
                                if (imageFileList != null) {
                                  for (var i = 0;
                                      i < imageFileList.length;
                                      i++) {
                                    imagelist.add(
                                        await dio.MultipartFile.fromFile(
                                            imageFileList[i].path));
                                  }
                                }
                                if (_document2 != null) {
                                  for (var i = 0; i < _document2.length; i++) {
                                    imagelist.add(
                                        await dio.MultipartFile.fromFile(
                                            _document2[i].path));
                                  }
                                }
                                Map<String, dynamic> map = Map();
                                map["user_id"] = user_id;
                                map["cat_name"] = id;
                                map["photos[]"] = imagelist;
                                final data =
                                    await API.customerIMGUploadAPI(map);
                                if (data.status == 1) {
                                  setLoding();
                                  Fluttertoast.showToast(msg: data.msg);
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeScreen(type: widget.type)),
                                      (route) => false);
                                } else {
                                  setLoding();
                                  Fluttertoast.showToast(msg: data.msg);
                                }
                                return;
                              }
                            } else {
                              print("Unsuccessful");
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  Future<void> _showPickermultiple(context, _setState) async {
    return showModalBottomSheet(
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
                            _imgFromDocument1(_setState);
                            Navigator.of(context).pop();
                          }),
                      ListTile(
                        leading: new Icon(Icons.photo_camera),
                        title: new Text('Camera'),
                        onTap: () {
                          _imgFromCamera1(_setState);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  Future<void> _imgFromDocument1(StateSetter _setState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        allowMultiple: true);
    _setState(() {
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        if (files.isNotEmpty) {
          List file = result.files;
          setState(() {
            _document2 = file;
          });

          print(_document2.length);
        }
      }
    });

    setState(() {});
  }

  Future<void> _imgFromCamera1(StateSetter _setState) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;
    _setState(() {
      if (image != null) {
        imageFileList.add(image);
      }
    });
  }
}

class GridItem2 extends StatefulWidget {
  final Key? key;
  final MyFolderListModel item;
  final ValueChanged<bool> isSelected;

  GridItem2({required this.item, required this.isSelected, this.key});

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem2> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.item.selec = !widget.item.selec;
          widget.isSelected(isSelected);
        });
      },
      child: Stack(
        children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Expanded(
              child: Container(
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
                  borderRadius: BorderRadius.circular(18.0),
                ),
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "Assets/folder.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 0),
                child: Text(widget.item.folder_name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                    ))),
          ]),
          widget.item.selec
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
