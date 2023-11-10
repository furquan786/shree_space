class TermsListModel {
  String page_id;
  String page_type;
  String content;

  TermsListModel({
    required this.page_id,
    required this.page_type,
    required this.content,
  });

  factory TermsListModel.fromJson(var json) {
    return TermsListModel(
      page_id: json["page_id"],
      page_type: json["page_type"],
      content: json["content"],
    );
  }
}
