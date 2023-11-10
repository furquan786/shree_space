class Category {
  String id;
  String count;
  String name;
  String description;
  String image;

  Category({
    required this.id,
    required this.count,
    required this.name,
    required this.description,
    required this.image,
  });

  factory Category.fromJSON(var json) {
    return Category(
      id: json["id"],
      count: json["count"],
      name: json["name"],
      description: json["description"],
      image: json["image"],
    );
  }
  List<Category> fromList(var list) {
    final List<Category> categoryList = [];
    for (var i in list) {
      categoryList.add(Category.fromJSON(i));
    }
    return categoryList;
  }
}
