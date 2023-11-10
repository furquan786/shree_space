import 'dart:math' as math;

import 'package:airpay_flutter_package/airpay_package.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:shreegraphic/generatePaymentReceipt.dart';
import 'package:shreegraphic/quotationItemDetailui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Backend/api_request.dart';
import '../HomeScreen.dart';
import 'Config/enums.dart';
import 'Model/QuotationModel.dart';
import 'Model/announcement_model.dart';
import 'Model/invoiceList_model.dart';
import 'Model/plansListModel.dart';
import 'Model/quotation_model.dart';
import 'QuotationListScreen.dart';
import 'editQuotationBook.dart';
import 'invoiceUpdateQuotationBook.dart';

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

class PackageScreenui extends StatefulWidget {
  String index;
  final UserType type;

  PackageScreenui({this.index = "", required this.type, Key? key})
      : super(key: key);

  @override
  State<PackageScreenui> createState() => _PackageScreenuiState();
}

class _PackageScreenuiState extends State<PackageScreenui> {
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
    print("i got called");
    _children = [
      Profileui(widget.type),
      Homeui(widget.type),
      HomePlaceholderWidget(widget.type, widget.index),
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
                    child: const Text("PLANS"))
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
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QuotationListScreen(type: widget.type)),
    );
  }
}

class HomePlaceholderWidget extends StatefulWidget {
  String index = "";
  UserType? type;

  HomePlaceholderWidget(UserType type, String index, {Key? key})
      : super(key: key) {
    this.type = type;
    this.index = index;
  }

  @override
  State<HomePlaceholderWidget> createState() => _HomeholderWidgetState();
}

class _HomeholderWidgetState extends State<HomePlaceholderWidget> {
  bool isLoding = false;
  List<PlansListModel> plansList = [];

  UserRequest user = UserRequest();

  onComplete(status, response) {
    var resp = response.toJson();
    print(resp);
    var txtStsMsg = resp['STATUSMSG'] ?? "";
    var txtSts = resp['TRANSACTIONSTATUS'] ?? "";
    Navigator.pop(context);
    if (txtStsMsg == '') {
      txtStsMsg = response['STATUSMSG'] ?? "";
      txtSts = response['TRANSACTIONSTATUS'] ?? "";
    }
    if (txtStsMsg == 'Invalid Checksum') {
      // txtStsMsg = "Transaction Canceled";
    }

    var transid = resp['MERCHANTTRANSACTIONID'] ?? "";
    var apTransactionID = resp['TRANSACTIONID'] ?? "";
    var amount = resp['TRANSACTIONAMT'] ?? "";
    var transtatus = resp['TRANSACTIONSTATUS'] ?? "";
    var message = resp['STATUSMSG'] ?? "";
    var customer_vpa = "";
    var customer_fvpa = "";
    var chmode = resp['CHMOD'] ?? "";
    var secureHash = resp['AP_SECUREHASH'] ?? "";

    //(!TextUtils.isEmpty(transaction.getChMode()) && transaction.getChMode().equalsIgnoreCase("upi")){
    if (!chmode.toString().isEmpty && chmode.toString() == "upi") {
      customer_vpa = resp['CUSTOMERVPA'] ?? "";
      customer_fvpa = ":$customer_vpa";
    }
    var merchantid = ""; //Please enter Merchant Id
    var username = ""; //Please enter Username

// Calculate the CRC32 checksum

    var sParam =
        '${transid}:${apTransactionID}:${amount}:${transtatus}:${message}:${merchantid}:${username}$customer_fvpa';

    // var checkSumResult = Crc32.calculate(sParam);

    // if(checkSumResult.toString() == secureHash.toString()){
    //   Fluttertoast.showToast(
    //       msg: "Securehash matched",
    //       toastLength: Toast.LENGTH_LONG,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.white24,
    //       textColor: Colors.white,
    //       fontSize: 16.0
    //   );
    // }else{
    //   Fluttertoast.showToast(
    //       msg: "Securehash mis-matched",
    //       toastLength: Toast.LENGTH_LONG,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.white24,
    //       textColor: Colors.white,
    //       fontSize: 16.0
    //   );
    // }

    // AwesomeDialog(
    //     context: context,
    //     dialogType: DialogType.NO_HEADER,
    //     headerAnimationLoop: true,
    //     animType: AnimType.BOTTOMSLIDE,
    //     //title: "AirPay",
    //     desc: 'Transaction Status: ' +
    //         txtSts +
    //         '\nTransaction Status Message: ' +
    //         txtStsMsg)
    //     .show();
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  getPlans() async {
    try {
      setLoding();
      var request = await API.getPlansListApi();

      if (request.status == 1) {
        for (var i in request.result) {
          plansList.add(PlansListModel.fromJson(i));
        }
        setLoding();
      } else {
        setLoding();
        Fluttertoast.showToast(
            msg: request.msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
            textColor: Colors.black,
            fontSize: 16.0);
      }
    } catch (e) {
      print("some exception occured ${e.toString()}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getPlans();
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
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 300,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            plansList[i].pName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: "Rs.${plansList[i].monthPrice}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: " /Month (+GST)",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ]))
                        ],
                      ),
                    ),
                    Container(
                      height: 280,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: const Color.fromARGB(255, 189, 185, 185),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          _rowData("Storage", plansList[i].name),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            color: Colors.white,
                            indent: 15,
                            endIndent: 15,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          _rowData("Validity", plansList[i].validity),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            color: Colors.white,
                            indent: 15,
                            endIndent: 15,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          _rowData("Total Price", plansList[i].price),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            color: Colors.white,
                            indent: 15,
                            endIndent: 15,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AirPay(
                                    user: user,
                                    closure: (status, response) =>
                                        {onComplete(status, response)},
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              width: 220,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.6),
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Text(
                                  "Order Now",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, i) => const SizedBox(
                    width: 1,
                  ),
              itemCount: plansList.length)),
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
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Text(
                  ":",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _rowData2(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            ":",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.440,
              height: 43,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
              ),
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 50)),
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xFF131416),
                    ),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () async {
                    Get.to(QuotationItemDetailhistoryui(
                        index: widget.index, type: widget.type!));
                  },
                  child: const Text(
                    "View",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat-Bold',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1.33),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
