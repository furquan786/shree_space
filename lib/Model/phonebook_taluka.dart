class PhoneBookTaluka {
  String id;
  String name;
  String state_id;
  String district_id;

  PhoneBookTaluka({
    required this.id,
    required this.name,
    required this.state_id,
    required this.district_id,
  });

  factory PhoneBookTaluka.fromJSON(var json) {
    return PhoneBookTaluka(
      id: json["id"],
      state_id: json["state_id"],
      name: json["name"],
      district_id: json["district_id"],
    );
  }
  List<PhoneBookTaluka> fromList(var list) {
    final List<PhoneBookTaluka> districtList = [];
    for (var i in list) {
      districtList.add(PhoneBookTaluka.fromJSON(i));
    }
    return districtList;
  }
}
