class BuysellListModel {
  String id;
  String seller_name;
  String seller_id;
  String mobile;
  String cat_id;
  String cat_name;
  String prod_name;
  String description;
  String uom;
  String type;
  String price;
  String avl_stock;
  String stock_unit;
  String address;
  String district;
  String dist_id;
  String state;
  String state_id;
  String taluko;
  String taluka_id;
  String photos;
  DateTime crDate;
  String status;
  dynamic view;
  dynamic like;
  dynamic share;
  String user_id;
  String user_name;

  BuysellListModel({
    required this.id,
    required this.seller_name,
    required this.seller_id,
    required this.mobile,
    required this.cat_id,
    required this.cat_name,
    required this.prod_name,
    required this.description,
    required this.uom,
    required this.type,
    required this.price,
    required this.avl_stock,
    required this.stock_unit,
    required this.address,
    required this.district,
    required this.dist_id,
    required this.state,
    required this.state_id,
    required this.taluko,
    required this.taluka_id,
    required this.photos,
    required this.crDate,
    required this.status,
    required this.view,
    required this.like,
    required this.share,
    required this.user_id,
    required this.user_name,
  });
  // Return object from JSON //
  factory BuysellListModel.fromJson(var json) {
    return BuysellListModel(
      id: json["id"],
      seller_name: json["seller_name"],
      seller_id: json["seller_id"],
      mobile: json["mobile"],
      cat_id: json["cat_id"],
      cat_name: json["cat_name"],
      prod_name: json["prod_name"],
      description: json["description"],
      uom: json["uom"],
      type: json["type"],
      price: json["price"],
      avl_stock: json["avl_stock"],
      stock_unit: json["stock_unit"],
      address: json["address"],
      district: json["district"],
      dist_id: json["dist_id"],
      state: json["state"],
      state_id: json["state_id"],
      taluko: json["taluko"],
      taluka_id: json["taluka_id"],
      photos: json["photos"],
      crDate: DateTime.parse(json["cr_date"]),
      status: json["status"],
      view: json["view"],
      like: json["like"],
      share: json["share"],
      user_id: json["user_id"],
      user_name: json["user_name"],
    );
  }
}
