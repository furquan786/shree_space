class QuoationModel {
  String id;
  String cust_name;
  String cust_uniq_code;
  DateTime start_date;
  DateTime end_date;
  String ocation;
  String side;
  String state;
  String city;
  String area;
  String state_n;
  String city_n;
  String area_n;
  String city_pin;
  String address;
  String amount;
  String requiremet;
  String remark;
  String mem_id;
  String status;
  String why_cancel;
  String cancel_by;
  String qot_no;
  String inv;

  QuoationModel({
    required this.id,
    required this.cust_name,
    required this.cust_uniq_code,
    required this.start_date,
    required this.end_date,
    required this.ocation,
    required this.side,
    required this.state,
    required this.city,
    required this.area,
    required this.state_n,
    required this.city_n,
    required this.area_n,
    required this.city_pin,
    required this.address,
    required this.amount,
    required this.requiremet,
    required this.remark,
    required this.mem_id,
    required this.status,
    required this.why_cancel,
    required this.cancel_by,
    required this.qot_no,
    required this.inv,
  });

  // Return object from JSON //
  factory QuoationModel.fromJson(var json) {
    return QuoationModel(
      id: json["id"],
      cust_name: json["cust_name"],
      cust_uniq_code: json["cust_uniq_code"],
      start_date: DateTime.parse(json['start_date'] as String),
      end_date: DateTime.parse(json['end_date'] as String),
      ocation: json["ocation"],
      side: json["side"] ?? "",
      state: json["state"] ?? "",
      city: json["city"] ?? "",
      area: json["area"] ?? "",
      state_n: json["state_n"] ?? "",
      city_n: json["city_n"] ?? "",
      area_n: json["area_n"] ?? "",
      city_pin: json["city_pin"] ?? "",
      address: json["address"] ?? "",
      amount: json["amount"] ?? "",
      requiremet: json["requiremet"] ?? "",
      remark: json["remark"] ?? "",
      mem_id: json["mem_id"] ?? "",
      status: json["status"] ?? "",
      why_cancel: json["why_cancel"] ?? "",
      cancel_by: json["cancel_by"] ?? "",
      qot_no: json["qot_no"] ?? "",
      inv: json["inv"] ?? "",
    );
  }
}
