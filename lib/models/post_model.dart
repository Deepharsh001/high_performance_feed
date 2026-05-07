class PostModel {
  final String id;
  final String thumbUrl;
  final String mobileUrl;
  final String rawUrl;

  int likeCount;

  bool isLiked;

  PostModel({
    required this.id,
    required this.thumbUrl,
    required this.mobileUrl,
    required this.rawUrl,
    required this.likeCount,
    required this.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      thumbUrl: json['media_thumb_url'],
      mobileUrl: json['media_mobile_url'],
      rawUrl: json['media_raw_url'],
      likeCount: json['like_count'] ?? 0,
      isLiked: false,
    );
  }
}