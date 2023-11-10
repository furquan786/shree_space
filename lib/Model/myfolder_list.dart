class MyFolderListModel {
  String id;
  String folder_name;
  String user_id;
  String parent;
  String share_sel;
  bool selec;

  MyFolderListModel({
    required this.id,
    required this.folder_name,
    required this.user_id,
    required this.parent,
    required this.share_sel,
    required this.selec,
  });

  factory MyFolderListModel.fromJson(var json) {
    return MyFolderListModel(
      id: json["id"] ?? "",
      folder_name: json["folder_name"] ?? "",
      user_id: json["user_id"] ?? "",
      parent: json["parent"] ?? "",
      share_sel: json["share_sel"] ?? "",
      selec: json["selec"] ?? false,
    );
  }
}
