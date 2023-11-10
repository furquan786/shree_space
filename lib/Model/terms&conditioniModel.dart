class TermsAndConditions {
  String id;
  String terms;

  TermsAndConditions({
    required this.id,
    required this.terms,
  });

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) =>
      TermsAndConditions(
        id: json["id"],
        terms: json["terms"],
      );
}
