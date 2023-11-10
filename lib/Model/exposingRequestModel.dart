class ExposingRequestModel {
  final String id;
  final String status;
  final String bkId;
  final String ocasion;
  final String startDate;
  final String endDate;
  final String shootLocation;
  final String requirement;

  ExposingRequestModel({
    required this.id,
    required this.status,
    required this.bkId,
    required this.ocasion,
    required this.startDate,
    required this.endDate,
    required this.shootLocation,
    required this.requirement,
  });

  factory ExposingRequestModel.fromJson(Map<String, dynamic> json) {
    return ExposingRequestModel(
      id: json['id'],
      status: json['status'],
      bkId: json['bk_id'],
      ocasion: json['ocasion'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      shootLocation: json['shoot_location'],
      requirement: json['requirement'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['bk_id'] = this.bkId;
    data['ocasion'] = this.ocasion;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['shoot_location'] = this.shootLocation;
    data['requirement'] = this.requirement;
    return data;
  }
}
