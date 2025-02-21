class StoryModel {
  final String id;
  final String uId;
  final String? caption;
  final String mediaUrl;
  final bool isVideo;
  final DateTime createdAt;
  final DateTime expiresAt;
  StoryModel(
      {required this.id,
      required this.uId,
      required this.caption,
      required this.createdAt,
      required this.expiresAt,
      required this.mediaUrl,
      this.isVideo = false})
;

  StoryModel copyWith({
    String? id,
    String? userId,
    String? mediaUrl,
    DateTime? createdAt,
    bool? isVideo,
    DateTime? expiresAt,
  }) {
    return StoryModel(
        id: id ?? this.id,
        uId: uId ,
        caption: caption ?? this.caption,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        createdAt: createdAt ?? this.createdAt,
        expiresAt: expiresAt ?? this.expiresAt
     );
  }

factory StoryModel.fromJson(Map<String, dynamic> json) {
  return StoryModel(
    id: json['id'] as String,
    uId: json['uId'] as String,              // Fix: match Firestore field name
    mediaUrl: json['mediaUrl'] as String,
    caption: json['caption'] as String?,     // or use ?? "" for default
    createdAt: DateTime.parse(json['createdAt'] as String),
    isVideo: json['isVideo'] as bool? ?? false,
    expiresAt: DateTime.parse(json['expiresAt'] as String), // parse as DateTime
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uId': uId,
      'mediaUrl': mediaUrl,
      'caption': caption ?? "",
      'createdAt': createdAt.toIso8601String(),
      'isVideo': isVideo,
      'expiresAt': expiresAt.toIso8601String()
    };
  }
}
