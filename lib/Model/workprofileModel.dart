class WorkProfileModel {
  String id;
  String name;

  WorkProfileModel({
    required this.id,
    required this.name,
  });

  factory WorkProfileModel.fromJSON(var json) {
    return WorkProfileModel(
      id: json["id"],
      name: json["name"],
    );
  }

  factory WorkProfileModel.fromJson(var json) {
    return WorkProfileModel(
      name: json["name"],
      id: json["id"],
    );
  }
  List<WorkProfileModel> fromList(var list) {
    final List<WorkProfileModel> stateList = [];
    for (var i in list) {
      stateList.add(WorkProfileModel.fromJSON(i));
    }
    return stateList;
  }
}
