class PostModel {
  final String id;
  final String uId;
  final String mediaUrl;
  final String? caption;
  final DateTime createdAt;

  PostModel(
      {required this.id,
      required this.uId,
      required this.mediaUrl,
      required this.caption,
      required this.createdAt});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        id: json['id'],
        uId: json['uId'],
        mediaUrl: json['mediaUrl'],
        caption: json['caption'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uId': uId,
      'media_url': mediaUrl,
      'caption': caption,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
