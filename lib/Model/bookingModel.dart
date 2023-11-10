class BookingModel {
  String id;
  String bkId;
  String mobile;
  String name;
  String status;
  String crDate;
  String endDate;
  String membId;

  BookingModel({
    required this.id,
    required this.bkId,
    required this.mobile,
    required this.name,
    required this.status,
    required this.crDate,
    required this.endDate,
    required this.membId,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      bkId: json['bk_id'],
      mobile: json['mobile'],
      name: json['name'],
      status: json['status'],
      crDate: json['cr_date'],
      endDate: json['end_date'],
      membId: json['memb_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "bk_id": bkId,
        "mobile": mobile,
        "name": name,
        "status": status,
        "cr_date": crDate,
        "end_date": endDate,
        "memb_id": membId,
      };

  @override
  String toString() {
    return 'BookingModel{id: $id, bkId: $bkId, mobile: $mobile, name: $name, status: $status, crDate: $crDate, endDate: $endDate, membId: $membId}';
  }

  set setMobile(String mobile) =>
      this.mobile = mobile; // ignore: unnecessary_this
}
