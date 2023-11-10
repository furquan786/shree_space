import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

import 'Backend/api_request.dart';
import 'Backend/urls.dart';
import 'Config/enums.dart';
import 'ELearningVideoList.dart';
import 'HomeScreen.dart';
import 'Model/elarningcategory.dart';

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

class ELearningCategory extends StatefulWidget {
  // const MyAnnouncement({Key key}) : super(key: key);
  final UserType type;

  ELearningCategory({required this.type, Key? key}) : super(key: key);

  @override
  State<ELearningCategory> createState() => _ELearningCategoryuiState();
}

class _ELearningCategoryuiState extends State<ELearningCategory> {
  bool _isDrawerOpen = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List _children = [];

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
      HomePlaceholderWidget(widget.type),
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
                padding: const EdgeInsets.only(left: 20.0),
                child: const Text("E-Learning"))
          ],
        ),
      ),
      body: _children[currentIndex],
    );
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
  List<ELearningCat> caList = [];

  getLocationList() async {
    caList = [];
    //String user_id = await ShareManager.getUserID();
    setLoding();
    final requestData = await API.elearningcatListAPI();
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        caList.add(ELearningCat.fromJson(i));
      }
      setState(() {});
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
    getLocationList();
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
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  caList == null
                      ? Center()
                      : caList.isEmpty
                          ? Center(
                              child: Text(
                              "No Data Found",
                              style: TextStyle(color: Colors.white),
                            ))
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GridView.count(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      primary: false,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: caList
                                          .map((item) => GestureDetector(
                                              onTap: () {
                                                Get.to(ELearningVideoListui(
                                                    index: item.id.toString(),
                                                    type: widget.type!));
                                              },
                                              child: Card(
                                                color: Colors.transparent,
                                                elevation: 0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              IMG_PATH1 +
                                                                  item.image),
                                                          fit: BoxFit.cover)),
                                                ),
                                              )))
                                          .toList(),

                                      /*itemCount: caList.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14.0,
                              mainAxisSpacing: 14.0,
                              mainAxisExtent: 120,
                            ),
                            itemBuilder:
                                (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(ELearningVideoListui(
                                      index: caList[index]
                                          .id
                                          .toString(),
                                      type: widget.type));
                                },
                                child: Stack(children: [
                                  Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment
                                                .bottomCenter,
                                            child: Card(
                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                              ),
                                              elevation: 5,
                                              child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      10.0),
                                                  child:
                                                  CachedNetworkImage(
                                                    imageUrl: IMG_PATH1 +
                                                        caList[
                                                        index]
                                                            .image,
                                                    imageBuilder:
                                                        (context,
                                                        imageProvider) =>
                                                        Container(
                                                          width: screen
                                                              .width,
                                                          decoration:
                                                          BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            image:
                                                            DecorationImage(
                                                              image:
                                                              imageProvider,
                                                              fit: BoxFit
                                                                  .fill,
                                                            ),
                                                          ),
                                                        ),
                                                    placeholder: (context,
                                                        url) =>
                                                    const CircleAvatar(
                                                      backgroundColor:
                                                      Colors
                                                          .black,
                                                      radius: 100,
                                                    ),
                                                    errorWidget: (context,
                                                        url,
                                                        error) =>
                                                        Icon(Icons
                                                            .error),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ]),
                                  Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(4.0),child:Container(
                                        alignment: Alignment.bottomLeft,
                                        //width: screen.width,
                                        height: 28,
                                        decoration: BoxDecoration(
                                            gradient: gradiColor,
                                            borderRadius:
                                            const BorderRadius.only(
                                              bottomLeft:
                                              Radius.circular(10),
                                              bottomRight:
                                              Radius.circular(10),
                                            )),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 8, bottom: 5),
                                          child: Text(
                                              caList[index]
                                                  .name ==
                                                  null
                                                  ? " "
                                                  : caList[
                                              index]
                                                  .name,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight
                                                      .w900,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      )),
                                ]),
                              );
                            },*/
                                    ),
                                  ]),
                            ),
                  /*Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext context, int i) {
                                    return const SizedBox(
                                      height: 8,
                                    );
                                  },
                                  itemCount: caList.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(ELearningVideoListui(
                                            index: caList[i]
                                                .id
                                                .toString(),
                                            type: widget.type));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: boxShadow,
                                            gradient: const LinearGradient(
                                                begin:
                                                    FractionalOffset.bottomLeft,
                                                end: FractionalOffset
                                                    .bottomRight,
                                                transform: GradientRotation(
                                                    math.pi / 4),
                                                //stops: [0.4, 1],
                                                colors: [
                                                  Color(0xFF131416),
                                                  Color(0xFF151619),
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 4),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.8,
                                                        vertical: 5.8),
                                                    child: _rowData(
                                                        _parseHtmlString(
                                                            caList[i]
                                                                .name))),
                                              ]),
                                        ),
                                      ),
                                    );
                                  }),
                            ),*/
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

  Widget _rowData(String value) {
    return value == null || value == ""
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Row(
              children: [
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
