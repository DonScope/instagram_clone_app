import 'package:intl/intl.dart';

class PostModel {
  final String mediaUrl;
  final String? thumbnailUrl;
  final String? caption;
  final DateTime createdAt;
  final int likes;
  final int comments;

  PostModel({
    required this.mediaUrl,
    this.thumbnailUrl,
    this.caption,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    String dateString = json['created_at'] ?? ''; 
    DateTime parsedDate;

    try {
      parsedDate = DateFormat('dd-MM-yyyy').parse(dateString);
    } catch (e) {
      parsedDate = DateTime.now();
    }

    return PostModel(
      mediaUrl: json['media_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'], // Support thumbnail
      caption: json['caption'],
      createdAt: parsedDate,
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
    );
  }

 Map<String, dynamic> toJson() {
  return {
    'media_url': mediaUrl,
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) 'thumbnail_url': thumbnailUrl,
    'caption': caption,
    'created_at': DateFormat('dd-MM-yyyy').format(createdAt),
    'likes': likes,
    'comments': comments,
  };
}
}
