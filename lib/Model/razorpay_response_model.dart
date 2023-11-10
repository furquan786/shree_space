class RazorpayOrderResponse {
  String id;
  String entity;
  int amount;
  int amountPaid;
  int amountDue;
  String currency;
  String receipt;
  String offerId;
  String status;
  int attempts;
  int createdAt;

  RazorpayOrderResponse({
    required this.id,
    required this.entity,
    required this.amount,
    required this.amountPaid,
    required this.amountDue,
    required this.currency,
    required this.receipt,
    required this.offerId,
    required this.status,
    required this.attempts,
    required this.createdAt,
  });

  // Return object from JSON //
  factory RazorpayOrderResponse.fromJson(var json) {
    return RazorpayOrderResponse(
      id: json["id"],
      entity: json["entity"],
      amount: json["amount"],
      amountPaid: json["amount_paid"],
      amountDue: json["amount_due"],
      currency: json["currency"],
      receipt: json["receipt"],
      offerId: json["offer_id"],
      status: json["status"],
      attempts: json["attempts"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["entity"] = entity;
    data["amount"] = amount;
    data["amount_paid"] = amountPaid;
    data["amount_due"] = amountDue;
    data["currency"] = currency;
    data["receipt"] = receipt;
    data["offer_id"] = offerId;
    data["status"] = status;
    data["attempts"] = attempts;
    data["created_at"] = createdAt;
    return data;
  }
}
