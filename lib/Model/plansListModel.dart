class PlansListModel {
  String id;
  String name;
  String price;
  String validity;
  DateTime crDate;
  String monthPrice;
  String pName;

  PlansListModel({
    required this.id,
    required this.name,
    required this.price,
    required this.validity,
    required this.crDate,
    required this.monthPrice,
    required this.pName,
  });

  factory PlansListModel.fromJson(Map<String, dynamic> json) => PlansListModel(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        validity: json["validity"],
        crDate: DateTime.parse(json["cr_date"]),
        monthPrice: json["month_price"],
        pName: json["p_name"],
      );
}
