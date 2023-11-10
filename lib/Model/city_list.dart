class CityListModel {
  String city_id;
  String city_name;

  CityListModel({
    required this.city_id,
    required this.city_name,
  });

  factory CityListModel.fromJSON(var json) {
    return CityListModel(
      city_id: json["city_id"],
      city_name: json["city_name"],
    );
  }
  List<CityListModel> fromList(var list) {
    final List<CityListModel> districtList = [];
    for (var i in list) {
      districtList.add(CityListModel.fromJSON(i));
    }
    return districtList;
  }
}
