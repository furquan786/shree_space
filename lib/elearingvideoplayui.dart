import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';
import 'package:orientation/orientation.dart';
import 'dart:io';

import 'Config/enums.dart';

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

class ElearningVideoPlayui extends StatefulWidget {
  String video;
  UserType type;
  ElearningVideoPlayui({required this.type, this.video = "", Key? key})
      : super(key: key);

  @override
  State<ElearningVideoPlayui> createState() => _ElearningVideoPlayuiState();
}

class _ElearningVideoPlayuiState extends State<ElearningVideoPlayui>
    with WidgetsBindingObserver {
  bool isLoding = false;
  late VideoPlayerController controllerVideo;
  late ChewieController _chewieController;
  late ChewieFullscreenToggler _toggler;
  late Floating floating;
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
    getVideo();
  }

  @override
  void dispose() {
    if (widget.video.contains("mp4")) {
      if (widget.video != null && widget.video.isNotEmpty) {
        WidgetsBinding.instance.removeObserver(_toggler);
        WidgetsBinding.instance.removeObserver(this);
        controllerVideo.dispose();
        _chewieController.dispose();
        floating.dispose();
      }
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    super.dispose();
  }

  Future<void> enablePip() async {
    final status = await floating.enable();
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
          child: widget.video.contains("mp4")
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
                                        controller: _chewieController,
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
                  "https://shreespace.com/upload/videos/" + widget.video,
                  fit: BoxFit.scaleDown,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
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
        future: floating.isPipAvailable,
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
    if (widget.video.contains("mp4")) {
      controllerVideo = VideoPlayerController.network(
        /*VID_PATH +*/
        "https://shreespace.com/upload/videos/" + widget.video /*"/download"*/,
        closedCaptionFile: _loadCaptions(),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await controllerVideo.initialize();
      controllerVideo.addListener(() {
        setState(() {});
      });

      _chewieController = ChewieController(
        videoPlayerController: controllerVideo,
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

      _toggler = ChewieFullscreenToggler(_chewieController);
      WidgetsBinding.instance.addObserver(_toggler);

      _chewieController.addListener(() {
        if (_chewieController.isFullScreen && isPortrait) {
          scheduleMicrotask(() {
            OrientationPlugin.forceOrientation(
                DeviceOrientation.landscapeRight);
          });
        } else if (!_chewieController.isFullScreen && !isPortrait) {
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
