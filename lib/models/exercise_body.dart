class ExerciseBody {
  String text, videoLink;
  bool isSpace, isVideo;

  ExerciseBody({
    required this.text,
    required this.videoLink,
    required this.isSpace,
    required this.isVideo,
  });

  factory ExerciseBody.fromJson(Map map) {
    // Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return ExerciseBody(
      text: map['text'] ?? '',
      videoLink: map['video_link'] ?? '',
      isSpace: map['is_space'],
      isVideo: map['is_video'],
    );
  }
}
