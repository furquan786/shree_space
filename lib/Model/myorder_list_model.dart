class MyOrderListModel {
  String id;
  String sell_id;
  String buy_id;
  String product_id;
  String product_name;
  String price;
  String qty;
  String from_date;
  String to_date;
  String total;
  String ship_add;
  String pincode;
  String status;

  MyOrderListModel({
    required this.id,
    required this.sell_id,
    required this.buy_id,
    required this.product_id,
    required this.product_name,
    required this.price,
    required this.qty,
    required this.from_date,
    required this.to_date,
    required this.total,
    required this.ship_add,
    required this.pincode,
    required this.status,
  });

  // Return object from JSON //
  factory MyOrderListModel.fromJson(var json) {
    return MyOrderListModel(
        id: json["id"],
        sell_id: json["sell_id"],
        buy_id: json["buy_id"],
        product_id: json["product_id"],
        product_name: json["product_name"],
        price: json["price"],
        qty: json["qty"],
        from_date: json["from_date"],
        to_date: json["to_date"],
        total: json["total"],
        ship_add: json["ship_add"],
        pincode: json["pincode"],
        status: json["status"]);
  }
}
