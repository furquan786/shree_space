class NotificationListModel {
  String id;
  String mobile;
  String title;
  String msg;
  DateTime cr_date;

  NotificationListModel({
    required this.id,
    required this.mobile,
    required this.title,
    required this.msg,
    required this.cr_date,
  });

  factory NotificationListModel.fromJson(var json) {
    return NotificationListModel(
      id: json["id"],
      mobile: json["mobile"],
      title: json["title"],
      msg: json["msg"],
      cr_date: json['cr_date'] ?? DateTime.parse(json['cr_date'] as String),
    );
  }
}
