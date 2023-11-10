import 'package:flutter/material.dart';

import 'Model/QuotationModel.dart';
import 'Model/workprofileModel.dart';
import 'Widget/equipment_filed.dart';

class EquipmentUi extends StatefulWidget {
  final List<QuotationModel> quotationList;
  final int count;
  List<WorkProfileModel> workprofileList;
  final Function setQuaList;

  EquipmentUi(
      {required this.quotationList,
      required this.count,
      required this.workprofileList,
      required this.setQuaList,
      Key? key})
      : super(key: key);

  @override
  _EquipmentUiState createState() => _EquipmentUiState();
}

class _EquipmentUiState extends State<EquipmentUi> {
  List<QuotationModel> myQuotationList = [];

  @override
  void initState() {
    myQuotationList = widget.quotationList;
    // print(widget.quotationList.isNotEmpty
    //     ? widget.quotationList[0].category
    //     : "");

    print("count is = ${widget.count}");
    for (int i = myQuotationList.length; i < widget.count; i++) {
      myQuotationList.add(QuotationModel(
          amount: '',
          id: '',
          name: '',
          qot_id: '',
          remark: '',
          requirement: '',
          selec: false));
    }

    print("myQuotationList lentght is =  ${myQuotationList.length}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
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
              child: myQuotationList.isEmpty
                  ? SizedBox()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ...List.generate(widget.count, (index) {
                            return EquipmentField(
                              quotation: myQuotationList[index],
                              workprofileList: widget.workprofileList,
                              index: index,
                            );
                          }).toList(),
                          const SizedBox(
                            height: 10,
                          ),
                          Material(
                              borderRadius: BorderRadius.circular(10.0),
                              child: MaterialButton(
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 50,
                                  child: const Text(
                                    "ADD",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    print(
                                        "myQuotationList ${myQuotationList.length}");
                                    widget.setQuaList(myQuotationList);
                                    Navigator.pop(context);
                                  }))
                        ],
                      ),
                    ),
            )));
  }
}
