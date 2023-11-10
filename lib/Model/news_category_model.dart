class NewsCategoryModel {
  String id;
  String count;
  String name;
  String description;
  String image;
  DateTime crDate;

  NewsCategoryModel({
    required this.id,
    required this.count,
    required this.name,
    required this.description,
    required this.image,
    required this.crDate,
  });

  // Return object from JSON //
  factory NewsCategoryModel.fromJson(var json) {
    return NewsCategoryModel(
      id: json["id"],
      count: json["count"],
      name: json["name"],
      description: json["description"],
      image: json["image"],
      crDate: DateTime.parse(json["cr_date"]),
    );
  }
}
