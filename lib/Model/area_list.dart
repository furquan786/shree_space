class AreaListModel {
  String id;
  String city_id;
  String area_name;

  AreaListModel({
    required this.id,
    required this.city_id,
    required this.area_name,
  });

  factory AreaListModel.fromJSON(var json) {
    return AreaListModel(
      id: json["id"],
      city_id: json["city_id"],
      area_name: json["area_name"],
    );
  }
  List<AreaListModel> fromList(var list) {
    final List<AreaListModel> districtList = [];
    for (var i in list) {
      districtList.add(AreaListModel.fromJSON(i));
    }
    return districtList;
  }
}
