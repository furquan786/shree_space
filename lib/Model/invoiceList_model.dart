class InvoiceListModel {
  String id;
  String custName;
  String custUniqCode;
  DateTime startDate;
  DateTime endDate;
  String ocation;
  dynamic side;
  String state;
  String city;
  dynamic area;
  String stateN;
  String cityN;
  dynamic areaN;
  String cityPin;
  String address;
  String amount;
  dynamic requiremet;
  dynamic remark;
  String memId;
  String status;
  dynamic whyCancel;
  String cancelBy;
  DateTime crDate;
  String lgImg;
  String bName;
  String qotId;
  String invNo;
  String invSt;
  String qotNo;
  String paid;
  String remAmt;

  InvoiceListModel({
    required this.id,
    required this.custName,
    required this.custUniqCode,
    required this.startDate,
    required this.endDate,
    required this.ocation,
    required this.side,
    required this.state,
    required this.city,
    required this.area,
    required this.stateN,
    required this.cityN,
    required this.areaN,
    required this.cityPin,
    required this.address,
    required this.amount,
    required this.requiremet,
    required this.remark,
    required this.memId,
    required this.status,
    required this.whyCancel,
    required this.cancelBy,
    required this.crDate,
    required this.lgImg,
    required this.bName,
    required this.qotId,
    required this.invNo,
    required this.invSt,
    required this.qotNo,
    required this.paid,
    required this.remAmt,
  });
  factory InvoiceListModel.fromJson(Map<String, dynamic> json) =>
      InvoiceListModel(
        id: json["id"] ?? "",
        custName: json["cust_name"] ?? "",
        custUniqCode: json["cust_uniq_code"] ?? "",
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        ocation: json["ocation"] ?? "",
        side: json["side"] ?? "",
        state: json["state"] ?? "",
        city: json["city"],
        area: json["area"],
        stateN: json["state_n"],
        cityN: json["city_n"],
        areaN: json["area_n"],
        cityPin: json["city_pin"],
        address: json["address"],
        amount: json["amount"],
        requiremet: json["requiremet"],
        remark: json["remark"],
        memId: json["mem_id"],
        status: json["status"],
        whyCancel: json["why_cancel"],
        cancelBy: json["cancel_by"],
        crDate: DateTime.parse(json["cr_date"]),
        lgImg: json["lg_img"] ?? "",
        bName: json["b_name"] ?? "",
        qotId: json["qot_id"] ?? "",
        invNo: json["inv_no"] ?? "",
        invSt: json["inv_st"] ?? "",
        qotNo: json["qot_no"] ?? "",
        paid: json["paid"] ?? "",
        remAmt: json["rem_amt"] ?? "",
      );
}
