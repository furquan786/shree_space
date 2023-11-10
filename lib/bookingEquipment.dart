import 'package:flutter/material.dart';
import 'package:shreegraphic/Widget/bookingEquipmentField.dart';

import 'Model/bookingModel.dart';

class BookingEquipmentui extends StatefulWidget {
  final int count;
  final Function setBookList;

  BookingEquipmentui({required this.count, required this.setBookList, Key? key})
      : super(key: key);

  @override
  _BookingEquipmentuiState createState() => _BookingEquipmentuiState();
}

class _BookingEquipmentuiState extends State<BookingEquipmentui> {
  List<BookingModel> myBookingList = [];

  @override
  void initState() {
    // print(widget.quotationList.isNotEmpty
    //     ? widget.quotationList[0].category
    //     : "");

    print("count is = ${widget.count}");
    for (int i = myBookingList.length; i < widget.count; i++) {
      myBookingList.add(BookingModel(
          mobile: "",
          bkId: '',
          crDate: '',
          endDate: '',
          id: '',
          membId: '',
          name: '',
          status: ''));
    }

    print("myQuotationList lentght is =  ${myBookingList.length}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF131416),
          centerTitle: true,
          title: const Text("Booking Item"),
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
              child: myBookingList.isEmpty
                  ? SizedBox()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ...List.generate(widget.count, (index) {
                            return BookingEquipmentField(
                              index: index,
                              booking: myBookingList[index],
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
                                        "myQuotationList ${myBookingList.length}");
                                    widget.setBookList(myBookingList);
                                    Navigator.pop(context);
                                  }))
                        ],
                      ),
                    ),
            )));
  }
}
