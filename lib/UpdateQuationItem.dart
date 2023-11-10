import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Backend/api_request.dart';
import 'Config/enums.dart';
import 'Model/QuotationModel.dart';
import 'Model/request_data.dart';
import 'Model/workprofileModel.dart';
import 'Widget/equipment_filed.dart';
import 'editQuotationBook.dart';

class UpdateQuotationItemUi extends StatefulWidget {
  final UserType type;
  String id;
  QuotationModel item;

  UpdateQuotationItemUi(
      {required this.type, this.id = "", required this.item, Key? key})
      : super(key: key);

  @override
  _UpdateQuotationItemUiState createState() => _UpdateQuotationItemUiState();
}

class _UpdateQuotationItemUiState extends State<UpdateQuotationItemUi> {
  List<WorkProfileModel> workprofileList = [];
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  var selectedRequirement = "";
  bool isLoding = false;
  int index = 0;
  @override
  void initState() {
    super.initState();
    getWorkProfile();
  }

  void getWorkProfile() async {
    amountController.text = widget.item.amount;
    remarkController.text = widget.item.remark;
    if (await DataConnectionChecker().hasConnection) {
      workprofileList = [];
      setLoding();
      RequestData requestData = await API.workprofileListAPI();
      setLoding();
      if (requestData.status == 1) {
        for (var i in requestData.result) {
          workprofileList.add(WorkProfileModel.fromJSON(i));
        }
        selectedRequirement = widget.item.name;
        setState(() {
          for (int i = 0; i < workprofileList.length; i++) {
            if (widget.item.name == workprofileList[i].name) {
              index = i;
            }
          }
        });

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
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF131416),
            centerTitle: true,
            title: const Text("Quotation Item"),
          ),
          body: Container(
              width: screen.width,
              height: screen.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2C3137), Color(0xFF1B1C20)]),
              ),
              child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.white,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.02,
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: AlignmentDirectional.bottomStart,
                                child: Text(
                                  "Requirement *",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat-Bold',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              requirementDropDownMenu(
                                  "Select Requirement *", workprofileList,
                                  (newVal) {
                                if (newVal != selectedRequirement) {
                                  selectedRequirement = newVal!;
                                  setState(() {});
                                }
                              }, selectedRequirement),
                              const SizedBox(
                                height: 20,
                              ),
                              const Align(
                                alignment: AlignmentDirectional.bottomStart,
                                child: Text(
                                  "Amount *",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat-Bold',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              amountFormFiled(),
                              const SizedBox(height: 20),
                              const Align(
                                alignment: AlignmentDirectional.bottomStart,
                                child: Text(
                                  "Remark *",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat-Bold',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              remarkFormFiled(),
                              const SizedBox(height: 20),
                              Material(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: MaterialButton(
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: Colors.transparent)),
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                      height: 50,
                                      child: const Text(
                                        "Update",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      color: Colors.white,
                                      onPressed: () async {
                                        setLoding();

                                        final requestData =
                                            await API.editquotationitemAPI(
                                                widget.item.id,
                                                widget.item.qot_id,
                                                selectedRequirement,
                                                amountController.text,
                                                remarkController.text);
                                        if (requestData.status == 1) {
                                          setLoding();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditQuotationBookui(
                                                      type: widget.type,
                                                      id: widget.id,
                                                    )),
                                          );
                                        } else {
                                          setLoding();
                                          Fluttertoast.showToast(
                                              msg: requestData.msg);
                                        }
                                      }))
                            ],
                          ),
                        ),
                      ))))),
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

  Widget requirementDropDownMenu(String hint, List<WorkProfileModel> list,
      Function(String? val) onChange, String value) {
    return SizedBox(
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              filled: true,
              fillColor: Colors.white,
            ),
            items: list.map((WorkProfileModel val) {
              return DropdownMenuItem<String>(
                value: val.name,
                child: Text(
                  val.name,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              );
            }).toList(),
            value: value,
            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onChanged: onChange),
      ),
    );
  }

  Widget amountFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: amountController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Amount";
          }
          return null;
        },
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Montserrat-Bold',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Amount",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'Montserrat-Bold',
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in unfocused
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in focused
          ),
        ),
      ),
    );
  }

  Widget remarkFormFiled() {
    return SizedBox(
      child: TextFormField(
        controller: remarkController,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Montserrat-Bold',
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        keyboardType: TextInputType.multiline,
        minLines: 3,
        maxLines: null,
        decoration: const InputDecoration(
          //filled: true,
          contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          hintText: "Remark",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'Montserrat-Bold',
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in unfocused
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in focused
          ),
        ),
      ),
    );
  }
}
