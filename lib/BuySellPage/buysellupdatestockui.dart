import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Backend/api_request.dart';
import '../Backend/share_manager.dart';
import '../Config/enums.dart';
import '../Model/buysell_list_model.dart';
import 'buysell_my_post_ui.dart';

class Buysellupdatestockui extends StatefulWidget {
  String index, title;
  final UserType type;
  Buysellupdatestockui(
      {this.index = "", this.title = "", required this.type, Key? key})
      : super(key: key);

  @override
  State<Buysellupdatestockui> createState() => _BuysellupdatestockuiState();
}

class _BuysellupdatestockuiState extends State<Buysellupdatestockui> {
  bool isLoding = false;
  List<BuysellListModel> buysellDetail = [];
  TextEditingController availStockController = TextEditingController();
  GlobalKey<FormState> _fbKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBuysellDetails();
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
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /*   Image.asset(
                'Assets/desh1.png',
                fit: BoxFit.scaleDown,
                height: 50,
              ),*/
              Flexible(
                  child: Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(widget.title)))
            ],
          ),
        ),
        body: Stack(children: [
          Container(
              width: screen.width,
              height: screen.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // tileMode: TileMode.clamp,
                    //transform: GradientRotation(math.pi / 4), Color(0xFF353A3F)
                    //  stops: [0.4, 1],
                    //0d0c22
                    colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
                /* gradient: linearGradient(
                    160, ['#262626 0%', "#000000 100%"]),*/
                /*gradient: LinearGradient(
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomRight,
                    //transform: GradientRotation(math.pi / 4),
                    //stops: [0.4, 1],
                    colors: [Color(0xFF00444B), Color(0xFF00444B)]),*/
              ),
              child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.white,
                  ),
                  child: SingleChildScrollView(
                      child: Form(
                    key: _fbKey,
                    child: buysellDetail == null
                        ? Center()
                        : buysellDetail.isEmpty
                            ? Center(
                                child: Text(
                                "",
                                style: TextStyle(color: Colors.white),
                              ))
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: SizedBox(
                                          width: screen.width,
                                          child: Text("Stock Update:",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    productTable('Available Stock :  ',
                                        buysellDetail[0].avl_stock),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: availSotckFormFiled(),
                                    ),
                                    const SizedBox(height: 15),
                                    Align(
                                      alignment: AlignmentDirectional.center,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 20.0,
                                            left: 20.0,
                                            right: 20.0,
                                            top: 0.0),
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          //Vertical || Horizontal
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5.0, right: 10.0),
                                              child: /*Material(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                             // color: Colors.black87,
                                              clipBehavior: Clip.antiAlias,
                                              child: */
                                                  MaterialButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0,
                                                              right: 20.0,
                                                              top: 10.0,
                                                              bottom: 10.0),
                                                      color: const Color(
                                                          0xFF131416),
                                                      child: const Text(
                                                        "Sell Out",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        String user_id =
                                                            await ShareManager
                                                                .getUserID();
                                                        if (_fbKey.currentState!
                                                            .validate()) {
                                                          // int stock = availStockController.text.toString() as int;
                                                          int stock = int.parse(
                                                              availStockController
                                                                  .text);
                                                          int avilstock =
                                                              int.parse(
                                                                  buysellDetail[
                                                                          0]
                                                                      .avl_stock);
                                                          print(stock);
                                                          print(avilstock);
                                                          if (stock <=
                                                              avilstock) {
                                                            setLoding();
                                                            final requestData =
                                                                await API.sellout(
                                                                    user_id,
                                                                    widget
                                                                        .index,
                                                                    availStockController
                                                                        .text
                                                                        .trim(),
                                                                    buysellDetail[
                                                                            0]
                                                                        .avl_stock);
                                                            if (requestData
                                                                    .status ==
                                                                1) {
                                                              setLoding();
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      requestData
                                                                          .msg);
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        BuySellMyPostui(
                                                                            type:
                                                                                widget.type)),
                                                              );
                                                            } else {
                                                              setLoding();
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      requestData
                                                                          .msg);
                                                            }
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Please Check your sold stock");
                                                          }

                                                          return;
                                                        } else {
                                                          print("Unsuccessful");
                                                        }
                                                      }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                  )))),
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

  Widget availSotckFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: availStockController,
        validator: (value) {
          if (value!.isEmpty) {
            return "How many sold your stock";
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
            hintText: "How many sold your stock",
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      ),
    );
  }

  Widget productTable(var title, var discription) {
    return Container(
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Wrap(
            direction: Axis.horizontal, //Vertical || Horizontal
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "  :  ",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                discription,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
