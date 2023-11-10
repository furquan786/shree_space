class BuysellWhatsappMsgModel {
  String id;
  String message;

  BuysellWhatsappMsgModel({
    required this.id,
    required this.message,
  });

  // Return object from JSON //
  factory BuysellWhatsappMsgModel.fromJson(var json) {
    return BuysellWhatsappMsgModel(
      id: json["id"],
      message: json["message"],
    );
  }
}
