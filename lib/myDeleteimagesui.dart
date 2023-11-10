import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shreegraphic/view_image_videoui.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:math';
import '../Backend/api_request.dart';
import '../Backend/share_manager.dart';
import '../HomeScreen.dart';
import 'Config/enums.dart';
import 'Model/member_list.dart';
import 'Model/my_cat_image_list.dart';
import 'Model/myfolder_list.dart';
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

class MyDeleteImagesui extends StatefulWidget {
  String index, folderName;
  final UserType type;

  MyDeleteImagesui(
      {this.index = "", this.folderName = "", required this.type, Key? key})
      : super(key: key);

  @override
  State<MyDeleteImagesui> createState() => _MyDeleteImagesuiState();
}

class _MyDeleteImagesuiState extends State<MyDeleteImagesui> {
  bool isLoding = false;
  List<MyCatIamgeListModel> myimageList = [];
  List<MyCatIamgeListModel> selectedList = [];
  var _popupMenuItemIndex = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String codeDialog = "";
  String valueText = "";
  var gridorlist;
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
    final requestData = await API.mydeleteimagesListAPI(user_id);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        myimageList.add(MyCatIamgeListModel.fromJson(i));
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageList();
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
                        child: Text("Delete")))
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
                            child: Text("Delete"),
                          ),
                        ];
                      }, onSelected: (value) {
                        if (value == 0) {
                          List<String> deletelist = [];
                          for (int i = 0; i < selectedList.length; i++) {
                            deletelist.add(selectedList[i].id);
                          }
                          deleteApi(deletelist);
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

  Future<void> deleteApi(List<String> deletelist) async {
    String device_id = await ShareManager.getUserID();
    setLoding();
    final requestData = await API.deleteImageAPI(
      deletelist,
      device_id,
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
}

/* setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }*/

class GridItem extends StatefulWidget {
  int index;
  final Key key;
  final MyCatIamgeListModel item;
  final ValueChanged<bool> isSelected;
  String catindex, foldname;
  final UserType type;
  String codeDialog = "";

  GridItem(
      {required this.index,
      required this.item,
      required this.catindex,
      required this.foldname,
      required this.isSelected,
      required this.type,
      required this.key});

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
        video: /*"https://shreespace.com/upload/devise_image/" +*/
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
                    type: "DELETE")),
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
                                              /*"https://shreespace.com/upload/devise_image/" +*/
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
                                                    //  leading: new Icon(Icons.share),
                                                    title: new Text('Delete'),
                                                    onTap: () {
                                                      Navigator.pop(context);

                                                      if (widget.item.owner
                                                              .toString() ==
                                                          "1") {
                                                        List<String>
                                                            deletelist = [];
                                                        deletelist.add(
                                                            widget.item.id);
                                                        deleteApi(deletelist);
                                                      }
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

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  Future<void> deleteApi(List<String> deletelist) async {
    String device_id = await ShareManager.getUserID();
    setLoding();
    final requestData = await API.deleteImageAPI(
      deletelist,
      device_id,
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
}
