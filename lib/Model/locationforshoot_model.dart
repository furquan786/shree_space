class LocforShootModel {
  String id;
  String name;
  String state;
  String city;
  String state_id;
  String city_id;
  String city_pin;
  String address;
  String member_id;
  String status;
  String image;
  String cost;

  LocforShootModel({
    required this.id,
    required this.name,
    required this.state,
    required this.city,
    required this.state_id,
    required this.city_id,
    required this.city_pin,
    required this.address,
    required this.member_id,
    required this.status,
    required this.image,
    required this.cost,
  });

  // Return object from JSON //
  factory LocforShootModel.fromJson(var json) {
    return LocforShootModel(
      id: json["id"],
      name: json["name"],
      state: json["state"],
      city: json["city"],
      state_id: json["state_id"],
      city_id: json["city_id"],
      city_pin: json["city_pin"],
      address: json["address"],
      member_id: json["member_id"],
      status: json["status"],
      image: json["image"],
      cost: json["cost"],
    );
  }
}
