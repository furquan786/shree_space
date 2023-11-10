class ITRModel {
  String id;
  String itr_year;
  String files;
  String status;

  ITRModel({
    required this.id,
    required this.itr_year,
    required this.files,
    required this.status,
  });

  // Return object from JSON //
  factory ITRModel.fromJson(var json) {
    return ITRModel(
      id: json["id"],
      itr_year: json["itr_year"],
      files: json["files"],
      status: json["status"],
    );
  }
}
