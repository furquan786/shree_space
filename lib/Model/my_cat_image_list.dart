class MyCatIamgeListModel {
  String id;
  String image;
  String div_id;
  String cat_name;
  String img_size;
  String owner;
  String i_id;
  String selected;
  String image_name;
  String nurl;

  MyCatIamgeListModel({
    required this.id,
    required this.image,
    required this.div_id,
    required this.cat_name,
    required this.img_size,
    required this.owner,
    required this.i_id,
    required this.selected,
    required this.image_name,
    required this.nurl,
  });

  factory MyCatIamgeListModel.fromJson(var json) {
    return MyCatIamgeListModel(
      id: json["id"] ?? "",
      image: json["image"] ?? "",
      div_id: json["div_id"] ?? "",
      cat_name: json["cat_name"] ?? "",
      img_size: json["img_size"] ?? "",
      owner: json["owner"] ?? "",
      i_id: json["i_id"] ?? "",
      selected: json["selected"] ?? "",
      image_name: json["image_name"] ?? "",
      nurl: json["nurl"] ?? "",
    );
  }
}
