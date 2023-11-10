import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../Backend/api_request.dart';
import '../Backend/share_manager.dart';
import '../Config/enums.dart';
import '../HomeScreen.dart';
import '../Model/buysell_list_model.dart';
import '../Model/razorpay_response_model.dart';
import 'buysellMainPage.dart';
import 'buysellcontroller.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BuysellBuyDetail extends StatefulWidget {
  String index;
  final UserType type;
  BuysellBuyDetail({required this.index, required this.type, Key? key})
      : super(key: key);

  @override
  State<BuysellBuyDetail> createState() => _BuysellBuyDetailState();
}

class _BuysellBuyDetailState extends State<BuysellBuyDetail> {
  final Buysellcontroller controller = Get.put(Buysellcontroller());
  List<String> productImages = [];
  var formatedDate;
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  bool isLoding = false;
  List<BuysellListModel> buysellDetail = [];
  SwiperController _controller = SwiperController();
  TextEditingController availStockController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  var qty, totalstock;
  int qty1 = 0;
  Razorpay _razorpay = Razorpay();
  final razorPayKey = dotenv.get("RZP_KEY");
  final razorPaySecret = dotenv.get("RZP_SECRET");
  @override
  void initState() {
    // TODO: implement initState

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    getBuysellDetails();
    availStockController.addListener(() {
      //here you have the changes of your textfield
      print("value: ${availStockController.text}");
      //use setState to rebuild the widget
      if (availStockController.text.toString() != "") {
        qty = availStockController.text;
        qty1 = num.parse('$qty') * num.parse('$totalstock') as int;
        print("value: ${qty1}");
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    availStockController.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(msg: " Payment Successfully");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "Payment Successfully");
  }

  getBuysellDetails() async {
    buysellDetail = [];
    setLoding();
    final requestData = await API.buysellDetail(widget.index);
    print(requestData);
    setLoding();
    if (requestData.status == 1) {
      for (var i in requestData.result) {
        buysellDetail.add(BuysellListModel.fromJson(i));
      }
      totalstock = requestData.result[0]["price"];
      setState(() {});
    }
  }

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF131416),
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            /* Image.asset(
              'Assets/desh1.png',
              fit: BoxFit.scaleDown,
              height: 50,
            ),*/
            buysellDetail == null
                ? Center()
                : buysellDetail.isEmpty
                    ? const Center(
                        child: Text(
                        "",
                        style: TextStyle(color: Colors.white),
                      ))
                    : Flexible(
                        child: Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(buysellDetail[0].cat_name)))
          ]),
        ),
        body: Stack(children: [
          Container(
              width: screen.width,
              height: screen.height,
              // color: Color(0xFF00444B),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // tileMode: TileMode.clamp,
                    //transform: GradientRotation(math.pi / 4), Color(0xFF353A3F)
                    //  stops: [0.4, 1],
                    //0d0c22
                    colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
                /*gradient: linearGradient(
                    160, ['#262626 0%', "#000000 100%"]),*/
              ),
              child: SingleChildScrollView(
                  child: buysellDetail == null
                      ? Center()
                      : buysellDetail.isEmpty
                          ? Center(
                              child: Text(
                              "",
                              style: TextStyle(color: Colors.white),
                            ))
                          : Form(
                              key: _fbKey,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // imagescroll(),
                                    const SizedBox(height: 15),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: _rowData(
                                            "Name of product",
                                            _parseHtmlString(
                                                buysellDetail[0].prod_name))),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: _rowData(
                                            "Product Description",
                                            _parseHtmlString(
                                                buysellDetail[0].description))),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: _rowData("Product Cost",
                                            buysellDetail[0].price)),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: _rowData(
                                            "Available Stock (In Number)",
                                            buysellDetail[0].avl_stock)),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: _rowData("Name of person",
                                            buysellDetail[0].seller_name)),
                                    const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: availSotckFormFiled()),
                                    const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: addressFormFiled()),
                                    const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: pincodeFormFiled()),
                                    const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    qty1 != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0),
                                            child: _rowData(
                                                "Total Cost",
                                                _parseHtmlString(
                                                    qty1.toString())))
                                        : SizedBox(),
                                    const SizedBox(height: 20),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: buttodata(lblbutton: "Ok")),
                                    const SizedBox(height: 20),
                                  ]),
                            ))),
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
        ]));
  }

  Widget buttodata({String lblbutton = ""}) {
    return Container(
      width: double.infinity,
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
            backgroundColor: MaterialStateProperty.all(Color(0xFF131416)),
            // elevation: MaterialStateProperty.all(3),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            if (await DataConnectionChecker().hasConnection) {
              if (_fbKey.currentState!.validate()) {
                int avilaqty = int.parse(availStockController.text);
                int qty = int.parse(buysellDetail[0].avl_stock);
                if (avilaqty <= qty) {
                  setLoding();
                  String buy_id = await ShareManager.getID();
                  final requestData = await API.addMOrderApi(
                      buysellDetail[0].seller_id,
                      buy_id,
                      widget.index,
                      buysellDetail[0].prod_name,
                      buysellDetail[0].price,
                      availStockController.text,
                      qty1.toString(),
                      addressController.text,
                      pincodeController.text,
                      "pendding");
                  if (requestData.status == 1) {
                    setLoding();
                    Fluttertoast.showToast(msg: requestData.msg);
                    createOrder();
                    //   Get.to(BuySellMainPage(type: widget.type));
                  } else {
                    setLoding();
                    Fluttertoast.showToast(msg: requestData.msg);
                  }
                  return;
                } else {
                  Fluttertoast.showToast(msg: "Please check your Qty");
                }
              }
            } else {
              Fluttertoast.showToast(
                  msg: "Please check your internet connection");
            }
          },
          child: Text(
            lblbutton,
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Montserrat-Bold',
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.33),
          )),
    );
  }

  Future<dynamic> createOrder() async {
    var mapHeader = <String, String>{};
    var auth =
        'Basic ' + base64Encode(utf8.encode('$razorPayKey:$razorPaySecret'));
    mapHeader['Authorization'] = auth;
    mapHeader['Accept'] = "application/json";
    mapHeader['Content-Type'] = "application/x-www-form-urlencoded";
    var map = <String, String>{};
    setState(() {
      map['amount'] = "${(num.parse(qty1.toString()) * 100)}";
    });
    map['currency'] = "INR";
    map['receipt'] = "receipt1";
    print("map $map");
    var response = await http.post(Uri.https("api.razorpay.com", "/v1/orders"),
        headers: mapHeader, body: map);
    print("...." + response.body);
    if (response.statusCode == 200) {
      RazorpayOrderResponse data =
          RazorpayOrderResponse.fromJson(json.decode(response.body));
      openCheckout(data);
    } else {
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  void openCheckout(RazorpayOrderResponse data) async {
    var options = {
      'key': razorPayKey,
      'amount': "${(num.parse(qty1.toString()) * 100)}",
      'name': 'Razorpay Test',
      'description': '',
      'order_id': '${data.id}',
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Widget availSotckFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: availStockController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Qty";
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
            hintText: "Qty",
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      ),
    );
  }

  Widget addressFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: addressController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Shipping Address";
          }
          return null;
        },
        keyboardType: TextInputType.streetAddress,
        decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
            hintText: "Shipping Address",
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      ),
    );
  }

  Widget pincodeFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: pincodeController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Pincode";
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
            hintText: "Pincode",
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      ),
    );
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

  Widget imagescroll() {
    Size screen = MediaQuery.of(context).size;
    final splitNames = buysellDetail[0].photos.split(',');
    for (int i = 0; i < splitNames.length; i++) {
      productImages.add(splitNames[i]);
    }

    var stringList =
        buysellDetail[0].crDate.toIso8601String().split(new RegExp(r"[T\.]"));
    formatedDate = "${stringList[0]} ${stringList[1]}";

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(formatedDate);
    formatedDate = DateFormat('dd-MM-yyyy – kk:mm:a').format(dateTime);

    return Stack(children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: SizedBox(
            height: screen.height * 0.4,
            width: screen.width,
            child: Swiper(
              physics: NeverScrollableScrollPhysics(),
              autoplay: true,
              key: UniqueKey(),
              scrollDirection: Axis.horizontal,
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                return new CachedNetworkImage(
                  imageUrl: "http://mmhomes.in/ShreeGraphic1/upload/buysell/" +
                      productImages[index],
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const CircleAvatar(
                    backgroundColor: Colors.black,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              },
              itemCount: productImages.length,
              itemWidth: 300.0,
            ),
          ),
        )
      ]),
    ]);
  }
}
