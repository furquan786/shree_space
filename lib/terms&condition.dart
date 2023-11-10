import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:shreegraphic/invoiceDetail.dart';
import 'package:shreegraphic/quotationDetailui.dart';
import 'Backend/api_request.dart';
import 'Backend/share_manager.dart';
import 'Config/enums.dart';
import 'HomeScreen.dart';
import 'ITRScreen.dart';
import 'Model/invoiceList_model.dart';
import 'Model/paymentReceiptModel.dart';
import 'Model/quotation_model.dart';
import 'addQuotationBook.dart';

class TermsAndConditionui extends StatefulWidget {
  final UserType type;

  TermsAndConditionui({required this.type, Key? key}) : super(key: key);

  @override
  State<TermsAndConditionui> createState() => _TermsAndConditionuiState();
}

class _TermsAndConditionuiState extends State<TermsAndConditionui> {
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
              backgroundColor: const Color(0xFF131416),
              child: Image.asset(
                "Assets/home.png",
                fit: BoxFit.fitHeight,
              )),
          bottomNavigationBar: BottomAppBar(
            clipBehavior: Clip.antiAlias,
            shape: const CircularNotchedRectangle(),
            notchMargin: 4,
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFF131416),
              selectedItemColor: const Color(0xFF131416),
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
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: ""),
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
            backgroundColor: const Color(0xFF131416),
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
                    child: const Text("Terms & Condition"))
              ],
            ),
          ),
          body: _children[currentIndex],
        ));
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
  TextEditingController termsController = TextEditingController();
  List<PaymentReceiptModel> paymentReceiptList = [];
  var startdate, enddate;
  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  getTermsandCond() async {
    try {
      String user_id = await ShareManager.getUserID();
      setLoding();
      var response = await API.getTermsAndCondt(user_id);
      if (response.status == 1) {
        termsController.text = response.result[0]["terms"];
        print(" old terms and cond is = " + termsController.text);
        setLoding();
      } else {
        setLoding();
      }
    } catch (e) {
      setLoding();
    } catch (e) {}
  }

  updateTermsandCond() async {
    try {
      String user_id = await ShareManager.getUserID();
      setLoding();
      var response =
          await API.updateTermsAndCondt(user_id, termsController.text);
      if (response.status == 1) {
        setLoding();
        Fluttertoast.showToast(msg: response.msg);
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: response.msg);
        setLoding();
      }
    } catch (e) {
      setLoding();
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    getTermsandCond();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Stack(children: [
      Container(
          width: screen.width,
          height: screen.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
          ),
          // color: Colors.black87,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 108),
                    child: Container(
                      height: 340,
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
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            // padding: EdgeInsets.all(20)
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 30),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              controller: termsController,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200),
                              maxLines: 10,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Terms & Condition",
                                  hintStyle: TextStyle(
                                    color: Colors.blueGrey,
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: 20, top: 20, right: 20)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              onTap: () {
                                if (termsController.text.isNotEmpty) {
                                  updateTermsandCond();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please enter terms & condition");
                                }
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 30, top: 40),
                                height: 50,
                                width: 180,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(0.6),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
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
