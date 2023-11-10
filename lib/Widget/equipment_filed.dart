import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/QuotationModel.dart';
import '../Model/workprofileModel.dart';

class EquipmentField extends StatefulWidget {
  final QuotationModel quotation;
  final int index;
  List<WorkProfileModel> workprofileList;

  EquipmentField(
      {required this.quotation,
      required this.index,
      required this.workprofileList,
      Key? key})
      : super(key: key);

  @override
  _EquipmentFieldState createState() => _EquipmentFieldState();
}

class _EquipmentFieldState extends State<EquipmentField> {
  bool isLoding = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController requirmentController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  WorkProfileModel? selectedworkprofile;
  @override
  void initState() {
    amountController.text = widget.quotation.amount ?? "";
    remarkController.text = widget.quotation.remark ?? "";
    amountController.addListener(() {
      //here you have the changes of your textfield
      print("value: ${amountController.text}");
      //use setState to rebuild the widget
      setState(() {
        widget.quotation.setAmount = amountController.text;
      });
    });
    remarkController.addListener(() {
      //here you have the changes of your textfield
      print("value: ${remarkController.text}");
      //use setState to rebuild the widget
      setState(() {
        widget.quotation.setRemark = remarkController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(
                    "Requirement ${widget.index + 1} *",
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
                _requirmentDropDown(),
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
              ],
            ),
          ),
          Visibility(
              visible: isLoding,
              child: Container(
                height: 250,
                color: Colors.transparent,
                child: Center(
                  child: Platform.isIOS
                      ? const CupertinoActivityIndicator(
                          radius: 25,
                        )
                      : CircularProgressIndicator(),
                ),
              ))
        ],
      ),
    );
  }

  Widget _requirmentDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField(
          isExpanded: true,
          menuMaxHeight: 300,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          items: widget.workprofileList.map((WorkProfileModel val) {
            return DropdownMenuItem(
              value: val,
              child: Text(val.name),
            );
          }).toList(),
          value: selectedworkprofile,
          hint: Text(
            widget.quotation.requirement ?? "Select Requirement",
            maxLines: 1,
            style: TextStyle(color: Colors.grey),
          ),
          onChanged: (WorkProfileModel? value) {
            if (value != selectedworkprofile) {
              setState(() {
                selectedworkprofile = value;
                widget.quotation.setRequirement = selectedworkprofile!.name;
                /*widget.quotation.setBrand =  '';
                widget.quotation.setequipment = '';*/
              });
            }
          }),
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

  setLoding() {
    setState(() {
      isLoding = !isLoding;
    });
  }
}
