import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:video_player/video_player.dart';
import 'package:orientation/orientation.dart';
import 'dart:io';

import 'Backend/api_request.dart';
import 'Backend/share_manager.dart';
import 'Backend/urls.dart';
import 'Model/my_cat_image_list.dart';

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

class ViewImageVideoui extends StatefulWidget {
  String catindex, image, folderName, user_ID, type;
  int index;
  ViewImageVideoui(
      {this.index = 0,
      this.catindex = "",
      this.folderName = "",
      this.user_ID = "",
      this.image = "",
      this.type = "",
      Key? key})
      : super(key: key);

  @override
  State<ViewImageVideoui> createState() => _ViewImageVideouiState();
}

class _ViewImageVideouiState extends State<ViewImageVideoui>
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
  List<MyCatIamgeListModel> myimageList = [];
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

  getAllImageList() async {
    myimageList = [];
    setLoding();
    String user_id = await ShareManager.getUserID();
    final requestData = await API.myallimagesListAPI(user_id);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        myimageList.add(MyCatIamgeListModel.fromJson(i));
      }
      setState(() {});
    }
  }

  getCatImageList() async {
    myimageList = [];
    setLoding();
    final requestData = await API.mycatimageListAPI(
        widget.user_ID, widget.catindex, widget.folderName);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        myimageList.add(MyCatIamgeListModel.fromJson(i));
      }
      setState(() {});
    }
  }

  getMoveImageList() async {
    myimageList = [];
    setLoding();
    String user_id = await ShareManager.getUserID();
    final requestData = await API.mymoveimagesListAPI(user_id);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        myimageList.add(MyCatIamgeListModel.fromJson(i));
      }
      setState(() {});
    }
  }

  getShareImageList() async {
    myimageList = [];
    setLoding();
    String user_id = await ShareManager.getUserID();
    final requestData = await API.myshareimagesListAPI(user_id);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        myimageList.add(MyCatIamgeListModel.fromJson(i));
      }
      setState(() {});
    }
  }

  getDeleteImageList() async {
    myimageList = [];
    setLoding();
    String user_id = await ShareManager.getUserID();
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
    if (widget.type == "ALL") {
      getAllImageList();
    } else if (widget.type == "CAT") {
      getCatImageList();
    } else if (widget.type == "MOVE") {
      getMoveImageList();
    } else if (widget.type == "SHARE") {
      getShareImageList();
    } else if (widget.type == "DELETE") {
      getDeleteImageList();
    }

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
                myimageList[currentIndex].nurl,
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
    if (widget.image.contains("mp4")) {
      if (widget.image != null && widget.image.isNotEmpty) {
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
            itemCount: myimageList.length,
            onPageChanged: (int index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return myimageList[index].nurl.contains("mp4")
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
                      myimageList[index].nurl,
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
    if (widget.image.contains("mp4")) {
      controllerVideo = VideoPlayerController.network(
        /*VID_PATH +*/
        widget.image /*"/download"*/,
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
