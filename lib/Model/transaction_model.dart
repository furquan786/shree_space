class TransactionModel {
  String id;
  String bill_id;
  String amount;
  String type;
  String note;
  String status;
  DateTime t_date;

  TransactionModel({
    required this.id,
    required this.bill_id,
    required this.amount,
    required this.type,
    required this.note,
    required this.status,
    required this.t_date,
  });

  // Return object from JSON //
  factory TransactionModel.fromJson(var json) {
    return TransactionModel(
      id: json["id"],
      bill_id: json["bill_id"],
      amount: json["amount"],
      type: json["type"],
      note: json["note"],
      status: json["status"],
      t_date: json['t_date'] ?? DateTime.parse(json['t_date'] as String),
    );
  }
}
