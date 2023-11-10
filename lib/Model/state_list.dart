class StateListModel {
  String id;
  String name;

  StateListModel({
    required this.id,
    required this.name,
  });

  factory StateListModel.fromJSON(var json) {
    return StateListModel(
      id: json["id"],
      name: json["name"],
    );
  }
  List<StateListModel> fromList(var list) {
    final List<StateListModel> districtList = [];
    for (var i in list) {
      districtList.add(StateListModel.fromJSON(i));
    }
    return districtList;
  }
}
