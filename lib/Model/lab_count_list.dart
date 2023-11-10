class LABListCountModel {
  String id;
  String lab_id;
  String lab_name;
  String lan_number;
  String mem_id;
  String mem_name;
  String count;
  LABListCountModel({
    required this.id,
    required this.lab_id,
    required this.lab_name,
    required this.lan_number,
    required this.mem_id,
    required this.mem_name,
    required this.count,
  });

  factory LABListCountModel.fromJson(var json) {
    return LABListCountModel(
      id: json["id"],
      lab_id: json["lab_id"],
      lab_name: json["lab_name"],
      lan_number: json["lan_number"],
      mem_id: json["mem_id"],
      mem_name: json["mem_name"],
      count: json["count"],
    );
  }
}
