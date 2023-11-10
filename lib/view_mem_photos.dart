import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shreegraphic/workprofile.dart';
import '../Backend/api_request.dart';
import '../HomeScreen.dart';
import 'Backend/share_manager.dart';
import 'Backend/urls.dart';
import 'Config/enums.dart';
import 'MemTransactionList.dart';
import 'Model/announcement_model.dart';
import 'Model/photoslist_model.dart';
import 'Model/quotation_model.dart';
import 'Model/request_data.dart';

class ViewMembPhotosui extends StatefulWidget {
  int index;
  final UserType type;
  List<Photosmodel> photolist;

  ViewMembPhotosui(
      {this.index = 0, required this.type, this.photolist = const [], Key? key})
      : super(key: key);

  @override
  State<ViewMembPhotosui> createState() => _ViewMembPhotosuiState();
}

class _ViewMembPhotosuiState extends State<ViewMembPhotosui> {
  List _children = [];
  bool _isDrawerOpen = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
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
      HomePlaceholderWidget(widget.type, widget.index, widget.photolist),
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
                padding: const EdgeInsets.only(left: 20.0), child: Text(""))
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () async {
              setLoding();
              final requestData =
                  await API.photosRemoveApi(widget.photolist[widget.index].id);
              setLoding();
              if (requestData.status == 1) {
                Fluttertoast.showToast(msg: requestData.msg);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WorkProfile(type: widget.type)),
                );
              } else {
                Fluttertoast.showToast(msg: requestData.msg);
              }
            },
          ),
        ],
      ),
      body: Stack(children: [
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
    );
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }
}

class HomePlaceholderWidget extends StatefulWidget {
  int index = 0;
  UserType? type;
  List<Photosmodel> photolist = [];

  HomePlaceholderWidget(UserType type, int index, List<Photosmodel> photolist,
      {Key? key})
      : super(key: key) {
    this.type = type;
    this.index = index;
    this.photolist = photolist;
  }

  @override
  State<HomePlaceholderWidget> createState() => _HomeholderWidgetState();
}

class _HomeholderWidgetState extends State<HomePlaceholderWidget> {
  bool isLoding = false;
  List<Photosmodel> photosList = [];
  PageController? _pageController;
  int _currentIndex = 0;

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController = PageController(initialPage: widget.index);
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
        child: /*SingleChildScrollView(
            child:*/
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              Expanded(
                  child: PhotoViewGallery.builder(
                pageController: _pageController,
                scrollPhysics: const BouncingScrollPhysics(),
                itemCount: widget.photolist.length,
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(
                        IMG_PATHIMAGE + widget.photolist[index].image),
                  );
                },
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              )),
              const SizedBox(height: 30),
            ]),
      ),
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
