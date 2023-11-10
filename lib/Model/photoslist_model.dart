class Photosmodel {
  String mem_id;
  String image;
  String video;
  String id;

  Photosmodel({
    required this.mem_id,
    required this.image,
    required this.video,
    required this.id,
  });

  factory Photosmodel.fromJSON(var json) {
    return Photosmodel(
      mem_id: json["mem_id"],
      image: json["image"],
      video: json["video"],
      id: json["id"],
    );
  }
  List<Photosmodel> fromList(var list) {
    final List<Photosmodel> cateogryList = [];
    for (var i in list) {
      cateogryList.add(Photosmodel.fromJSON(i));
    }
    return cateogryList;
  }
}
