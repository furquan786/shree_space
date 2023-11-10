import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shreegraphic/workprofile.dart';

import 'package:video_player/video_player.dart';
import 'package:orientation/orientation.dart';
import 'dart:io';

import 'Backend/api_request.dart';
import 'Backend/share_manager.dart';
import 'Backend/urls.dart';
import 'Config/enums.dart';
import 'HomeScreen.dart';
import 'Model/my_cat_image_list.dart';
import 'Model/photoslist_model.dart';

class ViewMemVideoui extends StatefulWidget {
  int index;
  final UserType type;
  List<Photosmodel> photolist;
  ViewMemVideoui(
      {this.index = 0, required this.type, this.photolist = const [], Key? key})
      : super(key: key);

  @override
  State<ViewMemVideoui> createState() => _ViewMemVideouiState();
}

class _ViewMemVideouiState extends State<ViewMemVideoui>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
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
                  await API.videoRemoveApi(widget.photolist[widget.index].id);
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

class _HomeholderWidgetState extends State<HomePlaceholderWidget>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool isLoding = false;
  VideoPlayerController? controllerVideo;
  ChewieController? _chewieController;
  ChewieFullscreenToggler? _toggler;
  Floating? floating;
  //final _controller = PageController();
  ScrollController _scrollController = ScrollController();
  final _controller = PageController();
  int get currentIndex => _controller.page!.round();
  AnimationController? _animationController;
  Animation<Rect>? rectAnimation;
  OverlayEntry? transitionOverlayEntry;
  int currentPage = 0;

  Future<ClosedCaptionFile> _loadCaptions() async {
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString('Assets/bumble_bee_captions.vtt');
    return WebVTTCaptionFile(
        fileContents); // For vtt files, use WebVTTCaptionFile
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
    WidgetsBinding.instance.addObserver(this);
    floating = Floating();
    transitionOverlayEntry = _createOverlayEntry();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        transitionOverlayEntry!.remove();
      }
      /*if (status == AnimationStatus.completed) {
        _setPageViewVisible(true);
      } else if (status == AnimationStatus.reverse) {
        _setPageViewVisible(false);
      }*/
    });

    getVideo();
    // _controller.jumpToPage(widget.index);
    // _controller = PageController(initialPage: widget.index);
    // _controller = PageController(initialPage: 2);
    //_showPageView(widget.index);
    print(widget.index);
  }

  void _showPageView(int index) {
    _controller.jumpToPage(index); //<--- set PageView's page
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: rectAnimation!,
          builder: (context, child) {
            return Positioned(
              top: rectAnimation!.value.top,
              left: rectAnimation!.value.left,
              child: Image.network(
                IMG_PATHVIDEO + widget.photolist[widget.index].video,
                fit: BoxFit.scaleDown,
                height: rectAnimation!.value.height,
                width: rectAnimation!.value.width,
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    if (widget.photolist[widget.index].video.contains("mp4")) {
      if (widget.photolist[widget.index].video != null &&
          widget.photolist[widget.index].video.isNotEmpty) {
        WidgetsBinding.instance.removeObserver(_toggler!);
        WidgetsBinding.instance.removeObserver(this);
        controllerVideo!.dispose();
        _chewieController!.dispose();
      }
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    floating!.dispose();
    _animationController!.dispose();
    super.dispose();
  }

  Future<void> enablePip() async {
    final status = await floating!.enable();
    debugPrint('PiP enabled? $status');
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
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
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.photolist.length,
            onPageChanged: (int index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return widget.photolist[widget.index].video.contains("mp4")
                  ? Row(children: [
                      Flexible(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(1)),
                              width: screen.width,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Center(
                                    child: _chewieController != null
                                        ? Chewie(
                                            controller: _chewieController!,
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SpinKitFadingCircle(
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                              height: 210,
                            )
                          ])),
                    ])
                  : Image.network(
                      IMG_PATHIMAGE + widget.photolist[widget.index].image,
                      fit: BoxFit.scaleDown,
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                    );
            },
          ),
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
      ]),
      floatingActionButton: FutureBuilder<bool>(
        future: floating!.isPipAvailable,
        initialData: false,
        builder: (context, snapshot) => snapshot.data!
            ? PiPSwitcher(
                childWhenDisabled: FloatingActionButton.extended(
                  onPressed: enablePip,
                  label: const Text(''),
                  icon: const Icon(Icons.picture_in_picture),
                ),
                childWhenEnabled: const SizedBox(),
              )
            : const Card(
                child: Text('Pip Unavailable'),
              ),
      ),
    );
  }

  void getVideo() async {
    if (widget.photolist[widget.index].video.contains("mp4")) {
      controllerVideo = VideoPlayerController.network(
        /*VID_PATH +*/
        IMG_PATHVIDEO + widget.photolist[widget.index].video /*"/download"*/,
        closedCaptionFile: _loadCaptions(),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await controllerVideo!.initialize();
      controllerVideo!.addListener(() {
        setState(() {});
      });

      _chewieController = ChewieController(
        videoPlayerController: controllerVideo!,
        autoPlay: false,
        looping: true,
        allowFullScreen: true,
        fullScreenByDefault: false,
        autoInitialize: true,
        //aspectRatio: controllerVideo.value.aspectRatio,//
        //  aspectRatio:MediaQuery.of(context).size.width/ MediaQuery.of(context).size.height,

        // deviceOrientationsAfterFullScreen: [],

        routePageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondAnimation, provider) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Container(
                  alignment: Alignment.center,
                  color: Colors.black,
                  child: provider,
                ),
              );
            },
          );
        },
      );

      _toggler = ChewieFullscreenToggler(_chewieController!);
      WidgetsBinding.instance.addObserver(_toggler!);

      _chewieController!.addListener(() {
        if (_chewieController!.isFullScreen && isPortrait) {
          scheduleMicrotask(() {
            OrientationPlugin.forceOrientation(
                DeviceOrientation.landscapeRight);
          });
        } else if (!_chewieController!.isFullScreen && !isPortrait) {
          scheduleMicrotask(() {
            OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
          });
        }
      });
    }
  }
}

class ChewieFullscreenToggler extends WidgetsBindingObserver {
  ChewieFullscreenToggler(this.chewieController)
      : assert(chewieController != null);

  final ChewieController chewieController;

  var _wasPortrait = false;

  @override
  void didChangeMetrics() {
    var _isPortrait = isPortrait;
    if (_isPortrait == _wasPortrait) {
      return;
    }

    _wasPortrait = _isPortrait;
    if (!_isPortrait && !chewieController.isFullScreen) {
      chewieController.enterFullScreen();
    } else if (_isPortrait && chewieController.isFullScreen) {
      chewieController.exitFullScreen();
    }
  }
}

bool get isPortrait {
  var size = WidgetsBinding.instance.window.physicalSize;
  return size.width < size.height;
}
