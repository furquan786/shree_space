class PlanListModel {
  String id;
  String name;
  String price;
  String validity;

  PlanListModel({
    required this.id,
    required this.name,
    required this.price,
    required this.validity,
  });

  factory PlanListModel.fromJSON(var json) {
    return PlanListModel(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      validity: json["validity"],
    );
  }
  List<PlanListModel> fromList(var list) {
    final List<PlanListModel> districtList = [];
    for (var i in list) {
      districtList.add(PlanListModel.fromJSON(i));
    }
    return districtList;
  }
}
