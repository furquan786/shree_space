class AnnouncementModel {
  String id;
  String title;
  String anno_by;
  String anno_desc;
  String anno_date_new;
  DateTime anno_date;
  DateTime start_date;
  DateTime end_date;
  String cr_date;
  String time;
  String work_profile;
  String state;
  String days;
  String occ_loc;
  String custom_location;
  String occasion;
  String side;
  String camera;
  String city;
  String area;
  String anno_by_mo;
  String status;
  String cust_name;
  String cust_uniq;
  String shoot_location;
  String requirement;
  String ocasion;
  String location;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.anno_by,
    required this.anno_desc,
    required this.anno_date_new,
    required this.anno_date,
    required this.start_date,
    required this.end_date,
    required this.cr_date,
    required this.time,
    required this.work_profile,
    required this.state,
    required this.days,
    required this.occ_loc,
    required this.custom_location,
    required this.occasion,
    required this.side,
    required this.camera,
    required this.city,
    required this.area,
    required this.anno_by_mo,
    required this.status,
    required this.cust_name,
    required this.cust_uniq,
    required this.shoot_location,
    required this.requirement,
    required this.ocasion,
    required this.location,
  });

  // Return object from JSON //
  factory AnnouncementModel.fromJson(var json) {
    return AnnouncementModel(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      anno_by: json["anno_by"] ?? "",
      anno_desc: json["anno_desc"] ?? "",
      anno_date_new: json['anno_date_new'] ?? "",
      anno_date: DateTime.parse(json['anno_date'] ?? "2023-10-19 11:44:52"),
      start_date: DateTime.parse(json['start_date'] ?? "2023-10-19 11:44:52"),
      end_date: DateTime.parse(json['end_date'] ?? "2023-10-19 11:44:52"),
      time: json["time"] ?? "",
      cr_date: json["cr_date"] ?? "",
      work_profile: json["work_profile"] ?? "",
      state: json["state"] ?? "",
      days: json["days"] ?? "",
      occ_loc: json["occ_loc"] ?? "",
      custom_location: json["custom_location"] ?? "",
      occasion: json["occasion"] ?? "",
      side: json["side"] ?? "",
      camera: json["camera"] ?? "",
      city: json["city"] ?? "",
      area: json["area"] ?? "",
      anno_by_mo: json["anno_by_mo"] ?? "",
      status: json["status"] ?? "",
      cust_name: json["cust_name"] ?? "",
      cust_uniq: json["cust_uniq"] ?? "",
      shoot_location: json["shoot_location"] ?? "",
      requirement: json["requirement"] ?? "",
      ocasion: json["ocasion"] ?? "",
      location: json["location"] ?? "",
    );
  }
}
