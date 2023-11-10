class PhoneBookDistrict {
  String id;
  String state_id;
  String district;

  PhoneBookDistrict({
    required this.id,
    required this.state_id,
    required this.district,
  });

  factory PhoneBookDistrict.fromJSON(var json) {
    return PhoneBookDistrict(
      id: json["id"],
      state_id: json["state_id"],
      district: json["district"],
    );
  }
  List<PhoneBookDistrict> fromList(var list) {
    final List<PhoneBookDistrict> districtList = [];
    for (var i in list) {
      districtList.add(PhoneBookDistrict.fromJSON(i));
    }
    return districtList;
  }
}
