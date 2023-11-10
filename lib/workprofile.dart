import 'dart:io';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shreegraphic/view_mem_photos.dart';
import 'package:shreegraphic/view_mem_video.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../Backend/api_request.dart';
import '../HomeScreen.dart';
import '../Model/photoslist_model.dart';
import 'Backend/share_manager.dart';
import 'Backend/urls.dart';
import 'BuySellPage/homecon.dart';
import 'Config/enums.dart';
import 'Model/request_data.dart';

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

class WorkProfile extends StatefulWidget {
  final UserType type;

  WorkProfile({required this.type, Key? key}) : super(key: key);

  @override
  State<WorkProfile> createState() => _WorkProfileState();
}

class _WorkProfileState extends State<WorkProfile>
    with SingleTickerProviderStateMixin {
  bool _isDrawerOpen = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List _children = [];
  int tabindex = 0;
  TabController? tabController;
  int currentIndex = 2;
  bool isLoding = false;
  final HomeCon controller = Get.put(HomeCon());
  List _document2 = [];
  List _document3 = [];
  List<XFile> imageFileList = [];
  List<Photosmodel> photosList = [];
  List<Photosmodel> videoList = [];
  List imagelist = [];
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
    tabController = TabController(vsync: this, length: 2);
    tabController!.addListener(_handleTabSelection);
    _children = [
      Profileui(widget.type),
      Homeui(widget.type),
      HomePlaceholderWidget(widget.type),
      Homeui(widget.type),
      Homeui(widget.type),
    ];
    getMemberPhotos();
    getMemberVideos();
  }

  void getMemberPhotos() async {
    photosList = [];
    if (await DataConnectionChecker().hasConnection) {
      String member_id = await ShareManager.getUserID();
      String mobile = await ShareManager.getMobile();
      print(member_id);
      //  setLoding();
      RequestData requestData =
          await API.workprofileimageList(member_id, mobile);
      // setLoding();
      if (requestData.status == 1) {
        for (var i in requestData.result) {
          photosList.add(Photosmodel.fromJSON(i));
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  void getMemberVideos() async {
    videoList = [];
    if (await DataConnectionChecker().hasConnection) {
      String member_id = await ShareManager.getUserID();
      String mobile = await ShareManager.getMobile();
      print(member_id);
      //  setLoding();
      RequestData requestData =
          await API.workprofilevideoList(member_id, mobile);
      // setLoding();
      if (requestData.status == 1) {
        for (var i in requestData.result) {
          videoList.add(Photosmodel.fromJSON(i));
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          key: _key,
          drawer: DrawerData(context, widget.type),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
                    child: const Text("Work Profile"))
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  if (tabindex == 0) {
                    _showPickermultiple(context);
                  }
                  if (tabindex == 1) {
                    _showPickermultiple2(context);
                  }
                },
              ),
            ],
          ),
          body: Stack(children: [
            Container(
                color: Colors.black,
                width: screen.width,
                height: screen.height,
                child: ContainedTabBarView(
                  tabs: const [
                    Text(
                      'Images',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Videos',
                      textAlign: TextAlign.center,
                    ),
                  ],
                  tabBarProperties: TabBarProperties(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 8.0,
                    ),
                    indicator: ContainerTabIndicator(
                      radius: BorderRadius.circular(16.0),
                      color: Colors.black,
                      borderWidth: 2.0,
                      borderColor: Colors.black,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[400],
                  ),
                  views: [
                    ImagesWidget(type: widget.type),
                    VideosWidget(type: widget.type),
                  ],
                  onChange: (index) => tabindex = index,
                )),
            _children[currentIndex],
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
          ]),
        ));
  }

  void _showPickermultiple(context) {
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
                            _imgFromDocument2();
                            Navigator.of(context).pop();
                            setState(() {});
                          }),
                      ListTile(
                        leading: new Icon(Icons.photo_camera),
                        title: new Text('Camera'),
                        onTap: () {
                          _imgFromCamera2();
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  void _showPickermultiple2(context) {
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
                          title: new Text('Select Video'),
                          onTap: () {
                            _imgFromDocument3();
                            Navigator.of(context).pop();
                            setState(() {});
                          }),
                    ],
                  ),
                ),
              ));
        });
  }

  _imgFromDocument2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpeg', 'jpg'],
        allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      if (file.size >= 5 * 1024 * 1024) {
        // File size exceeds 100 MB, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected Image file exceeds 5 MB limit.'),
          ),
        );
      } else {
        // File is within the size limit, update the selected file
        List<File> files = result.paths.map((path) => File(path!)).toList();
        int photocount = photosList.length;
        int filecount = files.length;
        int finalcount = photocount + filecount;
        if (files.isNotEmpty && finalcount < 11) {
          List file = result.files;
          setState(() {
            if (file != null) {
              _document2 = file;
              callPhotoUploadApi();
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please select a minimum of 10 photos.'),
            ),
          );
        }
      }
    }

    setState(() {});
  }

  _imgFromDocument3() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'mov', 'webm', 'wmv', 'avi', 'mkv'],
        allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      if (file.size >= 100 * 1024 * 1024) {
        // File size exceeds 100 MB, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected video file exceeds 100 MB limit.'),
          ),
        );
      } else {
        VideoPlayerController videoPlayerController =
            VideoPlayerController.file(File(file.path!));

        await videoPlayerController.initialize();
        Duration videoDuration = videoPlayerController.value.duration;

        if (videoDuration.inSeconds >= 60) {
          // Valid video file with a duration of at least 1 minute
          print('Valid video file with a duration of at least 1 minute.');
          List<File> files = result.paths.map((path) => File(path!)).toList();
          int photocount = videoList.length;
          int filecount = files.length;
          int finalcount = photocount + filecount;
          if (files.isNotEmpty && finalcount < 6) {
            List file = result.files;
            setState(() {
              if (file != null) {
                _document3 = file;
                callVideoUploadApi();
              }
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please select a minimum of 5 Videos.'),
              ),
            );
          }
          // You can now use the video file as needed
        } else {
          // File doesn't meet the duration requirement
          print(
              'Please select a video file with a duration of at least 1 minute.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Please select a video file with a duration of at least 1 minute.'),
            ),
          );
        }

        await videoPlayerController.dispose();

        // File is within the size limit, update the selected file
      }
    }

    setState(() {});
  }

  _imgFromCamera2() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image == null) return;
    if (image != null) {
      int photocount = photosList.length;
      int filecount = 1;
      int finalcount = photocount + filecount;
      if (finalcount < 11) {
        setState(() {
          imageFileList.add(image);
          callPhotoUploadApi();
        });
      } else {
        Fluttertoast.showToast(msg: "Please select a minimum of 10 photos.");
      }
    }
  }

  void callPhotoUploadApi() async {
    if (await DataConnectionChecker().hasConnection) {
      if (imageFileList != null) {
        for (var i = 0; i < imageFileList.length; i++) {
          imagelist
              .add(await dio.MultipartFile.fromFile(imageFileList[i].path));
        }
      }
      if (_document2 != null) {
        for (var i = 0; i < _document2.length; i++) {
          imagelist.add(await dio.MultipartFile.fromFile(_document2[i].path));
        }
      }
      setLoding();
      String member_id = await ShareManager.getUserID();
      String mobile = await ShareManager.getMobile();
      Map<String, dynamic> map = Map();
      map["mem_id"] = member_id;
      map["mobile"] = mobile;
      map["photos[]"] = imagelist;
      final data = await API.memphotoUploadAPI(map);
      if (data.status == 1) {
        //setLoding();
        Fluttertoast.showToast(msg: data.msg);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WorkProfile(type: widget.type)),
        );
      } else {
        setLoding();
        Fluttertoast.showToast(msg: data.msg);
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  void callVideoUploadApi() async {
    if (await DataConnectionChecker().hasConnection) {
      if (_document3 != null) {
        for (var i = 0; i < _document3.length; i++) {
          imagelist.add(await dio.MultipartFile.fromFile(_document3[i].path));
        }
      }
      setLoding();
      String member_id = await ShareManager.getUserID();
      String mobile = await ShareManager.getMobile();
      Map<String, dynamic> map = Map();
      map["mem_id"] = member_id;
      map["mobile"] = mobile;
      map["photos[]"] = imagelist;
      final data = await API.memvideoUploadAPI(map);
      if (data.status == 1) {
        //setLoding();
        Fluttertoast.showToast(msg: data.msg);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WorkProfile(type: widget.type)),
        );
      } else {
        setLoding();
        Fluttertoast.showToast(msg: data.msg);
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
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

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(),
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
}

class ImagesWidget extends StatefulWidget {
  UserType type;

  ImagesWidget({required this.type, Key? key}) : super(key: key);

  @override
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
  bool isLoding = false;
  List<Photosmodel> photosList = [];

  void getMemberPhotos() async {
    photosList = [];
    if (await DataConnectionChecker().hasConnection) {
      String member_id = await ShareManager.getUserID();
      String mobile = await ShareManager.getMobile();
      print(member_id);
      setLoding();
      RequestData requestData =
          await API.workprofileimageList(member_id, mobile);
      setLoding();
      if (requestData.status == 1) {
        for (var i in requestData.result) {
          photosList.add(Photosmodel.fromJSON(i));
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMemberPhotos();
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
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  photosList == null
                      ? Center()
                      : photosList.isEmpty
                          ? const Center(
                              child: Text(
                              "No Images are added.",
                              style: TextStyle(color: Colors.white),
                            ))
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: GridView.builder(
                                  itemCount: photosList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.landscape
                                            ? 3
                                            : 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (
                                    context,
                                    index,
                                  ) {
                                    return GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            ViewMembPhotosui(
                                              index: index,
                                              type: widget.type,
                                              photolist: photosList,
                                            ),
                                            transition: Transition.rightToLeft,
                                          );
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          IMG_PATHIMAGE +
                                                              photosList[index]
                                                                  .image),
                                                      fit: BoxFit.cover)),
                                              child: Stack(
                                                  clipBehavior: Clip.none,
                                                  fit: StackFit.expand,
                                                  children: [])),
                                        ));
                                  })),
                  const SizedBox(height: 30),
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
    ]);
  }
}

class VideosWidget extends StatefulWidget {
  UserType type;

  VideosWidget({required this.type, Key? key}) : super(key: key);
  @override
  State<VideosWidget> createState() => _VideosWidgetState();
}

class _VideosWidgetState extends State<VideosWidget> {
  bool isLoding = false;
  List<Photosmodel> photosList = [];
  String? uint8list;

  void getMemberVideos() async {
    photosList = [];
    if (await DataConnectionChecker().hasConnection) {
      String member_id = await ShareManager.getUserID();
      String mobile = await ShareManager.getMobile();
      print(member_id);
      setLoding();
      RequestData requestData =
          await API.workprofilevideoList(member_id, mobile);
      setLoding();
      if (requestData.status == 1) {
        for (var i in requestData.result) {
          photosList.add(Photosmodel.fromJSON(i));
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: "Please Check internet connection");
    }
  }

  Future<void> getVideo(int i) async {
    if (photosList[i].video.contains("mp4")) {
      uint8list = await VideoThumbnail.thumbnailFile(
        video: IMG_PATHVIDEO + photosList[i].video,
        imageFormat: ImageFormat.WEBP,
      );
    }
    print(uint8list);
    setState(() {});
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMemberVideos();
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
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  photosList == null
                      ? Center()
                      : photosList.isEmpty
                          ? const Center(
                              child: Text(
                              "No Videos are added.",
                              style: TextStyle(color: Colors.white),
                            ))
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: GridView.builder(
                                  itemCount: photosList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.landscape
                                            ? 3
                                            : 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (
                                    context,
                                    index,
                                  ) {
                                    getVideo(index);
                                    return GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            ViewMemVideoui(
                                              index: index,
                                              type: widget.type,
                                              photolist: photosList,
                                            ),
                                            transition: Transition.rightToLeft,
                                          );
                                        },
                                        child: Card(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                /* image: DecorationImage(image: NetworkImage(IMG_PATHVIDEO + photosList[index].video),
                                              fit: BoxFit.cover)*/
                                              ),
                                              child: uint8list == null
                                                  ? Center(
                                                      child:
                                                          const CircularProgressIndicator())
                                                  : Image.file(
                                                      File(uint8list!))),
                                        ));
                                  })),
                  const SizedBox(height: 30),
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
    ]);
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  Widget _rowData(String title, String value) {
    return value == null || value == ""
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  ":",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          );
  }
}
