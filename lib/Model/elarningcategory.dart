class ELearningCat {
  String id;
  String name;
  String image;

  ELearningCat({
    required this.id,
    required this.name,
    required this.image,
  });

  // Return object from JSON //
  factory ELearningCat.fromJson(var json) {
    return ELearningCat(
      id: json["id"],
      name: json["name"],
      image: json["image"],
    );
  }
}
