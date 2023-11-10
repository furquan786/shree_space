class LABListModel {
  String id;
  String lab_id;
  String name;
  String mobile;

  LABListModel({
    required this.id,
    required this.lab_id,
    required this.name,
    required this.mobile,
  });

  factory LABListModel.fromJson(var json) {
    return LABListModel(
      id: json["id"],
      lab_id: json["lab_id"],
      name: json["name"],
      mobile: json["mobile"],
    );
  }
}
