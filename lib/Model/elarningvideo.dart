class ELearningVideo {
  String id;
  String category_id;
  String video_title;
  String video;

  ELearningVideo({
    required this.id,
    required this.category_id,
    required this.video_title,
    required this.video,
  });

  // Return object from JSON //
  factory ELearningVideo.fromJson(var json) {
    return ELearningVideo(
      id: json["id"],
      category_id: json["category_id"],
      video_title: json["video_title"],
      video: json["video"],
    );
  }
}
