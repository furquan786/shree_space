class MemberListModel {
  String id;
  String memb_id;
  String name;
  String device_id;
  MemberListModel({
    required this.id,
    required this.memb_id,
    required this.name,
    required this.device_id,
  });

  factory MemberListModel.fromJson(var json) {
    return MemberListModel(
      id: json["id"],
      memb_id: json["memb_id"],
      name: json["name"],
      device_id: json["device_id"],
    );
  }
}
