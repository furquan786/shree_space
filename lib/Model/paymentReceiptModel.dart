class PaymentReceiptModel {
  String id;
  String invId;
  String invNo;
  String custName;
  String custUniqCode;
  DateTime startDate;
  DateTime endDate;
  String ocation;
  String state;
  String city;
  String stateN;
  String cityN;
  String cityPin;
  String address;
  String memId;
  String status;
  String lgImg;
  String bName;
  String amount;
  String remark;
  String pType;
  DateTime crDate;
  String rcptNo;

  PaymentReceiptModel({
    required this.id,
    required this.invId,
    required this.invNo,
    required this.custName,
    required this.custUniqCode,
    required this.startDate,
    required this.endDate,
    required this.ocation,
    required this.state,
    required this.city,
    required this.stateN,
    required this.cityN,
    required this.cityPin,
    required this.address,
    required this.memId,
    required this.status,
    required this.lgImg,
    required this.bName,
    required this.amount,
    required this.remark,
    required this.pType,
    required this.crDate,
    required this.rcptNo,
  });

  factory PaymentReceiptModel.fromJson(Map<String, dynamic> json) =>
      PaymentReceiptModel(
        id: json["id"],
        invId: json["inv_id"],
        invNo: json["inv_no"],
        custName: json["cust_name"],
        custUniqCode: json["cust_uniq_code"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        ocation: json["ocation"],
        state: json["state"],
        city: json["city"],
        stateN: json["state_n"],
        cityN: json["city_n"],
        cityPin: json["city_pin"],
        address: json["address"],
        memId: json["mem_id"],
        status: json["status"],
        lgImg: json["lg_img"],
        bName: json["b_name"],
        amount: json["amount"],
        remark: json["remark"],
        pType: json["p_type"],
        crDate: DateTime.parse(json["cr_date"]),
        rcptNo: json["rcpt_no"],
      );
}
